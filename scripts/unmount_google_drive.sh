#!/bin/sh

DRIVE_FOLDER=$HOME/Drive

echo "Unmounting..."
fusermount -uz $DRIVE_FOLDER 2> /dev/null
sleep 1
echo "Drive unmounted..."
exit 0
