#!/bin/bash
mv /usr/share/X11/xkb/symbols/pc /usr/share/X11/xkb/symbols/pc.bak
mv /usr/share/X11/xkb/symbols/altwin /usr/share/X11/xkb/symbols/altwin.bak
mv ~/dotfiles/usr-share-X11-xkb-symbols/pc /usr/share/X11/xkb/symbols/pc
mv ~/dotfiles/usr-share-X11-xkb-symbols/altwin /usr/share/X11/xkb/symbols/altwin
echo "please reboot to effect changes"
