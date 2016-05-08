#!/bin/bash

SCRIPTS="$(cd "$(dirname $0)"; pwd)"

CONF="/mnt/common/config/config.dev.xml"
HOST="192.168.0.1"
PASS="123456"

echo "$SCRIPTS/iog/import_config.ssh.sh -c $CONF -h $HOST -p $PASS"
eval "$SCRIPTS/iog/import_config.ssh.sh -c $CONF -h $HOST -p $PASS"
