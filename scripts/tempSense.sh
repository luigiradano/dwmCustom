#!/bin/sh

echo "Generating temperature read executable for SlStatus"

if [ "$USER" != "root" ]; then
	echo "Please run the script as root"
	exit 2
fi

read -p "What is the sensor to use as temperature? " sensorName

fileContent="sensors | grep $sensorName | awk {'print \$2'}"

if [ -f /bin/getTemp.sh ]; then
	echo "The sensor file is already present!"
	read -p "Should I remove the file? (Y/n)" remFile

	if [ "$remFile" != "n" ]; then
		rm /bin/getTemp.sh -rf
	else
		echo "Exiting the script"
		exit 1
	fi
else
	echo "$fileContent" >> /bin/getTemp.sh
fi

chmod +x /bin/getTemp.sh

echo "Done, running script to test it..."

getTemp.sh

