#/bin/sh

DEV="/dev/sdb"
DEV_BOOT="$DEV"1
DEV_INSTALL="$DEV"2
ISO="Win11_24H2_German_x64.iso"
ISO_PATH="/home/$USER/Downloads"

echo
echo "#  Format your USB flash drive"
echo
sudo wipefs -a $DEV
sudo parted $DEV mklabel gpt                     
sudo parted $DEV mkpart BOOT fat32 0% 1GiB
sudo parted $DEV mkpart INSTALL ntfs 1GiB 10GiB

echo
echo "# Check the drive layout now:"
echo
sudo parted $DEV unit B print

echo
echo "# Mount Windows ISO"
echo
sudo mkdir /mnt/iso
sudo mount $ISO_PATH/$ISO /mnt/iso/

echo
echo "# Format 1st partition of your USB flash drive as FAT32"
echo
sudo mkfs.vfat -n BOOT $DEV_BOOT
sudo mkdir /mnt/vfat
sudo mount $DEV_BOOT /mnt/vfat/

echo
echo "# Copy everything from Windows ISO image except for the sources directory there"
echo
sudo rsync -r --progress -echo-exclude sources --delete-before /mnt/iso/ /mnt/vfat/

echo
echo "# Copy only boot.wim file from the sources directory, while keeping the same path layout"
echo
sudo mkdir /mnt/vfat/sources
sudo cp /mnt/iso/sources/boot.wim /mnt/vfat/sources/

echo
echo "# Format 2nd partition of your USB flash drive as NTFS"
echo
sudo mkfs.ntfs --quick -L INSTALL $DEV_INSTALL
sudo mkdir /mnt/ntfs
sudo mount $DEV_INSTALL /mnt/ntfs

echo
echo "# Copy everything from Windows ISO image there"
echo
sudo rsync -r --progress --delete-before /mnt/iso/ /mnt/ntfs/

echo
echo "# Unmount the USB flash drive and Windows ISO image"
echo
sudo umount /mnt/ntfs
sudo umount /mnt/vfat
sudo umount /mnt/iso
sudo sync
sleep 1

echo
echo "# delete moutfolders"
echo 
sleep 1
sudo rm -r /mnt/iso
sudo rm -r /mnt/vfat
sudo rm -r /mnt/ntfs
sleep 1

echo
echo "# Power off your USB flash drive"
echo
#udo udisksctl power-off -b $DEV
