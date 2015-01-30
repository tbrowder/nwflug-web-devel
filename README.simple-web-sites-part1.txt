Simple Web Sites
================

Requirements:

  + a Linux installation connected to the internet (discussed in Part
    0)

  + an Amazon AWS account (discussed in Part 2)

Part 1 - Creating the Site Locally
----------------------------------

Choose an empty directory to contain one or more web-sites:

  $ mkdir domains

Recursively copy the files and directories from the NWFLUG Dropbox
folder 'nwflug-web-devel' into the directory created above.
 
In subdirectory 'web-sites' we see a sample site in a sub-directory
named 'mysite.org'.  It is a copy of the current NWFLUG site and is
being used as a template for other sites.

You modify content by adding or modifying the "*.content" files and
then auto-generate the html files by executing:

  $ ./gen-pages.pl

To create a new web-site:

  $ cd domains/web-sites
  $ cp -r mysite.org <new site>
  $ cd <new site>

and modify 'gen-pages.pl' with the correct data for the new site.

To see the sample web site locally, execute:

  $ ./run-iceweasel.sh

Summary
=======

You should now have a working local web site.

In Part 2 we will obtain and set up a remote server.

In the meantime, if you wish you might buy a domain name.  I recommend:

  https://www.godaddy.com

If you get a domain name, you should plan on using SSL/TLS for secure
web serving (https).  You can get a free, single-server certificate
from:

  http://www.startssl.com/

For multiple virtual hosting, you can get a two-year certificate for
$59 (unlimited certificate generation for a 350-day period after
identity validation).


