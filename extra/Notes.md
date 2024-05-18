### Script

Sets the access point interface up and assigns it an IP address of 10.0.0.1 with subnet mask 255.255.255.0

```bash
ip link set $ap up
ip addr add 10.0.0.1/24 dev $ap
sleep 2
```

1. Enable NAT (Masquerade all packets leaving the computer to make it look like they're originating from the computer)
2. Allow established connections to pass through
3. Forward packets from AP to the physical (in this case, P2P) interface

```bash
iptables -t nat -A POSTROUTING -o $p2p -j MASQUERADE
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $ap -o $p2p -j ACCEPT
```

### Programs

***iptables***: configure the rules of the KERNEL's firewall (NOT higher level ones)

***Hostapd***: host access point daemon. used for setting up an access point on the provided interface

***dnsmasq***: DNS Masquerade -> lightweight DNS & DHCP server. Caches DNS queries locally, forwarding to other services if necessary, so that if requested again, they can be fetched quickly.

#### What is DHCP?

_Dynamic Host Configuration Protocol_ - Network protocol that dynamically assigns IP addresses and other network config params, allowing clients to use other services such as DNS/NTP and communication protocols based on UDP/TCP

#### Subnet Mask?
Basically, your ipv4 address by itself, doesn't mean much. A subnet mask of `/n` implies you want to use `n` bits for the network portion of your final IP address and the remainder for your host portion.

In other words, it is a 32 bit number (4 byte IP address) that is logically and-ed with the IP address to denote which bits are to be used for network address, like so:

```
10.0.0.1/24

10.0.1.100 & 255.255.255.0
= 10.0.1.0
```

Devices with the same 'network portion' can communicate each other without going through an intermediate 'layer' like a router.

> Note that the subnet mask /24 has become the convention for home networks at this point because it corresponds to 2^8 - 2, or 254 potential home device connections.
> - 254 Connected devices, ==x.x.x.1-254==
> - 1 Network address - all host bits 0, ==x.x.x.0==
> - 1 Broadcast address - all host bits 1, ==x.x.x.255==

