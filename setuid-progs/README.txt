Create a special user and group:

  # groupadd web-content
  # useradd -d /home/apache -g web-content -s /bin/nologin apache

Modify the httpd.conf file accordingly:

  User apache
  Group web-content

Two programs to be transfered to the remote server in your user account:

  copywebsites                  # a binary executable
  cp-incoming-web-site-files.sh # a shell script to copy files and set permissions

Steps:

1. Build the binary executable:

  $ make

2. Transfer the files to the server:

  $ ./xfer-files-to-server.sh copywebsites cp-incoming-web-site-files.sh

3. Login to the server:

  $ ./login.sh

