import axios from "axios";

export const generateClaudeReply = async (prompt) => {
    try {
        const response = await axios.post(
            "https://api.anthropic.com/v1/messages",
            {
                model: "claude-sonnet-4-20250514",

                max_tokens: 300,

                messages: [
                    {
                        role: "user",
                        content: prompt
                    }
                ]
            },
            {
                headers: {
                    "x-api-key": process.env.CLAUDE_API_KEY,
                    "anthropic-version": "2023-06-01",
                    "content-type": "application/json"
                }
            }
        );

        const message = response.data;
        const textBlock = message.content.find(
            (block) => block.type === "text"
        );

        return textBlock?.text || "No response generated";

    } catch (error) {
        console.error(
            "Claude API Error:",
            error.response?.data || error.message
        );
        throw new Error("Failed to generate AI reply");
    }
};
