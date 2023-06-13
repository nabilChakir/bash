#!/bin/bash

curl https://webscraper.io/test-sites/e-commerce/allinone/computers/laptops > scraping

cat scraping | grep title=\" | cut -d "=" -f 4 | cut -d ">" -f 1 > titres.txt
cat scraping | grep "pull-right price" | cut -d ">" -f 2 | cut -d "<" -f 1 > prix.txt
cat scraping | grep "description" | cut -d ">" -f 2 | cut -d "<" -f 1 > descriptions.txt

# permet de supprimer la ligne vide du fichier descriptions.txt
awk 'NF' descriptions.txt > temp.txt
mv temp.txt descriptions.txt

# aide pour debug
wc -l titres.txt
wc -l prix.txt
wc -l descriptions.txt

# permet de fusionner les lignes correspondantes des 3 fichiers
paste -d "|" titres.txt prix.txt descriptions.txt

rm titres.txt prix.txt descriptions.txt


