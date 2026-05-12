nistula-technical-assessment/
│
├── README.md
├── schema.sql
├── thinking.md
├── .env.example
├── .gitignore
├── package.json
├── package-lock.json
│
├── src/
│   │
│   ├── server.js
│   ├── app.js
│   │
│   ├── routes/
│   │   └── messageRoutes.js
│   │
│   ├── controllers/
│   │   └── messageController.js
│   │
│   ├── services/
│   │   ├── aiService.js
│   │   ├── normalizationService.js
│   │   ├── classificationService.js
│   │   └── confidenceService.js
│   │
│   ├── prompts/
│   │   └── claudePrompt.js
│   │
│   ├── middleware/
│   │   ├── validateRequest.js
│   │   └── errorHandler.js
│   │
│   ├── utils/
│   │   ├── actionDecider.js
│   │   ├── generateMessageId.js
│   │   └── logger.js
│   │
│   ├── constants/
│   │   ├── propertyContext.js
│   │   ├── queryTypes.js
│   │   └── actionTypes.js
│   │
│   └── tests/
│       ├── payloads/
│       │   ├── availability.json
│       │   ├── pricing.json
│       │   ├── complaint.json
│       │   └── specialRequest.json
│       │
│       └── api.test.js
│
└── docs/
    ├── architecture.md
    └── api-examples.md
