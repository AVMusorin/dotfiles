## Installation

```bash
./bootstrap.sh
```

### Keyboard layout

```bash
sudo mkdir -p /etc/udev/hwdb.d
sudo ln -sf "$(pwd)/udev/90-key-remap.hwdb" /etc/udev/hwdb.d/90-key-remap.hwdb
sudo systemd-hwdb update
# no reboot needed
sudo udevadm trigger -s input
```
