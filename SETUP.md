# SpendShare Development Setup Guide

## Prerequisites

### Required Software

#### General
- **Git**: Version control
  - Install: https://git-scm.com/downloads
- **Docker Desktop**: Container runtime
  - Install: https://www.docker.com/products/docker-desktop
- **Node.js 18+ LTS**: JavaScript runtime
  - Install: https://nodejs.org/ or use nvm
- **Python 3.10+**: For OCR service
  - Install: https://www.python.org/downloads/

#### Optional but Recommended
- **Visual Studio Code**: Code editor
  - Install: https://code.visualstudio.com/
- **Postman**: API testing
  - Install: https://www.postman.com/downloads/
- **Docker Compose**: (Usually included with Docker Desktop)

### Version Managers (Recommended)

#### Node.js Version Manager (nvm)
```bash
# macOS/Linux
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Then install Node.js
nvm install 18
nvm use 18
```

#### Python Version Manager (pyenv)
```bash
# macOS
brew install pyenv

# Then install Python
pyenv install 3.10.0
pyenv global 3.10.0
```

---

## Project Setup

### 1. Clone Repository

```bash
git clone https://github.com/gohbi/SpendShare.git
cd SpendShare
```

### 2. Project Structure

Create the following directory structure:

```
SpendShare/
├── backend/
│   ├── auth-service/
│   ├── user-service/
│   ├── group-service/
│   ├── expense-service/
│   ├── chat-service/
│   ├── notification-service/
│   ├── settlement-service/
│   ├── payment-service/
│   └── shared/
├── ocr-service/
├── frontend/
│   ├── web/
│   └── mobile/
├── infrastructure/
│   ├── docker/
│   ├── kubernetes/
│   └── terraform/
├── docs/
├── scripts/
└── tests/
```

---

## Backend Setup

### 1. Initialize Services

```bash
# Create backend directory
mkdir -p backend/auth-service
cd backend/auth-service

# Initialize Node.js project
npm init -y

# Install dependencies
npm install express typescript @types/express @types/node
npm install dotenv jsonwebtoken bcrypt passport passport-jwt
npm install pg sequelize redis ioredis
npm install winston joi cors helmet
npm install --save-dev ts-node nodemon jest @types/jest

# Initialize TypeScript
npx tsc --init
```

### 2. TypeScript Configuration

Create `tsconfig.json`:

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "moduleResolution": "node",
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

### 3. Environment Variables

Create `.env.example`:

```env
# Server
NODE_ENV=development
PORT=3000

# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=spendshare
DB_USER=spendshare
DB_PASSWORD=your_password

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# JWT
JWT_SECRET=your_jwt_secret_key_change_in_production
JWT_EXPIRES_IN=7d
REFRESH_TOKEN_SECRET=your_refresh_token_secret
REFRESH_TOKEN_EXPIRES_IN=30d

# OAuth (optional)
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
FACEBOOK_CLIENT_ID=
FACEBOOK_CLIENT_SECRET=

# Email
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=
SMTP_PASSWORD=
EMAIL_FROM=noreply@spendshare.com

# Storage
S3_BUCKET=spendshare-receipts
S3_REGION=us-east-1
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=

# Or use MinIO for local development
MINIO_ENDPOINT=localhost:9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadmin
MINIO_USE_SSL=false
```

### 4. Database Setup

```bash
# Install PostgreSQL (if not using Docker)
# macOS
brew install postgresql@15
brew services start postgresql@15

# Create database
createdb spendshare

# Or use Docker
docker run --name spendshare-postgres \
  -e POSTGRES_DB=spendshare \
  -e POSTGRES_USER=spendshare \
  -e POSTGRES_PASSWORD=password \
  -p 5432:5432 \
  -d postgres:15
```

### 5. Redis Setup

```bash
# Install Redis (if not using Docker)
# macOS
brew install redis
brew services start redis

# Or use Docker
docker run --name spendshare-redis \
  -p 6379:6379 \
  -d redis:7-alpine
```

---

## OCR Service Setup

### 1. Initialize Python Project

```bash
cd ocr-service

# Create virtual environment
python -m venv venv

# Activate virtual environment
# macOS/Linux
source venv/bin/activate
# Windows
venv\Scripts\activate

# Install dependencies
pip install fastapi uvicorn python-multipart
pip install pillow opencv-python numpy
pip install pytesseract
pip install celery redis
pip install boto3  # for S3
pip install pydantic python-dotenv
```

### 2. Install Tesseract

```bash
# macOS
brew install tesseract

# Ubuntu/Debian
sudo apt-get install tesseract-ocr

# Windows
# Download from: https://github.com/UB-Mannheim/tesseract/wiki
```

### 3. Create Requirements File

Create `requirements.txt`:

```txt
fastapi==0.104.1
uvicorn[standard]==0.24.0
python-multipart==0.0.6
pillow==10.1.0
opencv-python==4.8.1.78
numpy==1.26.2
pytesseract==0.3.10
celery==5.3.4
redis==5.0.1
boto3==1.29.7
pydantic==2.5.0
python-dotenv==1.0.0
```

---

## Frontend Web Setup

### 1. Create React App with Vite

```bash
cd frontend

# Create Vite project
npm create vite@latest web -- --template react-ts

cd web

# Install dependencies
npm install

# Install additional packages
npm install @reduxjs/toolkit react-redux react-router-dom
npm install @mui/material @emotion/react @emotion/styled @mui/icons-material
npm install axios socket.io-client
npm install date-fns formik yup
npm install recharts
npm install react-dropzone
```

### 2. Install Dev Dependencies

```bash
npm install --save-dev @types/node
npm install --save-dev eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin
npm install --save-dev prettier eslint-config-prettier eslint-plugin-prettier
```

### 3. ESLint Configuration

Create `.eslintrc.js`:

```javascript
module.exports = {
  parser: '@typescript-eslint/parser',
  extends: [
    'eslint:recommended',
    'plugin:react/recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:react-hooks/recommended',
    'prettier'
  ],
  plugins: ['react', '@typescript-eslint', 'prettier'],
  rules: {
    'prettier/prettier': 'error',
    'react/react-in-jsx-scope': 'off',
    '@typescript-eslint/explicit-module-boundary-types': 'off'
  },
  settings: {
    react: {
      version: 'detect'
    }
  }
};
```

### 4. Prettier Configuration

Create `.prettierrc`:

```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false
}
```

---

## Mobile App Setup

### 1. Initialize React Native Project

```bash
cd frontend

# Using React Native CLI
npx react-native init mobile --template react-native-template-typescript

# Or using Expo (easier for beginners)
npx create-expo-app mobile --template
cd mobile

# Install dependencies
npm install @react-navigation/native @react-navigation/stack @react-navigation/bottom-tabs
npm install react-native-screens react-native-safe-area-context
npm install @reduxjs/toolkit react-redux
npm install axios
npm install react-native-paper
npm install react-native-camera
npm install @react-native-async-storage/async-storage
npm install socket.io-client
```

### 2. iOS Setup (macOS only)

```bash
# Install CocoaPods
sudo gem install cocoapods

# Install iOS dependencies
cd ios
pod install
cd ..
```

### 3. Android Setup

- Install Android Studio
- Set up Android SDK
- Configure ANDROID_HOME environment variable

---

## Docker Development Environment

### 1. Create Docker Compose File

Create `docker-compose.dev.yml`:

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15
    container_name: spendshare-postgres-dev
    environment:
      POSTGRES_DB: spendshare
      POSTGRES_USER: spendshare
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data

  mongodb:
    image: mongo:6
    container_name: spendshare-mongo-dev
    ports:
      - "27017:27017"
    volumes:
      - mongo-data:/data/db

  redis:
    image: redis:7-alpine
    container_name: spendshare-redis-dev
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data

  minio:
    image: minio/minio
    container_name: spendshare-minio-dev
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin
    command: server /data --console-address ":9001"
    ports:
      - "9000:9000"
      - "9001:9001"
    volumes:
      - minio-data:/data

  mailhog:
    image: mailhog/mailhog
    container_name: spendshare-mailhog-dev
    ports:
      - "1025:1025"
      - "8025:8025"

volumes:
  postgres-data:
  mongo-data:
  redis-data:
  minio-data:
```

### 2. Start Development Environment

```bash
# Start all services
docker-compose -f docker-compose.dev.yml up -d

# View logs
docker-compose -f docker-compose.dev.yml logs -f

# Stop services
docker-compose -f docker-compose.dev.yml down
```

---

## Running the Application

### Backend Services

```bash
cd backend/auth-service

# Development mode with hot reload
npm run dev

# Production mode
npm run build
npm start
```

### OCR Service

```bash
cd ocr-service
source venv/bin/activate

# Development mode
uvicorn main:app --reload --host 0.0.0.0 --port 8000

# With Celery worker (for async processing)
celery -A tasks worker --loglevel=info
```

### Frontend Web

```bash
cd frontend/web

# Development mode
npm run dev

# Production build
npm run build
npm run preview
```

### Mobile App

```bash
cd frontend/mobile

# iOS
npm run ios
# or
npx react-native run-ios

# Android
npm run android
# or
npx react-native run-android
```

---

## Database Migrations

### Using Sequelize

```bash
# Install Sequelize CLI
npm install --save-dev sequelize-cli

# Initialize Sequelize
npx sequelize-cli init

# Create migration
npx sequelize-cli migration:generate --name create-users-table

# Run migrations
npx sequelize-cli db:migrate

# Undo migration
npx sequelize-cli db:migrate:undo
```

### Using Prisma (Alternative)

```bash
# Install Prisma
npm install prisma --save-dev
npm install @prisma/client

# Initialize Prisma
npx prisma init

# Create migration
npx prisma migrate dev --name init

# Generate Prisma Client
npx prisma generate
```

---

## Testing

### Backend Testing

```bash
cd backend/auth-service

# Run tests
npm test

# Run tests with coverage
npm run test:coverage

# Run tests in watch mode
npm run test:watch
```

### Frontend Testing

```bash
cd frontend/web

# Run tests
npm test

# Run E2E tests
npm run test:e2e
```

---

## VS Code Extensions

Install these recommended extensions:

1. **ESLint** - Code linting
2. **Prettier** - Code formatting
3. **Docker** - Docker file support
4. **GitLens** - Git integration
5. **Thunder Client** - API testing
6. **Database Client** - Database management
7. **Python** - Python development
8. **React Native Tools** - React Native development

---

## Useful Commands

### Git

```bash
# Create feature branch
git checkout -b feature/your-feature-name

# Commit changes
git add .
git commit -m "feat: your feature description"

# Push changes
git push origin feature/your-feature-name
```

### Docker

```bash
# Build image
docker build -t spendshare/service-name .

# Run container
docker run -p 3000:3000 spendshare/service-name

# View running containers
docker ps

# View logs
docker logs container-name

# Execute command in container
docker exec -it container-name sh
```

### Database

```bash
# Connect to PostgreSQL
psql -h localhost -U spendshare -d spendshare

# Backup database
pg_dump -h localhost -U spendshare spendshare > backup.sql

# Restore database
psql -h localhost -U spendshare spendshare < backup.sql
```

---

## Troubleshooting

### Port Already in Use

```bash
# Find process using port
lsof -i :3000

# Kill process
kill -9 PID
```

### Docker Issues

```bash
# Clean up Docker
docker system prune -a

# Remove all volumes
docker volume prune
```

### Node Modules Issues

```bash
# Clear npm cache
npm cache clean --force

# Delete node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

### Python Virtual Environment

```bash
# Deactivate virtual environment
deactivate

# Remove virtual environment
rm -rf venv

# Create new virtual environment
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

---

## Additional Resources

- [Node.js Documentation](https://nodejs.org/docs/)
- [React Documentation](https://react.dev/)
- [React Native Documentation](https://reactnative.dev/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Docker Documentation](https://docs.docker.com/)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)

---

## Getting Help

- Check existing documentation in `/docs`
- Search for existing issues on GitHub
- Join the community Discord/Slack
- Create a GitHub issue with detailed information

---

## Next Steps

1. Set up your development environment following this guide
2. Review the [ARCHITECTURE.md](./ARCHITECTURE.md) document
3. Check the [ROADMAP.md](./ROADMAP.md) for project timeline
4. Read [CONTRIBUTING.md](./CONTRIBUTING.md) for contribution guidelines
5. Start with backend auth service or frontend login page
6. Write tests for your code
7. Submit pull requests for review

Happy coding! 🚀
