# Creates a new Wordpress project based on Roots/Bedrock & Roots/Sage you can start working on immediately

You will need to enter some info for this script to provide you with the correct installation.
If you want to avoid that, change the 2 variables inside the top of the script. 

# Prerequisites: 
 - Valet: https://laravel.com/docs/5.6/valet
 - WP CLI: https://wp-cli.org/
 - Valet WP-CLI plugin: https://github.com/aaemnnosttv/wp-cli-valet-command 


# Useful links:
 - https://roots.io/bedrock/
 - https://roots.io/sage/

# Configure valet wp
- in /home/user/.wp-cli create config.yml with <br>
`valet new:` <br>
 ` dbuser: root # or any db creating user`<br>
 ` dbpass: password # set yours here`
# Example use:
 - sh new-wp.sh
 - bash new-wp.sh

# ONLY FOR LOCAL DEVELOPMENT !
