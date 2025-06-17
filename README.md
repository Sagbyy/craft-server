# 🛠️ craft-server

A ready-to-deploy craft server project configured for Ubuntu Server 22.04 LTS.

## 📋 Server Specifications

- **OS**: Ubuntu Server 24.04 LTS
- **RAM**: 4 GB
- **Storage**: 20 GB
- **Architecture**: Server optimized for craft/gaming applications

## 🛠️ Technologies & Services

### Core Technologies

- **Node.js**: JavaScript runtime for the Strapi application
- **PostgreSQL**: Primary database system
- **Caddy**: Modern web server with automatic HTTPS
- **Ngrok**: Secure tunnels for local development and testing

### Development Environment

- **ZSH**: Advanced shell with enhanced features
- **Oh My Zsh**: Framework for managing ZSH configuration
- **Haribo Theme**: Custom ZSH theme for better visibility and usability

### Web Services

- **Strapi**: Headless CMS for content management
- **Caddy**: Reverse proxy and web server
- **Ngrok**: Secure tunnel for external access

## 🚀 Getting Started

### 1. **Server Access**

- Download the virtual machine using the link in `deliveries/vm-url.txt`
- Use root credentials available in `deliveries/root.txt`
- Connect via SSH or management interface

### 2. **Initial Installation**

```bash
# Clone the project on the server
sudo git clone <repository-url> /opt
cd /opt/craft-server

# Make scripts executable
chmod +x install.sh
chmod +x scripts/*.sh

# Launch installation
sudo ./install.sh
```

### 3. **Strapi CMS Setup**

The project includes a Strapi CMS application for content management. After the initial installation, the Strapi application will be automatically configured and started. You can access the admin panel at:

```
http://your-server-ip
```

Default credentials will be provided in the server setup output.

### 4. **Development Environment**

The server comes with a pre-configured development environment:

- ZSH shell with Oh My Zsh framework
- Custom Haribo theme for better visibility
- Node.js and npm for JavaScript development
- PostgreSQL for database management
- Caddy for web serving with automatic HTTPS
- Ngrok for secure tunneling (requires NGROK_AUTH_TOKEN in .env)
