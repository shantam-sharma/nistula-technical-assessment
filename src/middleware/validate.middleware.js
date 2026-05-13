const allowedSources = [
    "whatsapp",
    "booking_com",
    "airbnb",
    "instagram",
    "direct"
];

export const validateMessagePayload = (req, res, next) => {
    const{
        source,
        guest_name,
        message,
        timestamp,
        booking_ref,
        property_id
    } = req.body;

    // Check required fields
    if (
        !source ||
        !guest_name ||
        !message ||
        !timestamp ||
        !booking_ref ||
        !property_id
    ){
        return res.status(400).json({
            success: false,
            message: "All fields are required"
        });
    }

    // Validate source
    if (!allowedSources.includes(source)) {
        return res.status(400).json({
            success: false,
            message: "Invalid source type"
        });
    }
    next();
};
