#! /usr/bin/env perl
#
## START_MODULE_HEADER #######################################################
#
# $Header: //acds/rel/9.0sp2/quartus/mega/wizman/cbx2ww.pl#1 $
#
# Description: Convert MegaWizard-generated output into pure wrappers involving
#              a single megafunction instantiation.
#
#    Copyright (c) Altera Corporation 2008
#    All rights reserved.
#
## END_MODULE_HEADER #########################################################
#
use strict;
use File::Path;
use File::Copy;
use Cwd;

my $isWindows = (-e 'C:/') ? 1 : 0;
my @srcww;
my $useQmegawiz = 0;

my $usage =<<USAGE;
Usage: $0 [options] <...wrapper..list...>

Convert MegaWizard-generated output into traditional, pure wrappers
involving a single megafunction instantiation.

The output files use the original basename, and add an "_ww" suffix.

Options:
	-qmegawiz   Do not convert using the 'qmegawiz' command.
	or -q       Use the approximate conversion built into this perl script
	            instead.  The megafunction instance may not be fully 
	            connected.  Avoids potential \$DISPLAY disadvantage
	            of the qmegawiz method. This is the default.
	+qmegawiz   Convert using the 'qmegawiz' command.  In Linux systems,
	or +q       a valid \$DISPLAY must be defined for qmegawiz to execute
	            successfully.
USAGE

die $usage if (scalar @ARGV < 1);
# find a preferred temporary directory
my $tmpDir = "/tmp/ww.$$";
if ($isWindows) {
	my $tmpDirEnv = $ENV{'TEMP'};
	if (defined($tmpDirEnv)) {
		$tmpDir = $tmpDirEnv . "/ww.$$";
	}
}

# convert one wizard wrapper to a traditional wrapper, using qmegawiz
sub convertOneWWUseQmegawiz {
	my $inWW = shift or die "convertOneWWUseQmegawiz() requires 1 arg\n";
	my $module;
	
	# extract the module (entity) name from the existing wrapper
	open WIZWRAP, "<$inWW" or die "Couldn't open '$inWW' for reading\n";
	READWW: {
		while (<WIZWRAP>) {
			if (m!^[-/][-/]\s*GENERATION:\s*(\S+)!) {
				if ($1 ne "STANDARD") {
					print "$inWW: Can't convert 'GENERATION: $1' wrappers\n";
					last;	# stop reading the wrapper file
				}
			} elsif (m!^[-/][-/]\s*MODULE:\s*(\S+)!) {
				$module = $1;	# found the megafunction name
				last;	# stop reading the wrapper file
			}
		}
	}
	close WIZWRAP;
	
	# if we found a megafunction name in $module, go for conversion to a traditional wrapper
	if (defined($module)) {
		my $outWW = $inWW;
		$outWW =~ s/[.](v|vhd)$/_ww.$1/;
		print "Creating $outWW from $inWW\n";
		
		rmtree($tmpDir) if (-d $tmpDir);
		mkpath($tmpDir);	# create the temporary directory
		copy($inWW, "$tmpDir/$inWW");	# copy wrapper to temporary directory
		{
			my $origCwd = cwd();	# save original cd
			# local $CWD = $tmpDir;	# cd to $tmpDir within this context only (see File::chdir)
			chdir($tmpDir);
			system("qmegawiz -silent -wiz_override=\"LPM_HINT=CBX_BLACKBOX_LIST=$module\" $inWW");
			chdir($origCwd);
		}
		
		# copy the result from the temporary directory, but delete the line
		# that defines lpm_hint: ... .lpm_hint = "CBX_BLACKBOX_LIST= ...
		open INWW, "<$tmpDir/$inWW" or die "Couldn't open temporary $tmpDir/$inWW\n";
		open OUTWW, ">$outWW" or die "Couldn't open '$outWW' for writing\n";
		while (<INWW>) {
			if (! /[.]lpm_hint\s*[=]\s*\"CBX_BLACKBOX_LIST/
			 && ! /lpm_hint/ ) {
				print OUTWW;
			}
		}
		close OUTWW;
		close INWW;
		
		# clean up
		rmtree($tmpDir);
	}
}

# convert one wizard wrapper to a traditional wrapper, using only perl
sub convertOneWWUsePerl {
	my $inWW = shift or die "convertOneWWUsePerl() requires 1 arg\n";
	my $module;
	my $echoToOutWW = 1;	# when '1', echo each line immediately
	my $onComponent = 0;	# 0 means before the component declaration and instantiation
							# 1 means in the middle of the Verilog component instantiation (Verilog only)
							# 2 means after the component instantiation, save everything
							# 3 means betweeen the VHDL component declaration and instantiation (VHDL only)
	my $isClearboxVerilog = 0;
	my $isClearboxVHDL = 0;
	my $paramAssignOp = "=";	# "=>" for VHDL
	my $param;	# parameter name, value extracted from CONSTANT comment
	my $value;
	my @midVHDL; # part between VHDL component declaration and instantiation
	my @tail;	# all original wrapper lines following component instantiation
	my @params;	# "parameter = value" set
	my @genericsDeclaration;	# VHDL generics declarations
	my $genericDecl;
	
	my $outWW = $inWW;
	$outWW =~ s/[.](v|vhd)$/_ww.$1/;
	print "Creating $outWW from $inWW\n";
	
	# extract the module (entity) name from the existing wrapper
	open INWW, "<$inWW" or die "Couldn't open '$inWW' for reading\n";
	open OUTWW, ">$outWW" or die "Couldn't open '$outWW' for writing\n";
	READWW: {
		while (<INWW>) {
			if (m!^[-/][-/]\s*GENERATION:\s*(\S+)!) {
				if ($1 ne "STANDARD") {
					print "$inWW: Can't convert 'GENERATION: $1' wrappers\n";
					last;	# stop reading the wrapper file
				}
			} elsif (m!^[-/][-/]\s*MODULE:\s*(\S+)!) {
				$module = lc($1);	# found the megafunction name
			} elsif (defined($module) && m!^[-][-]$module\s!) {
				$echoToOutWW = 0;	# stop echoing into simplified wrapper until we see //VALID FILE
				$isClearboxVHDL = 1;
				$paramAssignOp = "=>";
				# add VHDL library declaration for megafunction definition
				print OUTWW "LIBRARY altera_mf;\nUSE altera_mf.all;\n";
			} elsif (defined($module) && m!^//$module\s!) {
				$echoToOutWW = 0;	# stop echoing into simplified wrapper until we see //VALID FILE
				$isClearboxVerilog = 1;
			} elsif (m!^[-/][-/]VALID\sFILE!) {
				$echoToOutWW = 1;	# start echoing again after this file
				next;
			}
			
			if ($onComponent == 2) {
				# Verilog or VHDL
				# saving remaining lines to echo later.  Collect all CONSTANT assignments
				push(@tail, $_);
				if (m!^[-/][-/]\s*Retrieval info[:]\s*CONSTANT[:]\s*(\S+)\s+(STRING|NUMERIC)\s+\"([^"]+)\"\s*$!) {
					$param = lc($1); # always lower-case parameter names for Verilog and VHDL
					if ($2 eq "STRING") {
						$value = "\"$3\"";
						$genericDecl = "$param\t\t: STRING";
					} else {
						$value = $3;
						$genericDecl = "$param\t\t: NATURAL";
					}
					push(@params, "$param $paramAssignOp $value");
					push(@genericsDeclaration, $genericDecl);
					#print OUTWW "\t\t${module}_component.$param = $value,\n";
				}
			}
			
			if ($onComponent == 3) {
				# VHDL only: we are in the middle block between the component declaration
				# and the component instantiation
				if (/^\s*\S+_component\s*[:]\s*\S+\s*$/) {
					# Found the component instantiation
					$_ = "\t${module}_component : $module\n";
					$onComponent = 2;
				}
				push(@midVHDL, $_);
			}
			
			if ($echoToOutWW) {
				if ($isClearboxVerilog) {
					# Verilog:
					s:/[*] synthesis synthesis_clearbox [=] 1 [*]/:: ;
					if (/^(\s*)(\S+)\s+(\S+_component)\s*[(]\s*$/) {
						# replace the component instantiation with a direct megafunction instantiation
						$_ = "$1$module ${module}_component (\n";
						$onComponent = 1;
					}
					# Check for new clearbox=2 style of comments in Quartus II 8.1 and beyond
					if (m:/[*]\s*synthesis synthesis_clearbox\s*[=]\s*2:) {
						# make sure there's a terminating "*/", since it could be on a subsequent line
						while (! s:/[*].*[*]/::s) { #/s modifier allows '.' to match newlines
							$_ .= <INWW>;
						}
					}
				} elsif ($isClearboxVHDL) {
					# VHDL:
					if (/ATTRIBUTE synthesis_clearbox/
					  || /ATTRIBUTE clearbox_macroname/
					  || /ATTRIBUTE clearbox_defparam/) {
						next; # delete clearbox attribute definition and assignment
					} elsif (/^\s*COMPONENT\s+(\S+)\s*$/) {
						# replace component name with megafunction name in declaration
						$_ = "\tCOMPONENT $module\n";
						$onComponent = 3; # for VHDL, must insert generics immediately on next lines
						$echoToOutWW = 0; # stop echoing immediately
					}
				}
				print OUTWW;
				
				if ($onComponent == 1 && /[)][;]\s*$/) {
					# insert Verilog defparam
					print OUTWW "\tdefparam\n";
					$onComponent = 2; # start saving remaining lines until end of file
					$echoToOutWW = 0; # stop echoing immediately
				}
			}
		}
		
		if ($isClearboxVerilog) {
			# finished reading the original wrapper.  Dump the tail section
			my $lastParam = pop(@params);
			print OUTWW  map("\t\t${module}_component.$_,\n", @params);
			print OUTWW  "\t\t${module}_component.$lastParam;\n";
			print OUTWW  @tail;
		} elsif ($isClearboxVHDL) {
			# Dump the generics declarations and the mid section
			print OUTWW  "\tGENERIC (\n";
			print OUTWW  map("\t\t$_;\n", @genericsDeclaration);
			print OUTWW  "\t\tlpm_type\t\t: STRING\n";
			print OUTWW  "\t);\n";
			print OUTWW  @midVHDL;

			# Dump the generics assignments and the tail section
			print OUTWW  "\tGENERIC MAP (\n";
			print OUTWW  map("\t\t$_,\n", @params);
			print OUTWW  "\t\tlpm_type => \"$module\"\n";
			print OUTWW  "\t)\n";
			print OUTWW  @tail;
		}
	}
	close OUTWW;
	close INWW;
}

#expand command-line filename wildcards
@ARGV= map glob, @ARGV if ($isWindows);

# command-line args?
#print "Program arguments are:\n",   map("  '$_'\n", @ARGV);
for (@ARGV) {
	if (/^([-]h|[-][-]help)/) {
		print $usage;
		exit 1;
	} elsif ( /^[-]q(|megawiz)$/ ) {
		$useQmegawiz = 0;	# don't use qmegawiz
	} elsif ( /^[+]q(|megawiz)$/ ) {
		$useQmegawiz = 1;	# use qmegawiz
	} elsif ( -r $_ ) {
		# source wizard wrapper is valid and readable
		push(@srcww, $_);
	} else {
		print "Source file '$_' not found\n";
		print $usage;
	}
}

# call converter on each valid source file
for (@srcww) {
	if ($useQmegawiz) {
		# use real 'qmegawiz' - must have valid $DISPLAY defined
		convertOneWWUseQmegawiz($_);
	} else {
		# use approximate conversion built into this script
		convertOneWWUsePerl($_);
	}
}
