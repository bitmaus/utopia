
## Utopia

A self-propagating stack of infinitive-basis, built on L2 (LAMP 2.0).

![utopia](/apt/image/utopia.png)

The stack is organized as:

- ap(**U**), system files for a working Linux client/server distro
- ap(**T**), resource files for non-functioning items like images and documents
- ap(**O**), project files for external frameworks like [Android](https://www.android.com) and [iOS](https://developer.apple.com/ios/)
- ap(**P**), application files for internal site framework using HTML, CSS, and JS
- ap(**I**), service files for server processes to handle data, mail, etc.
- ap(**A**), site index that ties everything together

![lamp](/apt/image/lamp.png)

LAMP 2.0 (**L2**) includes:

- [Linux](https://en.wikipedia.org/wiki/Linux), the free and open source kernel operating system
- [Arch](https://www.archlinux.org), a light-weight, minimal Linux distribution
- [Mongo](https://www.mongodb.com/), a JSON-driven database with flexible NoSQL design
- [Python](https://www.python.org/), the next best thing to C-programming to handle the "heavy" lifting

### apU

Hardware "CPU" files used to support the application. Includes a USB to run in client or server mode.

#### the Bit Bolt USB

This bootable USB serves as both a "bit" client or a distributable "bolt" server. Also works on Linux, Mac, and Windows machines as a functional USB drive.

![usb](/apt/image/usb.png)

To start you will need:

- a USB (16GB or higher)
- a computer running Arch Linux

To run Arch Linux, use an additional USB and download the image from [Arch Linux ISO](https://www.archlinux.org/download/), then:

- For Linux/Mac, find the USB with `fdisk -l` and run `dd if=<pathToArchISO> of=/dev/sd<pathToUSB> bs=16M && sync`.
- For Windows, find the USB using File Explorer, then download and run [Rufus](https://rufus.ie).

Next, with the USB inserted, boot into Arch Linux by pressing the function keys (Esc, F8, F10, etc.) dependent on your computer model during restart.

With Arch Linux running, insert the Bit Bolt USB and run the following:

1. Partition the USB with `fdisk /dev/sd<pathToUSB>` and the following commands:

   |Command|Description|
   |-|-|
   |o|Clears the partition table.|
   |n|Creates a new partition (must specify primary/extended, number, start, end)|
   |t|Change the type of the partition (use `b` for Windows, `8300` for Linux)|
   |a|Select the boot partition|
   |w|Write changes to disk|

   **fdisk** commands

   Create four partitions as follows:

   - primary, 1, type Windows, size `+1G`
   - primary, 2, type Linux, size `+1G`
   - primary, 3, type Windows, size `+1G`, bootable
   - primary, 4, type Linux, size remaining space

1. Format Windows partitions with `mkfs.fat /dev/sd<pathToUSB>` and Linux partitons with `mkfs.ext4 /dev/sd<pathToUSB>`.

1. Make sure you have network access:

   ```bash
   ip link show # list network devices
   wifi-menu <device> # connect wireless
   ping google.com -c 2 # test network
   ```

1. Mount partitions, install system files, generate config files, and change into the new system's root:

   ```bash
   mount /dev/sd<pathToUSB>4 /mnt
   mkdir /mnt/boot
   mount /dev/sd<pathToUSB>3 /mnt/boot
   pacstrap /mnt base base-devel linux linux-firmware
   genfstab -U /mnt >> /mnt/etc/fstab
   arch-chroot /mnt /bin/bash
   ```

1. Install additional packages and configure system:

   ```bash
   pacman-key --init
   pacman-key --populate archlinux
   pacman -Sy --noconfirm nano openssh sudo git haproxy python python-pip wget gnupg certbot dialog wpa_supplicant dhcpcd netctl syslinux dhcp xorg-server xorg-xhost xorg-xrandr xorg-xinit xf86-video-intel xterm mesa ntp alsa-utils arch-install-scripts efibootmgr jdk8-openjdk

   echo "box" > /etc/hostname # replace box with hostname
   cat "8.8.8.8" >> /etc/resolv.conf # use Google nameservers

   passwd
   useradd -m -g users -G wheel bitmaus # replace bitmaus with username (also for below commands)
   passwd bitmaus

   echo "bitmaus ALL=(ALL:ALL) ALL" >> /etc/sudoers
   echo "%wheel   ALL=(ALL)   ALL" >> /etc/sudoers

   ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
   timedatectl set-timezone America/Los_Angeles # replace America/Los_Angeles with timezone
   ntpd -qg
   hwclock --systohc

   echo "AllowUsers bitmaus" >> /etc/ssh/sshd_config
   echo "AllowGroups wheel" >> /etc/ssh/sshd_config
   echo "Port 22" >> /etc/ssh/sshd_config
   echo "AuthorizedKeysFile ~/.ssh/authorized_keys" >> /etc/ssh/sshd_config
   echo "AuthenticationMethods publickey" >> /etc/ssh/sshd_config #password?

   syslinux-install_update -iam
   mkdir -p /boot/EFI/syslinux
   cp -r /usr/lib/syslinux/efi64/* /boot/EFI/syslinux
   efibootmgr --create --disk /dev/sd<pathToUSB>3 --part Y --loader /EFI/syslinux/syslinux.efi --label "Syslinux" --verbose

   git clone https://github.com/bitmaus/utopia

   cp ~/utopia/apu/splash.png /boot/syslinux/splash.png # for custom image, use 'convert -resize 640x480 -depth 16 -colors 65536 my_custom_image.png splash.png'
   # update syslinux.cfg with UUID from /etc/fstab
   cp ~/utopia/apu/syslinux.cfg /boot/EFI/syslinux/syslinux.cfg

   # remove `fsck` from /etc/mkinitcpio.conf

   cp /usr/lib/systemd/system/systemd-fsck-root.service /etc/systemd/system/systemd-fsck-root.service
   cp /usr/lib/systemd/system/systemd-fsck@.service /etc/systemd/system/systemd-fsck@.service
   echo "StandardOutput=null" >> /etc/systemd/system/systemd-fsck@.service
   echo "StandardError=journal+console" >> /etc/systemd/system/systemd-fsck@.service

   mkinitcpio -p linux

   su tree

   git clone https://aur.archlinux.org/mongodb-bin.git
   git clone https://aur.archlinux.org/mongodb-tools-bin.git
   git clone https://aur.archlinux.org/google-chrome.git
   #git clone https://aur.archlinux.org/aosp-devel.git

   cd ~/mongodb-bin
   makepkg -si --noconfirm # repeat steps for each repo

   exit

   pip install tornado pymongo pycrypto markdown

   amixer sset Master unmute

   poweroff
   ```

1. Reboot into the Bit Bolt USB and sign in with your username and password.

1. Run `systemctl edit getty@tty1` and replace the contents with:

   ```
   [Service]
   ExecStart=
   ExecStart=-/usr/bin/agetty --skip-login --nonewline --noissue username --noclear %I $TERM
   ```

The USB is complete! See below for client or server instructions.

##### the bit client

In client mode, use the [Google Chrome](https://www.google.com/chrome/) web browser with the [SSH](https://chrome.google.com/webstore/detail/secure-shell-app/pnhechapfaindjhompbnflcldabbghjo?hl=en) extension for command-line work.

To run the browser use `xinit ~/utopia/apu/xinitrc`.

1. Install needed packages, find graphics with `lspci | grep -e VGA -e 3D`:

Use `xinit` then `xrandr` to display screen resolutions. 

1. Backup and restore

rsync -av --delete "/home/matt/site" "/usr/local/nginx/html" (could add -u to skip files newer on the receiver?)

scp -i ~/.ssh/mytest.key root@192.168.1.1:/<filepath on host>  <path on client> # copy backup files

automate with `crontab -e`, add entry `0 5 * * * rsync -av --delete /media/USBHDD1/shares /media/USBHDD2/shares` to backup at 5am every day.

1. Start a database replica with `mkdir -p /data/db`, then `service mongod start`

1. Get address with `ip address show`. (monero with wallet?)

Your private key should have permission 0600 while your public key have permission 0644.

chmod u+x scriptname # make script executable

chmod 600 file # owner can read and write
chmod 700 file # owner can read, write and execute
chmod 666 file # all can read and write
chmod 777 file # all can read, write and execute

mkdir -p /var/www/treeop
        ...copy over application files
sudo chown -R $USER:$USER /var/www/treeop
sudo chmod -R 755 /var/www/treeop

sudo bash # for continued root access
sudo poweroff  # shutdown
sudo reboot # reboot

ps aux | grep spawn # find process
kill 9 10509        # end process

ls -R > myfile.txt # pull bash history

Use `ssh matt@192.168.1.111 -i ssh.key` and mount partitions to work.

With `nano`, **Esc** + **Shift G** will get you to the beginning of the last line.

For security, use:

- [SSH](https://en.wikipedia.org/wiki/Secure_Shell), for remote access

   ```bash
   ssh-keygen -t rsa -b 4096 -f secret.key
   cat ~/tree/public.key >> ~/.ssh/authorized_keys
   systemctl start sshd
   systemctl enable sshd.socket
   ```

- [TLS/SSL](https://en.wikipedia.org/wiki/Transport_Layer_Security), for site security

   ```bash
   certbot certonly --standalone # see /etc/letsencrypt/live/<domain>/fullchain.pem|privkey.pem
   certbot renew
   ```

- [LUKS](https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup), use `dd if=/dev/urandom of=KEYFILE bs=1 count=4096`

- [GNU Privacy Guard](https://www.gnupg.org/) or GPG, for personal signing and encryption, good for private dealings

   ```bash
   gpg --gen-key
   gpg --output ~/mygpg.key --armor --export your_email@address.com
   gpg --send-keys your_email@address.com --keyserver hkp://subkeys.pgp.net

   gpg --search-keys 'myfriend@his.isp.com' --keyserver hkp://subkeys.pgp.net # get public key
   gpg --import name_of_pub_key_file

   gpg --encrypt --recipient 'Your Name' foo.txt # encrypt, --armor optional
   gpg --encrypt --recipient 'myfriend@his.isp.net' foo.txt

   gpg --output foo.txt --decrypt foo.txt.gpg # decrypt

   gpg --armor --detach-sign your-file.zip --output doc.sig # sign
   gpg --verify doc.sig crucial.tar.gz

   gpg --search-keys 'myfriend@his.isp.com' --keyserver hkp://subkeys.pgp.net
   gpg --import name_of_pub_key_file
   gpg --verify doc.sig crucial.tar.gz
   ```

- [Monero](https://en.wikipedia.org/wiki/Monero_(cryptocurrency)), run below, then use `./monerod` to update chain or `address` to display your wallet.

   ```bash
   wget https://downloads.getmonero.org/linux64
   tar -xvf linux64
   ./monero-wallet-cli
   ```

For keeping track of changes, use [Git](https://git-scm.com/):

1. On remote machine, connect and clone with `ssh-agent bash -c 'ssh-add /somewhere/yourkey; git clone user@server:/path/to/repo/project.git'`.

  > [!NOTE]
  > If there are issues, use `git config core.sshCommand "ssh -i ssh.key"`.

1. Now you can work and make changes remotely:

   ```bash
   cd project
   vim README
   git commit -m 'fix for the README file'
   git push origin master
   ```

   Or push a branch, `ssh-agent bash -c 'ssh-add ../ssh.key; git push matt@192.168.86.184:~/public/site/tree.git branch-name'`.

###### Work with branches and commits

1. Get the latest changes, `sudo git pull` or `git pull upstream master`. For a specific remote branch, `git fetch upstream <branch>`.

  > [!NOTE]
  > If there are issues, resolve and use `:wq` for exiting Git text editor.

1. Switch to the branch:

  - New branch is `git checkout -b <branch>`
  - Switch to branch is `git checkout <branch>`
  - Switch back is `git checkout master`
  - Delete branch is `git branch -d <branch>`

1. Make changes with commit:

   ```bash
   git add <filename>
   git add *
   git commit -m "message"
   git push origin <branch>
   ```

Some things to consider:

- To catch a branch up use `git fetch origin` then `git merge origin/yourbranch`
  
- To merge use `git merge branchone branchtwo`
  
- To update a branch:

   ```bash
   git remote update
   git checkout <branch_name>
   git pull origin <branch_name>
   ```

###### Save and move work

```bash
git stash
# change branches, pull master, etc.
git stash apply
```

Use `git stash pop` to delete stash after applying.
Use `git stash branch <branchName>` to make a branch out of changes.

###### Compare changes

Use `git diff --stat <commit-ish> <commit-ish>`

> [!NOTE]
> `--stat` is for human-readable output, `--numstat` is for a table layout that scripts can interpret. You can also use `git log --author="Your name" --stat <commit1>..<commit2>` (with `--numstat` or `--shortstat` as well)

###### To undo changes

To revert a merged branch use `git revert HEAD` or `git revert -m 1 dd8d6f587fa24327d5f5afd6fa8c3e604189c8d4>`

To undo a commit use `git reset --soft HEAD^` to keep changed files or `git reset --hard HEAD^` to remove changed files.

> [!NOTE]
> If the hard reset was a mistake or something else drastic? Use `git reflog` to view history and then `git reset --hard <commit-number>`. You can then remove individual files with `git reset HEAD path/to/unwanted/file`.

###### Extra information

```bash
git remote add origin new.git.url/here
git remote set-url origin new.git.url/here

secure SSH key... (to only be read by you)
chmod 400 ~/.ssh/id_rsa

git branch -d branchName

git fetch <remote> <sourceBranch>:<destinationBranch>

basic git techniques...?

git checkout BranchB
git merge BranchA
git push origin BranchB

git checkout master
git pull origin master
git merge test
git push origin master # OR...
git pull origin FixForBug
git push origin FixForBug

git reset --soft HEAD^ # if this is a question of moving the mistakenly committed files back to the staging area from the previous commit, without cancelling the changes done to them, OR...
git reset --soft HEAD~1 # Then reset the unwanted files in order to leave them out from the commit:

git reset HEAD path/to/unwanted_file
Now commit again, you can even re-use the same commit message:

git commit -c ORIG_HEAD  

git push origin HEAD:<remoteBranch> # for non-origin repos to master...

git remote add upstream https://github.com/whoever/whatever.git

git fetch upstream # Fetch all the branches of that remote into remote-tracking branches, such as upstream/master:
git pull upstream master

git config --local credential.helper ""

git filter-branch --tree-filter 'rm -rf path/to/your/file' HEAD
```

To test services:

```bash
curl -X GET http://localhost:3000/todos/{_id}
curl -H "Content-Type: application/json" -X POST -d '{"title":"Hello World"}' http://localhost:3000/items
curl -H "Content-Type: application/json" -X PUT -d '{"title":"Good Golly Miss Molly"}' http://localhost:3000/items/{_id}
curl -H "Content-Type: application/json" -X DELETE http://localhost:3000/items/{_id}
```

##### the bolt server

To start a server, partition, format, and mount the drive with:

```bash
parted -s <drive> mkpart primary ext4 1 100%
mkfs.ext4 <drive>
mount <drive> /mnt
```

- For encryption *(optional)*:

   ```bash
   dd if=/dev/urandom of=/dev/sdd bs=1M
   cryptsetup -c aes-xts-plain64 -y --use-random --key-size 512 --hash sha512 --iter-time 5000 luksFormat "$dev" --verify-passphrase
   cryptsetup luksAddKey /dev/sda2 ~/tree/drive.key
   cryptsetup open --type luks "$dev" bolt --key-file ~/tree/drive.key
   ```

Then, propagate the stack with:

```bash
cp -ax / /mnt
cp /temp/public.key >> /mnt/home/tree?/.ssh/authorized_keys
cp /temp/ssl_certs >> /mnt/home/ssl_certs

systemd-nspawn -b -D /mnt
```

To exit container, hold **Ctrl** and press **]** three times.

###### Mongo

See */var/log/mongodb/mongodb.log* for issues. Use database per user approach...

```bash
mongoexport --db Mydb --collection Items229900 --out D:/test.json
mongoimport --db <dbname> --collection <collection-name> --file <json-filename>
```

To usee database run `mongo`, then:

```mongo
use myDb

show dbs
show collections

db.myCollection.insertOne( { x: 1 } );
db.getCollection("stats").find()

db.collection.update( { "_id.name": "Robert Frost", "_id.uid": 0 },
   { "categories": ["poet", "playwright"] },
   { upsert: true } )

db.bios.remove( { } )
db.products.remove( { qty: { $gt: 20 } } )
```

ObjectId("505bd76785ebb509fc183733").getTimestamp();

Since the encrypted folder is mounted, we can see the content of the files. Let’s have a look:

cat /var/lib/mongo-encrypted/mongod.lock
cat /var/lib/mongo-encrypted/mongod.lock

###### Python

append & to commands to run in background (or nohup command &)
...closing terminal terminates applications unless you run disown

###### for remote development

For new developers:

```bash
sudo useradd -m nathan
addgroup developers
sudo usermod -a -G developers nathan # add -G sudo for admin
sudo chown -R :developers /personal_folder
```

Create their key and update SSH, then start git branch, assign port with all changes going to https://dev.bitma.us:specialport.

Give them the private key and change password with `ssh-keygen -p -f ~/.ssh/id_dsa`. This doesn't require any changes to the public key.

*might need to `chmod 700 ~/.ssh`, then `chmod 600 ~/.ssh/authorized_keys`, then `chown $USER:$USER ~/.ssh -R` (for issues, check /var/log/auth.log)

Limit accounts to git shell:

   ```bash
   cat /etc/shells    # see if git-shell exists, if not...
   which git-shell   # make sure git-shell is installed
   sudo vim /etc/shells  # add path to git-shell from last command
   sudo chsh git -s $(which git-shell) # edit shell for a user
   ```

Start a remote repository

   ```bash
   git init --bare # can also use --shared=group
   chown -R tree:tree /path/to/repo # set permissions
   chmod -R g+rw /path/to/repo

   mkdir project # start the repo
   cd project
   git init
   git add .
   git commit -m 'initial commit'
   git remote add origin user@server:/path/to/repo/project.git
   git push origin master
   ```

...then make a [public repo](https://git-scm.com/book/en/v1/Git-on-the-Server-Public-Access):

```bash
cd project.git
mv hooks/post-update.sample hooks/post-update
chmod a+x hooks/post-update
```

###### network commands

```bash
sudo ufw allow 1701    # allow port through firewall

iptables -A FORWARD -i eth1 -s 192.168.1.0/255.255.255.0 -j ACCEPT

ifconfig bridge0 create

ip link add name br0 type bridge
ip addr add 172.20.0.1/16 dev br0
ip link set br0 up
```

### apT

Resource "aptitude" files such as static documents and images created beyond the scope of the stack.

Examples include site specific icons, images, logos, and favicon.  Also *reference* files for dictionary, thesaurus, quotes, recipes, etc.

### apO

Project "port" files for platform specific applications:

#### [Android](https://www.android.com) setup for Google Play (and ad revenue)

/etc/pacman.conf, uncomment multilib
pacman -Syy

android-sdk, android-sdk-build-tools, android-sdk-platform-tools, android-platform

use `archlinux-java` to change environments

search phone settings for apk, usb, under About->Build Number (select 7 times)

```bash
export PROJ=~/utopia/apo/android/app
export BUILD=/opt/android-sdk/build-tools/<version>
export PLATFORM=/opt/android-sdk/platforms/android-<version>/android.jar

rm -rf obj/*
rm -rf src/com/example/helloandroid/R.java

$BUILD/aapt package -f -m -J $PROJ/src -M $PROJ/AndroidManifest.xml -S $PROJ/res -I $PLATFORM
javac -d obj -classpath src -bootclasspath $PLATFORM src/com/bitmaus/*.java #-classpath "src:libs/<your-lib>.jar", -source 1.7 -target 1.7 if errors
./dx --dex --output=$PROJ/bin/classes.dex $PROJ/obj # can add $PROJ/*.jar
./aapt package -f -m -F $PROJ/bin/hello.unaligned.apk -M $PROJ/AndroidManifest.xml -S $PROJ/res -I /opt/android-sdk/platforms/android-19/android.jar
cp $PROJ/bin/classes.dex .
./aapt add $PROJ/bin/hello.unaligned.apk classes.dex

./zipalign -f 4 $PROJ/bin/hello.unaligned.apk $PROJ/bin/hello.apk

keytool -genkeypair -validity 365 -keystore mykey.keystore -keyalg RSA -keysize 2048
./apksigner sign --ks mykey.keystore $PROJ/bin/hello.apk

adb install $PROJ/bin/hello.apk
```

#### [iOS](https://www.apple.com/ios) for App Store submissions

ssh to Mac machine, then with basic XCode project...

```bash
PROJECT_NAME=ExampleApp
BUNDLE_DIR=${PROJECT_NAME}.app
TEMP_DIR=_BuildTemp

rm -rf ${BUNDLE_DIR}
rm -rf ${TEMP_DIR}

mkdir ${BUNDLE_DIR}
mkdir ${TEMP_DIR}

echo → Step 2: Compile Swift Files
SOURCE_DIR=ExampleApp
SWIFT_SOURCE_FILES=${SOURCE_DIR}/*.swift
TARGET=arm64-apple-ios12.0
SDK_PATH=$(xcrun --show-sdk-path --sdk iphoneos)
FRAMEWORKS_DIR=Frameworks
OTHER_FLAGS="-Xlinker -rpath -Xlinker @executable_path/${FRAMEWORKS_DIR}"

swiftc ${SWIFT_SOURCE_FILES} \
  -sdk ${SDK_PATH} \
  -target ${TARGET} \
  -emit-executable \
  ${OTHER_FLAGS} \
  -o ${BUNDLE_DIR}/${PROJECT_NAME}

echo → Step 3: Compile Storyboards
STORYBOARDS=${SOURCE_DIR}/Base.lproj/*.storyboard
STORYBOARD_OUT_DIR=${BUNDLE_DIR}/Base.lproj

mkdir -p ${STORYBOARD_OUT_DIR}

for storyboard_path in ${STORYBOARDS}; do
  ibtool $storyboard_path \
    --compilation-directory ${STORYBOARD_OUT_DIR}
done

echo → Step 4: Process and Copy Info.plist
ORIGINAL_INFO_PLIST=${SOURCE_DIR}/Info.plist
TEMP_INFO_PLIST=${TEMP_DIR}/Info.plist
PROCESSED_INFO_PLIST=${BUNDLE_DIR}/Info.plist
APP_BUNDLE_IDENTIFIER=com.vojtastavik.${PROJECT_NAME}

cp ${ORIGINAL_INFO_PLIST} ${TEMP_INFO_PLIST}

PLIST_BUDDY=/usr/libexec/PlistBuddy
${PLIST_BUDDY} -c "Set :CFBundleExecutable ${PROJECT_NAME}" ${TEMP_INFO_PLIST}
${PLIST_BUDDY} -c "Set :CFBundleIdentifier ${APP_BUNDLE_IDENTIFIER}" ${TEMP_INFO_PLIST}
${PLIST_BUDDY} -c "Set :CFBundleName ${PROJECT_NAME}" ${TEMP_INFO_PLIST}

cp ${TEMP_INFO_PLIST} ${PROCESSED_INFO_PLIST}

echo → Step 5: Copy Swift Runtime Libraries
SWIFT_LIBS_SRC_DIR=/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos
SWIFT_LIBS_DEST_DIR=${BUNDLE_DIR}/${FRAMEWORKS_DIR}
RUNTIME_LIBS=( libswiftCore.dylib libswiftCoreFoundation.dylib libswiftCoreGraphics.dylib libswiftCoreImage.dylib libswiftDarwin.dylib libswiftDispatch.dylib libswiftFoundation.dylib libswiftMetal.dylib libswiftObjectiveC.dylib libswiftQuartzCore.dylib libswiftSwiftOnoneSupport.dylib libswiftUIKit.dylib libswiftos.dylib )

mkdir -p ${BUNDLE_DIR}/${FRAMEWORKS_DIR}

for library_name in "${RUNTIME_LIBS[@]}"; do
  cp ${SWIFT_LIBS_SRC_DIR}/$library_name ${SWIFT_LIBS_DEST_DIR}/
done

echo → Step 6: Code Signing
# ⚠️ YOU NEED TO CHANGE THIS TO YOUR PROFILE ️️⚠️
PROVISIONING_PROFILE_NAME=23a6e9d9-ad3c-4574-832c-be6eb9d51b8c.mobileprovision
EMBEDDED_PROVISIONING_PROFILE=${BUNDLE_DIR}/embedded.mobileprovision

cp ~/Library/MobileDevice/Provisioning\ Profiles/${PROVISIONING_PROFILE_NAME} ${EMBEDDED_PROVISIONING_PROFILE}

# ⚠️ YOU NEED TO CHANGE THIS TO YOUR ID ️️⚠️
TEAM_IDENTIFIER=X53G3KMVA6

XCENT_FILE=${TEMP_DIR}/${PROJECT_NAME}.xcent

${PLIST_BUDDY} -c "Add :application-identifier string ${TEAM_IDENTIFIER}.${APP_BUNDLE_IDENTIFIER}" ${XCENT_FILE}
${PLIST_BUDDY} -c "Add :com.apple.developer.team-identifier string ${TEAM_IDENTIFIER}" ${XCENT_FILE}

security find-identity -v -p codesigning
IDENTITY=E8C36646D64DA3566CB93E918D2F0B7558E78BAA

for lib in ${SWIFT_LIBS_DEST_DIR}/*; do
  codesign \
    --force \
    --timestamp=none \
    --sign ${IDENTITY} \
    ${lib}
done

codesign \
  --force \
  --timestamp=none \
  --entitlements ${XCENT_FILE} \
  --sign ${IDENTITY} \
  ${BUNDLE_DIR}

exit 0

ios-deploy -c
ios-deploy -i 00008020-xxxxxxxxxxxx -b ExampleApp.app
```

### apP

Application files such as site files and controls with HTML, CSS, and JavaScript.

- ui.htm
- data.htm
- user.htm
- editor.htm
- project.htm
- search.htm
- mobile.htm

Also includes *control* for specialized controls like text, input, file, datetime, location, mail, tag, and payment.

### apI

Interface files to run on the server as services with Python. This includes:

- token.py, supports user sign-in with token
- site.py, uses Tornado for asynchronous site hosting and services
- data.py, basic CRUD support for the Mongo database
- mark.py, supports content generation using Markdown
- file.py, downloads and uploads files
- mail.py, email client and server

Also includes *export* section for EPUB support.

See [Python-Markdown](https://python-markdown.github.io/), mail/message service/bot with database-stored templates?
...use cython? minimize js and css, voice control (to text/from text), speech, home automation, replication/backup
...Use a compression such as `gzip`, tar -xvf yourfile.tar

### apA

The *apa.htm* file, a site index to tie everything together.
