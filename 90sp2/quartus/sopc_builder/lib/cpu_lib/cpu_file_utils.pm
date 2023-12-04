#Copyright (C)2001-2008 Altera Corporation
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


























package cpu_file_utils;
use Exporter;
@ISA = Exporter;
@EXPORT = qw(
    &rmtree
    &make_contents_file_for_ram
);

use cpu_utils;
use strict;





our $rand_seeded = 0;














sub 
rmtree
{
    my $filename = shift;
    my $files_not_deleted = 0;

    if (-d $filename) {
        my $dirname = $filename;

        opendir DIR,$dirname;
        my @files = readdir DIR;
        closedir DIR;

        my $file;
        foreach $file (sort(@files)) {
            if($file ne "." and $file ne "..") {
                $files_not_deleted += rmtree("$dirname/$file");
            }
        }


        $files_not_deleted += rmdir($dirname) - 1;  
    } elsif(-e $filename) {


        $files_not_deleted += unlink($filename) - 1;   
    }

    return $files_not_deleted;
}








sub
make_contents_file_for_ram
{
    my $args = shift;       # Hash reference to all arguments

    my $filename_no_suffix = not_empty_scalar($args, "filename_no_suffix");
    my $data_sz = manditory_int($args, "data_sz");
    my $num_entries = manditory_int($args, "num_entries");
    my $value_str = not_empty_scalar($args, "value_str");
    my $clear_hdl_sim_contents = 
      manditory_bool($args, "clear_hdl_sim_contents");
    my $do_build_sim = manditory_bool($args, "do_build_sim");
    my $system_directory = not_empty_scalar($args, "system_directory");
    my $simulation_directory = not_empty_scalar($args, "simulation_directory");





    my $make_dat_hex = $do_build_sim;

    my $nib;

    if ($num_entries > 0xfffff) {
        &$error("Number of entries of $num_entries exceeds maximum of" .
          " 0xfffff (hex file format limitation)");
    }

    my $addr_bits = count2sz($num_entries);
    my $addr_nibbles = int(($addr_bits + 3) / 4);
    my $data_nibbles = int(($data_sz + 3) / 4);
    my $data_bytes   = int(($data_sz + 7) / 8);
    my $addr_hex_fmt = "%0" . $addr_nibbles . "x";
    my $mif_filename = $filename_no_suffix . ".mif";
    my $mif_pathname = $system_directory . "/" . $mif_filename;
    my $dat_filename = $filename_no_suffix . ".dat";
    my $dat_pathname = $simulation_directory . "/" . $dat_filename;
    my $hex_filename = $filename_no_suffix . ".hex";
    my $hex_pathname = $simulation_directory . "/" . $hex_filename;


    if (!open(MIF_FD, ">$mif_pathname")) {
        &$error("Can't open $mif_pathname for writing\n");
    }
    print MIF_FD "WIDTH=$data_sz;\n";
    print MIF_FD "DEPTH=$num_entries;\n";
    print MIF_FD "\n";
    print MIF_FD "ADDRESS_RADIX=HEX;\n";
    print MIF_FD "DATA_RADIX=HEX;\n";
    print MIF_FD "\n";
    print MIF_FD "CONTENT BEGIN\n";
    print MIF_FD "\n";

    if ($make_dat_hex) {

        if (!open(DAT_FD, ">$dat_pathname")) {
            &$error("Can't open $dat_pathname for writing\n");
        }
        printf DAT_FD ("\@" . $addr_hex_fmt . "\n", 0);
    

        if (!open(HEX_FD, ">$hex_pathname")) {
            &$error("Can't open $hex_pathname for writing\n");
        }
    }


    if (($value_str eq "random") && !$rand_seeded) {
        $rand_seeded = 1;
        srand(0xdeadbeef);
    }


    my $zero_val = "";
    for ($nib = 0; $nib < $data_nibbles; $nib++) {
        $zero_val .= "0";
    }



    for (my $addr = 0; $addr < $num_entries; $addr++) {

        my $val = "";

        if ($value_str eq "random") {
            my $extra_bits_first_nibble = 4*$data_nibbles - $data_sz;
            my $bits_first_nibble = 4 - $extra_bits_first_nibble;
            my $first_nibble_limit = 1 << $bits_first_nibble;

            for ($nib = 0; $nib < $data_nibbles; $nib++) {
                my $nibble_limit = ($nib == 0) ? $first_nibble_limit : 16;

                $val .= sprintf("%x", int(rand($nibble_limit)));
            }
        } else {
            if ($value_str eq "0") {

                $val = $zero_val;
            } else {
                $val = $value_str;
            }
        }

        if (length($val) != $data_nibbles) {
            &$error("make_contents_file_for_ram $filename_no_suffix has bad" .
              " value_str of '$val'. Must be $data_nibbles nibbles");
        }

        my $hdl_val = $clear_hdl_sim_contents ? $zero_val : $val;
        my $sof_val = $val;


        printf MIF_FD ("$addr_hex_fmt : $sof_val;\n", $addr);

        if ($make_dat_hex) {

            print DAT_FD "$hdl_val\n";
    

            if (($addr & 0xffff) == 0) {





                my $segment = ($addr & 0x000f0000) >> 4;
                writeHexLine(sprintf("02000002%04x", $segment));
            }
    

            writeHexLine(sprintf("%02x%04x00%s%s", 
              $data_bytes, 
              $addr & 0xffff, 
              ($data_nibbles & 0x1) ? "0" : "",
              $hdl_val));
         }
    }


    print MIF_FD "\nEND;\n";
    close(MIF_FD);

    if ($make_dat_hex) {

        print HEX_FD ":00000001FF\n";
        close(HEX_FD);


        close(DAT_FD);
    }
}







sub
writeHexLine
{
    my $hexLine = shift;
    my $len = length($hexLine);       
    my $sum = 0;

    if ($len & 0x1) {
        &$error("'$hexLine' isn't an even number of nibbles");
    }


    for (my $i = 0; $i < $len; $i +=2) {
        $sum += hex(substr($hexLine,$i,2));
    }

    my $checksum = (0x100 - ($sum & 0xff)) & 0xff;


    printf HEX_FD (":%s%02x\n", $hexLine, $checksum);
}

1;
