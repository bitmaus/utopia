# utopia
the stack of infinitive-basis

![utopia](/apt/utopia.png)


files are divided into:

- apu (system files for hardware)
- apt (resource files such as documents, images, and site indices)
- apo (project files for android, ios)
- api (service files in python)
- apa (this document)

![utopia](/apt/bit_bolt)

## [Android](https://www.android.com) setup for Google Play (and ad revenue)

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


flag gadget

layered budget spreadsheet

use "picture" codes in spy game, use algorithm to automate drawing? linux FPS
