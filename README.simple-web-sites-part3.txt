Simple Web Sites
================

Part 3 - Setting Up the Apache Server
-------------------------------------

We are going to install the latest Apache from source.  In order to
create a version that can be used if you ever incorporate SSL/TLS, we
shall also install openssl beforehand and use during the Apache build.

We will also need to install some other prerequisites as seen
below--see the 'apache-config.sh' file for particulars.

Necessary source files are not in the working directory and they
should be obtained from the Dropbox first:

  $ ./get-external-src-files.sh

Transfer necessary files to the server:

  $ scp -C src/* other-src/* am1:

In another terminal window ssh to the remote host:

  $ ssh am1
  am1$

We may need to update the server.  As root:

  $ sudo su
  # aptitude update
  # aptitude upgrade

You may see this message:

    *** /dev/xvda1 should be checked for errors ***

In that case do this:

  # touch /forcefsck

which will schedule an fsck run on the next boot (which you may want to
force).

If a reboot is needed:

  # shutdown -r 0

And log back in:

  $ ssh am1

(There may be a delay if the reboot has not completed due to an fsck check.)
  
Following the guidance in 'apache-config.sh' we unpack, configure,
build (make), and install the following programs:

  openssl
  pcre
  httpd

OpenSSL:
-------

  am1$ tar -tvzf openssl-1.0.2.tar.gz

The first command was to ensure the archive unpacked into its own
directory--otherwise we would would have a mess of unwanted files in
this directory.  Note that Windows developers are notorious for doing
that.

  am1$ tar -xvzf openssl-1.0.2.tar.gz
  am1$ cd openssl-1.0.2
  am1$ ../openssl-config.sh
  Usage: ../openssl-config.sh go
  Configures openssl source (without FIPS).
  am1$ ../openssl-config.sh go
  ...
  Since you've disabled or enabled at least one algorithm, you need to do
  the following before building:

	  make depend

  am1$ make depend
  ...
  am1$ make
  ...
  am1$ make test
  ...
  am1$ sudo make install
  ...
  am1$ cd

pcre:
----

  am1$ tar -tvjf pcre2-10.00.tar.bz2
  am1$ tar -xvjf pcre2-10.00.tar.bz2
  am1$ cd pcre2-10.00
  am1$ ./configure
  ...
  am1$ make
  ...
  am1$ make check
  ...
  am1$ sudo make install
  ...
  am1$ sudo ldconfig
  am1$ cd

httpd:
-----

  am1$ tar -tvjf httpd-2.4.12.tar.bz2
  am1$ tar -xvjf httpd-2.4.12.tar.bz2
  am1$ tar -tvjf apr-1.5.1.tar.bz2
  am1$ tar -xvjf apr-1.5.1.tar.bz2
  am1$ tar -tvjf apr-util-1.5.4.tar.bz2
  am1$ tar -xvjf apr-util-1.5.4.tar.bz2
  am1$ cd httpd-2.4.12
  am1$ mv ../apr-1.5.1 srclib
  am1$ mv ../apr-util-1.5.4 srclib
  am1$ cd srclib
  am1$ ln -s apr-1.5.1 apr
  am1$ ln -s apr-util-1.5.4 apr-util
  am1$ cd ..
  am1$ ../apache-config.sh go
  am1$ make
  am1$ sudo make install
  am1$ sudo ldconfig
  am1$ cd
  am1$ sudo cp httpd.conf /usr/local/apache2/conf

Test it:

  am1$ sudo /usr/local/apache2/bin/apachectl start
  am1$ sudo /usr/local/apache2/bin/apachectl start
  httpd (pid 10141) already running

NOTE: Make sure you have opened inbound HTTP traffic in your EC2
console 9NETWORK 7 SECURITY | Security Groups).  (CAUTION: Don't
delete inbound SSH!)

Point your local browser at your IP (from Part 2): 

  54.84.43.106

and you should see "It works!"

Finally, shut down the site:

  am1$ sudo /usr/local/apache2/bin/apachectl stop

In Part 4 we'll add a script to automatically start the server at
boot, and we'll work on user and group permissions, directories, and
scripts ease submitting our sites to the server (publishing).
