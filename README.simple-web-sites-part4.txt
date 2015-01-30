Simple Web Sites
================

Part 4 - Configuration and Publishing
-------------------------------------

Build a special file on the local host:

  $ make

which results in a binary executable named: copywebsites

Transfer two files to the server:

  $ ./xfer-files-to-server.sh copywebsites cp-incoming-web-site-files.sh

Make some changes on the server:

  $ login.sh go
  am1$ sudo su

  am1# groupadd web-content
  am1# useradd -d /home/apache -g web-content -s /bin/nologin apache

  am1# chown root.root copywebsites
  am1# chmod 4755 copywebsites


Directory layout - client
-------------------------

  web-sites/
    Resources/
    GENFUNCS.pm   
      mysite.org/
        cgi-bin/
        public/
          Resources -> ../../Resources
          genpages.pl
          ...
      newname.org/
        cgi-bin/
        public/
          Resources -> ../../Resources
          genpages.pl
          ...

    
Directory layout - server
-------------------------

  /home/web-sites

  /home/tbrowde/
    web-sites-incoming/

Updating files on the server
----------------------------

First we need an easier way to transfer files to the server via scp.
To do that we need to set up another public/private key set.

  $ cd ; mkdir .ssh ; cd .ssh
  $ ssh-keygen -t rsa
  Generating public/private rsa key pair.
  Enter file in which to save the key (/home/tbrowde/.ssh/id_rsa):
  Enter passphrase (empty for no passphrase):
  Enter same passphrase again:
  Your identification has been saved in /home/tbrowde/.ssh/id_rsa.
  Your public key has been saved in /home/tbrowde/.ssh/id_rsa.pub.
  The key fingerprint is:
  54:d5:f7:37:ec:ed:f2:42:ad:c1:68:18:84:12:b2:7d tbrowde@juvat2
  The key's randomart image is:
  +--[ RSA 2048]----+
  |    . .. .....   |
  |     +. ...   . .|
  |    . ..E.    ...|
  |       o  .    oo|
  |        S  o o..+|
  |          . o +.o|
  |           . . + |
  |              + .|
  |               +.|
  +-----------------+
  $ cp id_rsa.pub id_rsa.pub.juvat2

Now copy the named public key to our working directory.

Send the new key to the server:

  $ ./xfer-files-to-server.sh id_rsa.pub.juvat2

Login to the server and make some more changes:

  $ login.sh go
  am1$ mkdir .ssh
  am1$ mv id_rsa.pub.juvat2 .ssh
  am1$ chmod 700 .ssh
  am1$ cd .ssh
  am1$ cat id_rsa.pub.juvat2 >> authorized_keys


IMPORTANT: Delete the copy of the named public key in the local
working directory after a successful ssh/scp test!




Summary
-------

We've taken the low-level, but powerful route to produce a simple web
suite.  Now take the easy, but still free path.  Among other, similar
offerings, see:

  http://www.weebly.com/

Future Work
-----------

At this point, the next thing to do is expand your knowledge of web
technologies such as:

+ html 
+ css
+ web site frameworks
+ theme templating systems

More high-powered sites will also need forums, databases, and mail
programs.



