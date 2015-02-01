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
  am1# exit

Send the httpd.conf and modules file to the server:

  am1$ ./send-httpd-conf.sh go

Test and start apache (as root):

  am1$ sudo su
  am1#
  am1# /usr/local/apache2/bin/apachectl start -t
  Syntax OK
  am1# /usr/local/apache2/bin/apachectl start
  [Sun Feb 01 21:42:08.960868 2015] [core:warn] [pid 25030:tid 140191410218880] AH00111: Config variable ${PROJECT} is not defined
  [Sun Feb 01 21:42:08.961006 2015] [core:warn] [pid 25030:tid 140191410218880] AH00111: Config variable ${TLD} is not defined
  am1# /usr/local/apache2/bin/apachectl start
  [Sun Feb 01 21:42:08.960868 2015] [core:warn] [pid 25030:tid 140191410218880] AH00111: Config variable ${PROJECT} is not defined
  [Sun Feb 01 21:42:08.961006 2015] [core:warn] [pid 25030:tid 140191410218880] AH00111: Config variable ${TLD} is not defined
  httpd (pid 10141) already running

The strange warnings are a consequence of the macros in the httpd.conf
file.  Ignore them for now--they are, in my opinion, the result of an
apache bug and I am pursuing the issue.

Now work on the web site contents.

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

  /home/ubuntu/
    web-sites-incoming/

Updating files on the local host and the server
-----------------------------------------------

First edit files as desired in directory "web-sites" and its
subdirectories.  Then execute:

  $ ./send-web-sites.sh gen-only

and check the local site:

  $ run-iceweasel.sh &

When satisfied with the site and ready to push it to the remote server
(publish), execute:

  $ ./send-web-sites all

or, if not the original push, execute:

  $ ./send-web-sites mysite.org

and you should see the site when you point your browser to the
server's IP address (or domain name if you have one).

IP address from Part 3:

  54.84.43.106

Setting apache for automatically starting at boot time
------------------------------------------------------

On the server, stop apache if it's running (as root):

  am1$ sudo su
  am1#
  am1# /usr/local/apache2/bin/apachectl stop
  [Sun Feb 01 21:49:18.052158 2015] [core:warn] [pid 25387:tid 139982361810816] AH00111: Config variable ${PROJECT} is not defined
  [Sun Feb 01 21:49:18.052270 2015] [core:warn] [pid 25387:tid 139982361810816] AH00111: Config variable ${TLD} is not defined

Note the shutdown is effective and we cannot see the web site now.

Following the instructions in file "apache2-init.d-script" we move the
file to the /etc directory and rename it enroute.  As root execute:

  am1# mv apache2-init.d-script /etc/init.d/apache2
  am1# cd /etc/init.d
  am1# chmod 755 init.d
  am1# update-rc.d apache2 defaults
   Adding system startup for /etc/init.d/apache2 ...
     /etc/rc0.d/K20apache2 -> ../init.d/apache2
     /etc/rc1.d/K20apache2 -> ../init.d/apache2
     /etc/rc6.d/K20apache2 -> ../init.d/apache2
     /etc/rc2.d/S20apache2 -> ../init.d/apache2
     /etc/rc3.d/S20apache2 -> ../init.d/apache2
     /etc/rc4.d/S20apache2 -> ../init.d/apache2
     /etc/rc5.d/S20apache2 -> ../init.d/apache2

Now we check the script's operation by rebooting and see if apache
starts without our help.

  am1# shutdown -r 0
  Broadcast message from ubuntu@ip-172-31-37-69
  	(/dev/pts/0) at 21:59 ...

  The system is going down for reboot NOW!
  Connection to am1 closed by remote host.
  Connection to am1 closed.

  $

After a bit we check our browser again and the web site is
up--success!

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
