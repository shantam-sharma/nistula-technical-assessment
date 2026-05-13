nistula-technical-assessment/
│
├── README.md
├── schema.sql
├── thinking.md
├── .env.example
├── package.json
├── .gitignore
│
├── src/
│   │
│   ├── server.js
│   │
│   ├── routes/
│   │   └── webhook.routes.js
│   │
│   ├── controllers/
│   │   └── message.controller.js
│   │
│   ├── services/
│   │   ├── claude.service.js
│   │   ├── classifier.service.js
│   │   ├── confidence.service.js
│   │   └── normalization.service.js
│   │
│   ├── utils/
│   │   ├── action.util.js
│   │   └── prompts.js
│   │
│   └── middleware/
│       └── error.middleware.js
