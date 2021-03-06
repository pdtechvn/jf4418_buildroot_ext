#!/bin/bash
BOARD_NAME=$2
BOARDS_PATH=$(dirname $(dirname $BASH_SOURCE))
DEPLOY_PATH=$BOARDS_PATH/deploy
OVERLAY_PATH=$BOARDS_PATH/overlays
COMMON_OVERLAY=$OVERLAY_PATH/common
BOARD_OVERLAY=$OVERLAY_PATH/$BOARD_NAME

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

cp -rf $DEPLOY_PATH $BASE_DIR/
cp -rf $COMMON_OVERLAY/* $TARGET_DIR/
cp -rf $BOARD_OVERLAY/* $TARGET_DIR/

cp -r
SSHD_CONFIG=$TARGET_DIR/etc/ssh/sshd_config

if [ -f $SSHD_CONFIG ]; then
    sed -i 's/#PermitRootLogin no/PermitRootLogin yes/g' $SSHD_CONFIG
fi

AVAHID_CONFIG=$TARGET_DIR/etc/avahi/avahi-daemon.conf

if [ -f $AVAHID_CONFIG ]; then
    sed -i 's/#deny-interfaces=eth1/deny-interfaces=wlan0/g' $AVAHID_CONFIG
fi

QT_PROFILE=$TARGET_DIR/etc/profile.d/qapplauncher.sh

if [ -f $QT_PROFILE ]; then
    if [ $BOARD_NAME == "jf4418" ]; then
        sed -i 's/event0/event1/g' $QT_PROFILE
    fi
fi
