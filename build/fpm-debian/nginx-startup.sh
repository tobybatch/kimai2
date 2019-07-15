#!/bin/bash

# We need to copy the code pass to a new folder and then symlink it back so the scripts work

# We can move it as the /opt/kimai is amounted folder
cd /
cp -r /opt/kimai /opt/shared_kimai
# Clear the old path and link it back
rm -rf /opt/kimai
ln -s /opt/shared_kimai /opt/kimai
# Use the original start up scriot to initailise the app
cd /opt/shared_kimai
/startup.sh
