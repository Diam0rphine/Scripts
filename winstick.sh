#/bin/sh

echo
echo "███████╗██╗   ██╗ ██████╗██╗  ██╗    ██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗███████╗"
echo "██╔════╝██║   ██║██╔════╝██║ ██╔╝    ██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║██╔════╝"
echo "█████╗  ██║   ██║██║     █████╔╝     ██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║███████╗"
echo "██╔══╝  ██║   ██║██║     ██╔═██╗     ██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║╚════██║"
echo "██║     ╚██████╔╝╚██████╗██║  ██╗    ╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝███████║"
echo "╚═╝      ╚═════╝  ╚═════╝╚═╝  ╚═╝     ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚══════╝"
echo "01.2025"
sleep 1

echo
if [ "$EUID" -ne 0 ]
  then echo "#####  Please run as root"
  exit
fi
echo

DEV="/dev/sda"
DEV_BOOT="$DEV"1
DEV_INSTALL="$DEV"2
ISO="Win11_24H2_German_x64.iso"
ISO_PATH="/home/$USER/Downloads"

echo
echo "#  Unmount Partitions"
echo
umount "$DEV"1
umount "$DEV"2
umount "$DEV"3
umount "$DEV"4
umount "$DEV"5
sleep 1

echo
echo "#  Format your USB flash drive"
echo
wipefs -a $DEV
sleep 2
parted $DEV mklabel gpt               
sleep 2      
parted $DEV mkpart BOOT fat32 0% 1GiB
sleep 2
parted $DEV mkpart INSTALL ntfs 1GiB 10GiB
sleep 2

echo
echo "# Check the drive layout now:"
echo
parted $DEV unit B print

echo
echo "# Mount Windows ISO"
echo
mkdir /mnt/iso
mount $ISO_PATH/$ISO /mnt/iso/

echo
echo "# Format 1st partition of your USB flash drive as FAT32"
echo
mkfs.vfat -n BOOT $DEV_BOOT
mkdir /mnt/vfat
mount $DEV_BOOT /mnt/vfat/

echo
echo "# Copy everything from Windows ISO image except for the sources directory there"
echo
rsync -r --progress -echo-exclude sources --delete-before /mnt/iso/ /mnt/vfat/

echo
echo "# Copy only boot.wim file from the sources directory, while keeping the same path layout"
echo
mkdir /mnt/vfat/sources
cp /mnt/iso/sources/boot.wim /mnt/vfat/sources/

echo
echo "# Format 2nd partition of your USB flash drive as NTFS"
echo
mkfs.ntfs --quick -L INSTALL $DEV_INSTALL
mkdir /mnt/ntfs
mount $DEV_INSTALL /mnt/ntfs

echo
echo "# Copy everything from Windows ISO image there"
echo
rsync -r --progress --delete-before /mnt/iso/ /mnt/ntfs/

echo
echo "# Unmount the USB flash drive and Windows ISO image"
echo
umount /mnt/ntfs
umount /mnt/vfat
umount /mnt/iso
sync
sleep 1

echo
echo "# delete moutfolders"
echo 
sleep 1
rm -r /mnt/iso
rm -r /mnt/vfat
rm -r /mnt/ntfs
sleep 1

echo
echo "# Power off your USB flash drive"
echo
#udo udisksctl power-off -b $DEV
