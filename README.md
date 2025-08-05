Note: This repository is no longer being updated.  I have created a new repo named FedoraSetupInteractive.  The project is being re-written from scratch in the near future.

How to use this script:

- For application installs you will need to add the names of those applications to the corresponding txt file.  The files are all listed below:
	- dnf packages to install = dnfpackages.txt
	- dnf packages to remove = dnfrmpac.txt
	- flatpak apps to install = flatpaks.txt
	
- For Gnome Extensions you will need to download the most recent and compatible gnome extensions from https://extensions.gnome.org/.  Keep the files as a zip and put them in the GnomeExtensions folder.  You will also need to list file name in the extensions section in the script located at list 70.  If the extensions are out of date they will automatically update as long as you are using extension manager, so if you forget as I do sometimes it is not that big of a deal.

- For network shares you will need to add the config that needs to be in fstab to the NetworkShares.txt file and also add any folders that need to be created that area of the script located at line 113.

- If you have OpenVPN(s) to setup make sure you know your username and password.  You will be prompted.  This part of the script is for multiple connections that use a common username and password.  My use of this is for the OpenVPN connections I have with Proton VPN.  Place your Open VPN profiles in the OpenVPN-Profiles folder.

System Settings

- If you want to copy settings from another install I have used "Save Desktop".  I have used it several times and have not had any issues yet.
