export const classifyQuery = (messageText) => {

    const text = messageText.toLowerCase();

    const hasAvailability =
        text.includes("available") ||
        text.includes("availability");

    const hasPricing =
        text.includes("rate") ||
        text.includes("price") ||
        text.includes("cost");

    // Combined query
    if (hasAvailability && hasPricing) {
        return "pre_sales_availability_pricing";
    }

    // Complaint
    if (
        text.includes("not working") ||
        text.includes("refund") ||
        text.includes("unacceptable") ||
        text.includes("problem")
    ) {
        return "complaint";
    }

    if (hasAvailability) {
        return "pre_sales_availability";
    }

    if (hasPricing) {
        return "pre_sales_pricing";
    }

    if (
        text.includes("check in") ||
        text.includes("wifi")
    ){
        return "post_sales_checkin";
    }
    if (
        text.includes("airport transfer") ||
        text.includes("early check-in")
    ) {
        return "special_request";
    }

    return "general_enquiry";
};
