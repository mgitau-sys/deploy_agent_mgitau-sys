#!/usr/bin/env bash
set -euo pipefail
#prompts the user for name of class 
read -rp "Enter name of class:" name
Parent_Dir=attendance_tracker_$name

bundle_and_exit() {
	exit_code=$? #captures the script exit code
	echo -e "\nInterrupt detected! Bundling parent directory..."
	Archive_name="attendance_tracker_${name}_archive_$(date +%s).tar.gz"
	if [ -d "$Parent_Dir" ]; then
		tar -czf "$Archive_name" "$Parent_Dir"
		echo "archive created:$Archive_name"
		#deleting the incomplete directory
		echo "deleting incomplete project directory"
		rm -rf "$Parent_Dir"
		echo "Project directory has been deleted"
	else 
		echo "Project directory '$Parent_Dir' does not exist.Therefore,nothing to archive."
	fi
	exit $exit_code
}

trap bundle_and_exit SIGINT
echo "press contor +c to test trap"
while true; do
	sleep 1
done 

mkdir -p "$Parent_Dir"
touch "$Parent_Dir/attendance_checker.py"
mkdir -p "$Parent_Dir/Helpers"
touch "$Parent_Dir/Helpers/assets.csv"
touch "$Parent_Dir/Helpers/config.json"
mkdir -p "$Parent_Dir/reports"
touch "$Parent_Dir/reports/reports.log"


#dynamic configuration of threshold
read -rp "Do you want to update the attendance threshold? (y/n)?" updates
if [[ "$updates" == "y" || "$updates" == "Y" ]]; then 
	read -rp "Enter new values for warning(default 75%)" warning
	warning=${warning:-75} #warning is empty or unset use default value 75
	read -rp "Enter new values for failure(default 50%?)" failure
	failure=${failure:-50} #failure is empty or unset use default value 50

	#updating warning and failure values using in place sed
	config_json="$Parent_Dir/Helpers/config.json"
	sed -i "s/\"warning\": *[0-9]\+/\"warning\": $warning/" "$config_json"
	sed -i "s/\"failure\": * [0-9]\+/\"failure\": $failure/" "$config_json"
	echo "threshold updated successfully"
else
	echo "no changes made"
fi
