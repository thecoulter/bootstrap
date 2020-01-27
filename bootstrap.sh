#!/bin/bash

if [ $EUID -ne 0 ]; then
  echo "You must run this script as root"
  exit 1
fi

DATE=$(date '+%Y%m%d')
TMP_DIR=$(mktemp -d)
GIT_LOC="https://github.com/krislamo/bootstrap.git"

echo "Enter name server's new hostname:"
read NEW_HOSTNAME

cp /etc/apt/sources.list /etc/apt/sources.list.$DATE
sed -i '/deb cdrom/d' /etc/apt/sources.list

apt-get update -y
apt-get upgrade -y
apt-get install git -y

cd $TMP_DIR
git clone $GIT_LOC
cd bootstrap

mkdir -p /root/.ssh/
cp --update authorized_keys /root/.ssh/authorized_keys
apt-get install openssh-server -y

hostnamectl set-hostname $NEW_HOSTNAME
cp /etc/hosts /etc/hosts.$DATE
sed -i "s/test/$NEW_HOSTNAME/g" /etc/hosts
read -p "Press [enter] to restart this machine"
systemctl reboot
