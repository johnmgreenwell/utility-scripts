#!/bin/bash
# Report common disk and partition information

#!/bin/bash

echo "=== Disk/Partition Information ==="
lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT

echo -e "\n=== Detailed Partition Information ==="
fdisk -l 2>/dev/null

echo -e "\n=== Mounted File Systems ==="
df -hT

echo -e "\n=== Inodes Usage ==="
df -i

echo -e "\n=== File System Usage by Type ==="
findmnt -t ext4,xfs,vfat

echo -e "\n=== Disk Usage for Root Directory ==="
du -sh /

echo -e "\n=== SMART Status for Disks ==="
for disk in $(ls /dev/sd? 2>/dev/null); do
    echo -e "\nSMART info for $disk:"
    smartctl -H $disk 2>/dev/null || echo "SMART not supported or unavailable."
done

echo -e "\n=== Block Device Information ==="
blkid

echo -e "\n=== File System Usage by Top-Ten Directory ==="
du -ah / | sort -rh | head -n 10

echo -e "\n=== Mount Points and Options ==="
cat /etc/fstab

echo -e "\n=== Available Storage Devices ==="
ls /dev/disk/by-id/

echo -e "\n=== End of Report ==="

# EOF
