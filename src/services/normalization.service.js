import { v4 as uuidv4 } from "uuid";
import { classifyQuery } from "./classifier.service.js";

export const normalizeMessage = (payload) => {
    const queryType = classifyQuery(payload.message);
    return {
        message_id: uuidv4(),

        source: payload.source,

        guest_name: payload.guest_name,

        message_text: payload.message,

        timestamp: payload.timestamp,

        booking_ref: payload.booking_ref,

        property_id: payload.property_id,

        query_type: queryType
    };
};
