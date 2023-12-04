@rem = '--*-Perl-*--
@echo off
if "%OS%" == "Windows_NT" goto WinNT
perl -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto :eof
:WinNT
perl -x -S %0 %*
goto :eof
@rem ';
#! /usr/bin/env perl
#line 12

##############################################################################
#
# Filename:    qcmd.pl
#
# Description: Quartus II Command-Line Control Layer for stand-alone 
#              executables.
#
#              Copyright (c) Altera Corporation 2004
#              All rights reserved.
#
##############################################################################

use strict;
use File::Copy;
use File::Basename;
use Getopt::Long;

my $idprint_label      = "qcmd";
my $BANNER             = <<BANNER;
Quartus II Command-Line Control Layer
Copyright (C) 1991-2004 Altera Corporation

BANNER

my $USAGE = <<USAGE;
Usage
-----
    qcmd <project_name> [options]

Options
-------
    [ -c | --rev    ] <value>    Specifies a revision
    [ -f | --family ] <value>    Specifies a family
    [ -h | --help   ]            Generate this help message
    [ -p | --part   ] <value>    Specifies a part
    [ -s | --seed   ] <seeds>    Run DSE using the specified seed list.
    [ -t | --top    ] <value>    Specifies the top level design entity.

    [ --prep  ]                  Only prepare the project / do not compile


    <seeds> is a comma-separated list of seed values, where each value can
            be either an integer or a range of integers with an optional
            step value, specified as <start>..<end>:<step>

USAGE

my %OPTIONS;
my $BIN_DIR = "";

##############################################################################
#
sub set_bin_dir
#
##############################################################################
{
	my $slash = "/";

	# Set up to use the same slash direction as seen from the system.
	if ($0 =~ m/([\\\/])/)
	{
		$slash = $1;
	}

	$BIN_DIR = dirname($0) . $slash;
}


##############################################################################
#
sub parse_seed_list
#
#   This callback for GetOptions populates $OPTIONS{SEED_LIST} with 
#   a string containing a comma-separated list of integers.
#
#   Expands the start..end:step specification into an explicit list of values.
#
##############################################################################
{
	my ($option, $value) = @_;

	my ($start, $end, $step);
	my @seeds;

	local($_);

	foreach (split(",", $value))
	{
		if ( ($start, $end, $step) = /^(-?\d+)\.\.(-?\d+):?(-?\d+)?$/ )
		{
			if ($start == $end)
			{
				push @seeds, $start;
			}
			else
			{
				if ($start < $end)
				{
					$step = 1 unless defined $step;
	
					if ($step < 1)
					{
						die "Invalid step size $step for range $start..$end\n\n";
					}
	
					my $i = $start;
	
					while ($i <= $end)
					{
						push @seeds, $i;
						$i += $step;
					}
				}
				elsif ($end < $start)
				{
					$step = -1 unless defined $step;
		
					if ($step > -1)
					{
						die "Invalid step size $step for range $start..$end\n\n";
					}
	
					my $i = $start;
	
					while ($i >= $end)
					{
						push @seeds, $i;
						$i += $step;
					}
				}
		
			}
		}
		elsif ( /^(-?\d+)$/ )
		{
			push @seeds, $_;
		}
		else
		{
			die "Invalid Seed List \"$value\"\n\n";
		}
	}

	if (@seeds)
	{
		$OPTIONS{DO_DSE}    = 1;

		if ($OPTIONS{SEED_LIST})
		{
			$OPTIONS{SEED_LIST} .= "," . join(",", @seeds);
		}
		else
		{
			$OPTIONS{SEED_LIST}  = join(",", @seeds);
		}
	}
	else
	{
		die "Invalid Seed List \"$value\"\n\n";
	}
}

##############################################################################
#
sub process_options
#
#   Populates the %OPTIONS hash with the command line options.
#   Also performs some basic legality checking.
#
##############################################################################
{
	my $success = 
		GetOptions( "rev|c=s"    => \$OPTIONS{REVISION},
					"family|f=s" => \$OPTIONS{FAMILY},
					"help|h"     => \$OPTIONS{PRINT_HELP},
					"part|p=s"   => \$OPTIONS{PART},
					"top|t=s"    => \$OPTIONS{TOP_ENTITY},
					"seed=s"     => \&parse_seed_list,
					"prep"       => \$OPTIONS{PREP_ONLY},
					"dry"        => \$OPTIONS{DRY_RUN}     );

	if ($success)
	{
		if ($OPTIONS{PRINT_HELP})
		{
			print $USAGE;
			exit 0;
		}

		$OPTIONS{PROJECT} ||= shift @ARGV;

		if (@ARGV)
		{
			print "\nError: Too many options: @ARGV\n\n";
			$success = 0;
		}

		unless ($OPTIONS{PROJECT})
		{
			print "\nError: No project specified!\n\n";
			$success = 0;
		}
	}

	print $USAGE unless ($success);

	return $success;
}



##############################################################################
#
sub idprint
#  
#  This is simply a wrapper around print which prefixes the desired output
#  with the program name for easy identification
#
##############################################################################
{
	print "$idprint_label: " if $idprint_label;
	print @_;
}


##############################################################################
#
sub do_system
#
#  Takes a string to call with system, print it and call.
#
#  Returns true if successful (return code 0), false otherwise.
#
##############################################################################
{
	my ($str) = @_;

	idprint  "Calling: $str\n";
	my $ret;

	$ret = system $str unless $OPTIONS{DRY_RUN};

	return ($ret ? 0 : 1);
}


##############################################################################
#
sub main
#
#  The actual entry into the script.
#
##############################################################################
{
	print $BANNER;
	exit 1 unless process_options();
	set_bin_dir();

	# First prepare the project, if necessary.
	if ($OPTIONS{FAMILY} || $OPTIONS{PART} || $OPTIONS{TOP_ENTITY})
	{
		my $prep_args = "";
		$prep_args   .= "-r $OPTIONS{REVISION} "   if ( $OPTIONS{REVISION}   );
		$prep_args   .= "-f $OPTIONS{FAMILY} "     if ( $OPTIONS{FAMILY}     );
		$prep_args   .= "-d $OPTIONS{PART} "       if ( $OPTIONS{PART}       );
		$prep_args   .= "-t $OPTIONS{TOP_ENTITY} " if ( $OPTIONS{TOP_ENTITY} );

		do_system("${BIN_DIR}quartus_sh --prepare $prep_args $OPTIONS{PROJECT}") ;
	}
	
	exit 0 if $OPTIONS{PREP_ONLY};

	# Next set up the flow command
	my $flow_args = "";

	if ($OPTIONS{DO_DSE})
	{
		$flow_args .= "-revision $OPTIONS{REVISION} " if ( $OPTIONS{REVISION} );
		do_system("${BIN_DIR}quartus_sh --dse -nogui -project $OPTIONS{PROJECT} -seeds $OPTIONS{SEED_LIST} $flow_args");
	}
	else
	{
		$flow_args .= "-c $OPTIONS{REVISION} " if ( $OPTIONS{REVISION} );
		do_system("${BIN_DIR}quartus_sh --flow compile $OPTIONS{PROJECT} $flow_args");
	}

}

main();





__END__
:endofperl
