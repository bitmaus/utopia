#!/bin/bash

DRIVE='/dev/sda'
HOSTNAME='bolt'
ROOT_PASSWORD='bitmaus' # leave blank to be prompted
USER_NAME='bit'
USER_PASSWORD='bitmaus' # leave blank to be prompted
TIMEZONE='America/Los_Angeles'

PACKAGES='nano openssh sudo git haproxy python python-pip wget gnupg certbot dialog wpa_supplicant dhcpcd netctl syslinux dhcp xorg-server xorg-xhost xorg-xrandr xorg-xinit xf86-video-intel xterm mesa ntp alsa-utils lvm2'
#imagemagick jdk8-openjdk repo tigervnc rsync hostapd dnsmasq

echo "Enter USB drive location"
stty -echo
read DRIVE
stty echo

setup() {
# make another partion for boot
    sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${DRIVE}
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
  +4G # 100 MB boot parttion
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
  +4G # default, extend partition to end of disk
  n
  p
  3
    # default, start immediately after preceding partition
    # default, start immediately after preceding partition
  t
  1
  b
  t
  2
  8300
  t
  3
  8300
  a # make a partition bootable
  3 # bootable partition is partition 1 -- /dev/sda1
  w # write the partition table
  q # and we're done
EOF

    mkfs.fat "$DRIVE"1
    mkfs.ext4 "$DRIVE"2

    pvcreate "$DRIVE"3
    vgcreate "vg00" "$DRIVE"3
    lvcreate -l '+100%FREE' "vg00" -n root
    vgchange -ay
    mkfs.ext4 -L root /dev/vg00/root

    mount -L root /mnt

    pacstrap /mnt base base-devel linux linux-firmware
    genfstab -U /mnt >> /mnt/etc/fstab
    arch-chroot /mnt /bin/bash

    cp $0 /mnt/setup.sh
    arch-chroot /mnt ./setup.sh chroot
}

configure() {
    pacman-key --init
    pacman-key --populate archlinux
    pacman -Sy --noconfirm $PACKAGES

    echo "$HOSTNAME" > /etc/hostname
    cat "8.8.8.8" >> /etc/resolv.conf # Google

    echo -en "$ROOT_PASSWORD\n$ROOT_PASSWORD" | passwd
    useradd -m -g users -G wheel $USER
    echo -en "$USER_PASSWORD\n$USER_PASSWORD" | passwd $USER

    echo "$USER ALL=(ALL:ALL) ALL" >> /etc/sudoers
    echo "%wheel   ALL=(ALL)   ALL" >> /etc/sudoers

    ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
    timedatectl set-timezone $TIMEZONE
    ntpd -qg
    hwclock --systohc

    cat "AllowUsers $USER" >> /etc/ssh/sshd_config
    cat "AllowGroups wheel" >> /etc/ssh/sshd_config
    cat "Port 22" >> /etc/ssh/sshd_config
    cat "AuthorizedKeysFile ~/.ssh/authorized_keys" >> /etc/ssh/sshd_config
    cat "AuthenticationMethods publickey" >> /etc/ssh/sshd_config #password?

    syslinux-install_update -i -a -m

    git clone tree

    cp ~/tree/splash.png /boot/syslinux/splash.png
    cp ~/tree/syslinux.cfg /boot/syslinux/syslinux.cfg

    #Remove `fsck` from `mkinit`... (/etc/mkinitcpio.conf) add ext4 and lvm2 (after keyboard)

    cp /usr/lib/systemd/system/systemd-fsck-root.service /etc/systemd/system/systemd-fsck-root.service
    cp /usr/lib/systemd/system/systemd-fsck@.service /etc/systemd/system/systemd-fsck@.service

    cat "StandardOutput=null" >> /etc/systemd/system/systemd-fsck@.service
    cat "StandardError=journal+console" >> /etc/systemd/system/systemd-fsck@.service

    mkinitcpio -p linux

    su tree

    git clone https://aur.archlinux.org/mongodb-bin.git
    git clone https://aur.archlinux.org/mongodb-tools-bin.git
    git clone https://aur.archlinux.org/google-chrome.git
    #git clone https://aur.archlinux.org/aosp-devel.git

    cd ~/mongodb-bin
    makepkg -si --noconfirm # repeat steps for each repo
    cd ~/mongodb-tools-bin
    makepkg -si --noconfirm
    cd ~/google-chrome
    makepkg -si --noconfirm

    pip install tornado pymongo pycrypto markdown

    amixer sset Master unmute
}

set -ex

if [ "$1" == "chroot" ]
then
    configure
else
    setup
fi

]

  - Run `systemctl edit getty@tty1` and replace the contents with: **can't in chroot!**
```
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --skip-login --login-options "-f usernamehere" %I 38400 linux
or
ExecStart=-/usr/bin/agetty --skip-login --nonewline --noissue --autologin username --noclear %I $TERM
```