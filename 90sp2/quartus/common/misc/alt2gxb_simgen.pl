#!perl
## START_MODULE_HEADER #######################################################
#
# Filename:    alt2gxb_simgen.pl
#
# Description: Perl script to process the simgen outputs from megawizard
#				and parameterize them as necessary
#
# Authors:     Thiagaraja B Gopalsamy
#
#              Copyright (c) Altera Corporation 2003
#              All rights reserved.
#
## END_MODULE_HEADER #########################################################


## REVISION HISTORY ##########################################################
#
# $Revision: #1 $ 


## GLOBAL_DATA ###############################################################
$file_input = $ARGV[0];
$wys_lib = $ARGV[1];
$debug_mode = 0;
if ($ARGV[2] eq "-debug")
{
	$debug_mode = 1;
}
%daddr_map = "";
%paddr_map = "";

## MAIN ######################################################################
open READ_FILE, "<$file_input";
@file = <READ_FILE>;
close READ_FILE;
$par_watch = 0;
$mod = 0;
$wys_mod = 0;
$daddr = 0;
$paddr = 0;
$module_marker = "";
$vlg_mode = 0;
$vhd_mode = 0;
# the file is a Verilog output file
if ($file_input =~ /\.vo/)
{
	$vlg_mode = 1;
}
elsif ($file_input =~ /\.vho/)
{
	$vhd_mode = 1;
}
if ($vlg_mode == 1 || $vhd_mode == 1)
{
	$index = 0;
	while ($index <= $#file)
	{
		$line_src = $file[$index];
		$line_src = join(" . ", split ('\.', $line_src));
		$line_src = join(" ", split ('\t', $line_src));
		$line_src = join(" ; ", split (';', $line_src));
		$line_src = join(" , ", split (',', $line_src));
		$line_src = join(" = ", split ('=', $line_src));
		@line = split ' ', $line_src;
		if ($wys_lib ne "" && (($line[0] =~ /_hssi_/ && $vlg_mode == 1) ||
		   ($line[2] =~ /_hssi_/ && $vhd_mode == 1)))
		{
			@lib_name = split '_', $line[($vlg_mode == 1) ? 0 : 2];
			if ($lib_name[0] ne $wys_lib)
			{
				$wys_mod = 1;
			}
		}
		if (($line[0] =~ /hssi_central_management_unit/ && $vlg_mode == 1) ||
		   ($line[2] =~ /hssi_central_management_unit/ && $vhd_mode == 1))
		{
			# watch for parameters now
			if ($par_watch == 2)
			{
				$daddr_map{$module_marker} = $daddr;
				$paddr_map{$module_marker} = $paddr;
				if ($debug_mode == 1)
				{
					print "Debug: module=".$module_marker." Devaddr=".$daddr." Portaddr=".$paddr."\n";				
					print "Debug: End of parameters section\n";			
				}
			}
			$par_watch = 1;		
			if ($vlg_mode == 1)
			{
				$module_marker = $line[1];	
			}
			elsif ($vhd_mode == 1)
			{
				$module_marker = $line[0];
			}
			if ($debug_mode == 1)
			{
				if ($vlg_mode == 1)
				{
					print "Debug: Found unit ".$line[0]." ".$line[1]."\n";
				}
				elsif ($vhd_mode == 1)
				{
					print "Debug: Found unit ".$line[2]." ".$line[0]."\n";
				}
			}
		}
		elsif ($par_watch == 1)
		{
			if (($line[0] eq "defparam" && $vlg_mode == 1) ||
				($line[0] eq "GENERIC" && $vhd_mode == 1))
			{
				$par_watch = 2;
				if ($debug_mode == 1)
				{
					print "Debug: Reading parameters section\n";
				}
			}
		}
		elsif ($par_watch == 2)
		{
			if ((($line[0] eq "(" || $line[0] eq "defparam") && $vlg_mode == 1) ||
				(($line[0] eq ")" || $line[0] eq "PORT") && $vhd_mode == 1))
			{
				$par_watch = 0;
				$daddr_map{$module_marker} = $daddr;
				$paddr_map{$module_marker} = $paddr;
				if ($debug_mode == 1)
				{
					print "Debug: module=".$module_marker." Devaddr=".$daddr." Portaddr=".$paddr."\n";				
					print "Debug: End of parameters section\n";
				}
			}
			elsif (($line[2] eq "devaddr" && $vlg_mode == 1) ||
				 ($line[0] eq "devaddr" && $vhd_mode == 1))
			{
				if ($vlg_mode == 1)
				{
					$daddr = $line[4];
				}
				elsif ($vhd_mode == 1)
				{
					$daddr = $line[3];
				}
			}
			elsif (($line[2] eq "portaddr" && $vlg_mode == 1) ||
				($line[0] eq "portaddr" && $vhd_mode == 1))
			{
				if ($vlg_mode == 1)
				{
					$paddr = $line[4];
				}
				elsif ($vhd_mode == 1)
				{
					$paddr = $line[3];
				}
			}
			elsif (($line[2] eq "dprio_config_mode" && $vlg_mode == 1) ||
				($line[0] eq "dprio_config_mode" && $vhd_mode == 1))
			{
				if (($line[4] ne "0" && $vlg_mode == 1) ||
					($line[3] ne "0" && $vhd_mode == 1))
				{
					$mod = 1;
					if ($debug_mode == 1)
					{
						print "Debug: Design needs patching\n";
					}
				}
				else
				{
					if ($debug_mode == 1)
					{
						print "Debug: Design needs no patch\n";
					}
				}
			}
		}
		++$index;
	}
}

## modificationn is required, proceed with it
if ($mod == 1 || $wys_mod == 1)
{
	if ($mod == 1)
	{
		# figure out the channel numbers and the indices of the CMUs
		for $class ( keys %daddr_map)
		{
			if ($class ne "")
			{
				$daddr = $daddr_map{$class};
				$paddr = $paddr_map{$class};
				if ($main_daddr == 0)
				{
					$main_daddr = $daddr;
					$main_paddr = $paddr;
				}
				elsif ($main_paddr > $paddr)
				{
					$main_daddr = $daddr;
					$main_paddr = $paddr;
				}
				elsif ($main_paddr == $paddr && $main_daddr > $daddr)
				{
					$main_daddr = $daddr;
					$main_paddr = $paddr;
				}
			}
		}
		$start_chl_num = ($main_paddr - 1)*128 + ($main_daddr - 1)*4;
		if ($debug_mode == 1)
		{
			print "Debug: Starting_channel_number is ".$start_chl_num."\n";
		}
		%cmu_index = "";
		for $class ( keys %daddr_map)
		{
			if ($class ne "")
			{
				$daddr = $daddr_map{$class};
				$paddr = $paddr_map{$class};
				$cur_chl_num = ($paddr-1)*128 + ($daddr-1)*4;
				$cur_index = ($cur_chl_num - $start_chl_num) / 4;
				if ($debug_mode == 1)
				{
					print "Debug: module=".$class." CMU index=".$cur_index."\n";
				}
				$cmu_index{$class} = $cur_index;
			}
		}
	}
	$newfile = "";
	{
		$index = 0;
		$par_added = 0;
		$msg_added = 0;
		%sub_list = "";
		while ($index <= $#file)
		{
			$skip_line = 0;
			$line_src = $file[$index];
			$line_src = join(" . ", split ('\.', $line_src));
			$line_src = join(" ", split ('\t', $line_src));
			$line_src = join(" ; ", split (';', $line_src));
			$line_src = join(" , ", split (',', $line_src));
			$line_src = join(" = ", split ('=', $line_src));
			@line = split ' ', $line_src;
			if ($mod == 1)
			{
				if ($line[0] =~ /hssi_/ && $vlg_mode == 1 && $par_added == 0)
				{
					$newfile = $newfile."\tparameter\tstarting_channel_number = ".$start_chl_num.";\n\n";
					$par_added = 1;
					if ($debug_mode == 1)
					{
						print "Debug: Parameter starting_channel_number added\n";
					}
				}
				elsif ($line[0] eq "assign" && $vlg_mode == 1 && $msg_added == 0)
				{
					$newfile = $newfile."\n\tinitial\n\tbegin\n\t\tif ((starting_channel_number % 4) != 0)\n\t\tbegin\n";
					$newfile = $newfile."\t\t\t\$display(\"Error: Parameter starting_channel_number can only have values that are multiples of 4.\");\n\t\tend\n\tend\n\n";
					$msg_added = 1;
					if ($debug_mode == 1)
					{
						print "Debug: Error message for starting_channel_number added\n";
					}
				}
				elsif ($line[0] eq "ENTITY" && $par_added == 0 && $vhd_mode == 1)
				{
					$newfile = $newfile.$file[$index];
					$skip_line = 1;
					$newfile = $newfile."\t GENERIC\n\t (\n\t\t	starting_channel_number\t : NATURAL := ".$start_chl_num."\n\t );\n";
					$par_added = 1;
					if ($debug_mode == 1)
					{
						print "Debug: Parameter starting_channel_number added\n";
					}
				}
				elsif ($line[0] eq "END" && $line[1] eq "RTL" && $msg_added == 0 && $vhd_mode == 1)
				{
					$newfile = $newfile."\tASSERT ((starting_channel_number MOD 4) = 0)\n";
					$newfile = $newfile."\tREPORT \"Error: Parameter starting_channel_number can only have values that are multiples of 4.\"\n";
					$newfile = $newfile."\tSEVERITY ERROR;\n\n";
					$msg_added = 1;
					if ($debug_mode == 1)
					{
						print "Debug: Error message for starting_channel_number added\n";
					}
				}			
				elsif (($line[0] =~ /hssi_central_management_unit/ && $vlg_mode == 1) ||
					($line[2] =~ /hssi_central_management_unit/ && $vhd_mode == 1))
				{
					# watch for parameters now
					$par_watch = 1;		
					if ($vlg_mode == 1)
					{
						$module_marker = $line[1];	
					}
					elsif ($vhd_mode == 1)
					{
						$module_marker = $line[0];
					}
				}
				elsif ($par_watch == 1)
				{
					if (($line[0] eq "defparam" && $vlg_mode == 1) ||
						($line[0] eq "GENERIC" && $vhd_mode == 1))
					{
						$par_watch = 2;
					}
				}
				elsif ($par_watch == 2)
				{
					if ((($line[0] eq "(" || $line[0] eq "defparam") && $vlg_mode == 1) ||
						(($line[0] eq ")" || $line[0] eq "PORT") && $vhd_mode == 1))
					{
						$par_watch = 0;
					}
					elsif (($line[2] eq "devaddr" && $vlg_mode == 1) ||
							($line[0] eq "devaddr" && $vhd_mode == 1))
					{
						$skip_line = 1;
						$num_quad = $cmu_index{$module_marker};
						if ($vlg_mode == 1)
						{					
							$newfile = $newfile."\t\t".$line[0].".devaddr = (((starting_channel_number / 4) + ".$num_quad.") % 32) + 1,\n";
						}
						elsif ($vhd_mode == 1)
						{
							$newfile = $newfile."\t\tdevaddr => (((starting_channel_number / 4) + ".$num_quad.") mod 32) + 1,\n";					
						}
						if ($debug_mode == 1)
						{
							print "Debug: Patched devaddr for module ".$module_marker."\n";
						}					
					}
					elsif (($line[2] eq "portaddr" && $vlg_mode == 1) ||
							($line[0] eq "portaddr" && $vhd_mode == 1))
					{
						$skip_line = 1;
						$num_quad = $cmu_index{$module_marker};		
						if ($vlg_mode == 1)
						{								
							$newfile = $newfile."\t\t".$line[0].".portaddr = ((starting_channel_number + (4 * ".$num_quad.")) / 128) + 1,\n";
						}
						elsif ($vhd_mode == 1)
						{
							$newfile = $newfile."\t\tportaddr => ((starting_channel_number + (4 * ".$num_quad.")) / 128) + 1,\n";
						}
						if ($debug_mode == 1)
						{
							print "Debug: Patched portaddr for module ".$module_marker."\n";
						}					
					}
				}
			}
			if ($wys_mod == 1)
			{
				if ($file[$index] =~ /_hssi/)
				{
					$int_index = 0;
					while ($int_index <= $#line)
					{
						$token = $line[$int_index++];
						if ($token =~ /_hssi/ && $sub_list{$token} eq "")
						{
							@lib_name = split '_', $token;
							$lib_index = 1;
							$new_lib_name = $wys_lib;
							@repl = split '', $lib_name[0];
							if ($repl[0] eq "\"")
							{
								$new_lib_name = "\"".$new_lib_name;
							}
							while ($lib_index <= $#lib_name)
							{
								$new_lib_name = $new_lib_name."_".$lib_name[$lib_index++];
							}
							$sub_list{$token} = $new_lib_name;
						}						
					}
					## got the new name, now construct the rest of the line
					$final_line = $file[$index];
					for $name (keys %sub_list)
					{
						if ($name ne "")
						{
							$final_line =~ s/$name/$sub_list{$name}/;
						}
					}
					$newfile = $newfile.$final_line;
					$skip_line = 1;
				}
			}
			if ($skip_line == 0)
			{
				$newfile = $newfile.$file[$index];
			}
			++$index;
		}
	}
	open WRITE_FILE, ">$file_input";
	print WRITE_FILE $newfile;
	close WRITE_FILE;		
}
