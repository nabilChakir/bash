#!/bin/bash

# Pour ajouter le chemin du répertoire contenant ce script à la variable d'environnement $PATH, afin de le rendre exécutable depuis n'importe où, 
# voici les étapes à entreprendre:
# export PATH="$PATH:/Users/nabilchakir/BeCode/Bash";   ligne à rajouter à la fin de mon fichier /etc/bashrc (macOS)
# source /etc/bashrc;   exécute le script bashrc dans le contexte actuel du shell, afin que le changement puisse affecter l'environnement de travail 
# actuel du shell, comme la variable d'environnement $PATH

mode=$1     # argument obligatoire du script, doit être égal à "interactif" ou "non-interactif"
lines_number=$(cat "/Users/nabilchakir/BeCode/Bash/blagues.txt" | wc -l)

afficher_blague(){
	line=$(jot -r 1 1 $lines_number)
	blague=$(cat "/Users/nabilchakir/BeCode/Bash/blagues.txt" | head -n "$line" | tail -n 1)
	echo $blague
	say $blague
}

afficher_heure(){
    heure=$(date +"%H:%M")
    echo "Il est $heure"
    say "Il est $heure"
}

afficher_calcul(){
    resultat=$(echo "scale=2; $1" | bc)
    calcul=$(echo "Le résultat de votre calcul est égal à $resultat")
    echo $calcul
	resultat_audio="Le résultat de votre calcul est égal à $(echo $resultat | sed 's/\./ virgule /')"
    say "$resultat_audio"
}

afficher_meteo(){
    echo "Prévisions météorologiques:"
	say "Voici ci-dessous les prévisions météo pour les 3 prochains jours"
	curl wttr.in
}

if [ $# -eq 0 ]; then
	echo -e "Le script prend soit 2 arguments, \"non-interactif\" et \"une opération mathématique\", soit un unique argument égal à \"interactif\""
	echo "Veuillez relancer le script avec le(s) bon(s) argument(s)"

# Si le premier argument est égale à "non-interactif", l'opération mathématique à effectuer est fournie en tant que second argument
elif [ "$mode" =  "non-interactif" ]; then
	afficher_blague
	afficher_heure
    afficher_calcul $2
    afficher_meteo

elif [ "$mode" = "interactif" ]; then
    # -n permet d'activer l'interprétation des caractères d'échappement 
	echo -e "\nPour QUITTER le shell interactif, faites ctrl+C\n\nVoici les phrases prédéfinies auxquelles cet assistant peut répondre:"
	echo -e "Racontes moi une blague\nQuelle heure est-il?\nCalcules moi ...\nRenseignes moi sur la météo\n"
	MY_PROMPT='Veuillez entrer une question$ '
	while :
	do	
  		# -n empeche l'affichage du saut de ligne (\n) à la fin de la sortie 
		echo -n "$MY_PROMPT"
  		# lecture de l'entrée utilisateur à partir de la CLI
		read line
		
		if [ "$line" = "Racontes moi une blague" ]; then
        	afficher_blague
  		elif [ "$line" = "Quelle heure est-il?" ]; then 
			afficher_heure
		elif [[ $line =~ [Cc]alcules\ (moi)? ]]; then
			if [[ $line =~ [\-]?[0-9]+[\+\-\*\/\^][0-9]+([\+\-\*\/\^][0-9]+)* ]]; then
				calcul="${BASH_REMATCH[0]}"
				afficher_calcul $calcul
			else
				echo "Il n'y a aucune opération à calculer ou l'opération demandée n'est pas pris en charge"
			fi
		elif [ "$line" = "Renseignes moi sur la météo" ]; then
            afficher_meteo
		else
			echo "Je n'ai pas compris ce que vous voulez me demander, veuillez reformuler votre question ou appuye ctrl+C pour quitter"
		fi
	done
	exit 0  # spécifie explicitement que le script a terminé son exécution avec succès

fi

