Create a special user and group:

  # groupadd web-content
  # useradd -d /home/apache -g web-content -s /bin/nologin apache

Modify the httpd.conf file accordingly:

  User apache
  Group web-content

Four programs to be transferred to the remote server in your user account:

  on-server-copy-websites      # a binary executable
  on-server-copy-websites.sh   # a shell script to copy files and set permissions
  on-server-copy-httpdconf     # a binary executable
  on-server-copy-httpdconf.sh  # a shell script to copy files and set permissions

Steps:

1. Build the binary executable:

  $ make

2. Transfer the files to the server:

  $ make xfer

