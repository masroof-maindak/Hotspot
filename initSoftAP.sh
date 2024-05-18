#!/bin/bash
 
ap=wlan0_ap # virtual
p2p=wlan0   # physical, replace with your actual interface

# TODO: Make firewalld allow dnsmasq DHCP to 'pass' safely.
# firewall-cmd --zone=nm-shared --add-interface=ap0 (?)
systemctl stop firewalld

echo "Creating virtual interface for AP"
if [ ! -d /sys/class/net/$ap ]; then
    iw dev $p2p interface add $ap type __ap addr 12:34:56:78:ab:ce
fi
 
echo "Reinitializing AP + Assigning static IP Address"
ip link set $ap down
ip addr flush dev $ap
ip link set $ap up
ip addr add 10.0.0.1/24 dev $ap
sleep 2
 
echo "(Re)starting dnsmasq"
killall -q dnsmasq; sleep 1;
dnsmasq -C dnsmasq.conf
 
echo "Enabling NAT"
iptables -t nat -A POSTROUTING -o $p2p -j MASQUERADE
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $ap -o $p2p -j ACCEPT
 
echo "Enabling packet forwarding"
sysctl -w net.ipv4.ip_forward=1
 
echo "Starting hostapd"
hostapd hostapd.conf

# Comment these lines out if you run hostapd with the 'background' flag (-B)
echo "Cleanup"
killall -q dnsmasq
systemctl start firewalld
