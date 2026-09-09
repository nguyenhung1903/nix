# QEMU and VMM setup
If you want to install the Virt-manager and QEMU, you should follow some steps below:

```bash
# This will install the needed packages (note the "Windows 11" note below):
sudo pacman -S qemu-full virt-manager swtpm
# Force libvirt to use iptables
echo 'firewall_backend = "iptables"' | sudo tee -a /etc/libvirt/network.conf
# This will add the user to the "libvirt" group so they can use it:
sudo usermod -aG libvirt $USER
# LXC backend (optional, for linux containers, enabling both backends does not conflict):
systemctl enable --now libvirtd.service
# QEMU backend (for VMs):
systemctl enable --now libvirtd.socket
# This will bring Internet up in a VM whenever one starts:
sudo virsh net-autostart default
# And to enable the entire VM network to have unfettered transit: (You should consider if you need more granular firewall rules based on your use case and security posture)
sudo ufw route allow from 192.168.122.0/24
```

# References:
* https://wiki.cachyos.org/virtualization/qemu_and_vmm_setup/
