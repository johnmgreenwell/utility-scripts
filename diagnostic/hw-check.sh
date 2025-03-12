#!/bin/bash
# Report platform hardware info

echo "==== SYSTEM HARDWARE INFORMATION ===="

# CPU Information
echo -e "\n>>> CPU Information:"
lscpu

# Memory Information
echo -e "\n>>> Memory Information:"
free -h

# Storage Information
echo -e "\n>>> Storage Devices and Partitions:"
lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL

# Disk Usage
echo -e "\n>>> Disk Usage:"
df -h

# Network Interfaces
echo -e "\n>>> Network Interfaces:"
ip -brief addr show

# PCI Devices
echo -e "\n>>> PCI Devices:"
lspci

# USB Devices
echo -e "\n>>> USB Devices:"
lsusb

# DMI/BIOS Information
echo -e "\n>>> BIOS and Manufacturer Information:"
sudo dmidecode -t system

# Kernel and OS Information
echo -e "\n>>> OS and Kernel Information:"
uname -a

# Graphics Card Information
echo -e "\n>>> GPU Information:"
lspci | grep -i --color 'vga\|3d\|display'

echo -e "\n==== END OF REPORT ===="

# EOF
