# HYTECH Auto Print - cPanel Deployment Guide

## Prerequisites
- cPanel hosting with Node.js support (NodeSelector available)
- Ya VPS with cPanel license
- Domain name pointing to your server
- SSH access (recommended)

---

## Method 1: cPanel with Node.js (Shared Hosting)

### Step 1: cPanel me Node.js Enable Karo
1. cPanel login karo
2. **Software** section me jaao
3. **Node.js App** select karo
4. **Create Application** click karo
5. Settings:
   - Node.js version: **18.x** ya **20.x**
   - Application mode: **Production**
   - Application root: **public_html** ya **backend**
   - Application startup file: **src/app.js**
6. **Create** click karo

### Step 2: Files Upload Karo
1. **File Manager** me jaao
2. `public_html` folder me jaao (ya jahan Node.js app set kiya)
3. Ye files upload karo:
   ```
   backend/
   ├── src/
   │   ├── app.js
   │   ├── config/
   │   ├── routes/
   │   ├── middleware/
   │   ├── services/
   │   └── utils/
   ├── migrations/
   ├── data/
   ├── package.json
   └── node_modules/ (npm install se generate hoga)
   
   frontend/
   ├── index.html
   ├── super-admin/
   ├── tenant-admin/
   ├── customer/
   ├── styles.css
   └── customer.js
   ```

### Step 3: Install Dependencies
1. cPanel **Terminal** kholo (ya SSH se)
2. Navigate to backend folder:
   ```bash
   cd backend
   npm install --production
   ```

### Step 4: Environment Variables
cPanel me **Node.js App** → **Environment Variables** me add karo:

```
NODE_ENV=production
PORT=3000
PRINT_AGENT_SECRET=hytech-print-agent-secret-2024
APP_URL=https://yourdomain.com
```

### Step 5: Domain Setup
1. cPanel **Domains** me jaao
2. Apna domain add karo
3. Document Root: `public_html` (ya jahan app hai)
4. **Subdomain** banao (optional):
   - `admin.yourdomain.com` → super admin
   - `dashboard.yourdomain.com` → tenant dashboard

### Step 6: SSL Certificate
1. cPanel **SSL/TLS** me jaao
2. **Let's Encrypt** ya **AutoSSL** enable karo
3. Ya **Install SSL Certificate** manually karo

### Step 7: Start Application
1. cPanel **Node.js App** me jaao
2. **Restart** button click karo
3. Ya **Run NPM Install** click karo

---

## Method 2: VPS with cPanel (Recommended)

### Step 1: Server Setup
1. VPS kharido (DigitalOcean, Linode, Vultr, etc.)
2. cPanel license install karo
3. SSH access setup karo

### Step 2: SSH se Setup
```bash
# Connect to server
ssh root@your-server-ip

# Create project folder
mkdir -p /home/youruser/hytech-auto-print
cd /home/youruser/hytech-auto-print

# Clone/upload files
# ... (git clone ya scp se files copy karo)

# Install dependencies
cd backend
npm install --production

# Install PM2 for process management
npm install -g pm2

# Start the app
pm2 start src/app.js --name hytech-auto-print

# Save PM2 config
pm2 save
pm2 startup
```

### Step 3: cPanel Domain Setup
1. cPanel **Domains** me jaao
2. Domain add karo: `yourdomain.com`
3. Document Root: `/home/youruser/hytech-auto-print`
4. Ya **Reverse Proxy** setup karo (cPanel me):

```apache
# .htaccess (public_html me)
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

ProxyPass / http://localhost:3000/
ProxyPassReverse / http://localhost:3000/
```

### Step 4: SSL Setup
1. cPanel **SSL/TLS** → **Let's Encrypt** use karo
2. Ya **Certbot** se:
   ```bash
   certbot --nginx -d yourdomain.com -d www.yourdomain.com
   ```

### Step 5: Firewall
```bash
# Open ports
ufw allow 80
ufw allow 443
ufw allow 3000  # Only if needed
ufw enable
```

---

## Method 3: Docker Deployment (If cPanel supports Docker)

### Dockerfile banana ho:
```dockerfile
FROM node:20-alpine

WORKDIR /app

# Copy backend
COPY backend/ ./backend/
RUN cd backend && npm install --production

# Copy frontend
COPY frontend/ ./frontend/

# Expose port
EXPOSE 3000

# Start
CMD ["node", "backend/src/app.js"]
```

### Docker Compose:
```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "3000:3000"
    volumes:
      - ./data:/app/backend/data
    environment:
      - NODE_ENV=production
      - PRINT_AGENT_SECRET=hytech-print-agent-secret-2024
    restart: always
```

---

## Post-Deployment Checklist

### 1. Environment Variables (.env file)
```bash
# backend/.env
NODE_ENV=production
PORT=3000
PRINT_AGENT_SECRET=hytech-print-agent-secret-2024
APP_URL=https://yourdomain.com
```

### 2. Database Folder
```bash
# Data folder permissions
chmod 755 data/
chmod 644 data/app.db
```

### 3. Storage Folder
```bash
# Upload folder
chmod 755 storage/
```

### 4. Domain DNS Settings
```
Type    Name    Value           TTL
A       @       YOUR-SERVER-IP  3600
A       www     YOUR-SERVER-IP  3600
CNAME   admin   yourdomain.com  3600
```

### 5. Test Karo
- `https://yourdomain.com` → Landing page
- `https://yourdomain.com/super-admin` → Super admin login
- `https://yourdomain.com/dashboard` → Tenant dashboard
- `https://yourdomain.com/shop/abc-print-center` → Customer page

---

## Print Agent Setup (Tenant ke Computer pe)

### Config Update:
```json
{
  "server_url": "https://yourdomain.com",
  "agent_key": "TENANT-SPECIFIC-KEY-DATABASE-SE",
  "tenant_slug": "abc-print-center",
  "printer_name": "HP LaserJet P1108",
  "device_name": "Main Print Agent"
}
```

### Key kaise milega:
1. Super admin login karo
2. Tenants tab → Shop select karo
3. Print Agent section me unique key dikhega
4. Ya tenant-admin login karo
5. Print Agent tab me key dikhega

---

## Troubleshooting

### 502 Bad Gateway
- Node.js app running hai ya nahi check karo
- Port sahi hai ya nahi check karo
- PM2 status check karo: `pm2 status`

### Static Files Nahi Load Ho Rahe
- Frontend path sahi hai ya nahi check karo
- `.htaccess` file check karo
- Proxy rules check karo

### Database Error
- `data/` folder permissions check karo
- `app.db` file exists hai ya nahi check karo
- Write permissions check karo

### SSL Error
- Certificate install hai ya nahi check karo
- HTTP to HTTPS redirect setup hai ya nahi check karo

---

## Support
- Email: support@hytech.in
- Documentation: README.md
