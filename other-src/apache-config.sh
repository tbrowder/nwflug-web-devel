#!/bin/bash

# make sure this points to the right source dir:
VER=2.4.12
LDIR=..
SRCDIR=${LDIR}/httpd-$VER

# see Ivan Ristics "Bulletproof SSL and TLS," p. 382
# using static openssl with Apache

SSLDIR=/opt/openssl

USAGE="Usage: $0 go"

if [[ ! -d $SRCDIR ]] ; then
  echo "ERROR:  No dir '$SRCDIR' found."
  exit
fi

if [[ -z $1 ]] ; then
  echo $USAGE
  echo "  Uses SRCDIR '$SRCDIR'."
  echo "  Uses SSL/TLS without FIPS."
  exit
fi

## APACHE HAS TO BE BUILT IN THE SOURCE DIR AT THE MOMENT
## make sure we're not in src dir
#CWD=`pwd`
#if [ "$SRCDIR" = "$CWD" ] ; then
#  echo "ERROR:  Current dir is src dir '$SRCDIR'."
#  echo "        You must use a build dir outside this directory."
#  exit
#fi

# See http://httpd.apache.org/ for detailed installation instructions.
#
# dependencies and requirements:
#
#   Deb packages: ntp  ntp-doc ntpdate
#
#   Source libraries:
#
#     From: http://www.openssl.org/
#       OpenSSL                     openssl-1.0.1i.tar.gz
#
#       use configure script...
#
#     From: http://www.pcre.org/
#       PCRE                        pcre-8.35.tar.gz
#       Note: as root run ldconfig after installation.
#
#       ./configure
#        make
#        make check
#        sudo make install
#        sudo ldconfig
#        make clean
#
#     From: https://apr.apache.org/
#       APR       (see below)       apr-1.5.1.tar.bz2
#       APR-Utils (see below)       apr-util-1.5.4.tar.bz2

# we want to use latest APR and APR-Util
#   see "https://apr.apache.org/"
# download and unpack them to ./srclib/
# link the unpacked, versioned dirs, e.g.,
#
#   $ ln -s apr-1.5.1 apr
#   $ ln -s apr-util-1.5.4 apr-util
#
if [[ ! -f "$SRCDIR/srclib/apr/apr.pc.in" || ! -f "$SRCDIR/srclib/apr-util/apr-util.pc.in" ]] ; then
  echo "ERROR:  Need '$SRCDIR/srclib/apr' and"
  echo "             '$SRCDIR/srclib/apr-util'."
  echo "        Download latest from Apache2 site 'https://apr.apache.org/'."
  exit
fi

# the Apache layout:
# <Layout Apache>
#     prefix:        /usr/local/apache2
#     exec_prefix:   ${prefix}
#     bindir:        ${exec_prefix}/bin
#     sbindir:       ${exec_prefix}/bin
#     libdir:        ${exec_prefix}/lib
#     libexecdir:    ${exec_prefix}/modules
#     mandir:        ${prefix}/man
#     sysconfdir:    ${prefix}/conf
#     datadir:       ${prefix}
#     installbuilddir: ${datadir}/build
#     errordir:      ${datadir}/error
#     iconsdir:      ${datadir}/icons
#     htdocsdir:     ${datadir}/htdocs
#     manualdir:     ${datadir}/manual
#     cgidir:        ${datadir}/cgi-bin
#     includedir:    ${prefix}/include
#     localstatedir: ${prefix}
#     runtimedir:    ${localstatedir}/logs
#     logfiledir:    ${localstatedir}/logs
#     proxycachedir: ${localstatedir}/proxy
# </Layout>

# lua >= 5.1      # will not use
# distcache?      # will not use
# ldap?           # will not use
# --with-crypto?  # yes!
# privileges?     # Solaris only

# note: build mod_wsgi after installing apache

export LDFLAGS="-L/opt/openssl/lib"

# we build all modules for now (all shared except mod_ssl)
export LDFLAGS="-L${SSLDIR}"
$SRCDIR/configure                          \
    --prefix=/usr/local/apache2            \
    --with-included-apr                    \
\
    --enable-ssl                           \
    --enable-ssl-staticlib-deps            \
    --enable-mods-static=ssl               \
    --with-ssl=${SSLDIR}                   \
\
    --enable-mods-shared=reallyall         \
    --with-perl                            \
    --with-python                          \
    --enable-layout=Apache                 \
    --with-pcre=/usr/local/bin/pcre-config \
    --without-ldap                         \
    --enable-session-crypto                \
    --with-crypto                          \

# make
# sudo make install




