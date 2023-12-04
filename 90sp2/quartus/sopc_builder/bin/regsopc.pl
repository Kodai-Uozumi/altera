#!/bin/perl
###########
#
# regsopc.pl - post-install runtime environment
#              registration for SOPC Builder
#


#|#
#|# parse the command-line
#|#
my $quartus = $ENV{QUARTUS_ROOTDIR};
my $sopcdir = "";
my $sopcold = "";
my $verbose = 0;

foreach $arg (@ARGV) 
{
   $quartus      =   $1,  next    if ($arg =~ /^--quartus_root_dir=(.*)/i);
   $sopcold      =   $1,  next    if ($arg =~ /^--sopc_builder_old=(.*)/i);
   $verbose      =    1,  next    if ($arg =~ /^--verbose/i);
}

#|#
#|# Validate quartus and its subdirectories
#|#
$quartus =~ s/\\/\//g;
if ( ! -d "$quartus" || ! -d "$quartus/bin" || ! -d "$quartus/sopc_builder" )
{
   print STDERR "regsopc.pl: Cannot locate Quartus installation; try --quartus_root_dir=<quartus-dir>\n";
   exit -1;
}
$sopcdir = "$quartus/sopc_builder";
$sopcold =~ s/\\/\//g;


#|#
#|# set platform-bin when not on windows
#|# (on windows, platform-bin is just bin)
#|#
my $platbin = "bin";
if ($^O =~ /solaris/i)
{   $platbin = "solaris";  }
elsif ($^O =~ /hpux/i)
{   $platbin = "hp11";     }
elsif ($^O =~ /linux/i)
{   $platbin = "linux";     }

#|#
#|# Create wizard.lst file
#|#
my $wizname = "Altera SOPC Builder";
my $wizlist = "$quartus/libraries/megafunctions/sopc_builder_wizard.lst";
my $aliases = "<INFO><ALIAS SELECTABLE=\"YES\">Altera SOPC Builder 2.6</ALIAS><ALIAS SELECTABLE=\"YES\">Altera SOPC Builder 2.7</ALIAS><ALIAS SELECTABLE=\"YES\">Altera SOPC Builder 2.8</ALIAS><LANGUAGES AHDL=\"OFF\"/></INFO>";

chmod(0666, $wizlist) if ( -e $wizlist );
if (open (WIZFILE, "> $wizlist"))
{
{
print WIZFILE <<EOT
[]
$wizname = "$quartus/$platbin/perl/bin/perl" -x "$sopcdir/bin/sopc_builder" %f "-d$sopcdir" %o %h$aliases
EOT
}
close WIZFILE;
}
elsif ($verbose)
{
print STDERR "regsopc.pl: Cannot open $wizlist for writing; MWPIM launcher not created\n";
}

#|#
#|# create .sopc_builder file
#|#
my $cfgfile = "$sopcdir/.sopc_builder";

chmod(0666, $cfgfile) if ( -e $cfgfile );
if (open (CFGFILE, "> $cfgfile"))
{
 {
   print CFGFILE <<EOT
# .sopc_builder configuration file: 
sopc_builder = \"$sopcdir\";
sopc_legacy_dir = \"$sopcold\";
sopc_cygwin_dir = \"$quartus/bin/cygwin\";
sopc_quartus_dir = \"$quartus\";
sopc_modelsim_dir = \"\";
sopc_ui_debug = \"0\";
EOT
 }
   close CFGFILE;
}
elsif ($verbose)
{
   print STDERR "regsopc.pl: Cannot open $cfgfile for writing; config file not created\n";
}



#|#
#|# Setup Cygwin's mount-points
#|#
if ($^O =~ /win/i)
{
   my $cygroot = "$quartus/bin/cygwin";
   if ( -x "$cygroot/bin/mount.exe" )
   {
      my $dosroot = $cygroot;
      $dosroot =~ s/\//\\/g;
      chdir "$cygroot/bin";
      system( "$cygroot/bin/umount.exe", ("--remove-all-mounts") );
      system( "$cygroot/bin/mount.exe", ("-t", "-s", "${dosroot}", "/") );
      system( "$cygroot/bin/mount.exe", ("-t", "-s", "${dosroot}\\bin", "/usr/bin") );
      system( "$cygroot/bin/mount.exe", ("-t", "-s", "${dosroot}\\lib", "/usr/lib") );
      if ($verbose)
      {
         system( "$cygroot/bin/mount.exe" );
      }
   }
   elsif ($verbose)
   {
      print STDERR "regsopc.pl: Cannot locate Cygwin; mount-points not set";
   }
}
exit 0
