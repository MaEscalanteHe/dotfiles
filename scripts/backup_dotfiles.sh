#!/bin/bash

CONFIG_DIR="$HOME/.config"
REPOSITORY_LOCAL_DIR="$HOME/Workspace/dotfiles"
BACKUP_DATE=`date +%b-%d-%y`

gen_dotfile_dir () {
	read re

	if [[ ${re,,} =~ ^(n|no)$ ]]; then
		echo -e "Don't worry"
		sleep 0.25
		exit 127
	else
		# Check if Workspace directory exists and generate it in case it doesn't
		[ ! -d $HOME/Workspace ] && mkdir $HOME/Workspace
		git clone https://github.com/MaEscalanteHe/dotfiles.git $REPOSITORY_LOCAL_DIR
	fi
}

backup_copy () {
	[ ! -d $REPOSITORY_LOCAL_DIR/.config ] && mkdir $REPOSITORY_LOCAL_DIR/.config
	[ ! -d $REPOSITORY_LOCAL_DIR/scripts ] && mkdir $REPOSITORY_LOCAL_DIR/scripts

	case $2 in
		".config") cp -ruv $1 $REPOSITORY_LOCAL_DIR/.config;;
		"scripts") cp -ruv $1 $REPOSITORY_LOCAL_DIR/scripts/;;
		"home") cp -ruv $1 $REPOSITORY_LOCAL_DIR/
	esac

	sleep 0.25
}

backup () {
	[ ! -d $CONFIG_DIR ] && mkdir $HOME/.config
	
	sleep 0.5
	echo -e "\nCopy .config directory...\n"

	[ -d $CONFIG_DIR/bspwm ] && backup_copy "$CONFIG_DIR/bspwm" ".config"
	[ -d $CONFIG_DIR/sxhkd ] && backup_copy "$CONFIG_DIR/sxhkd" ".config"
	[ -d $CONFIG_DIR/polybar ] && backup_copy "$CONFIG_DIR/polybar" ".config"
	[ -d $CONFIG_DIR/compton ] && backup_copy "$CONFIG_DIR/compton" ".config"
	[ -d $CONFIG_DIR/fish ] && backup_copy "$CONFIG_DIR/fish" ".config"
	[ -d $CONFIG_DIR/omf ] && backup_copy "$CONFIG_DIR/omf" ".config"
	[ -d $CONFIG_DIR/zsh ] && backup_copy "$CONFIG_DIR/zsh" ".config"

	sleep 0.5
	echo -e "\nCopy Script directory...\n"

	[ -d $HOME/Scripts ] && backup_copy "$HOME/Scripts/*" "scripts" 

	sleep 0.5
	echo -e "\nCopy other files in home directory...\n"

	[ -f $HOME/.fehbg ] && backup_copy "$HOME/.fehbg" "home"
	[ -f $HOME/.p10k.zsh ] && backup_copy "$HOME/.p10k.zsh" "home"
	[ -f $HOME/.xinitrc ] && backup_copy "$HOME/.xinitrc" "home"
	[ -f $HOME/.zshrc ] && backup_copy "$HOME/.zshrc" "home"

	sleep 0.5
	echo -e "\nAlready up to date.\n"
	sleep 0.5
	read -p "Press [Enter] to continue..."
}

upload_github () {
	echo -e "Before performing the manual backup make sure that the repository folder has not been previously modified manually."
	echo -en "Are you sure you want to make the backup? [Y|n]: "
	read re

	if [[ ! ${re,,} =~ ^(n|no)$ ]]; then
		cd $REPOSITORY_LOCAL_DIR >> /dev/null
		git add .
		git commit -m "Backup from $BACKUP_DATE"
		git push
		cd - >> /dev/null
		read -ep $'\nPress [Enter] to continue...'
	fi
}

clear

while :
do
	if [ ! -d $REPOSITORY_LOCAL_DIR ]; then
		echo -en "The dotfile directory does not exist. Do you want to generate it? [Y|n]: "
		gen_dotfile_dir
		read -ep $'\nPress [Enter] to continue...'
		clear
		continue
	fi

	# Menú
	echo -e "1 - Backup your configuration files."
	echo -e "2 - Upload backup to github."
	echo -e "q - Exit."
	read re

	if [[ $re = "1" ]]; then
		backup
		clear
	elif [[ $re = "2" ]]; then
		upload_github
		clear
	elif [[ ${re,,} =~ ^q$ ]]; then
		echo -e "See ya!"
		sleep 0.25
		exit 0
	else
		echo -e "Option not valid."
		sleep 0.25
		clear
	fi
done

exit 1
