#!/bin/bash

CONFIG_DIR="$HOME/.config"
SCRIPT_DIR="$HOME/Scripts"
REPOSITORY_LOCAL_DIR="$HOME/Workspace/dotfiles"
BACKUP_DATE=`date +%b-%d-%y`

dont_worry () {
	echo -e "Don't worry"
	sleep 0.25
	exit 127
}

gen_dotfile_dir () {
	echo -en "The dotfile directory does not exist. Do you want to generate it? [Y|n]: "
	read re

	if [[ ${re,,} =~ ^(n|no)$ ]]; then
		dont_worry
	fi	
	
	# Check if Workspace directory exists and generate it in case it doesn't
	[ ! -d $HOME/Workspace ] && mkdir $HOME/Workspace
	git clone https://github.com/MaEscalanteHe/dotfiles.git $REPOSITORY_LOCAL_DIR	
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

restore_copy () {
	[ ! -d $CONFIG_DIR ] && mkdir -pv $CONFIG_DIR
	[ ! -d $SCRIPT_DIR ] && mkdir -pv $SCRIPT_DIR

	case $2 in
		".config") cp -ruv $1 "$CONFIG_DIR/";;
		"scripts") cp -ruv $1 "$SCRIPT_DIR/";;
		"home") cp -uv $1 "$HOME/"
	esac

	sleep 0.25
}

backup () {
	echo -e "\nCopy .config directory...\n"

	[ -d $CONFIG_DIR/bspwm ] && backup_copy "$CONFIG_DIR/bspwm" ".config"
	[ -d $CONFIG_DIR/sxhkd ] && backup_copy "$CONFIG_DIR/sxhkd" ".config"
	[ -d $CONFIG_DIR/polybar ] && backup_copy "$CONFIG_DIR/polybar" ".config"
	[ -d $CONFIG_DIR/compton ] && backup_copy "$CONFIG_DIR/compton" ".config"
	[ -d $CONFIG_DIR/fish ] && backup_copy "$CONFIG_DIR/fish" ".config"
	[ -d $CONFIG_DIR/omf ] && backup_copy "$CONFIG_DIR/omf" ".config"
	[ -d $CONFIG_DIR/zsh ] && backup_copy "$CONFIG_DIR/zsh" ".config"
	[ -d $CONFIG_DIR/dunst ] && backup_copy "$CONFIG_DIR/dunst" ".config"
	[ -d $CONFIG_DIR/terminator ] && backup_copy "$CONFIG_DIR/terminator" ".config"

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

restore () {
	echo -en "NOTICE! Restoring dotfiles can delete files that are already configured without prior notice. If you are sure of what you are doing you can continue.\nAre you sure you want to restore the dotfiles? [Y|n]: "
	read re

	if [[ ${re,,} =~ ^(n|no)$ ]]; then
		dont_worry
	fi

	echo -e "\nRestore .config directory...\n"
	
	restore_copy "$REPOSITORY_LOCAL_DIR/.config/*" ".config"

	sleep 0.5
	echo -e "\nRestore Script directory...\n"
	restore_copy "$REPOSITORY_LOCAL_DIR/scripts/*" "scripts"

	sleep 0.5
	echo -e "\nRestore other files in home directory...\n"
	restore_copy "$REPOSITORY_LOCAL_DIR/.fehbg" "home"
	restore_copy "$REPOSITORY_LOCAL_DIR/.p10k.zsh" "home"
	restore_copy "$REPOSITORY_LOCAL_DIR/.xinitrc" "home"
	restore_copy "$REPOSITORY_LOCAL_DIR/.zshrc" "home"

	sleep 0.5
	echo -e "\nRestore complete successfully."
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
		gen_dotfile_dir
		read -ep $'\nPress [Enter] to continue...'
		clear
		continue
	fi

	# Menú
	echo -e "1 - Backup your configuration files."
	echo -e "2 - Restore your configuration files."
	echo -e "3 - Upload backup to github."
	echo -e "q - Exit."
	read -ep "Option: " re

	if [[ $re = "1" ]]; then
		backup
		clear
	elif [[ $re = "2" ]]; then
		restore
		clear
	elif [[ $re = "3" ]]; then
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
