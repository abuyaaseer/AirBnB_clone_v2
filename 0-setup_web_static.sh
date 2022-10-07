#!/usr/bin/env bash
# Bash script that sets up the server for the deployment of web-static
# Install Nginx server if not already installed
sudo apt-get update
sudo apt-get -y install nginx
sudo service nginx start
# Create folder /data/web_static/releases/test/ if not exists
mkdir -p /data/web_static/releases/test/
# Create folder /data/web_static/shared/ if not exists
mkdir -p /data/web_static/shared/
# Create a fake HTML file /data/web_static/releases/test/index.html
echo "<html><head></head><body>Success</body></html>" > /data/web_static/releases/test/index.html
# Create a symbolic link /data/web_static/current linked to the /data/web_static/releases/test/ folder
# if link exists, delete and remake each time the script is run
if [ -h '/data/web_static/current' ]
then
	rm /data/web_static/current
	ln -s /data/web_static/releases/test/ /data/web_static/current
else
	ln -s /data/web_static/releases/test/ /data/web_static/current
fi
# Give ownership of /data/ folder to ubuntu user and group, recursively
chown -R ubuntu: /data/
# Update the Nginx configuration to serve the content of /data/web_static/current/ to hbnb_static
TO_FIND="^server {$"
TO_ADD="server {\n\tlocation \/hbnb_static\/ {\n\t\talias \/data\/web_static\/current\/;\n\t}\n"
sudo sed -i "s/$TO_FIND/$TO_ADD/" /etc/nginx/sites-available/default
sudo service nginx reload
