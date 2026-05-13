export const calculateConfidenceScore = (normalizedMessage, draftedReply) => {
    let score = 0.75;
    const text = normalizedMessage.message_text.toLowerCase();

    // High-confidence straightforward queries
    if(normalizedMessage.query_type === "pre_sales_availability"){
        score += 0.10;
    }

    if(normalizedMessage.query_type === "post_sales_checkin"){
        score += 0.10;
    }

    // Pricing requires calculations
    if(normalizedMessage.query_type === "pre_sales_pricing"){
        score += 0.05;
    }

    // Complaints are sensitive
    if(normalizedMessage.query_type === "complaint"){
        score -= 0.35;
    }

    // Very short / vague messages
    if(text.length < 12){
        score -= 0.15;
    }

    // AI generated usable response
    if(draftedReply && draftedReply.length > 20){
        score += 0.05;
    }

    // Clamp between 0 and 1
    score = Math.max(0, Math.min(score, 1));

    return Number(score.toFixed(2));
};
