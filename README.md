# 🛠️ Craft Server

A ready-to-deploy Ubuntu server for modern web applications with Strapi CMS, PostgreSQL, and a complete development toolkit.

## 📋 Server Specifications

- **OS**: Ubuntu Server 24.04 LTS
- **RAM**: 4 GB minimum
- **Storage**: 20 GB minimum
- **Architecture**: Optimized for web applications and development

## 🏗️ Project Architecture

```
craft-server/
├── configs/           # Service configurations
├── database/          # Database scripts
├── deliveries/        # Delivery information
├── scripts/           # Installation scripts
├── strapi-app/        # Strapi CMS application
└── install.sh         # Main installation script
```

## 🛠️ Technologies & Services

### 🎯 Core Technologies

- **Node.js 18+**: JavaScript runtime for Strapi
- **PostgreSQL 16**: Primary database
- **Strapi 5.15.1**: Modern headless CMS
- **Caddy**: Web server with automatic HTTPS
- **Ngrok**: Secure tunnels for development

### 🔧 Development Environment

- **ZSH + Oh My Zsh**: Advanced shell with framework
- **Haribo Theme**: Custom ZSH theme
- **NVM**: Node.js version manager
- **SFTP**: Secure file access

### 🌐 Web Services

- **Strapi CMS**: Admin panel on port 1337
- **Caddy**: Reverse proxy and web server on port 80
- **Ngrok**: Secure tunnel for external access
- **Weather API**: OpenWeatherMap integration

## 🚀 Installation

### 1. **Prerequisites**

- Ubuntu Server 24.04 LTS
- Root or sudo access
- Stable internet connection

### 2. **Initial Setup**

```bash
# Clone the project
sudo git clone <repository-url> /opt/craft-server
cd /opt/craft-server

# Make scripts executable
chmod +x install.sh
chmod +x scripts/*.sh

# Create .env file (see Configuration section)
cp .env.example .env
nano .env
```

### 3. **Environment Variables**

Create a `.env` file with the following variables:

```bash
# Ngrok (optional)
NGROK_AUTH_TOKEN=your_ngrok_token

# Weather API (optional)
OPENWEATHERMAP_API_KEY=your_openweathermap_key

# Database (automatically configured)
DB_NAME=data-db
DB_USER=dbuser
DB_PASS=gTU1ZwxE92Z77H83a33OZ046
```

### 4. **Automatic Installation**

```bash
# Launch interactive installation
sudo ./install.sh
```

The installation offers each step with confirmation:

- ✅ System update
- ✅ Dependencies installation
- ✅ SSH configuration
- ✅ ZSH configuration
- ✅ Haribo theme installation

### 5. **Web Services Installation**

```bash
# Install Strapi, Caddy and Ngrok
sudo bash scripts/setup-strapi-web.sh
```

## 📱 Strapi Application

### 🎨 Features

- **Content management**: Articles, authors, categories
- **Media**: Upload and manage images/videos
- **REST API**: Automatic endpoints
- **Admin interface**: Modern admin panel
- **Dynamic components**: Rich text, sliders, quotes

### 🗂️ Content Structure

- **Articles**: Blog posts with cover, author, category
- **Authors**: Author management with avatar
- **Categories**: Content organization
- **Globals**: Global site content
- **About**: About page

### 🚀 Startup

```bash
cd /opt/craft-server/strapi-app

# Development mode
npm run develop

# Production mode
npm run build
npm run start

# Seed example data
npm run seed:example
```

## 🌐 Web Access

### Access URLs

- **Strapi Admin**: `http://your-server-ip/admin`
- **Strapi API**: `http://your-server-ip/api`
- **Ngrok Tunnel**: `https://your-ngrok-url.ngrok.io`

### 🔐 Default Credentials

Credentials will be displayed during Strapi's first installation.

## 🗄️ Database

### PostgreSQL

- **Port**: 5432
- **Database**: `data-db`
- **User**: `dbuser`
- **Configuration**: Optimized for remote access

### 🔄 Automatic Backup

```bash
# Daily backup script
sudo bash database/cron/backup_postgresql.sh

# Backups kept for 7 days
# Location: /opt/backup/postgresql/
```

## 🔧 Available Scripts

### 📦 Installation

- `install.sh`: Main interactive installation
- `scripts/setup-ssh.sh`: Secure SSH configuration
- `scripts/setup-zsh.sh`: ZSH + Oh My Zsh configuration
- `scripts/setup-haribo-theme.sh`: Custom theme
- `scripts/setup-strapi-web.sh`: Complete web installation
- `scripts/setup-db-config.sh`: PostgreSQL configuration
- `scripts/setup-sftp.sh`: SFTP configuration
- `scripts/setup-firewalls.sh`: Firewall configuration
- `scripts/setup-meteo.sh`: Weather integration
- `scripts/setup-flutter.sh`: Flutter installation

### 🛠️ Maintenance

- `database/cron/backup_postgresql.sh`: Automatic backup
- `database/init-db.sh`: Database initialization

## 🌤️ Weather Integration

The server integrates OpenWeatherMap to display weather in the message of the day (MOTD).

```bash
# Manual configuration
sudo bash scripts/setup-meteo.sh

# Daily update at 7:00 AM
# Display: temperature and weather conditions
```

## 🔒 Security

### 🔐 SSH

- SSH keys recommended
- Password authentication disabled
- Configuration in `scripts/setup-ssh.sh`

### 🛡️ Firewall

- Automatic UFW configuration
- Open ports: 22 (SSH), 80 (HTTP), 443 (HTTPS)
- Script: `scripts/setup-firewalls.sh`

### 📁 SFTP

- Secure file access
- Isolated users
- Configuration in `scripts/setup-sftp.sh`

## 📊 Monitoring

### 📈 Logs

- **Strapi**: `/opt/craft-server/strapi-app/logs/`
- **Caddy**: `journalctl -u caddy`
- **PostgreSQL**: `/var/log/postgresql/`

### 🔍 Service Status

```bash
# Check services
sudo systemctl status caddy
sudo systemctl status postgresql
sudo systemctl status ngrok

# Real-time logs
sudo journalctl -f -u caddy
```

## 🚨 Troubleshooting

### Common Issues

1. **Strapi won't start**

   ```bash
   cd /opt/craft-server/strapi-app
   npm install
   npm run build
   npm run start
   ```

2. **Caddy not responding**

   ```bash
   sudo systemctl restart caddy
   sudo journalctl -u caddy
   ```

3. **Database inaccessible**
   ```bash
   sudo systemctl restart postgresql
   sudo bash scripts/setup-db-config.sh
   ```

### 🔧 Maintenance

```bash
# System update
sudo apt update && sudo apt upgrade -y

# Restart services
sudo systemctl restart caddy postgresql

# Clean logs
sudo journalctl --vacuum-time=7d
```
