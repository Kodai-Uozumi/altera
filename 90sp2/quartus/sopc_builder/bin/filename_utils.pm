#Copyright (C)2001-2003 Altera Corporation
#Any megafunction design, and related net list (encrypted or decrypted),
#support information, device programming or simulation file, and any other
#associated documentation or information provided by Altera or a partner
#under Altera's Megafunction Partnership Program may be used only to
#program PLD devices (but not masked PLD devices) from Altera.  Any other
#use of such megafunction design, net list, support information, device
#programming or simulation file, or any other related documentation or
#information is prohibited for any other purpose, including, but not
#limited to modification, reverse engineering, de-compiling, or use with
#any other silicon devices, unless such use is explicitly licensed under
#a separate agreement with Altera or a megafunction partner.  Title to
#the intellectual property, including patents, copyrights, trademarks,
#trade secrets, or maskworks, embodied in any such megafunction design,
#net list, support information, device programming or simulation file, or
#any other related documentation or information provided by Altera or a
#megafunction partner, remains with Altera, the megafunction partner, or
#their respective licensors.  No other licenses, including any licenses
#needed under any third party's intellectual property, are provided herein.
#Copying or modifying any file, or portion thereof, to which this notice
#is attached violates this copyright.







################################################################
# A (small) set of handy routines for manipulating 
# filenames.
#

package filename_utils;
require Exporter;
@ISA = Exporter;
@EXPORT = qw(Is_Absolute_Path
             Get_Base_Fname
             Coerce_Absolute_Path
             Create_Dir_If_Needed
             CopyDir
             Perlcopy
             );


################################################################
# Is_Absolute_Path
#
# Return 1 (true) if it is, and 0 (false) if it ain't.
#
################################################################
sub Is_Absolute_Path
{
  my ($filename) = (@_);
  $filename =~ s|\\|\/|sg;
  $filename =~ s|^\s+||sg;
  $filename =~ s|\s+$||sg;

  return 1 if $filename =~ /^\//;         # Starts with a slash.
  return 1 if $filename =~ /^[^\/]+\:/;   # Some sort of drive-specifier.

  return 0;
}

################################################################
# Get_Base_Fname
#
# Given a filename which might contain a path, strip-off
# the directory-part, leaving only the "base" filename part.
#
################################################################
sub Get_Base_Fname
{
  my ($filename) = (@_);

  $filename =~ /.*?([^\\\/]+)$/;
  my $base = $1;
  return $base;
}

################################################################
# Strip_Extension
#
# Given a filename, strip-off the "extension" (everything after
# the last dot, if any)
#
################################################################
sub Strip_Extension
{
  my ($filename) = (@_);
  return $filename unless $filename =~ /(.*)\..*?/;
  return $1;
}

################################################################
# Coerce_Absolute_Path
# 
# You pass a filename.   This function returns that same file name
# as an absolute path-name.  If your filename has an absolute path
# already, it just comes right back, boomerang-like.
#
# If your filename is relative (e.g. "foo.dat" or "projo/foo.dat")
# then we will treat it as if this path were relative to the 
# "home directory" given by the second argument.
#
# This is done by a magical process known as "concatenation."
#
################################################################
sub Coerce_Absolute_Path
{
  my ($filename, $relative_to_this_dir) = (@_);
  return $filename if &Is_Absolute_Path ($filename);

  # Be graceful: Accept directory-name either with or without 
  # trailing slash:
  $relative_to_this_dir =~ s/\/$//;
  return $relative_to_this_dir . "/" . $filename;
}

################################################################
# Create_Dir_If_Needed
#
# The name pretty much says it all, don't it?
#
################################################################
sub Create_Dir_If_Needed
{
    my $DIR_NAME;
    ($DIR_NAME) = (@_);
    
    # Null directory?  Nothing to do.
    return if $DIR_NAME eq '';

    if (-f $DIR_NAME)
    {
        print STDERR "Cannot create directory '$DIR_NAME': exists as file.\n";
    }

    if (!-e $DIR_NAME) 
    {
        # Make mine rwxrwxrwx.
        mkdir ($DIR_NAME,  0777) or die 
            "Error creating dir $DIR_NAME: $!";
    }
}

################################################################
# Perlcopy
#
# "cp" is different on every platform.  Worse, sometimes you 
# get read-only files as a result, which is never what we want
# (in this particular application).  
#
# One way to copy files is via a Perl-routine.  This 
# routine opens the source-file, reads it into a list of lines,
# closes it, opens the destination file, writes the list of lines,
# then closes it.
#
# As an added bonus, you may pass-in an optional regexp which gets 
# applied to every line on its way through.  Most people will
# never use this, but it sometimes comes in handy.
#
# Crude, but effective.
#
# 6/18/2001: Using both filehandles in binary mode.  This 
#            is a better way to manage e.g. encrypted files.
#
################################################################
sub Perlcopy
{
    my ($src, $dest, $regexp) = (@_);

    $src =~ /.*?([^\\\/]+)$/;
    my $src_root = $1;

    # If the destination is given as a directory, add-on the
    # root filename.
    $dest .= $src_root if $dest =~ /[\\\/]$/;

    my @lines;

    open (SRC, "< $src") or die 
        "Perlcopy: cannot open source file $src: $!";
    binmode SRC;
    while (<SRC>) { push (@lines, $_) } 
    close (SRC);

    open (DST, "> $dest") or die
        "Perlcopy: cannot open destination file $dest: $!";
    binmode DST;
    foreach $line (@lines) {
      if ($regexp) {
        eval ("\$line =~ $regexp");
        die "Perlcopy error ($@) evaluating expression: $regexp" if $@;
      }
      print DST $line;
    }
    close (DST);
}

################################################################
# CopyDir
#
# Copies all files in the $src directory to the $dest directory.
#
################################################################
sub CopyDir
{
    my $src;
    my $dest;
    ($src, $dest, $recursive) = (@_);

    $src  =~ s/\/$//;
    $dest =~ /.*[\\\/]$/ or die 
        "ERROR: CopyDir destination ($dest) must be a directory.";

    opendir (DIR, $src) or die 
        "ERROR: CopyDir can't open directory $src: $!";
    my @all_files = readdir(DIR);
    closedir (DIR);

    my @just_directories;
    my @just_files;
    foreach my $file (@all_files)
    {
       next if $file =~ /^\.+$/;
       if (-d "$src/$file")
       {
          push (@just_directories, $file);
       }
       else
       {
          push (@just_files, $file);
       }
    }

    foreach my $just_file (@just_files)
    {
       &Perlcopy ("$src/$just_file", $dest);
    }

    if ($recursive)
    {
       foreach my $directory (@just_directories)
       {
          my $new_dest_directory = "$dest$directory/";
          if (!(-e $new_dest_directory))
          {
             mkdir ($new_dest_directory, 0x777);
          }
          &CopyDir("$src/$directory",
                   $new_dest_directory,
                   $recursive);
       }
    }
}

1;
