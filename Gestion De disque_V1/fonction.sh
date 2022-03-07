#!/bin/bash

#COLORS :
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
#------- Parametre Yad (GUI):
YAD_txt="txt";
gui=(
   yad
   --center --width=820 --height=700
   --image="$PWD/icon/hard_drive.png"
   --title="-GESTION DE DISQUE-"
   --text="<span foreground='green'><big> <b> | Welcome, $USER | </b></big></span>"
   --button="Quttier":1
   --form
      --field="<span foreground='teal'><big><b>>Show usage</b></big></span>":btn "bash -c yad_show_usage "
      --field="<span foreground='teal'><big><b>>Help</b></big></span>":btn "bash -c HELP " 
      --field="<span foreground='teal'><big><b>>Version</b></big></span>":btn "bash -c version_script " 
      --field="<span foreground='teal'><big><b>>Cree un Journal des Fichier supprime</b></big></span>":btn "bash -c create_journal" 
      --field="<span foreground='teal'><big><b>>Compresser un Fichier</b></big></span>":btn "bash -c compresser_fichier " 
      --field="<span foreground='teal'><big><b>>Supprimer un Fichier</b></big></span>":btn "bash -c supprimer_fichier " 
      --field="<span foreground='teal'><big><b>>Parcour des Fichier a supprimer Ou Compresser</b></big></span>":btn "bash -c parcour " 
      --field="<span foreground='teal'><big><b>>Lister les Fichiers(+100ko)</b></big></span>":btn "bash -c lister_fichier " 
)

yad_show_usage()
{
yad --center --width=330 --height=100 --image="gtk-dialog-info" --title="-USAGE-" --text="<span foreground='blue'> <b> <big> disque.sh: [-h] [-j] [-s] [-p] [-l] [-v] [-m] [-g] : $PWD .${NC} </big> </b> </span>";
}
export -f yad_show_usage;
interface_gui(){
	while true; do
	    "${gui[@]}"
	    exval=$?
	    case $exval in
	        1|252) break;;
	    esac
	done
}

#Fonction show_usage afficher un message :
show_usage(){
echo -e "${RED} disque.sh: [-h] [-j] [-s] [-p] [-l] [-v] [-m] [-g] : $PWD .${NC}";
}

#Fonction HELP afficher le fichier Help :
HELP()
{
	if [ $# -eq 1 ];then
	cat README.md;
	else yad --center --width=1100 --height=800 --image="$PWD/icon/help.png" --title="-HELP-" --text-info < README.md ;
	fi 
}
export -f HELP;
#Fonction Lister_fichier ,liste Les fichier qui depasse 100ko dans la repertoire /Home/Utilisateur
lister_fichier(){
liste=`find ~ -type f -size +100k`;
for fichier in $liste
do
ls $fichier -l -t -s;
done 
}
export -f lister_fichier;
#afficher les authors et la version de script
version_script(){
	if [ $# -eq 1 ]; then
		#statements
		echo "|------------------------------------------------------|"
		echo -e "\e[1;92m Authors: Achref Riahi & Walid Ben Hassouna  \e[0m ";
		echo -e "\e[1;92m Version: V1.0-(2022)\e[0m ";
		echo "|------------------------------------------------------|"
	else
yad --center --width=330 --height=100 --image="$PWD/icon/team.png" --title="-Version-" --text="<span foreground='olive'> <b> <big> -Authors : Achref Riahi et Walid Ben Hassouna /\ -Version : V1.0 </big> </b> </span>";
	fi
}
export -f version_script;
#Supprimer_fichier permettre de supprimer un seul Fichier (>=100ko) saisi avec un message de confirmation:
supprimer_fichier(){
journal=$PWD/deleted_files.md;
if [ $# -eq 1 ]; then
read -p "==>Donner le nom de fichier a Supprimer : " nom;
else
nom=`yad --entry --center --title="-Supprimer-" --editable --ricon="$PWD/icon/delete.png" --entry-label="Donner le nom de fichier a Supprimer :"`;
fi
if [ ! -z $nom ]; then
sudo updatedb;
fichier=`locate -br "^$nom$"`;
echo $fichier;
if [ -f "$fichier" ]; then 
size=`du -k $fichier | cut -f1`;
size_i=`expr $size + "0"`;
if [ $size_i -ge 100 ]; then
if [ $# -eq 1 ]; then
rm -i $fichier;
else
rm $fichier;
fi
if [ -e $journal -a -f $journal ];then
delete_date=`date`;
echo "---------- File : $nom a ete Supprimer en : $delete_date | location : $fichier ." >> $journal;
fi
echo -e "${BLUE} (---- Le fichier $nom a ete Supprimer avec Succés ----)  ${NC}";
if [ $# -eq 0 ]; then
yad --center --width=120 --height=70 --image="$PWD/icon/success.png" --title="-Success-" --text="<span foreground='blue'> <b> <big> -Le fichier ' $nom ' a ete Supprimer avec Succés- </big> </b> </span>";
fi
else
echo -e " ${RED}>>Le fichier $nom ne depasse pas 100ko Vous ne pouvez pas Supprimer.${NC}";
if [ $# -eq 0 ]; then
yad --center --width=120 --height=70 --image="$PWD/icon/error.png" --title="-ERROR-" --text="<span foreground='red'> <b> <big>Le fichier ' $nom ' ne depasse pas 100ko Vous ne pouvez pas Supprimer</big> </b> </span>";
fi
fi
else 
echo -e " ${RED}>>Le fichier $nom n'existe pas Ou Vider la Corbeille.${NC}";
if [ $# -eq 0 ]; then
yad --center --width=120 --height=70 --image="$PWD/icon/error.png" --title="-ERROR-" --text="<span foreground='red'> <b> <big>Le fichier ' $nom ' n'existe pas Ou Vider la Corbeille.</big> </b> </span>";
fi
fi
fi
}
export -f supprimer_fichier;
#Supprimer_Pfichier permettre de supprimer plusieur Fichiers (>=100ko) saisi dans la liste des Arguments sans un message de confirmation:
supprimer_Pfichier(){
t=0;
journal=$PWD/deleted_files.md;
if [ $# -ge 1 ]; then 
sudo updatedb;
for nom in $*
do
fichier=`locate -br "^$nom$"`;
if [ -f "$fichier" ]; then 
size=`du -k $fichier | cut -f1`;
size_i=`expr $size + "0"`;
if [ $size_i -ge 100 ]; then
rm $fichier;
if [ -e $journal -a -f $journal ];then
delete_date=`date`;
echo "---------- File : $nom a ete Supprimer en : $delete_date | location : $fichier ." >> $journal;
fi
echo -e "${BLUE} (---- Le fichier $nom a ete Supprimer avec Succés ----)  ${NC}";
((t++));
else
echo -e " ${RED}>>Le fichier $nom ne depasse pas 100ko Vous ne pouvez pas Supprimer.${NC}";
fi
else 
echo -e " ${RED}>>Le fichier $nom n'existe pas Ou Vider la Corbeille.${NC}";
fi
done
else -e " ${RED}>>Enter Arguments Nb=0.${NC}";
fi
return $t;
}
export -f supprimer_Pfichier;
#compresser_fichier permettre de Compresser un seul Fichier (>=100ko) saisi et le mettre dans la dossier compress qui exsite dans le dossier de script:
compresser_fichier(){
if [ $# -eq 1 ]; then
read -p "==>Donner le nom de fichier a Compresser : " nom;
else
nom=`yad --entry --center --title="-Compresser-" --editable --ricon="$PWD/icon/zip.png" --entry-label="Donner le nom de fichier a Compresser :"`;
fi
if [ ! -z $nom ]; then
sudo updatedb;
fichier=`locate -br "^$nom$"`;
if [ -f "$fichier" ]; then 
size=`du -k $fichier | cut -f1`;
size_i=`expr $size + "0"`;
if [ $size_i -ge 100 ]; then
tar -czvf $nom.tar.gz $fichier;
mv $PWD/$nom.tar.gz $PWD/compress;
echo -e "${BLUE} (---- Le fichier a ete Compresser avec Succés et il est dans le chemin suivant : $PWD/compress/$nom.tar.gz ----)  ${NC}";
if [ $# -eq 0 ]; then
yad --center --width=180 --height=70 --image="$PWD/icon/success.png" --title="-Success-" --text="<span foreground='blue'> <b> <big> -Le fichier a ete Compresser avec Succés et il est dans le chemin suivant : '$PWD/compress/$nom.tar.gz' - </big> </b> </span>";
fi
else
echo -e " ${RED}>>Le fichier $nom ne depasse pas 100ko Vous ne pouvez pas Compresser.${NC}";
if [ $# -eq 0 ]; then
yad --center --width=120 --height=70 --image="$PWD/icon/error.png" --title="-ERROR-" --text="<span foreground='red'> <b> <big>Le fichier ' $nom ' ne depasse pas 100ko Vous ne pouvez pas Compresser</big> </b> </span>";
fi
fi
else 
echo -e " ${RED}>>Le fichier $nom n'existe pas Ou Vider la Corbeille.${NC}";
if [ $# -eq 0 ]; then
yad --center --width=120 --height=70 --image="$PWD/icon/error.png" --title="-ERROR-" --text="<span foreground='red'> <b> <big>Le fichier ' $nom ' n'existe pas Ou Vider la Corbeille.</big> </b> </span>";
fi
fi
fi
}
export -f compresser_fichier;
#compresser_Pfichier permettre de Compresser Plusieur Fichiers (>=100ko) saisi et le mettre dans la dossier compress qui exsite dans le dossier de script:
compresser_Pfichier()
{
	counter=0;
	if [ $# -ge 1 ]; then
	sudo updatedb;
	name_unique=Comp_`date +'%d%H%s%S'`; # |%S sont les secondes | %H l'heure | %d le jour
	mkdir $PWD/$name_unique;
	for nom in $*
	do
	fichier=`locate -br "^$nom$"`;
	if [ -f "$fichier" ]; then
	size=`du -k $fichier | cut -f1`;
	size_i=`expr $size + "0"`;
	if [ $size_i -ge 100 ]; then
	cp $fichier $PWD/$name_unique;
	((counter++));
	else
	echo -e " ${RED}>>Le fichier $nom ne depasse pas 100ko Vous ne pouvez pas Compresser.${NC}";
	fi
	else
	echo -e " ${RED}>>Le fichier $nom n'existe pas Ou Vider la Corbeille.${NC}";
	fi
	done
	else -e " ${RED}>>Enter Arguments Nb=0.${NC}";
	fi
	if [ $counter -eq 0 ]; then
	rm -r $PWD/$name_unique;
	else
	tar -czvf $name_unique.tar.gz $name_unique;
	mv $PWD/$name_unique.tar.gz $PWD/compress;
	echo -e "${BLUE} (---- Le fichier a ete Compresser avec Succés et il est dans le chemin suivant : $PWD/compress/$name_unique.tar.gz ----)  ${NC}";
	rm -r $PWD/$name_unique;
	fi
	return $counter;
}
export -f compresser_Pfichier;
#Repeat-menu pour afficher le menu encore fois apres le saisir: 
repeat_menu()
{
	echo -e "\e[1;92m ╔═══╦═══╦═══╦════╦══╦═══╦═╗─╔╗╔═══╦═══╗╔═══╦══╦═══╦═══╦╗─╔╦═══╗──╔╗──╔╗╔╗ \e[0m ";
	echo -e "\e[1;92m ║╔═╗║╔══╣╔═╗║╔╗╔╗╠╣╠╣╔═╗║║╚╗║║╚╗╔╗║╔══╝╚╗╔╗╠╣╠╣╔═╗║╔═╗║║─║║╔══╝──║╚╗╔╝╠╝║ \e[0m ";
	echo -e "\e[1;92m ║║─╚╣╚══╣╚══╬╝║║╚╝║║║║─║║╔╗╚╝║─║║║║╚══╗─║║║║║║║╚══╣║─║║║─║║╚══╗──╚╗║║╔╩╗║ \e[0m ";
	echo -e "\e[1;92m ║║╔═╣╔══╩══╗║─║║──║║║║─║║║╚╗║║─║║║║╔══╝─║║║║║║╚══╗║║─║║║─║║╔══╬══╗║╚╝║─║║ \e[0m ";
	echo -e "\e[1;92m ║╚╩═║╚══╣╚═╝║─║║─╔╣╠╣╚═╝║║─║║║╔╝╚╝║╚══╗╔╝╚╝╠╣╠╣╚═╝║╚═╝║╚═╝║╚══╬══╝╚╗╔╝╔╝╚╗ \e[0m ";
	echo -e "\e[1;92m ╚═══╩═══╩═══╝─╚╝─╚══╩═══╩╝─╚═╝╚═══╩═══╝╚═══╩══╩═══╩══╗╠═══╩═══╝────╚╝─╚══╝\e[0m ";
	echo -e "\e[1;92m ─────────────────────────────────────────────────────╚╝ \e[0m ";
	echo "1) -HELP-";
	echo "2) -GUI(Grapical User Interface - YAD)-";
	echo "3) -Auteurs & Version-";
	echo "4) -Creer Une Journal des Fichiers Supprime et l'Afficher -";
	echo "5) -Compresser Un Fichier-";
	echo "6) -Supprimer Un Fichier";
	echo "7) -Parcourir Des Fichiers (Supprimer ou Compresser)-";
	echo "8) -Lister les Fichier (+100ko)-";
	echo "9) -Quitter-";

}
print_txt(){
	nom=$PWD/deleted_files.md;
	echo "╔═══╗──╔╗───╔╗─────╔╗╔═══╗╔╗" >> $nom;
	echo "╚╗╔╗║──║║──╔╝╚╗────║║║╔══╝║║" >> $nom;
	echo "─║║║╠══╣║╔═╩╗╔╬══╦═╝║║╚══╦╣║╔══╦══╗╔╗" >> $nom;
	echo "─║║║║║═╣║║║═╣║║║═╣╔╗║║╔══╬╣║║║═╣══╣╚╝" >> $nom;
	echo "╔╝╚╝║║═╣╚╣║═╣╚╣║═╣╚╝║║║──║║╚╣║═╬══║╔╗" >> $nom;
	echo "╚═══╩══╩═╩══╩═╩══╩══╝╚╝──╚╩═╩══╩══╝╚╝" >> $nom;
}
#Cree le fichier journal pour sauvgarde l'historique des fichier supprimer 
create_journal()
{
	nom=$PWD/deleted_files.md;
	if [ -e $nom -a -f $nom ];then
	echo -e "${RED}>>$nom est existe .${NC}";
	YAD_txt=" $nom est existe .";
	else
	touch $PWD/$nom;
	print_txt;
	echo -e "${BLUE}>>$nom a ete Cree .${NC}";
	YAD_txt=" $nom a ete Cree .";
	fi
	if [ $# -eq 0 ]; then
	yad --center --width=320 --height=250 --image="gtk-dialog-info" --title="-JOURNAL-" --text="<span foreground='green'><big> <b> $YAD_txt </b></big></span>" --button="Afficher":1 --button="Retour":0;
	val=$?;
	if [ $val -eq 1 ]; then
	afficher_journal_yad;
	else
	echo "" ;
	fi
	fi
}
export -f create_journal;
parcour()
{
		i=1;
		c=1;
		echo -e "${RED}Saisir ' q ' OU ' Q ' Pour quitter la saisie.${NC}";
		while [ $c -eq 1 ]
		do
		if [ $# -eq 1 ];then
		read -p ">> Donner le nom de Fichier $i : " nom;
		else
		nom=`yad --entry --center --title="-Loop(Enter q to quit)-" --editable --ricon="$PWD/icon/zip.png" --entry-label="Donner le nom de fichier[$i] :"`;
		fi
		if [ ! -z $nom ]; then
		if [ $nom != "q" -a $nom != "Q" ]; then
		if [ $i -eq 1 ];then
		tab=( $nom )
		else
		tab[${#tab[*]}]=$nom;
		fi
		((i++));
		else
		c=0;
		fi
		fi
		done 
		if [ ${#tab[*]} -ne 0 ];then 
		#----
		v=1;
		while [ $v -eq 1 ] 
		do
		if [ $# -eq 1 ];then
		echo -e "${BLUE} (Compresser: 'c' ou 'C' /OU\ Supprimer: ' s ' ou ' S ' ) : ${NC}";
		read op;
		else
		op=`yad --entry --center --title="-Choix-" --editable --ricon="$PWD/icon/zip.png" --entry-label="Compresser: 'c' /OU\ Supprimer: ' s ' :"`;
		fi
		if [ $op == "s" -o $op == "S" ]; then
		v=0;
		supprimer_Pfichier ${tab[*]};
		val=$?;
		if [ $# -eq 0 ]; then
		if [ $val -gt 0 ]; then
		yad --center --width=120 --height=70 --image="$PWD/icon/success.png" --title="-Success-" --text="<span foreground='blue'> <b> <big> -Le Programme a Supprime avec Succés $val/${#tab[*]} Fichier - </big> </b> </span>";
		else
		yad --center --width=120 --height=70 --image="$PWD/icon/error.png" --title="-ERROR-" --text="<span foreground='red'> <b> <big> Les fichiers n'existe pas Ou Vider la Corbeille.</big> </b> </span>";
		fi
		fi		
		elif [ $op == "c" -o $op == "C" ]; then
		v=0;
		compresser_Pfichier ${tab[*]};
		val=$?;
		if [ $# -eq 0 ]; then
		if [ $val -gt 0 ]; then
		yad --center --width=120 --height=70 --image="$PWD/icon/success.png" --title="-Success-" --text="<span foreground='blue'> <b> <big> Les fichiers sont ete Compresser avec Succés et ils sont dans le chemin suivant : $PWD/compress/$name_unique.tar.gz </big> </b> </span>";
		else
		yad --center --width=120 --height=70 --image="$PWD/icon/error.png" --title="-ERROR-" --text="<span foreground='red'> <b> <big> Les fichiers n'existe pas Ou Vider la Corbeille.</big> </b> </span>";
		fi
		fi
		else
		echo -e "${RED} (----Option incorrecte----)  ${NC}";
		fi
		#----
		done
		fi
}
export -f parcour;
afficher_journal(){
		journal=$PWD/deleted_files.md;
		c=1;
		if [ -e $journal -a -f $journal ];then
		while [ $c -eq 1 ]
		do
		read -p "Voulez-Vous avoir la journal ( Oui :'1' | Non : '0' ) : " op;
		if [ $op -eq 0 ]; then
		c=0;
		elif [ $op -eq 1 ]; then
		cat $journal;
		c=0;
		else
		echo -e "${RED} (----Option incorrecte----)  ${NC}";
		fi
		done
		fi
}
afficher_journal_yad(){
	yad --center --width=800 --height=700 --image="$PWD/icon/jornal.png" --title="-JOURNAL-" --text="<span foreground='orange'><big> <b> Trash History </b></big></span>" --text-info < $PWD/deleted_files.md;
}
export -f afficher_journal_yad;
#menu de l'App :
menu()
{
	echo -e "\e[1;92m ╔═══╦═══╦═══╦════╦══╦═══╦═╗─╔╗╔═══╦═══╗╔═══╦══╦═══╦═══╦╗─╔╦═══╗──╔╗──╔╗╔╗ \e[0m ";
	echo -e "\e[1;92m ║╔═╗║╔══╣╔═╗║╔╗╔╗╠╣╠╣╔═╗║║╚╗║║╚╗╔╗║╔══╝╚╗╔╗╠╣╠╣╔═╗║╔═╗║║─║║╔══╝──║╚╗╔╝╠╝║ \e[0m ";
	echo -e "\e[1;92m ║║─╚╣╚══╣╚══╬╝║║╚╝║║║║─║║╔╗╚╝║─║║║║╚══╗─║║║║║║║╚══╣║─║║║─║║╚══╗──╚╗║║╔╩╗║ \e[0m ";
	echo -e "\e[1;92m ║║╔═╣╔══╩══╗║─║║──║║║║─║║║╚╗║║─║║║║╔══╝─║║║║║║╚══╗║║─║║║─║║╔══╬══╗║╚╝║─║║ \e[0m ";
	echo -e "\e[1;92m ║╚╩═║╚══╣╚═╝║─║║─╔╣╠╣╚═╝║║─║║║╔╝╚╝║╚══╗╔╝╚╝╠╣╠╣╚═╝║╚═╝║╚═╝║╚══╬══╝╚╗╔╝╔╝╚╗ \e[0m ";
	echo -e "\e[1;92m ╚═══╩═══╩═══╝─╚╝─╚══╩═══╩╝─╚═╝╚═══╩═══╝╚═══╩══╩═══╩══╗╠═══╩═══╝────╚╝─╚══╝\e[0m ";
	echo -e "\e[1;92m ─────────────────────────────────────────────────────╚╝ \e[0m ";
	PS3="==> Votre Choix :"
	select item in "-HELP-" "-GUI(Grapical User Interface - YAD)-" "-Auteurs & Version-" "-Creer Une Journal des Fichiers Supprime et l'Afficher-" "-Compresser Un Fichier-" "-Supprimer Un Fichier" "-Parcourir Des Fichiers (Supprimer ou Compresser)-" "-Lister les Fichier (+100ko)-" "-Quitter-"
	do
		case $REPLY in 
		1)
		HELP 1;
		repeat_menu;
		;;
		2)
		interface_gui;
		repeat_menu;
		;;
		3)
		version_script 1;
		repeat_menu;
		;;
		4)
		create_journal 1;
		afficher_journal;
		repeat_menu;
		;;
		5)
		compresser_fichier 1;
		repeat_menu;
		;;
		6)
		supprimer_fichier 1;
		repeat_menu;
		;;
		7)
		parcour 1;
		repeat_menu;
		;;
		8)
		lister_fichier;
		repeat_menu;
		;;
		9)
		echo -e "${RED}-------Quitting The MENU-------${NC}";
		break;
		;;
		*)
		echo "Choix incorrect";
		;;
		esac
	done
}
