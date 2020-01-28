#!/bin/bash

# Root required
if [ $EUID -ne 0 ]; then
  echo "You must run this script as root"
  exit 1
fi

# Get current date, hostname, create a temporary directory,
# and set the location to the remote repository
DATE=$(date '+%Y%m%d')
TMP_DIR=$(mktemp -d)
CUR_HOSTNAME=$(hostname)
GIT_LOC="https://github.com/krislamo/bootstrap.git"

# Get user input for hostname and IP
echo "Enter name server's new hostname:"
read NEW_HOSTNAME

echo "Enter a static IP address (e.g. 192.168.1.2/24):"
read STATIC_IP

if [ ! -z "$STATIC_IP" ]; then
  echo "Enter the gateway IP (default: 192.168.1.1):"
  read GATEWAY_IP

  [ -z "$GATEWAY_IP" ] && GATEWAY_IP="192.168.1.1"
  echo "Gateway set to $GATEWAY_IP"
fi

# Remove CD sources
cp /etc/apt/sources.list /etc/apt/sources.list.$DATE
sed -i '/deb cdrom/d' /etc/apt/sources.list

# Upgrade software
apt-get update -y
apt-get upgrade -y

# Install git, clone this repo, and navigate to it
apt-get install git -y
cd $TMP_DIR
git clone $GIT_LOC
cd bootstrap

# Install personal SSH keys under root and install the OpenSSH server
mkdir -p /root/.ssh/
cp --update authorized_keys /root/.ssh/authorized_keys
apt-get install openssh-server -y

# If STATIC_IP is set, backup interfaces and configure static IP
if [ ! -z "$STATIC_IP" ]; then
  cp /etc/network/interfaces /etc/network/interfaces.$DATE
  sed -i "s/dhcp/static/g" /etc/network/interfaces
  if ! grep -q "address" /etc/network/interfaces; then
    echo "  address $STATIC_IP" >> /etc/network/interfaces
    echo "  gateway $GATEWAY_IP" >> /etc/network/interfaces
  fi
fi

# If NEW_HOSTNAME is set, configure new hostname and backup /etc/hosts
if [ ! -z "$NEW_HOSTNAME" ]; then
  hostnamectl set-hostname $NEW_HOSTNAME
  cp /etc/hosts /etc/hosts.$DATE
  sed -i "s/$CUR_HOSTNAME/$NEW_HOSTNAME/g" /etc/hosts
  read -p "Press [enter] to restart this machine"
  /sbin/shutdown -r now
fi
