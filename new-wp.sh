#!/bin/bash

# Creates a new Wordpress project based on Roots/Bedrock & Roots/Sage you can start working on immediately
# 
# You will need to enter some info for this script to provide you with the correct installation.
# If you want to avoid that, change the 2 variables inside the top of the script. 
#
# Prerequisites: 
# - Valet: https://laravel.com/docs/5.6/valet
# - WP CLI: https://wp-cli.org/
# - Valet WP-CLI plugin: https://github.com/aaemnnosttv/wp-cli-valet-command 
#
# Useful links:
# - https://roots.io/bedrock/
# - https://roots.io/sage/
#
# Example use:
# sh new-wp.sh
#
# ONLY FOR LOCAL DEVELOPMENT !

#
# Terminate script if one of the commands fails
#
set -e 

err_report() {
	echo " ====== "
    echo "   Error on line $1"
    echo " ====== "
}

trap 'err_report $LINENO' ERR

#
# VARIABLES (you can comment them and will be asked interactively)
#
#PROJECT_PATH="/Users/namesurname/Dev" # absolute path without trailing slash
#FOLDERNAME="testfolder" 				 # just folder name, no slashes	(should not exists yet)

#
# CONSTANTS (dont change!)
#
readonly THEMES_DIR_FOR_BEDROCK="web/app/themes/" 

if [ -z "$PROJECT_PATH" ] 
then
	# ASK FOR PROJECT_PATH NAME IF NOT HARDCODED
	printf "\n===> Enter Root WP project path where your project will reside. For example /Users/namesurname/Dev: \n -- no spaces/weird chars -- \n -- absolute path WITHOUT TRAILING SLASH\nPATH: "
	read PROJECT_PATH
else
	echo "   > Using hardcoded PROJECT_PATH: $PROJECT_PATH"
fi

if [ -z "$FOLDERNAME" ] 
then
	# ASK FOR FOLDER NAME IF NOT HARDCODED
	printf "\n===> Enter project name (folder should not exist yet): \n -- (no spaces/weird chars; will be used for folder & database as well as theme folder -- \n -- without slashes! -- \nFOLDER name in $PROJECT_PATH /"
	read FOLDERNAME
else 
	echo "   > Using hardcoded FOLDERNAME: $FOLDERNAME"
fi

THEMES_DIR="$PROJECT_PATH/$FOLDERNAME/$THEMES_DIR_FOR_BEDROCK"

# move to our Development folder path
cd $PROJECT_PATH

echo "\n ===> ... creating db & downloading wordpress ... you will be asked for your password now ...\n"
# run valet command that: 
# creates DB & installs wordpress inside $FOLDERNAME
wp valet new $FOLDERNAME --project=bedrock > /dev/null # dont show stdout but show stderr

# move to the created folder (wp root)
cd $FOLDERNAME

echo "\n ===> ... adding $PROJECT_PATH/$FOLDERNAME to valet links + securing (https) ...\n"
# wp valet new doesnt link/park it seems so we do it manually
valet link > /dev/null 2>&1 # dont show stdout and also redirect stderr to stdout
valet secure > /dev/null 2>&1 # dont show stdout and also redirect stderr to stdout

printf "\n ===> ... installing blank Roots/Sage theme inside \n$THEMES_DIR$FOLDERNAME (will ask you some questions about theme) ... \n"
printf "Hints for some questions:\n Local development URL of WP site: https://$FOLDERNAME.my \nPath to theme directory: /app/themes/$FOLDERNAME \n"
# move to the themes folder
cd $THEMES_DIR_FOR_BEDROCK

# install Sage theme
composer create-project roots/sage $FOLDERNAME > /dev/null 2>&1 # dont show stdout and also redirect stderr to stdout

printf "\n ===> ... running yarn && yarn build \n"
# move to our theme folder
cd $FOLDERNAME

printf "\n ===> ... activating theme $FOLDERNAME \n"
wp theme activate $FOLDERNAME/resources

printf "\n ===> ... setting permalinks || \n"
wp rewrite structure /%postname%/

# compile our dev files
yarn && yarn build --display=none

# run yarn start that opens the page via webpack
printf "\n ===> ... running yarn start inside our theme..wait for it to open the webpage for you \n"
yarn start

printf "\n ===> ... You can login to WP here: https://$FOLDERNAME.my/wp/wp-login.php with admin/admin \n" 

printf "\n ===> ... removing twenty* themes from /themes folder \n"

# remove old themes
cd $THEMES_DIR
rm -r twenty*
