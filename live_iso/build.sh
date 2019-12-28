#!/bin/bash

rm *.iso
rm -rf image/
rm -rf scratch/
rm -rf chroot/root/.*
rm -rf chroot/home/user/.*
rm -rf chroot/root/*
rm -rf chroot/home/user/*

mkdir -p image/live &&
mkdir -p scratch &&
mksquashfs chroot image/live/filesystem.squashfs -e boot &&
cp chroot/boot/vmlinuz-* image/vmlinuz &&
cp chroot/boot/initrd.img-* image/initrd &&
echo "search --set=root --file /DEBIAN_CUSTOM" >> scratch/grub.cfg &&
echo "set default=\"0\"" >> scratch/grub.cfg &&
echo "set timeout=1" >> scratch/grub.cfg && 
echo "menuentry \"Aegis Altair\" {" >> scratch/grub.cfg &&
echo "linux /vmlinuz boot=live nomodeset toram" >> scratch/grub.cfg &&
echo "initrd /initrd" >> scratch/grub.cfg &&
echo "}" >> scratch/grub.cfg &&
touch image/DEBIAN_CUSTOM &&
grub-mkstandalone --format=i386-pc --output=~/live_iso/scratch/core.img --install-modules="linux normal iso9660 biosdisk memdisk search tar ls" --modules="linux normal iso9660 biosdisk search" --locales="" --fonts="" "boot/grub/grub.cfg=~/live_iso/scratch/grub.cfg" &&
cat /usr/lib/grub/i386-pc/cdboot.img ~/live_iso/scratch/core.img > ~/live_iso/scratch/bios.img &&
xorriso -as mkisofs -iso-level 3 -full-iso9660-filenames -volid "Aegis Altair" --grub2-boot-info --grub2-mbr /usr/lib/grub/i386-pc/boot_hybrid.img -eltorito-boot boot/grub/bios.img -no-emul-boot -boot-load-size 4 -boot-info-table --eltorito-catalog boot/grub/boot.cat -output "~/live_iso/aegis-altair.iso" -graft-points "~/live_iso/image" /boot/grub/bios.img=~/live_iso/scratch/bios.img
