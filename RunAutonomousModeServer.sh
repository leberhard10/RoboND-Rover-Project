#Starts up the windows roversim project in autonomous mode
#!/bin/bash

. activate RoboND

cd code
python drive_rover.py ../auto_mode_data/

read -rsp $'Press enter to continue...\n'
