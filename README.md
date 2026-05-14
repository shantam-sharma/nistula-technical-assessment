# Nistula Technical Assessment

## Overview
This project is a backend guest messaging workflow built for the Nistula Summer Technology Internship assessment.

The system receives guest messages from multiple communication channels, normalize them into a unified schema, classifies the guest intent, generate an AI-drafted reply using Claude sonnet 4, and returns a confidence score.

The implementation focuses on:
- clean backend architecture
- maintainable system design
- explainable service logic
- modular service seperation
- classification using predefined rules

## Features
- Unified webhook endpoint for guest messages
- Payload verification middleware
- Multi channel message normalization
- Claude Sonnet 4 AI integration
- Structured prompt engineering
- Confidence scoring system
- Operational action routing
- Modular Express.js architecture
- PostgreSQL schema design for unified message workflows

## Tech Stack
- Node.js
- Express.js
- Axios
- UUID
- dotenv
- PostgresSQL
- Claude Sonnet 4 API

## Project Structure
- Check "Docs/architecture.md" for detailed structure design

| Folder | Responsibility |
|---|---|
| controllers | Handles incoming API requests, manages the request flow, and sends the final response back to the client. |
| middleware | Validates request data, checks for missing fields, and prevents invalid requests from reaching the main logic. |
| routes | Defines all API endpoints and connects them to the correct controller functions. |
| services | Contains the core business logic such as message classification, confidence scoring, and Claude AI integration. |
| utils | Stores reusable helper functions like prompt generation, formatting utilities, and shared helper methods. |

## Folder Responsibilities

| Folder | Purpose |
|---|---|
| controllers | Handles incoming requests and manages the workflow |
| middleware | Validates requests and performs checks |
| routes | Defines API endpoints |
| services | Contains business logic and AI integration |
| utils | Stores helper functions and prompt utilities |

## System Flow
```
Incoming Request
        ↓
Payload Validation
        ↓
Message Normalization
        ↓
Query Classification
        ↓
Claude Prompt Generation
        ↓
Claude API Response
        ↓
Confidence Scoring
        ↓
Operational Action Decision
        ↓
JSON Response
```

## API Endpoint
POST /webhook/message

Accepts inbound guest messages from supported communication channels.

Supported channels:
whatsapp
booking_com
airbnb
instagram
direct

## Sample Request
```
{
  "source": "whatsapp",
  "guest_name": "Rahul Sharma",
  "message": "Is the villa available from April 20 to 24? What is the rate for 2 adults?",
  "timestamp": "2026-05-05T10:30:00Z",
  "booking_ref": "NIS-2024-0891",
  "property_id": "villa-b1"
}
```

## Sample Response
```
{
  "message_id": "8f3c4c2e-b8d1-4f53-96f4-a8ab57f09f11",
  "query_type": "pre_sales_availability",
  "drafted_reply": "Hi Rahul! Villa B1 is available from April 20–24. The base rate is INR 18,000 per night for up to 4 guests. Please let us know if you would like to proceed with the booking.\n\nNistula Hospitality Guest Support",
  "confidence_score": 0.9,
  "action": "auto_send"
}
```

## Query Classification Logic
The system uses rule-based keyword matching instead of AI-based intent detection.

This approach was chosen because it provides:

- predictable results
- faster processing
- easier debugging
- transparent decision-making
- simple and explainable routing logic

Supported Query Types
- pre_sales_availability
- pre_sales_pricing
- post_sales_checkin
- special_request
- complaint
- general_enquiry

| Guest Message | Query Type |
|---|---|
| "Is the villa available?" | pre_sales_availability |
| "What is the rate for 2 adults?" | pre_sales_pricing |
| "What is the WiFi password?" | post_sales_checkin |
| "Can I get airport pickup?" | special_request |
| "The AC is not working." | complaint |

Complaint messages are checked first to reduce operational risk.

## Confidence Scoring Logic
The system generates a confidence score between 0 and 1 for every AI-generated response.

The score is calculated using fixed rules based on:

- query complexity
- operational risk
- message clarity
- AI response quality

Scoring Logic
The system starts with a base confidence score of 0.75 because:

- The request payload is already validated
- Message normalization follow fixed rules
- Prompts are structured and controlled
- Claude only receives predefine property information

The score is then increased or decreased based on different condition.

Confidence Adjustments

| Condition | Score Change |
|---|---|
| availability query | +0.10 |
| check-in query | +0.10 |
| pricing query | +0.05 |
| complaint detected | -0.35 |
| vague or very short message | -0.15 |
| valid AI response generated | +0.05 |

The final confidence score is limited between 0 and 1.

## Action Routing Logic
Operational actions are determined using the confidence score and query category.

| Condition | Action |
|---|---|
| confidence > 0.85 | auto_send |
| confidence between 0.60 – 0.85 | agent_review |
| confidence < 0.60 | escalate |
| complaint query | escalate |

Complaint related messages are always escalated due to higher operational sensitivity.

## Claude AI Integration
The system connects with Claude Sonnet 4 using the Anthropic Messages API.

The prompt system:

adds property details to the AI request
reduces incorrect or made-up responses
keeps replies professional and guest-friendly
handles complaints carefully
generates responses ready to send to guests

The AI functionality is kept in a separate service to maintain clean and organized code.

## Environment Variables
PORT	        3000
CLAUDE_API_KEY	Anthropic API key

## Testing
The system was tested using multiple payload categories:

1. Availability Query
"Is Villa B1 available from April 20–24?"
2. Pricing Query
"What is the rate for 2 adults for 3 nights?"
3. Complaint Query
"The AC is not working and I am unhappy with the stay."

## Design Decisions
1. Deterministic Query Classification

Keyword-based classification was intentionally chosen over AI classification to maintain predictable routing behavior and operational transparency.

2. Modular Service Sepration

The application separates:

routing
validation
normalization
classification
AI orchestration
confidence scoring

This improves maintainability and simplifies future scaling.

3. Prompt Isolation

Prompt generation logic is isolated from API communication to make prompt iteration safer and easier.

4. Explainable Confidence Scoring

The confidence system uses fixed rules instead of unclear AI-generated confidence scores.

This makes the routing process:
easy to understand
easy to adjust
easy to track and review

5. Operationally Safe Complaint Handling

Complaint-related queries are automatically escalated to reduce automation risk during sensitive guest interactions.

## Future Improvements

Given additional development time
- I would think of a more advanced intent classification logic capable of handling more complex conversations beyond simple keyword matching.
- Retry layer for AI failures.
- PostgreSQL layer — I did not partially integrate the database because it would also require implementing migration logic, which could lead to a more unstable codebase within the assessment timeframe.
- Centralized logging: Keep all application logs and error logs in one place to make debugging and monitoring easier.
- Rate limiting: Prevent excessive API requests and protect the system from spam or abuse. I mention this because I ran out of API usage while testing this project, so it was a good lesson for future builds.
- Implement a system to maintain a complete history of all guest messages, AI responses, edits, and actions taken by the platform.
- Analytics layer: Track repeated guest issues and generate insights to identify operational problems across properties.
- Agent escalation workflow: Automatically notify human agents when complaints, low-confidence replies, or urgent issues are detected.
- Allow the system to remember previous guest messages so replies can remain context-aware across conversations.
- Multi-property context injection: Dynamically load different property details based on the property ID instead of using fixed mock data.

