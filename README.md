# 🛠️ craft-server

A ready-to-deploy craft server project configured for Ubuntu Server 22.04 LTS.

## 📋 Server Specifications

- **OS**: Ubuntu Server 22.04 LTS
- **RAM**: 2 GB
- **Storage**: 20 GB
- **Architecture**: Server optimized for craft/gaming applications

## 🏗️ Project Structure

```
craft-server/
├── 📁 deliveries/          # Delivery and access files
│   ├── vm-url.txt          # Virtual machine link
│   └── root.txt            # Root access credentials
├── 📁 database/            # Database configuration and scripts
├── 📁 configs/             # Server configuration files
├── 📁 scripts/             # Automation and maintenance scripts
│   └── init-setup.sh       # Server initialization script
├── 📁 cron/                # Cron jobs and automation
├── install.sh              # Main installation script
└── README.md               # Project documentation
```

## 🚀 Getting Started

### 1. **Server Access**

- Download the virtual machine using the link in `deliveries/vm-url.txt`
- Use root credentials available in `deliveries/root.txt`
- Connect via SSH or management interface

### 2. **Initial Installation**

```bash
# Clone the project on the server
sudo git clone <repository-url> /opt/craft-server
cd /opt/craft-server

# Make scripts executable
chmod +x install.sh
chmod +x scripts/init-setup.sh

# Launch installation
sudo ./install.sh
```
