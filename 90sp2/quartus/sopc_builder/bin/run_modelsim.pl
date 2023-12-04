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

$| = 1;         # set flushing on STDOUT

    # commands are passed in via a single argument, comma-delimited.

    my $in_cmd = shift;
    my ($modelsim_dir, $system_dir, $system_name) = split ',',$in_cmd;

    # get simulation directory name

    my $sim_dir;
    $sim_dir = "${system_name}_sim";

    # get full path to sim dir as dest

    my $dest;
    $dest  = "$system_dir/$sim_dir";

    # build up command to run Modelsim

    my $executable;
    my @cmd;
    $modelsim_dir .= "/" if $modelsim_dir ne "";

    if ($^O =~ /win/i)
    {
        # windows
        push(@cmd,"${modelsim_dir}modelsim");
    }
    else
    {
        # non-windows
        push(@cmd,"${modelsim_dir}vsim","-i");
    }

    push(@cmd,"$sim_dir.mpf");

    # change to project directory
    chdir "$dest";
    
    # Check to make sure they have an mpf file and 
    # give them the most likely cause
    # if they don't
    if (! -e "$sim_dir.mpf")
    {
        print "\n";
        print "Warning! Could not find $sim_dir.mpf in $dest\n";
        print "If you have not set the Modelsim Directory Path\n";
        print "(under File SOPC Builder Setup), please do so\n";
        print "and regenerate. \n";
    }

    # debug: print out command-line
    print "Command Line: @cmd \n";

    # run Modelsim
    my $result = (0xffff & system(@cmd)) >> 8;
    # print "result=$result\n";

exit($result);

