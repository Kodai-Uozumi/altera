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







################
# wiz_utils.pm
#
# A set of utility routines and global variables 
# which are useful for automating the wiard "back-end" 
# build proecss.  These include:
#
#  * Path names for all the Nios HDK source directories.
#
#  * A handy subroutine for parsing named function arguments.
#
#  * A handy subroutine for stripping Perl comments.
#
#  * Routines for copying files and directories platform-independently.
#

# We would like to auto-flush our buffers in the new, fancy 
# way (using ->autoflush()), but for now we'll do it in the 
# old, cryptic way (using $|), because we can't seem to find
# our library modules.
#use IO::Handle;
$| = 1;         # set flushing on STDOUT
my $wiz_util_old_fh = select (STDERR);
my %wiz_util_class_hash;
$| = 1;         # set flushing on STDERR
select ($wiz_util_old_fh);

use europa_utils;
use filename_utils;
use ptf_update;
use mk_custom_sdk;   # Just to get formatted-print function "print_command."
                     #   --Inefficient.  Sould put in some shared
                     #   module.


################################################################
# Progress
#
# Prints-out a happy progress message in a standard format.
#
################################################################
sub Progress
{
   foreach $msg (@_)
     { &print_command ($msg) }    # Use DvB's unimprovable format.
}


$LEONARDO_EXEC=$ENV{"SPECTRUM_ROOTDIR"};
$LEONARDO_EXEC=~ s/\\/\//g;    # I hate '\'.

$PERL_PROGRAM_FILE = $ENV{"JPERL_PERL_CMD"};
$PERL_PROGRAM_FILE = "perl" if !defined ($PERL_PROGRAM_FILE);


################################################################
# Run_System_Command
#
# THE FIRST ELEMENT OF THE ARGUMENT LIST IS AN ERROR MESSAGE!
#
# You pass a -list- of arguments (some of which may contain 
# spaces).  This function builds them into a properly-formed
# command line, runs the command-line via "system," checks 
# for an error, and prints an informative error message if it happens.
#
# If the system command results in an error, this function
# does not return.
#
################################################################
sub Run_System_Command
{
    my $error_msg;
    my @cmd_args;
    ($error_msg, @cmd_args) = (@_);

    my $cmd_line_string = join(" ",@cmd_args); # FOR DISPLAY ONLY.

    my $num_words = scalar (@cmd_list);

    # comment-out these flusharoos until we can make IO:Hanlde work.
    #STDOUT->autoflush(1);
    #STDERR->autoflush(1);
    
    my $run_banner =<<END_RUN_BANNER;
    ************************************************
    * About to Run System Command: 
        $cmd_line_string
    ************************************************

END_RUN_BANNER
    
    print STDOUT $run_banner;
    print STDERR " ";

    system (@cmd_args) == 0 or die 
        "ERROR ($?) running system command line.
            *** $error_msg
                [$cmd_line_string] ";
}

################################################################
# Log
#
# Logs messages to either one, or both, of two log-files 
# at the same time.  
#
# One log-file is a high-level "scorecard."  This file should
# contain progress messages for "very big" operations only.
# When your giant 72-hour regression test is complete, A 
# user should be able to print-out this file on a few pages
# and determine, from 10,000 feet, what happend and how it went.
#
# The second log file is lower-level progress report.  It should contain more
# fine-grained progress messages, but still nothing like
# the aggregated STOUT and STDERR, which will be megabytes and 
# megabytes of crap.
#
# The first argument to this funciton is logged (with a timestamp) 
# to the scorecard file.  Null strings ("") are not logged.
# The first argument is also logged to the progress report file.
#
# The second argument is logged (with a timestamp) to the 
# progress report.  Null strings ("") are not logged.
#
# **** Where are the log files?
#
# By default, the scorecard log messages will go to a file named
# "./scorecard.log", and the progress report messages will go to a file
# named "./progress_report.log"  
#
# (The messages are also emitted to STDOUT and STDERR).
#
# There is not currenly any way to change the default behavior.
# I might do this someday if I have time.
#
################################################################
sub Log_Guts
{
    my $log_file_name;
    my $msg;
    my $do_timestamp;
    my $do_send_to_stdout;
    ($log_file_name, $msg, $do_timestamp, $do_send_to_stdout) = (@_);

    return if !defined ($msg);
    return if $msg eq "";

    my $time_string = localtime();
    my $uber_msg    = "$msg\n";
       $uber_msg    = "--> $time_string <--\n$uber_msg" if $do_timestamp;

    open (LOG_FILE, ">> $log_file_name") or die 
        "Log: Couldn't open $log_file_name: $!";
    print LOG_FILE $uber_msg;
    close (LOG_FILE);
    
    if ($do_send_to_stdout) {
        print STDOUT   $uber_msg;
    }
}

sub Log
{
    my $score_msg;
    my $prog_msg;
    ($score_msg, $prog_msg) = (@_);

    my $scorecard_file       = $ENV{NIOS_SCORECARD};
    my $progress_file        = $ENV{NIOS_PROGRESS_REPORT};

    $scorecard_file = "./score_card.log"      if $scorecard_file eq "";
    $progress_file  = "./progress_report.log" if $progress_file  eq "";

    my $progress_only = $score_msg eq "";

    &Log_Guts ($scorecard_file, $score_msg, 1, 1);
    &Log_Guts ($progress_file,  $score_msg, 1, 0);
    &Log_Guts ($progress_file,  $prog_msg,  0, $progress_only);
}

################################################################
# Find_SOPC_Component_Directory
#
# In an ideal world, a user would be able to take a system's PTF-file,
# copy it to another computer (or directory), and reproduce the
# original system from it--even if the new computer has the
# SOPC-Builder library installed in a totally different place.
#
# To accomplish this, we need to do "run-time binding" of the SOPC-Builder
# library/libraries.  This means we have to go out and find them
# when the user actually runs the tool, based on some kind of
# search-path.
#
# The search-path is handed to us by the caller as one of those
# dash-dash command-line arguments.  If no search path is specified,
# we use a sensible default (set up in "Process_Wizard_Script_Arguments,"
# below).
#
# This function uses the library-search path to find the correct
# directory containing the given component-class name.
#
# To make things more efficient, the first time this fucntion is called
# a hash is generated of all the valid (read w/ class.ptf) components.
# This hash key is the class name, and the value is the directory.
# Subsequent calls just looking their class name in the hash.
#
################################################################
sub Find_SOPC_Component_Directory
{
  my ($module_class, $path_string) = (@_);

  #Enumerate the class directory if it hasn't already been done
  %wiz_util_class_hash = &Enumerate_SOPC_Components ($path_string)
  	if (scalar(keys(%wiz_util_class_hash)) == 0);

  #extract our module from the class hash
  my $result = $wiz_util_class_hash{$module_class};

  #verify that there is a class.ptf for the specified module
  if ($result eq "") {
    warn ("
     SOPC-Builder library component '$module_class' not found.
         Could not find a 'class.ptf' file which defines '$module_class'
         on the path: ($path_string)\n");
  }
  
  #return the directory
  return ($result);
}

################################################################
# Emumerate_SOPC_Components
#
# In an ideal world, a user would be able to take a system's PTF-file,
# copy it to another computer (or directory), and reproduce the
# original system from it--even if the new computer has the
# SOPC-Builder library installed in a totally different place.
#
# To accomplish this, we need to do "run-time binding" of the SOPC-Builder
# library/libraries.  This means we have to go out and find them
# when the user actually runs the tool, based on some kind of
# search-path.
#
# The search-path is handed to us by the caller as one of those
# dash-dash command-line arguments.  If no search path is specified,
# we use a sensible default (set up in "Process_Wizard_Script_Arguments,"
# below).
#
# This function uses the library-search path to find all componenents
# and places them in a hash with the class name as the key and the 
# directory as the value.
#
# It does so by going through all of the directories in the path and
# looking for a -subdirectory- which contains a "class.ptf" file.  
# When it finds one, it adds that class to the hash
#
################################################################
sub Enumerate_SOPC_Components
{
  my $path_string = shift;

  # Path-elements can be split by numerous oddball characters.
  # this might very well come in handy later:
  #
  my @path_dirs = split (/\s*\+\s*/, $path_string);

  my %result = {};   # Subdirectory in which we found matching "class.ptf"

  foreach $dir (@path_dirs) {
    # It's polite to tolerate directory-names both with- and without
    # trailing slashes.  If we see a trailing slash, we get rid of it:
    # (and we convert all evil backslashes into good forward-slashes.
    $dir =~ s|\\|\/|g;
    $dir =~ s|\/$||g;

    # Get a list of all subdirectories.  Actually, we just get a list
    # of all the files, and then ignore them if they're not
    # directories.
    #
    if (!opendir (DIR, $dir)) {
	#|# MF: I think the SPR says to not print an error (or warning),
	#|#     so I'm taking this out.  Might want to say "skipping
	#|#     unknown lib dir ..." and not make it a warning, just a
	#|#     status message.
    #  warn ("Couldn't open SOPC library directory '$dir' : $!");
      next;
    }
	#|# MF: what about shelling-out to: ls ./*/class.ptf instead?
    my @subdirectories = (readdir(DIR));
    closedir (DIR);

    foreach $sub_dir (@subdirectories) {
      my $sub_dir_path = "$dir/$sub_dir";
      my $class_ptf_filename = "$sub_dir_path/class.ptf";

      next if !-d $sub_dir_path;          # Must be a directory...
      next if !-e "$class_ptf_filename";  #   with a class.ptf file.

      my $db_PTF_file = new_ptf_from_file ($class_ptf_filename);
      next if !$db_PTF_file;              # If we can't open it: forget it.

      my $db_Class = &get_child_by_path ($db_PTF_file, "CLASS");
      next if !$db_Class;                 # No 'class' section: forget it.

      my $found_class_name = &get_data ($db_Class);

      # If we got to here, then we've found a "class.ptf" file which
      # defines the class we're looking for.  I suppose I could
      # do other checks, like look for a valid "MODULE_DEFAULTS" section,
      # but that's a slippery slope.  For now, a "class.ptf" file which
      # defines the class we're looking for is good enoug.
      #
      # Well, not quite good enoug.  We have to check to be sure this
      # class isn't just a dumb commercial.  If it is, change the channel.
      # it.
      #
      my $db_License = 
          &get_child_by_path ($db_Class, "USER_INTERFACE/USER_LABELS/license");
      my $license = &get_data($db_License);
      next if $license =~ /^none/i;

      # MF: forward search-order requires we don't replace existing classes
      #     so, we first check that the hash-entry doesn't exist before storing
      unless ( $result{$found_class_name} )
      {  
           $result{$found_class_name} = $sub_dir_path;
      }
	}
  }

  if (%result eq {}) {
    warn ("
     No SOPC-Builder library components found in the path: ($path_string)\n");
  }

  return %result;
}

################################################################
# Validate_Boolean Copied from vpp.pm (VPP_Validate_Boolean)
#
# TRUE...FALSE.. YES... NO--Who can keep track?
# and that doesn't even count "true" and "False".
#
# To avoid all this confusion, we've decided on an age-old solution:
# An unreasonably-draconian rule.  The only allowed values from now on
# are "1" (the number one) and "0" (the number zero).
#
# Notice especially that the null-string ("") is easy to confuse with
# the number zero, but that's not a mistake we make.  We treat the
# null-string ("") specially, and assign a default 1/0 value (or print
# an error if no default is specified).
#
# For now, we do accept things like "TRUE" and "YES" and "True" and
# "yEs," but this is an -unsupported- courtesy-feature that may 
# go away some day, and which we make no promises about.
#
# Note that the second (semi-optional) argument is a "description,"
# used for error-reporting.  It's not strictly required, but it's
# probably a good idea.
#
################################################################
sub Validate_Boolean
{
    my ($value, $description, $default_value) = (@_);

    return 1 if $value ==  1;
    return 0 if $value eq "0";

    return $value = $default_value if ($value eq "") && ($default_value ne "");
    # Now then.  We are entitled to print an error, because the user
    # is naughty.  Out of the goodness of my heart, I will accept
    # these values:
    if ($value =~ /^TRUE$/i or
        $value =~ /^YES/i   or
        $value =~ /^one$/i  or
        $value =~ /^t$/i      )
    {
      printf STDERR
       "WARNING (Validate_Boolean): Obsolete boolean '$value'.
        using '1' for variable '$description'\n";
      return 1;
    }

    if ($value =~ /^FALSE$/i  or
        $value =~ /^NO/i      or
        $value =~ /^zero$/i   or
        $value =~ /^nil$/i      )
    {
      printf STDERR
       "WARNGING (Validate_Boolean): Obsolete boolean '$value'.
        using '0' for variable '$description'\n";
      return 0;
    }

    # Well, if we didn't return 1 or 0 above, then something
    # went horribly wrong.  Suicide is now the only answer:
    $description = "<unknown-value>" if $description eq "";

    die "ERROR: Expected '1' or '0' for $description. Got: $value.";
}

################################################################
# Strip_Perl_Comments ($expr) Copied from vpp.pm
#
# Takes a string, which might be a multi-line Perl expression.
# For some reason, the Perl "eval" function is too lame to ignore
# comments embedded in the eval-expressoin.  Fine.  We'll strip
# the comments so it doesn't have to.
#
################################################################
sub Strip_Perl_Comments
{
    my $expr;
    my @lines;
    my $stripped_expr;
    ($expr) = (@_);

    @lines = split (/\n/, $expr);

    $stripped_expr = "";
    foreach (@lines)
    {
        $stripped_expr .= "\n", next if /^\#/;
	s/^(.*?)[^\\]\#.*$/$1/;
	$stripped_expr .= "$_\n";
    }
    return $stripped_expr;
}

################################################################
# Parse_Named_Arguments Copied from vpp.pm
#
# Takes the *documentation* for a client function, 
# plus an argument list (@_), and returns to you a couple of 
# hashes (by reference) with all of the args pulled-apart just the way it 
# says in the documentation. 
#
# This is so slick that it scares me.
#
# The variables you get (by reference) are:
#
#  \%arg          : a hash of all the argument values, keyed by their
#                   documented long names
#
#  \%user_defined : A hash of true-false values, keyed by long-name,
#                   that tell whether the user explicitly set the given
#                   argument (as opposed to it assuming a default value).
#
# -- Most client functions don't use the rest of the returned values:
#
#  \%table        : A hash of name-value pairs, one for each 
#                   "name --> value" pair (note the "-->" delimiter)
#                   that appears in the function arguments.
#
#  \@table_order  : a list of keys to the table, giving the order
#                   that keys appeared for the table.  May sound rather
#                   ridiculous, but sometimes the order matters.
#
# Any long name preceded by a (*) is required.  An error will be generated
# unless this argument is explicitly set by the user.
#
# If the comment portion of a documentation line starts with "*{some_string}*,
# some_string defines appropriate values that $arg{$value} may take on.
# the checking is done by converting $arg{$value} to a string and
# checked against a case-insensitive text match of "some_string" i.e. 
#             die unless $arg{$value} =~ /^($some_string)$/i;
#
# Any argument with a short-name documented as (exactly) "--null--" will 
# get set when an *unnamed* (no-equals-sign) parameter is passed.
#
# Arguments without a default value must be documented as having a 
# default value of "--none--".  Actually, any string of the form
# "--xxx--" (for example: "--forget_it--") will be treated as "--none--".
#
#
# **** RESTRICTIONS
#
# The documented long name, short name, and default value for any 
# argument must NOT contain white space.  Sorry.
#
# Arguments in the documentation string are listed one-per-line.
# Lines in the documentation string starting with '#' are stripped-out.
# Blank lines in the documentation string are ignored.
#
################################################################

sub Parse_Named_Arguments
{
    my $doc_string;
    my @fn_arg_list;

    ($doc_string, @fn_arg_list) = (@_);

    # Ignore #-comments and blank lines in documentation:
    $doc_string =  &Strip_Perl_Comments ($doc_string);
    $doc_string =~ s/\n[\n\s]+/\n/g;

    my $strict = 2;   # Die on unrecognized arguments.  Sir, yes sir.

    # First, pull apart the documentation string.  We use the 
    # documentation to set the my hashes %arg (with default values)
    # and %long_name (for short-name de-aliasing).
    #
    # Note that this is kind-of wasteful, since we re-parse the documentation
    # every time the function is called.  Ain't Perl grand?
    my %arg;
    my %long_name;
    my %short_name;
    my %required;
    my %user_defined;
    my %table;
    my @table_order = ();
    my $arg_name_if_unnamed = "";
    my %recognized;                # Table of valid argument names.
    my %values_allowed;

    my @doc_lines = split (/\s*\n\s*/, $doc_string);
    foreach $doc_line (@doc_lines) 
    {

	# strip out any space between * (required-specifier) and arg name:
	$doc_line =~ s/^\s*\*\s*/*/;
	next if $doc_line =~ /^\s*$/;   # skip blank lines.

        # Things all by themselves on a line, in square-brackets, are
        # "special instructions" that control &Parse_Named_Arguments itself.
        if ($doc_line =~ /^\[(\S*)\]/) 
        {
           my $special_instruction = $1;
           # For now, the only "special" setting we recognize is
           #   disabling strict-mode.  But there could be more in the future.
           $strict = 0 if $special_instruction eq "silent";
           $strict = 0 if $special_instruction eq "hippie";
           $strict = 1 if $spectial_instruction eq "whiner";
           $strict = 1 if $spectial_instruction eq "warn";
           $strict = 2 if $spectial_instruction eq "fascist";
           $strict = 2 if $spectial_instruction eq "die";
           next;
        }

	my $arg_name;
	my $short;
	my $default_val;
	my @buncha_extra_words;

	($arg_name, $short, $default_val, @buncha_extra_words) = 
	    split (/\s+/, $doc_line);

	# Some extra protection to make this code pass
	# Perl -w test:
	@buncha_extra_words = () if !defined (@buncha_extra_words);

	$required   {$arg_name} = "Yes"        if ($arg_name    =~ s/^\*//   );
        $recognized {$arg_name} = "Yes";
	$arg        {$arg_name} = $default_val if ($default_val !~ /^--.*--$/);
	$long_name  {$short}    = $arg_name    if ($short       ne "--none--");
	$short_name {$arg_name} = $short       if ($short       ne "--none--");
	$arg_name_if_unnamed    = $arg_name    if ($short       eq "--null--");

	my $required_values = join ("" , @buncha_extra_words);
	if ($required_values =~ s/^\*(.*)\*(.*)/$1/)
	{
	    $values_allowed {$arg_name} .= $required_values;
	}
    }

    ################
    # Now actually analyze the arguments that got passed to the
    # function, according to the documentation we just studied.

    # Glue all the function arguments into a single comma-delimited string:
    my $arg_string;
    $arg_string = join (',' , @fn_arg_list);

    # Re-Break argument string into a list of comma-delimited sub-strings:
    #
    # But first,  deal with the very-real case of arguments that 
    # might have commas -buiried inside-.  A user can pass an argument
    # with a comma in it by putting parenthesis around it.  We won't break 
    # on commas surrounded by parentheses.
    #
    while ($arg_string =~ 
	   s/(\([^\)]*)\,(.*\))/$1__AUTO_COMMA_PLACE_HOLDER__$2/g){}
    
    my @named_arg_list = split (/\s*,\s*/, $arg_string);

    #Examine each argument:
    foreach $name_value_pair (@named_arg_list)
    {
	# Strip leading/trailing whitespace, because it bugs me:
        $name_value_pair =~ s/^\s*//;
        $name_value_pair =~ s/\s*$//;

	# Put commas back in, if any:
	$name_value_pair =~ s/__AUTO_COMMA_PLACE_HOLDER__/,/g;

	# "-->" - delimited pairs are passed straight through to the 
	# client function, with no analysis, through the %table hash:
	if ($name_value_pair =~ /(.*)(-->|<--)(.*)/)
	{ 
	    my $nm  = $1;
	    my $val = $3;
	    $nm = "--null--" if ($nm eq "");
	    $nm =~ s/\s*$//;   # strip trailing whitespace from $nm.
	    $nm =~ s/^\s*//;   # strip leading  whitespace from $nm.
	    $table {$nm} = $val;
            push (@table_order, $nm);
	    next;
	}

	# Special hack for expressions-with-equals-signs:
        # Sometimes, you want to pass in an argument value with 
        # an equals-sign in it.  In particular, you might want to set 
	# one of the arguents equal to a verilog expression.  Here's 
        # a real-world example:
        #
	# 	&Delay ("out      = timeout_count_enable,
	# 		clk       = acq_clk,
        # 		in        = (timeout_presacle_counter == 0),
        # 		reset     =,
	# 	       "); 
        #
        # Lookie there: two equals-signs. So.  Here's what 
        # we'll do. If any equals-signs appear inside parentheses,
        # we'll *temporarily* replace them with an unambiguous string.  
        # Then we split the name/value pair on "=".  Afterwards, we restore 
        # the equals-signs in the parenthesized expression. 
	while ($name_value_pair =~ 
	   s/(\(.*)=(.*\))/$1__AUTO_EQUALS_SIGN_PLACE_HOLDER__$2/g){}

	# Deal with the special "unnamed argument" case. One of the 
	# arguments can 
	# Deal with the special input-name case, which we allow to be 
	# specified without an equals-sign (coerce into standard format):
	$name_value_pair = "$arg_name_if_unnamed=$name_value_pair"  
	    if ($name_value_pair !~ /=/);

	my $arg_name  = "";
	my $arg_value = "";
	($arg_name, $arg_value) = split (/\s*=\s*/, $name_value_pair);
	die ("Badly-formed name-value pair: $name_value_pair") if !$arg_name;

	# restore temporarily-hidden parenthesized euqals-signs:
	$arg_value =~ s/__AUTO_EQUALS_SIGN_PLACE_HOLDER__/=/g;

	# Translate short argument names into long argument names:
	my $long_version;
	$arg_name = $long_version if ($long_version = $long_name{$arg_name});

	# Complain bitterly if an unrecognized argument arrives:
        die ("unrecognized argument: \"$arg_name\".") 
	    if (($strict >= 2) && !$recognized{$arg_name});

        print STDERR ("Warning: unrecognized argument \"$arg_name\".\n") 
            if (!$recognized{$arg_name}) && ($strict >= 1);

	# Record the fact that the user explicitly set this argument:
	$user_defined {$arg_name} = 1;

	if ("$arg_value" ne "")
	{
	    $arg {$arg_name} = $arg_value; 

	    # Allow elements in the $arg-array to be looked-up by their
	    # short names as well.
	    # 
	    # This feature was added pretty late-in-the-game by 
	    # TPA (12/22/00).
	    my $short_version = $short_name {$arg_name};
	    $arg{$short_version} = $arg_value if $short_version ne "";
	}
    }

    # Check that all the arguments marked "required" (*) were actually 
    # set by user:
    foreach $arg_name (keys(%required))
    {
	die ("required argument ($arg_name) missing")
	    if (!$user_defined {$arg_name});
    }

    # Check that all the arguments with allowable values
    # are within those allowable values.
    #
    # Handle the special case when the given "values allowed" is 
    # the string "bool" or "boolean".  In that case, we validate that
    # the arg seems to be some sort of boolean, and actually 
    # -change the arg value- into a testable 1/0-result.
    foreach $arg_name (keys(%values_allowed))
    {
      my $string = eval ("$arg{$arg_name}");

      if ($values_allowed{$arg_name} =~ /^bool(ean)?$/) {
        $arg{$arg_name} = &Validate_Boolean ($arg{$arg_name}, $arg_name);
      } else {
        &ribbit ("
                  required value, ($arg_name) value ($arg{$arg_name})
                  not an allowed value. Allowable values are:
                  $values_allowed{$arg_name}\n")
          unless ($string =~ /^($values_allowed{$arg_name})$/i);
      }
    }

    return (\%arg, \%user_defined, \%table, \@table_order);
}


################################################################
# Process_Wizard_Script_Arguments
#
# At the top of each X-wizard script (mk_<X>.pl) there was
# a little preamble of code which analyzed the PTF file and 
# set some global variables in a highly-ritualized way.
#
# Did someone say "highly ritualized?"  This sounds like a job
# for a subroutine.  I'm so lazy.  That's why I'm a good Perl 
# programmer.
#
# This is just a wrapper around &Parse_Named_Arguments which,
# additionally:
#
#  * Reads the "argments" to this script out of the (indicated) PTF file,
#    and re-phrases them as an argument list which is interpreted
#    by the aforementioned &Parse_Named_Arguments.
#
#  * Sets the global variable $QUARTUS_PROJECT_DIR
#
#  * Sets the global variable $MODELSIM_DIR
#
#  * Returns a string of all the input arguments with the 
#    equals-signs substituted with "__equals__".
#    (useful for passing arguments down to PTF-file).
#
#  * "Decodes" spaces in input-arguments.  
#     we've found that it's difficult to pass 
#     script-arguments around if they contain whitespace.
#     solution: Replace " " with "__jperl_space__".  This 
#     function does the reverse, acting as a receiver for 
#     this sneaky encoding.
#
#  This routine has one (and maybe later more) arg which is
#  always accepted: "wizard."  This is saved-away in the PTF-file
#  and used by the wizards themselves later to figure out 
#  who ran this funciton (which wizard), and who should be called
#  when this device needs to be edited.
#
# The use of the term "arguments" in this function is a bit tricky.
# There are really two distinct sets of things we call "arguments":
#
#   1) The actual arguments passed to this here function, which 
#      specify the current working directory and PTF file and stuff.
#
#   2) The contents of the WIZARD_SCRIPT_ARGUMENTS" section of the 
#      PTF file
#
# We have to process the type (1) arguments in order to -get at- the 
# type (2) arguments.  The result of this function, a hash, is obtained
# by opening the PTF file (based on the (1) arguments) and then recasting
# the contents of the PTF-flile (the type (2) arguments).  How very 
# confusing.  Sorry.  That's what happens when there are multiple levels
# of indirection.
#
$Process_Wiz_Args_Doc=<<END_OF_DOCUMENTATION_STRING ;

[hippie]   --tolerate unfamiliar arguments.

# LONG NAME              SHORT    DEFAULT      DESCRIPTION
# -----------------------------------------------------------------------
*  system_directory     --none--     .      Directory where system resides.
*  target_module_name     name   --none--   Module being generated.
*  system_name          --none-- --none--   Name of system being generated.
*  sopc_directory       --none-- --none--   Where the SOPC-Bldr is installed.
*  sopc_lib_path        --none-- --none--   Where to look for lib dirs.
   generate             --none--    1       "Yes, please do generate, please."
   verbose                 v        0       *bool* Extra blabbering output.

# Just for sheer convenience, we also provide the client (caller) with
# "fictitious" arguments called:
#
*  class_directory      --none-- --none--   Where THIS component lib dir is.
   system_sim_dir        sim_dir --none--   If sim project, where to put it.

#
# dvb, 2005.02.07: as it turns out, --module_lib_dir=class_directory
# IS being passed in. So I will use that if present, rather
# than the time-consuming search for the module. (15 seconds).
# seconds off the generation time by passing it in.
#

END_OF_DOCUMENTATION_STRING
#
################################################################
sub Process_Wizard_Script_Arguments
{
    my ($arg_doc_string, @input_arg_list) = (@_);

    ################
    # First, we expect to see a certain, predefined set of
    # incoming arguments.
    #
    # Note that these incoming arguments are re-interpreted as part of 
    # our fictitious name=value "argument" list, as well as processed
    # directly here.
    #
    my @name_equals_value_list = ();
    my $sys_dir    = "";
    my $sys_name   = "";
    my $mod_name   = "";
    my $lib_path   = "";
    my $class_directory = "";

    foreach $arg (@input_arg_list)
    {
        # We expect arguments to be name=value pairs that begin 
        # with double-dashes.  Hmm.
        $arg =~ s/^--//           or ribbit "malformed argument: $arg";
        $arg =~ /([^=]+)=([^=]*)/ or ribbit "malformed argument: $arg";
        push (@name_equals_value_list, $arg);
        my $arg_name = $1;
        my $arg_value = $2;

        $sys_dir  = $arg_value  if ($arg_name =~ /^system_directory/);
        $sys_name = $arg_value  if ($arg_name =~ /^system_name/);
        $mod_name = $arg_value  if ($arg_name =~ /^target_module_name/);
        $sopc_dir = $arg_value  if ($arg_name =~ /^sopc_directory/);
        $lib_path = $arg_value  if ($arg_name =~ /^sopc_lib_path/);
        $class_directory = $arg_value if($arg_name =~ /^module_lib_dir/);
	    $verbose  = $arg_value  if ($arg_name =~ /^verbose/);
    }


    # Library path default:
    #    If no library path was specified, we use a sensible default:
    #
    if ($lib_path eq "") {
      $lib_path = "$sopc_dir/components";
      push (@name_equals_value_list, "sopc_lib_path=$lib_path");
    }

    # This is a bit bogus, but it's a thing several people might need
    # to know, and which we can figure out here.
    push (@name_equals_value_list, "system_sim_dir=$sys_dir/$sys_name\_sim");

    &Progress ("Extracting PTF info for $mod_name.") if $verbose;

    $msg = "Couldn't process PTF-file arguments for module $mod_name.";
    my $ptf_filename = "$sys_dir/$sys_name.ptf";

    &PTF_Translate_Old_Version ($ptf_filename);  # Update legacy files.

    my $db_PTF_File  = &PTF_New_Required_Ptf_From_File ($ptf_filename, $msg);
    my $db_Sys       = &PTF_Get_Required_Child_By_Path ($db_PTF_File,
                                                        "SYSTEM", $msg);

    ################
    # The "-target_module_name" argument is special.  If it has the
    # exact-same name as the system itself, then we get the
    # WIZARD_SCRIPT_ARGUMENTS from the SYSTEM section itself, instead
    # of one of its sub-modules.
    #
    my $db_Module = $db_Sys;
       $db_Module = &PTF_Get_Required_Child_By_Path
                          ($db_Sys, "MODULE $mod_name", "That's odd.")
                    unless $mod_name eq $sys_name;

    my $db_Wiz_Args = &get_child_by_path ($db_Module,
                                          "WIZARD_SCRIPT_ARGUMENTS");

    ################
    # The fictitious  "class_directory"  argument
    #
    # We -wish- the user had passed us yet-another command-line argument
    # called "--class_directory"  The user did not because it is, after
    # all, something we could figure out for ourselves.  Please allow
    # me to demonstrate:
    #

    # dvb 2005: and maybe they have, now.

    if($class_directory ne "")
    {
        push(@name_equals_value_list,"class_directory=$class_directory");
    }
    else
    {   # if not
        if ($mod_name eq $sys_name)
        {
            # If We're generating the system (and bus) itself, then
            # the "class_directory" is just the directory in which the
            # system-builder library stuff lives:
            #
            # NOTE: JWIZ NAME CHANGE
            #    The name of this directory should be changed when we
            #    re-name all the components.  I think.  Maybe.
            push (@name_equals_value_list, 
                  "class_directory=$sopc_dir/bin");
        } else {
            # This is just an ordinary module, so we search for its 
            # class-directory in the conventional manner:
            #
            my $class     = &PTF_Get_Required_Data_By_Path ($db_Module, "class");
            my $class_dir = &Find_SOPC_Component_Directory ($class, $lib_path);
            push (@name_equals_value_list, "class_directory=$class_dir");
        }
    }

    ################
    # For compatibility with the old-style (and very powerful)
    # &Parse_Named_Arguments function, we convert all the assignments
    # in the fetched WIZARD_SCRIPT_ARGUMENTS section into
    # a Perl-list of "name=value" strings.  This lets us use all our
    # old, familiar argument-parsing-and-checking infrastructure.  How
    # civilized.
    #
    my $num_wiz_args = &get_child_count ($db_Wiz_Args);
    for ($child_index = 0; $child_index < $num_wiz_args; $child_index++)
    {
        my $db_Arg = &get_child ($db_Wiz_Args, $child_index);
        my $name = &get_name ($db_Arg);
        next unless $name;

        my $string = $name . "=" . &get_data ($db_Arg);
        push (@name_equals_value_list,
              $string
              );
    }

    # Take spaces from Perl as a special token.  This helps us smuggle
    # them past the command line.
    #
    # This is almost totally anachronistic, but c'est la vie, eh?
    # There's no reasyn really to quit doing this.
    #
    my $named_arg_string = join (",", @name_equals_value_list);
       $named_arg_string =~ s/\n/ /mg;          # form a single line, please.
       $named_arg_string =~ s/__jperl_space__/ /g;

    my ($arg, $user_defined, $table) = 
        &Parse_Named_Arguments ("$arg_doc_string \n $Process_Wiz_Args_Doc",
                                $named_arg_string);

    return ($arg, $user_defined, $db_Module, $db_PTF_File);
}

################################################################
# PTF_Eval_Expr
#
#  If you have an assignment-value from a PTF-file,
# this subroutine trys to evaluate it as a numerical expression.
# This is handy for converting hex-values to "real numbers," 
# for example--or even allowing users to put honest-to-Pete 
# arithmetic expressions in their PTF-files:
#
#    IRQ_Number = "36 + 0xC";     # Valid when evaluated.
# 
# Sometimes, numeric fields can have special marker-values, 
# like "N/A" or "peripheral-controlled".  We give the caller option
# of specifying a list of such "special" values, which we return
# unmolested.
#
# The user may also optionally provide a description, which is 
# handy for error-reporting.
#
################################################################
sub PTF_Eval_Expr
{
    my ($value, $description, @special_values) = (@_);

    foreach $special (@special_values)
      {  return $value if $value eq $special; }

    $description = "<unknown>" if $description eq "";

    my $result = eval ($value);

    my $msg =<<EOM;
      Error: Could not evaluate the following expression:
             $value

         This nasty little expression was found in the 
         PTF data under this path:

             $description

         When I tried to evaluate said nasty little expression,
         I got this here error:

             $@
EOM
    die $msg if $@;
    return $result;
}

################################################################
# PTF_Get_Required_Data_By_Path
#
# Just like ptf_parse's "get_data_by_path," except that 
# we print a nasty error message and die if the data
# we requested isn't there.
#
################################################################
sub PTF_Get_Required_Data_By_Path
{
    my ($ptfRef, $path, $error_message) = (@_);

    my $result = get_data_by_path($ptfRef, $path);

    if ($result eq "")
    {
       my $ptfName = &get_name ($ptfRef) . " " . &get_data($ptfRef);
       my $msg =<<EOM;
    Error: $error_message
        Required assignment: 
             '$path' 
        was not found in PTF section:
             '$ptfName'

EOM
       die $msg;
     }
    return $result;
}
        
################################################################
# PTF_Get_Required_Child_By_Path
#
# Just like ptf_parse's "get_child_by_path," except that 
# we print a nasty error message and die if the child
# we requested isn't there.
#
################################################################
sub PTF_Get_Required_Child_By_Path
{
    my ($ptfRef, $path, $error_message) = (@_);

    my $result = get_child_by_path($ptfRef, $path);

    if ($result eq "")
    {
       my $ptfName = &get_name ($ptfRef) . " " . &get_data($ptfRef);
       my $msg =<<EOM;
    Error: $error_message
        Required PTF section:
             '$path' 
        was not found in PTF section/file:
             '$ptfName'

EOM
       ribbit $msg;
   }
    return $result;
}

################################################################
# PTF_New_Required_Ptf_From_File
#
# Just like ptf_parse's "new_ptf_from_file," except that 
# we print a nasty error message and die if the file 
# can't be opened.
#
################################################################
sub PTF_New_Required_Ptf_From_File
{
    my ($filename, $error_message) = (@_);

    my $result = new_ptf_from_file ($filename);

    if ($result eq "") 
    {
       my $msg =<<EOM;
    Error: $error_message
        Required PTF file: 
             '$filename' 
        could not be opened.

EOM
       die $msg;
   }
    return $result;
}

################################################################
# PTF_Get_Boolean_Data_By_Path
#
#  Fishes value out of PTF-file, then validates to make 
#  sure it's boolean.
# 
################################################################
sub PTF_Get_Boolean_Data_By_Path
{
    my ($ptfRef, $path, $default) = (@_);
    my $data = get_data_by_path ($ptfRef, $path);

    return &Validate_Boolean ($data, $path, $default);
}

1;    # Modules must say "1"--mustn't they?











