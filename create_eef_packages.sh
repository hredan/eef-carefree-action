#!/usr/bin/bash

EEF_VERSION="v1.0.5"

HELP="Paramter:\n
-t\tTARGET all/win64/linux64/linuxarm64/linuxarmv7/macos12/macos14\n
-n\tNAME e.g. can be the name of Repository
e.g. ./eef_payload.sh -t all -n My_Project\n"

ARCHIVE_WIN64="ESPEasyFlasher_win64.zip"
ARCHIVE_LINUX64="ESPEasyFlasher_linux_x64.tar.gz"
ARCHIVE_LINUXARM64="ESPEasyFlasher_linux_arm64.tar.gz"
ARCHIVE_LINUXARMV7="ESPEasyFlasher_linux_armv7.tar.gz"
ARCHIVE_MACOS_INTEL="ESPEasyFlasher_macOS_intel.tar.gz"
ARCHIVE_MACOS_ARM="ESPEasyFlasher_macOS_arm64.tar.gz"

ARCHIVES="./Archives"
TEMP_DIR="./Temp"
EEF_PACKAGE_DIR="./EEF_Packages"

EEP_PACKAGE_DIR=eep_packages

## function to download eef assets
downloadArchives () {
    mkdir -p $ARCHIVES
    LINK="https://github.com/hredan/ESPEASYFLASHER_2.0/releases/download/${EEF_VERSION}/$1"
    # curl -kLSs $LINK -o ./Targets/$1 # -k: allow insecure server connections when using SSL -s: silent mode -S: show error
    if [ ! -f ${ARCHIVES}/$1 ]; then
        curl -L $LINK -o ${ARCHIVES}/$1
    fi
}

## function to download and extract tar.gz archives
downloadExtractGz () {
    downloadArchives $1
    mkdir -p $TEMP_DIR
    rm -rf $TEMP_DIR/*
    tar -xzf $ARCHIVES/$1 -C $TEMP_DIR
}

## function to download and extract zip archives
downloadExtractZip () {
    downloadArchives $1
    mkdir -p $TEMP_DIR
    rm -rf $TEMP_DIR/*
    unzip $ARCHIVES/$1 -d $TEMP_DIR
}

addLogoAndConfig () {
    echo LogoAndConfig Target $1
    if [ -f ./LogoEasyFlash.png ]; then
        cp ./LogoEasyFlash.png $1
    fi

    if [ -f ./ESPEasyFlasherConfig.json ]; then
        cp ./ESPEasyFlasherConfig.json $1
    fi
}

while getopts t:n:h flag
do
    case "${flag}" in
        t) TARGET=${OPTARG};;
        n) NAME=${OPTARG};;
		h) echo -e $HELP; exit 0;
    esac
done

if [ -z $TARGET ]; then
    echo -e $HELP
    exit 1
fi

if [ -z $NAME ]; then
    echo -e $HELP
    exit 1
fi

# cleanup if exists
rm -fr ./$EEP_PACKAGE_DIR
rm -fr ./$EEF_PACKAGE_DIR
rm -fr ./$TEMP_DIR

# create eep packages from artifacts in EEP_PACKAGE_DIR
if [ -d ./artifacts ]; then
    mkdir -p ./$EEP_PACKAGE_DIR
    cd ./artifacts
    for D in *; do
        if [ -d "${D}" ]; then
            echo "${D}"   # your processing here
            cd ./${D}
            zip -r ../../$EEP_PACKAGE_DIR/${D}.eep .
            cd ..
        fi
    done
    cd ..
fi

mkdir -p $EEF_PACKAGE_DIR

if [ $TARGET = "linux_x64" ] || [ $TARGET = "all" ]; then
    echo "linux64 payload"
    downloadExtractGz $ARCHIVE_LINUX64
    cp ./$EEP_PACKAGE_DIR/*.eep $TEMP_DIR/ESP_Packages
    addLogoAndConfig $TEMP_DIR/ESP_Packages
    tar -czf ${EEF_PACKAGE_DIR}/${ARCHIVE_LINUX64}_$NAME -C $TEMP_DIR .
fi

if [ $TARGET = "linux_arm64" ] || [ $TARGET = "all" ]; then
    echo "linuxarm64 payload"
    downloadExtractGz $ARCHIVE_LINUXARM64
    cp ./$EEP_PACKAGE_DIR/*.eep $TEMP_DIR/ESPEasyFlasher/ESP_Packages
    addLogoAndConfig $TEMP_DIR/ESPEasyFlasher
    tar -czf ${EEF_PACKAGE_DIR}/${ARCHIVE_LINUXARM64}_$NAME -C $TEMP_DIR .
fi

if [ $TARGET = "linux_armv7" ] || [ $TARGET = "all" ]; then
    echo "linuxarmv7 payload"
    downloadExtractGz $ARCHIVE_LINUXARMV7
    cp ./$EEP_PACKAGE_DIR/*.eep $TEMP_DIR/ESPEasyFlasher/ESP_Packages
    addLogoAndConfig $TEMP_DIR/ESPEasyFlasher
    tar -czf ${EEF_PACKAGE_DIR}/${ARCHIVE_LINUXARMV7}_$NAME -C $TEMP_DIR .
fi

if [ $TARGET = "macos_intel" ] || [ $TARGET = "all" ]; then
    echo "macos_intel payload"
    downloadExtractGz $ARCHIVE_MACOS_INTEL
    cp ./$EEP_PACKAGE_DIR/*.eep $TEMP_DIR/ESPEasyFlasher.app/Contents/MacOS/ESP_Packages
    addLogoAndConfig $TEMP_DIR/ESPEasyFlasher.app/Contents/MacOS
    tar -czf ${EEF_PACKAGE_DIR}/${ARCHIVE_MACOS_INTEL}_$NAME -C $TEMP_DIR .
fi

if [ $TARGET = "macos_arm64" ] || [ $TARGET = "all" ]; then
    echo "macos14 payload"
    downloadExtractGz $ARCHIVE_MACOS_ARM
    cp ./$EEP_PACKAGE_DIR/*.eep $TEMP_DIR/ESPEasyFlasher.app/Contents/MacOS/ESP_Packages
    addLogoAndConfig $TEMP_DIR/ESPEasyFlasher.app/Contents/MacOS
    tar -czf ${EEF_PACKAGE_DIR}/${ARCHIVE_MACOS_ARM}_$NAME -C $TEMP_DIR .
fi

if [ $TARGET = "win64" ] || [ $TARGET = "all" ]; then
    echo "win64 payload"
    downloadExtractZip $ARCHIVE_WIN64
    cp ./$EEP_PACKAGE_DIR/*.eep $TEMP_DIR/ESPEasyFlasher/ESP_Packages
    addLogoAndConfig $TEMP_DIR/ESPEasyFlasher
    cd $TEMP_DIR
    zip -r ../${EEF_PACKAGE_DIR}/${ARCHIVE_WIN64}_$NAME ./ESPEasyFlasher
    cd ..
fi