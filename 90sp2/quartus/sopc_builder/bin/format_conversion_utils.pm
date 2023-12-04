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








# file: format_conversion_utils.pm
#
# Utilities for converting between
# S-records, mif, and dat files
#
# Also handy for getting address ranges
# and such.
#

package format_conversion_utils;
use Exporter;

@ISA = Exporter;
@EXPORT = qw(
    fcu_convert
    fcu_usage
    fcu_parse_args
    fcu_get_switch
    fcu_get_sdk_settings
    fcu_get_address_range
    fcu_date_time
    fcu_print_command
    fcu_read_file
    fcu_write_file
    fcu_text_to_hash
    fcu_hash_to_text
    fcu_get_hash_range
);

use strict;  #(now available)
use filename_utils;   # needed for &Create_Dir_If_Needed()


# -------------------------------
# nios-convert

    
# ----------------------
# ceil(x)
#
# standard math ceil
#
sub ceil
    {
    my $x = shift;

    return int($x) if ($x == int($x));
    return int($x + 1);
    }

# -------------------------
# addTo(stringRef,list)
#
# Add list of arguments as one line to
# big multiline variable stringRef.
# This, instead of print.

sub addTo
    {
    my $stringRef = shift;
    
    my $i;

    for($i = 0; $i <= $#_; $i++)
        {
        $$stringRef .= $_[$i];
        }
    $$stringRef .= "\n";
    }

# -------------------------
# dprint(list...)
#
# print only if gDebug

my $gDebug = 0;

sub dprint
    {
    my $i;

    return if ($gDebug == 0);

    for($i = 0; $i < 30; $i++)
        {
        print STDERR shift;
        }
    print STDERR "\n";
    }

# ----------------------
# dateTime()
#
# returns a relatively nice date & time string
#
sub dateTime
    {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdet) = localtime(time);
    $mon++;
    $year += 1900;

    my $d = sprintf("%04d.%02d.%02d",$year,$mon,$mday);
    my $t = sprintf("%02d:%02d:%02d",$hour,$min,$sec);

    return "$d $t";
    }


# ----------------------------
# fcu_date_time()
#
# Return a formatted string with the date and time
# nice and consistent
#

sub fcu_date_time
    {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdet) = localtime(time);
    $mon++;
    $year += 1900;

    my $d = sprintf("%04d.%02d.%02d",$year,$mon,$mday);
    my $t = sprintf("%02d:%02d:%02d",$hour,$min,$sec);

    return "$d $t";
    }

# fcu_print_command
#
# Print a command that is about to be executed in our
# signature format
#
# (should we break-and-backslash this?)
#

my $fcu_print_command_cr = 1; # extra spacing

sub fcu_print_command
    {
    my $command = shift;

    if($command eq ":::cr0")
        {
        $fcu_print_command_cr = 0;
        return;
        }

    my $dt = fcu_date_time();

    print "\n" if $fcu_print_command_cr;
    print "# $dt (*) $command\n";
    }

# --------------------------
# fcu_read_file(fileName)
#
#    returns the complete file contents
#
sub fcu_read_file
    {
    my $fileName = shift;
    my $bunch;
    my $result;
    my $did;

    if(open(FILE,$fileName))
        {
        binmode FILE;         # Bite me, Windows! --dvb
        while(read(FILE,$bunch,32000))
            {
            $result .= $bunch;
            }
        close FILE;
        }
    
    return $result;
    }


# -----------------------
# fcu_write_file(fileName,contents)
#
#    creates new file and writes entire
#    file contents. Return "ok" if so,
#    or "" if not.
#
sub fcu_write_file
    {
    my $fileName = shift;
    my $contents = shift;
    my $did;
    my $filePath;

    #
    # If fileName is "", print it to stdout
    # and that is all.
    #

    if($fileName eq "")
        {
      print $contents;
        return "";
        }

    #
    # Delete existing file, if any.
    #
    unlink ($fileName) if(-e $fileName);

    # Check for existence of directory
    $fileName =~ /(.*)\/.+$/;   # everything before last '/'
    $filePath = $1;
    &Create_Dir_If_Needed($filePath);

    $did = open(FILE,">$fileName");
    if($did)
        {
        binmode FILE;         # Bite me, Windows! --dvb
        print FILE $contents;
        close FILE;
        return "ok";
        }
    
    return "";
    }

# -----------------------------
# txt2hash(giantFileString)
#
# Each byte of this text file
# becomes one byte in the rom.
#
sub txt2hash
    {
    my $txtString = shift;
    my $i;
    my %hash;

    for($i = 0; $i < length($txtString); $i++)
        {
        $hash{$i} = unpack("C",substr($txtString,$i,1));
        }

    return %hash;
    }

# -----------------------------
# hex2hash(giantFileString)
#
# Given a giant string containing
# a text file, assume that each line
# contains a single value of the
# current data width.
#
# Addresses start at zero, blank
# lines are ignored, and the comment
# character is HASH.
#
sub hex2hash
    {
    my $txtString = shift;
    my $width = shift;

    my $line;
    my %hash;
    my $address = 0;
    my $i;

    foreach $line (split("\n",$txtString))
        {
        $line =~ s/\r//g; # kill ^M's
        $line = $1 if($line =~ /^(.*)\#.*$/);    # kill comments
        $line = $1 if($line =~/^\s*?(\S*)\s*?$/); # kill surrounding whitespace

        if($line ne "")
            {
            $line = hex($1) if($line =~ /^0x(.*)$/); # allow hex
            $line = 1 * $line;
            $line = int($line + 0.5);

            for($i = 0; $i < $width/8; $i++)
                {
                $hash{$address++} = $line & 0xff;
                $line = $line >> 8;
                }
            }
        }
    
    return %hash;
    }


# -----------------------------
# srec2hash(giantFileString)
#
# Given a giant string containing
# one entire srec file, return an
# associative array where each entry
# has a byte-address key, and its
# contents.
#
# This will of course be moderately
# gigantic, but who's counting?
#
# We just presume that RAM is cheap
# and plentiful and works, too.
#
sub srec2hash
    {
    my $srecString = shift;
    my %hash;

    my $srecord;
    my $recordType;
    my $recordLength;
    my $recordChecksum;
    my $recordAddress;
    my $recordData;
    my $addressStringLength;

    foreach $srecord (split("\n",$srecString))
        {
        $srecord =~ s/\r//g;    # kill ^M's
        if($srecord =~ /^S([123])(..)(.*)(..)$/)        # an S record we can use
            {
            $recordType = $1;
            $recordLength = hex($2)-1;
            $a = $3;
            $recordChecksum = $4;

            $recordLength -= $recordType + 2;
            $addressStringLength = ($recordType + 1) * 2;
            $recordAddress = hex(substr($a,0,$addressStringLength));
            $recordData = substr($a,$addressStringLength);

            while(length($recordData))
                {
                $hash{$recordAddress} = hex(substr($recordData,0,2));
                $recordData = substr($recordData,2);
                $recordAddress++;
                }
            }
        }

    return %hash;
    }



sub mifRadixFromText
    {
    my $mifRadix = shift;

    return 10 if($mifRadix eq "UNS"
            or $mifRadix eq "DEC");

    return 2 if($mifRadix eq "BIN");

    return 16 if(($mifRadix eq "HEX") or (1)); # return 16 if unrecognized
    }

# Warning: this routine assumes input data is <= 32 bits in length.
sub mifValueByRadix
    {
    my $mifData = shift;
    my $mifRadix = shift;

    return hex($mifData) if($mifRadix == 16);
    return 1.0 * $mifData if($mifRadix == 10);

    my $result = 0;

    while($mifData ne "")
        {
        $result = $result * $mifRadix + substr($mifData,0,1);
        $mifData = substr($mifData,1);
        }
    
    return $result;
    }

# -----------------------------
# mif2hash(giantFileString)
#
# Given a giant string containing
# one entire mif file, return an
# associative array where each entry
# has a byte-address key, and its
# contents.
#
# This will of course be moderately
# gigantic, but who's counting?
#
# We just presume that RAM is cheap
# and plentiful and works, too.
#
sub mif2hash
    {
    my $srecString = shift;
    my %hash;

    my $mifrecord;
    my $mifWidth;
    my $mifAddressRadix;
    my $mifDataRadix;
    my $mifBytesPerData;
    my $mifData;
    my $mifAddress;
    my $mifAddressLast; # for ranges
    my $i;

    $mifWidth = 8;

    foreach $mifrecord (split("\n",$srecString))
        {
        $mifrecord =~ s/\r//g;    # kill ^M's

# Recognize 4 kinds of lines:
# WIDTH=x;
# ADDRESS_RADIX=HEX/DEC/UNS;
# DATA_RADIX=HEX/DEC/UNS;
# addr:data;
# Ignore anything else. We don't even care about the "DEPTH".
#
        $mifrecord =~ s/[\t ]//g; # kill white space
        if($mifrecord =~ /^(.*)\=(.*);$/)
            {
            if($1 eq "WIDTH")
                {
                $mifWidth = $2;
                $mifBytesPerData = int(($mifWidth + 7) / 8);
                }
            elsif($1 eq "ADDRESS_RADIX")
                {
                $mifAddressRadix = mifRadixFromText($2);
                }
            elsif($1 eq "DATA_RADIX")
                {
                $mifDataRadix = mifRadixFromText($2);
                }
            }
        elsif($mifrecord =~ /^(.*):(.*);$/)
            {
            #
            # Address can be a number like "1234" or a range like "[1234..1244]"
            #

            $mifAddress = $1;
      # I'm going to work with mif data in bytes, to avoid 32-bit integer
      # overflow trouble when data width is > 32.
      my @mifData = $2 =~ /[\dA-Fa-f]{2}/g;
      
      # Convert hex values to number.
      map {$_ = hex($_)} @mifData;

      # Mif bytes are pulled out in bytes-per-data groups,
      # least-significant bytes first.  @mifData is in most-significant
      # byte first order, so reverse it.
      @mifData = reverse @mifData;
      
      # Mif file data may be padded out with zeroes.  Drop any extra bytes from
      # the most-significant end.
      pop @mifData while (@mifData > $mifBytesPerData);

            if($mifAddress =~ /\[([0-9a-zA-Z]*)\.\.([0-9a-zA-Z]*)\]/)
                {
                $mifAddress = mifValueByRadix($1,$mifAddressRadix)
                        * $mifBytesPerData;
                $mifAddressLast = mifValueByRadix($2,$mifAddressRadix)
                        * $mifBytesPerData;
                }
            else
                {
                $mifAddress = mifValueByRadix($mifAddress,$mifAddressRadix)
                        * $mifBytesPerData;
                $mifAddressLast = $mifAddress;
                }

            #
            # Sanity save...
            #

            if(($mifAddressLast < $mifAddress)
                    || ($mifAddressLast - $mifAddress > 1000000))
                {
                $mifAddressLast = $mifAddress;
                }

            while($mifAddress <= $mifAddressLast)
                {
                for($i = 0; $i < $mifBytesPerData; $i++)
                    {
                    $hash{$mifAddress + $i} = $mifData[$i];
                    }
                $mifAddress += $mifBytesPerData;
                }
            }
        }
    
    return %hash;
    }



# -------------------------------
# hash2dat(bytesHashRef,switchesHashRef)         #width,lanes,lane,info)
#
# Returns giant string ready to be written to a file.
#
sub hash2dat
  {
  my $bytesRef = shift;
  my $switchesHashRef = shift;

  my $width = $$switchesHashRef{width};
  my $lanes = $$switchesHashRef{lanes};
  my $info = $$switchesHashRef{info};
  my $lane = $$switchesHashRef{lane};

  my $address_low = $$switchesHashRef{address_low};
  my $address_high = $$switchesHashRef{address_high};

  my $address;
  my $address_span;
  my $addressStep;
  my $bytesPerData;
  my $dataFormat;
  my $depth;
  my $result = "";

  my $i;
  my $v;
  my $line;
  my $bytesPerLine;
  my $bytesThisLine;

  
  $address_span = $address_high - $address_low;

  $bytesPerData = ceil($width / 8);

  $addressStep = $lanes * $bytesPerData;

  if ($address_span > 0) {
    $depth = log(ceil($address_span / $addressStep)) / log(2);
    $depth = ceil($depth);
    $depth = 1 << $depth;
  } else {
    $depth = 0;
  }

  #
  # Print the DAT file header
  #

  addTo \$result, sprintf("\@%08X",$address_low / $addressStep);

  $line = "";
  $bytesThisLine = 0;
  $bytesPerLine = 16;
  for($address = $address_low + $lane * $bytesPerData ; $address <= $address_high ; $address += $addressStep)
    {
    $v = "";
    for($i = 0; $i < $bytesPerData; $i++)
      {
      my $byte = sprintf("%02X", $$bytesRef{$address + $i});
      $v = $byte . $v;
      }
    $line .= "$v ";
    
    $bytesThisLine += $bytesPerData;
    if($bytesThisLine >= $bytesPerLine)
      {
      addTo \$result, $line;
      $line = "";
      $bytesThisLine = 0;
      }
    }
  addTo \$result, $line if $line ne "";

  return $result;
  }

# -------------------------------
# hash2mif(hashRef,switches_ref)
#
# Returns giant string ready to be written to a file.
#
sub hash2mif
    {
    my $bytesRef = shift;
    my $switchesHashRef = shift;

    my $width = $$switchesHashRef{width};
    my $lanes = $$switchesHashRef{lanes};
    my $info = $$switchesHashRef{info};
    my $lane = $$switchesHashRef{lane};

    my $comments = $$switchesHashRef{comments}; # comments enabled/disabled

    my $address_low = $$switchesHashRef{address_low};
    my $address_high = $$switchesHashRef{address_high};

    my $address;
    my $address_span;
    my $addressStep;
    my $bytesPerData;
    my $dataFormat;
    my $depth;
    my $result = "";

    my $mifAddress;
    my $i;
    my $v;

    $address_span = $address_high - $address_low;

    $bytesPerData = ceil($width / 8);
  
dprint "address_low is $address_low";
    $addressStep = $lanes * $bytesPerData;
    $dataFormat = "%0" . $bytesPerData * 2 . "X";

    if ($address_span > 0) {
      $depth = log(ceil($address_span / $addressStep)) / log(2);
      $depth = ceil($depth);
      $depth = 1 << $depth;
    } else {
      $depth = 0;
    }

    #
    # Print the MIF file header
    #

    addTo \$result;
    if($comments)     # MAX hates mif comments, so say --comments=0 if you're MAX.
        {
        addTo \$result, "/* This file generated by nios-convert */";
        addTo \$result, "/* $info */";
        addTo \$result, "/* " , dateTime() , " */";
        addTo \$result, "/* " , sprintf("0x%08x-0x%08x",$address_low,$address_high) , " */";
        }
    addTo \$result;
    addTo \$result, "WIDTH=", $width, ";";
    addTo \$result, "DEPTH=", $depth, ";";
    addTo \$result;
    addTo \$result, "ADDRESS_RADIX=HEX;";
    addTo \$result, "DATA_RADIX=HEX;";
    addTo \$result;
    addTo \$result, "CONTENT BEGIN";
    addTo \$result;

    $mifAddress = 0;
    for($address = $address_low + $lane * $bytesPerData ; $address <= $address_high ; $address += $addressStep)
        {
    $v = "";
        for($i = 0; $i < $bytesPerData; $i++)
            {
      my $byte = sprintf("%02X", $$bytesRef{$address + $i});
      $v = $byte . $v;
            }
        addTo \$result, sprintf(" %08X : $v;",$mifAddress++);
        }

    addTo \$result;
    addTo \$result, "END;";
    addTo \$result;
    addTo \$result, "/* End of file */";
    
    return $result;
    }

# -------------------------------------
# hash2size
#
# Returns simple table showing low, high, and span.
#
# Note: address_low and address_high are _inclusive_ byte ranges,
#       so the span is the difference plus one.
#

sub hash2size
    {
    my $bytesRef = shift;
    my $switchesHashRef = shift;

    my $address_low = $$switchesHashRef{address_low};
    my $address_high = $$switchesHashRef{address_high};
    my $address_span = $address_high - $address_low + 1;

    my $result;

    addTo \$result,$address_span;
    addTo \$result,$address_low;
    addTo \$result,$address_high;

    return $result;
    }


# -------------------------------------
# hash2srec
#
# Returns giant string ready to be written to a file.
# In the case of an srec, we do not support multi-lane
# splitting! you get one file.
#
sub hash2srec
    {
    my $bytesRef = shift;
    my $switchesHashRef = shift;

    my $width = $$switchesHashRef{width};
    my $lanes = $$switchesHashRef{lanes};
    my $info = $$switchesHashRef{info};
    my $lane = $$switchesHashRef{lane};
    my $comments = $$switchesHashRef{comments}; # comments enabled/disabled

    my $address_low = $$switchesHashRef{address_low};
    my $address_high = $$switchesHashRef{address_high};

    my $i;
    my $i_end;
    my $j;
    my $bytes_per_line = 21; # seems to be what nios-elf-oconv makes
    my $sr_addr_width = int((length(sprintf("%x",$address_high)) + 1) / 2);
    my $line;
    
    my $result;

    addTo \$result;
    if($comments)
        {
        addTo \$result, "# This file generated by nios-convert";
        addTo \$result, "# $info";
        addTo \$result, "# " , dateTime();
        addTo \$result, "# " , sprintf("0x%08x-0x%08x",$address_low,$address_high);
        }

    $sr_addr_width = 2 if $sr_addr_width < 2;
    my $sr_type = $sr_addr_width - 1;    #first character for each srec
    $sr_addr_width *= 2;    # number of characters in address

    for($i = $address_low; $i <= $address_high; $i += $bytes_per_line)
        {
        $i_end = $i + $bytes_per_line;
        $i_end = $address_high + 1 if $i_end > $address_high;
        my $checksum = 0;
        my $addr_in_hex;
        my $length_in_hex;

        $addr_in_hex = sprintf("%0${sr_addr_width}X",$i);
        $length_in_hex = sprintf("%02X",$sr_addr_width /2 + $i_end - $i + 1);

        # |
        # | Add up the checksum as if it must be 32 bits wide
        # |

        $checksum += hex(substr($addr_in_hex,0,2));
        $checksum += hex(substr($addr_in_hex,2,2));
        $checksum += hex(substr($addr_in_hex,4,2));
        $checksum += hex(substr($addr_in_hex,6,2));
        $checksum += hex($length_in_hex);

        # |
        # | begin the S-record line
        # |

        $line = "S${sr_type}" . $length_in_hex . $addr_in_hex;

        for($j = $i; $j < $i_end; $j++)
            {
            my $a_byte = $$bytesRef{$j};

            $line .= sprintf("%02X",$a_byte);
            $checksum += $a_byte;
            }

        $checksum = 255 - ($checksum & 255);
        $line .=  sprintf("%02X",$checksum);
        addTo \$result,$line;
        }
    
    return $result;
    }

# -------------------------------------
# hash2hex
#
# Returns giant string ready to be written to a file.
# In the case of an hex, we do not support multi-lane
# splitting! you get one file.
#
# BY THE WAY, the altera altsyncram VHDL model uses
# a file format which is similar to but NOT
# intel hex format. There's switches in the code below
# to emit either authentic intel hex, or modified
# variant. We call it "quartus hex format", sometimes qhex.
#
# 2004.12.15:
# Added the following switches for I-hex/EPCS/relocation:
#   --ihex=1 to emit TRUE Intel-hex (previously it was 
#     only Alterahex.
#
#   --ihex_start=<addr> to start Intel hex output
#     at an arbitrary address.
#
#   --epcs=1 to reverse each bit in each byte - very handy
#     for EPCS memory initialization when using the Quartus
#     Convert Programming Files tool. NOTE: this won't be 
#     necessary come Quartus II 4.2 SP1 as the cpf utility
#     will flip user-data. This flag will be hidden from help!
# ---------------------------------------
sub gimme_ihex_checksum($)
    {
    # |
    # | same for intel hex or altera modified hex
    # |

    my ($ihex_line) = (@_);
    my $checksum = 0;
    my $i;

    for($i = 1; $i < length($ihex_line); $i+=2)
        {
        $checksum += hex(substr($ihex_line,$i,2));
        }

    $checksum = (256 - ($checksum & 255)) & 255;
    return sprintf("%02x",$checksum);
    }

sub hash2hex($$)
    {
    my $bytesRef = shift;
    my $switchesHashRef = shift;

    my $width = $$switchesHashRef{width};
    my $info = $$switchesHashRef{info};
    my $lane = $$switchesHashRef{lane};
    my $comments = $$switchesHashRef{comments}; # comments enabled/disabled

    my $address_low = $$switchesHashRef{address_low};
    my $address_high = $$switchesHashRef{address_high};

    # |
    # | 2004.12.15:
    # | Use wronghex format unless the user asks for Intel hex 
    # | with "--ihex=1" (doing this for backwards-compatibility).
    # |
   my $ihex = $$switchesHashRef{ihex};

    # |
    # | Altera's "altsyncram" vhdl model uses a file
    # | format which is just close enough to Intel Hex Format
    # | to be infuriating. 
    # |
   my $quartus_hex_format = $ihex ? 0 : 1;
   my $use_record_2 = $quartus_hex_format;  # less-good record form
    
    # |
    # | 2004.12.15:
    # | Normaly all hex output is forced to start at address zero.
    # | BUT, for those needing some arbitraty offset, specifying
    # | --ihex_start=<offset> will yield an Intel hex 
    # | file that starts right there, regardless of the input file's
    # | offset. 
    # |
    # | This is quite useful for using the Quartus 
    # | "Convert programming files" utility to jam an INTEL hex file
    # | into an EPCS device exactly where SOF-data ends!
    # |
    my $ihex_start = $ihex ? $$switchesHashRef{ihex_start} : 0;
    
    my $address_relocation = $address_low; # force to appear at 0-ish
    $address_low -= $address_relocation;
    $address_high -= $address_relocation;
    
    # |
    # | 2004.12.15:
    # | The Nios EPCS controller SPI master reads EPCS bits out
    # | in reverse-order. This means that a user-specified hex
    # | file programmed in via the Quartus programmer will be
    # | bass-ackwards when Nios software tries to read it out. 
    # | If "--epcs=1" is specified, reverse each byte for this 
    # | purpose. 
    # |
    # | The end-result: Nios software will then read out bytes 
    # | just as they are presented in a source-file to this 
    # | conversion utility.
    # |
    # | NOTE: this won't be necessary come Quartus II 4.2 SP1 as
    # | the cpf utility will flip user-data. This flag will be hidden!
    my $epcs = $$switchesHashRef{epcs};
    
    # |
    # | For quartus modified-up format, the bytes per line
    # | must be the data width of the memory rounded up to the nearest byte.
    # | otherwise, we choose a pleasant 80-columnish size
    # |
    my $bytes_per_line = $quartus_hex_format ? int(($width + 7) / 8) : 32;

    my $result;

    # |
    # | the intel hex format is inherently segment-based.
    # | A segment is a 64k-aligned range of memory.
    # | A "segment record" affects all "data records"
    # | which come after it.
    # |
    # | So, we divide our output into segments
    # | of 64k-or-less.
    # |
    my $k_segment_size = 65536; # bytes, of course

    if($quartus_hex_format)
        {
        $k_segment_size *= $bytes_per_line;
        }

    my $lowest_segment = int(($address_low+$ihex_start) / $k_segment_size);
    my $highest_segment = int(($address_high+$ihex_start) / $k_segment_size);

dprint "address_low = $address_low, address_high = $address_high\n";
dprint "ihex_start = $ihex_start";
dprint "lowest_segment = $lowest_segment, highest_segment = $highest_segment\n";
    for(my $segment = $lowest_segment;
            $segment <= $highest_segment;
            $segment++)
        {
dprint "segment = $segment\n";

        # |
        # | emit the segment record
        # |
            {
            # |
            # | emit upper 16 bits as an "extended linear segment offset"
            # | (unless use_record_2, which offsets in
            # | units of 16 word-sizes (bytes in intel hex,
            # | or width's in quartus_hex_format))
            # |
            
            my $segment_line = ":020000";
            my $segment_value;

            if($use_record_2)  # less total range, but sometimes required
                {
                $segment_line .= "02";
                $segment_value = $segment * 4096;
                }
            else
                {
                $segment_line .= "04";
                $segment_value = $segment;
                }

            $segment_line .= sprintf("%04x",$segment_value);

            $segment_line .= gimme_ihex_checksum($segment_line);
            addTo \$result,$segment_line;
            }

        # |
        # | $segment is an index, find the actual address range
        # | (inclusive)

        my $segment_address = $segment * $k_segment_size;
        my $segment_address_end = $segment_address + $k_segment_size - 1;

        # |
        # | find range within segment to care about
        # |

        my $addr_low_in_seg = $address_low + $ihex_start;
        $addr_low_in_seg = $segment_address
                if ($segment_address > $addr_low_in_seg);

        my $addr_high_in_seg = $address_high + $ihex_start;
        $addr_high_in_seg = $segment_address_end
                if ($segment_address_end < $addr_high_in_seg);

        # |
        # | and emit all them bytes for this here segment
        # | one line at a time
        # |

dprint "addr_low_in_seg = $addr_low_in_seg\n";
dprint "addr_high_in_seg = $addr_high_in_seg\n";

        for(my $line_addr = $addr_low_in_seg;
                $line_addr <= $addr_high_in_seg;
                $line_addr += $bytes_per_line)
            {
            my $line_addr_end = $line_addr + $bytes_per_line - 1;
            if($line_addr_end > $addr_high_in_seg)
                {
                # |
                # | for altera wronghex format, we must output
                # | a full line width
                # |

                unless($quartus_hex_format)
                    {
                    $line_addr_end = $addr_high_in_seg;
                    }
                }

            my $address_to_put_to_file = $line_addr % $k_segment_size;

            if($quartus_hex_format)
                {
                # |
                # | one address increment per memory-word
                # | if you're quartis-ish up.
                # |

                $address_to_put_to_file /= $bytes_per_line;
                }
                
            my $data_line = sprintf(":%02x%04x00",
                    $line_addr_end - $line_addr + 1,
                    $address_to_put_to_file);

            # |
            # | If doing quartus version of "hex", the bytes
            # | must be placed per line (row, word, whatever)
            # | in reverse order. Stunning!
            # |

            if($quartus_hex_format)
            {
              for(my $i = $line_addr_end; $i >= $line_addr; $i--)
              {
                $data_line .= sprintf("%02x",
                  $$bytesRef{$i + $address_relocation} * 1);
              }
            }
            else
            {
              my $hex_data = 0x0;
              my $hex_temp;
              my $hex_bit;
      
              for(my $i = $line_addr; $i <= $line_addr_end; $i++)
              {
                $hex_data = $$bytesRef{$i + $address_relocation - $ihex_start} * 1;
      
                # | 
                # | 2004.12.15 -- EPCS mode: 
                # | Each byte's bits must be reversed in place
                # | as the odd-ball interface to this chip reads things
                # | out bassackwards. 
                # |
                # | NOTE: this won't be necessary come Quartus II 4.2 SP1 
                # | as the cpf utility will flip user-data. This flag will be 
                # | hidden from help!
                if($epcs)
                {
                  $hex_temp = 0;
      
                  for(my $shifter = 7; $shifter >= 0; $shifter--)
                  {
                    $hex_bit = $hex_data & 0x1;
                    $hex_temp |= ($hex_bit << $shifter);
                    $hex_data = $hex_data >> 1;
                  }
                  $hex_data = $hex_temp;   
                }
                          
                $data_line .= sprintf("%02x", $hex_data);
              } #for
            } # else

            $data_line .= gimme_ihex_checksum($data_line);

            addTo \$result,$data_line;
          } # for each line
        } # for each segment

   addTo \$result, ":00000001FF";  # end-of-file record

   return $result;
}
    

# -------------------------------------
# fcu_parse_args
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

sub fcu_parse_args
    {
    my $arg;
    my $argVal;
    my $argc;
    my %hash;

    $argc = 0;


    while($arg = shift)
        {
dprint "fcu_parse_args: $arg";

        if($arg =~ /^-+/)
            {
            if($arg =~ /^-+([^\=]*)\=(.*)$/)
                {
                $arg = $1;
                $argVal = $2;
                }
            elsif($arg =~ /^-+(.*)$/)
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

    return %hash;
    }

# -------------------------------
# getSwitch(hashRef, switchName, defaultValue [, mustBeNumber])
#
# Look at a hash as returned by fcu_parse_args, and
# give the value of the switch, or the defaultValue
# if it was not specified in the command line.
#
# If we take the default value, then assign it back
# into the switches hash, too.

sub getSwitch
    {
    my $hashRef = shift;
    my $switchName = shift;
    my $defaultValue = shift;
    my $mustBeNumber = shift;

    my $switchValue;

    $switchValue = $$hashRef{$switchName};
    $switchValue = $defaultValue if(($switchValue eq "") && ($defaultValue ne ""));

    if($mustBeNumber)
        {
        #
        # From Hex, if 0xABCD
        if($switchValue =~ /^0x(.*)$/)
            {
            $switchValue = hex($1);
            }
        $switchValue *= 1;
        }

    #
    # stash back (in decimal, if a number)
    #

    $$hashRef{$switchName} = $switchValue;

    return $switchValue;
    }


# +----------------------------------------
# | fcu_get_sdk_settings(sdk_dir) # optional argument
# |
# |  return reference to hash of a = b settings from Makefile
# |  HACK ALERT - Look in inc/excalibur.mk first if it exists
# |
# | for historical reasons, a bunch of useful constants
# | are stashed in the nios library makefile. Some of them are
# | used to control the build of the library, and come right out
# | of the system ptf description. Others are only used indirectly
# | by other tools; nios-run, for example, uses some settings to 
# | figure out whether to use jtag or serial. nios-build uses
# | them to control application compilation. And srec2flash discovers
# | the flash addresses from them.
# |
# | If they ever move, perhaps to a PTF file, this routine would
# | change.
# |
# | You can optionally pass in the root of the custom SDK.
# | If you do, then that's the only directory checked. (Or rather,
# | for now, the <sdk>/lib/ directory.
# |
# | Otherwise, we look around as if we're in the src dir of an sdk.
# |

sub fcu_get_sdk_settings
    {
    my ($sdk_dir) = (@_);
    my $dir;
    my $line;
    my %makefile_settings;
    my $got_makefile = 0;
    my @search_list;

    if($sdk_dir)
        {
        @search_list = ("$sdk_dir/inc");
        }
    else
        {
        @search_list = 
                (
                "../inc",
                "../../inc",
                "../../../inc",
                "../../../../inc",
                "../../../../../inc",
                "./inc",
                ".",
                );
        }

    foreach $dir (@search_list)
        {
        if(-e "${dir}/excalibur.mk")
            {
            # Handy extras
            $makefile_settings{sdk_inc_directory} = ${dir};
            $makefile_settings{sdk_lib_directory} = ${dir} . "../lib";

            if(open(FILE,"${dir}/excalibur.mk"))
                {
                while($line = <FILE>)
                    {
                    my $sp="[ \t]*";
                    if($line =~ /^$sp(.*?)$sp\=$sp(.*?)$sp$/)
                        {
                        $makefile_settings{$1} = $2;
                        }
                    }
                close FILE;
                }
            $got_makefile = 1;
            last;
            }
        }

    return \%makefile_settings if $got_makefile;

    if($sdk_dir)
        {
        @search_list = ("$sdk_dir/lib");
        }
    else
        {
        @search_list = 
                (
                "../lib",
                "../../lib",
                "../../../lib",
                "../../../../lib",
                "../../../../../lib",
                "./lib",
                ".",
                );
        }

    foreach $dir (@search_list)
        {
        if(-e "${dir}/Makefile")
            {
            # Handy extras
            $makefile_settings{sdk_lib_directory} = ${dir};
            $makefile_settings{sdk_inc_directory} = ${dir} . "../inc";

            if(open(FILE,"${dir}/Makefile"))
                {
                while($line = <FILE>)
                    {
                    my $sp="[ \t]*";
                    if($line =~ /^$sp(.*?)$sp\=$sp(.*?)$sp$/)
                        {
                        $makefile_settings{$1} = $2;
                        }
                    }
                close FILE;
                }
            $got_makefile = 1;
            last;
            }
        }

    return -1 if !$got_makefile;

    return \%makefile_settings;
    }



sub fcu_get_switch { return getSwitch(@_); }



# +-----------------------------------
# | fcu_text_to_hash(bigstring,format,width)
# |
# | Given a string (perhaps read from an s-record or hexout file,
# | or maybe just a string you have lying about)
# | and format you claim it to be in,
# | parse the string and return a hash of bytes, keyed numerically
# | by address
# |
# | not all formats require "width". actually, only "hex" does.
# |
sub fcu_text_to_hash
    {
    my ($bigstring,$format,$width) = (@_);
    my %bytes;

    if($format eq "mif")
        {
        %bytes = mif2hash($bigstring);
        }
    elsif($format eq "srec")
        {
        %bytes = srec2hash($bigstring);
        }
    elsif($format eq "txt")
        {
        %bytes = txt2hash($bigstring);
        }
    else
        {
        %bytes = hex2hash($bigstring,$width);
        }

    return \%bytes;
    }

# +-----------------------------------
# | fcu_hash_to_text(bigstring,format,width)
# |
# | Given a hash keyed numerically by address (perhaps one previously produced
# | by the above fcu_text_to_hash routine),  converts the hash into a string
# | format of your choosing. 
# |
# | Also expects a "switches" hash with the following keys:
# |
# | not all formats require "width". actually, only "hex" does.
# |
sub fcu_hash_to_text
{
  my $bytes_ref = shift;  # hash ref of bytes to put into text  
  my $destFormat = shift; # text describing destination format
  my $switches = shift; # get hash of all incoming arguments

  my @destFile;     # complete contents, indexed by lane

  my $lanes = getSwitch($switches,"lanes",1,1);
  my $width = getSwitch($switches,"width",16,1);
  my $comments = getSwitch($switches,"comments",1,1);
  my $to_stdout = getSwitch($switches,"stdout",0,1);
  my $just_one_lane = getSwitch($switches,"lane","all");

  for(my $lane = 0; $lane < $lanes; $lane++)
  {
    $$switches{info} .= " lane $lane of range 0.." . ($lanes-1);
    $$switches{lane} = $lane;
  dprint "Thinking about lane '$lane'";                        

    if(($just_one_lane eq "all") or ($just_one_lane eq $lane)) {
  dprint "emitting lane $lane";

      if($destFormat eq "dat")
          {
          $destFile[$lane] = hash2dat($bytes_ref,$switches);
          }
      elsif($destFormat eq "size")
          {
          $destFile[$lane] = hash2size($bytes_ref,$switches);
          }
      elsif($destFormat eq "srec")
          {
          $destFile[$lane] = hash2srec($bytes_ref,$switches);
          }
      elsif($destFormat eq "hex")
          {
          $destFile[$lane] = hash2hex($bytes_ref,$switches);
          }
      elsif($destFormat eq "mif" || 1) # default case, as well
          {
          $destFile[$lane] = hash2mif($bytes_ref,$switches);
          }

    }
    #
    # If we supported another format, we'd add it here...
    # elsif...
  }
  return \@destFile;
}

# +-------------------------
# | return the lowest and highest byte address, *inclusive*
# | so both numbers returned contain data from the s-record
# | eh ok?
# |
sub fcu_get_hash_range
    {
    my ($bytes_ref) = (@_);
    my @addresses;
    my $address_low;
    my $address_high;

    @addresses = sort    ({ $a <=> $b } keys(%$bytes_ref) );
    $address_low = $addresses[0];
    $address_high = $addresses[$#addresses];

    return ($address_low,$address_high);
    }
    
# -------------------------------------
# fcu_convert -- just like the command line version, but takes hashref of switches.
#

sub fcu_convert
    {
    my $switches = shift; # get hash of all incoming arguments

    if(getSwitch($switches,"h") or getSwitch($switches,"help"))
        {
        fcu_usage();
        }

    my $lanes;
    my $width;
    my $comments;
    my $sourceFileName;
    my $sourceFileNameBase;
    my $sourceFormat;
    my $destFileName;
    my $destFileBase;
    my $destFormat;
    my $to_stdout;
 
    my $sourceFile;     # complete contents
    my @destFile;     # complete contents, indexed by lane

    my $destFileNameBase;
    my $lane;
    my $just_one_lane;

    my $bytes_ref; # hash of address/byte for whole file contents.

    $lanes = getSwitch($switches,"lanes",1,1);
    $width = getSwitch($switches,"width",16,1);
    $comments = getSwitch($switches,"comments",1,1);
    $to_stdout = getSwitch($switches,"stdout",0,1);
    $just_one_lane = getSwitch($switches,"lane","all");

    $gDebug = getSwitch($switches,"debug",$gDebug,1);

dprint "just_one_lane is $just_one_lane";

    #
    # Source name & format
    #

    $sourceFileName = getSwitch($switches,"infile",$$switches{0});

    if($sourceFileName =~ /^(.*)\.([^.]*)$/)
        {
        $sourceFileNameBase = $1;
        $sourceFormat = $2;
        }

    $sourceFormat = getSwitch($switches,"iformat",$sourceFormat);

    #
    # Dest name & format
    #

    $destFormat = "mif";
    $destFileName = getSwitch($switches,"outfile",$$switches{1});
    if($destFileName)
        {
        if($destFileName =~ /^(.*)\.([^.]*)$/)
            {
            $destFileNameBase = $1;
            $destFormat = $2;
            }
        }

    $destFormat = getSwitch($switches,"oformat",$destFormat);      
    $destFileNameBase = ${sourceFileNameBase} if ($destFileName eq "");
    $destFileName = "${destFileNameBase}.${destFormat}";

    fcu_usage() if((!$sourceFileName) and (!$destFileNameBase));

dprint "destFormat = ",$destFormat;
dprint "destFileNameBase = ",$destFileNameBase;
dprint "destFileName = ",$destFileName;
dprint "sourceFileName = ",$sourceFileName;

    # |
    # | If we are provided a source file to convert,
    # | then, by all means, convert it. If there's
    # | no file, well, just emit them zeroes later.
    # |

    if($sourceFileName)
        {
        $sourceFile = fcu_read_file($sourceFileName);
        die "Bad file $sourceFileName" if $sourceFile eq "";

        $bytes_ref = fcu_text_to_hash($sourceFile,$sourceFormat,$width);
        }

    $sourceFile = ""; # done with source data, thankyou

    #
    # Use a rather crude method to ascertain the lowest
    # and highest addresses present in the hash.
    # Put them into the hash, unless the invoker already
    # told us.
    #
        {
        my @addresses;
        my $address_low;
        my $address_high;
        my $ihex = 0;
        my $ihex_start = 0;
        my $epcs = 0;

        @addresses = sort    ({ $a <=> $b } keys(%$bytes_ref) );
        $address_low = $addresses[0];
        $address_high = $addresses[$#addresses];

        #
        # Poke them into the options, if the invoker has not
        # provided them for us in the command line.
        #

        getSwitch($switches,"address_low",$address_low,1);
        getSwitch($switches,"address_high",$address_high,1);
        $ihex = getSwitch($switches,"ihex",$ihex,1);
        $ihex_start = getSwitch($switches,"ihex_start",$ihex_start,1);
        $epcs = getSwitch($switches,"epcs",$epcs,1);
        
        dprint "address_low is $address_low";
        dprint "address_high is $address_high";
        dprint "ihex is $ihex";
        dprint "ihex_start is $ihex_start";
        dprint "epcs is $epcs";
        }

    #
    # Generate each lane of the result file,
    # switching by destFormat
    #
dprint "just_one_lane = $just_one_lane";
dprint "About to emit $lanes lanes in a loop";

        $$switches{info} = "source file: $sourceFileName,";
        my $destFile_ref = 
          &fcu_hash_to_text ($bytes_ref, $destFormat, $switches);
        @destFile = @{$destFile_ref};

    #
    # If the output is "stdout", return the string intact.
    #

    if($to_stdout)
        {
        return $destFile[$just_one_lane * 1]; # becomes zeroth lane if "all"
        }

    #
    # Else, print each file.
    #

    # Write a file for each lane.
    # Perhaps we send it to stdout by telling fcu_write_file 
    # a blank file name.
    #
    for($lane = 0; $lane < $lanes; $lane++)
        {
        if(($lanes > 1) && ($just_one_lane eq "all"))
            {
            $destFileName = $destFileNameBase . "_lane_" . $lane . "." . $destFormat;
            }

        fcu_write_file($destFileName,$destFile[$lane]) if $destFile[$lane];
        }
    
    return "";
    }

sub fcu_get_address_range
    {
    my $filename = shift;
    my $nc_result;

    $nc_result = fcu_convert
            ({
            0 => $filename,
            stdout => 1,
            oformat => "size"
            });
            
    return split(/\s/,$nc_result);
    }

# -------------------------------------
sub fcu_usage
    {
    print <<EOP;

         nios-convert --infile=<file> --outfile=<file> [options]

  sourceFile can be .srec or .mif
  destFile will get same name as sourceFile if omitted

  If no address range is specified, the entire source file
  is converted. If the oformat is mif, the first address in
  the mif file is always zero.

        --infile=<file>  : name of file to convert
        --outfile=<file> : name of file to emit
        --lanes=x        : break up into multiple output files, with _lane_0 .. _lane_(x-1) appended
        --width=x        : set output width to 8, 16, or 32
        --oformat=f      : format can be mif or dat or size or srec or hex
        --iformat=f      : format can be mif or size or txt or srec
        --comments=b     : comments in mif file enabled (1) or disabled (0). Default is enabled
        --stdout         : print result to stdout (forces lanes=1)
        --lane=x         : output only lane x
        --address_low=x  : lowest address to emit (range is inclusive)
        --address_high=x : highest address to emit (range is inclusive)
        --ihex=<0|1>     : for oformat=hex only: emit Intel hex (as opposed to Altera hex)
        --ihex_start=x   : start-address to emit in Intel hex file 
"nios-convert"

nios-convert is a tool to convert files between several
formats. The formats supported are S-record, mif, and dat.
These are three formats used in Nios hardware and software
development. S-records are used to download code to the
Germs monitor. mif files are used to specify the contents
of Nios ROM and RAM devices. dat files are used as data for
Modelsim to simulate a Nios hardware design.

It is sometimes necessary to break up a file into individual
"lanes"; if the --lanes option is used for more than 1 lane,
then the result files will have the names "lane_0", "lane_1",
&c, appended to them.


EOP


    exit(0);
    }

# Every .pm ends with success

return 1;

# end of file
                                                                                             
