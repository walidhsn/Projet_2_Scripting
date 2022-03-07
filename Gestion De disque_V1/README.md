 ╔╗─╔╦═══╦╗──╔═══╗
 ║║─║║╔══╣║──║╔═╗║
 ║╚═╝║╚══╣║──║╚═╝║╔╗
 ║╔═╗║╔══╣║─╔╣╔══╝╚╝
 ║║─║║╚══╣╚═╝║║───╔╗
 ╚╝─╚╩═══╩═══╩╝───╚╝
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------->Ce logiciel va permettre à l’utilisateur de gérer l’espace de stockage de son disque à l’aide de plusieurs fonctionnalités développer d’une façon optimale et facile à utiliser.
   Le logiciel commence par vérifier l’existence d’arguments dans le cas où ils sont inexistants ce message apparait :
« disque.sh: [-h] [-j] [-s] [-p] [-l] [-v] [-m] [-g] Chemin…”
1-- : permet d’afficher le « help », ce fichier texte ou se trouve toutes les explications et informations nécessaires à l’utilisation du logiciel.
2-- : Présence d’une interface graphique (yad) rendant le logiciel plus facile à utiliser pour un simple utilisateur 
et plus agréable à regarder grâce à son design attirant.
3-- : Version : permet à l’utilisateur de connaitre les créateurs du logiciel et de se renseigner de la version dont ils disposent. 
4-- : une fonction qui permet de créer un journal contenant les noms de tous les fichiers supprimés l’heure de leurs suppressions.
5-- : une fonctionnalité qui permet de supprimer un fichier si sa taille dépasse 100 ko, 
il suffit juste d’entrer son nom dans la barre de saisie et puis de confirmer la suppression s’il n’existe pas un message d’erreur vous alertera.
6-- : une fonctionnalité qui permet de compresser un fichier si sa taille dépasse 100 ko, il fonctionne de la même manière que la fonction supprimer dans le cas où il est compressé avec succès
 un message vous en tiendra au courant et vous donnera son emplacement.
7-- : une fonctionnalité qui permet de prendre en arguments plusieurs fichiers de taille supérieur à 100 ko et donne à l’utilisateur 
la possibilité de supprimer ou de compresser ces fichiers dont le cas où l’un de, est inexistant un message vous avertira.
8-- : est une fonctionnalité qui permet de lister un par un tous les fichiers faisant plus de 100 ko du disque affichant ainsi
, la date de création, le nom, la taille et plusieurs autres informations les concernants.
9-- : permet de quitter le menu.
->> Un autre choix sera considéré comme incorrecte.
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|-----------------------------------------------------------------------------------------------------------------------|
|> Options :
| • -h : Pour afficher le help détaillé à partir d’un fichier texte
| • -g : Pour afficher un menu textuel et gérer les fonctionnalités de façonGraphique (Utilisation de YAD).
| • -v : Pour afficher le nom des auteurs et la version du code.
| • -j : créer le fichier journal des fichiers supprimés
| • -c : compresser un fichier
| • -s : supprimer un fichier
| • -p : parcourir des fichiers pour supprimer ou compresser
| • -l : lister des fichiers de taille supérieur à 100ko
| • -m : pour afficher un menu textuel (en boucle) qui permet d'accéder à chaque fonction
|-----------------------------------------------------------------------------------------------------------------------|
