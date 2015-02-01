Simple Web Sites
================

Part 4 - Configuration and Publishing
-------------------------------------

Build a special file on the local host:

  $ cd setuid-progs
  $ make

which results in two binary executables named:

  on-server-copy-httpdconf
  on-server-copy-websites

Transfer four files to the server:

  $ make xfer

Make some changes on the server:

  $ ssh am1
  am1$ sudo su

  am1# groupadd web-content
  am1# useradd -d /home/apache -g web-content -s /bin/nologin apache

  am1# chown root.root on-server-copy-httpdconf on-server-copy-websites
  am1# chmod 4755 on-server-copy-httpdconf on-server-copy-websites

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




Summary
-------

We've taken the low-level, but powerful route to produce a simple web
suite.  Now take the easy, but still free path.  Among other, similar
offerings, see:

  http://www.weebly.com/
  http://www.wix.com/

Future Work
-----------

At this point, the next thing to do is expand your knowledge of web
technologies such as:

+ html5
+ css3
+ web site frameworks
+ theme templating systems
+ https

More high-powered sites will also need forums, databases, and mail
programs.

In planning
===========

I plan to make a Part 5 which covers use of https to run secure sites.
