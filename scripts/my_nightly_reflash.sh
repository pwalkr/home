#!/bin/bash

SCRIPTS="$(cd "$(dirname $0)"; pwd)"

BOOT="/mnt/net/G/nightly_latest/nightly-dev-btg25_sng25-bootfs.jffs2"
ROOT="/mnt/net/G/nightly_latest/nightly-dev-btg25_sng25-rootfs.jffs2"
CONF="/mnt/common/config/config.dev.xml"
HOST="192.168.0.1"
PASS="123456"
SAVE="n"

echo "$SCRIPTS/iog/reflash.ssh.sh -b $BOOT -r $ROOT -h $HOST -p $PASS -s $SAVE"
eval "$SCRIPTS/iog/reflash.ssh.sh -b $BOOT -r $ROOT -h $HOST -p $PASS -s $SAVE" || exit 1

echo "Device is reflashing. Please give it some time to reboot and generate keys"
read -rsp $'Press any key to continue when it is done...\n' -n1 key

echo "$SCRIPTS/iog/import_config.ssh.sh -c $CONF -h $HOST -p $CONF"
eval "$SCRIPTS/iog/import_config.ssh.sh -c $CONF -h $HOST -p $CONF"
