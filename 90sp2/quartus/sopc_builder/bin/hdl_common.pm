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

# hdl_common.pm - contains common routines for perl scripts called by the
# user defined interface wizard

use strict;
use ptf_parse;

sub parse_args
{
  my $arg;
  my $argVal;
  my $argc;
  my %hash;

  $argc = 0;


  while($arg = shift)
  {
    usage() if $arg eq "--help";

    if($arg =~ /^--/)
    {
      if($arg =~ /^--(.*)\=(.*)$/)
      {
        $arg = $1;
        $argVal = $2;
      }
      elsif($arg =~ /^--(.*)$/)
      {
        $arg = $1;
        $argVal = 1;
      }

      $hash{$arg} = $argVal;
    }
    else
    {
      $hash{$argc++} = $arg;
    }
  }

  $hash{_argc} = $argc;

  return \%hash;
}



# ----------------------------------------
# get_HDLfiles_from_module (moduleRef)
#
# extract HDL file list from moduleRef
# return - array of filenames
#
sub get_HDLfiles_from_module
{
    my $moduleRef = shift;
    my @fileNames;

#   loop through the modules children
    my $childCnt = &get_child_count ($moduleRef);
    for (my $idx=0; $idx<$childCnt; $idx++)
    {
        my $hdl_info = &get_child ($moduleRef, $idx);
#       is this an HDL_INFO section?
        if (&get_name ($hdl_info) eq "HDL_INFO")
	    {
#           loop through the HDL_INFO sections children
	        my $sectCnt = &get_child_count ($hdl_info);
	        for (my $jdx=0; $jdx<$sectCnt; $jdx++)
	        {
	            my $hdl_file = &get_child ($hdl_info, $jdx);
#               push it on the array if its an HDL_FILE
                if (&get_name ($hdl_file) eq "Imported_HDL_Files")
                {
                    my $names = &get_data($hdl_file);
                    @fileNames = split (/,/ , $names);
                }
            }
        }
    }
    return @fileNames;
}

1;
