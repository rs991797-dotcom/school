# HYTECH AUTO PRINT — MULTI-TENANT SAAS
## REAL PAYMENT GATEWAY + AUTOMATIC PRINT MASTER PROMPT

Build a complete, modern, production-ready **Multi-Tenant Auto Print SaaS Platform** from scratch.

The system is for multiple print shops/cyber cafes/photo studios where customers scan a shop-specific QR, upload files, pay online, and the paid file is automatically sent to that shop's printer.

---

# 1. CUSTOMER WORKFLOW

Customer scans the QR code of a particular shop.

Flow:

QR Scan
↓
Shop Branded Customer Page
↓
Upload JPG / JPEG / PNG / WEBP / PDF
↓
Preview
↓
Select Print Type
↓
Select Paper Size
↓
Select Copies
↓
Automatic Price Calculation
↓
Create Payment Order
↓
Razorpay Checkout
↓
Customer completes UPI/Card/NetBanking payment
↓
Razorpay Server-side Verification
↓
Payment Webhook Verification
↓
Order status = PAID
↓
Print Job Created
↓
Shop Print Agent receives job
↓
Correct Printer Selected
↓
Silent Automatic Printing
↓
Order status = PRINTED

IMPORTANT:

Never trust a frontend "payment successful" response.

Printing is allowed ONLY after server-side payment verification or verified Razorpay webhook.

---

# 2. REAL PAYMENT GATEWAY

Integrate **Razorpay** as the primary real payment gateway.

Create proper configuration for:

RAZORPAY_KEY_ID
RAZORPAY_KEY_SECRET
RAZORPAY_WEBHOOK_SECRET

Payment flow:

1. Customer uploads file.
2. Server calculates final amount.
3. Server creates internal order.
4. Server creates Razorpay Order.
5. Razorpay order ID is stored in database.
6. Frontend opens Razorpay Checkout.
7. Customer pays.
8. Frontend sends payment response to backend.
9. Backend verifies Razorpay signature.
10. Razorpay webhook is also received.
11. Backend verifies webhook signature.
12. Payment is marked successful only after verification.
13. Print job is created exactly once.
14. Duplicate webhook/payment events must not create duplicate print jobs.

Implement idempotency.

Store:

- internal_order_id
- razorpay_order_id
- razorpay_payment_id
- payment_signature
- amount
- currency
- payment_status
- webhook_status
- paid_at
- gateway_response
- created_at
- updated_at

Support:

- UPI
- Credit Card
- Debit Card
- Net Banking
- Other Razorpay-supported payment methods

Do not store card numbers, CVV, UPI PIN or other sensitive payment credentials.

---

# 3. MULTI-TENANT PAYMENT ARCHITECTURE

Every shop is a separate tenant.

Each tenant must have its own:

- Shop name
- Logo
- Address
- Phone
- WhatsApp
- Email
- GSTIN
- UPI/payment configuration
- Pricing
- Customer QR
- Orders
- Payments
- Printers
- Print jobs
- Staff users
- Reports

Support two payment configuration modes:

MODE A — PLATFORM PAYMENT

All tenant payments use the platform's Razorpay account.

System records which tenant generated the order.

MODE B — TENANT PAYMENT

Allow future support for tenant-specific Razorpay credentials.

Create a secure architecture so tenant credentials are encrypted at rest.

Do NOT expose Razorpay secret keys to frontend.

---

# 4. TENANT URL / QR

Every shop must have a unique URL.

Example:

https://yourdomain.com/shop/abc-print-center

Generate a QR for every tenant.

QR should open:

https://yourdomain.com/shop/abc-print-center

Super Admin can download and print the QR.

Tenant can view/download its QR from its dashboard.

Customer page must automatically display:

- Shop Logo
- Shop Name
- Address
- Contact
- Pricing
- Upload form

---

# 5. SHOP CONFIGURATION

Tenant owner must be able to configure everything from dashboard.

Shop Profile:

- Shop Name
- Logo
- Address
- Phone
- WhatsApp
- Email
- GSTIN
- Website
- Footer text

Branding:

- Logo
- Favicon
- Primary color
- Secondary color
- Customer page title
- Receipt branding

Pricing:

- B/W A4 price
- Color A4 price
- B/W A3 price
- Color A3 price
- Photo print price
- Per-copy price
- Minimum order
- Additional page pricing

Print settings:

- Default printer
- Printer mapping
- Auto Print ON/OFF
- Maximum copies
- Allowed file types
- Maximum file size

Payment:

- Platform Razorpay mode
- Tenant Razorpay mode for future support
- Test/Live mode
- Currency

---

# 6. SUPER ADMIN PANEL

Create a high-tech Super Admin dashboard.

Features:

Dashboard:

- Total Tenants
- Active Tenants
- Today's Orders
- Today's Revenue
- Total Revenue
- Pending Print Jobs
- Completed Prints
- Failed Prints
- Online Print Agents

Tenant management:

- Create tenant
- Edit tenant
- Disable tenant
- Activate tenant
- Delete tenant
- Reset tenant password
- View tenant dashboard
- View tenant orders
- View tenant payments
- View tenant printers
- Generate tenant QR

Tenant fields:

- Shop Name
- Owner Name
- Email
- Mobile
- Address
- Plan
- Status
- Created Date

---

# 7. TENANT DASHBOARD

Create a modern SaaS dashboard.

Cards:

Today's Orders
Today's Sales
Pending Payments
Paid Orders
Printing
Printed
Failed

Charts:

- Daily sales
- Monthly sales
- Orders by day
- Payment method distribution

Tables:

- Recent orders
- Recent payments
- Print queue
- Failed print jobs

---

# 8. ORDER MANAGEMENT

Each order must have:

- Order ID
- Tenant ID
- Customer name optional
- Customer mobile optional
- File name
- File type
- Copies
- Print type
- Paper size
- Amount
- Payment status
- Print status
- Payment ID
- Created time
- Paid time
- Printed time

Statuses:

PAYMENT_PENDING
PAYMENT_PROCESSING
PAID
PRINT_QUEUED
PRINTING
PRINTED
PRINT_FAILED
CANCELLED
REFUNDED

Create a complete order detail page.

---

# 9. PRINT QUEUE

After verified payment:

Create exactly one print job.

Print job contains:

- Tenant ID
- Order ID
- Printer ID
- File path
- Copies
- Paper size
- Print type
- Status
- Attempts
- Error
- Created time
- Completed time

Queue system:

QUEUED
↓
PRINTING
↓
PRINTED

If printer fails:

PRINTING
↓
PRINT_FAILED

Allow retry.

Do not print the same successful order twice accidentally.

Use job locking/idempotency.

---

# 10. PYTHON PRINT AGENT

Create a separate Python Windows application.

Features:

- Connect to server
- Device registration
- Secure authentication
- Tenant pairing
- Printer detection
- Printer selection
- Online/offline heartbeat
- Polling/WebSocket-ready architecture
- Download print job
- Download file
- Send file to SumatraPDF
- Silent print
- Report success
- Report failure
- Retry
- Local logs

Example:

Shop A:

Printer:
HP LaserJet

Shop B:

Printer:
Canon Color

The print agent must NEVER accidentally print Tenant A's job on Tenant B's printer.

Implement tenant/device pairing.

---

# 11. PRINTER MANAGEMENT

Tenant dashboard should allow:

Add Printer
Edit Printer
Delete Printer
Set Default Printer
Test Printer
View Printer Status

Printer fields:

- Printer name
- Windows printer name
- Printer type
- Paper type
- Color/B&W
- Active status
- Last heartbeat

---

# 12. PAYMENT SECURITY

Implement:

- HTTPS requirement
- Razorpay signature verification
- Webhook signature verification
- Idempotency
- Server-side amount validation
- Tenant validation
- Order ownership validation
- Payment status validation
- Duplicate webhook protection
- Rate limiting
- Input validation
- Secure environment variables

Never put:

RAZORPAY_KEY_SECRET

inside frontend JavaScript.

Never trust:

amount
tenant_id
payment_status

from the customer browser.

Calculate and validate these on the server.

---

# 13. FILE SECURITY

Allowed:

JPG
JPEG
PNG
WEBP
PDF

Maximum file size configurable.

Generate random storage filenames.

Never execute uploaded files.

Validate MIME type and extension.

Keep uploaded files outside executable directories where possible.

Automatically delete old files according to configurable retention policy.

---

# 14. RECEIPT

After successful payment generate a professional receipt.

Receipt should contain:

Shop Logo
Shop Name
Address
GSTIN
Order Number
Date/Time
File Name
Print Type
Paper Size
Copies
Amount
Payment ID
Payment Status

Provide:

Download PDF
Print Receipt

---

# 15. CUSTOMER TRACKING PAGE

After payment give customer an order tracking URL.

Example:

/order/ORDER-ID

Show:

Payment ✓
Order Queued ✓
Printing...
Printed ✓

Do not expose private admin information.

---

# 16. MODERN UI

Make the entire application look like a premium SaaS product.

Use:

- Responsive design
- Mobile-first customer page
- Modern dashboard
- Sidebar
- Top navigation
- Cards
- Tables
- Charts
- Toast notifications
- Loading states
- Empty states
- Confirmation dialogs
- Dark/light mode
- Professional typography
- Smooth transitions

Customer page should be extremely simple.

The customer should be able to complete the entire process from a mobile phone in a few steps.

---

# 17. DATABASE

Use PostgreSQL for production.

Tables:

tenants
users
roles
tenant_settings
pricing
orders
order_files
payments
payment_webhooks
printers
print_agents
print_jobs
subscriptions
audit_logs
notifications

Every tenant-owned table must contain:

tenant_id

Use proper indexes and foreign keys.

---

# 18. ROLE SYSTEM

Roles:

SUPER_ADMIN
TENANT_OWNER
MANAGER
STAFF
PRINT_AGENT

Permissions must be enforced server-side.

A tenant user must NEVER access another tenant's:

orders
payments
files
printers
users
settings

---

# 19. SUBSCRIPTION READY

Prepare SaaS subscription architecture.

Plans:

FREE
STARTER
PRO
BUSINESS

Plan limits should support:

- Monthly orders
- Number of printers
- Number of staff
- Storage
- Features

Do not make subscription billing mandatory for initial local testing.

---

# 20. NOTIFICATIONS

Prepare notification architecture for:

- Payment successful
- Print completed
- Print failed
- Order cancelled

Keep provider integration modular.

Future support:

WhatsApp
SMS
Email

---

# 21. AUDIT LOG

Record important actions:

- Login
- Logout
- Tenant created
- Settings changed
- Price changed
- Payment received
- Refund
- Printer added
- Print job created
- Print job retried
- Order cancelled

---

# 22. PROJECT STRUCTURE

Do NOT mix everything into one folder.

Use a clean modular structure:

hytech-auto-print/
│
├── backend/
│   ├── src/
│   │   ├── config/
│   │   ├── controllers/
│   │   ├── middleware/
│   │   ├── models/
│   │   ├── routes/
│   │   ├── services/
│   │   │   ├── payment/
│   │   │   ├── printing/
│   │   │   └── notification/
│   │   ├── utils/
│   │   └── app.js
│   ├── migrations/
│   ├── .env.example
│   └── package.json
│
├── frontend/
│   ├── customer/
│   ├── tenant-admin/
│   └── super-admin/
│
├── print-agent/
│   ├── src/
│   ├── config/
│   ├── requirements.txt
│   └── README.md
│
├── storage/
│
├── docs/
│
└── README.md

Keep modules separated.

---

# 23. ENVIRONMENT VARIABLES

Create `.env.example`.

Include:

DATABASE_URL
JWT_SECRET
APP_URL

RAZORPAY_KEY_ID
RAZORPAY_KEY_SECRET
RAZORPAY_WEBHOOK_SECRET

STORAGE_PATH

PRINT_AGENT_SECRET

Do not hard-code secrets.

---

# 24. REAL PAYMENT TESTING

Provide clear setup instructions:

1. Create Razorpay account.
2. Obtain Test API keys.
3. Add keys to `.env`.
4. Configure webhook URL.
5. Add webhook secret.
6. Start application.
7. Create tenant.
8. Open tenant QR/customer page.
9. Upload test file.
10. Create payment.
11. Complete test payment.
12. Verify webhook.
13. Confirm order becomes PAID.
14. Confirm print job is created.
15. Confirm Print Agent receives job.
16. Confirm printer prints.
17. Confirm order becomes PRINTED.

Only after complete testing should Live Mode be enabled.

---

# 25. ERROR HANDLING

Handle:

- Payment failure
- Payment timeout
- Webhook failure
- Duplicate webhook
- Upload failure
- Printer offline
- Printer unavailable
- File download failure
- Print failure
- Network failure

Show user-friendly messages.

Never expose stack traces or secrets to customers.

---

# 26. IMPORTANT FINAL REQUIREMENT

Do not create a fake/demo-only payment implementation.

Implement the Razorpay integration architecture completely with:

- order creation
- checkout
- signature verification
- webhook endpoint
- webhook signature verification
- payment record
- idempotency
- amount validation
- payment status update
- print job creation after verified payment

Keep Test Mode configurable so the system can be tested safely before Live Mode.

Generate complete runnable code, database migrations, frontend, backend, Python Print Agent, `.env.example`, setup documentation and deployment instructions.

The final application should look like a professional commercial product named:

**HYTECH AUTO PRINT**

Do not leave core functionality as pseudocode.

Where a production credential is required, use environment variables and clearly document where the merchant must enter their own credentials.