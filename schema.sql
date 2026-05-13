-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Supported communication channels
CREATE TYPE message_source AS ENUM (
    'whatsapp',
    'booking.com',
    'airbnb',
    'instagram',
    'direct'
);
-- why Enum instead of Varchar?
-- Prevent invalid values, self documenting schema , cleaner constraints

-- AI classified guest query categories
CREATE TYPE query_type AS ENUM (
    'pre_sales_availability',
    'pre_sales_pricing',
    'post_sales_checkin',
    'special_request',
    'complaint',
    'general_enquiry'
);

-- Enum 3 Message Direction
-- Needed because: inbound = guest → platform | outbound = platform → guest
CREATE TYPE message_direction AS ENUM (
    'inbound',
    'outbound'
);

-- Tracks AI/human workflow lifecycle.
CREATE TYPE message_status AS ENUM (
    'drafted',
    'reviewed',
    'auto_sent',
    'escalated'
);

-- Reservation_status For booking lifecycle tracking.
CREATE TYPE reservation_status AS ENUM (
    'pending',
    'confirmed',
    'cancelled',
    'completed'
);

-- Current state of a conversation
CREATE TYPE conversation_status AS ENUM (
    'open',
    'closed',
    'escalated'
);

CREATE TABLE guests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid();
    full_name VARCHAR(300) NOT NULL,
    email VARCHAR(300),
    phone VARCHAR(30),
    preferred_channel message_source,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Email not unique ?
-- Real world hospatilaty system often
-- lack emails, have shared emails on diff platform.

-- TABLE 2 Stores all properties/villas managed by the platform.

CREATE TABLE properties (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(300) NOT NULL,
    bedrooms INTEGER NOT NULL CHECK (bedrooms > 0),
    max_guests INTEGER NOT NULL CHECK (max_guests > 0),
    base_rate NUMERIC(10,2) NOT NULL CHECK (base_rate >= 0),
    caretaker_hours VARCHAR(300),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- wifi_password VARCHAR(300), can be included here but im keeping it out as its not always necessary
--Production systems may: encrypt, restrict access.
-- caretaer_hours can later have -> start_time ,end_time ,availability_schedule
CREATE INDEX idx_properties_property_code
ON properties(property_code);
CREATE INDEX idx_properties_location
ON properties(location);
-- why create a index?
-- PostgreSQL creates a special data structure internally (its easier to look up detail instead of searching 1000's of lines)
-- we can do (WHERE email = 'john@gmail.com') it will directly jump there "MUCH FASTER" insteada of scanning.
-- OPTIONAL yes but good practice

-- Stores booking/reservation information for guests
CREATE TABLE reservations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_reference VARCHAR(100) NOT NULL UNIQUE,
    guest_id UUID NOT NULL,
    property_id UUID NOT NULL,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    guest_count INTEGER NOT NULL CHECK (guest_count > 0),
    reservation_status reservation_status NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_reservation_guest
        FOREIGN KEY (guest_id)
        REFERENCES guests(id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_reservation_property
        FOREIGN KEY (property_id)
        REFERENCES properties(id)
        ON DELETE RESTRICT,
    CONSTRAINT check_checkout_after_checkin
        CHECK (check_out > check_in)
);
-- CHECK (check_out > check_in) Prevents impossible bookings.
-- ON DELETE RESTRICT
/*
for example if (GUEST : aayush)
Now if someone tries to delete Aayush from the guests table:
DELETE FROM guests
WHERE id = 'g1';
PostgreSQL says:
No. This guest is still connected to a reservation.

reservation_status
Tracks booking lifecycle.
Possible values:
pending
confirmed
cancelled
completed
*/
-- booking_reference lookup
CREATE INDEX idx_reservations_booking_reference
ON reservations(booking_reference);
/*
eg:
A guest calls support and says: "My booking reference is BK-2026-00125"
no instead of checkng thousands of rows manually it can jump directly to the reservation almost instantly.
*/
-- guest reservations
CREATE INDEX idx_reservations_guest_id
ON reservations(guest_id);
-- why? we can easiy use show "all bookings for Rahul"

CREATE INDEX idx_reservations_dates
ON reservations(check_in, check_out);
--useful to view "what bookings overlap these dates?"

CREATE TABLE conversation (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    guest_id UUID NOT NULL
    reservation_id UUID,
    property_id UUID NOT NULL,
    conversation_status conversation_status NOT NULL DEFAULT 'open',
    started_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_message_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_conversation_reservation
        FOREIGN KEY (guest_id)
        REFERENCES guests(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_conversation_reservation
        FOREIGN KEY (reservation_id)
        REFERENCES reservations(id)
        ON DELETE SET NULL

    CONSTRAINT fk_conversation_property
        FOREIGN KEY (property_id)
        REFERENCES properties(id)
        ON DELETE RESTRICT
);
/*
Why This Table Exists
A messaging platform cannot rely only on individual messages.
AI systems need:context,history.
Example:
Message 1:
"Is Villa B1 available?"

Message 2:
"What about early check-in?"

Message 3:
"Can you arrange airport pickup?"

Without conversations: these become isolated, AI loses context, workflow becomes messy.
So conversations act as: message threads
*/

CREATE INDEX idx_conversations_guest_id
ON conversations(guest_id);
CREATE INDEX idx_conversations_property_id
ON conversations(property_id);
CREATE INDEX idx_conversations_property_id
ON conversations(property_id);

-- Stores all inbound and outbound messages across channels
CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL,
    guest_id UUID NOT NULL,
    source message_source NOT NULL,
    direction message_direction NOT NULL,

    message_text TEXT NOT NULL,

    message_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    query_type query_type,

    confidence_score NUMERIC(3,2)
        CHECK (
            confidence_score IS NULL
            OR (confidence_score >= 0 AND confidence_score <= 1)
        ),

    ai_drafted_reply TEXT,
    final_sent_reply TEXT,

    message_status message_status NOT NULL DEFAULT 'drafted',
    recommended_action VARCHAR(50),
    reviewed_by_agent_id UUID,

    reviewed_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_message_conversation
        FOREIGN KEY (conversation_id)
        REFERENCES conversations(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_message_guest
        FOREIGN KEY (guest_id)
        REFERENCES guests(id)
        ON DELETE RESTRICT
);
/*
Why ON DELETE CASCADE Here?

If a conversation disappears:
its messages become meaningless.

So deleting conversation should remove:all associated messages
*/
CREATE INDEX idx_messages_conversation_id
ON messages(conversation_id);

CREATE INDEX idx_messages_timestamp
ON messages(message_timestamp DESC);
-- latest messages first


-- Stores internal support agents and operational staff data
CREATE TABLE agents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    role VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
/*
Useful for:
roles:
support,
manager,
admin,
maintenance,
escalation team.

Could later become ENUM.
*/


ALTER TABLE messages
ADD CONSTRAINT fk_message_review_agent
FOREIGN KEY (reviewed_by_agent_id)
REFERENCES agents(id)
ON DELETE SET NULL;

-- FUTURE IMPROVEMENT
--
-- If given more time, I would add a `message_events` audit table
-- to track the full lifecycle of every message interaction.
--
-- Example events:
-- - message_received
-- - ai_draft_generated
-- - agent_reviewed
-- - auto_sent
-- - escalated
-- - delivery_failed
--
-- This would create a complete event history for operational auditing,
-- debugging, analytics, escalation tracking, and future AI performance analysis.
--
-- I chose not to include it in the current schema to keep the design focused
-- and avoid unnecessary complexity for the assessment scope.


-- ----------------------------------------------------
-- HARDEST DESIGN DECISION
-- ----------------------------------------------------
--
-- The hardest design decision was structuring the
-- relationships between guests, reservations,
-- conversations, and messages while keeping the
-- schema flexible for real-world workflows.
--
-- The challenging part was deciding what should depend
-- on what, especially because conversations can exist
-- both before and after a reservation is created.
--
-- For example, a guest may enquire about pricing or
-- availability without making a booking, which meant
-- conversations could not strictly require a reservation.
--
-- Designing the schema in a normalized way while still
-- maintaining clear relationships between all entities
-- took the most thought, as the goal was to avoid
-- duplicated data while keeping the system scalable
-- and easy to query later.

