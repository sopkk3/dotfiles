#!/usr/bin/env bash

tmpbg='/tmp/screen.png'

(( $# )) && { icon=$1; }

scrot "$tmpbg"
convert "$tmpbg" -scale 10% -scale 1000% "$tmpbg" # imagemagick
i3lock -i "$tmpbg"
rm /tmp/screen.png
