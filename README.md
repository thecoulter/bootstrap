# Bootstrap
This repository bootstraps a GNU/Linux environment from a fresh installation. It will set up an SSH server with a static IP placing _my_ SSH keys into the root user's `.ssh` folder. If you run this script unmodified by following the instructions exactly below you may end up granting **me** root access to your machines, which is likely not your intention. If you like this script, fork this repository and replace the `authorized_keys` file with your **public** SSH keys and change the `GIT_LOC` bash variable in `bootstrap.sh` to your repository's location. Then download the script and run it from your repository.

The purpose of this is to allow me to quickly put a machine online in an accessible manner before provisioning it. This is mainly targeted at a fresh Debian 10 installation.

### Features
* Removes CD sources from `/etc/apt/sources.list`
* Updates repository information and installs all patches
* Installs git and clones this repository to download SSH keys
* Installs SSH keys for root access
* Sets a static IP (optional)
* Configures new hostname (optional)
* Prompts to restart if a new hostname is set

### Quick Start
1. Download the bootstrap script from the repository

`wget https://raw.githubusercontent.com/krislamo/bootstrap/master/bootstrap.sh`

2. Check that the file contains what you expected to download

`less bootstrap.sh`

2. Run the script with root permissions

`sudo bash bootstrap.sh`

_Note: you may prevent setting a new hostname or static IP by leaving those fields blank when requested._


### Copyrights and Licenses
Copyright (C) 2020  Kris Lamoureux, Miles Huff

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
