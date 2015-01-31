package GENFUNCS;

use v5.14;

use Data::Dumper;
use File::Basename;

# main vars
our $debug = 0;

# local vars
my @default_resource_lines
  = (
     "<link rel='stylesheet' href='./Resources/css/my.css' />",
     "<link rel='stylesheet' href='./Resources/css/other.css' />",
    );

my @footer_lines
  = (
     "<!-- content -->",
     "",
     "    <p><strong>Credits</strong> This site relies heavily on the",
     "    work of many Free and Open Source (FOSS) projects and their",
     "    developers and contributors.  See a list",
     "      <a href='./credits.html'>here</a>.",
     "    </p>",
    );

my @credits_lines
  = (
     "<!-- content -->",
     "",
     "    <h3>Credits</h3>",
     "    <br />",
     "    <p>This site relies heavily on the",
     "       work of many Free and Open Source Software (FOSS) projects and their",
     "       developers and contributors, some of which are:",
     "    </p>",
     "",
     "    <ul>",
     "      <li><a href='https://www.kernel.org/'>Linux kernel</a></li>",
     "      <li><a href='http://www.gnu.org/'>GNU Software</a></li>",
     "      <li><a href='http://www.perl.org/'>Perl Programming Language</a></li>",
     "      <li><a href='http://httpd.apache.org/'>Apache Web Server</a></li>",
     "      <li><a href='http://www.dynamicdrive.com/'>Dynamic Drive</a></li>",
     "    </ul>",
    );

#### subroutines ####
sub get_datetime {
  my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst)
    = localtime(time);
  my @mons = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
  my @days = qw(Sunday Monday Tuesday Wednesday Thursday Fiday Saturday);
  my $Mon  = $mons[$mon];
  my $Wday = $days[$wday];
  $year += 1990;

  my $dt = sprintf "$Wday, $mday $Mon $year (%02d:%02d)", $hour, $min;

  return $dt;
} # get_datetime

sub prep_mainlines {
  my $aref = shift @_; # \@mainlines
  my $href = shift @_; # \%lines
  my $iref = shift @_; # \%idx

  # the page template
  my @tlines = <GENFUNCS::DATA>; #'./main-page.html.template';

  my $regex = qr/\A \s* <!-- \s* content \s+ ([\S]+) \s* --> \s* \z/x;

  my $idx = -1;
  foreach my $line (@tlines) {
    $aref->[++$idx] = $line;

    if ($line =~ m{$regex}) {
      my $key = $1;

      if ($debug) {
	my $s = $line;
	chomp $s;
	say "DEBUG: found comment key line '$s' with key '$key'";
      }

      if ($key =~ /menu/) {
	# insert the menu and update the index
	foreach my $mline (@{$href->{menu}}) {
	  $aref->[++$idx] = $mline;
	}
      }


      elsif ($key =~ /title/) {
	# extract the index
	$iref->{title} = $idx;
	# also clear the line
	$aref->[$idx] = '';
      }
      elsif ($key =~ /header/) {
	# extract the index
	$iref->{header} = $idx;
      }
      elsif ($key =~ /resource/) {
	# extract the index
	$iref->{resource} = $idx;
      }
      elsif ($key =~ /time/) {
	# extract the index
	$iref->{time} = $idx;
      }
      elsif ($key =~ /page/) {
	# extract the index
	$iref->{content} = $idx;
      }
      elsif ($key =~ /footer/) {
	# extract the index
	$iref->{footer} = $idx;
      }
      elsif ($key =~ /script/) {
	# extract the index
	$iref->{script} = $idx;
      }
      elsif ($key =~ /animation/) {
	# extract the index
	$iref->{animation} = $idx;
      }
    }
  }

} # prep_mainlines

sub get_file_contents {
  my $f    = shift @_;
  my $aref = shift @_;
  my $href = shift @_;
  $href = 0 if !defined $href; # \%input

  open my $fp, '<', $f
    or die "$f: $!";
  my @lines = <$fp>;

  if ($href) {
    my $regex_script = qr/\A \s* <!-- \s* script: \s+ ([\S]+) \s* --> \s* \z/xo;
    my $regex_anim   = qr/\A \s* <!-- \s* animation: \s+ ([\S]+) \s* --> \s* \z/xo;
    my $bf = basename $f;
    $bf =~ s{\.content \z}{}x;

  LINE:
    foreach my $line (@lines) {
      # if we find a script reference, save it
      if ($line =~ m{$regex_script}) {
	my $fil = $1;
	# strip any quotes
	$fil =~ s{[\"\']?}{}gx;
	$href->{$bf}{script} = $fil;
      }
      elsif ($line =~ m{$regex_anim}) {
	my $fil = $1;
	# strip any quotes
	$fil =~ s{[\"\']?}{}gx;
	$href->{$bf}{animation} = $fil;
      }
    }
  }

  push @{$aref}, @lines;
} # get_file_contents

sub check_files {
  my $pwd   = shift @_;
  my $paref = shift @_; # \@pfils

  my $err = 0;
  foreach my $f (@{$paref}) {
    my $ff = "$pwd/$f";
    $ff .= '.content' if ($f !~ /main-page/);
    if (! -f $ff) {
      say "ERROR:  Input file '$f.content' not found.";
      ++$err;
    }
  }
  return $err;
} # check_files

sub gen_pages {
  my $argref = shift @_;

  # this function does it all
  my $pwd   = $argref->{dir};
  my $paref = $argref->{page_aref};     # \@pfils

  my $title = $argref->{title};         # $title
  my $haref = $argref->{header_aref};   # \@header
  my $raref = $argref->{resource_aref}; # \@resources (css, etc.)

  # check all files are present
  my $err = check_files($pwd, $paref);
  die "ERROR exit.\n"
    if $err;

  my %lines = ();
  my %input = ();
  foreach my $f (@{$paref}) {
    my $ff .= "$pwd/$f.content";
    my @arr = ();
    get_file_contents($ff, \@arr, \%input);
    $lines{$f} = [@arr];
  }

=pod

  if (0) {
    say "DEBUG: dumping \%input:";
    print Dumper(\%script);
    die "DEBUG exit";
  }

=cut

  # add footer lines
  $lines{'footer'} = [@footer_lines];
  # add credits lines
  $lines{'credits'} = [@credits_lines];
  # add header lines
  $lines{'header'} = [@{$haref}];

  # add resource lines, if any
  if (defined $raref) {
    $lines{'resource'} = [@{$raref}];
  }
  else {
    $lines{'resource'} = [];
  }

  if (0 && $GENFUNCS::debug) {
    print Dumper(\%lines);
  }

  # get main template indices and insert menu into main template lines
  # (main template is in __DATA__ section of GENFUNCS module)
  my @mainlines = ();
  my %idx
    = (
       title    => -1,
       header   => -1,
       resource => -1,
       time     => -1,
       content  => -1,
       footer   => -1,
       script   => -1,
      );

  prep_mainlines(\@mainlines, \%lines, \%idx);
  my $nm = @mainlines;

  # now write the pages
  foreach my $f (@{$paref}, 'credits') {
    next if $f eq 'menu'; # menu contents are inserted (not an independent page)

    my $ff = "$pwd/$f.html";
    if ($GENFUNCS::debug) {
      say "DEBUG:  Writing file '$f'...";
    }

    open my $fp, '>', $ff
      or die "$f: $!";

    for (my $i = 0; $i < $nm; ++$i) {
      print $fp $mainlines[$i];
      if ($i == $idx{content}) {
	foreach my $line (@{$lines{$f}}) {
	  chomp $line;
	  say $fp $line;
	}
      }
      elsif ($i == $idx{footer} && $f ne 'credits') {
	foreach my $line (@{$lines{footer}}) {
	  chomp $line;
	  say $fp $line;
	}
      }
      elsif ($i == $idx{header}) {
	foreach my $line (@{$lines{header}}) {
	  chomp $line;
	  say $fp $line;
	}
      }
      elsif ($i == $idx{script} && exists $input{$f} && exists $input{$f}{script}) {
	my $sfil = $input{$f}{script};
	# that's a file basename name which is expected to be in the 'resources2' dir
	$sfil = "./resources2/${sfil}";
	if (! -f $sfil) {
	  warn "WARNING:  Required script file '$sfil' not found.";
	  next;
	}
	my @slines = ();
	get_file_contents($sfil, \@slines);
	foreach my $line (@slines) {
	  chomp $line;
	  say $fp $line;
	}
      }
      elsif ($i == $idx{animation} && exists $input{$f} && exists $input{$f}{animation}) {
	my $sfil = $input{$f}{animation};
	# that's a file basename name which is expected to be in the 'resources2' dir
	$sfil = "./resources2/${sfil}";
	if (! -f $sfil) {
	  warn "WARNING:  Required animation file '$sfil' not found.";
	  next;
	}
	my @slines = ();
	get_file_contents($sfil, \@slines);
	foreach my $line (@slines) {
	  chomp $line;
	  say $fp $line;
	}
      }
      elsif ($i == $idx{resource}) {
	my @r = @{$lines{resource}};
	@r = @default_resource_lines
	  if (!@r);

	foreach my $line (@r) {
	  chomp $line;
	  say $fp $line;
	}
      }
      elsif ($i == $idx{title}) {
	say $fp "<title>$title</title>";
      }
      elsif ($i == $idx{time} && $f eq 'index') {
	# insert last modified time
	my $date = GENFUNCS::get_datetime();
	say $fp "<br /> <h5 class=\"center\">Last update: $date</h5>";
      }
    }
  }

  say "Normal end.";

} # gen_pages

# mandatory true return for a Perl module
1;

__DATA__
<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">

<!--[if IE]>
  <meta http-equiv="x-ua-compatible" content="ie=edge" />
<![endif]-->

<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1" />
<meta name="description" content="NW Florida Linux User Group home site" />
<meta name="keywords" content="Linux" />

<!-- content insert-title -->

<!--[if lt IE 9]>
  <script src="Resources/js/html5.js"></script>
<![endif]-->

<!-- from http://www.dynamicdrive.com/style/blog/entry/css-equal-columns-height-script/ -->
<script src="Resources/js/equalcolumns.js" type="text/javascript"></script>

<!-- our css -->
<!-- content insert-resources -->

</head>
<body><div id="wrapper">

  <div id="header">
  <div class="innertube">

    <!-- content insert-headers -->

    <!-- content insert-time -->

    <!-- content insert-animation -->

  </div>
  </div>

  <div id="contentwrapper">
  <div id="contentcolumn">
  <div class="innertube">

    <!-- content insert-page-content -->

  </div>
  </div>
  </div>

  <div id="leftcolumn">
  <div class="innertube">

    <!-- content insert-menu-content-->

  </div>
  </div>

  <div id="footer">
    <!-- content insert-footer-content -->
  </div>

</div><!-- wrapper -->
<script src="Resources/js/jquery.js"></script>

<!-- the following is a per-page insertion -->
<!-- content insert-script-content -->

</body>
</html>
