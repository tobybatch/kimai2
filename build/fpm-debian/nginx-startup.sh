#!/bin/bash

# We need to copy the code pass to a new folder and then symlink it back so the scripts work

# We cani't move it as the /opt/shared_kimai is a mounted folder
cd /
cp -r /opt/kimai/*     /opt/shared_kimai/
cp -r /opt/kimai/.???  /opt/shared_kimai/
cp -r /opt/kimai/.???* /opt/shared_kimai/
# Clear the old path and link it back
rm -rf /opt/kimai
ln -s /opt/shared_kimai /opt/kimai
# Use the original start up scriot to initailise the app
cd /opt/shared_kimai
chown -R www-data:www-data /opt/shared_kimai/var
chmod -R g+r /opt/shared_kimai/
chmod -R g+rw /opt/shared_kimai/var/
/startup.sh
