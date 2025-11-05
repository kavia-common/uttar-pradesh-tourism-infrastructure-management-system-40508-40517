# UPSTDC Infrastructure Backend

Spring Boot 3 backend serving REST APIs for infrastructure monitoring.

Run:
- Profiles: dev (default), prod
- Port: 5001

Environment variables (set via orchestrator, do not commit .env):
- DB_URL=jdbc:postgresql://<host>:<port>/<db>
- DB_USERNAME=<user>
- DB_PASSWORD=<password>
- SPRING_PROFILES_ACTIVE=dev|prod
- CORS_ALLOWED_ORIGINS=http://localhost:3000
- JWT_SECRET=<strong-long-random>
- JWT_EXPIRY_MINUTES=120

Flyway:
- Looks into classpath:db/migration and sibling ../infrastructure_database/db/migration for shared migrations.

Auth:
- POST /api/auth/register
- POST /api/auth/login

Docs:
- Swagger UI at /swagger
- Health at /actuator/health
