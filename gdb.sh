#!/bin/bash

set -ex

SUPPORTED_DISTRO_NAMES=( "debian" "ubuntu" "fedora" "manjaro" "arch" )
DISTRO_NAME=$(cat /etc/os-release | grep -m 1 -i "ID" | cut -d '=' -f 2)
DISTRO_VERSION=$(cat /etc/os-release | grep -i "VERSION_ID" | cut -d '=' -f 2 | tr -dc '0-9')

verify_compatible_distro_version ()
{
	case "$DISTRO_VERSION" in
		"2404")
			DISTRO_NAME="ubuntu-24"
			;;
		"43")
			DISTRO_NAME="fedora-43"
			;;
		"13")
			DISTRO_NAME="debian-13"
			;;
		"2604")
			DISTRO_NAME="ubuntu-26"
			;;
		*)
			DISTRO_NAME="$DISTRO_NAME"
			;;
	esac
}

verify_compatible_distro ()
{
	for name in "${SUPPORTED_DISTRO_NAMES[@]}"; do
		if grep -Fiq "$name" <<< "$DISTRO_NAME" ; then
			DISTRO_SUPPORTED=1
			break
		else
			DISTRO_SUPPORTED=0
			continue
		fi
	done
}

verify_gnome_environment ()
{
	if [ "$DESKTOP_SESSION" = "gnome" ]; then
		IS_GNOME=1
	else
		IS_GNOME=0
	fi
}

verify_sudo_permissions ()
{
	if sudo -n true; then
		IS_SUDOER=1
	else
		IS_SUDOER=0
	fi
}

###################################################
###################################################

verify_sudo_permissions
verify_compatible_distro_version
verify_compatible_distro
verify_gnome_environment

if [ IS_SUDOER ]; then
	echo "Confirmed sudoer permissions"
else
	echo "Sorry, you'll need sudoer permissions to run this script"
	exit 1
fi

if [ DISTRO_SUPPORTED ]; then
 	echo "Confirmed supported distro: $DISTRO_NAME"
else
	echo "Sorry, you're not running a supported distro; this script won't help you"
	exit 1
fi


if [ IS_GNOME ]; then
	echo "Confirmed GNOME environment"
else
	echo "You're not running a GNOME environment. This script can't help you if you're not running GNOME"
	exit 1
fi

# Debloating per distro
case "$DISTRO_NAME" in
	"debian-13")
		sudo apt purge gnome-contacts gnome-calendar gnome-connections gnome-software gnome-text-editor gnome-remote-desktop \
		gnome-user-docs gnome-characters gnome-abrt gnome-weather gnome-maps gnome-font-viewer gnome-logs gnome-tour gnome-sound-recorder \
		gnome-keyring orca brltty simple-scan nano yelp malcontent evolution libreoffice-base-core libreoffice-core libreoffice-draw \
		libreoffice-impress libreoffice-math libreoffice-gtk3 libreoffice-common shotwell -y

		sudo apt autoremove -y
		;;

	"ubuntu-24")
		sudo apt purge software-properties-* gnome-font-viewer update-manager gnome-remote-desktop gnome-user-docs gnome-text-editor gnome-power-manager \
		gnome-characters gnome-keyring gnome-logs yelp orca brltty -y

		# Purging snap bloat:
		for i in {1..2}; do
			for package in $(snap list | tail -n +2 | cut -d ' ' -f 1); do
				sudo snap remove --purge "$package" || true
			done
		done

		sudo systemctl disable --now snapd
		sudo apt purge snapd -y
		sudo rm -rf /snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd ~/snap

		sudo apt autoremove --purge -y
		sudo apt autoclean -y
		;;

	"ubuntu-26")
		sudo apt purge software-properties-* gnome-font-viewer update-manager gnome-remote-desktop gnome-user-docs gnome-text-editor \
		gnome-characters gnome-keyring gnome-logs sysprof yelp orca brltty -y

		# Purging snap bloat:
		for i in {1..2}; do
			for package in $(snap list | tail -n +2 | cut -d ' ' -f 1); do
				sudo snap remove --purge "$package" || true
			done
		done

		sudo systemctl disable --now snapd
		sudo apt purge snapd -y
		sudo rm -rf /snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd ~/snap

		sudo apt autoremove --purge -y
		sudo apt autoclean -y
		;;


	"fedora-43")
		sudo dnf remove gnome-calendar firefox gnome-connections gnome-software gnome-text-editor gnome-remote-desktop gnome-user-docs \
		orca brltty epiphany-runtime simple-scan nano gnome-characters gnome-abrt libreoffice-core gnome-contacts gnome-weather gnome-maps \
		mediawriter gnome-boxes gnome-font-viewer gnome-logs gnome-tour yelp malcontent-ui-libs -y
		;;

	"manjaro")
		sudo pacman -Rns --noconfirm gnome-contacts gnome-calendar gnome-connections gnome-text-editor gnome-remote-desktop gnome-user-docs \ 
		gnome-characters gnome-weather gnome-maps gnome-font-viewer gnome-logs gnome-tour gnome-keyring gnome-chess gnome-layout-switcher \
		gnome-firmware simple-scan nano nano-syntax-highlighting seahorse yelp malcontent file-roller deja-dup desktop-file-utils endeavour \
		fragments kvantum kvantum-manjaro micro quadrapassel thunderbird firefox iagno webapp-manager timeshift timeshift-autosnap-manjaro \
		manjaro-application-utility pamac-gtk pamac-gnome-integration libpamac-flatpak-plugin manjaro-hello manjaro-settings-manager-notifier \
		manjaro-settings-manager qt5-base qt5-svg qt5ct qt6-base qt6-svg qt6ct openconnect stoken \
		networkmanager-vpn-plugin-openconnect networkmanager-openconnect gufw system-config-printer
		;;

	"arch")
		sudo pacman -Rns --noconfirm gnome-software gnome-calendar gnome-text-editor gnome-maps gnome-contacts gnome-connections gnome-weather \
		gnome-characters gnome-tour gnome-logs gnome-font-viewer gnome-remote-desktop gnome-user-docs yelp orca brltty epiphany malcontent simple-scan nano
		;;
esac

# Removing clocks from search for speed
dconf write /org/gnome/desktop/search-providers/disabled "['org.gnome.clocks.desktop']"

echo "Debloating complete, hopefully you'll see some improvement in memory management and little more disk space"
echo "You may want to restart to avoid any issues for the remainder of this session"
