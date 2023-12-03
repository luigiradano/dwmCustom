#!/bin/sh

echo "Generating getVolume.sh"

defSink=$(pactl get-default-sink)
echo "Detected sink: $defSink"

fileContent="pactl get-sink-volume $defSink | awk '{print \$5}' | tr -d '\n'"

if [ -f /bin/getVol.sh ]; then
	echo "The volume file is already present!"
	read -p "Should I remove the file? (Y/n)" remFile

	if [ "$remFile" != "n" ]; then
		sudo rm /bin/get.Volsh -rf
		echo "$fileContent" | sudo tee -a /bin/getVol.sh
	else
		echo "Exiting the script"
		exit 1
	fi
else
	echo "$fileContent" | sudo tee -a /bin/getVol.sh
fi

sudo chmod +x /bin/getVol.sh

echo "Done, running script to test it..."

getVol.sh
