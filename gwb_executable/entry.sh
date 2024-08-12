#!/bin/bash
# several arguments which are set in the CyVerse app front-end are passed to this script
#	$0 = the name of this script
#	$1 = the GWB module to run
#	$2 = the user's Data Store input directory
#	$3 = what to name the output directory in the user's Data Store analyes folder
# The dockerfile starts this shell with user ruser in directory /home/ruser/data-store
#
# ? is this needed? This exposes $IPLANT_USER's external Data Store volumes within the container at: ~/data-store/. 
echo '{"irods_host": "data.cyverse.org", "irods_port": 1247, "irods_user_name": "$IPLANT_USER", "irods_zone_name": "iplant"}' | envsubst > $HOME/.irods/irods_environment.json
# CyVerse automatically copies the contents of /home/ruser/data-store to the user's Data Store analysis folder.
#	Exception: CyVerse copies the user's input data directory into ~/data-store/, but that directory is EXCLUDED.
#
# GWB needs within-container input and output directories because it reads and writes to both of them.
mkdir /home/ruser/input/ /home/ruser/output/
cp -a /home/ruser/data-store/$2/. /home/ruser/input/
# Create the Data Store output directory. This must be here and not in the dockerfile. This
#	directory will appear in the user's Data Store analyses folder.
mkdir /home/ruser/data-store/$3
# Execute GWB module
echo " The GWB command is $1 --nox -i=/home/ruser/input -o=/home/ruser/output:"
$1 --nox -i=/home/ruser/input -o=/home/ruser/output
# copy the GWB outputs to user's data-store analysis folder
cp -a /home/ruser/output/. /home/ruser/data-store/$3/
#
# -----------Debug info will be written to logs/condor-stdout-0 and condor-stderr-0 in the user's Data Store "analyses" directory
# CyVerse provides $IPLANT_USER as the current user (who is running the container). e.g., "kriitters"
echo "this is the current CyVerse username: $IPLANT_USER"  
echo "the name of this shell is: $0"  							# /bin/entry.sh
echo "these are the run-time parameters set in the DE app:"
echo "this is the GWB script: $1" 								# /usr/bin/<GWB script>
echo "this is the external Data Store input directory: $2"		# <a user-selected directory in user's Data Store>
echo "this is the external analyses output directory: $3"		# <a user-defined name used to create a directory in the "analyses" folder in the user's Data Store>
echo "ls alR on /home:"
ls -alR /home
echo " "
echo "------Environment------"
env

 


