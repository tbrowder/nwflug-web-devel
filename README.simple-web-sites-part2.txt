Simple Web Sites
================

Part 2 - Obtaining a Remote Server
----------------------------------

Getting a free, Amazon cloud server
-----------------------------------

(Free for one year.)

You need an amazon.com account to start.

With or without an existing account, start here where you can either
signe up for a new account or sign in:

  https://aws.amazon.com/

Note that for an existing regular account it still takes an AWS
sign-up (it just uses your current ID and password).

Select:

  My Account/Console | AWS Management Console

Select:

  EC2

Note that I am in the US West Region, but the default is US East.  You
should use US East unless you know a good reason not to.

Choose a server to start. Select:

  Launch Instance
 
Click "Free Tier Only"

I selected (at the bottom of the list):

  Ubuntu Server 14.04 LTS (PV) - ami-68c2a858 (32-bit)

Note that the "68c2a858" is a unique identifier and will be different
for your instance.

It uses:

  SSD: up to 30 Gb storage

(Note that not all the following instructions will work if you select
another server.)

Get the instance public IP: 54.191.61.9

Create a key pair, select "Key Pairs".

  I named mine ' amazon1' and placed file 'amazon1.pem' in the
  directory above this working directory.

Change the privileges (permissions) on the file:

  $ chmod 400 ../amazon1.pem

To login, in the working directory enter:

 $ ssh -i ../amazon1.pem ubuntu@54.191.61.9

(See file 'login.sh' for a script to simplify your login.)

Get the instance current:

 am1$ sudo aptitude update
 am1$ sudo aptitude upgrade

You will have to answer some questions during the upgrade--I always
took the defaults.

I had to restart the system due to a kernel upgrade:

 am1$ sudo shutdown -r 0

and it automatically logged me out as expected.

To transfer files from the local host to your server:

 $ scp -C -i ../amazon1.pem <files...> ubuntu@54.191.61.9:

To transfer directories from the local host to your server you need
the '-r' (recursive) option (it is harmless to use it for files only):

 $ scp -r -C -i ../amazon1.pem <dirs..> ubuntu@54.191.61.9:

(See file 'xfer-files-to-server.sh' for a script to simplify your
transfers.)

Prepare to install Apache on the remote server
----------------------------------------------

On the cloud server Use the system aprutil (openssl is already
installed):

  am1$ sudo aptitude install libaprutil1-dev

Other dependencies:

  am1$ sudo aptitude install ntp ntp-doc make
  am1$ sudo aptitude install g++

Summary
=======

You should now have a working remote server ready to install and
configure Apache.

In Part 3 we will install and configure Apache on the remote server.
