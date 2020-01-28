#!/bin/bash

if [ $EUID -ne 0 ]; then
  echo "You must run this script as root"
  exit 1
fi

DATE=$(date '+%Y%m%d')
TMP_DIR=$(mktemp -d)
CUR_HOSTNAME=$(hostname)
GIT_LOC="https://github.com/krislamo/bootstrap.git"

echo "Enter name server's new hostname:"
read NEW_HOSTNAME

echo "Enter a static IP address (e.g. 192.168.1.2/24):"
read STATIC_IP

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

# If STATIC_IP var was set, backup interfaces and set static IP
if [ ! -z "$STATIC_IP" ]; then
  cp /etc/network/interfaces /etc/network/interfaces.$DATE
  sed -i "s/dhcp/static/g" /etc/network/interfaces
  if ! grep -q "address" /etc/network/interfaces; then
    echo "  address $STATIC_IP" >> /etc/network/interfaces
    echo "  gateway 192.168.1.1" >> /etc/network/interfaces
  fi
fi

hostnamectl set-hostname $NEW_HOSTNAME
cp /etc/hosts /etc/hosts.$DATE
sed -i "s/$CUR_HOSTNAME/$NEW_HOSTNAME/g" /etc/hosts
read -p "Press [enter] to restart this machine"
/sbin/shutdown -r now
