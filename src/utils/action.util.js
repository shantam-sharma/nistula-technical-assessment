export const determineAction = (queryType,confidenceScore) => {
    if(queryType === "complaint"){
        return "escalate";
    }
    if(confidenceScore > 0.85){
        return "auto_send";
    }
    if(confidenceScore >= 0.60 && confidenceScore <= 0.85){
        return "agent_review";
    }
    return "escalate";
};
