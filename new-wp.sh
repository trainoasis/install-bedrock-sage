#!/bin/bash

# Creates a new Wordpress project you can start working on immediately

# Prerequisites: 
# - Valet: https://laravel.com/docs/5.6/valet
# - WP CLI: https://wp-cli.org/
# - Valet WP-CLI plugin: https://github.com/aaemnnosttv/wp-cli-valet-command 

# Notes:
#	- Database is created (valet does the work via local db - installed via brew)
#	- Wordpress installed with config filled in (valet does the work)
#	- the script will ask you for some info before it does it's thing 
#	- change DEV_PATH variable based on where you want your project to be located (project root folder name will be added inside that folder)

# Example use:
# sh new-wp.sh

# ONLY FOR LOCAL DEVELOPMENT !

DEV_PATH="/Development/"
BEDROCK=false
THEMES_DIR="wp-content/themes/"

# Terminate script if one of the commands fails
set -e 

# Variables
printf "Folder/Project Name: (no spaces/weird chars; will be used for folder & database as well)\nFOLDER  $DEV_PATH"
read FOLDERNAME

# USING BEDROCK OR NOT?
read -p "Use Bedrock for WP structure? (y/n)" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    BEDROCK=true
fi

# move to our Development folder path
cd $DEV_PATH

echo "... creating db & downloading wordpress"
# run valet command that: 
# creates DB & installs wordpress inside $FOLDERNAME
if $BEDROCK ; then
    THEMES_DIR="web/app/themes/"
    wp valet new $FOLDERNAME --project=bedrock
else
    wp valet new $FOLDERNAME
fi

# move to the created folder (wp root)
cd $FOLDERNAME

echo "... putting this folder to valet paths and linking it"
# wp valet new doesnt link/park it seems so we do it manually
valet park
valet link

echo "... moving to our /themes folder"
# move to the themes folder
cd $THEMES_DIR

echo "... installing blank Roots/Sage theme $FOLDERNAME"
# install Sage theme
composer create-project roots/sage $FOLDERNAME

echo "... running yarn && yarn build"
# move to our theme folder
cd $FOLDERNAME

# compile our dev files
yarn && yarn build

echo "... removing twenty* themes from /themes folder"
# remove old themes
cd ..
rm -rf twentyfifteen
rm -rf twentysixteen
rm -rf twentyseventeen

echo ".."
echo "Note: You will probably have to activate the theme manually since it wp theme activate doesnt work if a theme does not have a stylesheet..."
echo "!"

# run yarn start that opens the page via webpack
echo "... running yarn start inside our theme..wait for it to open the webpage for you"
yarn start

echo "... activating theme $FOLDERNAME"
# activate the new theme
wp theme activate $FOLDERNAME

echo ".."
echo "Note: You will probably have to activate the theme manually since it wp theme activate doesnt work if a theme does not have a stylesheet..."
echo "!"
