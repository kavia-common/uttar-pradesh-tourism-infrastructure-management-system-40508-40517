# UPSTDC Infrastructure Backend

Spring Boot 3 backend serving REST APIs for infrastructure monitoring.

Run:
- Profiles: dev (default), prod
- Port: 5001

Environment variables (set via orchestrator, do not commit .env):
- POSTGRES_HOST, POSTGRES_PORT, POSTGRES_DB, POSTGRES_USER, POSTGRES_PASSWORD
- or DB_URL=jdbc:postgresql://<host>:<port>/<db> (takes precedence if set)
- DB_USERNAME=<user> (when using DB_URL only)
- DB_PASSWORD=<password> (when using DB_URL only)
- SPRING_PROFILES_ACTIVE=dev|prod
- CORS_ALLOWED_ORIGINS=http://localhost:3000
- JWT_SECRET=<strong-long-random, >=32 bytes>
- JWT_EXPIRY_MINUTES=120

Dev specifics:
- server.port=5001
- spring.jpa.show-sql=true for development

Database:
- Uses PostgreSQL with JDBC driver.
- In dev/prod, provide DB_URL or POSTGRES_* env vars. The app listens on port 5001.

Flyway:
- Enabled by default.
- Locations: classpath:db/migration and sibling ../infrastructure_database/db/migration for shared migrations.
- Ensure the infrastructure_database container repo exists adjacent to this backend for filesystem migrations to be picked up:
  - Backend path: uttar-pradesh-tourism-infrastructure-management-system-40508-40517/infrastructure_backend
  - Database path: uttar-pradesh-tourism-infrastructure-management-system-40508-40519/infrastructure_database
  - Shared migrations directory expected at: ../infrastructure_database/db/migration

Auth:
- POST /api/auth/register
- POST /api/auth/login
- JWT is returned in `token` field; include it as `Authorization: Bearer <token>` in subsequent requests.

CORS:
- CORS allows frontend origin(s) configured via `CORS_ALLOWED_ORIGINS` (comma-separated). Default is http://localhost:3000.

Docs:
- Swagger UI at /swagger
- Health at /actuator/health

Frontend integration:
- API base URL: http://localhost:5001 (dev) or your preview host.
- Login form: POST /api/auth/login with body { "username": "...", "password": "..." }.
- Store JWT token securely (e.g., in memory with SSR-safe guards or local storage for non-SSR deployments).
- Include Authorization header for protected routes.
- Projects APIs (examples):
  - GET /api/projects
  - POST /api/projects

Quickstart (dev):
1) Ensure PostgreSQL is reachable and export:
   - POSTGRES_HOST=localhost
   - POSTGRES_PORT=5432
   - POSTGRES_DB=upstdc_dev
   - POSTGRES_USER=postgres
   - POSTGRES_PASSWORD=postgres
   - SPRING_PROFILES_ACTIVE=dev
   - JWT_SECRET=<min 32 bytes secret, e.g., use `openssl rand -hex 32`>
2) From infrastructure_backend: mvn spring-boot:run
3) Open http://localhost:5001/swagger
4) Default dev admin is seeded (username: admin, password: admin123). Change in prod.
