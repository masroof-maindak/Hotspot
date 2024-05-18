> on a raspberry pi, write a script which puts wifi in access point mode so that raspberry pi becomes an access point and all the traffic of this access point goes through ethernet. Then run tshark or wire~~guard~~shark to capture the wifi traffic and see what goes on the wire when you connect android client and use wireguard on it. Please share the script and the dump of the first handshake packets of wireguard with me. 
>
> Bonus points if you can avoid using ethernet and make wifi work as AP and connection to another wifi for internet at the same time (it's possible on some wifi chips to create multiple interfaces, not sure if RPi is capable of doing that so you'll have to check).

##### Day 1

1. Learn that my laptop's Wifi chip doesn't support AP mode
2. Puppy Linux on my father's laptop failed, decide to use friend's tomorrow

##### Day 2

1. Tested minimal hostapd config to confirm working
2. Implemented proper hostapd config file
3. NetworkManager shenanigans (manually disabling/enabling interfaces/service)
4. Configured dnsmasq interface and dhcp range settings
5. Set up interface (down -> flush -> up -> bind addr)
6. Start dnsmasq and hostapd
	1. Failed to create listening socket port 53
		1. Systemd resolve was the culprit
		2. Solved by giving port 5300 to dnsmasq
8. Don't have an ethernet cable so I must create a virtual interface

##### Day 3

1. Try on friend's laptop for ~2 hours to no avail
2. Pick up Ehab's spare laptop
3. Learn after 4 hours that the reason my phone wasn't obtaining an IP address was because of the [firewall](https://github.com/oblique/create_ap/issues/455) on my friend's laptop (Fedora) and Ehab's laptop  too (EndeavourOS).
	- Interestingly enough, assuming my own laptop's (Arch) WiFi chip supported the particular interface mode required (I.e AP, P2P-Client), I would likely have been done within the first half hour, by virtue of it not having a running firewall service in the first place
1. Simultaneous mode took barely 5 minutes after that, because I already had variables in place for routing the packets from one interface to another, and I merely had to replace their values

##### Day 4
1. Set up WireGuard connection on my own laptop at first
	1. Try different permutations of IP addresses, endpoints and allowed IPs for an hour to no avail
	2. Read up on settings and try ChatGPT
2. Learn about what the settings actually mean
3. Try on Ehab's laptop instead, succeed quickly
	- Realised that the reason it wasn't working on my own laptop was because it was on a different internet connection, whereas both Ehab's laptop and my Android phone were on the same LAN, by virtue of Ehab's laptop having assigned my phone the IP address - I'm not entirely sure this is the reason but I certainly don't think the actual reason would be mutually exclusive to the aforementioned
4. When the tunnel is active, the internet doesn't work on my phone
	1. Because I have to forward it from WireGuard's interface to the access point (or client?)
5. Capture packets on Wireshark -> save as pcap/pcapng -> export to .txt -> 'trim' excess

#### Resources
- [Hostapd : The Linux Way to create Virtual Wifi Access Point](https://nims11.wordpress.com/2012/04/27/hostapd-the-linux-way-to-create-virtual-wifi-access-point/)
- [Arch Wiki - Internet Sharing](https://wiki.archlinux.org/title/Internet_sharing)
- [Arch Wiki - Software Access Point](https://wiki.archlinux.org/title/Software_access_point)
- [Set up an access point on Linux using hostapd and dnsmasq](https://finchsec-1672417305892.hashnode.dev/linux-ap-hostapd-dnsmasq-dhcp)
- [create_ap](https://github.com/oblique/create_ap)
- [Setting Up WireGuard Client On Android](https://youtu.be/myn6yE1wgK4?feature=shared)