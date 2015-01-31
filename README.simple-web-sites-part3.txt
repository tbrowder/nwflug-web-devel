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

  $ scp -C -r src am1:

Note file 'openssl-1.0.1i.tar.gz.sha1':

  $ cat openssl-1.0.1i.tar.gz.sha1
  74eed314fa2c93006df8d26cd9fc630a101abd76

We can check the tar archive to see that it yields the same sha1
digest:

  $ sha1sum openssl-1.0.1i.tar.gz
  74eed314fa2c93006df8d26cd9fc630a101abd76  openssl-1.0.1i.tar.gz

I have checked all the archives after downloading them, so we will not
check the others.

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

  $ login.sh go

(There may be a delay if the reboot has not completed due to an fsck check.)
  
Following the guidance in 'apache-config.sh' we unpack, configure,
build (make), and install the following programs:

  openssl (note latest version is 1.0.1j, 15 Oct)
  pcre
  httpd

OpenSSL:
-------

  am1$ tar -tvzf openssl-1.0.1i.tar.gz

The first command was to ensure the archive unpacked into its own
directory--otherwise we would would have a mess of unwanted files in
this directory.  Note that Windows developers are notorious for doing
that.

  am1$ tar -xvzf openssl-1.0.1i.tar.gz
  am1$ cd openssl-1.0.1i
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

  am1$ tar -tvjf pcre-8.35.tar.bz2
  am1$ tar -xvjf pcre-8.35.tar.bz2
  am1$ cd pcre-8.35
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

  am1$ tar -tvjf httpd-2.4.10.tar.bz2
  am1$ tar -xvjf httpd-2.4.10.tar.bz2
  am1$ tar -tvjf apr-1.5.1.tar.bz2
  am1$ tar -xvjf apr-1.5.1.tar.bz2
  am1$ tar -tvjf apr-util-1.5.4.tar.bz2
  am1$ tar -xvjf apr-util-1.5.4.tar.bz2
  am1$ cd httpd-2.4.10
  am1$ mv ../apr-1.5.1 srclib
  am1$ mv ../apr-util-1.5.4 srclib
  am1$ cd srclib
  am1$ ln -s apr-1.5.1 apr
  am1$ ln -s apr-util-1.5.4 apr-util
  am1$ cd ..
  am1$ ../apache-config.sh
  am1$ make
  am1$ sudo make install
  am1$ cd
  am1$ sudo cp httpd.conf /usr/local/apache2/conf

Test it:

  am1$ sudo /usr/local/apache2/bin/apachectl start
  am1$ sudo /usr/local/apache2/bin/apachectl start
  httpd (pid 10141) already running

NOTE: Make sure you have opened inbound HTTP traffic in your EC2
console.  (CAUTION: Don't delete inbound SSH!)

Point your local browser at your IP (from Part 2): 

  54.191.61.9

and you should see "It works!"

Finally, shut down the site:

  am1$ sudo /usr/local/apache2/bin/apachectl stop

In Part 4 we'll add a script to automatically start the server at
boot, and we'll work on user and group permissions, directories, and
scripts ease submitting our sites to the server (publishing).
