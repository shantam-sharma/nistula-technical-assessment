import { normalizeMessage }
from "../services/normalization.service.js";

import { buildClaudePrompt }
from "../utils/prompts.js";

import { generateClaudeReply }
from "../services/claude.service.js";

import { calculateConfidenceScore }
from "../services/confidence.service.js";

import { determineAction }
from "../utils/action.util.js";

export const handleIncomingMessage = async (req, res) => {
    try {
        // Normalize message
        const normalizedMessage = normalizeMessage(req.body);

        // Build prompt
        const prompt = buildClaudePrompt(normalizedMessage);

        // Generate AI reply
        const draftedReply = await generateClaudeReply(prompt);

        // Confidence scoring
        const confidenceScore =
            calculateConfidenceScore(
                normalizedMessage,
                draftedReply
            );

        // Determine action
        const action = determineAction(
            normalizedMessage.query_type,
            confidenceScore
        );

        return res.status(200).json({
            message_id: normalizedMessage.message_id,
            query_type: normalizedMessage.query_type,
            drafted_reply: draftedReply,
            confidence_score: confidenceScore,
            action
        });
    }catch(error){
        console.error(error);
        return res.status(500).json({
            success: false,
            message:
                error.message ||
                "Internal server error"
        });
    }
};
