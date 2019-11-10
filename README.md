
## Utopia

A self-propagating stack of infinitive-basis, built on L2 (LAMP 2.0).

<img src="/apt/utopia.png" width="48" height="48" />

Stack includes:

- **apu** (system files)
- **apt** (resource files)
- **apo** (project files)
- **app** (application files)
- **api** (service files)
- **apa** (site index)

**L2** includes:

- Linux
- [Arch Linux](https://www.archlinux.org)
- Mongo
- Python

### apU

Includes "CPU" files closest to hardware to build a working "Bit Bolt" USB. This USB can function as both a client and the server depending on your needs.

Download the [BitBolt image]() and use the `dd if=bitbolt.iso of=/dev/sdX bs=16M && sync`. For Windows, use [Rufus](https://rufus.ie).

Insert the USB and use function keys (Esc, F8, F10) to boot from USB into the Bit Bolt.

 The USB starts with a command-prompt, sign in with user `bit` and password `bitmaus`. Some basic commands include:

```
fdisk -l # list storage drives
ip link show # list network devices
wifi-menu <device> # connect wireless
ping google.com -c 2 # test network
```

- the "bit" client features the [Google Chrome]() web browser featuring the [SSH](https://chrome.google.com/webstore/detail/secure-shell-app/pnhechapfaindjhompbnflcldabbghjo?hl=en) application to streamline development.

 For basic setup, you need to create security keys:

  1. For [SSH](), create a key using `ssh-keygen -t rsa -b 4096 -f secret.key`.

  1. For [SSL](), use `certbot certonly --standalone` or `certbot renew` and see `/etc/letsencrypt/live/<domain>/fullchain.pem|privkey.pem`.

  1. For [LUKS](), use `dd if=/dev/urandom of=KEYFILE bs=1 count=4096`

  1. For GPG [GNU Privacy Guard](https://www.gnupg.org/), used for personal signing and encryption, good for private dealings

	```
	gpg --gen-key
	gpg --output ~/mygpg.key --armor --export your_email@address.com
	gpg --send-keys your_email@address.com --keyserver hkp://subkeys.pgp.net
	```

  1. For [Monero], use

	```
	wget https://downloads.getmonero.org/linux64
	tar -xvf linux64
	./monerod # wait until chain is updated
	./monero-wallet-cli # include name, wallet, view key, 25-word seed[for access]
	address # to get address
	```

 After setup, either start a server or run the browser using `xinit xinitrc`.

- the "bolt" server features an easy way to transfer the system files and start services to handle your applications, data, email, etc.

 To propagate the server,

  1. Partition, format, and mount the drive with:

	```
	parted -s <drive> mkpart primary ext4 1 100%
	mkfs.ext4 <drive>
	mount <drive> /mnt
	```

    1. For encryption,

	```
	dd if=/dev/urandom of=/dev/sdd bs=1M
	cryptsetup -c aes-xts-plain64 -y --use-random --key-size 512 --hash sha512 --iter-time 5000 luksFormat "$dev" --verify-passphrase
	cryptsetup luksAddKey /dev/sda2 ~/tree/drive.key
	cryptsetup open --type luks "$dev" bolt --key-file ~/tree/drive.key
	```

  1. Propagate the stack with,

	```
	cp -ax / /mnt`
	cp /temp/public.key >> /mnt/home/tree?/.ssh/authorized_keys
	cp /temp/ssl_certs >> /mnt/home/ssl_certs
	```

  1. Start the server with `systemd-nspawn -b -D /mnt`

### apT

Resource files are static documents and images that are created beyond the scope of the stack.

### apO

Project "port" files include platform specific applications such as [Android](https://www.android.com) and [iOS]().

### apP

Application files include site files and controls using HTML, CSS, and JavaScript.

### apI

Includes "API" files in [Python]() that run on the server as services.

### apA

The file *apa.htm* is the site index to tie everything together.

