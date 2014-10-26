#!/bin/bash

FACTER_VERSION="2.2.0"
HIERA_VERSION="1.3.4"
PUPPET_VERSION="3.7.1"

usage()
{
cat << EOF
usage: $0 [options ...]

This script installs puppet.

OPTIONS:
	-h, --help
		Show this help
	-v, --verbose
		Verbose during execution
EOF
}

VERBOSE=
while true; do
	if [ -z $1 ]; then
		break
	fi
	case "$1" in
		-v | --verbose )
			VERBOSE=true
			shift
			;;
		-h | --help )
			usage
			exit
			;;
		* )
			usage
			exit
			;;
	esac
done

notice() {
	if [[ $VERBOSE = true ]]; then
		echo $1
	fi
}

# Création d'un dossier temporaire
mkdir -p tmp

##
# Fonction d'installation de fichier pkg dans un dmg
# $1 : url du fichier dmg
##
install_pkg_dmg()
{
	# Récupération du fichier dmg à partir de l'url donné
	filename="${1%.*}"
	tmp="${filename##*/}"
	curl "$1" -L -s -o "tmp/$tmp.dmg"
	notice "[$tmp] téléchargé"

	# Conversion du dmg en cdr et montage du cdr
	hdiutil convert "tmp/$tmp.dmg" -format UDTO -o "tmp/$tmp.cdr" -quiet
	notice "[$tmp] converti"
	hdiutil attach -nobrowse -readonly -noverify -noautoopen -mountpoint "tmp/$tmp" "tmp/$tmp.cdr" -quiet
	notice "[$tmp] monté"

	# Installation du pkg
	sudo installer -pkg "tmp/$tmp/$tmp.pkg" -target / >/dev/null
	notice "[$tmp] installé"

	# Démontage du cdr et suppression des fichiers créés
	hdiutil detach "tmp/$tmp" -quiet
	notice "[$tmp] démonté"
	rm "tmp/$tmp.cdr" "tmp/$tmp.dmg"
}

if !(hash facter 2>/dev/null) || [[ `facter --version` != $FACTER_VERSION ]]; then
	install_pkg_dmg "http://downloads.puppetlabs.com/mac/facter-$FACTER_VERSION.dmg"
	if !(hash facter 2>/dev/null) || [[ `facter --version` != $FACTER_VERSION ]]; then
		echo "Il y a eu un problème lors de l'installation de facter"
	else
		notice "Facter $FACTER_VERSION installé"
	fi
fi

if !(hash hiera 2>/dev/null) || [[ `hiera --version` != $HIERA_VERSION ]]; then
	install_pkg_dmg "http://downloads.puppetlabs.com/mac/hiera-$HIERA_VERSION.dmg"
	if !(hash hiera 2>/dev/null) || [[ `hiera --version` != $HIERA_VERSION ]]; then
		echo "Il y a eu un problème lors de l'installation de hiera"
	else
		notice "Hiera $HIERA_VERSION installé"
	fi
fi

if !(hash puppet 2>/dev/null) || [[ `puppet --version` != $PUPPET_VERSION ]]; then
	install_pkg_dmg "http://downloads.puppetlabs.com/mac/puppet-$PUPPET_VERSION.dmg"
	if !(hash puppet 2>/dev/null) || [[ `puppet --version` != $PUPPET_VERSION ]]; then
		echo "Il y a eu un problème lors de l'installation de puppet"
	else
		notice "Puppet $PUPPET_VERSION installé"
	fi
fi

# Suppression du dossier temporaire s'il n'est pas vide
rmdir tmp 2> /dev/null
