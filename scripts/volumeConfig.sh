#!/bin/sh
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

	sudo chmod +x $1
	
	echo "Write completed, running script"

	$1
}

echo "Generating getVol.sh"

defSink=$(pactl get-default-sink)
echo "Detected sink: $defSink"
fileContent="pactl get-sink-volume $defSink | awk '{print \$5}' | tr -d '\n'"

writeScript /bin/getVol.sh "$fileContent"

echo "Generating setVol.sh"
fileContent="#!/bin/sh\npactl set-sink-volume $defSink \$1\nstatus=\$(getVol.sh)\nxprop -root -set WM_NAME \"Set volume:\$status\""

writeScript /bin/setVol.sh "$fileContent"
