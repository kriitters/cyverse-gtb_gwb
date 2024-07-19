#!/bin/bash
# several arguments which are set in the CyVerse app front-end are passed to this script
#	$0 = the name of this script
#	$1 = the GWB module to run
#	$2 = the user's Data Store input directory
#	$3 = what to name the output directory in the user's Data Store analyes folder
# The dockerfile starts this shell with user ubuntu in directory /home/ubuntu/data-store
#
# This exposes $IPLANT_USER's external Data Store volumes within the container at: ~/data-store/. 
echo '{"irods_host": "data.cyverse.org", "irods_port": 1247, "irods_user_name": "$IPLANT_USER", "irods_zone_name": "iplant"}' | envsubst > $HOME/.irods/irods_environment.json
#
cd /home/ubuntu
# GWB needs write permissions on the input directory (why?); this can't be done in the dockerfile
#	as it is mounted with a dynamic name. sudo needed because root is owner.
sudo chown ubuntu:ubuntu /home/ubuntu/data-store/$2
# Create a temporary output directory; GWB reads and writes in this temporary directory
#	which will be copied to the data-store directory later
mkdir /home/ubuntu/output
# Create the Data Store output directory. This must be here and not in the dockerfile. This
#	directory appears in the user's Data Store analyses folder.
mkdir /home/ubuntu/data-store/$3
#
# fix up GWB things for user. /tmp/.gwb/ contains EULA.txt
# ln -s /tmp/.gwb /home/ubuntu/.gwb
# this ln is now done in the dockerfile

# more testing of .gwb
#GWBCONF="${HOME}/.gwb/"
#echo "this is GWBCONF: $GWBCONF"
#echo "this is GWBCONF in 'dollar_sign{GWBCONF}': '${GWBCONF}'"
#echo my username is: `whoami`
#echo my user variable is: $USER
#echo my logname is: $LOGNAME
#echo GWBCONF directory is: $GWBCONF
#if [ -d "$GWBCONF" ];then echo directory GWBCONF exists ;fi
#echo "this is ls -la $GWBCONF"
#ls -la $GWBCONF
#touch $GWBCONF/weirdo.txt
#echo "this is ls -la $GWBCONF/weirdo.txt:"
#ls -la $GWBCONF/weirdo.txt
#if [ ! -w "$GWBCONF" ];then 
#  echo "You have no write permissions in the directory '${GWBCONF}'"
#  exit 1
#fi  


# example command line to run the module (script) GWB_ACC:
#		/usr/bin/GWB_ACC --nox -i=<path to input> -o=<path to output>
# (--nox tells GWB there is no x server)
# The temporary  output directory is created above
bash -c "$1  --nox  -i=/home/ubuntu/data-store/$2 -o=/home/ubuntu/output"
# put a test file into output directory
echo "fubar" >> /home/ubuntu/output/test.txt
# copy the GWB outputs to user's data-store analysis folder
cp -a /home/ubuntu/output/. /home/ubuntu/data-store/$3/
# CyVerse automatically copies the contents of /home/ubuntu/data-store to the user's Data Store analysis folder.
#	Exception: CyVerse copies the user's input data directory into ~/data-store/, but that directory is EXCLUDED.
#
# -----------Debug info will be written to logs/condor-stdout-0 and condor-stderr-0 in the user's Data Store "analyses" directory
# user who is running the shell
echo "this is the shell user:"
whoami
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
echo "this is the current directory:"
pwd
echo "ls -al on the /home directory:"
ls -al /home
echo "listing of /home/ubuntu"
ls -al /home/ubuntu/
echo "listing of /tmp"
ls -al /tmp/
echo "listing of /tmp/.gwb"
ls -al /tmp/.gwb
echo "listing of /home/ubuntu/data-store/$3/"
ls -al /home/ubuntu/data-store/$3
echo "listing of the input directory outside the container:"
ls -al /home/ubuntu/data-store/$2
echo "Environment"
env

