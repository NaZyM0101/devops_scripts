#!/bin/bash

# List of allowed IP subnets
public_ports=(
    "443"
    "80"
    "9021"
)
subnets=(
    "192.168.1.0/24"
    "192.168.100.0/24"

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
