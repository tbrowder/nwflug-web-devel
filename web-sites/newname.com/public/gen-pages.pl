#!/usr/bin/env perl

use v5.14;

use strict;
use warnings;

use lib('../..');
use GENFUNCS;

# PER SITE DATA ============================
my $title = 'My Site';
# site header lines
my @header_lines
  = (
     "    <h1>My Site</h1>",
    );

# Main pages with their own content (footer and credits are
#   "standard").
# Pages MUST have html content in a "<page-name>.content" file.
my @pfils
  = (
     'menu',     # mandatory (keep updated) with page names and aliases)
     'index',    # mandatory
     'meetings',
     'topics',
     'resources',
     'projects',
     );
# END PER SITE DATA ============================

# boiler plate below here ======================
foreach my $arg (@ARGV) {
  $GENFUNCS::debug = 1
    if $arg =~ m{\A -d}x;
}

my $pwd = `pwd`;
chomp $pwd;
say "DEBUG is on, pwd is '$pwd'"
  if (0 && $GENFUNCS::debug);

GENFUNCS::gen_pages({
		     'dir'           => $pwd,
		     'page_aref'     => \@pfils,
		     'title'         => $title,
		     'header_aref'   => \@header_lines,
		    });

