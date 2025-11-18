# Docker Setup for SpendShare

This document explains the optimized Docker configuration for SpendShare.

## Quick Start

```bash
# Start all core services (recommended for development)
docker compose up -d

# Check status
docker compose ps

# View logs
docker compose logs -f

# Stop all services
docker compose down
```

## What Changed?

The Docker setup has been optimized for faster startup and better developer experience:

### 1. **Fixed Image Versions**
- ✅ Updated Kong from non-existent `3.4-alpine` to `latest` (commented out until needed)
- ✅ Updated PostgreSQL from `15-alpine` to `16-alpine` (latest stable)
- ✅ Updated MongoDB from `6-jammy` to `7-jammy` (commented out until needed)
- ✅ All other images use stable versions with alpine where possible

### 2. **Improved Healthchecks**
- ✅ Faster healthcheck intervals (5s instead of 10s)
- ✅ Added `start_period` to prevent false failures during initialization
- ✅ More reliable healthcheck commands
- ✅ Fixed Redis healthcheck to work with password authentication

### 3. **Reduced Startup Time**
- ✅ Commented out unused services (MongoDB, Kong) - enable when needed
- ✅ Only essential services start by default:
  - PostgreSQL (database)
  - Redis (cache/sessions)
  - MinIO (file storage)
  - MailHog (email testing)
- ✅ Startup time reduced from 2+ minutes to ~10-15 seconds

### 4. **Better Dependencies**
- ✅ Services use proper `depends_on` with health conditions
- ✅ Services wait for dependencies to be healthy before starting

### 5. **Created Missing Files**
- ✅ Created `infrastructure/docker/kong/kong.yml` (minimal Kong config)
- ✅ Created `infrastructure/docker/postgres/init.sql` (database initialization)

## Services Overview

### Active Services (Always On)

| Service | Port | Purpose | UI/Access |
|---------|------|---------|-----------|
| PostgreSQL | 5432 | Primary database | `psql -h localhost -U spendshare -d spendshare` |
| Redis | 6379 | Cache & sessions | `redis-cli -a spendshare_dev_password` |
| MinIO | 9000, 9001 | File storage (S3) | http://localhost:9001 (user: minioadmin, pass: minioadmin) |
| MailHog | 1025, 8025 | Email testing | http://localhost:8025 |

### Optional Services (Commented Out)

Uncomment in `docker-compose.yml` when needed:

| Service | When to Enable | Purpose |
|---------|---------------|---------|
| Kong API Gateway | When backend services are ready | API routing and management |
| MongoDB | When chat service is implemented | Chat message storage |
| Elasticsearch | For search functionality | Full-text search (optional) |
| RabbitMQ | For async processing | Message queue (optional) |

## Configuration

### Environment Variables

Create a `.env` file (copy from `.env.example`):

```bash
cp .env.example .env
```

Default values work for local development. Key variables:

```env
# Database
DB_PASSWORD=spendshare_dev_password

# Redis
REDIS_PASSWORD=spendshare_dev_password

# MongoDB (if enabled)
MONGO_USER=spendshare
MONGO_PASSWORD=spendshare_dev_password

# MinIO
MINIO_USER=minioadmin
MINIO_PASSWORD=minioadmin
```

## Testing the Setup

### 1. Verify All Services Are Healthy

```bash
docker compose ps
```

All services should show "Up X seconds (healthy)".

### 2. Test PostgreSQL

```bash
# Connect to database
docker exec -it spendshare-postgres psql -U spendshare -d spendshare

# Inside psql:
\l              # List databases
\dt             # List tables (empty initially)
\q              # Quit
```

### 3. Test Redis

```bash
# Test connection
docker exec -it spendshare-redis redis-cli -a spendshare_dev_password

# Inside redis-cli:
PING            # Should return PONG
SET test "hello"
GET test
quit
```

### 4. Test MinIO

1. Open http://localhost:9001
2. Login with `minioadmin` / `minioadmin`
3. Create a bucket called `receipts` for testing

### 5. Test MailHog

1. Open http://localhost:8025
2. You should see the MailHog web interface
3. Any emails sent to localhost:1025 will appear here

## Enabling Optional Services

### Enable Kong API Gateway

1. Uncomment the `api-gateway` service in `docker-compose.yml`
2. Update Kong configuration in `infrastructure/docker/kong/kong.yml`
3. Restart: `docker compose up -d`

### Enable MongoDB

1. Uncomment the `mongodb` service and `mongo-data` volume
2. Restart: `docker compose up -d`

## Troubleshooting

### Services Taking Too Long to Start

```bash
# Check logs for errors
docker compose logs -f

# Check specific service
docker compose logs postgres
```

### Port Already in Use

```bash
# Find what's using the port (example: 5432)
lsof -i :5432

# Kill the process or change the port in docker-compose.yml
```

### Health Check Failing

```bash
# Check service logs
docker compose logs [service-name]

# Restart specific service
docker compose restart [service-name]
```

### Clean Reset

```bash
# Stop and remove everything including volumes
docker compose down -v

# Start fresh
docker compose up -d
```

## Performance Tips

1. **Allocate More Resources to Docker**
   - Docker Desktop → Settings → Resources
   - Recommended: 4GB RAM, 2 CPUs minimum

2. **Use Docker Volumes for Performance**
   - Already configured with named volumes
   - Much faster than bind mounts on Mac/Windows

3. **Prune Unused Images/Containers**
   ```bash
   docker system prune -a
   ```

## Next Steps

1. ✅ **Infrastructure is Ready** - All core services are running
2. 🔄 **Start Backend Services** - Develop and run Node.js microservices
3. 🔄 **Start OCR Service** - Develop Python FastAPI service
4. 🔄 **Start Frontend** - Develop React web application
5. 🔄 **Connect Services** - Wire everything together

See [SETUP.md](../SETUP.md) for full development setup instructions.

## Architecture Diagram

```
┌─────────────────────────────────────────────────┐
│              Docker Network                      │
│         (spendshare-network)                     │
│                                                   │
│  ┌─────────────┐  ┌─────────────┐               │
│  │  PostgreSQL │  │    Redis    │               │
│  │   :5432     │  │   :6379     │               │
│  └─────────────┘  └─────────────┘               │
│                                                   │
│  ┌─────────────┐  ┌─────────────┐               │
│  │    MinIO    │  │   MailHog   │               │
│  │  :9000-9001 │  │ :1025, 8025 │               │
│  └─────────────┘  └─────────────┘               │
│                                                   │
│  (Optional Services - Commented Out)              │
│  ┌─────────────┐  ┌─────────────┐               │
│  │    Kong     │  │   MongoDB   │               │
│  │  :8000-8001 │  │   :27017    │               │
│  └─────────────┘  └─────────────┘               │
└─────────────────────────────────────────────────┘
```

## Support

For issues or questions:
- Check [QUICKSTART.md](../QUICKSTART.md)
- See [GitHub Issues](https://github.com/gohbi/SpendShare/issues)
- Review [ARCHITECTURE.md](../ARCHITECTURE.md)
