## Pre-Requisites

#### Hardware

1. Access Point mode `iw phy | grep "Supported interface modes" -A 8`
2. Simultaneous AP/P2P `iw phy | grep "interface combinations" -A 3`

#### Software Dependencies
1. dnsmasq
2. hostapd
3. iptables


## First time setup

#### NetworkManager setup

```sh
sudo -s
sudo mv unmanaged.conf /etc/NetworkManager/conf.d/
systemctl restart NetworkManager
```

#### Replace P2P interface variable
Check your wireless interface's name with `nmcli device status` or `ip link show` (it should be something along the lines of wlan0 or wlp3s0) and replace the value of the `p2p` variable inside the `initSoftAP.sh` script.

---

Note: This script assumes you are using `systemd` as your init system, `NetworkManager` to handle internet connections and `firewalld` as your firewall.
