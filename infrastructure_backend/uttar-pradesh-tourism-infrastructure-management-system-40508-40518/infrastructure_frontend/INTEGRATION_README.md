# Infrastructure Frontend Integration Guide

Backend
- Base URL (dev): http://localhost:5001
- Set NG_APP_API_BASE_URL to override during builds if your tooling supports it.

Environment configuration
- Ensure src/environments/environment.ts (dev) points to the backend base URL.
- Example:
  export const environment = {
    production: false,
    apiBaseUrl: 'http://localhost:5001'
  };

Authentication
- Login: POST /api/auth/login with body { "username": string, "password": string }
- Response: { token, username, roles }
- Store token (e.g., localStorage.getItem('jwt')) and include Authorization: Bearer <token> on protected requests.

Projects APIs
- GET /api/projects: requires authentication
- POST /api/projects: requires ADMIN or MANAGER
- Include Authorization header with Bearer token.

Route guards
- Protect routes by checking presence of a valid token; optionally decode roles client-side for RBAC.

Notes
- CORS: backend default allows http://localhost:3000; adjust CORS_ALLOWED_ORIGINS as needed.
- Swagger: http://localhost:5001/swagger
