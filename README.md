
## Utopia

A self-propagating stack of infinitive-basis, built on L2 (LAMP 2.0).

<img src="apt/utopia.png" width="48" height="48" />

The stack is organized as:

- ap**U** (system files for a working Linux client/server distro)
- ap**T** (resource files for non-functioning items like images and documents)
- ap**O** (project files for external frameworks like Android and iOS)
- ap**P** (application files for internal site framework)
- ap**I** (service files for server processes to handle data, mail, etc.)
- ap**A** (site index that ties everything together)

**L2** includes:

- [Linux](https://en.wikipedia.org/wiki/Linux)
- [Arch Linux](https://www.archlinux.org)
- [Mongo](https://www.mongodb.com/)
- [Python](https://www.python.org/)

### apU

Steps to build a bootable client/server USB. Nicknamed the *bit bolt*, this USB serves as both working client via browser and command-line, or a distributable server. To start you will need two USBs and a computer that allows booting from USB.

1. Insert the first USB and find its path with `fdisk -l` or a file manager. Next download the [Arch Linux ISO](https://www.archlinux.org/download/) and use the command `dd if=<pathToArchISO> of=/dev/sdX bs=16M && sync`, or for Windows download and run [Rufus](https://rufus.ie).

1. Reboot with USB still inserted, and use function keys (Esc, F8, F10) to boot into Arch Linux.

1. Insert a second USB designated as the "bit bolt", find its path and run `fdisk /dev/<pathToUSB>` to partition. Some basic commands include:

|Command|Description|
|-|-|
|o|Clears the partition table.|
|n|Creates a new partition, must specify primary/extended, number, start, end.|
|t|Change the type of the partition. Use b for Windows, 8300 for Linux.|
|a|Select your boot partition.|
|w|Write changes to disk.|

  Use these commands to create your partitions as follows:

|Partition|Description|
|-|-|
|1|Windows client files (1G)|
|2|Linux client files (1G)|
|3|System files for Linux (remaining space)|

1. Format any Windows partitions with `mkfs.fat <drive>` and Linux partitons with `mkfs.ext4 /dev/sdaX`.

1. For network access, use the following:

```bash
ip link show # list network devices
wifi-menu <device> # connect wireless
ping google.com -c 2 # test network
```

1. Mount, install system files, generate file configuration, and change into the new system's root:

```bash
mount /dev/sdaX /mnt
pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt /bin/bash
```

1. In the new system, install your client/server setup:

```bash
pacman-key --init
pacman-key --populate archlinux
pacman -Sy --noconfirm $PACKAGES

echo "box" > /etc/hostname
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

syslinux-install_update -iam

git clone tree

cp ~/tree/splash.png /boot/syslinux/splash.png
cp ~/tree/syslinux.cfg /boot/syslinux/syslinux.cfg

#Remove `fsck` from `mkinit`... (/etc/mkinitcpio.conf)

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
```

1. Remove the Arch USB and boot into the BitBolt USB, which starts with a command-prompt, sign in with user `bit` and password `bitmaus`.

1. Run `systemctl edit getty@tty1` and replace the contents with:

```
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --skip-login --nonewline --noissue username --noclear %I $TERM
```

Your working BitBolt is complete! See below on how to run the client or install the server.

- the "bit" client features the [Google Chrome](https://www.google.com/chrome/) web browser featuring the [SSH](https://chrome.google.com/webstore/detail/secure-shell-app/pnhechapfaindjhompbnflcldabbghjo?hl=en) extension for command-line work.

 For basic setup, you need to create security keys:

  - [SSH](https://en.wikipedia.org/wiki/Secure_Shell), create a key using `ssh-keygen -t rsa -b 4096 -f secret.key`.

  - [TLS/SSL](https://en.wikipedia.org/wiki/Transport_Layer_Security), use `certbot certonly --standalone` or `certbot renew` and see `/etc/letsencrypt/live/<domain>/fullchain.pem|privkey.pem`.

  - [LUKS](https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup), use `dd if=/dev/urandom of=KEYFILE bs=1 count=4096`

  - GPG, or [GNU Privacy Guard](https://www.gnupg.org/), used for personal signing and encryption, good for private dealings

  ```bash
  gpg --gen-key
  gpg --output ~/mygpg.key --armor --export your_email@address.com
  gpg --send-keys your_email@address.com --keyserver hkp://subkeys.pgp.net
  ```

  - [Monero], run below, then use `./monerod` to update chain or `address` to display your wallet.

```bash
wget https://downloads.getmonero.org/linux64
tar -xvf linux64
./monero-wallet-cli
```

 After setup, either start a server or run the browser using `xinit xinitrc`.

- the "bolt" server features an easy way to transfer the system files and start services to handle your applications, data, email, etc.

 To propagate the server,

  1. Partition, format, and mount the drive with:

```bash
parted -s <drive> mkpart primary ext4 1 100%
mkfs.ext4 <drive>
mount <drive> /mnt
```

  1. (optional) For encryption,

```bash
dd if=/dev/urandom of=/dev/sdd bs=1M
cryptsetup -c aes-xts-plain64 -y --use-random --key-size 512 --hash sha512 --iter-time 5000 luksFormat "$dev" --verify-passphrase
cryptsetup luksAddKey /dev/sda2 ~/tree/drive.key
cryptsetup open --type luks "$dev" bolt --key-file ~/tree/drive.key
```

  1. Propagate the stack with,

```bash
cp -ax / /mnt`
cp /temp/public.key >> /mnt/home/tree?/.ssh/authorized_keys
cp /temp/ssl_certs >> /mnt/home/ssl_certs
```

  1. Start the server with `systemd-nspawn -b -D /mnt`

### apT

Resource files are static documents and images that are created beyond the scope of the stack.

### apO

Project "port" files include platform specific applications such as [Android](https://www.android.com) and [iOS](https://developer.apple.com/ios/).

### apP

Application files include site files and controls using HTML, CSS, and JavaScript.

### apI

Includes "API" files in Python that run on the server as services.

### apA

The file *apa.htm* is the site index to tie everything together.
