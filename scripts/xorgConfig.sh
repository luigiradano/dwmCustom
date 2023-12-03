#!/bin/sh

LOCALE="it,it"

writeScript (){
	# $1 is filename, 1st argument
	# $2 is file content to write, 2nd argument
	
	if [ -f $1 ]; then
		echo "WARN: The file $1 is already present!"
		read -p "Should the file be removed? (Y/n)" remFile

		if [ "$remFile" == "n" ]; then
			echo "Aborting script"
			exit 2
		fi

		sudo rm -rf $1
	fi
	
	printf "$2" | sudo tee -a $1

}


echo "Editing keyboard config to $LOCALE layout"

FILECONTENT=$(cat /etc/X11/xorg.conf.d/30-keyboard.conf)

if [[ $FILECONTENT == *$LOCALE* ]]; then
	echo "Already set to chosen locale"
else
	printf "Section \"InputClass\"\n\tIdentifier \"keyboard\"\n\tMatchIsKeyboard \"on\"\n\tOption \"XKbLayout\" '$LOCALE'\nEndSection" >> /etc/X11/xorg.conf.d/30-keyboard.conf
fi
echo "Done !"

echo "Editing touchpad scrolling"
fileContent="Section \"InputClass\"\n\tIdentifier \"touchpad\"\n\tDriver \"libinput\"\n\tMatchIsTouchpad \"on\"\n\tOption \"Tapping\" \"on\"\n\tOption \"NaturalScrolling\" \"true\"\nEndSection"
writeScript /etc/X11/xorg.conf.d/30-touchpad.conf "$fileContent"
echo "Done !"

echo "Editing AMD gpu config"
fileContent="Section \"OutputClass\"\n\tIdentifier \"AMD\"\n\tMatchDriver \"amdgpu\"\n\tDriver \"amdgpu\"\nEndSection"

writeScript /etc/X11/xorg.conf.d/20-amdgpu.conf "$fileContent"
