#!/bin/bash

# List of allowed IP subnets
public_ports=(
    "443"
    "80"
    "9021"
)
subnets=(
    "27.34.176.0/24"
    "57.90.150.0/23"
    "77.83.59.0/24"
    "82.198.24.0/24"
    "91.202.233.0/24"
    "93.171.174.0/24"
    "93.171.220.0/24"
    "93.171.221.0/26"
    "93.171.221.64/26"
    "93.171.221.128/26"
    "93.171.222.0/24"
    "93.171.223.0/24"
    "94.102.176.0/22"
    "94.102.180.0/22"
    "94.102.184.0/22"
    "94.102.188.0/22"
    "95.85.96.0/22"
    "95.85.100.0/24"
    "95.85.101.0/24"
    "95.85.102.0/25"
    "95.85.103.0/24"
    "95.85.108.0/23"
    "95.85.110.0/24"
    "95.85.111.0/24"
    "95.85.112.0/20"
    "103.220.0.0/22"
    "119.235.112.0/21"
    "119.235.120.0/21"
    "154.30.29.0/24"
    "177.93.143.0/24"
    "178.171.66.0/23"
    "185.69.184.0/22"
    "185.246.72.0/22"
    "196.48.195.0/24"
    "196.56.195.0/24"
    "196.57.195.0/24"
    "196.58.195.0/24"
    "196.197.195.0/24"
    "196.198.195.0/24"
    "196.199.195.0/24"
    "216.250.8.0/21"
    "217.8.117.0/24"
    "217.174.224.0/20"
    "185.69.185.71"
    "93.171.222.150"

)

# Flush existing rules (optional, be cautious if using in a live environment)
iptables -F

# Default policy to drop all incoming traffic
iptables -P INPUT DROP

# Allow traffic on loopback interface
iptables -A INPUT -i lo -j ACCEPT

# Allow From Local Network
iptables -A INPUT -p tcp --dport 9021 -j ACCEPT
iptables -A INPUT -s 192.168.1.0/24 -m tcp -p tcp -j ACCEPT
iptables -A INPUT -s 192.168.100.0/24 -m tcp -p tcp -j ACCEPT

# Allow established and related traffic
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow HTTP and HTTPS traffic from specified subnets
for port in "${public_ports[@]}"; do
	for subnet in "${subnets[@]}"; do
    		iptables -A INPUT -p tcp -s "$subnet" --dport "$port" -j ACCEPT
	done
done

# Log and drop all other traffic (optional, for debugging purposes)
iptables -A INPUT -j LOG --log-prefix "iptables-dropped: " --log-level 4
iptables -A INPUT -j DROP
