
## upcoming features

flag gadget

layered budget spreadsheet

use "picture" codes in spy game, use algorithm to automate drawing? linux FPS


### dev and entertainment builds

see Inkscape, GIMP, Blender, OpenShot, FreeCAD, [Unreal](https://www.unrealengine.com), https://www.khronos.org/ (for OpenGL and Vulkan)

Unreal/VLC supports game streaming, use video cards and MiraCast, need [Ubuntu](http://www.ubuntu.com)?

Process uses x86-64 machines, try to cross-compile Arch Linux to run on any chip [here](https://archlinuxarm.org/wiki/Distcc_Cross-Compiling).
https://www.linuxjournal.com/article/8957 and https://www.linuxjournal.com/content/diy-build-custom-minimal-linux-distribution-source

(security checksum?)

xargs mv -t /app/dest/ < /tmp/list.txt # move file by list in file

PACKAGES=''
#imagemagick jdk8-openjdk repo tigervnc rsync hostapd dnsmasq 

1. Install needed packages, find graphics with `lspci | grep -e VGA -e 3D`:

convert -resize 640x480 -depth 16 -colors 65536 my_custom_image.png splash.png

1. Mount the fat and ext4 extra partitions.

(get public key)
gpg --search-keys 'myfriend@his.isp.com' --keyserver hkp://subkeys.pgp.net
gpg --import name_of_pub_key_file

(encrypt) *--armor optional
gpg --encrypt --recipient 'Your Name' foo.txt
gpg --encrypt --recipient 'myfriend@his.isp.net' foo.txt

(decrypt)
gpg --output foo.txt --decrypt foo.txt.gpg

(sign)
gpg --armor --detach-sign your-file.zip --output doc.sig
gpg --verify doc.sig crucial.tar.gz

gpg --search-keys 'myfriend@his.isp.com' --keyserver hkp://subkeys.pgp.net
gpg --import name_of_pub_key_file
gpg --verify doc.sig crucial.tar.gz

    cat ~/tree/public.key >> ~/.ssh/authorized_keys
    systemctl start sshd
    systemctl enable sshd.socket

1. Start a remote repository with `git init --bare` (and `--shared=group`?) then set permissions:
```
chown -R tree:tree /path/to/repo
chmod -R g+rw /path/to/repo
```

...and start the repo locally or remotely:
```
mkdir project
cd project
git init
git add .
git commit -m 'initial commit'
git remote add origin user@server:/path/to/repo/project.git
git push origin master
```

Use `xinit` then `xrandr` to display screen resolutions. 


1. Backup and restore

rsync -av --delete "/home/matt/site" "/usr/local/nginx/html" (could add -u to skip files newer on the receiver?)

scp -i ~/.ssh/mytest.key root@192.168.1.1:/<filepath on host>  <path on client> # copy backup files

automate with `crontab -e`, add entry `0 5 * * * rsync -av --delete /media/USBHDD1/shares /media/USBHDD2/shares` to backup at 5am every day.

1. Start a database replica with `mkdir -p /data/db`, then `service mongod start`

1. Get address with `ip address show`. (monero with wallet?)

Your private key should have permission 0600 while your public key have permission 0644.

append & to commands to run in background (or nohup command &)
...closing terminal terminates applications unless you run disown

chmod u+x scriptname # make script executable

chmod 600 file # owner can read and write
chmod 700 file # owner can read, write and execute
chmod 666 file # all can read and write
chmod 777 file # all can read, write and execute

mkdir -p /var/www/treeop
        ...copy over application files
sudo chown -R $USER:$USER /var/www/treeop
sudo chmod -R 755 /var/www/treeop
        cd site

sudo bash # for continued root access
sudo poweroff  # shutdown
sudo reboot # reboot

ps aux | grep spawn # find process
kill 9 10509        # end process

ls -R > myfile.txt # pull bash history

sudo ufw allow 1701    # allow port through firewall

iptables -A FORWARD -i eth1 -s 192.168.1.0/255.255.255.0 -j ACCEPT

ifconfig bridge0 create

ip link show

ip link add name br0 type bridge
ip addr add 172.20.0.1/16 dev br0
ip link set br0 up

...clone git repo also...

hold Ctrl and press ']' three times...



The L2 stack includes:<br/>
            <ul>
                <li><span class="bullet">L (inux)</span>, the free and open source kernel operating system</li>
                <li><span class="bullet">A (rch)</span>, the most simple and easy-to-use distribution</li>
                <li><span class="bullet">M (ongo)</span>, a JSON-driven database with flexible NoSQL design</li>
                <li><span class="bullet">P (ython)</span>, the next best thing to C-programming, handles all the "heavy" lifting</li></ul>

## Python and [Mongo](https://docs.mongodb.com)

`mongoimport --db <dbname> --collection <collection-name> --file <json-filename>'

See [Python-Markdown](https://python-markdown.github.io/), mail/message service/bot with database-stored templates? 
...use cython? minimize js and css, voice control (to text/from text), speech, home automation, replication/backup
...Use a compression such as `gzip`, tar -xvf yourfile.tar

test portion...
curl -X GET http://localhost:3000/todos/{_id}
curl -H "Content-Type: application/json" -X POST -d '{"title":"Hello World"}' http://localhost:3000/items    
curl -H "Content-Type: application/json" -X PUT -d '{"title":"Good Golly Miss Molly"}' http://localhost:3000/items/{_id}     
curl -H "Content-Type: application/json" -X DELETE http://localhost:3000/items/{_id}

use myNewDatabase
db.myCollection.insertOne( { x: 1 } );
db.getCollection("stats").find()

use database per user approach...

/var/log/mongodb/mongodb.log

$ mongo
> use myDb

show dbs
show collections

mongoexport --db Mydb --collection Items229900 --out D:/test.json

db.collection.update( { "_id.name": "Robert Frost", "_id.uid": 0 },
   { "categories": ["poet", "playwright"] },
   { upsert: true } )

db.bios.remove( { } )
db.products.remove( { qty: { $gt: 20 } } )

ObjectId("505bd76785ebb509fc183733").getTimestamp();

Since the encrypted folder is mounted, we can see the content of the files. Let’s have a look:

cat /var/lib/mongo-encrypted/mongod.lock
cat /var/lib/mongo-encrypted/mongod.lock

http://feeds.bbci.co.uk/news/rss.xml

use calendar stickers, hour glass, agenda, with online/phone booking for automated check-in

email/newsletter? 

http_server = httpserver.HTTPServer(application1)
http_server.listen(8080)    # NOTE - port 8080

...
http_server2 = httpserver.HTTPServer(application2)
http_server2.listen(8081)   # NOTE - port 8081

ioloop.IOLoop.instance().start()


import tornado.httpserver
import tornado.ioloop
import tornado.web

class getToken(tornado.web.RequestHandler):
    def get(self):
        self.write("hello")

application = tornado.web.Application([
    (r'/', getToken),
])

if __name__ == '__main__':
    http_server = tornado.httpserver.HTTPServer(application, ssl_options={
        "certfile": "/var/pyTest/keys/ca.csr",
        "keyfile": "/var/pyTest/keys/ca.key",
    })
    http_server.listen(443)
    tornado.ioloop.IOLoop.instance().start()

for easy site/app development
...pymongo new/update/delete/search -> json object -> javascript class
...var note = new Pymp() ...add properties ...or .mp files?
note.sync();
note.

## [Git](https://git-scm.com/)

1. On remote machine, connect and clone with `ssh-agent bash -c 'ssh-add /somewhere/yourkey; git clone user@server:/path/to/repo/project.git'`.

  > [!NOTE]
  > If there are issues, use `git config core.sshCommand "ssh -i ssh.key"`.

1. Now you can work and make changes remotely:

```
	cd project
	vim README
	git commit -m 'fix for the README file'
	git push origin master
```

   Or push a branch, `ssh-agent bash -c 'ssh-add ../ssh.key; git push matt@192.168.86.184:~/public/site/tree.git branch-name'`.

### Work with branches and commits

1. Get the latest changes, `sudo git pull` or `git pull upstream master`. For a specific remote branch, `git fetch upstream <branch>`.

  > [!NOTE]
  > If there are issues, resolve and use `:wq` for exiting Git text editor.

1. Switch to the branch:

  - New branch is `git checkout -b <branch>`
  - Switch to branch is `git checkout <branch>`
  - Switch back is `git checkout master`
  - Delete branch is `git branch -d <branch>`

1. Make changes with commit:

```
	git add <filename>
	git add *
	git commit -m "message"
    git push origin <branch>
```

Some things to consider:

- To catch a branch up use `git fetch origin` then `git merge origin/yourbranch`
  
- To merge use `git merge branchone branchtwo`
  
- To update a branch:

```
	git remote update
	git checkout <branch_name>
	git pull origin <branch_name>
```

### Save and move work

```
	git stash
	# change branches, pull master, etc.
	git stash apply
```

Use `git stash pop` to delete stash after applying.
Use `git stash branch <branchName>` to make a branch out of changes.

### Compare changes

Use `git diff --stat <commit-ish> <commit-ish>`

> [!NOTE]
> `--stat` is for human-readable output, `--numstat` is for a table layout that scripts can interpret. You can also use `git log --author="Your name" --stat <commit1>..<commit2>` (with `--numstat` or `--shortstat` as well)

### To undo changes

To revert a merged branch use `git revert HEAD` or `git revert -m 1 dd8d6f587fa24327d5f5afd6fa8c3e604189c8d4>`

To undo a commit use `git reset --soft HEAD^` to keep changed files or `git reset --hard HEAD^` to remove changed files.

> [!NOTE]
> If the hard reset was a mistake or something else drastic? Use `git reflog` to view history and then `git reset --hard <commit-number>`. You can then remove individual files with `git reset HEAD path/to/unwanted/file`.

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
git push origin master

...or

git pull origin FixForBug
git push origin FixForBug

git issues...
I think other answers here are wrong, because this is a question of moving the mistakenly committed files back to the staging area from the previous commit, without cancelling the changes done to them. 

git reset --soft HEAD^ 
or

git reset --soft HEAD~1
Then reset the unwanted files in order to leave them out from the commit:

git reset HEAD path/to/unwanted_file
Now commit again, you can even re-use the same commit message:

git commit -c ORIG_HEAD  

for non-origin repos to master...
git push origin HEAD:<remoteBranch> 

### for remote developers

- hire developer (create user on dev machine, assign a port, send key)
    - need to run ssh, git and start branch
    - all changes go to https://dev.treeop.com:specialport

1. Give them the private key and change password with `ssh-keygen -p -f ~/.ssh/id_dsa`. This doesn't require any changes to the public key.

1. Limit accounts to git shell:

```
    cat /etc/shells    # see if git-shell exists, if not...
    which git-shell   # make sure git-shell is installed
    sudo vim /etc/shells  # add path to git-shell from last command
    sudo chsh git -s $(which git-shell) # edit shell for a user
```

sudo useradd -m nathan, or Add new users with `adduser username`
addgroup editors
sudo usermod -a -G readers nathan (or `usermod -a -G sudo username` for admin)

sudo chown -R :readers /READERS

`ssh matt@192.168.1.111 -i ssh.key`

*might need to `chmod 700 ~/.ssh`, then `chmod 600 ~/.ssh/authorized_keys`, then `chown $USER:$USER ~/.ssh -R` (for issues, check /var/log/auth.log)


git remote add upstream https://github.com/whoever/whatever.git

# Fetch all the branches of that remote into remote-tracking branches,
# such as upstream/master:

git fetch upstream
git pull upstream master

## [Android]() setup for Google Play (and ad revenue)

```
AAPT="/path/to/android-sdk/build-tools/23.0.3/aapt"
DX="/path/to/android-sdk/build-tools/23.0.3/dx"
ZIPALIGN="/path/to/android-sdk/build-tools/23.0.3/zipalign"
APKSIGNER="/path/to/android-sdk/build-tools/26.0.1/apksigner" # /!\ version 26
PLATFORM="/path/to/android-sdk/platforms/android-19/android.jar"

rm -rf obj/*
rm -rf src/com/example/helloandroid/R.java

$AAPT package -f -m -J src -M AndroidManifest.xml -S res -I $PLATFORM

javac -d obj -classpath src -bootclasspath $PLATFORM -source 1.7 -target 1.7 src/com/example/helloandroid/MainActivity.java
javac -d obj -classpath src -bootclasspath $PLATFORM -source 1.7 -target 1.7 src/com/example/helloandroid/R.java

echo "Translating in Dalvik bytecode..."
$DX --dex --output=classes.dex obj

echo "Making APK..."
$AAPT package -f -m -F bin/hello.unaligned.apk -M AndroidManifest.xml -S res -I $PLATFORM
$AAPT add bin/hello.unaligned.apk classes.dex

echo "Aligning and signing APK..."
$APKSIGNER sign --ks mykey.keystore bin/hello.unaligned.apk
$ZIPALIGN -f 4 bin/hello.unaligned.apk bin/hello.apk

if [ "$1" == "test" ]; then
	echo "Launching..."
	adb install -r bin/hello.apk
	adb shell am start -n com.example.helloandroid/.MainActivity
fi

export PROJ=path/to/HelloAndroid

cd /opt/android-sdk/build-tools/26.0.1/
./aapt package -f -m -J $PROJ/src -M $PROJ/AndroidManifest.xml -S $PROJ/res -I /opt/android-sdk/platforms/android-19/android.jar

cd /path/to/AndroidHello
javac -d obj -classpath src -bootclasspath /opt/android-sdk/platforms/android-19/android.jar src/com/example/helloandroid/*.java
javac -d obj -classpath "src:libs/<your-lib>.jar" -bootclasspath /opt/android-sdk/platforms/android-19/android.jar src/com/example/helloandroid/*.java

---
cd /opt/android-sdk/build-tools/26.0.1/
./dx --dex --output=$PROJ/bin/classes.dex $PROJ/obj
-or-
./dx --dex --output=$PROJ/bin/classes.dex $PROJ/*.jar $PROJ/obj
---

possible errors, try,
cd /path/to/AndroidHello
javac -d obj -source 1.7 -target 1.7 -classpath src -bootclasspath /opt/android-sdk/platforms/android-19/android.jar src/com/example/helloandroid/*.java

./aapt package -f -m -F $PROJ/bin/hello.unaligned.apk -M $PROJ/AndroidManifest.xml -S $PROJ/res -I /opt/android-sdk/platforms/android-19/android.jar
cp $PROJ/bin/classes.dex .
./aapt add $PROJ/bin/hello.unaligned.apk classes.dex

keytool -genkeypair -validity 365 -keystore mykey.keystore -keyalg RSA -keysize 2048

./apksigner sign --ks mykey.keystore $PROJ/bin/hello.apk

./zipalign -f 4 $PROJ/bin/hello.unaligned.apk $PROJ/bin/hello.apk

adb install $PROJ/bin/hello.apk
adb shell am start -n com.example.helloandroid/.MainActivity

to log errors, use this before,
adb logcat


## [iOS](https://www.apple.com/ios) for App Store submissions

#!/bin/bash
PROJECT_NAME=ExampleApp
BUNDLE_DIR=${PROJECT_NAME}.app
TEMP_DIR=_BuildTemp

if [ "$1" = "--device" ]; then
  BUILDING_FOR_DEVICE=true
fi

if [ "${BUILDING_FOR_DEVICE}" = true ]; then
  echo 👍 Bulding ${PROJECT_NAME} for device
else
  echo 👍 Bulding ${PROJECT_NAME} for simulator
fi

echo → Step 1: Prepare Working Folders
rm -rf ${BUNDLE_DIR}
rm -rf ${TEMP_DIR}

mkdir ${BUNDLE_DIR}
mkdir ${TEMP_DIR}

echo → Step 2: Compile Swift Files
SOURCE_DIR=ExampleApp
SWIFT_SOURCE_FILES=${SOURCE_DIR}/*.swift
TARGET=""
SDK_PATH=""

if [ "${BUILDING_FOR_DEVICE}" = true ]; then
  TARGET=arm64-apple-ios12.0
  SDK_PATH=$(xcrun --show-sdk-path --sdk iphoneos)
  FRAMEWORKS_DIR=Frameworks
  OTHER_FLAGS="-Xlinker -rpath -Xlinker @executable_path/${FRAMEWORKS_DIR}"
else
  TARGET=x86_64-apple-ios12.0-simulator
  SDK_PATH=$(xcrun --show-sdk-path --sdk iphonesimulator)
fi

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

if [ "${BUILDING_FOR_DEVICE}" != true ]; then
  exit 0
fi

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

...or use?...

ssh to Mac machine, then with basic XCode project...

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
  --sign ${IDENTITY} \
  --entitlements ${XCENT_FILE} \
  ${BUNDLE_DIR}

ios-deploy -c
ios-deploy -i 00008020-xxxxxxxxxxxx -b ExampleApp.app



git config --local credential.helper ""

git filter-branch --tree-filter 'rm -rf path/to/your/file' HEAD


#!/bin/bash

HOSTNAME='bolt' # variable names

echo "Enter USB drive location"
stty -echo
read DRIVE
stty echo

setup() {
}

set -ex

if [ "$1" == "chroot" ]
then
    configure
else
    setup
fi

echo -en "$ROOT_PASSWORD\n$ROOT_PASSWORD" | passwd
useradd -m -g users -G wheel $USER
echo -en "$USER_PASSWORD\n$USER_PASSWORD" | passwd $USER

echo "$USER ALL=(ALL:ALL) ALL" >> /etc/sudoers
echo "%wheel   ALL=(ALL)   ALL" >> /etc/sudoers


ESC + Shift G will get you to the beginning of the last line


Installation on UEFI
Note: In the commands related to UEFI, esp denotes the mountpoint of the EFI system partition aka ESP.
Install the syslinux and efibootmgr packages from the official repositories. Then setup Syslinux in the ESP as follows:
Copy Syslinux files to ESP:
# mkdir -p esp/EFI/syslinux
# cp -r /usr/lib/syslinux/efi64/* esp/EFI/syslinux
Setup boot entry for Syslinux using efibootmgr:
# efibootmgr --create --disk /dev/sdX --part Y --loader /EFI/syslinux/syslinux.efi --label "Syslinux" --verbose
where /dev/sdXY is the partition containing the bootloader.

Create or edit esp/EFI/syslinux/syslinux.cfg by following #Configuration.
Note:
The config file for UEFI is esp/EFI/syslinux/syslinux.cfg, not /boot/syslinux/syslinux.cfg. Files in /boot/syslinux/ are BIOS specific and not related to UEFI Syslinux.
When booted in BIOS mode, efibootmgr will not be able to set EFI nvram entry for /EFI/syslinux/syslinux.efi. To work around, place resources at the default EFI location: esp/EFI/syslinux/* -> esp/EFI/BOOT/* and esp/EFI/syslinux/syslinux.efi -> esp/EFI/BOOT/bootx64.efi