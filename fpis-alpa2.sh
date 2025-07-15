#!/bin/bash

# Fedora Post Install Setup - fpis-alpha2.sh

# Version 0.2 - Alpha 2
# Copyright 2025 Jesse Zelesnikar
# Authored by: Jesse Zelesnikar aka Cl0udb3rry87

# Licensed under GNU Affero General Public License (AGPL v3.0 )
# This software is licensed for non-commercial use only. You may use, copy, and modify
# this software for personal, educational, or research purposes, provided that this
# notice remains intact. Commercial use is strictly prohibited without prior written
# permission from the copyright holder.

# Contact at Cl0udb3rry87@gmail.com (For commerical Licensing Inquiries)

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE, AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWISE,
# ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

# Step 1 - Updating the system
# This script updates the Operating System
	echo "Starting update of Fedora and Applications"
# Updating the System
# Upgrade Packages
	echo "Upgrading packages"
	sudo dnf upgrade
	sleep 10
	echo "RPM Package Upgrade Complete"

# Clean up un-needed packages and depenedencies
	echo "Cleaning up packages and dependencies"
	sudo dnf autoremove
	sleep 10
	echo "Cleanup Complete"

# Step 2 - Installing the apps and removing the ones we do not want
echo "Starting application installation"
cd /home/$USER/FedoraSetup
# Install Applications
# dnf Installs
echo "Installing Apps from dnf"
sleep 5
# dnfpackages.txt contains a list of all dnf packages that will be installed.  Remember to add the packages you want to install.
sudo dnf install -y $(< dnfpackages.txt)
sleep 10
cowsay "dnf Apps Installed"
sleep 5
# dnf removals
echo "Removing un-needed included software"
sleep 5
# dnfrmpac.txt contains a list of all dnf packages to be removed.  Remember to add the packages you want to remove.
sudo dnf remove -y $(< dnfrmpac.txt)
sleep 10
cowsay "un-needed applications removed"
sleep 5
# Flatpak Installs
echo "Installing flatpak apps"
sleep 5
# flatpaks.txt contains the list of all flatpak apps to be installed.  Remember to add the adds your want to install.
flatpak install -y $(< flatpaks.txt)
sleep 10
cowsay "Flatpak Apps Installed"
sleep 5
cd /home/$USER/FedoraSetup/GnomeExtensions
extensions=(
	# Add any additional or remove any extensions that you do not want from this list.
	# DO NOT forget to add the zip files for the extensions in the GnomeExtensions folder.
    	#"appindicatorsupportrgcjonas.gmail.com.v60.shell-extension.zip"

)
# Loop through each extension
for extension in "${extensions[@]}"; do
    if gnome-extensions list | grep -q "$extension"; then
        echo "Extension $extension is already installed. Skipping..."
    else
        echo "Installing and enabling extension: $extension"
        gnome-extensions install "$extension"
        gnome-extensions enable "$extension"
    fi
done
sleep 5
# Disable Un-Needed Extensions
gnome-extensions disable background-logo@fedorahosted.org
gnome-extensions disable launch-new-instance@gnome-shell-extensions.gcampax.github.com
gnome-extensions disable window-list@gnome-shell-extensions.gcampax.github.com
sleep 5
cowsay "All extensions have been checked, installed if necessary, and enabled. Restart GNOME Shell to apply changes."

# Step 3 - Network share setup
# Setup Network Shares
echo "Starting configuration of Network Shares"
sleep 5
# Network Shares
cd /home/$USER
# Add any folders taht need to be made for your network shares here.
mkdir # Folder Name Here
sleep 5
# NetworkShares.txt contains all of the path information for your network shares.
# Remember to add your info to the file.
sudo cat /home/$USER/FedoraSetup/NetworkShares.txt | sudo tee -a /etc/fstab
sleep 5
sudo mount -a
sleep 5
cowsay "Network Shares have been added."


# Step 4 - OpenVPN Setup
# OpenVPN VPN Configuration
echo "Configuring OpenVPN Connections"
cd /home/$USER/FedoraSetup/OpenVPN-Profiles
sleep 3
echo -n "What is the username for your openvpn?"
read OVPNUSER
echo -n "What is the password for your openvpn?"
read OVPNPASS
# Loop to setup multiple openvpn profiles with a common password
for f in  *.ovpn
do
	name=`basename -s .ovpn $f`;
	nmcli connection import type openvpn file $f
	nmcli connection modify "${name}" +vpn.data connection-type=password-tls
	nmcli connection modify "${name}" +vpn.data username="${OVPNUSER}"
	nmcli connection modify "${name}" +vpn.secrets password="${OVPNPASS}"
done
cowsay "Proton VPNs have been added"
# Tailscale Setup
echo "Configuring Tailscale"
sleep 3
sudo systemctl start tailscaled.service
sleep 3
sudo tailscale set --operator=$USER
sleep 3
sudo tailscale up
sleep 3
read -p "Use link to login to tailscale, then press enter to continue"
sleep 3
sudo tailscale set --operator=$USER
cowsay "Tailscale is setup"

# Step 6 - Ending the script
# Script Completion Feedback
cowsay "Setup is Complete"
# Reboot System
cowsay "System will reboot in about 10 seconds."
sleep 10
sudo shutdown -r now
