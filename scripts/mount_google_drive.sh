#!/bin/sh

DRIVE_FOLDER=$HOME/Drive
F_READ_ONLY="--read_only"

if [ -d $DRIVE_FOLDER ]; then 
	fusermount -uz $DRIVE_FOLDER 2> /dev/null
	sleep 0.1
	rmdir $DRIVE_FOLDER
fi

mkdir -p $DRIVE_FOLDER
echo "Mounting..."
rclone about Drive:
sleep 0.3

while test $# -gt 0; do
	case "$1" in
		"-w"|"--write") 
			$F_READ_ONLY=""
			break;;
		*) break;;
	esac
done
