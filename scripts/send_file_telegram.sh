#!/bin/bash

/usr/bin/telegram-desktop -sendpath $(readlink -f $1)
