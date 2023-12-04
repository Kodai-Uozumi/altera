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







use ptf_parse;
use format_conversion_utils;
package run_system_command_utils;
require Exporter;
@ISA = Exporter;
@EXPORT = qw(System_Win98_Safe 
             Run_Command_In_Unix_Like_Shell
             Capture_Output_From_Unix_Like_Shell
			 Set_External_Command_Visible
             );
use strict;

################################################################
# System_Win98_Safe
#
# Win-98-safe "wrapper" for Perl's built-in 'system' command.
#
# Windows-98 can't handle an executable-name ($ARGV[0]) which
# has forward slashes in it.  WinNT and Win2000 can handle
# either forward- or backward-slashes.  So, if we notice that
# the operating system is Windows (or Cygwin), then we convert
# forward-slashes to backslashes in -only- the program-name
# part of the system-command.  We leave all the arguments 
# alone-- whether '/' or '\' is OK in an arugment is entirely 
# up to the program.
#
################################################################
sub System_Win98_Safe
{
  my (@command_parts) = (@_);
  my $sys_cmd         = join (" ", @command_parts);

  $sys_cmd =~ /^\s*(\S+)\s+(.*)$/ or die
    "System_Win98_Safe: Suspicious system-command: $sys_cmd";

  my $program_path = $1;
  my $arguments    = $2;

  $program_path =~ s|/|\\|g if ($^O =~ /(MSWin|cygwin)/i);

  my $new_sys_cmd = "$program_path $arguments";
  system ($new_sys_cmd);

  my $error_code = ($? >> 8);
  return $error_code;
}

################################################################
# Set_External_Command_Visible
#
# Using specialized features of our own perl build (on Win32),
# set a flag which determines whether system()-ed commands
# are in/visible.
#
################################################################
sub Set_External_Command_Visible
{
	my $visible = shift;
	if ($visible)
	{
		open (ABRAHAM_LINCOLN_NO_STEALTH, "");
		close ABRAHAM_LINCOLN_NO_STEALTH;
	}
	else
	{
		open (ABRAHAM_LINCOLN_STEALTH, "");
		close ABRAHAM_LINCOLN_STEALTH;
	}
	return $visible;
}

################################################################
# Run_Command_In_Unix_Like_Shell
#
# When say "system()" in Perl, you never know exactly what you're
# going to get.  If you're on a DOS box, your command executes in a 
# DOS-shell.  If you're on a Solaris machine, your command is probably
# executing in a civilized environment with various expected
# shell-features (e.g. the 'which' program) accessible to your program
# or script.
#
# This function system()'s your command from within Cygwin (if you're
# on a PC) or from within 'sh' if you're in UNIX.  Either way, you get
# a more predictable execution-environment.
#
################################################################
sub Run_Command_In_Unix_Like_Shell
{
  my ($sopc_directory, @command_parts) = (@_);
  
  return _Use_Unix_Like_Shell ($sopc_directory, 
                               "return-code", 
                               @command_parts);
}

sub Capture_Output_From_Unix_Like_Shell
{
  my ($sopc_directory, @command_parts) = (@_);
  
  return _Use_Unix_Like_Shell ($sopc_directory, 
                               "return-output", 
                               @command_parts);
}

sub _Use_Unix_Like_Shell
{
   # Return-option is either, literally:
   #          "return-code"   : This runs system() and returns the
   #                            exit-code of the program.
   #          "return-output" : This runs the command, backtick-style,
   #                            and returns the output captured thereby.

  my ($sopc_directory, $return_option, @command_parts) = (@_);

  if (scalar (@command_parts) == 0)
  {
     die ("No command to run!\n",
          "  You probably forgot to pass the system-directory.\n"
          );
  }

  $sopc_directory =~ s|\\|/|g;   # Unix-style paths, please.

  my $sys_cmd = join (" ", @command_parts);
# the westward wind bloweth
  $sys_cmd =~ s|\\|/|g;
# HEY!  this was doing the colon-drive to double-slash-drive thing (now it's not):
#  $sys_cmd =~ s|^(\w)\:/?|//$1/|;

  # Run the "nios_sh" command -in front of- the user-command.
  # this has the nice side-effect of setting-up a bunch of handy paths
  # and variables and such.
  $sys_cmd = ". $sopc_directory/bin/nios_sh; $sys_cmd"; 

  # But, before we run "nios_sh", set the "altera" variable.
  # MF: I believe this is out-of-date...
  if ($sopc_directory =~ m|^(.*)/excalibur/sopc_builder$|) {
    $sys_cmd = "altera=$1; $sys_cmd";
  }

  # And, even before -that-, you have to set the "sopc_directory" variable.
  $sys_cmd = "sopc_directory=$sopc_directory; $sys_cmd";

  # Love Bill Gates' colon and stupid drive-letters:
  #if ($^O eq "MSWin32") {
  #  while ($sys_cmd =~ m|^(.*)(\W)([a-z]):/(.*)$|i) {
  #    #$sys_cmd = $1.$2."/cygdrive/".lc($3)."/".$4;
  #    $sys_cmd = $1.$2."/cygdrive/".lc($3)."/".$4;
  #  }
  #}
  
  # Try and figger-out a shell-command to run:
  my $sh = "";
	if ($^O =~ /win/i)
		{
      $sh = "$ENV{QUARTUS_ROOTDIR}" . "/bin/cygwin/bin/sh.exe";
		}
	else
		{
		$sh = '/bin/sh';
		}

    die ("cannot find any '\cygwin\bin\sh.exe' on your system.
          You must install Cygwin on your system to provide a
          unix-like shell") if (! -e $sh);

  my $final_sys_cmd = "$sh -c \"$sys_cmd\"";
  format_conversion_utils::fcu_print_command ($final_sys_cmd);
   

  if       ($return_option eq "return-code") {
      return system ($final_sys_cmd);
   } elsif ($return_option eq "return-output") {

# Original:
#      return `$final_sys_cmd`;
# MF: with NT4+altera_perl, the output isn't captured properly.
#     so, this is a workaround (I hope you have nothing important in $out_file_name!):
        my $out_file_name = "____altera_sopc_builder_captured_output____";
        unlink ($out_file_name) if(-e $out_file_name);
        system ("$final_sys_cmd > $out_file_name");
        open  (OUTFILE, "$out_file_name");
        my $result = <OUTFILE>;	# I think this only handles one line, but that's all we need for now!
        # print " _Use_Unix_Like_Shell Captured: $result \n";
        close (OUTFILE);
        unlink ($out_file_name) if(-e $out_file_name);
        return $result;
   } else {
      die ("Invalid return option: '$return_option'");
   }
      
}

1;   # I can't stop myself from saying "one."


