#!/bin/bash

#---- INCLUDING THE FILE fonction.sh where the functions are :
DIR="${BASH_SOURCE%/*}"
if [[ ! -d DIR ]]; then DIR="$PWD"; fi
. "$DIR/fonction.sh";
#------------------------------------------------------------|

# tester la presence au moin un argument saisi dans le script si nom il afficher un message d'errure
if [ $# -eq 0 ];then
 show_usage;
 exit;
fi

while getopts "hgvjcsplm" option
do
	echo -e "${BLUE} Getopts a trouve l'option(s) : $option ${NC}";
	case $option in 
	h)
	HELP 1;
	;;
	g)
	YAD_act=1;
	interface_gui;
	;;
	v)
	version_script 1;
	;;
	j)
	create_journal 1;
	afficher_journal;
	;;
	c)
	compresser_fichier 1;
	;;
	s)
	supprimer_fichier 1;
	;;
	p)
	parcour 1;
	;;
	l)
	lister_fichier;
	;;
	m)
	menu;
	;;
	esac
done
echo -e "${RED} Analyse Des Options Terminee ${NC}";
exit 0;


