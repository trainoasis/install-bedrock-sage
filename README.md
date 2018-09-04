# new-wordpress-install
Simple script to create a clean Wordpress install using Valet, WP CLI &amp; Valet WP-CLI plugin. Start working on your code ASAP.

### What this script does:
Creates a new Wordpress project you can start working on immediately

### Prerequisites:

- Valet: https://laravel.com/docs/5.6/valet
- WP CLI: https://wp-cli.org/
- Valet WP-CLI plugin: https://github.com/aaemnnosttv/wp-cli-valet-command 

### Notes:
- Database is created (valet does the work via local db - installed via brew)
- Wordpress installed with config filled in (valet does the work)
- the script will ask you for some info before it does it's thing 
- change DEV_PATH variable based on where you want your project to be located (project root folder name will be added inside that folder)

### Example use

`sh new-wp.sh`

___ONLY FOR LOCAL DEVELOPMENT !___
