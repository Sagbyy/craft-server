#!/bin/bash

# Reset all rules
sudo iptables -F # Flush all rules from filter table
sudo iptables -t nat -F # Flush all rules from nat table
sudo iptables -t mangle -F # Flush all rules from mangle table
sudo iptables -X # Delete all custom chains

# Set default policies to drop
sudo iptables -P INPUT DROP # Drop all incoming traffic
sudo iptables -P FORWARD DROP # Drop all forwarded traffic
sudo iptables -P OUTPUT DROP # Drop all outgoing traffic

# Loopback
iptables -I INPUT -i lo -j ACCEPT # Accept all loopback traffic
# Loopback is used for communication between the server and itself
iptables -I OUTPUT -o lo -j ACCEPT # Accept all loopback traffic

# Allow established and related connections
# ESTABLISHED: The connection is established
# RELATED: The connection is related to an existing connection
iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -I OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# SSH
iptables -I INPUT -p tcp --dport 22 -j ACCEPT # Accept all incoming SSH traffic
iptables -I OUTPUT -p tcp --dport 22 -j ACCEPT # Accept all outgoing SSH traffic

# Website (HTTP/HTTPS)
# It used for the strapi web application
iptables -I INPUT -p tcp --dport 80 -j ACCEPT # Accept all incoming HTTP traffic
iptables -I INPUT -p tcp --dport 443 -j ACCEPT # Accept all incoming HTTPS traffic
iptables -I OUTPUT -p tcp --dport 80 -j ACCEPT # Accept all outgoing HTTP traffic
iptables -I OUTPUT -p tcp --dport 443 -j ACCEPT # Accept all outgoing HTTPS traffic

# ICMP
# It used for the ping command
iptables -I INPUT -p icmp --icmp-type echo-request -j ACCEPT # Accept all incoming ping requests
iptables -I OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT # Accept all outgoing ping replies

# PostgreSQL
# It used for the PostgreSQL database
iptables -I INPUT -p tcp --dport 5432 -j ACCEPT # Accept all incoming PostgreSQL traffic
iptables -I OUTPUT -p tcp --dport 5432 -j ACCEPT # Accept all outgoing PostgreSQL traffic

# SFTP
# It used for the SFTP server
iptables -I INPUT -p tcp --dport 2049 -j ACCEPT # Accept all incoming SFTP traffic
iptables -I OUTPUT -p tcp --dport 2049 -j ACCEPT # Accept all outgoing SFTP traffic

# Update the firewall rules
sudo apt update
sudo apt install iptables-persistent -y

# Save rules
sudo iptables-save > /etc/iptables/rules.v4

echo "✅ Firewalls configured and persistent"