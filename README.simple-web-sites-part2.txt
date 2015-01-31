Simple Web Sites
================

Part 2 - Obtaining a Remote Server
----------------------------------

First, make sure we have a public/private key pair for ssh use on our
local host.

If you have a pair it should be in directory "$HOME/.ssh":

  $ ls -l $HOME/.ssh/*
  -rw------- 1 tbrowde tbrowde  791 Aug 27 15:35 /home/tbrowde/.ssh/authorized_keys
  -rw------- 1 tbrowde tbrowde  135 Dec  2 09:30 /home/tbrowde/.ssh/config
  -rw------- 1 tbrowde tbrowde 1679 Aug 27 15:35 /home/tbrowde/.ssh/id_rsa
  -rw------- 1 tbrowde tbrowde  396 Aug 27 15:35 /home/tbrowde/.ssh/id_rsa.pub
  -rw------- 1 tbrowde tbrowde 9388 Jan 31 07:56 /home/tbrowde/.ssh/known_hosts

Files "id_rsa" and "id_rsa.pub" are my private and matching public
keys, respectively.  The "authorized_keys" file will not be used for
our situation.  The "known_hosts" file is used by the system for
storing remote host information. The "config" file will be mentioned
later.

If you do not have the files or the ".ssh' directory, procede as
follows (here I take the defaults):

  $ cd
  $ mkdir .ssh
  $ ssh-keygen -t rsa
  Enter file in which to save the key (/home/tbrowde/.ssh/id_rsa):
  Enter passphrase (empty for no passphrase):
  Enter same passphrase again:
  Your identification has been saved in /home/tbrowde/.ssh/id_rsa.
  Your public key has been saved in /home/tbrowde/.ssh/id_rsa.pub.
  The key fingerprint is:
  98:b8:8a:63:0d:30:32:7d:73:41:39:a0:45:69:93:64 tbrowde@juvat2
  The key's randomart image is:
  +--[ RSA 2048]----+
  |   oE=..         |
  |   += +          |
  | ... . o         |
  |= . o..o         |
  |oo ..oo S        |
  | .   .           |
  |  o .            |
  |.o o             |
  |o..              |
  +-----------------+
  $

Change the privileges (permissions) on the directory:

  $ chmod 600 .ssh

Change the privileges (permissions) on the directory's files:

  $ chmod 400 .ssh/*

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

On the left hand menu select

  NETWORK & SECURITY | Key Pairs | Import Key Pair

You will need a unique name for the pair (I use my local host name).  You
can either browse for the public key or insert its contents (it's in
ASCII).

WARNING:  Be sure and use the PUBLIC key, NOT the private key.

Choose a server to start. Select:

  Launch Instance
 
Click "Free Tier Only"

I selected the first Ubuntu instance:

 Ubuntu Server 14.04 LTS (HVM), SSD Volume Type - ami-9a562df2

Note that the "9a562df2" is a unique identifier and may be different
for your instance.

Amazon recommends using HVM types for new instances.

(Note that not all the following instructions will work if you select
another server.)

Get the instance public IP: 54.84.43.106 (your instance will be different).

For ease of access add en entry to your "/etc/hosts" file.  As root,
edit the file and add these lines (am1 is the local name I've chosen
for the remote instance):

  # Amazon EC2:
  54.84.43.106 am1

To login you normally need to preface the host name with your user
name on the remote host ("ubuntu" for Ubuntu images).  To ease login
we edit (or create) the "config" file so it looks like this:

  $ cat $HOME/.ssh/config
  # see man ssh_config for help

  Host *
  ForwardX11 yes
  ServerAliveInterval 45

  Host am1
  User ubuntu

Then, to login, in the working directory enter:

  $ ssh am1
  The authenticity of host 'am1 (54.84.43.106)' can't be established.
  ECDSA key fingerprint is fc:68:8f:fc:92:bf:db:ef:3c:dd:2e:dd:4f:35:4c:4a.
  Are you sure you want to continue connecting (yes/no)? yes
  Warning: Permanently added 'am1' (ECDSA) to the list of known hosts.
  Welcome to Ubuntu 14.04.1 LTS (GNU/Linux 3.13.0-45-generic x86_64)

   * Documentation:  https://help.ubuntu.com/

    System information as of Sat Jan 31 13:59:44 UTC 2015

    System load: 0.0               Memory usage: 5%   Processes:       82
    Usage of /:  12.7% of 7.74GB   Swap usage:   0%   Users logged in: 0

    Graph this data and manage this system at:
      https://landscape.canonical.com/

    Get cloud support with Ubuntu Advantage Cloud Guest:
      http://www.ubuntu.com/business/services/cloud


  Last login: Sat Jan 31 13:56:56 2015 from fl-67-235-143-222.dhcp.embarqhsd.net

Get the instance current:

 am1$ sudo aptitude update
 am1$ sudo aptitude upgrade

You will have to answer some questions during the upgrade--I always
took the defaults.

I had to restart the system due to a kernel upgrade:

 am1$ sudo shutdown -r 0

and it automatically logged me out as expected.

To transfer files from the local host to your remote server (the '-C'
means compress; note the ':' after the remote server's name):

 $ scp -C <files...> am1:

To transfer directories from the local host to your remote server you
need the '-r' (recursive) option (it is harmless to use it for files
only):

 $ scp -r -C <dirs..> am1:

To transfer directories or files from the remote server to your local
host (note the quotes are needed around multiple files and directories
which must be separated by spaces; note also the dot at the end):

 $ scp -r -C am1:"<dirs.. files...>" .

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
