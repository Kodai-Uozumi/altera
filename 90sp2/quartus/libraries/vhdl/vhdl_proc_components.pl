##############################################################################
#! perl		
#	Perl script to process VHDL component declarations and add lpm_type to them
#	if they are missing
#
#	Author :	Thiagaraja B Gopalsamy
#
## REVISION HISTORY ##########################################################
#
# $Revision: #1 $ 

##########################################################################
##	Function checks whether a token is a special string or not			##
##########################################################################
sub is_special_string
{
	if (@_ eq "(" || @_ eq ";" || @_ eq "--" || @_ eq ")")
	{
		return 1;
	}
	return 0;
}


sub parse_line_into_tokens
{
	my($new_line) = @_;
	$new_line = join (" ) ", split('\)', $new_line));
	$new_line = join (" ( ", split('\(', $new_line));
	$new_line = join (" , ", split(',', $new_line));
	$new_line = join ("-", split(" - ", $new_line));
	$new_line = join (" ; ", split(';', $new_line));
	$new_line = join (" = ", split('=', $new_line));
	$new_line = join (" : ", split(':', $new_line));
	$new_line = join (" -- ", split("--", $new_line));
	$new_line = join (" [ ", split('\[', $new_line));
	$new_line = join (" ] ", split('\]', $new_line));
	return $new_line;
}

##########################################################################
##	Main function														##
##########################################################################
$input_file_name = $ARGV[0];
$output_file_name = $ARGV[1];
if (-e $input_file_name)
{
	open READ_FILE, "<$input_file_name";
	@file = <READ_FILE>;
	if ($input_file_name =~ /.[Vv][Hh][Dd]/)
	{
		open WRITE_FILE, ">$output_file_name";
		## is a vhdl source file
		print "Debug: Processing VHDL source file ".$input_file_name."\n";
		$index =0;
		$component_name = "";
		$read_param = 0;
		$lpm_type_found = 0;
		while ($index <= $#file)
		{
			## the line is processed into recognizable tokens first (with space
			## separations for all the key markers
			@line = split ' ', parse_line_into_tokens($file[$index]);
			$line_index = 0;
			while ($line_index <= $#line)
			{
				if ($line[$line_index] eq "--")
				{
					## comment line just ignore
				}
				elsif (lc($line[$line_index]) eq "component")
				{	## the line that has the entity name
					if (lc($line[$line_index-1]) eq "end")
					{ 
						print "Debug: End of component section for ".$component_name."\n";
						$read_param = 0;
						$component_name = "";	
						$lpm_type_found = 0;
					}
					else
					{
						$component_name = $line[++$line_index];
						print "Debug: New component named ".$component_name."  found\n";
					}
				}
				elsif (lc($line[$line_index]) eq "generic" &&
					   $component_name ne "")
				{
					$read_param = 1;
					$lpm_type_found = 0;
					print "Debug: Reading parameter section for component ".$component_name."\n";
				}
				elsif (($line[$line_index] eq ")" && $read_param == 1) ||
						(lc($line[$line_index]) eq "port" && $read_param == 0))
				{
					print "Debug: End of parameter section for component ".$component_name."\n";
					if ($read_param == 0)
					{
						print WRITE_FILE " generic (\n";
					}
					if ($lpm_type_found == 0)
					{	## lpm_type description not found so far
						## so add it
						print "Debug: Added lpm_type declaration for ".$component_name."\n";
						if ($read_param == 1 && $line_index == 0)
						{
							print WRITE_FILE ";\n";
						}
						print WRITE_FILE "\t\tlpm_type : string := \"".$component_name."\"";
						if ($read_param == 1 && $line_index != 0)
						{
							print WRITE_FILE ";\n";
						}
					}
					if ($read_param == 0)
					{
						print WRITE_FILE "\n\t\t);\n";
					}
					$read_param = 2; ## indicating end of component read
				}
				if ($read_param == 1)
				{
					$param_name = "";
					if ($line[$line_index] eq ":")
					{
						$param_name = $line[$line_index-1];
					}
					if ($param_name ne "")
					{
						if (lc($param_name) eq "lpm_type")
						{
							$lpm_type_found = 1;
						}
					}
				}
				++$line_index;
			}
			print WRITE_FILE $file[$index];
			++$index;
		}
	}
	else
	{
		print "Error: Unsupported file type ".$input_file_name."\n";
	}
	close READ_FILE;
}
else
{
	print "Error: Input file ".$input_file_name." doesn't exist\n";
}
