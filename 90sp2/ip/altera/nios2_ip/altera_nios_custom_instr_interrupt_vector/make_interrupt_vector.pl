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


































use europa_all;
use e_custom_instruction_slave;
use strict;

$| = 1;     # Always flush stderr





our $datapath_sz = 32;


our $bytes_per_vector = 8;


our %ci_slave_gen_funcs = (
        "interrupt_vector" => \&make_interrupt_vector,
    );


{
    my @arguments = (@ARGV);
    my $project = e_project->new(@arguments);


    my %Opt = copy_of_hash($project->WSA());

    validate_options(\%Opt);

    my $module = $project->top();
    my $marker = e_default_module_marker->new($module);


    my $slave_hash = $project->spaceless_module_ptf()->{SLAVE};
    foreach my $slave_name (keys(%$slave_hash)) {
        my $slave_SBI = $slave_hash->{$slave_name}{SYSTEM_BUILDER_INFO};


        if ($slave_SBI->{Is_Enabled} eq "0") {
            next;
        }


        if ($slave_hash->{$slave_name}{SYSTEM_BUILDER_INFO}{Bus_Type} 
          ne "nios_custom_instruction") {
            next;
        }

        my $func = $ci_slave_gen_funcs{$slave_name};

        if (!defined($func)) {
            my @supported_funcs = keys(%ci_slave_gen_funcs);

            print("Cannot generate slave $slave_name. Supported: @supported_funcs\n");
            ribbit("Bye now");
        }


        my $submodule = &$func(\%Opt, $project, $module, $slave_SBI);
        e_instance->add({module => $submodule});
    }

    $project->output();     # DONE!
}

sub 
make_interrupt_vector
{
    my ($Opt, $project, $parent, $slave_SBI) = @_;


    my $cpu_master_ref = $slave_SBI->{MASTERED_BY};
    my @cpu_master_ids = (keys %$cpu_master_ref);
    my $cpu_master_id = $cpu_master_ids[0];


    my ($cpu_name, $cpu_interface) = split(/\//, $cpu_master_id);

    my $submodule = 
      e_module->new({name => $cpu_name . "_interrupt_vector_compute_result"});
    my $marker = e_default_module_marker->new($submodule);

    e_port->adds(
      ["result"                  => $datapath_sz,      "out" ],
      ["ipending"                => 32,                "in"  ],
      ["estatus"                 => 1,                 "in"  ],
    );

    e_custom_instruction_slave->new({
        name     => "interrupt_vector",
        type_map => {
            result             => "result",
            ipending           => "ipending",
            estatus            => "estatus",
            },
    })->within($parent);

    my $offset_expr = compute_result($project, $cpu_name);

    e_assign->adds(

      [["result_no_interrupts", 1], 
         "(ipending == 0) | (estatus == 0)"],
        
      [["result_offset", $datapath_sz-1], $offset_expr],

      [["result", $datapath_sz], "{result_no_interrupts, result_offset}"],
    );

    return $submodule;
}


sub
compute_result
{
    my ($project, $cpu_name) = @_;

    my $data_master_id = join("/", $cpu_name, "data_master");

    my $data_master_irq_hash_ref = $project->get_module_slave_hash(
      ["SYSTEM_BUILDER_INFO", "IRQ_MASTER", $data_master_id, 
      "IRQ_Number"]);


    my @irqs;
    my $irq;

    foreach $irq (values(%$data_master_irq_hash_ref)) {

        next unless ($irq =~ /^\d+$/);


        my $is_dup_irq = 0;
        foreach my $dup_irq (@irqs) {
            if ($irq == $dup_irq) {
                $is_dup_irq = 1;
            }
        }

        next if ($is_dup_irq);

        push(@irqs, $irq);
    }


    @irqs = sort {$a <=> $b} @irqs;



    my $offset_expr;
    my $num_irqs = scalar(@irqs);

    if ($num_irqs > 0) {
        for (my $index = 0; $index < $num_irqs; $index++) {
            my $irq = $irqs[$index];
            my $offset = $irq * $bytes_per_vector;

            if ($index == ($num_irqs - 1)) {

                $offset_expr .= "$offset";
            } else {
                $offset_expr .= "ipending[$irq] ? $offset : ";
            }
        }
    } else {

        $offset_expr = "0";
    }

    return $offset_expr;
}

sub 
validate_options
{
    my ($Opt) = @_;

    validate_parameter({hash    => $Opt,
                        name    => "Data_Width",
                        type    => "integer",
                        default => $datapath_sz,
                        allowed => [$datapath_sz],
                       });
}
