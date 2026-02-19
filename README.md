How To Run The Script
Open your termial
Navigate to the directory where the script is located
Make your script executable by using:
    chmod +x setup_project.sh
Run the script using :
   ./setup_project.sh

   Follow the prompts:
   1. enter the user identifier
   2. press 'y' or 'Y' to update the threshold numeric values

How To Trigger the Archive Feature
    This script includes a SIGINT trap 
    To trigger it :
      Press Control+c while the script is running 
    When triggered the script will:
      1. Detect the interruption
      2.create a compressed archive of the partially created project
      3.Delete the incomplete project folder
      4.Exit cleanly
This below is a Directory structure example
```
attendance_tracker_c1/
├── attendance_checker.py
├── Helpers
│   ├── assets.csv
│   └── config.json
└── reports
    └── reports.log
```
