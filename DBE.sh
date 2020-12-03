#!/bin/bash

# ------------------- Data Base Extractor --------------------
#
#     This program extracts data from a database and
# place it into a file.
#
# Requirements :
#  - sqlite3
#  - npm
#  - csvtojson (installed via npm)
#
# Versions :
#
# 24/11/2020 > [0.0.1] :
# - Created the whole DBE.
#
# BUGS : .
# NOTES : .
#
# Contact     : i.a.sebsil83@gmail.com
# Youtube     : https://www.youtube.com/user/IAsebsil83
# GitHub repo : https://github.com/iasebsil83
#
# Let's Code !                                          By I.A.
# -------------------------------------------------------------



#get database name
dbPath=""
read -p "Please enter the database path > " dbPath
read -p "Please enter the table to extract > " tableName
read -p "Please enter the selection attribute > " attribute
read -p "Please enter the wanted value for this attribute > " value
read -p "Please enter the path of the desired result file > " resultPath



#convert from database to csv
sqlite3 $dbPath .headers\ on .mode\ csv .output\ temp.csv SELECT\ *\ FROM\ $tableName .quit



#convert from csv to json
csvtojson temp.csv > temp.json



#extract the concerned json line
line=""
while IFS= read -r line
do
	case $line in

		#useless lines
		"[" | "]" | "," | "")
		;;

		#useful line
		*)
			#remove "{" and "}"
			lineLength="${#line}"
			lineLength=$(( lineLength - 2 ))
			line="${line:1:lineLength}"

			#split the line with ","
			IFS=',' read -ra splittedLine <<< $line

			#show result
			for relation in "${splittedLine[@]}"
			do
				#select attribute
				if [[ "${relation}" == "\"${attribute}\":\"${value}\""* ]]; then

					#create result file
					touch $resultPath
					for l in "${splittedLine[@]}"
					do
						echo $l >> $resultPath
					done
				fi
			done
		;;
	esac
done < temp.json

#remove temp files
rm -f temp.csv temp.json
