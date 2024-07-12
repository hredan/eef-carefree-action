#!/usr/bin/bash

EEF_VERSION="v1.0.1"

HELP="Paramter:\n
-t\tTARGET all/win64/linux64/linuxarm64/linuxarmv7/macos12/macos14\n
e.g. ./eef_payload.sh -t all\n"

ARCHIVE_WIN64="espeasyflasher_win64.zip"
ARCHIVE_LINUX64="ESPEasyFlasher_linux_x64.tar.gz"
ARCHIVE_LINUXARM64="ESPEasyFlasher_linux_arm64.tar.gz"
ARCHIVE_LINUXARMV7="ESPEasyFlasher_linux_armv7.tar.gz"
ARCHIVE_MACOS12="ESPEasyFlasher_macos12.tar.gz"
ARCHIVE_MACOS14="ESPEasyFlasher_macos14.tar.gz"

print_something () {
    echo Hello $1
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

if [ $TARGET = "linux64" ] || [ $TARGET = "all" ]; then
    echo "linux64 payload"
    print_something "linux64"
    # LINK="https://github.com/hredan/ESPEASYFLASHER_2.0/releases/download/${EEF_VERSION}/${EEF_ARCHIVE_NAME_LINUX64}"
    # curl -kLSs $LINK_LINUX64 -o $EEF_ARCHIVE_NAME_LINUX64

    # mkdir ./ESP_Packages
    # cp *.eep ./ESP_Packages
    # tar -xzf $EEF_ARCHIVE_NAME_LINUX64 ./ESP_Packages/*.*
fi




