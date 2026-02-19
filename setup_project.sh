#!/usr/bin/env bash
#!/bin/bash

bundle_and_exit() {
    echo -e "\nInterrupt detected! Bundling parent directory..."
    if [ -d "$Parent_Dir" ]; then
        Archive_name="attendance_tracker_${name}_archive_$(date +%s).tar.gz"
        tar -czf "$Archive_name" "$Parent_Dir"
        echo "Archive created: $Archive_name"
        rm -rf "$Parent_Dir"
        echo "Project directory has been deleted"
    else
        echo "No project directory to archive."
    fi
    exit 1  # ensures the script stops
}

trap bundle_and_exit SIGINT

set -euo pipefail
#prompts the user for input
read -rp "Enter identifier input:" name
echo ""
while [[ -z "$name" ]]; do
	echo "name cannot be empty."
	read -rp "Enter identifier input:" name
done
while true; do
Parent_Dir=attendance_tracker_$name
if [[ -d "$Parent_Dir" ]]; then
	echo "Warning: Directory '$Parent_Dir' already exists"
	read -rp "Do you want to overwrite it? (y/n):" choice
	if [[ "$choice" =~ ^[Yy]$ ]]; then
		rm -rf "$Parent_Dir"
		mkdir "$Parent_Dir"
		break
else
	read -rp "Enter a new identifier:" name
	while [[ -z "$name" ]]; do
		echo "name cannot be empty."
		read -rp "Enter a new identifier input:" name
	done
	fi
else
	mkdir "$Parent_Dir"
	break
fi
done

echo ""

touch "$Parent_Dir/attendance_checker.py"
mkdir -p "$Parent_Dir/Helpers"
touch "$Parent_Dir/Helpers/assets.csv"
touch "$Parent_Dir/Helpers/config.json"
mkdir -p "$Parent_Dir/reports"
touch "$Parent_Dir/reports/reports.log"
echo "================================="
echo "Project structure created succefully."

echo "Project structure for '$Parent_Dir':"
tree "$Parent_Dir"

cp source_files/attendance_checker.py "$Parent_Dir/"
cp source_files/assets.csv "$Parent_Dir/Helpers/"
cp source_files/config.json "$Parent_Dir/Helpers/"
cp source_files/reports.log "$Parent_Dir/reports/"


echo ""
echo "Copying source files..."
cp source_files/attendance_checker.py "$Parent_Dir/"
cp source_files/assets.csv "$Parent_Dir/Helpers/"
cp source_files/config.json "$Parent_Dir/Helpers/"
cp source_files/reports.log "$Parent_Dir/reports/"
if cp source_files/attendance_checker.py "$Parent_Dir/"; then
    echo "attendance_checker.py copied successfully"
else
    echo "Failed to copy attendance_checker.py"
    exit 1
fi

# Copy assets file
if cp source_files/assets.csv "$Parent_Dir/Helpers/"; then
    echo "assets.csv copied successfully"
else
	echo "Failed to copy assets.csv"
    exit 1
fi

# Copy configuration file
if cp source_files/config.json "$Parent_Dir/Helpers/"; then
    echo "config.json copied successfully"
else
    echo "Failed to copy config.json"
    exit 1
fi
echo ""
echo "All files copied successfully."

#dynamic configuration of threshold
default_warning=75
default_failure=50
echo "Warning threshold: $default_warning"
echo "Failure threshold: $default_failure"

read -rp "Do you want to update the attendance threshold? (y/n)?" updates
if [[ "$updates" == "y" || "$updates" == "Y" ]]; then 
	while true; do 
		read -rp "Enter new values for warning(default 75%)" warning
		warning=${warning:-75} #warning is empty or unset use default value 75
		if [[ "$warning" =~ ^[0-9]+$ ]]; then
			break
		else
			echo "Error: Please enter a valid numeric number"
		fi
	done

	while true; do
		read -rp "Enter new values for failure(default 50%?)" failure
		failure=${failure:-50} #failure is empty or unset use default value 50
		if [[ "$failure" =~ ^[0-9]+$ ]]; then
			break
		else
			echo "Error: Please enter a valid numeric number"
		fi
	done

	#updating warning and failure values using in place sed
	config_json="$Parent_Dir/Helpers/config.json"
	sed -i "s/\"warning\": *[0-9]\+/\"warning\": $warning/" "$config_json"
	sed -i "s/\"failure\": * [0-9]\+/\"failure\": $failure/" "$config_json"
	echo "threshold updated successfully"
	echo "warning threshold: $warning"
	echo "failure threshold: $failure"
else
	echo "no changes made"
	echo "Warning threshold: $default_warning"
	echo "Failure threshold: $default_failure"
fi

echo "Running Health check..."
# code to check if python 3 exists
if command -v python3 >/dev/null 2>&1; then
	echo "Python3 is installed"
else
	echo "Python3 is not installed"
fi
