#!/bin/bash

# Pour ajouter ce script à la variable d'environnement $PATH, afin de le rendre exécutable depuis n'importe où, voici les étapes à entreprendre:
# export PATH="$PATH:/Users/nabilchakir/BeCode/Bash"; ligne a rajouter à la fin de mon fichier /etc/bashrc
# source /etc/bashrc; exécute le script bashrc dans le contexte actuel du shell, afin que le changement puisse affecter l'environnement de travail 
# actuel du shell, comme la variable d'environnement $PATH

# argument obligatoire
mode=$1
lines_number=$(cat "/Users/nabilchakir/BeCode/Bash/blagues.txt" | wc -l)

# si le premier argument est égale à "non-interactif", l'opération mathématique à effectuer est fournie en tant que second paramètre
# la fonctionnalité say (équivalent de espeak pour Mac) n'a été implémentée que pour le mode non-interactif
if [ "$mode" =  "non-interactif" ]; then
	# blague
	line=$(jot -r 1 1 $lines_number)
	blague=$(cat "/Users/nabilchakir/BeCode/Bash/blagues.txt" | head -n "$line" | tail -n 1)
	echo $blague
	say $blague
	
	# heure
        heure=$(date +"%H:%M")
        echo $heure
        say "Il est $heure"

	# calcul
        #resultat=$(($2))
        resultat=$(echo "scale=2; $2" | bc)
        calcul=$(echo "le résultat de votre calcul est égal à $resultat")
        echo $calcul
	resultat_audio="le résultat de votre calcul est égal à $(echo $resultat | sed 's/\./ virgule /')"
        say "$resultat_audio"

	# météo
	say "Voici ci-dessous les prévisions météo pour les 3 prochains jours"
	curl wttr.in

elif [ "$mode" = "interactif" ]; then
	echo -e "\nPour QUITTER le shell interactif, faites ctrl+C\n"
	echo "Voici les phrases auxquelles cet assistant peut répondre:"
	echo -e "Racontes moi une blague\nQuelle heure est-il?\nCalcules moi ...\nRenseignes moi sur la météo"
	MY_PROMPT='Veuillez entrer une question$ '
	while :
	do	
  		# -n empeche l'affichage du saut de ligne (\n) à la fin de la sortie 
		echo -n "$MY_PROMPT"
  		# lecture de l'entrée utilisateur à partir de la CLI
		read line
		
		if [ "$line" = "Racontes moi une blague" ]; then
        		line=$(jot -r 1 1 $lines_number)
        		cat "/Users/nabilchakir/BeCode/Bash/blagues.txt" | head -n "$line" | tail -n 1
  		
		elif [ "$line" = "Quelle heure est-il?" ]; then 
			date +"%H:%M"
		
		elif [[ $line =~ [Cc]alcules\ moi ]]; then
			# aide debug
			echo $line
			
			if [[ $line =~ [0-9]+[\+\-\*\/][0-9]+([\+\-\*\/][0-9]+)* ]]; then
				calcul="${BASH_REMATCH[0]}"
				echo "scale=2; $calcul" | bc
			else
				echo "Il n'y a aucune opération à calculer"
			fi
		
		elif [ "$line" = "Renseignes moi sur la météo" ]; then
                        curl wttr.in
		
		else
			echo "Je n'ai pas compris ce que vous voulez me demander, veuillez reformuler votre question ou appuye ctrl+C pour quitter"
		fi
			
  	done
	exit 0
fi




