# HYTECH AUTO PRINT — Multi-Tenant Print SaaS

QR scan → Shop branded page → Upload → Payment (Razorpay) → Print queue → Windows Print Agent → Silent print.

## Architecture

```
hytech-auto-print/
├── backend/          Express.js + PostgreSQL
│   ├── src/
│   │   ├── config/       Database, Razorpay
│   │   ├── controllers/
│   │   ├── middleware/    Auth, Error Handler
│   │   ├── models/
│   │   ├── routes/       auth, admin, shop, payments, dashboard, settings, printers, printAgent
│   │   ├── services/
│   │   │   ├── payment/    Razorpay integration
│   │   │   ├── printing/   Print queue & job management
│   │   │   └── notification/
│   │   ├── utils/        Helpers, crypto, audit, file validation
│   │   └── app.js        Main entry point
│   ├── migrations/
│   └── package.json
├── frontend/
│   ├── customer/        Customer upload & payment page
│   ├── tenant-admin/    Tenant dashboard
│   └── super-admin/     Super admin panel
├── print-agent/         Python Windows print agent
├── storage/             Uploaded files
└── .env.example
```

## Setup

### Prerequisites
- Node.js 18+
- PostgreSQL 14+
- SumatraPDF (for print agent)
- Python 3.8+ (for print agent)

### 1. Database
```sql
CREATE DATABASE hytech_print;
```

### 2. Backend
```bash
cd backend
cp .env.example .env    # Edit with your credentials
npm install
npm run migrate
npm start
```

### 3. Environment Variables

| Variable | Description |
|----------|-------------|
| `DATABASE_URL` | PostgreSQL connection string |
| `JWT_SECRET` | Random secret for JWT tokens |
| `RAZORPAY_KEY_ID` | Razorpay test/live key |
| `RAZORPAY_KEY_SECRET` | Razorpay secret (NEVER expose to frontend) |
| `RAZORPAY_WEBHOOK_SECRET` | Razorpay webhook signing secret |
| `PRINT_AGENT_SECRET` | Shared secret for print agents |

### 4. Open
- **Customer**: `http://localhost:3000/shop/<slug>`
- **Tenant Dashboard**: `http://localhost:3000/dashboard`
- **Super Admin**: `http://localhost:3000/super-admin`
- **Order Tracking**: `http://localhost:3000/track/<order-id>`

### 5. Print Agent
```bash
cd print-agent
cp config.example.json config.json   # Edit settings
pip install -r requirements.txt
python print_agent.py
```

## Razorpay Setup
1. Create account at [razorpay.com](https://razorpay.com)
2. Get test API keys from Dashboard → Settings → API Keys
3. Add keys to `.env`
4. Configure webhook URL: `https://yourdomain.com/api/payments/webhook/razorpay`
5. Add webhook secret to `.env`

## Features
- Multi-tenant architecture (each shop is isolated)
- Razorpay real payment (UPI, Card, NetBanking)
- Webhook signature verification
- Payment idempotency (no duplicate print jobs)
- Server-side amount validation
- Role-based access (Super Admin, Owner, Manager, Staff)
- Modern responsive UI
- Print queue with retry
- Device registration & tenant pairing
- Audit logs
- Notifications

## Testing Flow
1. Login as Super Admin → Create tenant
2. Open `/shop/<slug>` → Upload file → Pay (Demo or Razorpay test)
3. Verify order becomes PAID
4. Print Agent picks up job → Printer prints
5. Order status becomes PRINTED
