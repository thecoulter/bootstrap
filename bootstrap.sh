#!/bin/bash

DATE=$(date '+%Y%m%d')
TMP_DIR=$(mktemp -d)
SOURCE_FILE="/etc/apt/sources.list"
GIT_LOC="https://github.com/krislamo/bootstrap.git"

mv $SOURCE_FILE $SOURCE_FILE.$DATE
sed '/deb cdrom/d' $SOURCE_FILE.$DATE > $SOURCE_FILE

apt-get update -y
apt-get upgrade -y
apt-get install git -y

cd $TMP_DIR
git clone $GIT_LOC
cd bootstrap
