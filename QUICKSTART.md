# SpendShare Quick Start Guide

Get SpendShare running on your local machine in under 10 minutes!

## Prerequisites

Before you begin, make sure you have:

- **Docker Desktop** installed and running ([Download](https://www.docker.com/products/docker-desktop))
- **Git** installed ([Download](https://git-scm.com/downloads))

That's it! Docker will handle the rest.

## Quick Start with Docker (Recommended)

### 1. Clone the Repository

```bash
git clone https://github.com/gohbi/SpendShare.git
cd SpendShare
```

### 2. Set Up Environment Variables

```bash
# Copy the example environment file
cp .env.example .env

# The default values work for local development
# You can edit .env if you want to customize settings
```

### 3. Start the Services

```bash
# Start all infrastructure services
docker-compose up -d

# Wait for services to be ready (about 30 seconds)
docker-compose ps
```

### 4. Access the Services

Once everything is running:

- **MailHog** (Email testing): http://localhost:8025
- **MinIO Console** (File storage): http://localhost:9001
  - Username: `minioadmin`
  - Password: `minioadmin`
- **PostgreSQL**: `localhost:5432`
- **MongoDB**: `localhost:27017`
- **Redis**: `localhost:6379`

### 5. Stop the Services

```bash
# Stop all services
docker-compose down

# Stop and remove all data
docker-compose down -v
```

## Development Setup (For Contributors)

If you want to contribute to SpendShare or run services locally:

### Prerequisites

- Node.js 18+ LTS ([Download](https://nodejs.org/))
- Python 3.10+ ([Download](https://www.python.org/downloads/))
- All the Docker prerequisites above

### 1. Start Infrastructure

```bash
# Start only the infrastructure services (databases, cache, etc.)
docker-compose up -d postgres mongodb redis minio mailhog
```

### 2. Set Up Backend Service

```bash
# Navigate to a backend service (example: auth-service)
cd backend/auth-service

# Install dependencies
npm install

# Run database migrations
npm run migrate

# Start in development mode with hot reload
npm run dev
```

The service will be available at http://localhost:3001 (or the port defined in .env)

### 3. Set Up Frontend

```bash
# Navigate to the web frontend
cd frontend/web

# Install dependencies
npm install

# Start development server
npm run dev
```

The web app will be available at http://localhost:3000

### 4. Set Up OCR Service

```bash
# Navigate to OCR service
cd ocr-service

# Create virtual environment
python -m venv venv

# Activate virtual environment
# On macOS/Linux:
source venv/bin/activate
# On Windows:
# venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Install Tesseract (if not already installed)
# macOS:
brew install tesseract
# Ubuntu:
# sudo apt-get install tesseract-ocr

# Start the service
uvicorn main:app --reload --port 8000
```

The OCR service will be available at http://localhost:8000

## Verify Installation

### Check Service Health

```bash
# Check which containers are running
docker-compose ps

# View logs
docker-compose logs -f

# Check specific service logs
docker-compose logs postgres
docker-compose logs redis
```

### Test Database Connection

```bash
# Connect to PostgreSQL
docker exec -it spendshare-postgres psql -U spendshare -d spendshare

# Inside psql, try:
# \dt          -- List tables
# \l           -- List databases
# \q           -- Quit

# Connect to MongoDB
docker exec -it spendshare-mongodb mongosh -u spendshare -p spendshare_dev_password

# Inside mongosh, try:
# show dbs     -- List databases
# exit         -- Quit

# Connect to Redis
docker exec -it spendshare-redis redis-cli -a spendshare_dev_password

# Inside redis-cli, try:
# PING         -- Should return PONG
# quit         -- Quit
```

## Common Commands

### Docker

```bash
# Start all services
docker-compose up -d

# Start specific services
docker-compose up -d postgres redis

# View logs in real-time
docker-compose logs -f

# Restart a service
docker-compose restart postgres

# Stop all services
docker-compose down

# Remove all data and volumes
docker-compose down -v

# Rebuild all images
docker-compose build

# Pull latest images
docker-compose pull
```

### npm/Node.js

```bash
# Install dependencies
npm install

# Run in development mode
npm run dev

# Build for production
npm run build

# Run tests
npm test

# Run linter
npm run lint

# Fix linting issues
npm run lint:fix
```

### Python

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
source venv/bin/activate  # macOS/Linux
venv\Scripts\activate     # Windows

# Install dependencies
pip install -r requirements.txt

# Run the service
uvicorn main:app --reload

# Run tests
pytest

# Deactivate virtual environment
deactivate
```

## Project Structure

```
SpendShare/
├── backend/                 # Backend microservices
│   ├── auth-service/       # Authentication & authorization
│   ├── user-service/       # User management
│   ├── group-service/      # Group management
│   ├── expense-service/    # Expense tracking
│   ├── chat-service/       # Real-time chat
│   ├── notification-service/
│   ├── settlement-service/
│   └── payment-service/
├── ocr-service/            # Computer vision & OCR
├── frontend/
│   ├── web/               # React web application
│   └── mobile/            # React Native mobile app
├── infrastructure/         # DevOps & infrastructure
│   ├── docker/            # Docker configurations
│   ├── kubernetes/        # K8s manifests
│   └── terraform/         # Infrastructure as code
├── docs/                   # Additional documentation
├── scripts/               # Utility scripts
└── tests/                 # End-to-end tests
```

## Next Steps

### For Users
1. ✅ Start the services with Docker
2. 📖 Read the [README.md](./README.md) for an overview
3. 🎯 Try creating your first expense
4. 📸 Test the receipt scanning feature

### For Contributors
1. ✅ Set up the development environment
2. 📖 Read the [CONTRIBUTING.md](./CONTRIBUTING.md) guide
3. 🏗️ Study the [ARCHITECTURE.md](./ARCHITECTURE.md)
4. 🗺️ Check the [ROADMAP.md](./ROADMAP.md) for upcoming features
5. 🐛 Find an issue to work on or suggest a feature
6. 💻 Write code and submit a pull request!

## Troubleshooting

### Port Already in Use

If you get an error about ports being in use:

```bash
# Find what's using the port (example: port 5432)
lsof -i :5432

# Kill the process
kill -9 <PID>

# Or change the port in docker-compose.yml
```

### Docker Issues

```bash
# Restart Docker Desktop
# Then clean up:
docker system prune -a
docker volume prune

# Try again
docker-compose up -d
```

### Services Not Starting

```bash
# Check the logs
docker-compose logs -f

# Verify Docker is running
docker ps

# Check available disk space
df -h

# Check available memory
free -h  # Linux
vm_stat  # macOS
```

### Database Connection Failed

```bash
# Make sure the database container is running
docker-compose ps

# Check the database logs
docker-compose logs postgres

# Verify connection settings in .env
cat .env | grep DB_

# Try restarting the database
docker-compose restart postgres
```

### Module Not Found Errors

```bash
# Backend
cd backend/auth-service
rm -rf node_modules package-lock.json
npm install

# Frontend
cd frontend/web
rm -rf node_modules package-lock.json
npm install

# Python
cd ocr-service
rm -rf venv
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Getting Help

- 📖 **Documentation**: Check the `/docs` folder
- 💬 **Discussions**: [GitHub Discussions](https://github.com/gohbi/SpendShare/discussions)
- 🐛 **Issues**: [GitHub Issues](https://github.com/gohbi/SpendShare/issues)
- 📧 **Email**: support@spendshare.com

## Resources

- [Full Setup Guide](./SETUP.md) - Detailed setup instructions
- [Architecture Overview](./ARCHITECTURE.md) - System design
- [Technology Stack](./TECH_STACK.md) - Technologies used
- [Roadmap](./ROADMAP.md) - Future plans
- [Contributing Guide](./CONTRIBUTING.md) - How to contribute

---

**Happy coding! 🚀**

If you encounter any issues or have questions, don't hesitate to open an issue or reach out to the community.
