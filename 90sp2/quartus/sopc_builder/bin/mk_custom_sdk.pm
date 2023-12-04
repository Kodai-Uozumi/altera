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
#
# ex: set tabstop=4:

# +---------------------------------------------
# | mk_custom_sdk.pm
# |
# | Implements mk_custom_sdk() which can be
# | be invoked from the Nios wizards or
# | on the command line.
# |

use strict;
use ptf_parse;
use wiz_utils;
use europa_utils;

my $gDebug = 0;
#
# 2000 August
# dvb \ Altera Santa Cruz

#
# name of the directory within each wizard's dir
# with doc, inc, src, and lib files
#

my $CUSTOM_SDK_PIECES_DIR = "custom_sdk_pieces";
my $gUseOldSillyJNames = 0;	# if 1, convert to old juartwizard style names.


# |
# | These strings get emitted for
# | historical reasons.
# |

my $g_old_nios_s = <<EOP;
;
; for backwards compatibility
; we have this file named "nios.s",
; which does what it ever did.
;
; As of SOPC Builder 2.6 (2002 May-ish)
; the generated header files are excalibur.[hs].
;
; This file is compatible with GNU tools only.
;

	.include "nios_macros.s"
	.include "excalibur.s"

; end of file
EOP

my $g_old_nios_h = <<EOP;
//
// for backwards compatibility
// we have this file named "nios.h",
// which does what it ever did.
//
// As of SOPC Builder 2.6 (2002 May-ish)
// the generated header files are excalibur.[hs].
//
	
#ifndef _nios_
#define _nios_

	#include "excalibur.h"

#endif

// end of file
EOP


# --------------------------
# bail(string)
#
sub bail
	{
	my $x = shift;

	warn("ERROR: $x");
	exit (-1);
	}

# --------------------------
# mcs_dprint (list)
#
#  prints if debugging is on
sub mcs_dprint
	{
    my (@p) = (@_);
    for(my $i = 0; $i <= $#p; $i++)
        {
        $p[$i] =~ s/\n//gs;
        }
	if($gDebug)
		{
		print "(debug) ";
		print @p;
		print "\n";
		}
	}

sub mcs_dprintf
	{
	if($gDebug)
		{
		print "(debug) ";
		printf @_;
		print "\n";
		}
	}


sub date_time
	{
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdet) = localtime(time);
	$mon++;
	$year += 1900;

	my $d = sprintf("%04d.%02d.%02d",$year,$mon,$mday);
	my $t = sprintf("%02d:%02d:%02d",$hour,$min,$sec);

	return "$d $t";
	}


# +---------------------------------------
# | strip_comments(file_contents,comment_char)
# |
# | comment_char one of "/",";", or "#"
# | if /, then strip //... and /*...*/
# |

sub strip_comments($$;$)
    {
    my ($file_contents,$comment_char,$filename) = (@_);

    # filename for debug output only

    mcs_dprint "stripping \"$comment_char\""
            . ($filename ? "from $filename" : "");
    mcs_dprint "old length: " . length($file_contents);
    if($comment_char eq "/")
        {
        $file_contents =~ s/\/\*.*?\*\///gs; # kill /*...*/
        $file_contents =~ s/\/\/.*?$//gm;   # kill //...$
        }
    elsif($comment_char ne "")
        {
        $file_contents =~ s/${comment_char}.*$//gm;
        }
    mcs_dprint "new length: " . length($file_contents);

    return $file_contents;
    }

# +---------------------------------------
# | guess_comment_char(filename)
# |
sub guess_comment_char($)
    {
    my ($filename) = (@_);

    my $comment_char = "";
    my $filetype = "";

    if($filename =~ /^.*\.(.*)$/)
        {
        $filetype = lc($1);
        }

    if(($filename =~ /^.*Makefile$/)
            or ($filetype eq "mk")
            or ($filetype eq "tcl"))
        {
        $comment_char = "#";
        }
    elsif(($filetype eq "c") or ($filetype eq "h"))
        {
        $comment_char = "/";
        }
    elsif($filetype eq "s")
        {
        $comment_char = ";";
        }

    mcs_dprint "guessed $filename comment char \"$comment_char\"";
    return $comment_char;
    }

# +---------------------------------------
# | maybe_write_file(file_name,contents[,comment_char])
# |
# | If the file already exists, and is equivalent,
# | then dont write it. (This preserves timestamps
# | for Make dependencies.) What does "equivalent"
# | mean? We strip off the comments and compare after that.
# |

sub maybe_write_file($$;$)
    {
    my ($filename,$contents,$comment_char) = (@_);
    my $doright = 1;

    mcs_dprint "maybe_write $filename comment char \"$comment_char\"";

    # |
    # | Old file exists?
    # |

    if(-f $filename)
        {
        my $old_contents = readFile($filename);

        if(!$comment_char)
            {
            $comment_char = guess_comment_char($filename);
            }

        my $old_stripped =
                strip_comments($old_contents,$comment_char,$filename);
        my $new_stripped =
                strip_comments($contents,$comment_char);

        if($old_stripped eq $new_stripped)
            {
            $doright = 0;
            }
        }

    if($doright)
        {
        writeFile($filename,$contents);
        }
    else
        {
        mcs_dprint "did not write $filename";
        }
    }

# +-----------------------------------
# | maybe_copy_file(src_filename,dst_filename[,comment_char])
# |

sub maybe_copy_file($$;$)
    {
    my ($src_filename,$dst_filename,$comment_char) = (@_);

    my $src_contents = readFile($src_filename);
    maybe_write_file($dst_filename,$src_contents,$comment_char);
    }

# --------------------------
# print_command (string)
#
# prints time, and then string

sub print_command
	{
	my $command = shift;
	my $dt = date_time();

	print "# $dt (*) $command\n";
	}

sub print_warning
	{
	my $w1 = shift;

    my $dt = date_time();
    print "# \n";
    print "# $dt mk_custom_sdk: WARNING\n";
    print "# \n";
    print "#    $w1\n";
    print "# \n";
	}


# -------------------------------
# table_begin() returns a reference to a table to be constructed
# table_addrow() takes the tableRef, and adds the rest of the
#                args as elements to a single row
# table_sprint() returns the table in left-justified columns
#                as one big string.
#

my $table_ROWBREAK = "##rzw##";		# an unlikely character sequence

sub table_begin
	{
	my @table;

	return \@table;
	}

sub table_addrow
	{
	my $tableRef = shift;
	my $eachArg;
	my $line;

	push @$tableRef,join($table_ROWBREAK,@_);
	return;

	while(($eachArg = shift) ne "")
		{
		$line .= $table_ROWBREAK if $line;
		$line .= $eachArg;
		}
	
	push @$tableRef,$line;
	}

sub table_sprint_range
	{
	my ($tableRef,$line_first,$line_last) = (@_);

	my $columnSpaces = 1;
	my @columnMaxWidths;
	my $line_number;
	my $line;
	my @line;
	my $i;
	my $len;
	my $result;

	# first pass: find the maximum width for each line

	for($line_number = $line_first; $line_number <= $line_last; $line_number++)
		{
		$line = $$tableRef[$line_number];
		@line = split(/${table_ROWBREAK}/,$line);
		for($i = 0; $i < scalar(@line); $i++)
			{
			$len = length($line[$i]);
			$columnMaxWidths[$i] = $len if $columnMaxWidths[$i] < $len;
			}
		}
	
	# second pass: spew them out with enough blanks

	for($line_number = $line_first; $line_number <= $line_last; $line_number++)
		{
		$line = $$tableRef[$line_number];
		@line = split(/${table_ROWBREAK}/,$line);
		my $line_c = scalar(@line);
		for($i = 0; $i < $line_c; $i++)
			{
			my $lineItem = $line[$i];
			my $blanx = $columnMaxWidths[$i] - length($lineItem) + 1;

			# | Pad... if there's another column coming.

			$result .= $lineItem;
			$result .= (" " x $blanx) if ($i < $line_c-1);
			}
		$result .= "\n";
		}
	return $result;
	}

sub table_sprint
	{
	my ($tableRef) = (@_);
	my $result = "";

	my $line_count = $#$tableRef + 1;
	
	my $line_first;
	my $line_last;

	$line_first = 0;
	while($line_first < $line_count)
		{
		$line_last = $line_first;
		while(($$tableRef[$line_last] ne " ")
				and ($line_last < $line_count))
			{
			$line_last ++;
			}
		$result .= table_sprint_range($tableRef,$line_first,$line_last);
		$line_first = $line_last + 1;
		}

	return $result;
	}


sub usage
    {
    print <<EOP

    usage: mk_custom_sdk

        --sopc_directory=<x>         installed directory for nios kit
        --system_name=<x>            name of ptf file, without ".ptf" on it
        --system_directory=<x>       path to ptf file, default is .
        --sopc_lib_path=<x>          places to look for components
        --nios_cpu=<x>               name of CPU to build sdk for this time
        --debug=<1|0>                print extra junk
        --build_library=<1|0>        build libnios
        --do_generate_sdk=<1|0>      explicit control
        --do_generate_contents=<1|0> explicit control
        --output_directory=<x>       explicit control

EOP
    }

# -----------------------------
# read_ptf(sourceFile)
#
# read in the PTF, and return a hash reference.
# Uses the module for all the real work.
#
# (return only the SYSTEM section)
#

sub read_ptf
	{
	my $sourceFile = shift;
	my $ptfRef;

	$ptfRef = new_ptf_from_file($sourceFile);

	$ptfRef = get_child_by_path($ptfRef,"SYSTEM");
	bail ("PTF file broken: no SYSTEM section.") if !$ptfRef;

	return $ptfRef
	}



sub nb_min
	{
	my $a = shift;
	my $b = shift;

	return $a if $a < $b;
	return $b;
	}

sub nb_max
	{
	my $a = shift;
	my $b = shift;

	return $a if $a > $b;
	return $b;
	}

# -------------------------------------
# parseArgs
#
# Given a list of arguments, return
# a hash where the keys and values
# are taken from those arguments of
# the form "--key=value". The hyphens
# disappear from the key name.
#
# A command line switch of "--key"
# is equivalent to "--key=1".
#
# a special key named _argc contains
# a count of non-dash-dash arguments,
# and they are in the hash as {0}, {1},
# and so on.

sub parseArgs
	{
	my $arg;
	my $argVal;
	my $argc;
	my %hash;

	$argc = 0;


	while($arg = shift)
		{
		usage if $arg eq "--help";

		if($arg =~ /^--/)
			{
			if($arg =~ /^--(.*)\=(.*)$/)
				{
				$arg = $1;
				$argVal = $2;
				}
			else
				{
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

	return %hash;
	}

# -------------------------------
# getSwitch(hashRef, switchName, defaultValue [, mustBeNumber])
#
# Look at a hash as returned by parseArgs, and
# give the value of the switch, or the defaultValue
# if it was not specified in the command line.

sub getSwitch
	{
	my $hashRef = shift;
	my $switchName = shift;
	my $defaultValue = shift;
	my $mustBeNumber = shift;

	my $switchValue;

	$switchValue = $$hashRef{$switchName};
	$switchValue = $defaultValue if ($switchValue eq "");
	$switchValue *= 1 if ($mustBeNumber);

	return $switchValue;
	}



# +---------------------------------------------
# | do_sh_command(sopc_directory,command,do_as_backtick)
# |
# | Do whatever funniness is needed to execute
# | a command with paths set up and all.
# |
# | The error code is returned, 0 for success.
# |
# | Oh! Unless the third argument "do_as_backtick" is
# | passed and is nonzero. Then the stdout of the
# | operation is passed back as the result.
# |

sub do_sh_command
	{
	my ($g,$command,$do_as_backtick) = @_;
	my $sopc_directory = $$g{sopc_directory};
	my $sh;
	my $result;

   # sh will come from Quartus's Cygwin (windows) or /bin
	if ($^O =~ /win/i)
		{
      my $sh_dir = $ENV{SOPC_SHELL};
      $sh_dir = "$ENV{QUARTUS_ROOTDIR}/bin/cygwin/bin" if ($sh_dir eq "");
      $sh = $sh_dir . "/sh.exe";
		}
	else
		{
		$sh = '/bin/sh';
		}
		mcs_dprint "Running shell at: $sh\n";

	if(! -e $sh)
		{
		print_warning "mk_custom_sdk: unable to locate suitable shell (tried: $sh).";
		$result = -1;
		}
	else
		{
		my $system_command;
		my $sopc_directory_unix;
		my $nios_sh_unix;

		$sopc_directory_unix = mcs_dos2cygwin_path($sopc_directory);

		$nios_sh_unix = "$sopc_directory_unix/bin/nios_sh";

		my $sh_command = "";
		$sh_command .= "sopc_builder=$sopc_directory_unix;";
		$sh_command .= "export sopc_builder;";
		$sh_command .= ". $nios_sh_unix -s;";
		$sh_command .= $command;

		$system_command = "${sh} -c \"$sh_command\"";

mcs_dprint "mk_custom_sdk do_sh_command about to execute:";
mcs_dprint "---> $system_command";

		if($do_as_backtick)
			{
			$result = `$system_command`;
			if($do_as_backtick == 1)
				{
				$result =~ s/[\n\r]//sg;
				}
			}
		else
			{
			$result = system ($system_command);
			}

		}
	
	return $result;
	}
	

# +-----------------------------------------
# | run_make(g, $sdk_dir, $make_subdir, $makefile, $target)
# |
# | Run make in a subdirectory of the SDK. Use the given makefile
# | and ask it to build the given target.
# | 
# | $target is optional.  
# |
sub run_make
{
   my ($g, $sdk_dir, $make_subdir, $makefile, $target) = (@_);
   die "bad arguments to run_make" unless ($sdk_dir     ne "") && 
                                          ($make_subdir ne "") && 
                                          ($makefile    ne "")  ; 

   return do_sh_command
       ($g,
        "cd $sdk_dir/$make_subdir; make -f $makefile $target SHELL=/bin/sh");
}   

# +-----------------------------------------
# | build_library(g,cpu_ref)
# |
# | Do whatever weird magic it takes to
# | run the makefile down in the /lib directory
# | for this cpu
# |
sub build_library
	{
	my ($g,$cel) = @_;
	my $sdk_directory = $$cel{sdk_dir};
	my $result;


	# |
	# | Is there a gcc for us to use?
	# |

	my $gcc = "$$cel{gnu_tools_prefix}-gcc";
	$result = do_sh_command($g,"which $gcc 2> /dev/null > /dev/null");

	if(!$result)
		{
		print_command "Making Library";
                $result = run_make ($g, 
                                    $sdk_directory, 
                                    "lib",
                                    "Makefile", 
                                    "all");
	
		}
	else
		{
		print_command "(Not building library; no $gcc found.)";
		$result = 0;
		}

	return $result;
	}


sub mcs_dos2cygwin_path
	{
	my ($file) = @_;

	# backslashes to slashes

	$file =~ tr/\\/\//;

	# x: to /cygdrive/x

	if($file =~ /^([a-zA-Z]):(.*)$/)
		{
		$file = "/cygdrive/${1}${2}";
		}
	
	return $file;
	}


# +----------------------------------------
# | generate_test_code_routine(g,cpu)
# |
# | build a unique-named file which contains invocations
# | to each peripheral's test routine which is present.
# | return the name of the file.
# |

sub generate_test_code_routine
	{
	my ($g,$cel) = (@_);

	my $sdk_dir = $$cel{sdk_dir};
	my $file_name = "$sdk_dir/src/$$cel{cpu_name}_test_code.c";

# +------------------------------------------------
# | Code Template
# |
	my $test_code_template = <<EOP;
/*
 * file: --file_name--
 * This file is a machine generated test program
 * for a CPU named --cpu_name--.
 * --ptf_name--
 * Generated: --date_time--
 *
 * ex: set tabstop=4:
 */

#include "--memory_map_file_name--.h"

int main(void)
	{
	--test_routines--

	return 0;
	}

/* End of file */
EOP
# |
# | Code Template End
# +------------------------------------------------

	my $i;
	my $test_routines_calls = "/* (Test routines follow) */\n";
	my $pel_list = $$cel{peripheral_list};
	my $pel;
	my %mv;

	for($i = 0; $i <= $#$pel_list; $i++)
		{
		my $pel = $$pel_list[$i];

		if($$pel{test_routine})
			{
			$test_routines_calls .= sprintf
				(
				"\t$$pel{test_routine}(0x%x,0x%x); // %s named \"%s\"\n",
					(1 * $$pel{addr_low}),
					(1 * $$pel{addr_high}),
					$$pel{module_type},
					$$pel{module_name}
				);
			}
		}

	$mv{file_name} = $file_name;
	$mv{cpu_name} = $$cel{cpu_name};
	$mv{ptf_name} = $$g{ptf_name};
	$mv{date_time} = date_time();
	$mv{memory_map_file_name} = $$cel{memory_map_file_name};
	$mv{test_routines} = $test_routines_calls;

	my $test_code_file = populate_template($test_code_template,\%mv);

	maybe_write_file($file_name,$test_code_file);

	return $file_name;
	}



# +----------------------------------------
# | build_peripheral_contents(g,cpu_ref)
# |
# | For an onchip memory (and perhaps one day
# | other peripherals) build a MIF file by
# | request.
# |
sub build_peripheral_contents
	{
	my ($g,$cel) = @_;
	my $sdk_dir = $$cel{sdk_dir};
	my $result;


	# |
	# | Some contents types cannot be built for non-nios systems
	# |
    my $is_nios = ($$cel{cpu_architecture} =~ /^nios_/);
    my $is_nios2 = ($$cel{cpu_architecture} =~ /^nios2$/);

    my $nios_build = $is_nios2 ? "nios2-build" : "nios-build";

    my $vec_low;
    my $vec_high;

    my $pel;

	$vec_low = $$cel{constant_hash}{nasys_vector_table};
	$vec_high = $$cel{constant_hash}{nasys_vector_table_end};

	foreach $pel (sort {$$a{addr_low} <=> $$b{addr_low}} @{$$cel{peripheral_list}})
		{
		my $cr = get_child_by_path($$pel{module_ref},"WIZARD_SCRIPT_ARGUMENTS/CONTENTS");

		next if !$cr;
	
		my $cr_result_file = "$$pel{module_name}_contents.srec";
		my $cr_kind = get_data_by_path($cr,"Kind");
		my $cr_source_directory = get_data_by_path($cr,"Source_Directory");

		my $a_low;
		my $a_high;

		my $a_low = $$pel{addr_low};
		my $a_high = $a_low + $$pel{addr_span};

		if($$cel{has_nios_vector_table}
				and ($a_low >= $vec_low)
				and ($a_low < $vec_high))
			{
			print_command "(Clamping base address $a_low up to $vec_high)";
			$a_low = $vec_high;
			}

		my $command = "";

		$cr_source_directory = $$g{system_directory} if !$cr_source_directory;

		print_command "Building $cr_result_file using \"$cr_kind\"";

        # |
        # | dvb 2003 -- preflight check. can only do any sw building
        # |             if do_sdk_build
        # |

        if(($cr_kind eq "germs")
                or ($cr_kind eq "build"))
            {
            if(!$$cel{do_build_sdk})
                {
                # !!!(we need a centralized die-method here)

                die "Cannot build contents for non-GNU tool chain";
                }
            }

		if($cr_kind eq "germs" and $is_nios)
			{
			$command .= "$nios_build --sdk_directory=$sdk_dir -np -s"
					. " -o $cr_result_file"
					. " -b ${a_low}-${a_high}"
					. " $sdk_dir/lib/nios_germs_monitor.s";
			}
		elsif($cr_kind eq "germs" and $is_nios2)
			{
            my $germs_dir = "$sdk_dir/src/nios2_germs_monitor";
            my $germs_srec = "$germs_dir/nios2_germs_monitor.srec";
            my $germs_base_hex = sprintf("0x%x",${a_low});

            $command .= "make clean all"
                    . " --directory=$sdk_dir/src/nios2_germs_monitor"
                    . " GERMS_BASE=$germs_base_hex"
                    . " GERMS_SREC=../../../$cr_result_file";
			}
		elsif($cr_kind eq "test_code")
			{
			# |
			# | New option in sopcb2.6 -- generate a "main" routine
			# | that calls each peripheral's test routine
			# |

			my $test_code_file_name = $$cel{test_code_file_name};

			if($test_code_file_name && $is_nios)
				{
				$command .= "$nios_build --sdk_directory=$sdk_dir -np -s -cc -O0"
					. " -o $cr_result_file"
					. " -b ${a_low}-${a_high}"
					. " -pp=tcp"
					. " $test_code_file_name";
				}
			else
				{
				print_warning "Could not build test code for $$pel{module_name}";
				}
			}
		elsif($cr_kind eq "blank")
			{
			#
			# Limit "blank" files to 64k
			#

			my $biggest = 65535;
			my $a_high_clipped = $a_high;

			if($a_high_clipped - $a_low > $biggest)
				{
				$a_high_clipped = $a_low + $biggest;
				}


			$command .= "nios-convert --outfile=$cr_result_file --address_low=$a_low --address_high=$a_high_clipped";
			}
		elsif($cr_kind eq "build")
			{
			# |
			# | use nios-build to collect all the files
			# |

			my $cr_build_info = get_data_by_path($cr,"Build_Info");
			my @file_list = split(/[,;+]/,$cr_build_info);
			my $file;

			if($#file_list == 0 && $file_list[0] =~ /\.(mif|srec)$/)
				{
				# |
				# | Just one file, and its a mif file?
				# | simply nios-convert it.
				# |
				$command .= "nios-convert --outfile=$cr_result_file --infile="
						. $file_list[0];
				}
			else
				{
				$command .= "$nios_build --sdk_directory=$sdk_dir -s"
						. " -o $cr_result_file"
						. " -b $a_low";

				foreach $file (sort(@file_list))
					{
					$file = mcs_dos2cygwin_path($file);
					$command .= " $file";
					}
				}
			}
		elsif($cr_kind eq "command")
			{
			my $cr_command_info = get_data_by_path($cr,"Command_Info");

			# |
			# | Swap in result file instead of %1
			# | And SDK dir for %2
			# |

			$cr_command_info =~ s/%1/$cr_source_directory\/$cr_result_file/gs;
			$cr_command_info =~ s/%2/$sdk_dir/gs;

			$command .= $cr_command_info;
			}
		elsif($cr_kind eq "textfile")
			{
			my $cr_textfile_info = get_data_by_path($cr,"Textfile_Info");
                        my $file_type = "txt"; 
                        $file_type = "srec" 
                            if ($cr_textfile_info =~ /\.srec$/i);
			$command .= "nios-convert --outfile=$cr_result_file --iformat=$file_type --infile=$cr_textfile_info" if ($cr_textfile_info);
			}
		else
			{
			print_warning "Unknown peripheral contents kind \"$cr_kind\" on $$cel{cpu_architecture}";
			}

		if($command)
			{
                        $command = "cd $cr_source_directory ; $command";
			print_command $command;

			$result = do_sh_command($g,$command);
			print_warning "$result $command" if $result;

			# |
			# | Early bailout case!
			# |

			return $result if $result;
			}
		}

	return $result;
	}


# +-------------------------------------------------
# | structure of g->class_ptfs{}
# |
# | Each member of the has is indexed by a module class (such as "altera_avalon_uart")
# | and contains a ptf_ref. Each member of g->class_dirs contains the
# | full directory path to the folder containing the class.ptf.
# |

# +-------------------------------------------------
# | structure of g->cpu_list[]
# |
# | Each element of g->cpu_list[] is
# | a hash reference. The fields of the
# | the hash reference are:
# |
# |       cpu_ref         reference within g->ptf_ref
# |       cpu_name        name of cpu
# |       module_type     the class of the cpu component
# |       toolchain       kind of toolchain for the sdk, gnu or ads
# |       cpu_data_width  16 or 32 for nios 16 or nios 32
# |       peripheral_list array of hashrefs, one for each peripheral,
# |                       with still more goop in each one.
# |       constant_list   a few more equivalences, with a structure for each
# |       constant_hash   the base addresses out of the constant_list, keyed by name
# |       pel_constant_list  any special #defines that go with each component
# |       pel_constant_nameshash  just a "1" for each, by name, to avoid duplicates
# |       pel_constant_hash values for constants
# |       sdk_dir_name    name of sdk directory, like "{cpu_name}_ads_sdk"
# |       sdk_dir         directory to build CPU in -- g{system_directory}/{sdk_dir_name}
# |       file_list       array of union of the files for each
# |                       peripheral
# |                       its concatted with other data like so:
# |                      <srcdir>||inc/fish.h
# |                       where toolchain is "ads" or "gnu" or nothing
# |                       (nothing means both), srcdir is where in the
# |                       component directory it comes from.
# |       gnu_tools_prefix  examples: nios-elf, arm-elf
# |       gnu_as_lcc        line comment character. ; if blank. it'll be @ for ARM.
# |
# | next few are new as of sopcb 2.6, and come from
# | the cpu's SDK_GENERATION/CPU section
# |       cc, as, ld, ar  names of the gnu-compatible software build tools



# +----------------------------------------------------
# | structure of a constant_list[]
# |
# | Each element is a hash with the following fields:
# |
# | name     symbol name to #define or GEQU
# | type     type to cast to, if any
# | value    a number or string in the appropriate base-notation
# | irq      interrupt, if any
# | span     span, if any
# | end      end, if any
# |



# +-------------------------------------------------
# | fill_out_cpu_misc(globals *g, cpu_list_element *cel)
# |
# | fill in the cc, as, ld fields (either by sopcb2.6
# | means or by nios-assumptions)
# | also the sdk_dir, for the resulting location
# |

sub fill_out_cpu_misc
	{
	my ($g,$cel) = (@_);

    my $cpu_name = $$cel{cpu_name};

    my $cpu_class_ptf = get_class_ptf($g,$$cel{module_type}, 'verbose');
 
    if(!$cpu_class_ptf)
        {
        print_warning "did not find class.ptf "
                . "for $$cel{module_type} \"$cpu_name\"";
        }

    my $sdk_gen_ptf = get_child_by_path($cpu_class_ptf,
            "CLASS $$cel{module_type}/SDK_GENERATION");

	my $sg_ptf = get_child_by_path($sdk_gen_ptf,"CPU");


	if($sg_ptf)
		{
		$$cel{gnu_tools_prefix} = get_data_by_path($sg_ptf,"gnu_tools_prefix");
		$$cel{gnu_as_lcc} = get_data_by_path($sg_ptf,"gnu_as_line_comment_character");
		$$cel{program_prefix} = get_data_by_path($sg_ptf,"program_prefix_file");
		$$cel{test_code_prefix} = get_data_by_path($sg_ptf,"test_code_prefix_file");

### !!! this is ok, no gnu_tools_prefix means no sdk. ok! dvb 2003
###
###		if($$cel{gnu_tools_prefix} eq "")
###			{
###			bail "Missing SDK_GENERATION/CPU/gnu_tools_prefix assignment for $$cel{module_type}/class.ptf";
###			}

        $$cel{do_build_sdk} = $$cel{gnu_tools_prefix} ? 1 : 0;

		my $toolchain_infix = ($$cel{toolchain} ne "gnu") ? $$cel{toolchain} . "_" : "";
		$$cel{sdk_dir_name} = $cpu_name . "_"
				. $toolchain_infix
				. get_data_by_path($sg_ptf,"sdk_directory_suffix");
		$$cel{sdk_dir} = $$g{output_directory} . "/" . $$cel{sdk_dir_name};

		} # (found sopcb2.6-ish SDK_GENERATION/CPU section)
	else
		{
		$$cel{gnu_tools_prefix} = "nios-elf";
		$$cel{program_prefix} = "nios_jumptostart.s.o";
		$$cel{test_code_prefix} = "nios_jumptostart.s.o";

		$$cel{sdk_dir_name} = $cpu_name . "_sdk";
		$$cel{sdk_dir} = $$g{output_directory} . "/" . $$cel{sdk_dir_name};
		}

	$$cel{memory_map_file_name} = "excalibur";   # fixed, for now
	}

# +-------------------------------------------------
# | find_cpus(globals_ref *g)
# |
# | walk through g->ptf_ref and build
# | an array of pointers to module_refs,
# | for each cpu. That is, g->cpu_list[],
# | where each entry is a hash ref
# | as described above.


sub find_cpus
	{
	my ($g) = @_;

	my $child_count;
	my $child_ref;
	my $cpu_name;
	my $module_type;
	my $is_cpu;
	my $i;
	my $cpu_list_ref = []; # we'll assign this into g at the end.

	$child_count = get_child_count($$g{ptf_ref},"MODULE");

	for($i = 0; $i < $child_count; $i++)
		{
		$child_ref = get_child($$g{ptf_ref},$i,"MODULE");
		$is_cpu = get_number_by_path($child_ref,"SYSTEM_BUILDER_INFO/Is_CPU");
		next if(!$is_cpu);

		$module_type = get_data_by_path($child_ref,"class");
		my $cpr = get_class_ptf($g,$module_type,'verbose');
		my $toolchain = get_data_by_path
				(
				$cpr,
				"CLASS $module_type/SDK_GENERATION/CPU/toolchain"
				);

		my $cpu_architecture = get_data_by_path
				(
				$child_ref,
				"WIZARD_SCRIPT_ARGUMENTS/CPU_Architecture"
				);

		my $is_enabled = get_number_by_path($child_ref,"SYSTEM_BUILDER_INFO/Is_Enabled",1);
		next if(!$is_enabled);

		$cpu_name = get_data($child_ref);
		$module_type = get_data_by_path($child_ref,"class");

		my $cpu_data_width = 32;
		if($cpu_architecture eq "nios_16")
			{
			$cpu_data_width = 16;
			}

		my $do_inc = 1;
		my $do_rest_of_sdk = 1;

		# |
		# | Now, create a separate toolchain for
		# | each toolchain specified.
		# | A missing toolchain is implicitly
		# | gnu.
		# |

		my @tc_list = (sort(split(/,/,$toolchain)));

		@tc_list = ("gnu") if ($#tc_list < 0);

		my $tc;

		foreach $tc (@tc_list)
			{
			my $cel =
				{
				cpu_ref => $child_ref,
				cpu_name => $cpu_name,
				cpu_architecture => $cpu_architecture,
				peripheral_list => [],
				cpu_data_width => $cpu_data_width,

				module_type => $module_type,

				do_inc => $do_inc,
				do_rest_of_sdk => $do_rest_of_sdk,
				toolchain => $tc,
				};

			push(@$cpu_list_ref,$cel);
			}
		}
	
	$$g{cpu_list} = $cpu_list_ref;
	}

# +--------------------------------
# | find_module(g,cpu_ref,module_name)
# |
# | return the reference out of the cpu's
# | peripheral list
# |

sub find_module
	{
	my ($g,$cel,$module_name) = @_;
	my $pel;
	my $slave_name;

	if($module_name =~ /^(.*)\/(.*)$/)
		{
		$module_name = $1;
		$slave_name = $2;
		}

	foreach $pel (sort {$$a{addr_low} <=> $$b{addr_low}} @{$$cel{peripheral_list}})
		{
		next if ($module_name ne $$pel{module_name});
		next if ($slave_name and $slave_name ne $$pel{slave_name});

		return $pel;
		}

	return 0;
	}

# +----------------------------------------------
# | get_module_address(g,cpu_ref,module_name)
# |
# | Get the numerical address of the requested module.
# | module_name might be "module/slave" name.
# |

sub get_module_address
	{
	my ($g,$cel,$module_name) = @_;
	my $pel;
	my $slave_name;

	$pel = find_module($g,$cel,$module_name);
	return $$pel{addr_low} if $pel;

	return "";
	}

# +----------------------------------------
# | get_module_address_range(g,cpu_ref,module_name,vec_low,vec_high)
# |
# | return the base and top of the module, skipping
# | around the vec_low->vec_high span
# |

sub get_module_address_range
	{
	my ($g,$cel,$module_name,$vec_low,$vec_high) = @_;
	my $pel;
	my $slave_name;
	my $m_low;
	my $m_high;

	$pel = find_module($g,$cel,$module_name);
	if($pel)
		{
		$m_low = $$pel{addr_low};
		$m_high = $m_low + $$pel{addr_span};

        if(defined($vec_low) && defined($vec_high)) 
            {
    		if($vec_low - $m_low > $m_high - $vec_high)
    			{
    			$m_high = nb_min($m_high,$vec_low);
    			}
    		else
    			{
    			$m_low = nb_max($m_low,$vec_high);
    			}
            }

		return ($m_low,$m_high);
		}
	
	return "";
	}

# +----------------------------------------
# | whex(cpu_ref,value)
# |
# | return a hex-formatted number 0x0000 or 0x00000000
# | depending on cpu width
# |

sub whex
	{
	my ($cel,$x) = @_;
	my $addr_width = $$cel{cpu_data_width} == 16 ? 4 : 8;

	return sprintf("0x%0${addr_width}x",$x);
	}



# +----------------------------------------------
# | fill_in_cpu_constants(g,cpu_ref)
# |
# | Figure out the nasys_printf_uart and such
# | things, put into the cpu's constant_list
# |

sub fill_in_cpu_constants
	{
	my ($g,$cpu_list_element) = @_;
	my $cel = $cpu_list_element;
	my $wsa = get_child_by_path($$cel{cpu_ref},"WIZARD_SCRIPT_ARGUMENTS");

	my @cc; #constants
	my %ch; #constants

	my $x;
	my $vec_low;
	my $vec_high;

	# |
	# | Create a constant list for each kind of peripheral
	# | so we can sort-of find peripherals without knowing
	# | too much about 'em
	# |

	my $pel;
	my %info_by_short_type;

	# |
	# | but first, the very special na_null
	# |

	push(@cc,
		{
		name => "na_null",
		value => 0
		});


    # |
    # | and, what is the chip we're on?
    # |

    my $device_family = get_data_by_path
            (
            $$g{ptf_ref},
            "WIZARD_SCRIPT_ARGUMENTS/device_family"
            );

    push(@cc,
        {
        name => "nasys_device_family",
        value => "\"$device_family\"",
        no_asm => 1
        });
	$ch{nasys_device_family} = "\"$device_family\"";

    # |
    # +---
    # |

	foreach $pel (sort {$$a{addr_low} <=> $$b{addr_low}} 
                      get_peripherals_and_sw_components ($cel))
		{
		my $short_type = $$pel{short_type};

		next if !$short_type;

		$info_by_short_type{$short_type}{count} ++;
		push ( @{$info_by_short_type{$short_type}{list}},$pel);
		}
	
	my $key;
	foreach $key (sort (keys (%info_by_short_type)))
		{
		my $x = $info_by_short_type{$key};
		my $i;

		push(@cc,
			{
			name => "nasys_" . $key . "_count",
			value => $$x{count}
			});

		for($i = 0; $i < $$x{count} ; $i++)
			{
			$pel = $$x{list}[$i];
			push(@cc,
				{
				name => "nasys_${key}_${i}",
				value => $$pel{symbol_name},
				irq => $$pel{irq_number} # might be "" for no irq
				});
			}
		}



	$$cel{has_nios_vector_table} = 0;

	# |
	# | vector_table, for nios 16 or nios 32
	# |
	# | (and save the vec_low & vec_high, as it affects
	# | the data and program memories)
	# |

    if($$cel{cpu_architecture} =~ /^nios_/)
        {
	    $$cel{has_nios_vector_table} = 1;
        $x = get_data_by_path($wsa,"vecbase_slave");
        $x = get_module_address($g,$cel,$x);
        $x += get_number_by_path($wsa,"vecbase_offset");
        $vec_low = $x;
        $vec_high = $x + 64 * $$cel{cpu_data_width} / 8;
        $ch{nasys_vector_table} = "$vec_low";
        $ch{nasys_vector_table_end} = "$vec_high";
        push(@cc,
                {
                name => "nasys_vector_table",
                type => "int",
                value => whex($cel,$vec_low),
                span => whex($cel,$vec_high - $vec_low),
                end => whex($cel,$vec_high)
                });
        }

    # |
    # | exception address for nios2 -- we avoid it
    # | just like the exception vector
    # |
    if($$cel{cpu_architecture} =~ /^nios2$/)
        {
	    $$cel{has_nios_vector_table} = 1;
        $x = get_data_by_path($wsa,"exc_slave");
        $x = get_module_address($g,$cel,$x);
        $x += get_number_by_path($wsa,"exc_offset");
        $vec_low = $x;
        $vec_high = $x + 128; # arbitrary amount of space reserved here...
        $ch{nasys_vector_table} = "$vec_low";
        $ch{nasys_vector_table_end} = "$vec_high";

        # |
        # | we keep the "vector table" area free of
        # | code or data from the above constants.
        # |
        # | we wont emit any nasys_vector_table constants
        # | into the header file, though.
        # |
        }

	# |
	# | reset_address
	# |

	$x = get_data_by_path($wsa,"reset_slave"); # module/slave name
    $ch{nasys_reset_device} = $x;
    $ch{nasys_reset_device} =~ s/\/.*$//;

	$x = get_module_address($g,$cel,$x);
	$x += get_number_by_path($wsa,"reset_offset");
    $x = whex($cel,$x);

	push(@cc,
			{
			name => "nasys_reset_address",
			type => "void",
			value => $x
			});

    # | For the OCI, nios-run needs to know the reset address
    # | put it in the makefile for easy access - JMB Jan 2003
    $ch{nasys_reset_address} = $x;

    # |
    # | exception_address
    # |

    $x = get_data_by_path($wsa,"exc_slave"); # module/slave name
    if ($x ne "") {
        $ch{nasys_exception_device} = $x;
        $ch{nasys_exception_device} =~ s/\/.*$//;

        $x = get_module_address($g,$cel,$x);
        $x += get_number_by_path($wsa,"exc_offset");
        $x = whex($cel,$x);

        push(@cc,
                {
                name => "nasys_exception_address",
                type => "void",
                value => $x
                });
        $ch{nasys_exception_address} = $x;
    }

    # |
    # | break_address
    # |

    $x = get_data_by_path($wsa,"break_slave"); # module/slave name
    if ($x ne "") {
        $ch{nasys_break_device} = $x;
        $ch{nasys_break_device} =~ s/\/.*$//;

        $x = get_module_address($g,$cel,$x);
        $x += get_number_by_path($wsa,"break_offset");
        $x = whex($cel,$x);

        push(@cc,
                {
                name => "nasys_break_address",
                type => "void",
                value => $x
                });
        $ch{nasys_break_address} = $x;
    }

    # |
    # | fast_tlb_miss_exc
    # |

    $x = get_data_by_path($wsa,"fast_tlb_miss_exc_slave"); # module/slave name
    if ($x ne "") {
        $ch{nasys_fast_tlb_miss_exc_device} = $x;
        $ch{nasys_fast_tlb_miss_exc_device} =~ s/\/.*$//;

        $x = get_module_address($g,$cel,$x);
        $x += get_number_by_path($wsa,"fast_tlb_miss_exc_offset");
        $x = whex($cel,$x);

        push(@cc,
                {
                name => "nasys_fast_tlb_miss_exc_address",
                type => "void",
                value => $x
                });
        $ch{nasys_fast_tlb_miss_exc_address} = $x;
    }

	# clock_freq
	$x = get_number_by_path($$g{ptf_ref},"WIZARD_SCRIPT_ARGUMENTS/clock_freq");
	$x = 25000012 if !$x; # a reasonable value that looks different than the expected one
	push(@cc,
			{
			name => "nasys_clock_freq",
			value => $x
			});
	push(@cc,
			{
			name => "nasys_clock_freq_1000",
			value => int($x / 1000)
			});


	# clock_freq_1000

	# debug core

	$x = get_number_by_path($wsa,"include_debug");

	push(@cc,
				{
				name => "nasys_debug_core",
				value => $x
				});

    # oci core
    #
    # find the darned oci core

        {
        my $pel = find_module($g,$cel,"$$cel{cpu_name}/oci_core");
        if($pel)
            {
            # since there is such a beastie, jam in a special nasys for it
            
			push(@cc,
					{
					name => "nasys_oci_core",
					value => whex($cel,$$pel{addr_low}),
					});
            $ch{nasys_oci_core} = whex($cel,$$pel{addr_low});
            }
        else
            {
            # |
            # | if not: jam in something informative
            # |
            # | Those who think far ahead will have already wondered,
            # | hey, what if my code runs on a system without an oci core.
            # | And perhaps found the answer, here.
            # |
            $ch{nasys_oci_core} = "off";
            }
        }


	# printf uart

	$x = get_data_by_path($wsa,"maincomm_slave");

	# |
	# | !!! (probably should keep slave part here...)
	# |
#	$x = $1 if $x =~ /^(.*)\/(.*)$/;  so we will, through this will likely break the ARM SDK

	if($x and ($x ne "(none)"))	# (none) means user doesn't like printfing
		{
		my $pel = find_module($g,$cel,$x);
		if($pel)
			{
			my $irq_sym = $$pel{irq_number} ne "" ? "$$pel{symbol_name}_irq" : "";
			push(@cc,
					{
					name => "nasys_printf_uart",
					value => $$pel{symbol_name},
					irq => $irq_sym
					});
			$ch{nasys_printf_uart} = $$pel{symbol_name};

			$ch{nasys_printf_uart_address} = $$pel{addr_low};
			$ch{host_comm} = $$pel{symbol_name};

			# |
			# | Find the txchar, recvchar, and initialize routines
			# | for the printf uart
			# | and for the debug uart
			# |

			sub _oneroutine
				{
				my ($cc_ref,$pel,$pel_index,$routine_name) = (@_);

				my $v = $$pel{$pel_index};
				if($v)
					{
					push(@$cc_ref,
						{
						name => $routine_name,
						value => $v,
						no_asm => 1,
						});
					}
				}

			_oneroutine(\@cc,$pel,"printf_txchar_routine","nm_printf_txchar");
			_oneroutine(\@cc,$pel,"printf_rxchar_routine","nm_printf_rxchar");
			_oneroutine(\@cc,$pel,"printf_initialize_routine","nm_printf_initialize");

			_oneroutine(\@cc,$pel,"debug_txchar_routine","nm_debug_txchar");
			_oneroutine(\@cc,$pel,"debug_rxchar_routine","nm_debug_rxchar");
			_oneroutine(\@cc,$pel,"debug_initialize_routine","nm_debug_initialize");
			}
		else
			{
			print_warning "ptf inconsistency: maincomm_slave -> nonexistent \"$x\".";
			}
		}

	# debug uart

	$x = get_data_by_path($wsa,"debugcomm_slave");
	$x = $1 if $x =~ /^(.*)\/(.*)$/;

	if($x and ($x ne "(none)"))	# (none) means user doesn't like printfing
		{
		my $pel = find_module($g,$cel,$x);
		if($pel)
			{
			my $irq_sym = $$pel{irq_number} ne "" ? "$$pel{symbol_name}_irq" : "";

			push(@cc,
					{
					name => "nasys_debug_uart",
					value => $$pel{symbol_name},
					irq => $irq_sym
					});
			$ch{nasys_debug_uart} = $$pel{symbol_name};
			}
		else
			{
			print_warning "ptf inconsistency: debugcomm_slave -> nonexistent \"$x\".";
			}
		}

	# main flash

	my $pel; # periphera list element
	my $flash_pel;
	my $i;

	my $m_low;
	my $m_high;


	foreach $pel (sort {$$a{addr_low} <=> $$b{addr_low}} @{$$cel{peripheral_list}})
		{
		# |
		# | !!! This is a BAD way to see if a module is a flash!
		# | an "Is_Flash" field would be nicer
		# |

		if($$pel{module_type} =~ /flash/)
			{
			$flash_pel = $pel;
			last;
			}
		}

	if($flash_pel)
		{
        $m_low = $$flash_pel{addr_low};
        $m_high = $m_low + $$flash_pel{addr_span};

	    $ch{nasys_main_flash} = $m_low;
	    $ch{nasys_main_flash_end} = $m_high;

		push(@cc,
				{
				name => "nasys_main_flash",

				# value => $$flash_pel{symbol_name},
				# span => $$flash_pel{symbol_name} . "_size",
				# end => $$flash_pel{symbol_name} . "_end"

                # values instead of names...

				value => whex($cel,$m_low),
				span => whex($cel,$m_high - $m_low),
				end => whex($cel,$m_high),
                type => "void"

				});
		}
	
	# |
	# | program_mem
	# |

	$x = get_data_by_path($wsa,"mainmem_slave");
    $ch{nasys_program_device} = $x;
    $ch{nasys_program_device} =~ s/\/.*$//;

	($m_low,$m_high) = get_module_address_range($g,$cel,$x,$vec_low,$vec_high);

	$ch{nasys_program_mem} = $m_low;
	$ch{nasys_program_mem_end} = $m_high;
	push(@cc,
			{
			name => "nasys_program_mem",
			type => "void",
			value => whex($cel,$m_low),
			span => whex($cel,$m_high - $m_low),
			end => whex($cel,$m_high)
			});

	# data_mem

	$x = get_data_by_path($wsa,"datamem_slave");
    $ch{nasys_data_device} = $x;
    $ch{nasys_data_device} =~ s/\/.*$//;
	($m_low,$m_high) = get_module_address_range($g,$cel,$x,$vec_low,$vec_high);

	my $stack_top = get_number_by_path($wsa,"stack_top");
	$stack_top = $m_high if(!$stack_top);

	# A Courtesy Hack in case there's no ram assigned: just pretend
	# we have 127k. haha.

	 if($stack_top == 0)
	 	{
		print_warning "stacktop was at zero... bumping it to 127k.";
		$stack_top = 127 * 1024;
		}


	$ch{nasys_data_mem} = $m_low;
	$ch{nasys_data_mem_end} = $m_high;

	push(@cc,
			{
			name => "nasys_data_mem",
			type => "void",
			value => whex($cel,$m_low),
			span => whex($cel,$m_high - $m_low),
			end => whex($cel,$m_high)
			});

	# |
	# | stack_top
	# |

	$ch{nasys_stack_top} = $stack_top;
	push(@cc,
			{
			name => "nasys_stack_top",
			type => "void",
			value => whex($cel,$stack_top)
			});

	$$cel{constant_list} = \@cc;
	$$cel{constant_hash} = \%ch;
	}

# +----------------------------------------------
# | get_all_masters(globals *g,ptf_ref *slave_ref,master_list_ref *master_list,depth)
# |
# | Ascend up the ptf, via the "MASTERED_BY" sections of
# | the slave we're looking at, building up a list of
# | master names.
# | To ascend bridges, we recurse up, passing a reference to our list so far.
# |
# | Infinite loops are prevented by setting a maximum recursion
# | depth to this search.
# |
# | infinite loops can occur by, for example, cross linking
# | two DMA peripherals.
# |

sub get_all_masters
	{
	my ($g,$slave_ref,$master_list_ref,$r_depth) = @_;

	my $mastered_by_count;
	my $mastered_by_ref;
	my $mastered_by_module_name;
	my $mastered_by_master_name;
	my $master_module_ref;
	my $i;

	# |
	# | Make sure master_list_ref is a reference to some
	# | array...

	$master_list_ref = [] if(!$master_list_ref);

	# |
	# | Return unchanged if we've hit or depth limit
	# |

	return $master_list_ref if $r_depth > 3;

	# |
	# | Descend the slave PTF section to the SYSTEM_BUILDER_INFO where
	# | we have the MASTERED_BY sections
	# |

	$slave_ref = get_child_by_path($slave_ref,"SYSTEM_BUILDER_INFO");

	$mastered_by_count = get_child_count($slave_ref,"MASTERED_BY");
	for($i = 0; $i < $mastered_by_count; $i++)
		{
		$mastered_by_ref = get_child($slave_ref,$i,"MASTERED_BY");
		($mastered_by_module_name,$mastered_by_master_name) = 
			split("/",get_data($mastered_by_ref));

		$master_module_ref = get_child_by_path($$g{ptf_ref},"MODULE $mastered_by_module_name");

		# |
		# | Is this master a CPU? If so, push it onto the resulting list
		# | of cpu masters
		# |

		if(get_number_by_path($master_module_ref,"SYSTEM_BUILDER_INFO/Is_CPU"))
			{
			push(@$master_list_ref,$mastered_by_module_name);
			}

		# |
		# | Is this master a bridge? If so, ascend and let any 
		# | cpu masters upstream land up on this list too
		# |

		if(get_number_by_path($master_module_ref,"SYSTEM_BUILDER_INFO/Is_Enabled",1))
			{
			my $j;
			my $slave_count;
			my $slave_ref;

			# |
			# | For each slave port on the bridge that masters
			# | the slave of interest... find out who masters *that*.
			# |

			$slave_count = get_child_count($master_module_ref,"SLAVE");
			for($j = 0; $j < $slave_count; $j++)
				{
				$slave_ref = get_child($master_module_ref,$j,"SLAVE");
				get_all_masters($g,$slave_ref,$master_list_ref,$r_depth + 1);
				}
			}
		}
	
	return $master_list_ref;
	}

# +----------------------------------------------
# |sub get_slave_address_span(int cpu_width,$slave_ref)
# |

sub get_slave_address_span
	{
	my ($cpu_width,$slave_ref) = @_;
	my $sbi_ref = get_child_by_path($slave_ref,"SYSTEM_BUILDER_INFO");
	my $address_alignment = get_data_by_path($sbi_ref,"Address_Alignment");
	my $span;

	# |
	# | If the number is just there, use it.
	# |

	$span = get_number_by_path($sbi_ref,"Address_Span");
	return $span if $span;

	# |
	# | else, think harder.
	# |

	my $word_size_per_address;
	my $bytes_per_address;
	my $address_exponent;

	if($address_alignment eq "dynamic")
		{
		$word_size_per_address = get_number_by_path($sbi_ref,"Data_Width");
		}
	elsif($address_alignment eq "native")
		{
		$word_size_per_address = $cpu_width;
		}
	elsif($address_alignment eq "word")
		{
		$word_size_per_address = 32;
		}
	elsif($address_alignment eq "halfword")
		{
		$word_size_per_address = 16;
		}
	elsif($address_alignment eq "byte")
		{
		$word_size_per_address = 8;
		}
	else
		{
		# default to width of master (Nios) CPU
		$word_size_per_address = $cpu_width;
		}
	
	$bytes_per_address = int($word_size_per_address / 8);
	$address_exponent = get_number_by_path($sbi_ref,"Address_Width");
	$span = (1 << $address_exponent) * $bytes_per_address;

	return $span;
	}


# +----------------------------------------------
# | structure of a cpu_ref->peripheral_list[]
# |
# | Each entry in cpu_list includes a peripheral_list.
# | This list contains entries for each peripheral
# | which is mastered by that cpu.
# |
# | (Actually, there's an entry for each module
# | slave mastered by that cpu.)
# |
# | Each entry in peripheral_list is a hashref
# | with the following entries
# |
# |        module_ref    reference within g->ptf_ref
# |        module_name   name of the module, "uart1"
# |        module_type   name of class of this module
# |        slave_ref     reference to the particular slave
# |        slave_name    name of the slave, "s1"
# |        symbol_name   name in address map, "na_uart1", or perhaps nasys_clock_freq_1000
# |        component_dir location of this component's class.ptf & friends (including sdk)
# |        struct_type   name of struct * for the address range, or "" for void *, like "np_uart *"
# |        short_type    short name of struct, like "uart"
# |        addr_low      address
# |        addr_span     in bytes
# |        irq_number    integer (missing or 0 for no irq)
# |        is_swlib      set if this "peripheral" (so to speak) is just a library
# |        constant_list only name and value are there, and they become #define's in nios.h
# |                      oh, yeah, there's also a "comment"
# |                      oh, but these all migrated into the CPU's pel_constant_list, so
# |                      they can all go first, before the structure files and stuff.
# |
# |        sdk_dir       just $component_dir/sdk or $component_dir/custom_sdk_pieces
# |        sdk_dir       a comma separated list of directories where sw
# |                      can be found for this peripheral, filtered by
# |                      the appropriate CPU type
# |        struct_file_h path to struct file which gets glommed onto nios.h,
# |                       relative to $component_sdk
# |        struct_file_s path to struct file which gets glommed onto nios.s.
# |        file_list     array of files to copy into sdk, relative to $component_sdk,
# |                       for example, "src/web_server_example/web_pages/index.html".
# |
# |        ci_is_ci      set to 1 if this "peripheral" is really a custom instruction.
# |        ci_macro_name For a custom instruction, what's it called
# |
# |  Nios I:
# |        ci_opcode     "USR0" through "USR5"
# |        ci_ifmt       "RR" or "Rw"
# |        ci_operands   1 or 2
# |        ci_prefix     0 or 1
# |        
# |  Nios II:
# |        ci_base_addr  0x00 to 0xff
# |        


# +-------------------------------------------------
# | readdir_deep(directory_name,visible_path_name)
# |
# | return an array reference to the recursive descent of the
# | specified directory. The visible_path_name ensures that
# | subdirectory names are preprended to the file names as we go.
# |

sub readdir_deep
	{
	my ($directory_name,$visible_path_name) = @_;
	my @dir_contents;
	my $file;
	my @file_list;

	if(opendir(DIR,$directory_name))
		{
		@dir_contents = readdir(DIR);
		closedir(DIR);

		foreach $file (sort(@dir_contents))
			{
			# |
			# | Skip . and .. and blah_blah_struct.[sh]
			# |

			next if
					(
					$file eq "." 
					or $file eq ".." 
					or $file eq "vssver.scc"
					or $file =~ /struct\.[sh]$/
					);

			# |
			# | a dir? descend
			# |

			if(-d "$directory_name/$file")
				{
				my $nvp;

				$nvp = $visible_path_name;
				if($nvp ne ""
					and !($nvp =~ /[|\/]$/))
					{
					$nvp .= "/";
					}
				$nvp .= $file;

				my $dir_file_list = readdir_deep("$directory_name/$file",$nvp);

				push(@file_list,@$dir_file_list);
				}
			else
				{
				my $x;

				if($visible_path_name)
					{
					$x = "$visible_path_name/$file";
					}
				else
					{
					$x = $file;
					}
				push(@file_list,$x);
				}
			}
		}

	return \@file_list;
	}

# +-------------------------------------------------
# | add_peripheral_file_list(globals_ref *g,peripheral_list_element *)
# |
# | Add the appropriate entries to the file_list array.

sub add_peripheral_file_list
	{
	my ($g,$pel) = @_;

	my $f;
	my $file_list_ref;
	my @file_list;

	# |
	# | for now, we shall enumerate all the files in
	# | the component's SDK. One could imagine
	# | looking at a PTF file and fetching either
	# | a list of files from there, or even executing
	# | an SDK generation script.
	# |

    # |
    # | if the file list has not already been explicitly built
    # | up in find_sdk_supplies from an SDK_FILES/sdk_files_list assignment,
    # | then get all the files from all the dirs, here
    # |

    my $pel_file_list_ref = $$pel{file_list};
    if($#$pel_file_list_ref < 0)
        {
        mcs_dprint "------";
        mcs_dprint "file_list is $$pel{sdk_dir}";

        foreach $f (split(/,/,$$pel{sdk_dir}))
            {
            if($f ne "")
                {
                mcs_dprint "readdir_deep-ing of $f now.";
                $file_list_ref = readdir_deep($f,"$f||");
                push(@file_list,@$file_list_ref);
                }
            }

        $$pel{file_list} = \@file_list;
        }

	if($gDebug)
		{
		mcs_dprint "file list for $$pel{module_name}:";
		foreach $f (sort (@{$$pel{file_list}}))
			{
			mcs_dprint "       $f";
			}
		mcs_dprint "------";
		}
	}


# +-------------------------------------------------
# | find_peripherals(globals_ref *g)
# |
# | For each peripheral's slave, determine which CPU's
# | it is mastered by, and add that peripheral
# | to that CPU's list.
# | 

sub find_peripherals
	{
	my ($g) = (@_);

	my $module_count;
	my $module_ref;
	my $is_cpu; # true if the module itself is a CPU
	my $slave_count;
	my $enabled_slave_count;
	my $slave_ref;
	my $thing_name; # module/slave name, for debugging messages only
	my $i;
	my $j;
	my $k;
	my $master_list_ref;

	my $cpu_list_ref = $$g{cpu_list};

	# |
	# | Iterate through modules, and for each, see if
	# | it is mastered by the CPU we're working on.
	# | If so, add it to this cpu's peripheral_list
	# |
	
	$module_count = get_child_count($$g{ptf_ref},"MODULE");
	for($i = 0; $i < $module_count; $i++)
		{
		my $use_it = 1;
		my $is_swlib = 0;
		$module_ref = get_child($$g{ptf_ref},$i,"MODULE");

		$is_swlib = get_number_by_path($module_ref,"SYSTEM_BUILDER_INFO/Is_Software_Library");
		$use_it = 0 if (get_number_by_path($module_ref,"SYSTEM_BUILDER_INFO/Is_Bridge"));
		$use_it = 1 if $is_swlib;
		$use_it = 0 if (!get_number_by_path($module_ref,"SYSTEM_BUILDER_INFO/Is_Enabled",1));

        # and the latest moderne addition: just ignore adapters! dvb20050915
		$use_it = 0 if (get_number_by_path($module_ref,"SYSTEM_BUILDER_INFO/Is_Adapter",0));

        

		next if (!$use_it);

		# |
		# | Don't add in CPUs themselves here
		# | Sometimes we have internal faux SLAVE modules
		# | We get CPUs explicitly a bit later.
		# |
#		next if (get_number_by_path($module_ref,"SYSTEM_BUILDER_INFO/Is_CPU"));
		# |
		# | Note that this means you always get the same SDK and test
		# | routine, regardless of the states of different slaves
		# | within the CPU...
		# |

		$slave_count = get_child_count($module_ref,"SLAVE");

		# | Count up the enabled slaves
		$enabled_slave_count = 0;
		for($j = 0; $j < $slave_count; $j++)
			{
			$slave_ref = get_child($module_ref,$j,"SLAVE");

			if (get_data_by_path($slave_ref, "SYSTEM_BUILDER_INFO/Is_Enabled",1))
				{
				$enabled_slave_count ++;
				}
			}



		for($j = 0; $j < $slave_count; $j++)
			{
			$slave_ref = get_child($module_ref,$j,"SLAVE");

            # Skip over disabled slaves.
            # Actually: 
            #   if a slave lacks an Is_Enabled value, or has one set to 1, process it
            #   if a slave has an Is_Enabled value, set to 0, skip it.
            next if
              ('0' eq get_data_by_path($slave_ref, "SYSTEM_BUILDER_INFO/Is_Enabled",1));

			$thing_name = get_data($module_ref) . "/" . get_data($slave_ref);
	
			$master_list_ref = get_all_masters($g,$slave_ref,0);

			# |
			# | We have a list of all CPU's that are masters
			# | of this slave... so add this slave to each
			# | cpu's list of peripherals
			# |

			# |
			# | For each cpu, we grep against the list of masters
			# | and see if it's one we like
			# |

			for($k = 0; $k <= $#$cpu_list_ref; $k++)
				{
				my $cpu_list_element = $$cpu_list_ref[$k];
				my $cpu_ref = $$cpu_list_element{cpu_ref};
				my $cpu_name = get_data($cpu_ref);
				my $peripheral_list_ref = $$cpu_list_element{peripheral_list};

				if(grep(/^$cpu_name$/,@$master_list_ref))
					{
          			# | If this is the sole slave of its module, give it the module's name
          			# | unadorned.

          			my $module_name = get_data($module_ref);
					my $symbol_name = "na_$module_name";

          			if(
                      get_data_by_path($slave_ref,"SYSTEM_BUILDER_INFO/SDK_Use_Slave_Name")
					  or
					  get_number_by_path($module_ref,"SYSTEM_BUILDER_INFO/Is_CPU")
					  or
            		  $enabled_slave_count > 1)
						{
						# When multiple slaves exist in a module, or if a slave demands
						# it (via SBI/SDK_Use_Slave_Name), or if if slave's master is a CPU,
						# use unique name(s) based on the module name and slave name.
						$symbol_name .= '_' . get_data($slave_ref);
						}

					push (@$peripheral_list_ref,
						{
						module_ref => $module_ref,
						module_name => $module_name,
						symbol_name => $symbol_name,
						module_type => get_data_by_path($module_ref,"class"),
						slave_ref => $slave_ref,
						slave_name => get_data($slave_ref),
						is_swlib => $is_swlib
						});
					}
				}
			}
		}
	
	# +---------------------------------------
	# | and now a pleasant little loop in which
	# | each CPU gets added to its own list
	# | of peripherals. To get the nios library, &c.
	# |

	for($k = 0; $k <= $#$cpu_list_ref; $k++)
		{
		my $cel = $$cpu_list_ref[$k];
		my $cpu_ref = $$cel{cpu_ref};
		my $cpu_name = get_data($cpu_ref);
		my $peripheral_list_ref = $$cel{peripheral_list};

		push(@$peripheral_list_ref,
				{
				module_ref => $cpu_ref,
				module_name => get_data($cpu_ref),
				symbol_name => "na_".get_data($cpu_ref),
				module_type => get_data_by_path($cpu_ref,"class"),
				slave_ref => ""
				});
		}
	}
    

# +-------------------------------------------------
# | find_software_components(globals_ref *g)
# |
# | TPA 10/31/2002
# | 
# |  Software components are alot like regular-old MODULEs: They 
# |  have a class.ptf file which might contain SDK settings.  They
# |  have component-directories which might contain sdk/
# |  sub-directories.  When SDKs are made, they are full participants, 
# |  every bit as much as UARTs and other peripherals.
# | 
# |  A key difference is that software components and modules are
# |  "stored" in different places in the system PTF file.  Each MODULE, 
# |  as you must surely know, lives in its own SYSTEM/MODULE section.
# |  Software components, on the other hand, are represented within a 
# |  given CPU's SOFTWARE_COMPONENT <name-of-component> section.
# |  Thus, one difference is that we must look for software components 
# |  in a different way than we look for peripherals.
# | 
# |  For the purposes of SDK-generation, there are a few other key
# |  differences: A software component is associated with only one 
# |  CPU "master."  It doesn't have a SLAVE section, it doesn't have
# |  base-address or a symbol.
# | 
# |  This function just adds information to g.  For every cpu in g, it will
# |  add a software_component_list list-ref.  This will be a list of
# |  little data-structures that have happy info about each component.
# | 
# |  The "little data structure" we build for each component is similar
# |  to, and can be used as, the little datastructure built elsewhere
# |  for each "real" module.  One difference is that we set 
# |  
# |            is_swlib = 1
# |
# |  inside the datastructure, so that people (elsewhere) who process
# |  modules will know not to go looking for things like base-addresses
# |  and such.

sub find_software_components
{
   my ($g) = (@_);

   my $cpu_list_ref = $g->{cpu_list};
   
   foreach my $cpu_data_structure (@{$cpu_list_ref})
   {
      my $cpu_ptf  = $cpu_data_structure->{cpu_ref};
      my $cpu_name = get_data ($cpu_ptf);


      mcs_dprint "Searching for SW components inside CPU $cpu_name\n";
      
      # Riffle through all the top-level children of the CPU's MODULE
      # section which start with the words "SOFTWARE_COMPONENT". 
      #
      my $num_sw_comps = get_child_count ($cpu_ptf, 
                                          "SOFTWARE_COMPONENT");

      mcs_dprint "  Found $num_sw_comps software components, which are:\n";

      my @sw_comp_list = ();

      for (my $i = 0; $i < $num_sw_comps; $i++)
      {
         my $comp_ptf = get_child ($cpu_ptf, $i, 
                                   "SOFTWARE_COMPONENT");
         
         # ignore specifically-disabled components:
         next if ('0' eq get_data_by_path($comp_ptf, 
                                          "SYSTEM_BUILDER_INFO/Is_Enabled",1)
                  );

         my $sw_comp_datastructure = 
         {
            module_ref  => $comp_ptf,
            module_name => get_data($comp_ptf),
            module_type => get_data_by_path($comp_ptf,"class"),
            is_swlib    => 1,
          };

         
         mcs_dprint "    ", get_data($comp_ptf), "\n";
            
         push (@sw_comp_list, $sw_comp_datastructure);
      }
      $cpu_data_structure->{software_component_list} = \@sw_comp_list;
   }
}

# +-------------------------------
# | get_peripherals_and_sw_components ($cel)
# | 
# | TPA 11/1/2002
# |
# | Given a ref to "one of those little CPU datastructures," return
# | a list of "those little module datastructures."  The list is a
# | union of peripherals -and- software-components for the CPU.
# | This function is nearly trivial: It just joins-together 
# | the CPU-structure's existing {peripheral_list} and
# | {software_component_list} fields and returns the result.
# | 
# |
sub get_peripherals_and_sw_components
{
   my ($cel) = (@_);
   return (@{$cel->{peripheral_list}}, @{$cel->{software_component_list}});
}

# +-------------------
# | maybe_assign(source, dest *)
# |
# | if source is nonblank, poke it into dest
sub maybe_assign
	{
	my ($src,$dst_ref) = (@_);

	if($src ne "")
		{
		$$dst_ref = $src;
		}
	}
sub maybe_assign_path
	{
	my ($src,$dst_ref,$prefix,$do_append) = (@_);

	if($src ne "")
		{
		my $v = "$prefix/$src";

		if($do_append and ($$dst_ref ne ""))
			{
			$$dst_ref .= ",$v";
			}
		else
			{
			$$dst_ref = $v;
			}
		}
	}



# +-------------------------------------------------
# | find_sdk_supplies(globals *g,cpu_list_element *cel,peripheral_list_element *pel)
# |
# | From either the sopc builder 2.6 class.ptf entries
# | in SDK_GENERATION or the old directory-implicit
# | locations, find out:
# |  c structure type (such as np_uart *)
# |  c header files to concat into excalibur.h
# |  asm header files to concat into excalibur.s
# |  sdk files directory
# |
# | depends on $$cel{cpu_architecture} being already found
# |

sub find_sdk_supplies
{
   my ($g,$cel,$pel) = (@_);


   # |
   # | First, we see if the class.ptf specifies the sdk dir
   # | for the architecture we have. (sopcb2.6 feature)
   # |
   
   my $sdk_gen_ptf = get_child_by_path(get_class_ptf($g,$$pel{module_type},'verbose'),"CLASS $$pel{module_type}/SDK_GENERATION");

   # |
   # | If that section was found...
   # | iterate through each "SDK_FILES" section, and
   # | match by CPU architecture
   # |

   if($sdk_gen_ptf)
   {
      my $sc = get_child_count($sdk_gen_ptf,"SDK_FILES");
      my $sf_ptf;
      my $i;
      my $ca;
      my $tc;
      my $cel_ca = $$cel{cpu_architecture}; #processor cpu_arch
      my $pel_cd = $$pel{component_dir};
      my $found_one_yet = ""; # set the first time we find a match 
                              #   (not "always")

      for($i = 0; $i < $sc; $i++)
      {
         $sf_ptf = get_child($sdk_gen_ptf,$i,"SDK_FILES");
         $ca = get_data_by_path($sf_ptf,"cpu_architecture");
         $tc = get_data_by_path($sf_ptf,"toolchain");

         # turn * for glob into regexp: * becomes .*
         $ca =~ s/\*/.\*/g;

         my $cpu_architecture_matches = 
             (
              (($cel_ca =~ /^nios_/i) && ($cel_ca =~ /$ca/i))
              || $cel_ca =~ /^$ca$/i
              || ($ca eq "")
              || ($ca eq "always")
              || ($ca eq "else" and !$found_one_yet));

         my $toolchain_matches = 
             (($tc eq $$cel{toolchain})
              or (!$tc));

         if($cpu_architecture_matches and $toolchain_matches)
         {
            $found_one_yet = 1 unless ($ca eq "always") or ($ca eq "else");
            
            # TPA 11/1/2002: Peripherals can
            # define their own build-process by
            # naming a Makefile.
            #
            # Peripherals are also on the hook for 
            # naming the SDK destination-directory
            # in which the "make" command should
            # be executed.
            #
            # Peripherals may, optionally,
            # specify a different make-target in each
            # SDK_FILES section.
            #
            # Just for total politeness,
            # accept either "makefile" or
            # "Makefile"
            #
            maybe_assign(
                         get_data_by_path($sf_ptf,"makefile"),
                         \$$pel{makefile} );

            maybe_assign(
                         get_data_by_path($sf_ptf,"Makefile"),
                         \$$pel{makefile} );

            maybe_assign(
                         get_data_by_path($sf_ptf,"make_in_sdk_directory"),
                         \$$pel{make_dir} );

            maybe_assign(
                         get_data_by_path($sf_ptf,"make_target"),
                         \$$pel{make_target} );

            maybe_assign(
                         get_data_by_path($sf_ptf,"short_type"),
                         \$$pel{short_type} );

            # (new sopcb2.6 feature -- for generation of test code)
            maybe_assign(
                         get_data_by_path($sf_ptf,"test_routine"),
                         \$$pel{test_routine} );

            maybe_assign(
                         get_data_by_path($sf_ptf,"c_structure_type"),
                         \$$pel{struct_type} );


            # |
            # | printf uart routines
            # |
            maybe_assign(
                         get_data_by_path($sf_ptf,"printf_txchar_routine"),
                         \$$pel{printf_txchar_routine} );
            maybe_assign(
                         get_data_by_path($sf_ptf,"printf_rxchar_routine"),
                         \$$pel{printf_rxchar_routine} );
            maybe_assign(
                         get_data_by_path($sf_ptf,"printf_initialize_routine"),
                         \$$pel{printf_initialize_routine} );

            # |
            # | debug uart routines
            # |
            maybe_assign(
                         get_data_by_path($sf_ptf,"debug_txchar_routine"),
                         \$$pel{debug_txchar_routine} );
            maybe_assign(
                         get_data_by_path($sf_ptf,"debug_rxchar_routine"),
                         \$$pel{debug_rxchar_routine} );
            maybe_assign(
                         get_data_by_path($sf_ptf,"debug_initialize_routine"),
                         \$$pel{debug_initialize_routine} );


            maybe_assign_path(
                              get_data_by_path($sf_ptf,"c_header_file"),
                              \$$pel{struct_file_h},
                              $pel_cd);

            maybe_assign_path(
                              get_data_by_path($sf_ptf,"asm_header_file"),
                              \$$pel{struct_file_s},
                              $pel_cd);

            my $sdk_files_dir = get_data_by_path($sf_ptf,"sdk_files_dir");
            maybe_assign_path(
                              $sdk_files_dir,
                              \$$pel{sdk_dir},
                              $pel_cd,
                              1);
            
            # |
            # | explicit list of sdk files to follow?
            # | great! avoids ambiguity that way
            # |
            # | If you use multiple sdk directories, they *all* need
            # | explicit file lists if any have them
            # |

            my $sdk_files_list = get_data_by_path($sf_ptf,"sdk_files_list");
            if($sdk_files_list)
                {
                # | strip leading and trailing whitespace

                if($sdk_files_list =~ /^\s*(.*?)\s*$/)
                    {
                    $sdk_files_list = $1;
                    }

                # | make sure the pel list exists

                $$pel{file_list} = [] if !$$pel{file_list};
                my $file_list_ref = $$pel{file_list};

                # | break apart, and push into place
                my $each_sdk_file;
                foreach $each_sdk_file (split(/[\s,;]+/,$sdk_files_list))
                    {
                    next if $each_sdk_file =~ /^\s*$/;

                    push(@$file_list_ref,"$pel_cd/$sdk_files_dir||$each_sdk_file");
                    }
                }
            

         } # (cpu_architecture matched)

      } # (iterating through SDK_FILES sections

   } # (if SDK_GENERATION section exists in peripheral's class.ptf)
	elsif (($$cel{cpu_architecture} =~ /^nios_/) &&
               # TPA: no courtesey for SW components.
                  (!$pel->{is_swlib}))
		{
		my $i;
		my @dir_contents;
		my $file;


		# |
		# | No SDK_GENERATION section, so we look in the old fashioned 2.5 places
		# | but! this courtesy we extend only to Nios. New CPU's exist only
		# | in the brave new SOPC Builder 2.6 world.
		# |
		# | TPA: Note: We don't extend this courtesey to 
		# |      software components, because there AREN'T any 
                # |      legacy software components.

		foreach $i ("sdk","custom_sdk_pieces")
			{
			my $z = $$pel{component_dir}."/".$i;
	
			$$pel{sdk_dir} = $z if(-d $z);
			}

		# |
		# | Look for a <something>_struct.h file...
		# |

		if(opendir(DIR,$$pel{sdk_dir}))
			{
			@dir_contents = readdir(DIR);

			closedir(DIR);

			foreach $file (@dir_contents)
				{
				if($file =~ /^(.*)_struct.s$/)
					{
					$$pel{struct_file_s} = "$$pel{sdk_dir}/$file";
					}

				if($file =~ /^(.*)_struct.h$/)
					{
					# |
					# | Even if there is a struct file, we hack here so that
					# | very large spans are still void-typed.
					# |

					$$pel{short_type} = $1;
					$$pel{struct_type} = "np_$1 *" if $$pel{addr_span} < 512;
					$$pel{struct_file_h} = "$$pel{sdk_dir}/$file";
					}
				}
			}
		} # (else, look for sdk pieces in the <= v2.5 places)
	}




# +-------------------------------------------------
# | get_irq_number(globals g,cel,pel)
# |
# | Return "" if there is no IRQ number for this,
# | or a number 0..whatever if there is.
# |

sub get_irq_number
  {
  my ($g,$cel,$pel) = @_;

  my $name = "$$pel{module_name}/$$pel{slave_name}";
  my $slave_sbi_ref = get_child_by_path($$pel{slave_ref},"SYSTEM_BUILDER_INFO");
  my $irq_map_ref = get_child_by_path($$cel{cpu_ref},
      "MASTER Stripe_PLD_Master/SYSTEM_BUILDER_INFO/IRQ_MAP");
  my $irq_number; # result

  if(get_number_by_path($slave_sbi_ref,"Has_IRQ") == 0)
    {
    $irq_number = "";
    }
  else
    {
    # Search this slave's IRQ_MASTER sections for a matching cpu.
    my $irq_master_count = get_child_count($slave_sbi_ref, "IRQ_MASTER" );
    for my $i (0 .. $irq_master_count - 1)
      {
      my $irq_master_section = get_child($slave_sbi_ref, $i, 'IRQ_MASTER');
      my $master_name = get_data($irq_master_section);

      if ($master_name =~ m|^$$cel{cpu_name}/\S+|)
        {
        $irq_number = get_number_by_path($irq_master_section, 'IRQ_Number');
        last;
        }
      }
    # If we failed to find the IRQ number in the IRQ_MASTER section, see if
    # there's one in SBI/IRQ_Number.
    if (!$irq_number)
    {
      $irq_number = get_number_by_path($slave_sbi_ref,"IRQ_Number");
    }
      
mcs_dprint "&&& irq_number (avalon-style) is $irq_number";
mcs_dprint "&&& irq_map_ref = $irq_map_ref";

    # | in the case of an ARM stripe, we get IRQ numbers from 
    # | stripe/MASTER ahb_master/SYSTEM_BUILDER_INFO/IRQ_MAP...

    if($irq_map_ref)
      {
      # | start over.

mcs_dprint "&&& name is $name";

      $irq_number = "";

      # | iterate through the mappings.
      my $count;
      my $child;
      my $child_name;
      my $child_data;
      my $i;

      $count = get_child_count($irq_map_ref);
      for($i = 0; $i < $count; $i++)
        {
        $child = get_child($irq_map_ref,$i);
        $child_name = get_name($child);
        $child_data = get_data($child);
mcs_dprint "&&& found child $child_name=$child_data";

        if($child_data eq $name)
          {
          if($child_name =~ /^.*?([x0-9]+)$/)
            {
mcs_dprint "&&^ matched $name";
            $irq_number = 1 * $1;
            }
          }
        }
      }
    }
  
mcs_dprint "&&# returning irq_number=$irq_number for $name";
  return $irq_number;
  }

# +--------------------------------------------------
# | fill_out_peripheral(globals *g,cpu_list_element *,peripheral_list_element *)
# |
# | Given the pointer to the element, which contains
# | a reference to its PTF entry, fill in the address,
# | name, &c, fields of the element.
# |
# | By the way, if multiple CPU's share this peripheral,
# | we do *all the work* for each instance.
# |

sub fill_out_peripheral
	{
	my ($g,$cel,$pel) = @_;

	my $module_ref = $$pel{module_ref};
	my $module_wsa_ref = get_child_by_path($module_ref,"WIZARD_SCRIPT_ARGUMENTS");
	my $slave_ref = $$pel{slave_ref};
	my $slave_sbi_ref = get_child_by_path($slave_ref,"SYSTEM_BUILDER_INFO");
	my $i;

    my $cpu_wsa_ref = get_child_by_path($$cel{cpu_ref},"WIZARD_SCRIPT_ARGUMENTS");

	# |
	# | Take a check and early return if its a custom instruction slave
	# |

    my $ba = get_data_by_path($slave_sbi_ref,"Base_Address");
    $$pel{ci_is_ci} = 
      ($ba =~ /^USR(.)/) ||
      get_data_by_path($slave_sbi_ref,"Is_Custom_Instruction");

	if ($$pel{ci_is_ci})
		{
		# |
		# | Yup! it's a custom instruction slave
		# |
        
        if (!defined($ba)) {
            bail("PTF file broken: No Base_Address");
        }

        if($$cel{cpu_architecture} eq "nios2") 
            {
            # Look in WSA for backwards compatibility.
            $$pel{ci_macro_name} = 
              get_data_by_path($module_wsa_ref, "ci_macro_name") ||
              get_data_by_path($slave_sbi_ref, "ci_macro_name");
            $$pel{ci_base_addr} = eval($ba);
            } 
            else  
            {
            # Look in WSA for backwards compatibility.
            $$pel{ci_macro_name} = 
              get_data_by_path($module_wsa_ref, "ci_macro_name") ||
              get_data_by_path($slave_sbi_ref, "ci_macro_name");

            $$pel{ci_opcode} = $ba;
            $$pel{ci_ifmt} = 
              ($ba eq "USR0") ? "RR" : "Rw"; # USR0 is RR, the rest are Rw.
            $$pel{ci_imft} = 
              get_data_by_path($module_wsa_ref,"ci_instr_format") ||
              get_data_by_path($slave_sbi_ref,"ci_instr_format");
            $$pel{ci_operands} = 
              get_data_by_path($module_wsa_ref,"ci_operands") ||
              get_data_by_path($slave_sbi_ref,"ci_operands");
            $$pel{ci_prefix} = 
              get_data_by_path($module_wsa_ref,"ci_has_prefix") ||
              get_data_by_path($slave_sbi_ref,"ci_has_prefix");
            }
		}

	$$pel{component_dir} = find_component_dir($g,$module_ref,'','verbose');
	$$pel{file_list} = [];

	# |
	# | Load up the class ptf for this module
	# | into g->class_ptfs{}
	# |
	my $component_class = $$pel{module_type};

	# | ask for it, to force it to be cached
	# |
	# !!!my $dummy = get_class_ptf($g,$$pel{module_type},'verbose');


	# +-----------------------------------------------
	# | fill in the address span and irq numbers...
	# |

	if((!$$pel{is_swlib}) and (!$$pel{ci_is_ci}))  # no baseaddr for swlib or custom instructions
		{
		# |
		# | Get the base address and irq
		# |

		$$pel{addr_low} = get_number_by_path($slave_sbi_ref,"Base_Address");

		$$pel{irq_number} = get_irq_number($g,$cel,$pel);

		# |
		# | And the address span...
		# |

		$$pel{addr_span} = get_slave_address_span($$cel{cpu_data_width},$slave_ref);
		}
	
	# +------------------------------------------------
	# | check for the sdk places and set one. if there is one.
	# |

	find_sdk_supplies($g,$cel,$pel);

	# |
	# | Fill in the constant_list, if the PTF has a CONSTANTS section
	# |

	my $cr = get_child_by_path($$pel{module_ref},
            "WIZARD_SCRIPT_ARGUMENTS/CONSTANTS");
    if($cr)
		{
		my $i;
		my $def;
		my @temp_list;

		for($i = 0; $i < get_child_count($cr,"CONSTANT"); $i++)
			{
			$def = get_child($cr,$i,"CONSTANT");
			my ($name,$value,$comment) =
					(get_data($def),
					get_data_by_path($def,"value"),
					get_data_by_path($def,"comment"));

			# |
			# | Protection against malformed CONSTANT sections
			# |

			next if (($name eq "") or ($value eq ""));

			# |
			# | If we don't have an entry by this name already,
			# | anywhere in the whole CPU, add it.
			# | We keep this list globally by CPU.
			# |

			if(!$$cel{pel_constant_nameshash}{$name})
				{
				push(@{$$cel{pel_constant_list}},
					{
					name => $name,
					value => $value,
					comment => $comment
					});
				$$cel{pel_constant_nameshash}{$name} = 1;
				$$cel{pel_constant_hash}{$name} = $value;
				}
			}
		}

	# |
	# | And now a list of files in the sdk
	# |

	add_peripheral_file_list($g,$pel);
	}


# +--------------------------------------------------
# | examine_each_peripheral(globals *g)
# |
# | For each peripheral of each cpu, fill in its
# | entry with the symbol name, the the address
# | span, the list of library files, and so forth
# |
# | TPA 10/31/2002: 
# |     Now also "examines" each software component.

sub examine_each_peripheral
	{
	my ($g) = @_;

	my $i; # cpu index
	my $j; # peripheral index

	my $cpu_list;
	my $cel;
	my $peripheral_list;
	my $pel;

	$cpu_list = $$g{cpu_list};

	for($i = 0; $i <= $#$cpu_list; $i++)
        {
           $cel = $$cpu_list[$i];

           # make sure we have a listref handy...
           $$cel{pel_constant_list} = []; 

           # |
           # | pull out the cpu goodies from each peripheral's class.ptf
           # |
           foreach my $pel (get_peripherals_and_sw_components($cel))
           {
              
              fill_out_peripheral($g,$cel,$pel);
           }
        }

	# |
	# | after the peripherals, fill out the cpus
	# | why after? because fill_out_peripherals reads
	# | in the class.ptf's, and this stage needs the
	# | class.ptf already read in, thankyou
	# |

	foreach $cel (@$cpu_list)
		{
		fill_out_cpu_misc($g,$cel);
		}

	}


# +--------------------------------------
# | ensure_directory(guaranteed_root,directory_path)
# |
# | The guaranteed root is not checked or
# | created; each segment of the new dir is.
# |
sub ensure_directory
	{
	my ($guaranteed_root,$directory_path) = @_;
	my $directory_segment;

	foreach $directory_segment (split(/\//,$directory_path))
		{
		$guaranteed_root .= "/" . $directory_segment;
		if(! -d $guaranteed_root)
			{
			mkdir($guaranteed_root,511) or return 0;
			}
		}
	
	return 1;
	}



# +--------------------------------------------
# | populate_template($template,%substitution_hash *)
# |
# | For each occurrance of --something_here-- in the template,
# | replace it with the named element out of the substitution
# | hash, or a little ERROR note if there's not one an
# | unsubstituted --thingie--.
# |
# | that pattern match requires a character that
# | is NOT a hyphen just before the two hypens...
# | so this may fail at the beginning of a line.
# |

sub populate_template
	{
	my ($template,$substitution_hash_ref) = @_;
	my $pattern;

	# |
	# | look first for --this--, and then %that%.
	# |

	foreach $pattern (
			"(.*[^-]) \-\-([a-zA-Z0-9_]+)\-\- (.*)",
			"(.*[^%]) %([a-zA-Z0-9_]+)% (.*)")
		{
		while ($template =~ /^$pattern$/xs)
			{
			my $mt_beginning = $1;
			my $mt_middle = $2;
			my $mt_end = $3;
			my $mt_middle_var;
	
			$mt_middle_var = $$substitution_hash_ref{$mt_middle};
			$mt_middle_var = "ERROR_missing_${mt_middle}" if($mt_middle_var eq "");
	
			$template = $mt_beginning . $mt_middle_var . $mt_end;
			}
		}

	return $template;
	}


# +-----------------------------------
# | generate_makefile
# |
# | return a giant string with the Makefile in it
# | for the ../lib directory
# |

sub generate_makefile
    {
    my ($g,$cpu_list_element) = @_;
    my $cel = $cpu_list_element;

    # | We start with one string with the Makefile
    # | template in it, then we replace the
    # | changeable parts
    # |

    my $makefile_template = <<EOP;
# file: Makefile
#
# SDK Makefile for cpu named --cpu_name--
# --date_time--
# --ptf_name--
#
--makefile_conditionals--

CPU_ARCHITECTURE = --cpu_architecture--
GNU_TOOLS_PREFIX = --gnu_tools_prefix--
AS = \$(GNU_TOOLS_PREFIX)-as
CC = \$(GNU_TOOLS_PREFIX)-gcc
AR = \$(GNU_TOOLS_PREFIX)-ar
LD = \$(GNU_TOOLS_PREFIX)-ld
M = --cpu_data_width--
PROGRAM_PREFIX = --program_prefix--
TEST_CODE_PREFIX = --test_code_prefix--

# constants from excalibur.h, sometimes useful in build-decisions

--all_consts--
#HOST_COMM = --host_comm--
#NASYS_PRINTF_UART = --nasys_printf_uart--
#NASYS_VECTOR_TABLE = --nasys_vector_table--
#NASYS_OCI_CORE = --nasys_oci_core--
#NASYS_RESET_ADDRESS = --nasys_reset_address--

OBJDIR = ./obj\$(M)
OBJDIR_DEBUG = ./obj\$(M)_debug
SRC = .
E = echo \\\\\\# `date +%Y.%m.%d.%H:%M:%S` ---

ASFlags = --platform_as_flags-- --gstabs -I ../inc -I ../.. --as_conditionals--

ASFlags_debug = \$(ASFlags) --defsym __nios_debug__=1

CCFlags = -W -Wno-multichar -g -c -O2 --platform_cc_flags-- -I ../inc -I ../.. --cc_conditionals--

CCFlags_debug = \$(CCFlags) -O0 -D __nios_debug__=1

LIBRARY = libnios\$(M).a
LIBRARY_DEBUG = libnios\$(M)_debug.a

SINCLUDES = --sincludes_list--

CINCLUDES = --cincludes_list--

OBJECTS = --object_list--

OBJECTS_DEBUG = --object_list_debug--

# +--------------------------------------------
# | Default make target is "all"

all : \$(LIBRARY) \$(LIBRARY_DEBUG) --nios_gdb_standalone2--

# |
# +--------------------------------------------

\$(OBJDIR)/%.s.o : \$(SRC)/%.s \$(SINCLUDES)
\t\@\$(E) Assembling \$<
\t\@\$(AS) \$(ASFlags) \$< -o \$@

\$(OBJDIR_DEBUG)/%.s.o : \$(SRC)/%.s \$(SINCLUDES)
\t\@\$(E) Assembling \$<
\t\@\$(AS) \$(ASFlags_debug) \$< -o \$@

\$(OBJDIR)/%.c.o : \$(SRC)/%.c \$(CINCLUDES)
\t\@\$(E) Compiling \$<
\t\@\$(CC) \$(CCFlags) \$< -o \$@

\$(OBJDIR_DEBUG)/%.c.o : \$(SRC)/%.c \$(CINCLUDES)
\t\@\$(E) Compiling \$<
\t\@\$(CC) \$(CCFlags_debug) \$< -o \$@

\$(OBJDIR) :
\t\@\$(E) Making \$@ Directory
\t\@mkdir \$@

\$(OBJDIR_DEBUG) :
\t\@\$(E) Making \$@ Directory
\t\@mkdir \$@

clean : \$(OBJDIR) \$(OBJDIR_DEBUG) clean-lib
\t\@\$(E) Removing objects
\t\@rm -f \$(OBJECTS) \$(OBJECTS_DEBUG) \$(LIBRARY)

clean-lib :
\t\@\$(E) Deleting \$(LIBRARY) \$(LIBRARY_DEBUG)
\t\@rm -f \$(LIBRARY) \$(LIBRARY_DEBUG)

lib : \$(LIBRARY) \$(LIBRARY_DEBUG)

\$(LIBRARY) : clean-lib \$(OBJDIR) \$(OBJECTS)
\t\@\$(E) Building \$@
\t\@\$(AR) -r \$(LIBRARY) \$(OBJECTS)

\$(LIBRARY_DEBUG) : clean-lib \$(OBJDIR_DEBUG) \$(OBJECTS_DEBUG)
\t\@\$(E) Building \$@
\t\@\$(AR) -r \$(LIBRARY_DEBUG) \$(OBJECTS_DEBUG)

--nios_gdb_standalone--

# end of file
EOP

    # +--------------------------------------
    # | Now to fill in the unknowns
    # |

    my %mv; # the makefile variables

    $mv{cpu_name} = $$cel{cpu_name};
    $mv{date_time} = date_time();
    $mv{ptf_name} = $$g{ptf_name};
    $mv{cpu_data_width} = $$cel{cpu_data_width};

    $mv{cpu_architecture} = $$cel{cpu_architecture};
    $mv{gnu_tools_prefix} = $$cel{gnu_tools_prefix};
    $mv{program_prefix} = $$cel{program_prefix};
    $mv{test_code_prefix} = $$cel{test_code_prefix};

    # +--------------------------------------
    # | Platform specific as and cc flags
    # | Regrettably, nios-build knows about these
    # | right here in the perl code. Would be
    # | if it was modular, or data driven, but so it goes.
    # |

    $mv{platform_as_flags} = " ";
    $mv{platform_cc_flags} = " ";
    if ($$cel{cpu_architecture} =~ /^nios_/) {
        $mv{platform_as_flags} = "--defsym __nios\$(M)__=1 -m\$(M)";
        $mv{platform_cc_flags} = "-mno-zero-extend -m\$(M)";
        
        if($$cel{pel_constant_hash}{nasys_has_dcache})
            {
            $mv{platform_cc_flags} .= " -mdcache";
            }
    }

    # |

    # +--------------------------------------
    # | Makefile conditionals are a cluster
    # |
    # | (2002dvb -- these may no longer be needed, the mc?)

    my %mc;
    my $wsa = get_child_by_path($$cel{cpu_ref},"WIZARD_SCRIPT_ARGUMENTS");

    if($$cel{cpu_architecture} =~ /^nios_/)
        {
        $mc{NIOS_SYSTEM_NAME} = $$g{system_name};
        # (This should be deleted post 2.6; nobody uses it I think?)

        # |
        # | These two settings have migrated into the
        # | CONSTANTS section of the class.ptf for
        # | nios. But old designs may not have access
        # | to the new class.ptf for Nios for a while,
        # | until Altera ships one. sopc 2.6 does not
        # | include it, yet.
        # |
        # | So we have this grotesque kludge to include
        # | them as defsyms until. Blecchy!
        # |
        # | !!! abominable hack for 2.6 !!!
        # | (But it works fine, fear not. -- dvb 2002)
        # |
        # (This should be deleted post 2.6, when new nios goes out)

        if(!$$cel{pel_constant_nameshash}{__nios_use_mstep__})
            {
            $mc{NIOS_USE_MSTEP} = get_number_by_path($wsa,"mstep")
                    . " # CPU option (shift, test, & add)";
            }
        if(!$$cel{pel_constant_nameshash}{__nios_use_multiply__})
            {
            $mc{NIOS_USE_MULTIPLY} = get_number_by_path($wsa,"multiply")
                    . " # CPU option (16x16->32)";
            }
        }






    my $key;
    my $lckey;

    $mv{makefile_conditionals} .= "\n"; # so its not ever empty

    $mv{cc_conditionals} = " "; # so its unblank
    $mv{as_conditionals} = " ";

    foreach $key (sort(keys(%mc)))
        {
        $lckey = $key;
        $lckey =~ tr/A-Z/a-z/;
        $mv{makefile_conditionals} .= "\n$key = " . $mc{$key};
        $mv{as_conditionals} .= " \\\n\t--defsym __${lckey}__=\$(${key})";
        $mv{cc_conditionals} .= " \\\n\t-D __${lckey}__=\$(${key})";
        }

    # +-----------------------------------------------------------------
    # | Object files result from any .c or .s in the lib directory
    # | SIncludes are any .s files in the inc directory
    # | CIncludes are any .h files in the inc or lib directory
    # | Start the include list with the memory map file name.
    # |
    # | Though, we do manually exclude a couple of troublemakers
    # | named nios_germs_monitor.s and nios_gdb_standalone.c
    # |

    my $file;

    $mv{cincludes_list} .= " \\\n\t../inc/$$cel{memory_map_file_name}.h";
    $mv{sincludes_list} .= " \\\n\t../inc/$$cel{memory_map_file_name}.s";

    foreach $file (sort(@{$$cel{file_list}}))
        {
        if(($file =~ /^lib\/([^\/]*\.[cs])$/)
                and ($file ne "lib/nios_germs_monitor.s")
                and ($file ne "lib/nios_gdb_standalone.c")) # ugly
            {
            $mv{object_list} .= " \\\n\t\$(OBJDIR)/${1}.o";
            $mv{object_list_debug} .= " \\\n\t\$(OBJDIR_DEBUG)/${1}.o";
            }
        elsif($file =~ /^lib\/([^\/]*\.[h])$/)
            {
            $mv{cincludes_list} .= " \\\n\t$1";
            }
        elsif($file =~ /^(inc\/[^\/]*\.[h])$/)
            {
            $mv{cincludes_list} .= " \\\n\t../$1";
            }
        elsif($file =~ /^(inc\/[^\/]*\.[s])$/)
            {
            $mv{sincludes_list} .= " \\\n\t../$1";
            }
        }
    
    # +----------------------------------------------------------------
    # | and special slop for the gdb_standalone stub
    # |

    my $standalone_stub_size = 0x4000; # estimated size of stub
    my $nios_stub_address = $$cel{constant_hash}{nasys_stack_top} - $standalone_stub_size;

    if(grep(/^lib\/nios_gdb_standalone.c$/,@{$$cel{file_list}})
            and 
            $nios_stub_address > $$cel{constant_hash}{nasys_data_mem})
        {
        $nios_stub_address = whex($cel,$nios_stub_address);

        $mv{nios_gdb_standalone2} = "nios_gdb_standalone.srec";
        $mv{nios_gdb_standalone} = "nios_gdb_standalone.srec : nios_gdb_standalone.c "
                    . "\$(CINCLUDES) \$(SINCLUDES)\n"
                . "\t\@\$(E) Building \$@\n"
                . "\t\@nios-build -ne -s -b $nios_stub_address nios_gdb_standalone.c\n"
                . "\t\@rm nios_gdb_standalone.c.o nios_gdb_standalone.out";
        }
    else
        {
        $mv{nios_gdb_standalone} = " ";
        $mv{nios_gdb_standalone2} = " ";
        }

    # +--------------------------------------
    # | Values for nios-run to check, to build its
    # | command line options, especially for jtag
    # |
    # | this will be all the nasys_thisnthats.
    # |

        {
        my $w_l = 28;
        my $w_r = 16;
        my $all_consts = "";
        my $key;
        my $ch;

        foreach $ch ($$cel{constant_hash},$$cel{pel_constant_hash})
            {
            foreach $key (sort(keys(%$ch)))
                {
                my $val = $$ch{$key};
                my $key_uc = uc($key);

                $all_consts .= " " x ($w_l - length($key_uc));

                my $first_val;
                my $second_val;

# freaking garbage copy and paste
# dont forget, you gotta make EVERY CHANGE in
# two places.

                if($val * 1)
                    {
                    # its a decimal number
                    $first_val = sprintf("0x%08x",$val);
                    $second_val = " # $val";
                    }
                else
                    {
                    $first_val = $val;
                    $second_val = "";
                    }

                $all_consts .= "$key_uc = $first_val$second_val\n";
                }
            }
        
        $mv{all_consts} = $all_consts;
        }

    # +----------------------------------------------------------------
    # | And lastly, swap in all the variables
    # |

    my $makefile = populate_template($makefile_template,\%mv);

    return $makefile;
    }

# +-----------------------------------
# | generate_nios2_excalibur_mk
# |
# | return a giant string with the excalibur.mk in it for the ../inc directory
# |

sub generate_nios2_excalibur_mk
    {
    my ($g,$cpu_list_element) = @_;
    my $cel = $cpu_list_element;

    # |
    # | We start with one string with the excalibur.mk
    # | template in it, then we replace the
    # | changeable parts
    # |

    my $excalibur_mk_template = <<EOP;
# file: excalibur.mk
#
# This file is a machine generated address map
# for a CPU named --cpu_name--.
# --ptf_filename--
# Generated: --date_time--
#
# DO NOT MODIFY THIS FILE
#
# Changing this file will have subtle consequences
# which will almost certainly lead to a nonfunctioning
# system. If you do modify this file, you MUST
# change both --memory_map_file_name--.h,
# --memory_map_file_name--.s, and --memory_map_file_name--.mk identically.
# Or better yet:
#
# DO NOT MODIFY THIS FILE

CPU_ARCHITECTURE = --cpu_architecture--
GNU_TOOLS_PREFIX = --gnu_tools_prefix--
AS = \$(GNU_TOOLS_PREFIX)-as
CC = \$(GNU_TOOLS_PREFIX)-gcc
AR = \$(GNU_TOOLS_PREFIX)-ar
LD = \$(GNU_TOOLS_PREFIX)-ld
NM = \$(GNU_TOOLS_PREFIX)-nm
OD = \$(GNU_TOOLS_PREFIX)-objdump
OC = \$(GNU_TOOLS_PREFIX)-objcopy
NC = nios-convert
ISS = nios2-iss
PROJECT_NAME = --projectname--
CPU_NAME = --cpu_name--
SYSTEM_NAME = --system_name--
PTF_FILENAME = --ptf_filename--

# constants from excalibur.h, sometimes useful in build-decisions

--all_consts--

# ===========================================================
# Parameters for Each Peripheral, Excerpted From The PTF File

--ptf_excerpts--

# end of file
EOP

    # +--------------------------------------
    # | Now to fill in the unknowns
    # |

    my %mv; # the makefile variables

    $mv{cpu_name} = $$cel{cpu_name};
    $mv{date_time} = date_time();
    $mv{ptf_filename} = $$g{system_name} . ".ptf";

    $mv{cpu_architecture} = $$cel{cpu_architecture};
    $mv{gnu_tools_prefix} = $$cel{gnu_tools_prefix};
    $mv{program_prefix} = $$cel{program_prefix};
    $mv{test_code_prefix} = $$cel{test_code_prefix};
    $mv{memory_map_file_name} = $$cel{memory_map_file_name};

    $mv{projectname} = $$g{projectname};
    $mv{system_name} = $$g{system_name};

    # +--------------------------------------
    # | Values for nios-run to check, to build its
    # | command line options, especially for jtag
    # |
    # | this will be all the nasys_thisnthats.
    # |

        {
        my $w_l = 28;
        my $w_r = 16;
        my $all_consts = "";
        my $key;
        my $ch;

        foreach $ch ($$cel{constant_hash},$$cel{pel_constant_hash})
            {
            foreach $key (sort(keys(%$ch)))
                {
                my $val = $$ch{$key};
                my $key_uc = uc($key);

                $all_consts .= " " x ($w_l - length($key_uc));

                my $first_val;
                my $second_val;

# freaking garbage copy and paste
# dont forget, you gotta make EVERY CHANGE in
# two places.

                if($val * 1)
                    {
                    # its a decimal number
                    $first_val = sprintf("0x%08x",$val);
                    $second_val = " # $val";
                    }
                else
                    {
                    $first_val = $val;
                    $second_val = "";
                    }

                $all_consts .= "$key_uc = $first_val$second_val\n";
                }
            }
        
        $mv{all_consts} = $all_consts;
        }

    # +--------------------------------------
    # | And glom together some nice ptf excerpts to tell a story
    # |
    
        {
        my $pel;
        my $comment_char = "#";

        foreach $pel (sort {$$a{addr_low} <=> $$b{addr_low}} 
                              get_peripherals_and_sw_components ($cel))
            {
            my $table_ref = table_begin();
            my $wsa;
            my $child_count;
            my $child_ref;
            my $i;

            $wsa = get_child_by_path($$pel{module_ref},
              "WIZARD_SCRIPT_ARGUMENTS");
            $child_count = get_child_count($wsa);

            next if (!$wsa) or (!$child_count);

            $mv{ptf_excerpts} .= "\n\n"
                    . $comment_char
                    . " ------------------\n"
                    . $comment_char
                    . " Parameters for "
                    . $$pel{module_type}
                    . " named "
                    . $$pel{module_name}
                    . "\n\n";

            my $prefix;

            # Set the prefix to nios2_ so that makefiles don't need
            # to know the name of this CPU instance (since there is
            # one SDK for each CPU).
            #
            # !!!HACK ALERT!!!
            # If you have multiple Nios II CPUs, this won't work.

            if ($$pel{module_type} eq "altera_nios2") {
                $prefix = "nios2_";
            } else {
                $prefix = $$pel{module_name} . "_";
            }

            for($i = 0; $i < $child_count; $i++)
                {
                $child_ref = get_child($wsa,$i);
                my $arg_name = $prefix . get_name($child_ref);

                table_addrow($table_ref,
                        $arg_name,
                        "=",
                        get_data($child_ref));
                }
            $mv{ptf_excerpts} .= table_sprint($table_ref);
            }
        }

    # +----------------------------------------------------------------
    # | And lastly, swap in all the variables
    # |

    my $excalibur_mk = populate_template($excalibur_mk_template,\%mv);

    return $excalibur_mk;
    }

# +-----------------------------------
# | generate_nios2_makefile
# |
# | return a giant string with the Makefile in it for the ../lib directory
# |

sub generate_nios2_makefile
	{
	my ($g,$cpu_list_element) = @_;
	my $cel = $cpu_list_element;

	# |
	# | We start with one string with the Makefile
	# | template in it, then we replace the
	# | changeable parts
	# |

	my $makefile_template = <<EOP;
# file: Makefile
#
# SDK Makefile for cpu named --cpu_name--
# --date_time--
# --ptf_name--
#
--makefile_conditionals--

include ../inc/excalibur.mk

MAKEFILES=Makefile ../inc/excalibur.mk

OBJDIR = ./obj
OBJDIR_DEBUG = ./obj_debug
SRC = .
E = echo \\\\\\# `date +%Y.%m.%d.%H:%M:%S` ---

ASFlags = --platform_as_flags-- --gstabs -I ../inc -I ../.. --as_conditionals--

ASFlags_debug = \$(ASFlags) --defsym __nios_debug__=1

CCFlags = -W -Wno-multichar -g -c -O2 --platform_cc_flags-- -I ../inc -I ../.. --cc_conditionals--

CCFlags_debug = \$(CCFlags) -O0 -D __nios_debug__=1

LIBRARY = libnios.a
LIBRARY_DEBUG = libnios_debug.a

SINCLUDES = --sincludes_list--

CINCLUDES = --cincludes_list--

OBJECTS = --object_list--

OBJECTS_DEBUG = --object_list_debug--

# +--------------------------------------------
# | Default make target is "all"

all : \$(LIBRARY) \$(LIBRARY_DEBUG) --nios_gdb_standalone2--

# |
# +--------------------------------------------

\$(OBJDIR)/%.s.o : \$(SRC)/%.s \$(SINCLUDES) \$(MAKEFILES)
\t\@\$(E) Assembling \$<
\t\@\$(AS) \$(ASFlags) \$< -o \$@

\$(OBJDIR_DEBUG)/%.s.o : \$(SRC)/%.s \$(SINCLUDES) \$(MAKEFILES)
\t\@\$(E) Assembling \$<
\t\@\$(AS) \$(ASFlags_debug) \$< -o \$@

\$(OBJDIR)/%.c.o : \$(SRC)/%.c \$(CINCLUDES) \$(MAKEFILES)
\t\@\$(E) Compiling \$<
\t\@\$(CC) \$(CCFlags) \$< -o \$@

\$(OBJDIR_DEBUG)/%.c.o : \$(SRC)/%.c \$(CINCLUDES) \$(MAKEFILES)
\t\@\$(E) Compiling \$<
\t\@\$(CC) \$(CCFlags_debug) \$< -o \$@

\$(OBJDIR) :
\t\@\$(E) Making \$@ Directory
\t\@mkdir \$@

\$(OBJDIR_DEBUG) :
\t\@\$(E) Making \$@ Directory
\t\@mkdir \$@

clean : \$(OBJDIR) \$(OBJDIR_DEBUG) clean-lib
\t\@\$(E) Removing objects
\t\@rm -f \$(OBJECTS) \$(OBJECTS_DEBUG) \$(LIBRARY)

clean-lib :
\t\@\$(E) Deleting \$(LIBRARY) \$(LIBRARY_DEBUG)
\t\@rm -f \$(LIBRARY) \$(LIBRARY_DEBUG)

lib : \$(LIBRARY) \$(LIBRARY_DEBUG)

\$(LIBRARY) : clean-lib \$(OBJDIR) \$(OBJECTS)
\t\@\$(E) Building \$@
\t\@\$(AR) -r \$(LIBRARY) \$(OBJECTS)

\$(LIBRARY_DEBUG) : clean-lib \$(OBJDIR_DEBUG) \$(OBJECTS_DEBUG)
\t\@\$(E) Building \$@
\t\@\$(AR) -r \$(LIBRARY_DEBUG) \$(OBJECTS_DEBUG)

--nios_gdb_standalone--

# end of file
EOP

	# +--------------------------------------
	# | Now to fill in the unknowns
	# |

	my %mv; # the makefile variables

	$mv{cpu_name} = $$cel{cpu_name};
	$mv{date_time} = date_time();
	$mv{ptf_name} = $$g{ptf_name};

	# +--------------------------------------
	# | Platform specific as and cc flags
	# | Regrettably, nios-build knows about these
	# | right here in the perl code. Would be
	# | if it was modular, or data driven, but so it goes.
	# |

    my $wsa = get_child_by_path($$cel{cpu_ref},"WIZARD_SCRIPT_ARGUMENTS");

	$mv{platform_as_flags} = " ";
	$mv{platform_cc_flags} = " ";

    if (get_number_by_path($wsa,"hardware_multiply_present")) {
        $mv{platform_cc_flags} .= " -mhw-mul";

        if (get_number_by_path($wsa,"hardware_multiply_omits_msw")) {
            $mv{platform_cc_flags} .= " -mno-hw-mulx";
        } else {
            $mv{platform_cc_flags} .= " -mhw-mulx";
        }
    } else {
        $mv{platform_cc_flags} .= " -mno-hw-mul";
        $mv{platform_cc_flags} .= " -mno-hw-mulx";
    }

    if (get_number_by_path($wsa,"hardware_divide_present"))
    {
        $mv{platform_cc_flags} .= " -mhw-div";
    }
    else
    {
        $mv{platform_cc_flags} .= " -mno-hw-div";
    }

    $mv{platform_cc_flags} .= " -mno-cache-volatile";

	# +--------------------------------------
	# | Makefile conditionals are a cluster
	# |
	# | (2002dvb -- these may no longer be needed, the mc?)

	my %mc;

	my $key;
	my $lckey;

	$mv{makefile_conditionals} .= "\n"; # so its not ever empty

	$mv{cc_conditionals} = " "; # so its unblank
	$mv{as_conditionals} = " ";

	foreach $key (sort(keys(%mc)))
		{
		$lckey = $key;
		$lckey =~ tr/A-Z/a-z/;
		$mv{makefile_conditionals} .= "\n$key = " . $mc{$key};
		$mv{as_conditionals} .= " \\\n\t--defsym __${lckey}__=\$(${key})";
		$mv{cc_conditionals} .= " \\\n\t-D __${lckey}__=\$(${key})";
		}

	# +-----------------------------------------------------------------
	# | Object files result from any .c or .s in the lib directory
	# | SIncludes are any .s files in the inc directory
	# | CIncludes are any .h files in the inc or lib directory
	# | Start the include list with the memory map file name.
	# |
	# | Though, we do manually exclude a couple of troublemakers
	# | named nios_germs_monitor.s and nios_gdb_standalone.c
	# |

	my $file;

	$mv{cincludes_list} .= " \\\n\t../inc/$$cel{memory_map_file_name}.h";
	$mv{sincludes_list} .= " \\\n\t../inc/$$cel{memory_map_file_name}.s";

	foreach $file (sort(@{$$cel{file_list}}))
		{
		if(($file =~ /^lib\/([^\/]*\.[cs])$/)
				and ($file ne "lib/nios_germs_monitor.s")
				and ($file ne "lib/nios_gdb_standalone.c")) # ugly
			{
			$mv{object_list} .= " \\\n\t\$(OBJDIR)/${1}.o";
			$mv{object_list_debug} .= " \\\n\t\$(OBJDIR_DEBUG)/${1}.o";
			}
		elsif($file =~ /^lib\/([^\/]*\.[h])$/)
			{
			$mv{cincludes_list} .= " \\\n\t$1";
			}
		elsif($file =~ /^(inc\/[^\/]*\.[h])$/)
			{
			$mv{cincludes_list} .= " \\\n\t../$1";
			}
		elsif($file =~ /^(inc\/[^\/]*\.[s])$/)
			{
			$mv{sincludes_list} .= " \\\n\t../$1";
			}
		}
	
	# +----------------------------------------------------------------
	# | and special slop for the gdb_standalone stub
	# |

	my $standalone_stub_size = 0x4000; # estimated size of stub
	my $nios_stub_address = $$cel{constant_hash}{nasys_stack_top} - $standalone_stub_size;

	if(grep(/^lib\/nios_gdb_standalone.c$/,@{$$cel{file_list}})
			and 
			$nios_stub_address > $$cel{constant_hash}{nasys_data_mem})
		{
		$nios_stub_address = whex($cel,$nios_stub_address);

		$mv{nios_gdb_standalone2} = "nios_gdb_standalone.srec";
		$mv{nios_gdb_standalone} = "nios_gdb_standalone.srec : nios_gdb_standalone.c "
					. "\$(CINCLUDES) \$(SINCLUDES)\n"
				. "\t\@\$(E) Building \$@\n"
				. "\t\@nios-build -ne -s -b $nios_stub_address nios_gdb_standalone.c\n"
				. "\t\@rm nios_gdb_standalone.c.o nios_gdb_standalone.out";
		}
	else
		{
		$mv{nios_gdb_standalone} = " ";
		$mv{nios_gdb_standalone2} = " ";
		}

	# +----------------------------------------------------------------
	# | And lastly, swap in all the variables
	# |

	my $makefile = populate_template($makefile_template,\%mv);

	return $makefile;
	}

# +-----------------------------------
# | generate_excalibur_h(globals *g,cpu_list_element *,h_defines)
# |
# | return giant string for excalibur.h
# | The caller must pass in the h_defines
# | for the .../lib directory
# |

sub generate_excalibur_h
	{
	my ($g,$cpu_list_element,$h_defines) = @_;
	my $cel = $cpu_list_element;

    my $wsa = get_child_by_path($$cel{cpu_ref},"WIZARD_SCRIPT_ARGUMENTS");

    my $title = "The Memory Map";

	my %mv; # variables to substitute into template

	my $nios_h_template = <<EOP;
/*
 * File: --memory_map_file_name--.h
 *
 * This file is a machine generated address map
 * for a CPU named --cpu_name--.
 * --ptf_name--
 * Generated: --date_time--

 DO NOT MODIFY THIS FILE

 Changing this file will have subtle consequences
 which will almost certainly lead to a nonfunctioning
 system. If you do modify this file, you MUST
 change both --memory_map_file_name--.h,
 --memory_map_file_name--.s, and --memory_map_file_name--.mk identically.
 Or better yet:

 DO NOT MODIFY THIS FILE

 */

#ifndef _--memory_map_file_name--_
#define _--memory_map_file_name--_

// Legacy SDK will not be supported for Nios II in version 6.0 and beyond.
// Please migrate your software to use the HAL System Library.
// See the Nios II Software Developer's Handbook.

#include <stdio.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

// $title

--h_defines--

#define nm_system_name_string "--system_name--"
#define nm_cpu_name_string "--cpu_name--"
#define nm_monitor_string "--monitor_string--"
#define nm_cpu_architecture --cpu_architecture--
#define nm_cpu_architecture_string "--cpu_architecture--"
#define --cpu_architecture-- 1

// Structures and Routines For Each Peripheral

--all_structfiles_h--


// ===========================================================
// Parameters for Each Peripheral, Excerpted From The PTF File

--ptf_excerpts--

#ifdef __cplusplus
}
#endif

#endif //_--memory_map_file_name--_

// end of file
EOP

	# +----------------------------------
	# | Fill in the date & name for nios.h
	# |

	$mv{memory_map_file_name} = $$cel{memory_map_file_name};
	$mv{h_defines} = $h_defines;
	$mv{cpu_name} = $$cel{cpu_name};
	$mv{cpu_architecture} = $$cel{cpu_architecture};
	$mv{date_time} = date_time();
	$mv{ptf_name} = $$g{ptf_name};
	$mv{system_name} = $$g{system_name};
	$mv{monitor_string} = get_data_by_path($$cel{cpu_ref},"WIZARD_SCRIPT_ARGUMENTS/germs_monitor_id");
	$mv{monitor_string} = "(missing)" if $mv{monitor_string} eq "";

	# +-----------------------------------
	# | Glom together all the struct.h files
	# | using a hash to avoid repeats
	# |
	
		{	
		my %module_types;
		my $pel;

		foreach $pel (sort
				{$$a{addr_low} <=> $$b{addr_low} ?
					$$a{addr_low} <=> $$b{addr_low} :	# primary key
					$$a{module_name} cmp $$b{module_name}}	# secondary key

                            # TPA:  Needs replacin': 
				get_peripherals_and_sw_components($cel))
			{
			# |
			# | If this slave is a custom instruction, emit a macro
			# |

			if($$pel{ci_is_ci})
				{
				my $macro_name = lc($$pel{ci_macro_name});

                if($$cel{cpu_architecture} eq "nios2") 
                    {
                    my $base_addr = lc($$pel{ci_base_addr});

                    $mv{all_structfiles_h} .=
                        "#define nm_${macro_name}_n $base_addr\n";
                    }
                else 
                    {
                    my $opcode = lc($$pel{ci_opcode});
                    my $ci_operands = $$pel{ci_operands};
                    my $ci_ifmt = $$pel{ci_ifmt};
                    my $ci_prefix = $$pel{ci_prefix};
    
                    if($ci_ifmt eq "Rw")
                        {
                        # |
                        # | Rw Instruction, single and dual operand flavors
                        # |
    
                        if($ci_operands == 1)
                        {
                        # Rw, 1op, no pfx
                        $mv{all_structfiles_h} .=
                            "#define nm_${macro_name}(_x) "
                            . "({"
                            . "\\\n\tint __x = (_x);"
                            . "\\\n\tasm volatile("
                            . "\""
                            . "$opcode %0 ; does $macro_name"
                            . "\" "
                            . "\\\n\t: \"=r\" (__x) "
                            . "\\\n\t: \"0\" (__x)"
                            . ");"
                            . "\\\n\t__x;"
                            . "\\\n\t})\n"
                            ;
                        }
                        if($ci_operands == 1 and $ci_prefix)
                        {
                        # Rw, 1op, pfx
                        $mv{all_structfiles_h} .=
                            "#define nm_${macro_name}_pfx(_p,_x) "
                            . "({"
                            . "\\\n\tint __x = (_x);"
                            . "\\\n\tasm volatile("
                            . "\""
                            . "pfx \" #_p \"\\n\\t"
                            . "$opcode %0 ; does $macro_name"
                            . "\" "
                            . "\\\n\t: \"=r\" (__x) "
                            . "\\\n\t: \"0\" (__x)"
                            . ");"
                            . "\\\n\t__x;"
                            . "\\\n\t})\n"
                            ;
                        }
                        if($ci_operands == 2)
                        {
                        # Rw, 2op, no pfx
                        $mv{all_structfiles_h} .=
                            "#define nm_${macro_name}(_x,_y) "
                            . "({"
                            . "\\\n\tint __x = (_x), __y = (_y);"
                            . "\\\n\tasm volatile("
                            . "\""
                            . "mov %%r0,%2\\n\\t"
                            . "$opcode %0 ; does $macro_name"
                            . "\" "
                            . "\\\n\t: \"=r\" (__x) "
                            . "\\\n\t: \"0\" (__x), \"r\" (__y)"
                            . ");"
                            . "\\\n\t__x;"
                            . "\\\n\t})\n"
                            ;
                        }
                        if($ci_operands == 2 and $ci_prefix)
                        {
                        # Rw, 2op, pfx
                        $mv{all_structfiles_h} .=
                            "#define nm_${macro_name}_pfx(_p,_x,_y) "
                            . "({"
                            . "\\\n\tint __x = (_x), __y = (_y);"
                            . "\\\n\tasm volatile("
                            . "\""
                            . "mov %%r0,%2\\n\\t"
                            . "pfx \" #_p \"\\n\\t"
                            . "$opcode %0 ; does $macro_name"
                            . "\" "
                            . "\\\n\t: \"=r\" (__x) "
                            . "\\\n\t: \"0\" (__x), \"r\" (__y)"
                            . ");"
                            . "\\\n\t__x;"
                            . "\\\n\t})\n"
                            ;
                        }
                        }
                    if($ci_ifmt eq "RR")
                        {
                        # |
                        # | RR Instruction, single and dual operand flavors
                        # |
    
                        if($ci_operands == 1)
                        {
                        # RR, 1op, no pfx
                        $mv{all_structfiles_h} .=
                            "#define nm_${macro_name}(_x) "
                            . "({"
                            . "\\\n\tint __x = (_x);"
                            . "\\\n\tasm volatile("
                            . "\""
                            . "$opcode %0,%%r0 ; does $macro_name, %%r0 ignored"
                            . "\" "
                            . "\\\n\t: \"=r\" (__x) "
                            . "\\\n\t: \"0\" (__x)"
                            . ");"
                            . "\\\n\t__x;"
                            . "\\\n\t})\n"
                            ;
                        }
                        if($ci_operands == 1 and $ci_prefix)
                        {
                        # RR, 1op, pfx
                        $mv{all_structfiles_h} .=
                            "#define nm_${macro_name}_pfx(_p,_x) "
                            . "({"
                            . "\\\n\tint __x = (_x);"
                            . "\\\n\tasm volatile("
                            . "\""
                            . "pfx \" #_p \"\\n\\t"
                            . "$opcode %0,%%r0 ; does $macro_name, %%r0 ignored"
                            . "\" "
                            . "\\\n\t: \"=r\" (__x) "
                            . "\\\n\t: \"0\" (__x)"
                            . ");"
                            . "\\\n\t__x;"
                            . "\\\n\t})\n"
                            ;
                        }
                        if($ci_operands == 2)
                        {
                        # RR, 2op, no pfx
                        $mv{all_structfiles_h} .=
                            "#define nm_${macro_name}(_x,_y) "
                            . "({"
                            . "\\\n\tint __x = (_x), __y = (_y);"
                            . "\\\n\tasm volatile("
                            . "\""
                            . "$opcode %0,%2 ; does $macro_name"
                            . "\" "
                            . "\\\n\t: \"=r\" (__x) "
                            . "\\\n\t: \"0\" (__x), \"r\" (__y)"
                            . ");"
                            . "\\\n\t__x;"
                            . "\\\n\t})\n"
                            ;
                        }
                        if($ci_operands == 2 and $ci_prefix)
                        {
                        # RR, 2op, pfx
                        $mv{all_structfiles_h} .=
                            "#define nm_${macro_name}_pfx(_p,_x,_y) "
                            . "({"
                            . "\\\n\tint __x = (_x), __y = (_y);"
                            . "\\\n\tasm volatile("
                            . "\""
                            . "pfx \" #_p \"\\n\\t"
                            . "$opcode %0,%2 ; does $macro_name"
                            . "\" "
                            . "\\\n\t: \"=r\" (__x) "
                            . "\\\n\t: \"0\" (__x), \"r\" (__y)"
                            . ");"
                            . "\\\n\t__x;"
                            . "\\\n\t})\n"
                            ;
                        }

                        next;
                        }
                    }
				}

			my $struct_file_h = $$pel{struct_file_h};

			#
			# Already done this type? NO need for another.
			#

			next if $module_types{$$pel{module_type}};

			# MF: SPR 97265 unix doesn't like empty one...

			if($struct_file_h ne "")
				{
				$module_types{$$pel{module_type}} = 1;
				$mv{all_structfiles_h} .= readFile($struct_file_h);
				}
			}
		}

	$mv{all_structfiles_h} .= "\n";

	# +--------------------------------------
	# | And glom together some nice ptf excerpts to tell a story
	# |
	
		{
		my $pel;
		my $comment_char = "//";

		foreach $pel (sort {$$a{addr_low} <=> $$b{addr_low}} 
                              get_peripherals_and_sw_components ($cel))
			{
			my $table_ref = table_begin();
			my $wsa;
			my $child_count;
			my $child_ref;
			my $i;

			$wsa = get_child_by_path($$pel{module_ref},"WIZARD_SCRIPT_ARGUMENTS");
			$child_count = get_child_count($wsa);

			next if (!$wsa) or (!$child_count);

			$mv{ptf_excerpts} .= "\n\n"
					. $comment_char
					. " ------------------\n"
					. $comment_char
					. " Parameters for "
					. $$pel{module_type}
					. " named "
					. $$pel{module_name}
					. "\n\n";

			for($i = 0; $i < $child_count; $i++)
				{
				$child_ref = get_child($wsa,$i);

				table_addrow($table_ref,$comment_char,
						get_name($child_ref),
						"=",
						get_data($child_ref));
				}

            $mv{ptf_excerpts} .= table_sprint($table_ref);

            my $table2_ref = table_begin();

            if ($$pel{module_type} eq "altera_nios2") 
                {
                # Protect against multiple processors.
                table_addrow($table2_ref,
                  "#ifndef _NIOS2_WSA_");
                table_addrow($table2_ref,
                  "#define _NIOS2_WSA_");

                for($i = 0; $i < $child_count; $i++)
                    {
                    $child_ref = get_child($wsa,$i);
                    my $arg_name = "#define NIOS2_" . uc(get_name($child_ref));
    
                    table_addrow($table2_ref,
                            $arg_name,
                            get_data($child_ref));
                    }

                table_addrow($table2_ref,
                  "#endif /* _NIOS2_WSA_ */");
                }

            $mv{ptf_excerpts} .= table_sprint($table2_ref);
            }
		}
	
	# +--------------------------------------
	# | And emit the darned file
	# |

	my $nios_h = populate_template($nios_h_template,\%mv);

	return $nios_h;
	}






# +------------------------------------
# | generate_excalibur_s_ads
# |
# | return giant string for excalibur.s for ADS assembly
# | for the .../inc directory
# | The caller must pass in the s_defines
# |
# | This is not used for Nios II since it only supports GNU tools.

sub generate_excalibur_s_ads
	{
	my ($g,$cpu_list_element,$s_defines,$do_asm_structs) = @_;
	my $cel = $cpu_list_element;

	my %mv; # variables to substitute into template

	my $nios_s_template = <<EOP;
;
; File: --memory_map_file_name--.s
;
; This file is a machine generated address map
; for a CPU named --cpu_name-- using toolchain "--toolchain--".
; --ptf_name--
; Generated: --date_time--
;
; DO NOT MODIFY THIS FILE
;
; Changing this file will have subtle consequences
; which will almost certainly lead to a nonfunctioning
; system. If you do modify this file, you MUST
; change both --memory_map_file_name--.h,
; --memory_map_file_name--.s, and --memory_map_file_name--.mk identically.
; Or better yet:
;
; DO NOT MODIFY THIS FILE
;
; ex: set tabstop=4:
;

; The Memory Map

--s_defines--

; Structures and Routines For Each Peripheral

--all_structfiles_s--

		END
; end of file
EOP
	



	# +----------------------------------
	# | Fill in the date & name for nios.h
	# |

	$mv{memory_map_file_name} = $$cel{memory_map_file_name};
	$mv{s_defines} = $s_defines;
	$mv{cpu_name} = $$cel{cpu_name};
	$mv{toolchain} = $$cel{toolchain};
	$mv{cpu_architecture} = $$cel{cpu_architecture};
	$mv{date_time} = date_time();
	$mv{ptf_name} = $$g{ptf_name};
	$mv{system_name} = $$g{system_name};

	# +-----------------------------------
	# | Glom together all the struct.h files
	# | using a hash to avoid repeats
	# |
	
		{	
		my %module_types;
		my $pel;

		foreach $pel (sort {$$a{addr_low} <=> $$b{addr_low}} 
                              get_peripherals_and_sw_components ($cel))
			{
			# |
			# | If this module is a custom instruction, emit a macro
			# |

			if($$pel{ci_is_ci})
				{
				my $macro_name = lc($$pel{ci_macro_name});

                if($$cel{cpu_architecture} eq "nios2") 
                    {
                    my $base_addr = lc($$pel{ci_base_addr});

                    $mv{all_structfiles_s} .=
                        "\t.equ\tnp_${macro_name}_n, $base_addr\n";
                    }
                else
                    {
                    my $opcode = lc($$pel{ci_opcode});
    
                    if($$pel{ci_ifmt} eq "Rw")
                        {
                        # |
                        # | Rw Instruction
                        # |
    
                        $mv{all_structfiles_s} .= 
                                  "\t.macro\tnm_$macro_name,_x\n"
                                . "\t$opcode\t\\_x\n"
                                . "\t.endm\n";
                        }
                    elsif($$pel{ci_ifmt} eq "RR")
                        {
                        # |
                        # | RR Instruction
                        # |
    
                        $mv{all_structfiles_s} .= 
                                  "\t.macro\tnm_$macro_name,_x,_y\n"
                                . "\t$opcode\t\\_x,\\_y\n"
                                . "\t.endm\n";
                        }

                    next;
                    }
				}

			my $struct_file_s = $$pel{struct_file_s};

			# |
			# | just once for each type
			# |

			next if $module_types{$$pel{module_type}};

			$module_types{$$pel{module_type}} = 1;
			# MF: SPR 97265 unix doesn't like empty one...
			next if $struct_file_s eq "";
			$mv{all_structfiles_s} .= readFile($struct_file_s);
			}
		}

	$mv{all_structfiles_s} .= "\n";

	# |
	# | After all that, just toss it if we're not
	# | supposed to do them structs
	# |

	if(!$do_asm_structs)
		{
		$mv{all_structfiles_s} = "\n";
		}

	# +--------------------------------------
	# | And emit the darned file
	# |

	my $nios_s = populate_template($nios_s_template,\%mv);

	return $nios_s;
	}





# +------------------------------------
# | generate_excalibur_s
# |
# | return giant string for excalibur.s
# | for the .../lib directory
# | The caller must pass in the s_defines
# |

sub generate_excalibur_s
	{
	my ($g,$cpu_list_element,$s_defines,$do_asm_structs) = @_;
	my $cel = $cpu_list_element;
    my $wsa = get_child_by_path($$cel{cpu_ref},"WIZARD_SCRIPT_ARGUMENTS");

    my $title = "The Memory Map";
    
	my %mv; # variables to substitute into template

	my $nios_s_template = <<EOP;
;
; File: --memory_map_file_name--.s
;
; This file is a machine generated address map
; for a CPU named --cpu_name-- using toolchain "--toolchain--".
; --ptf_name--
; Generated: --date_time--
;
; DO NOT MODIFY THIS FILE
;
; Changing this file will have subtle consequences
; which will almost certainly lead to a nonfunctioning
; system. If you do modify this file, you MUST
; change both --memory_map_file_name--.h,
; --memory_map_file_name--.s, and --memory_map_file_name--.mk identically.
; Or better yet:
;
; DO NOT MODIFY THIS FILE
;
; ex: set tabstop=4:
;

.ifndef _--memory_map_file_name--_
.equ _--memory_map_file_name--_,1
EOP

  if($$cel{cpu_architecture} eq "nios2")
  {
    # For Nios II, GEQU is defined in nios_macros.s.
    $nios_s_template .= <<EOP;
  .include "nios_macros.s"
EOP
  }
  else
  {
    # Define GEQU for non-nios II.
    $nios_s_template .= <<EOP;
  ; minor macro to .equate and .global
  .macro  GEQU sym,val
  .global \\sym
  .equ \\sym,\\val
  .endm
EOP
  }

  $nios_s_template .= <<EOP;

; $title

--s_defines--

	.macro	nm_system_name_string
	.asciz	"--system_name--"
	.endm

	.macro	nm_cpu_name_string
	.asciz	"--cpu_name--"
	.endm

	.macro	nm_monitor_string
	.asciz	"--monitor_string--"
	.endm

	.equ	--cpu_architecture--,1

	.macro	nm_cpu_architecture
	.asciz	"--cpu_architecture--"
	.endm

; Structures and Routines For Each Peripheral

--all_structfiles_s--

.endif ; _--memory_map_file_name--_

; end of file
EOP
	



	# +----------------------------------
	# | Fill in the date & name for nios.h
	# |

	$mv{memory_map_file_name} = $$cel{memory_map_file_name};
	$mv{s_defines} = $s_defines;
	$mv{cpu_name} = $$cel{cpu_name};
	$mv{toolchain} = $$cel{toolchain};
	$mv{cpu_architecture} = $$cel{cpu_architecture};
	$mv{date_time} = date_time();
	$mv{ptf_name} = $$g{ptf_name};
	$mv{system_name} = $$g{system_name};
	$mv{monitor_string} = get_data_by_path($$cel{cpu_ref},"WIZARD_SCRIPT_ARGUMENTS/germs_monitor_id");
	$mv{monitor_string} = "(missing)" if $mv{monitor_string} eq "";

	# +-----------------------------------
	# | Glom together all the struct.h files
	# | using a hash to avoid repeats
	# |
	
		{	
		my %module_types;
		my $pel;

		foreach $pel (sort {$$a{addr_low} <=> $$b{addr_low}} 
                              get_peripherals_and_sw_components($cel))
			{
			# |
			# | If this module is a custom instruction, emit a macro
			# |

            if($$pel{ci_is_ci})
                {
                my $macro_name = lc($$pel{ci_macro_name});

                if($$cel{cpu_architecture} eq "nios2") 
                    {
                    my $base_addr = lc($$pel{ci_base_addr});

                    $mv{all_structfiles_s} .=
                        "\t.equ\tnp_${macro_name}_n, $base_addr\n";
                    }
                else
                    {
                    my $opcode = lc($$pel{ci_opcode});
    
                    if($$pel{ci_ifmt} eq "Rw")
                        {
                        # |
                        # | Rw Instruction
                        # |
    
                        $mv{all_structfiles_s} .= 
                                  "\t.macro\tnm_$macro_name,_x\n"
                                . "\t$opcode\t\\_x\n"
                                . "\t.endm\n";
                        }
                    elsif($$pel{ci_ifmt} eq "RR")
                        {
                        # |
                        # | RR Instruction
                        # |
    
                        $mv{all_structfiles_s} .= 
                                  "\t.macro\tnm_$macro_name,_x,_y\n"
                                . "\t$opcode\t\\_x,\\_y\n"
                                . "\t.endm\n";
                        }
    
                    next;
                    }
				}

			my $struct_file_s = $$pel{struct_file_s};

			# |
			# | just once for each type
			# |

			next if $module_types{$$pel{module_type}};

			$module_types{$$pel{module_type}} = 1;
			# MF: SPR 97265 unix doesn't like empty one...
			next if $struct_file_s eq "";
			$mv{all_structfiles_s} .= readFile($struct_file_s);
			}
		}

	$mv{all_structfiles_s} .= "\n";

	# |
	# | After all that, just toss it if we're not
	# | supposed to do them structs
	# |

	if(!$do_asm_structs)
		{
		$mv{all_structfiles_s} = "";
		}

	# +--------------------------------------
	# | And emit the darned file
	# |

	my $nios_s = populate_template($nios_s_template,\%mv);

	# |
	# | swap in the gnu line comment character
	# |

	if($$cel{gnu_as_lcc} ne "")
		{
		$nios_s =~ s/;/$$cel{gnu_as_lcc}/gm;
		}

	return $nios_s;
	}



# +-----------------------------------
# | emit_sdk(globals *g,cpu_list_element *)
# |
# | generate the files that go into the SDK, now
# | that all the data has been gathered.
# |
# | This includes nios.h and nios.s,
# | a Makefile for the library,
# | and the union of all the files for each peripheral
# |

sub emit_sdk
	{
	my ($g,$cpu_list_element) = @_;
	my $cel = $cpu_list_element;
	my $address_map_h_ref;
	my $address_map_s_ref;
	my $address_map_ads_s_ref;
	my $peripheral_list_ref;
	my $pel;
	my $addr_width;

	$peripheral_list_ref = $$cel{peripheral_list};

	# +------------------------------------------
	# | 0. Decide which parts of the sdk to generate.
	# | for Nios, to them all. For everyone else, for now,
	# | do only the .inc directory.
	# |
	# | And, for that matter, make up a name for the
	# | include file, here, too.
	# |
	my $do_inc = $$cel{do_inc};
	my $do_rest_of_sdk = $$cel{do_rest_of_sdk};

	# +----------------------------------------------
	# | 1. Copy over the union of all the files for each peripheral
	# | If multiple peripherals have files of the same name, only
	# | the first one is used.
	# |

	print_command "Copying Files for $$cel{cpu_name}";

	my %file_list_union; # we hash by filename key
	my $sdk_dir = $$cel{sdk_dir};

	# |
	# | Make the directory <cpu_name>_sdk
	# | also, the lib directory, since we
	# | know it's needed for a Makefile
	# | also, the inc directory, since we
	# | build nios.s and nios.h right here
	# |

	if($sdk_dir =~ /^(.*)\/([^\/]*)$/)
		{
		ensure_directory($1,$2) or die;
		ensure_directory($sdk_dir,"lib") if $do_rest_of_sdk;
		ensure_directory($sdk_dir,"src") if $do_rest_of_sdk;
		ensure_directory($sdk_dir,"inc") if $do_inc;
		}

	# |
	# | Copy files for each peripheral as needed
	# |
	# | TPA 10/31/2002:
        # |  We do this same thing for software components, too
        # | 

        my @component_list = get_peripherals_and_sw_components ($cel);
	if($do_rest_of_sdk)
		{
		foreach $pel (sort {$$a{addr_low} <=> $$b{addr_low}} @component_list)
			{
			my $file_list = $$pel{file_list};
			my $file;
                        mcs_dprint ("copying files for $$pel{module_name}");
	
			if($file_list)
				{
				foreach $file (sort(@$file_list))
					{
					my $src_dir; # copy file from here
					my $dst_frag; # copy to <cpusdk>/this

					# |
					# | Use some whacky and awful || to delimit
					# | the break in the source dir and the file copied
					# | (sorry -- dvb)

					($src_dir,$dst_frag) = split(/\|\|/,$file,2);

					next if $file_list_union{$file};
					$file_list_union{$dst_frag} = 1;
	
					# |
					# | for each file, make sure its destination directory
					# | has been created in the sdk
					# |
	
					if($dst_frag =~ /^(.*)\/([^\/]*)$/)
						{
                        ensure_directory($sdk_dir,$1) or die;
                        my $comment_char = "";

                        if($dst_frag =~ /^.*\.s$/) # asm file?
                            {
                            $comment_char = $$cel{gnu_as_lcc};
                            };

                        maybe_copy_file
                                (
                                "$src_dir/$dst_frag",
                                "$sdk_dir/$dst_frag",
                                $comment_char
                                );
						}
					}
				}
			}
		}

	$$cel{file_list} =
			[
			sort(keys(%file_list_union)),
			"inc/$$cel{memory_map_file_name}.h",
			"inc/$$cel{memory_map_file_name}.s"
			];
	

	# +-----------------------------------------------
	# | 2. Generate the memory maps, right here.
	# |

	print_command "Generating Memory Map for $$cel{cpu_name}";

	$addr_width = $$cpu_list_element{cpu_data_width} == 16 ? 4 : 8;

	$address_map_h_ref = table_begin;
	$address_map_s_ref = table_begin;
	$address_map_ads_s_ref = table_begin;

	foreach $pel (sort {$$a{addr_low} <=> $$b{addr_low}} @$peripheral_list_ref)
		{

		# |
		# | If, somehow (like it's a swlib) we got no addr_low, skip this
		# |
		next if $$pel{addr_low} eq "";
	
		my $is_void = $$pel{struct_type} eq "";
		my $struct_type = $is_void ? "void *" : $$pel{struct_type};
		my $addr_low_string = sprintf("0x%0${addr_width}x",$$pel{addr_low});
		my $addr_high_string = $is_void ? sprintf("0x%0${addr_width}x",
				$$pel{addr_low} + $$pel{addr_span}) : ""; 
		my $addr_size_string = $is_void ? sprintf("0x%0${addr_width}x",
				$$pel{addr_span}) : ""; 

		table_addrow
				(
				$address_map_h_ref,
				"#define",
				$$pel{symbol_name},
				"(($struct_type)",
				"$addr_low_string)",
				"// $$pel{module_type}"
				);

		table_addrow
				(
				$address_map_h_ref,
				"#define",
				"$$pel{symbol_name}_base",
				"",
				"$addr_low_string"
				);

		table_addrow
				(
				$address_map_s_ref,
				"\tGEQU",
				$$pel{symbol_name},
				",",
				"$addr_low_string",
				";",
				$$pel{module_type}
				);

		table_addrow
				(
				$address_map_ads_s_ref,
				$$pel{symbol_name},
				"EQU",
				"$addr_low_string",
				";",
				$$pel{module_type}
				);

		if($addr_high_string)
			{
			table_addrow
					(
					$address_map_h_ref,
					"#define",
					$$pel{symbol_name} . "_end",
					"(($struct_type)",
					"$addr_high_string)"
					);

			table_addrow
					(
					$address_map_h_ref,
					"#define",
					$$pel{symbol_name} . "_size",
					"",
					"$addr_size_string"
					);

			table_addrow
					(
					$address_map_s_ref,
					"\tGEQU",
					$$pel{symbol_name} . "_end",
					",",
					"$addr_high_string"
					);

			table_addrow
					(
					$address_map_s_ref,
					"\tGEQU",
					$$pel{symbol_name} . "_size",
					",",
					"$addr_size_string"
					);

			table_addrow
					(
					$address_map_ads_s_ref,
					$$pel{symbol_name} . "_end",
					"EQU",
					"$addr_high_string"
					);
			}

		if($$pel{irq_number} ne "")
			{
			table_addrow
					(
					$address_map_h_ref,
					"#define",
					$$pel{symbol_name} . "_irq",
					"",
					$$pel{irq_number}	
					);

			table_addrow
					(
					$address_map_s_ref,
					"\tGEQU",
					$$pel{symbol_name} . "_irq",
					",",
					$$pel{irq_number}
					);

			table_addrow
					(
					$address_map_ads_s_ref,
					$$pel{symbol_name} . "_irq",
					"EQU",
					$$pel{irq_number}
					);
			}
		}

	# +-------------------------------------------
	# | 3. call out for the cpu constants
	# | (nasys_printf_uart, &c)
	# |

	fill_in_cpu_constants($g,$cel);

	my $ccr = $$cel{constant_list};
	my $i;

	table_addrow($address_map_h_ref," ");
	table_addrow($address_map_s_ref," ");
	table_addrow($address_map_ads_s_ref," ");

	for($i = 0; $i <= $#$ccr; $i++)
		{
		my $cr = $$ccr[$i];
	
		if($$cr{type})
			{
			table_addrow($address_map_h_ref,
					"#define",
					$$cr{name},
					"((".$$cr{type}." *)",
					$$cr{value}.")");
			}
		else
			{
			table_addrow($address_map_h_ref,
					"#define",
					$$cr{name},
					"",
					$$cr{value});
			}

		if(!$$cr{no_asm})
			{
			table_addrow($address_map_s_ref,
					"\tGEQU",
					$$cr{name},
					",",
					$$cr{value});

			table_addrow($address_map_ads_s_ref,
					$$cr{name},
					"EQU",
					$$cr{value});
			}

		if($$cr{irq})
			{
			table_addrow($address_map_h_ref,
					"#define",
					$$cr{name}."_irq",
					"",
					$$cr{irq});

			if(!$$cr{no_asm})
				{
				table_addrow($address_map_s_ref,
						"\tGEQU",
						$$cr{name}."_irq",
						",",
						$$cr{irq});

				table_addrow($address_map_ads_s_ref,
						$$cr{name}."_irq",
						"EQU",
						$$cr{irq});
				}
			}
		if($$cr{span})
			{
			table_addrow($address_map_h_ref,
					"#define",
					$$cr{name}."_size",
					"",
					$$cr{span});

			if(!$$cr{no_asm})
				{
				table_addrow($address_map_s_ref, "\tGEQU", $$cr{name}."_size", ",", $$cr{span});
				table_addrow($address_map_ads_s_ref, $$cr{name}."_size", "EQU", $$cr{span});
				}
			}
		if($$cr{end})
			{
			if($$cr{type})
				{
				table_addrow($address_map_h_ref,
						"#define",
						$$cr{name}."_end",
						"((".$$cr{type}." *)",
						$$cr{end}.")");
				}
			else
				{
				table_addrow($address_map_h_ref, "#define", $$cr{name}."_end","", $$cr{end});
				}
			if(!$$cr{no_asm})
				{
				table_addrow($address_map_s_ref, "\tGEQU", $$cr{name}."_end", ",", $$cr{end});
				table_addrow($address_map_ads_s_ref, $$cr{name}."_end", "EQU", $$cr{end});
				}
			}
		}

	# +------------------------------------------
	# | 4. Add all the constants from peripherals
	# | to the constant tables, too.
	# |

	my $cr;

	table_addrow($address_map_h_ref," ");
	table_addrow($address_map_s_ref," ");
	table_addrow($address_map_ads_s_ref," ");

	foreach $cr (@{$$cel{pel_constant_list}})
		{
		table_addrow($address_map_h_ref,
				"#define",
				$$cr{name},
				"",
				$$cr{value},
				$$cr{comment} ? "// $$cr{comment}" : "");

		table_addrow($address_map_ads_s_ref,
				$$cr{name},
				"EQU",
				$$cr{value},
				$$cr{comment} ? "; $$cr{comment}" : "");

		table_addrow($address_map_s_ref,
				"\t.equ",
				$$cr{name},
				",",
				$$cr{value},
				$$cr{comment} ? "; $$cr{comment}" : "");
		}
	
	# +-------------------------------------------
	# | Generate the library Makefile
    # |
    # | (but only for gnu toolchains, if any)
	# |

  if($$cel{do_build_sdk} and $$cel{toolchain} eq "gnu")
  {
    # HACK ALERT
    if($$cel{cpu_architecture} eq "nios2")
    {
      print_command
        "Generating Makefile, excalibur.mk and " .
        "$$cel{memory_map_file_name}.h for $$cel{cpu_name}";
        my $makefile_contents = 
          generate_nios2_makefile($g,$cpu_list_element);
        maybe_write_file("$sdk_dir/lib/Makefile",$makefile_contents);

        my $excalibur_mk_contents = 
          generate_nios2_excalibur_mk($g,$cpu_list_element);
        maybe_write_file("$sdk_dir/inc/excalibur.mk",$excalibur_mk_contents);
    }
    else
    {
      print_command
        "Generating Makefile and $$cel{memory_map_file_name}.h " .
        "for $$cel{cpu_name}";
      my $makefile_contents = generate_makefile($g,$cpu_list_element);
      maybe_write_file("$sdk_dir/lib/Makefile",$makefile_contents);
    }
 }

# +-------------------------------------------
# | Generate excalibur.h and excalibur.s and sdk_info.ptf
# |
	    {
	    my $h_defines = table_sprint($address_map_h_ref);
		my $excalibur_h_contents = 
	      generate_excalibur_h($g,$cpu_list_element,$h_defines);
		maybe_write_file("$sdk_dir/inc/$$cel{memory_map_file_name}.h",$excalibur_h_contents);
	
	# |
	# | Emit the historical files
	# |
	maybe_write_file("$sdk_dir/inc/nios.h",$g_old_nios_h);
		maybe_write_file("$sdk_dir/inc/nios.s",$g_old_nios_s,$$cel{gnu_as_lcc});
	
		# +------------------------------
		# | Which asm file should we secrete?
		# |
	
		if($$cpu_list_element{toolchain} eq "gnu")
			{
			my $s_defines = table_sprint($address_map_s_ref);
			my $excalibur_s_contents = generate_excalibur_s
				(
				$g,
				$cpu_list_element,
				$s_defines,
				$do_rest_of_sdk
				);
			maybe_write_file
				(
				"$sdk_dir/inc/$$cel{memory_map_file_name}.s",
				$excalibur_s_contents,
	            $$cel{gnu_as_lcc}
				);
			}
		elsif ($$cpu_list_element{toolchain} eq "ads")
			{
			# |
			# | Emit the ADS assembly equates file
			# |
	
			my $ads_s_defines = table_sprint
				(
				$address_map_ads_s_ref
				);
	
			my $excalibur_ads_s_contents = generate_excalibur_s_ads
				(
				$g,
				$cpu_list_element,
				$ads_s_defines,
				$do_rest_of_sdk
				);
	
			maybe_write_file
				(
				"$sdk_dir/inc/$$cel{memory_map_file_name}.s",
				$excalibur_ads_s_contents
				);
			}
	
		$$cel{test_code_file_name} = generate_test_code_routine($g,$cel);
		}
    }


# +----------------------------------------------------
# | gather_file_list(globals *g)
# |
# | print out a list of files produced.
# |

sub gather_file_list
	{
	my ($g) = (@_);
	my @file_list;

	#my $cpu_list = $$g{cpu_list};
	my $cel;
	my $sdk_dir;
	my $file;

	mcs_dprint "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
	mcs_dprint "% FILE LIST";
    if($$g{do_generate_sdk})
        {
        foreach $cel (sort(@{$$g{cpu_list}}))
            {
            mcs_dprint "% CPU named $$cel{cpu_name}";
            $sdk_dir = $$cel{sdk_dir};

            push(@file_list,"$sdk_dir/lib/", 
                         "$$cel{cpu_name} library files");
            push(@file_list,"$sdk_dir/inc/", 
                         $$cel{cpu_name}.
                           " include files such as memory maps"
                         );
            push(@file_list,"$sdk_dir/src/", 
                         $$cel{cpu_name}. " example programs"
                         );

            mcs_dprint "% directory $$cel{sdk_dir}";
            }
        }
	mcs_dprint "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n";
	mcs_dprint "%\n";

	return \@file_list;
	}




# +------------------------------------------------------
# | emit_quartus_tcl_script(globals *g,cpu *cel)
# |
# | generate a set of commands for loading up the quartus
# | software mode project for the particular CPU's
# | sdk. (CPU is cross of cpu and toolchain, these-a-days.)
# |

sub emit_quartus_tcl_script
	{
	my ($g,$cel) = (@_);
	my $i;

	my $sdk_cpu_ptf = get_child_by_path(get_class_ptf($g,$$cel{module_type},'verbose'),
			"CLASS $$cel{module_type}/SDK_GENERATION/CPU");

	my $qts_ptf;

	# |
	# | Find which TCL generation section matches our toolchain
	# | and also matches the cpu_architecture. Either one missing
	# | from the TCL section means "match anyhow".
	# | (Maybe print an apology and do nothing.)
	# |
		{
		my $qts_count = get_child_count($sdk_cpu_ptf,"QUARTUS_TCL_SCRIPT");

		for($i = 0; $i < $qts_count; $i++)
			{
			$qts_ptf = get_child($sdk_cpu_ptf,$i,"QUARTUS_TCL_SCRIPT");
			my $t = get_data_by_path($qts_ptf,"toolchain");
			my $c = get_data_by_path($qts_ptf,"cpu_architecture");
			if
					(
						($t eq "" or $t eq $$cel{toolchain})
						and
						($c eq "" or $c eq $$cel{cpu_architecture})
					)
				{
				last;
				}
			$qts_ptf = "";
			}

		if(!$qts_ptf)
			{
			# SPR 112223 dvb 2002 // print_command ("(No TCL script for toolchain $$cel{toolchain}, architecture $$cel{cpu_architecture})");
			return;
			}
		}

	# | $qts_ptf is now the QUARTUS_TCL_SCRIPT section for us to use
	# | Set up the template, and populate using $qts_ptf.

	my $exclude_lib_files = get_data_by_path($qts_ptf,"exclude_lib_files");

	my $s; # the script
	my $file_name = "make_quartus_sw_project.tcl";

	my $quartus_base_name = $$g{projectname};

	if($quartus_base_name =~ /^(.*)\.quartus$/)
		{
		$quartus_base_name = $1;
		}

	my $tcl_template = <<EOP;
# File: --file_name--
#
# This is a machine-generated script to
# populate a Quartus Software Mode Project
# with the appropriate files.
#
# Generated: --date--
# CPU: --cpu_name--
# Toolchain: --toolchain--
# Quartus Project: --projectname--
# SDK Directory: --sdk_directory--
#

puts "#"
puts "# This script is setting up Quartus Software Mode"
puts "# CPU: %cpu_name%"
puts "# Toolchain: %toolchain%"
puts "# Quartus Project: %projectname%"
puts "# SDK Directory : %sdk_directory%"
puts "#"

#
# If the sdk_directory doesn't exist, this tcl script
# was probably built on a different computer
#

if {![file exists "%sdk_directory%"]} then {
		puts "#=========================================="
		puts "# ERROR: Directories appear to have moved!"
		puts "#        You must regenerate the SDK"
		puts "#        in SOPC Builder for this script"
		puts "#        to work on this computer."
		puts "#"
		return -1
	}

# First, remove all software assignments


puts "# Removing all software files from project"

set a [project get_all_assignments "" "" "" ""]
foreach z \$a {
	set z3 [lindex \$z 3]
	set z4 [lindex \$z 4]
	if {\$z3 == "C_FILE" 
		|| \$z3 == "CPP_FILE"
		|| \$z3 == "ASM_FILE"
		|| \$z3 == "CPP_INCLUDE_FILE"} then {
		project remove_assignment "" "" "" "" \$z3 \$z4
		}
	}


# Then, add back in the new ones

puts "# Adding in library and header files to project..."

--library_files--

# Setup for --toolchain--

puts "# Setting build options..."

#
# Roundabout way to remove the
# "Release" target
#

if {![project swb_exists Release]} {
	project create_swb Release;
}
project set_active_swb Release;
project remove_assignment "" "" "" "" "SOFTWARE_SETTINGS" "Release"

#
# Software Build Assignments for Debug
# Make sure there is a Debug target
#

if {![project swb_exists Debug]} {
	project create_swb Debug;
}
project set_active_swb Debug;

--tcl_commands--

puts "# Added --library_file_count-- library and header files."
puts "# To reduce code footprint, you may remove unused libraries manually."
puts "# (You must still provide a main routine.)"
puts "# Bye."

# End of file
EOP

	my %mv;

	$mv{file_name} = $file_name;
	$mv{date} = date_time();
	$mv{cpu_name} = $$cel{cpu_name};
	$mv{cpu_architecture} = $$cel{cpu_architecture};
	$mv{toolchain} = $$cel{toolchain};
	$mv{projectname} = $quartus_base_name;
	$mv{sopc_directory} = $$g{sopc_directory};
	$mv{sdk_directory} = $$cel{sdk_dir};

	$mv{library_files} = "\n";
	$mv{tcl_commands} = "\n";

    #Add environment variable substitutions
    $mv{ALTERA_ARM9GP_HOST} = $ENV{ALTERA_ARM9GP_HOST};
    $mv{ALTERA_ARM9GP_ROOT} = $ENV{ALTERA_ARM9GP_ROOT};
    $mv{ALTERA_ARM9GP_VER} = $ENV{ALTERA_ARM9GP_VER};

	my $tcl_commands = "";
	my $library_files = "";
	my $library_file_count = 0;
	my $file;
	my $qq = '""';

	# |
	# | Make the file list, omitting src
	# | files and excluded files
	# |

	foreach $file (sort(@{$$cel{file_list}}))
		{
		my $file_type = "";

		# |
		# | Don't include any "src/..." files.
		# | Those are the ones with main() in 'em.
		# |


		# | Dont use if it's in the src directory

		next if($file =~ /^src\//);

		# | Dont use if it's in the exclude_lib_files list

		my $file_base;
		$file_base = $1 if($file =~ /^.*?([^\/]*)$/);

		my $each_exc;
		foreach $each_exc (split(/[,;+]/,$exclude_lib_files))
			{
			$file_base = "" if($file_base eq $each_exc);
			}
		next if !$file_base;


		if($file =~ /\.c$/)
			{
			$file_type = "C_FILE";
			}
		elsif($file =~ /\.cpp$/)
			{
			$file_type = "CPP_FILE";
			}
		elsif($file =~ /\.s$/)
			{
			$file_type = "ASM_FILE";
			}
		elsif($file =~ /\.h$/)
			{
			$file_type = "CPP_INCLUDE_FILE";
			}

		if($file_type ne "")
			{
			$library_files .= "project add_assignment $qq $qq $qq $qq \"$file_type\" \"$$cel{sdk_dir_name}/$file\";\n";
			$library_file_count++;
			}
		else
			{
			$library_files .= "# unknown file type for: $file\n";
			}
		}

	# |
	# | Generate more TCL commands from
	# | the cpu and toolchain specific assignments
	# | in the class.ptf file
	# |

	my $a_count = get_child_count($qts_ptf,"SWB_ASSIGNMENT");

	for($i = 0; $i < $a_count; $i++)
		{
		my $asn_ptf = get_child($qts_ptf,$i,"SWB_ASSIGNMENT");
		my $z1 = get_data_by_path($asn_ptf,"name");
		my $z2 = get_data_by_path($asn_ptf,"value");

		$tcl_commands .= "swb add_assignment $qq $qq $qq \"$z1\" \"$z2\"\n";
		}

	$mv{tcl_commands} .= $tcl_commands;
	$mv{library_files} .= $library_files;
	$mv{library_file_count} = $library_file_count;

		{
		my $result;

		# |
		# | and swap in the gcc version, for library findings
		# |
		$mv{gcc_version} = "GCC_IS_MISSING";

		my $gcc = "$$cel{gnu_tools_prefix}-gcc";
		$result = do_sh_command($g,"which $gcc 2> /dev/null > /dev/null");
		if($result == 0)
			{
			$mv{gcc_version} = do_sh_command($g,"$gcc --version",1);
			}
		}

	my $tcl_file = populate_template($tcl_template,\%mv);

	maybe_write_file("$$cel{sdk_dir}/$file_name",$tcl_file);

	print_command "Wrote $$cel{toolchain} tcl script for $$cel{cpu_name}";
	}

# -------------------------------------------------
#
# Necessary inputs:
#	--sopc_directory=dir   complete path to directory containing jnioswizard & siblings
#	--system_name=name     name of the system; add .ptf for the file we need
#	--system_directory=dir path to the ptf file
#       --nios_cpu=name        which cpu to master
#
# Optional inputs:
#       --sopc_lib_path=dir[(+dir)*]
#                              list of directories for components
#       --debug=1 (or 0)       turn on debug print messages. defaults to off.

sub mk_custom_sdk
	{
	print_command "mk_custom_sdk starting";
	my %g; # global state that gets passed around
	my %switches; # command line arguments
	my $result;

	my $file_list_ref_ref = shift; # to return the file list...


	%switches = parseArgs(@_);

	$gDebug = getSwitch(\%switches,"debug",$gDebug);
	mcs_dprint "==========(debug on)===========";

if($gDebug)
	{
	my $key;
	my $value;

	mcs_dprint " ";
	foreach $key (sort(keys(%switches)))
		{
		$value = $switches{$key};
		mcs_dprint "parameter: $key = $value";
		}
	mcs_dprint " ";
	}

	$g{projectname} = getSwitch(\%switches,"projectname");
	$g{sopc_directory} = getSwitch(\%switches,"sopc_directory",$ENV{sopc_builder});
	$g{system_name} = getSwitch(\%switches,"system_name",getSwitch(\%switches,0,""));
	$g{system_directory} = getSwitch(\%switches,"system_directory",".");
	$g{sopc_lib_path} = getSwitch(\%switches,
			"sopc_lib_path",
            "$ENV{SOPC_BUILDER_PATH}"
			. "+"
			. $g{sopc_directory} . "/components"
            );

	$g{build_library} = getSwitch(\%switches,"build_library",1);

	# |
	# | If there's no system name specified, do a DIR locally
	# | and use the last PTF file found
	# |
	# | Furthermore, find a quartus project to use, too.
	# |
	# | All this does an adequate quessing-job if you just
	# | type "mk_custom_sdk" on the command line, in your
	# | quartus project directory.
	# |

	if(!$g{system_name})
		{
		my $file;
		my @files;

		opendir(DIR, ".");
		@files = readdir(DIR);
		closedir(DIR);
		foreach $file (@files)
			{
			# | Use a PTF file we found, if we dont have one...

			$g{system_name} = $file if($file =~ /.*\.ptf$/);

			# | And if no ptf file is specified, find a nearby .quartus file, too
	
			if(!$g{projectname})
				{
				$g{projectname} = $file if($file =~ /.*\.quartus$/);
				}
			}
		$g{projectname} = "MISSING PROJECT NAME" if !$g{projectname};


		if($g{system_name} ne "")
			{
			print_command "Using ptf file ".$g{system_name}.".";
			}
		else
			{
			die "No system name or ptf file specified or found.";
			}
		}

	# |
	# | Allow "system name" to be the name of a ptf file.
	# | Strip off ".ptf" if it is there.
	# |

	if($g{system_name} =~ /^(.*)\.ptf$/)
		{
		$g{system_name} = $1;
		}
	
	# |
	# | Add .ptf to the system name to get the ptf name, ha ha.
	# |

	$g{ptf_name} = $g{system_directory} . "/" . $g{system_name} . ".ptf";

    $g{output_directory} = getSwitch(\%switches,
            "output_directory",
            $g{system_directory});

	# |
	# | Read in the PTF file
	# |
	print_command "Reading project $g{ptf_name}.";

	$g{ptf_ref} = read_ptf($g{ptf_name});

	# |
	# | Decide if we're really going to build an SDK, or
	# | the various ROM contents
	# |

	$g{software_only} = getSwitch(\%switches,"software_only","");
	if($g{software_only} == 0) # missing or set to zero
		{
		# no command line switch "software only"
		$g{do_generate_sdk} = get_data_by_path($g{ptf_ref},"WIZARD_SCRIPT_ARGUMENTS/generate_sdk");
		$g{do_generate_contents} = $g{do_generate_sdk};
		}
	else
		{
		$g{do_generate_sdk} = 0;
		$g{do_generate_contents} = 1;
		}

    # |
    # | More complications: let command-line switch force
    # | sdk-generation. Oh, the permutations are tricky,
    # | but at least we do them all up here, right? -- dvb2003
    # |

    $g{do_generate_sdk} = getSwitch(\%switches,
            "do_generate_sdk",
            $g{do_generate_sdk});
    $g{do_generate_contents} = getSwitch(\%switches,
            "do_generate_contents",
            $g{do_generate_contents});

	# |
	# | Make a list of CPU's
	# |

	print_command "Finding all CPUs";
	find_cpus(\%g);

	# |
	# | Add a list of peripherals for each CPU
	# |

	print_command "Finding all peripherals";
	find_peripherals(\%g);

	# |
	# | Add a list of software components for each CPU
	# |

	print_command "Finding software components";
	find_software_components(\%g);

	# |
	# | For each cpu, examine each peripheral in it
	# | and add the address span, symbolic names,
	# | list of library files, and so forth
	# |
	# | (This could be in find_peripherals, it's
	# | just broken out for granularity.)
	# |

	examine_each_peripheral(\%g);

	# |
	# | And for each CPU, emit
	# | a fully-formed sdk now,
	# | but only if do_generate_sdk.
	# |

	my $cel; # we'll keep reusing this one

	if($g{do_generate_sdk})
		{
		foreach $cel (@{$g{cpu_list}})
			{
			print_command "Generating $$cel{toolchain} SDK for $$cel{cpu_name}";
			emit_sdk(\%g,$cel);
			}
		}
	else
		{
		print_command "(Legacy SDK Generation Skipped)";
		}

	# |
	# | Spew TCL Scripts galore
	# |

	if($g{do_generate_sdk})
		{
		my $cel;
		my $g = \%g;
		foreach $cel (@{$g{cpu_list}})
			{
			emit_quartus_tcl_script($g,$cel);
			}
		}
	else
		{
		print_command "(All TCL Script Generation Skipped)";
		}

	# |
	# | And for each CPU, maybe, just maybe,
	# | build the library into a .a file.
        # |
        # | TPA 10/31/2002: This also ends up making any 
        # |  peripherals (or software components) that have a 
        # |  defined "makefile" setting, whether or not they
        # |  have "gnu" as their toolchain.
	# |

   if($g{do_generate_sdk})
      {
         foreach $cel (@{$g{cpu_list}})
            {
               if($g{build_library}
                   and $$cel{do_rest_of_sdk}
                   and $$cel{do_build_sdk})
               {
                 # TPA: We only try to build CPU libraries for GNU
                 # toolchains.  This seems pretty conservative, but
                 # there you go.

                 build_library(\%g,$cel) if $$cel{toolchain} eq "gnu";
                 
                 # For each software-only peripheral, look for a generator program,
                 # and run it if present.

                 my $cpu_name = get_data($cel->{cpu_ref});
                 foreach my $sel (@{$cel->{software_component_list}})
                 {
                    my $class_dir = get_class_ptf(\%g,$sel->{module_type},'verbose');
                    my $class_ptf = get_class_ptf(\%g,$sel->{module_type},'verbose');
                    
                    my $gen_prog_path = "CLASS $sel->{module_type}/" .
                       "ASSOCIATED_FILES/Generator_Program";

                    my $gen_prog = &get_data_by_path($class_ptf, $gen_prog_path);

                    # No generator program? We're done with this component.
                    next if
                      $gen_prog eq "" or
                      $gen_prog eq "--none--" or
                      $gen_prog eq "--default--";

                    # We require generator programs to be perl scripts, just
                    # like hardware generator programs.
                     if ($gen_prog !~ /\.pl$/)
                     {
                        return
                           "Illegal Generator program '$gen_prog' " .
                           "for $sel->{module_type}: " .
                           "Generator programs must be perl-scripts.\n"
                     }
                     my @cmd = (
                        "$ENV{SOPC_PERL}/bin/perl" ,
                        "-I$g{sopc_directory}/bin" ,
                        "-I$g{sopc_directory}/bin/europa" ,
                        "-I$g{sopc_directory}/bin/perl_lib" ,
                        "$class_dir/$gen_prog"
                        );
                     # TBD: pass $ENV{SOPC_PERL_LIB} to account for kit/system-specific libs

                     push(@cmd,"--system_name=$g{system_name}");
                     push(@cmd,"--system_directory=$g{system_directory}");
                     push(@cmd,"--sopc_directory=$g{sopc_directory}");
                     push(@cmd,"--target_module_name=$sel->{module_name}");
                     push(@cmd,"--custom_sdk_directory=$g{system_directory}/" .  "${cpu_name}_sdk/");
                     push(@cmd,"--generate=1");
                     push(@cmd,"--cpu_name=$cpu_name");
                     push(@cmd,"--module_lib_dir=$class_dir");

                     &Progress ("Running Generator Program for $sel->{module_name}");
                     open (ABRAHAM_LINCOLN_STEALTH, "");
                     close ABRAHAM_LINCOLN_STEALTH;
                     my $error_code = &System_Win98_Safe (\@cmd);
                     open (ABRAHAM_LINCOLN_NO_STEALTH, "");
                     close ABRAHAM_LINCOLN_NO_STEALTH;

                     if ($error_code != 0)
                     {
                        return ("
                           Error: Generator program 
                           for module '$sel->{module_name}' did NOT run successfully.\n".
                           "generator cmd was '@cmd'\n");
                     }
                 }

                 # TPA 11/1/2002:  Loop through all the peripherals
                 # and find the ones that have a defined makefile.
                 # Run the makefiles for 
                 #
                 foreach my $pel (get_peripherals_and_sw_components($cel))
                 {
                    # Only do this for folks with Makefiles.
                    next unless $pel->{makefile};
                    
                    # If you have a makefile, you're required to say 
                    # where it is.
                    $pel->{make_dir} or die 
                        "No make-directory given for $$pel{module_name}";

                    run_make (\%g, 
                              $cel->{sdk_dir},
                              $pel->{make_dir}, 
                              $pel->{makefile},
                              $pel->{make_target});
                 }
               }
           }
        }
        else
        {
           print_command "(No Libraries Built)";
        }


	# |
	# | Then, for each cpu, build any memory contents
	# | that they might want.
	# |

	if($g{do_generate_contents})
		{
		my $i;
		my $cpu_list_ref = $g{cpu_list};

		for($i = 0; $i <= $#$cpu_list_ref; $i++)
			{
			my $cel = $$cpu_list_ref[$i];
			$result = build_peripheral_contents(\%g,$cel);

			if($result)
				{
				return "ERROR: Could not build Peripheral Contents for $$cel{cpu_name}";
				}
			}
		}
	else
		{
		print_command "(Contents Generation Skipped)";
		}

	# |
	# | And print out even more stuff & junk if
	# | gDebug is set.
	# |

	if($gDebug)
		{
		print "\n\n------\n";
		my $i;
		my $cpu_ref;
		my $cpu_name;
		my $cpu_data;

		for($i = 0; $i <= $#{$g{cpu_list}}; $i++)
			{
			$cpu_ref = ${$g{cpu_list}}[$i];
			$cpu_name = get_name($$cpu_ref{cpu_ref});
			$cpu_data = get_data($$cpu_ref{cpu_ref});
			print "% cpu number $i: $cpu_name $cpu_data\n";

			my $cel = $cpu_ref;

			my $f;

			foreach $f (@{$$cel{file_list}})
				{
				print "     cpu $cpu_name named $cpu_data has $f.\n";
				}
			}
		undef $g{ptf_ref};
		#ptf_PrintRef(\%g);
		print "\n\n------\n";
		}



	if (ref($file_list_ref_ref) eq "SCALAR")
		{
		$$file_list_ref_ref = gather_file_list(\%g);
		}

	print_command "mk_custom_sdk finishing";
	return "";
	}

# ----------------------------
# The Body
#

	return "ok";


# end of file

