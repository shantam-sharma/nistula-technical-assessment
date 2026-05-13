import express from "express";
import { handleIncomingMessage } from "../controllers/message.controller.js";
import { validateMessagePayload } from "../middleware/validate.middleware.js";

const router = express.Router();

router.post(
    "/message",
    validateMessagePayload,
    handleIncomingMessage
);

export default router;
