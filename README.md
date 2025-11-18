# SpendShare

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![React Native](https://img.shields.io/badge/React%20Native-Mobile-brightgreen.svg)](https://reactnative.dev/)

> A modern, open-source bill splitting application - The free alternative to Splitwise

SpendShare is a full-featured expense sharing and bill splitting platform that helps friends, families, and roommates easily track shared expenses and settle debts. With intelligent receipt scanning powered by computer vision and seamless group chat, managing shared expenses has never been easier.

## 🌟 Key Features

### Core Functionality
- **Smart Expense Splitting**: Split bills equally, by percentage, exact amounts, or custom shares
- **Group Management**: Create unlimited groups for different friend circles, trips, or households
- **Friend Network**: Connect with friends and track balances across multiple groups
- **Balance Tracking**: Real-time calculation of who owes whom with intelligent debt simplification
- **Expense Categories**: Organize expenses with customizable categories and tags

### Advanced Features
- **🤖 AI-Powered Receipt Scanning**: Upload photos of receipts and let computer vision automatically extract amounts, dates, and merchants
- **💬 Group Chat**: Built-in messaging for each group to discuss expenses and coordinate payments
- **📱 Mobile Apps**: Native iOS and Android apps (premium)
- **🌐 Web Interface**: Full-featured responsive web application
- **🔄 Recurring Expenses**: Set up automatic monthly bills and subscriptions
- **💰 Payment Integration**: Direct integration with Venmo, PayPal, and Stripe
- **📊 Analytics & Insights**: Visualize spending patterns and category breakdowns
- **🌍 Multi-Currency**: Support for international expenses with real-time exchange rates
- **📤 Export Data**: Download expense reports as CSV or Excel
- **🔒 Bank-Level Security**: End-to-end encryption and secure authentication

## 🆓 Free vs Premium

### Free Version (Self-Hosted)
- ✅ Unlimited expenses and groups
- ✅ Web application
- ✅ Basic OCR (Tesseract)
- ✅ Group chat
- ✅ Export to CSV
- ✅ Self-hosted on your own infrastructure
- ✅ Open source - modify as needed

### Premium Mobile App ($4.99/month)
- ✅ **Everything in Free**, plus:
- ✨ Native iOS and Android apps
- ✨ Advanced OCR with Google Cloud Vision (higher accuracy)
- ✨ Offline mode with automatic sync
- ✨ Priority customer support
- ✨ Payment integration (Venmo, PayPal, Stripe)
- ✨ Advanced analytics and insights
- ✨ Multi-currency with live exchange rates
- ✨ Dark mode
- ✨ Cloud backup and sync

## 🏗️ Architecture

SpendShare is built with a modern microservices architecture:

```
Frontend:
├── Web App (React + TypeScript)
├── iOS App (React Native)
└── Android App (React Native)

Backend Microservices:
├── Auth Service (Node.js)
├── User Service (Node.js)
├── Group Service (Node.js)
├── Expense Service (Node.js)
├── Chat Service (Node.js)
├── OCR Service (Python + FastAPI)
├── Notification Service (Node.js)
├── Settlement Service (Node.js)
└── Payment Service (Node.js)

Data Layer:
├── PostgreSQL (Primary database)
├── MongoDB (Chat messages)
├── Redis (Cache & sessions)
└── S3/MinIO (Receipt storage)
```

For detailed architecture information, see [ARCHITECTURE.md](./ARCHITECTURE.md).

## 🚀 Quick Start

### Using Docker Compose (Recommended)

The easiest way to run SpendShare is using Docker Compose. **The setup has been optimized for fast startup** (~10-15 seconds):

```bash
# Clone the repository
git clone https://github.com/gohbi/SpendShare.git
cd SpendShare

# Start all services (optimized - only essential services enabled)
docker compose up -d

# Access the application
open http://localhost:3000
```

**What's included:**
- ✅ PostgreSQL (database)
- ✅ Redis (cache/sessions) 
- ✅ MinIO (file storage)
- ✅ MailHog (email testing)
- 💡 MongoDB & Kong (commented out - enable when needed)

For more details, see [infrastructure/docker/README.md](./infrastructure/docker/README.md)

### Manual Setup

For local development or custom deployments:

```bash
# 1. Install prerequisites
# - Node.js 18+
# - Python 3.10+
# - PostgreSQL 15
# - Redis 7
# - MongoDB 6

# 2. Set up backend services
cd backend/auth-service
npm install
npm run dev

# 3. Set up OCR service
cd ocr-service
pip install -r requirements.txt
uvicorn main:app --reload

# 4. Set up frontend
cd frontend/web
npm install
npm run dev
```

For detailed setup instructions, see [SETUP.md](./SETUP.md).

## 📚 Documentation

- **[Architecture Overview](./ARCHITECTURE.md)** - System design and technical architecture
- **[Technology Stack](./TECH_STACK.md)** - Complete list of technologies used
- **[Development Roadmap](./ROADMAP.md)** - Project timeline and milestones
- **[Setup Guide](./SETUP.md)** - Detailed development environment setup
- **[Contributing Guide](./CONTRIBUTING.md)** - How to contribute to the project
- **[API Documentation](./docs/API.md)** - REST API reference (coming soon)

## 🛠️ Technology Stack

**Frontend:**
- React 18 with TypeScript
- Redux Toolkit for state management
- Material-UI for components
- React Native for mobile apps

**Backend:**
- Node.js with Express/Fastify
- Python with FastAPI (OCR service)
- Socket.io for real-time chat
- JWT authentication

**Databases:**
- PostgreSQL for relational data
- MongoDB for chat messages
- Redis for caching and sessions

**Computer Vision:**
- Tesseract OCR (open source)
- Google Cloud Vision API (premium)
- AWS Textract (premium)
- OpenCV for image preprocessing

**Infrastructure:**
- Docker & Docker Compose
- Kubernetes (production)
- AWS/GCP/Azure compatible
- CI/CD with GitHub Actions

## 📱 Mobile Apps

The mobile apps are available on:

- **iOS**: [App Store](#) (Coming Soon)
- **Android**: [Google Play](#) (Coming Soon)

Or build from source:

```bash
cd frontend/mobile

# iOS (macOS only)
npm run ios

# Android
npm run android
```

## 🤝 Contributing

We welcome contributions from the community! Whether it's:

- 🐛 Bug reports
- 💡 Feature requests
- 📝 Documentation improvements
- 🔧 Code contributions

Please read our [Contributing Guide](./CONTRIBUTING.md) to get started.

### Development

```bash
# Fork the repository
# Clone your fork
git clone https://github.com/YOUR_USERNAME/SpendShare.git

# Create a feature branch
git checkout -b feature/amazing-feature

# Make your changes and commit
git commit -m "feat: add amazing feature"

# Push to your fork
git push origin feature/amazing-feature

# Open a Pull Request
```

## 🗺️ Roadmap

### Phase 1: MVP (Q1 2024) ✅
- [x] Core expense splitting
- [x] Group management
- [x] Web application
- [x] Docker deployment

### Phase 2: Mobile & OCR (Q2 2024)
- [ ] iOS app
- [ ] Android app
- [ ] Receipt scanning with OCR
- [ ] Basic computer vision

### Phase 3: Chat & Real-time (Q3 2024)
- [ ] Group chat functionality
- [ ] Real-time expense updates
- [ ] Push notifications

### Phase 4: Payments & Premium (Q4 2024)
- [ ] Payment integrations
- [ ] Premium subscriptions
- [ ] Advanced analytics
- [ ] Multi-currency support

See the full [Roadmap](./ROADMAP.md) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## 🙏 Acknowledgments

SpendShare is inspired by Splitwise but built from the ground up to be:
- More accessible (free self-hosted option)
- More transparent (open source)
- More private (you control your data)
- More modern (latest tech stack)

Special thanks to:
- The open-source community
- Contributors and early adopters
- Users who provide feedback

## 📞 Support

- **Documentation**: Check our [docs](./docs) folder
- **Issues**: [GitHub Issues](https://github.com/gohbi/SpendShare/issues)
- **Discussions**: [GitHub Discussions](https://github.com/gohbi/SpendShare/discussions)
- **Email**: support@spendshare.com
- **Twitter**: [@SpendShareApp](#)

## 🌟 Star History

If you find SpendShare useful, please consider giving it a star! ⭐

## 📊 Project Status

- **Status**: Active Development
- **Version**: 0.1.0-alpha
- **Last Updated**: November 2024

---

**Built with ❤️ by the SpendShare team**

[Website](#) • [Documentation](./ARCHITECTURE.md) • [Blog](#) • [Twitter](#)
