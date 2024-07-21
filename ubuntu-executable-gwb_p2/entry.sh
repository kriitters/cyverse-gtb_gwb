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

export USER=ubuntu
export HOME=/home/ubuntu
echo "this is whoami:"
whoami
echo "this is USER:"
echo $USER
echo "this is HOME:"
echo $HOME
echo "/home directory:"
ls -al /home
echo "/home/ubuntu/ before adding ~/.gwb"
ls -al /home/ubuntu
echo "create /home/ubuntu/.gwb with chmod a+rw and re-do"
mkdir /home/ubuntu/.gwb
chmod a+rw /home/ubuntu/.gwb
ls -al /home/ubuntu
echo "touching EULA and putting two test files into /home/ubuntu/.gwb"
touch /home/ubuntu/.gwb/EULA.txt
echo "fubar" >> /home/ubuntu/.gwb/test.txt
echo "fubar" >> test2.txt
cp test2.txt /home/ubuntu/.gwb/
echo "ls -lr on /home/ubuntu/.gwb:"
ls -lr /home/ubuntu/.gwb
echo "test write permissions with: if [ -w /home/ubuntu/.gwb ]"
if [ -w /home/ubuntu/.gwb ]
then 
  echo "You have write permissions in the directory /home/ubuntu/.gwb"
else
  echo "Your do not have write permissions in the directory /home/ubuntu/.gwb"
fi 
echo "test write permissions using GWB method with GWBCONF=${HOME}/.gwb/"
GWBCONF="${HOME}/.gwb/"
if [ ! -w "$GWBCONF" ];then 
  echo "You have no write permissions in the directory '${GWBCONF}'"
fi   
echo "end of test write permissions"
echo "Look at stat /home/ubuntu/.gwb"
stat /home/ubuntu/.gwb
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

echo " "
echo "Try running bash -c $1  --nox  -i=/home/ubuntu/data-store/$2 -o=/home/ubuntu/output:"
# example command line to run the module (script) GWB_ACC:
#		/usr/bin/GWB_ACC --nox -i=<path to input> -o=<path to output>
# (--nox tells GWB there is no x server)
# The temporary  output directory is created above
bash -c "$1  --nox  -i=/home/ubuntu/data-store/$2 -o=/home/ubuntu/output"
echo " try running $1 --nox -i=/home/ubuntu/data-store/$2 -o=/home/ubuntu/output:"
$1 --nox -i=/home/ubuntu/data-store/$2 -o=/home/ubuntu/output

# put a test file into output directory
echo "Putting a test file into /home/ubuntu/output, and copying to /home/ubuntu/data-store/$3"
echo "fubar" >> /home/ubuntu/output/test.txt
# copy the GWB outputs to user's data-store analysis folder
cp -a /home/ubuntu/output/. /home/ubuntu/data-store/$3/
# CyVerse automatically copies the contents of /home/ubuntu/data-store to the user's Data Store analysis folder.
#	Exception: CyVerse copies the user's input data directory into ~/data-store/, but that directory is EXCLUDED.
#
# -----------Debug info will be written to logs/condor-stdout-0 and condor-stderr-0 in the user's Data Store "analyses" directory

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

