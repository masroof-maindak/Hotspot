# Script

Sets the access point interface up and assigns it an IP address of 10.0.0.1 with subnet mask 255.255.255.0
```bash
ip link set $ap up
ip addr add 10.0.0.1/24 dev $ap
sleep 2
```

iptables allows you to configure the rules of the KERNEL's firewall (NOT higher level ones)
```bash
iptables -t nat -A POSTROUTING -o $p2p -j MASQUERADE
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $ap -o $p2p -j ACCEPT
```
- Enable NAT (Masquerade all packets leaving the computer to make it look like they're coming from the computer)
- Allow established connections to pass through
- Forward packets from AP to the physical IF

## Hostapd
host access point daemon. used for setting up an access point on the provided interface

