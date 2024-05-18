### Setup

First, check your wireless interface's name with `nmcli device status` or `ip link show` and replace the value of the `p2p` variable inside the `./initSoftAP.sh` script.

```sh
sudo -s
mv unmanaged.conf /etc/NetworkManager/conf.d/
systemctl restart NetworkManager
./initSoftAP.sh
```