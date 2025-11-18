# SpendShare Architecture

## Overview

SpendShare is a modern bill splitting application designed as a free and open alternative to Splitwise. The platform enables users to easily split expenses with friends and family through intelligent receipt scanning, automated expense tracking, and seamless group management.

## Design Principles

1. **Privacy First**: User data is encrypted and users control their own data
2. **Cross-Platform**: Consistent experience across web, iOS, and Android
3. **Offline Capable**: Core functionality works without internet connection
4. **Scalable**: Architecture supports growth from individual users to large groups
5. **Open Source Core**: Containerized version is fully open source
6. **AI-Powered**: Computer vision for automatic receipt/bill processing

## System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Client Layer                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   Web App    │  │  iOS App     │  │ Android App  │          │
│  │  (React)     │  │ (React       │  │ (React       │          │
│  │              │  │  Native)     │  │  Native)     │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
└─────────────────────────────────────────────────────────────────┘
                            │
                            │ HTTPS / WebSocket
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                      API Gateway Layer                           │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  API Gateway (Kong / AWS API Gateway)                     │  │
│  │  - Rate Limiting, Authentication, Load Balancing          │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Microservices Layer                          │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   Auth       │  │   User       │  │   Group      │          │
│  │   Service    │  │   Service    │  │   Service    │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │  Expense     │  │    OCR       │  │    Chat      │          │
│  │  Service     │  │   Service    │  │   Service    │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │ Settlement   │  │ Notification │  │   Payment    │          │
│  │  Service     │  │   Service    │  │   Service    │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
└─────────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                        Data Layer                                │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │  PostgreSQL  │  │    Redis     │  │   MongoDB    │          │
│  │  (Primary)   │  │   (Cache)    │  │   (Chat)     │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐                             │
│  │      S3      │  │  Elasticsearch│                             │
│  │  (Storage)   │  │   (Search)   │                             │
│  └──────────────┘  └──────────────┘                             │
└─────────────────────────────────────────────────────────────────┘
```

## Technology Stack

### Frontend

#### Web Application (Free Containerized Version)
- **Framework**: React 18+ with TypeScript
- **State Management**: Redux Toolkit with RTK Query
- **UI Library**: Material-UI (MUI) or Tailwind CSS with Headless UI
- **Build Tool**: Vite
- **Progressive Web App**: Workbox for offline support
- **Camera Integration**: WebRTC for receipt capture

#### Mobile Applications (Paid Version)
- **Framework**: React Native with TypeScript
- **Navigation**: React Navigation
- **State Management**: Redux Toolkit
- **UI Components**: React Native Paper or Native Base
- **Camera**: react-native-camera or Expo Camera
- **Offline Storage**: WatermelonDB or Realm
- **Push Notifications**: Firebase Cloud Messaging
- **In-App Purchases**: react-native-iap
- **Deep Linking**: React Navigation deep linking

### Backend

#### Core Services
- **Language**: Node.js with TypeScript (or Go for high-performance services)
- **API Framework**: Express.js or Fastify
- **API Style**: RESTful APIs with GraphQL for complex queries
- **Real-time**: Socket.io or WebSockets for chat and live updates

#### Microservices Architecture

1. **Auth Service**
   - JWT-based authentication
   - OAuth 2.0 integration (Google, Apple, Facebook)
   - Multi-factor authentication
   - Session management with Redis

2. **User Service**
   - User profile management
   - Friend/contact connections
   - Privacy settings
   - User preferences

3. **Group Service**
   - Group creation and management
   - Member management
   - Group settings and permissions
   - Activity feeds

4. **Expense Service**
   - Expense CRUD operations
   - Split calculations
   - Multiple split types (equal, percentage, exact amounts, shares)
   - Expense categories and tags
   - Recurring expenses

5. **OCR/Computer Vision Service**
   - Receipt image processing
   - Text extraction (OCR)
   - Data parsing (merchant, date, total, items)
   - Bill scanning
   - Screenshot analysis
   - ML model: Tesseract OCR + Custom trained models
   - Technology: Python with TensorFlow/PyTorch
   - API: FastAPI

6. **Chat Service**
   - Real-time messaging
   - Group chats per expense group
   - Message history
   - File sharing (receipts, images)
   - Read receipts
   - Technology: Node.js with Socket.io or Go with WebSockets

7. **Settlement Service**
   - Debt calculation and optimization
   - Settlement suggestions
   - Payment tracking
   - Balance history

8. **Notification Service**
   - Push notifications (mobile)
   - Email notifications
   - In-app notifications
   - Notification preferences
   - Technology: Firebase Cloud Messaging, SendGrid

9. **Payment Service**
   - Payment method integration
   - Transaction recording
   - Payment verification
   - Integration: Stripe, PayPal, Venmo API

### Database Design

#### PostgreSQL (Primary Database)

**Users Table**
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255),
    phone_number VARCHAR(20),
    avatar_url VARCHAR(500),
    default_currency VARCHAR(3) DEFAULT 'USD',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_premium BOOLEAN DEFAULT FALSE,
    last_login TIMESTAMP
);
```

**Groups Table**
```sql
CREATE TABLE groups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url VARCHAR(500),
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);
```

**Group Members Table**
```sql
CREATE TABLE group_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID REFERENCES groups(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(20) DEFAULT 'member', -- admin, member
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(group_id, user_id)
);
```

**Expenses Table**
```sql
CREATE TABLE expenses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID REFERENCES groups(id) ON DELETE CASCADE,
    description VARCHAR(500) NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    paid_by UUID REFERENCES users(id),
    category VARCHAR(50),
    date DATE NOT NULL,
    notes TEXT,
    receipt_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_settled BOOLEAN DEFAULT FALSE
);
```

**Expense Splits Table**
```sql
CREATE TABLE expense_splits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    expense_id UUID REFERENCES expenses(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id),
    share_amount DECIMAL(12, 2) NOT NULL,
    percentage DECIMAL(5, 2),
    is_paid BOOLEAN DEFAULT FALSE,
    paid_at TIMESTAMP
);
```

**Friendships Table**
```sql
CREATE TABLE friendships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id_1 UUID REFERENCES users(id) ON DELETE CASCADE,
    user_id_2 UUID REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'pending', -- pending, accepted, blocked
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CHECK (user_id_1 < user_id_2),
    UNIQUE(user_id_1, user_id_2)
);
```

**Settlements Table**
```sql
CREATE TABLE settlements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    from_user_id UUID REFERENCES users(id),
    to_user_id UUID REFERENCES users(id),
    amount DECIMAL(12, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    group_id UUID REFERENCES groups(id),
    payment_method VARCHAR(50),
    notes TEXT,
    settled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### MongoDB (Chat Data)

**Messages Collection**
```javascript
{
  _id: ObjectId,
  group_id: UUID,
  user_id: UUID,
  message: String,
  message_type: String, // text, image, receipt, system
  attachments: [{
    type: String,
    url: String,
    filename: String
  }],
  created_at: Date,
  read_by: [UUID],
  metadata: Object
}
```

#### Redis (Caching & Real-time)
- Session storage
- Real-time presence data
- Chat room management
- Rate limiting
- Cached user balances
- Temporary OCR job status

### Computer Vision / OCR Pipeline

```
┌──────────────────────────────────────────────────────────────┐
│  1. Image Upload (Mobile/Web)                                │
└──────────────────────────────────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────────┐
│  2. Image Preprocessing                                       │
│     - Resize and normalize                                    │
│     - Enhance contrast                                        │
│     - Deskew/straighten                                       │
└──────────────────────────────────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────────┐
│  3. Text Detection & Extraction                               │
│     - Tesseract OCR                                           │
│     - Google Cloud Vision API (premium)                       │
│     - AWS Textract (premium)                                  │
└──────────────────────────────────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────────┐
│  4. Data Parsing & Extraction                                 │
│     - Merchant name detection                                 │
│     - Date parsing                                            │
│     - Total amount extraction                                 │
│     - Line items identification                               │
│     - Tax and tip calculation                                 │
│     - Custom ML model (trained on receipts)                   │
└──────────────────────────────────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────────┐
│  5. Validation & User Review                                  │
│     - Confidence scoring                                      │
│     - User confirmation/editing interface                     │
│     - Learning from corrections                               │
└──────────────────────────────────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────────┐
│  6. Expense Creation                                          │
│     - Auto-populate expense form                              │
│     - Store original receipt image                            │
└──────────────────────────────────────────────────────────────┘
```

**Technologies for OCR Service:**
- **Framework**: Python with FastAPI
- **OCR Engine**: Tesseract 4.x or 5.x
- **Image Processing**: OpenCV, Pillow
- **ML Framework**: TensorFlow or PyTorch for custom models
- **Data Extraction**: spaCy for NLP, regex patterns
- **Cloud Options**: Google Cloud Vision API, AWS Textract (for premium users)
- **Queue**: RabbitMQ or AWS SQS for async processing
- **Storage**: S3 or MinIO for receipt images

## Deployment Architecture

### Free Containerized Version

#### Docker Compose Setup
```yaml
version: '3.8'

services:
  # Frontend
  web:
    image: spendshare/web:latest
    ports:
      - "3000:3000"
    environment:
      - API_URL=http://api-gateway:8080
    depends_on:
      - api-gateway

  # API Gateway
  api-gateway:
    image: kong:latest
    ports:
      - "8080:8000"
      - "8443:8443"
    environment:
      - KONG_DATABASE=postgres
      - KONG_PG_HOST=postgres
    depends_on:
      - postgres

  # Microservices
  auth-service:
    image: spendshare/auth-service:latest
    environment:
      - DATABASE_URL=postgresql://postgres:5432/spendshare
      - REDIS_URL=redis://redis:6379
    depends_on:
      - postgres
      - redis

  user-service:
    image: spendshare/user-service:latest
    depends_on:
      - postgres

  group-service:
    image: spendshare/group-service:latest
    depends_on:
      - postgres

  expense-service:
    image: spendshare/expense-service:latest
    depends_on:
      - postgres

  ocr-service:
    image: spendshare/ocr-service:latest
    environment:
      - MODEL_PATH=/models
      - STORAGE_PATH=/receipts
    volumes:
      - ocr-models:/models
      - receipt-storage:/receipts

  chat-service:
    image: spendshare/chat-service:latest
    depends_on:
      - mongodb
      - redis

  notification-service:
    image: spendshare/notification-service:latest
    environment:
      - SMTP_HOST=${SMTP_HOST}
      - SMTP_USER=${SMTP_USER}

  # Databases
  postgres:
    image: postgres:15
    volumes:
      - postgres-data:/var/lib/postgresql/data
    environment:
      - POSTGRES_DB=spendshare
      - POSTGRES_USER=spendshare
      - POSTGRES_PASSWORD=${DB_PASSWORD}
    ports:
      - "5432:5432"

  mongodb:
    image: mongo:6
    volumes:
      - mongo-data:/data/db
    ports:
      - "27017:27017"

  redis:
    image: redis:7-alpine
    volumes:
      - redis-data:/data
    ports:
      - "6379:6379"

  # Storage (MinIO for S3-compatible storage)
  minio:
    image: minio/minio
    volumes:
      - minio-data:/data
    environment:
      - MINIO_ROOT_USER=${MINIO_USER}
      - MINIO_ROOT_PASSWORD=${MINIO_PASSWORD}
    command: server /data --console-address ":9001"
    ports:
      - "9000:9000"
      - "9001:9001"

volumes:
  postgres-data:
  mongo-data:
  redis-data:
  minio-data:
  ocr-models:
  receipt-storage:
```

#### Kubernetes (Production-Ready)
- Helm charts for easy deployment
- Horizontal Pod Autoscaling
- Ingress for routing
- Persistent volumes for databases
- ConfigMaps and Secrets management

### Paid Mobile App Infrastructure

#### Cloud Provider: AWS (or GCP/Azure)

**Architecture Components:**
- **Compute**: AWS ECS/EKS or EC2 for services
- **Database**: AWS RDS (PostgreSQL), DocumentDB (MongoDB), ElastiCache (Redis)
- **Storage**: S3 for receipts and avatars
- **CDN**: CloudFront for static assets
- **Load Balancer**: Application Load Balancer
- **Authentication**: AWS Cognito or Auth0
- **Notifications**: Firebase Cloud Messaging
- **Monitoring**: CloudWatch, DataDog, or New Relic
- **Logging**: ELK Stack or CloudWatch Logs
- **CI/CD**: GitHub Actions, AWS CodePipeline
- **ML/OCR**: AWS SageMaker or custom EC2 GPU instances

**Mobile-Specific Services:**
- **App Store**: Apple App Store, Google Play Store
- **Analytics**: Firebase Analytics, Mixpanel
- **Crash Reporting**: Sentry, Firebase Crashlytics
- **A/B Testing**: Optimizely, Firebase Remote Config
- **In-App Purchases**: Apple StoreKit, Google Play Billing
- **Payment Processing**: Stripe Connect for peer-to-peer payments

## Security Architecture

### Authentication & Authorization
- JWT tokens with refresh tokens
- OAuth 2.0 for social login
- Multi-factor authentication (TOTP)
- Role-based access control (RBAC)
- API key management for third-party integrations

### Data Security
- Encryption at rest (AES-256)
- Encryption in transit (TLS 1.3)
- Database encryption
- Secure file storage with signed URLs
- PII data handling compliance (GDPR, CCPA)

### API Security
- Rate limiting per user/IP
- Input validation and sanitization
- SQL injection prevention
- XSS protection
- CORS configuration
- API versioning
- Request signing for sensitive operations

### Mobile App Security
- Certificate pinning
- Secure storage (iOS Keychain, Android Keystore)
- Code obfuscation
- Root/jailbreak detection
- Biometric authentication

## Scalability & Performance

### Horizontal Scaling
- Stateless services for easy scaling
- Database read replicas
- Caching strategy (Redis)
- CDN for static assets
- Message queues for async processing

### Performance Optimization
- Database indexing strategy
- Query optimization
- Lazy loading and pagination
- Image optimization and compression
- GraphQL for efficient data fetching
- Debouncing and throttling

### Caching Strategy
- User session cache (Redis)
- API response cache
- Database query cache
- CDN edge cache
- Client-side cache (service workers)

## Monitoring & Observability

### Metrics
- API response times
- Error rates
- User activity metrics
- Database performance
- Service health checks
- OCR processing times

### Logging
- Structured logging (JSON)
- Centralized log aggregation
- Log levels and filtering
- Request tracing (correlation IDs)
- Audit logs for sensitive operations

### Alerting
- Service downtime alerts
- Performance degradation alerts
- Error rate thresholds
- Database capacity alerts
- Security incident alerts

## Development Workflow

### Version Control
- Git with GitHub
- Feature branch workflow
- Pull request reviews
- Semantic versioning

### CI/CD Pipeline
1. **Continuous Integration**
   - Automated testing on PR
   - Code linting and formatting
   - Security scanning
   - Build verification

2. **Continuous Deployment**
   - Automated deployment to staging
   - Manual approval for production
   - Blue-green deployment
   - Rollback capability

### Testing Strategy
- Unit tests (Jest, Pytest)
- Integration tests
- E2E tests (Cypress, Detox)
- API tests (Postman, Newman)
- Load testing (k6, JMeter)
- Security testing (OWASP ZAP)

## Free vs Paid Version Differentiation

### Free Version (Containerized)
- Core expense splitting features
- Basic OCR (Tesseract)
- Chat functionality
- Group management (up to 5 groups)
- Web access only
- Self-hosted
- Community support

### Paid Mobile App Features
- Native iOS and Android apps
- Unlimited groups
- Advanced OCR with cloud services (Google Vision, AWS Textract)
- Higher accuracy receipt scanning
- Recurring expenses
- Advanced analytics and insights
- Export to CSV/Excel
- Priority support
- Automatic backups
- Payment integration (Venmo, PayPal)
- Custom categories and tags
- Dark mode
- Multi-currency support with real-time exchange rates
- Offline mode with sync

## Monetization Strategy

### Pricing Tiers
1. **Free (Self-Hosted)**
   - $0/month
   - All core features
   - Self-hosted deployment

2. **Premium Individual**
   - $4.99/month or $49.99/year
   - Mobile apps access
   - Advanced OCR
   - Priority support

3. **Premium Group**
   - $9.99/month or $99.99/year
   - Up to 5 users
   - Shared premium features
   - Group analytics

4. **Enterprise**
   - Custom pricing
   - Dedicated support
   - Custom integrations
   - SLA guarantees

### Revenue Streams
- Mobile app subscriptions
- In-app purchases (premium features)
- Enterprise licensing
- API access for third-party integrations
- Affiliate commissions from payment processors

## Future Enhancements

### Phase 1 (MVP)
- Basic expense management
- Simple OCR
- Friend connections
- Group creation
- Basic chat

### Phase 2
- Mobile apps
- Advanced OCR
- Payment integration
- Analytics dashboard
- Multi-currency

### Phase 3
- AI-powered insights
- Predictive spending
- Budget tracking
- Bill reminders
- Voice input for expenses

### Phase 4
- Bank account integration
- Automatic expense detection
- Smart categorization
- Tax preparation export
- Business expense tracking

## API Examples

### Create Expense
```http
POST /api/v1/expenses
Authorization: Bearer {jwt_token}
Content-Type: application/json

{
  "group_id": "uuid",
  "description": "Dinner at Restaurant",
  "amount": 120.50,
  "currency": "USD",
  "paid_by": "user_uuid",
  "date": "2024-01-15",
  "category": "food",
  "splits": [
    {
      "user_id": "user_uuid_1",
      "share_amount": 40.17
    },
    {
      "user_id": "user_uuid_2",
      "share_amount": 40.17
    },
    {
      "user_id": "user_uuid_3",
      "share_amount": 40.16
    }
  ]
}
```

### Upload Receipt for OCR
```http
POST /api/v1/ocr/process
Authorization: Bearer {jwt_token}
Content-Type: multipart/form-data

receipt_image: (binary)
```

Response:
```json
{
  "job_id": "ocr_job_uuid",
  "status": "processing",
  "estimated_time": 5
}
```

### Get OCR Result
```http
GET /api/v1/ocr/result/{job_id}
Authorization: Bearer {jwt_token}
```

Response:
```json
{
  "status": "completed",
  "confidence": 0.92,
  "data": {
    "merchant": "Restaurant ABC",
    "date": "2024-01-15",
    "total": 120.50,
    "tax": 10.50,
    "tip": 15.00,
    "items": [
      {
        "description": "Pasta",
        "amount": 25.00
      },
      {
        "description": "Pizza",
        "amount": 30.00
      }
    ]
  },
  "receipt_url": "https://s3.../receipt.jpg"
}
```

## Conclusion

This architecture provides a solid foundation for building SpendShare as both a free, self-hosted containerized application and a premium mobile app. The microservices architecture ensures scalability, the dual-deployment model serves different user segments, and the comprehensive feature set positions SpendShare as a competitive alternative to Splitwise.

The modular design allows for incremental development, starting with core features and progressively adding advanced capabilities like computer vision, chat, and payment integration. The clear separation between free and paid tiers creates a sustainable business model while maintaining the open-source ethos for the containerized version.
