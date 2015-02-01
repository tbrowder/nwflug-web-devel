Simple Web Sites
================

Requirements:

  + a Linux installation connected to the internet (discussed in Part
    0)

  + an Amazon AWS account (discussed in Part 2)

Part 1 - Creating the Site Locally
----------------------------------

Choose a location to contain a parent directory for one or more
web-sites.  Then execute the following to get the code:

  $ git clone https://github.com/tbrowder/nwflug-web-devel.git

which will create the following directory:

  nwflug-web-devel

The directory may be renamed as desired, but we will stay with that
name.  Move into that directory:

  $ cd nwflug-web-devel

In subdirectory 'web-sites' we see a sample site in a sub-directory
named 'mysite.org'.  It is a copy of the an earlier state of the
NWFLUG site and is being used as a template for other sites.

You modify content by adding or modifying the "*.content" files and
then auto-generate the html files by executing:

  $ ./gen-pages.pl

To create a new web-site:

  $ cd web-sites
  $ cp -r mysite.org <new site>
  $ cd <new site>

and modify 'gen-pages.pl' with the correct data for the new site.

To see the sample web site locally, execute:

  $ ./run-iceweasel.sh

Summary
=======

You should now have a working local web site.

Up next
=======

In Part 2 we will obtain and set up a remote server.

In the meantime, if you wish you might buy a domain name.  I
recommend:

  https://www.godaddy.com

If you get a domain name, you should plan on using SSL/TLS for secure
web serving (https).  You can get a free, single-server certificate
from:

  http://www.startssl.com/

For multiple virtual hosting, you can get a two-year certificate for
$59 (unlimited certificate generation for a 350-day period after
identity validation).

