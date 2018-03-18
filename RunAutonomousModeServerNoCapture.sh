#Starts up the windows roversim project in autonomous mode
#!/bin/bash

. activate RoboND

cd code
python drive_rover.py

read -rsp $'Press enter to continue...\n'
