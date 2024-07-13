#!/usr/bin/bash

EEF_VERSION="v1.0.1"

HELP="Paramter:\n
-t\tTARGET all/win64/linux64/linuxarm64/linuxarmv7/macos12/macos14\n
e.g. ./eef_payload.sh -t all\n"

ARCHIVE_WIN64="espeasyflasher_win64.zip"
ARCHIVE_LINUX64="ESPEasyFlasher_linux_x64.tar.gz"
ARCHIVE_LINUXARM64="ESPEasyFlasher_linux_arm64.tar.gz"
ARCHIVE_LINUXARMV7="ESPEasyFlasher_linux_armv7.tar.gz"
ARCHIVE_MACOS12="ESPEasyFlasher_macOs12_intel.tar.gz"
ARCHIVE_MACOS14="ESPEasyFlasher_macOs14_arm64.tar.gz"

ARCHIVES="./Archives"
TEMP_DIR="./Temp"
WITH_PAYLOAD="./WithPayload"

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


while getopts t:h flag
do
    case "${flag}" in
        t) TARGET=${OPTARG};;
		h) echo -e $HELP; exit 0;
    esac
done

if [ -z $TARGET ]; then
    echo -e $HELP
    exit 1
fi

mkdir -p $WITH_PAYLOAD
mkdir -p $WITH_PAYLOAD

if [ $TARGET = "linux64" ] || [ $TARGET = "all" ]; then
    echo "linux64 payload"
    downloadExtractGz $ARCHIVE_LINUX64
    cp ./Artifacts/*.eep $TEMP_DIR/ESP_Packages
    tar -czf ${WITH_PAYLOAD}/${ARCHIVE_LINUX64} -C $TEMP_DIR .
fi

if [ $TARGET = "linuxarm64" ] || [ $TARGET = "all" ]; then
    echo "linuxarm64 payload"
    downloadExtractGz $ARCHIVE_LINUXARM64
    cp ./Artifacts/*.eep $TEMP_DIR/ESPEasyFlasher/ESP_Packages
    tar -czf ${WITH_PAYLOAD}/${ARCHIVE_LINUXARM64} -C $TEMP_DIR .
fi

if [ $TARGET = "linuxarmv7" ] || [ $TARGET = "all" ]; then
    echo "linuxarmv7 payload"
    downloadExtractGz $ARCHIVE_LINUXARMV7
    cp ./Artifacts/*.eep $TEMP_DIR/ESPEasyFlasher/ESP_Packages
    tar -czf ${WITH_PAYLOAD}/${ARCHIVE_LINUXARMV7} -C $TEMP_DIR .
fi

if [ $TARGET = "macos12" ] || [ $TARGET = "all" ]; then
    echo "macos12 payload"
    downloadExtractGz $ARCHIVE_MACOS12
    cp ./Artifacts/*.eep $TEMP_DIR/ESPEasyFlasher.app/Contents/MacOS/ESP_Packages
    tar -czf ${WITH_PAYLOAD}/${ARCHIVE_MACOS12} -C $TEMP_DIR .
fi

if [ $TARGET = "macos14" ] || [ $TARGET = "all" ]; then
    echo "macos14 payload"
    downloadExtractGz $ARCHIVE_MACOS14
    cp ./Artifacts/*.eep $TEMP_DIR/ESPEasyFlasher.app/Contents/MacOS/ESP_Packages
    tar -czf ${WITH_PAYLOAD}/${ARCHIVE_MACOS14} -C $TEMP_DIR .
fi

if [ $TARGET = "win64" ] || [ $TARGET = "all" ]; then
    echo "win64 payload"
    downloadExtractZip $ARCHIVE_WIN64
    cp ./Artifacts/*.eep $TEMP_DIR/ESPEasyFlasher/ESP_Packages
    cd $TEMP_DIR
    zip -r ../${WITH_PAYLOAD}/${ARCHIVE_WIN64} ./ESPEasyFlasher
    cd ..
fi