#!/bin/bash
# several arguments which are set in the CyVerse app front-end are passed to this script
#	$0 = the name of this script
#	$1 = the GWB module to run
#	$2 = the user's Data Store input directory
#	$3 = what to name the output directory in the user's Data Store analyes folder
# The dockerfile starts this shell with user ubuntu in directory /home/ubuntu/data-store
#
# ? is this needed? This exposes $IPLANT_USER's external Data Store volumes within the container at: ~/data-store/. 
echo '{"irods_host": "data.cyverse.org", "irods_port": 1247, "irods_user_name": "$IPLANT_USER", "irods_zone_name": "iplant"}' | envsubst > $HOME/.irods/irods_environment.json
# CyVerse automatically copies the contents of /home/ubuntu/data-store to the user's Data Store analysis folder.
#	Exception: CyVerse copies the user's input data directory into ~/data-store/, but that directory is EXCLUDED.
#
# GWB needs within-container input and output directories because it reads and writes to both of them.
mkdir /home/ubuntu/input /home/ubuntu/output/
cp -a /home/ubuntu/data-store/$2/. /home/ubuntu/input/
sudo chown -R ubuntu:ubuntu /home/ubuntu/
chmod -R 777 /home/ubuntu/input
chmod -R 777 /home/ubuntu/output
# Create the Data Store output directory. This must be here and not in the dockerfile. This
#	directory will appear in the user's Data Store analyses folder.
mkdir /home/ubuntu/data-store/$3
# Execute GWB module
echo " try running $1 --nox -i=/home/ubuntu/input -o=/home/ubuntu/output:"
$1 --nox -i=/home/ubuntu/input -o=/home/ubuntu/output
# copy the GWB outputs to user's data-store analysis folder
cp -a /home/ubuntu/output/. /home/ubuntu/data-store/$3/
#
# put test file into output directory
echo "Putting a test file directly into /home/ubuntu/output/, and test copying to /home/ubuntu/data-store/$3"
echo "fubar" >> /home/ubuntu/output/test.txt
echo "fubar" >> test2.txt
cp test2.txt /home/ubuntu/data-store/$3/
echo "ls -alR on /home/ubuntu"
ls -alR /home/ubuntu
echo " "
echo "try to find directories writable by current user, find /home -type d -writable >> list.txt"
# https://unix.stackexchange.com/questions/22421/find-a-users-writable-files-and-directories
find /home -type d -writable >> list.txt
echo "cat list.txt"
cat list.txt  
echo " "
echo "try to find FILES writable by current user, find /home -type f -writable >> list2.txt"
# https://unix.stackexchange.com/questions/22421/find-a-users-writable-files-and-directories
find /home -type f -writable >> list2.txt
echo "cat list2.txt"
cat list2.txt  
 

# -----------Debug info will be written to logs/condor-stdout-0 and condor-stderr-0 in the user's Data Store "analyses" directory
echo " "
echo "debug info..."
echo "this is whoami:"
whoami
echo "this is USER:"
echo $USER
echo "this is HOME:"
echo $HOME
echo "this is the uid:"
id -u ubuntu
echo "this is the gid:"
id -g ubuntu
echo "the user is a member of these groups:"
id -G ubuntu
# CyVerse provides $IPLANT_USER as the current user (who is running the container). e.g., "kriitters"
echo "this is the current CyVerse username: $IPLANT_USER"  
echo "the name of this shell is: $0"  							# /bin/entry.sh
echo "these are the run-time parameters set in the DE app:"
echo "this is the GWB script: $1" 								# /usr/bin/<GWB script>
echo "this is the external Data Store input directory: $2"		# <a user-selected directory in user's Data Store>
echo "this is the external analyses output directory: $3"		# <a user-defined name used to create a directory in the "analyses" folder in the user's Data Store>
echo "listing of /home/ubuntu/data-store/$3/"
ls -al /home/ubuntu/data-store/$3
echo "listing of the input directory outside the container:"
ls -al /home/ubuntu/data-store/$2
echo "Environment:"
env
#echo "/home/ubuntu/.bashrc"
#cat /home/ubuntu/.bashrc

