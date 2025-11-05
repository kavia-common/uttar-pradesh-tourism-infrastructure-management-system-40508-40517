# Frontend Integration Notes

- API Base URL:
  - Development: http://localhost:5001
  - Environment variable: NG_APP_API_BASE_URL (can be read and used to populate environment.ts during build).
  - Ensure src/environments/environment.ts includes `apiBaseUrl` pointing to the backend.
- Authentication:
  - Login endpoint: POST /api/auth/login with body { "username": "...", "password": "..." }
  - Response: { token, username, roles }
  - Store token securely (SSR-safe strategy recommended; for pure SPA dev, localStorage is acceptable).
  - Add Authorization header `Bearer <token>` on API requests after login.
- Routes/Guards:
  - Protect routes by checking presence of token and optionally decoding roles to enforce RBAC client-side.
- Projects Endpoints:
  - GET /api/projects (requires authenticated user) -> include Authorization header
  - POST /api/projects (requires ADMIN or MANAGER) -> include Authorization header
- References:
  - See INTEGRATION_README.md in the frontend workspace for a ready environment snippet.
