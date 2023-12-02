#!/bin/sh

LOCALE="it,it"

echo "Editing keyboard config to $LOCALE layout"

FILECONTENT=$(cat /etc/X11/xorg.conf.d/30-keyboard.conf)

if [[ $FILECONTENT == *$LOCALE* ]]; then
	echo "Already set to chosen locale"
else
	printf "Section \"InputClass\"\n\tIdentifier \"keyboard\"\n\tMatchIsKeyboard \"on\"\n\tOption \"XKbLayout\" '$LOCALE'\nEndSection" >> /etc/X11/xorg.conf.d/30-keyboard.conf
fi
echo "Done !"

