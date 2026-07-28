#!/bin/bash

iptables -F
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT

PORTS=(53 22 9011 80 443 8080 {9000..9007} 5432 5433 6432 5000 {3001..3003})
for port in "${PORTS[@]}" ; do
    iptables -A INPUT -p tcp --dport "$port" -j ACCEPT
  done

