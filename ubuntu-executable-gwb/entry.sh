#!/bin/bash
# several arguments which are set in the CyVerse app front-end are passed to this script
#	$0 = the name of this script
#	$1 = the GWB script to run
#	$2 = the user's Data Store input directory
#	$3 = what to name the output directory in the user's Data Store analyes folder
# The dockerfile starts this shell with user ubuntu
#
# This exposes $IPLANT_USER's external Data Store volumes within the container at: ~/data-store/. 
echo '{"irods_host": "data.cyverse.org", "irods_port": 1247, "irods_user_name": "$IPLANT_USER", "irods_zone_name": "iplant"}' | envsubst > $HOME/.irods/irods_environment.json
#
# GWB needs write permissions on the input directory; this can't be done in the dockerfile.
#	CyVerse automatically creates this folder but it has root ownership.
sudo chown ubuntu:ubuntu /home/ubuntu/data-store/$2
#
# Create the GWB output directory that CyVerse will write to the Data Store analyses folder.
mkdir /home/ubuntu/data-store/$3
# Note that everything that is put into /home/ubuntu/data-store/, EXCEPT the input directory, is copied
#	by CyVerse into the users Data Store analyses folder after the analysis is completed.
#
# Construct a command to evaluate. The form of the command is:
#		/usr/bin/GWB_ACC --nox -i=<path to input> -o=<path to output>
# 		--nox tells GWB there is no x server (an artifact of GWB's IDL roots).
#		-o points to a directory inside the container, which is created by user ubuntu in the dockerfile.
#			GWB writes and reads intermediate things from the -o directory, so it must be inside the container.
#			After the evaluation, the contents of -o are copied into the Data Store analyses folder
NOX="--nox"
TMP_DIR="-o=/home/ubuntu/output"
cmd=( $1 )
[[ -n "$NOX" ]] && cmd+=( "$NOX" )
[[ -n "$2" ]] && cmd+=( "-i=/home/ubuntu/data-store/$2" )
[[ -n "$TMP_DIR" ]] && cmd+=( "$TMP_DIR" )
eval "${cmd[@]}"
# Now copy the outputs to the Data Store
cp -r /home/ubuntu/output/* /home/ubuntu/data-store/$3

# -----------Debug info will be written to logs/condor-stdout-0 and condor-stderr-0 in the user's Data Store "analyses" directory
echo "this is the command to eval: ${cmd[@]}"
# user who is running the shell
echo "this is the shell user:"
whoami
echo "this is the current directory:"
pwd
# CyVerse provides $IPLANT_USER as the current user (who is running the container). e.g., "kriitters"
echo "this is the current CyVerse username: $IPLANT_USER"  
echo "the name of this shell is: $0"  							# /bin/entry.sh
echo "these are the run-time parameters set in the DE app:"
echo "this is the GWB script: $1" 								# /usr/bin/<GWB script>
echo "this is the external Data Store input directory: $2"		# <a user-selected directory in user's Data Store>
echo "this is the external analyses output directory: $3"		# <a user-defined name used to create a directory in the "analyses" folder in the user's Data Store>
echo "ls -al on current directory:"
ls -al
echo "ls -al on the /home directory:"
ls -al /home
echo "ls -al on the /home/.gwb directory:"
ls -al /home/.gwb
echo "listing of /home/ubuntu"
ls -al /home/ubuntu/
echo "listing of /home/ubuntu/data-store/$3/"
ls -al /home/ubuntu/data-store/$3
echo "listing of /home/ubuntu/output"
ls -al /home/ubuntu/output
echo "listing of /home/ubuntu/.gwb"
ls -al /home/ubuntu/.gwb
echo "listing of the input directory outside the container:"
ls -al /home/ubuntu/data-store/$2
