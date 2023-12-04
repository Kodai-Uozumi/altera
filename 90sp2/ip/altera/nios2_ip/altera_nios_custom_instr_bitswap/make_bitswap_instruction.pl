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

my @arguments =  (@ARGV);
my $project = e_project->new(@arguments);


my %Options = &copy_of_hash($project->WSA());

&make_bitswap_instruction ($project->top(), \%Options);

$project->output();


sub validate_bitswap_options
{
  my ($Opt) = (@_);
  &validate_parameter ({hash    => $Opt,
                        name    => "Data_Width",
                        type    => "integer",
                        default => 32,
                       });
}

sub make_bitswap_instruction 
{
  my ($module, $Opt) = (@_);
  &validate_bitswap_options ($Opt);

  my $datawidth = $Opt->{Data_Width};
  $module->add_contents (
      e_port->new (["dataa",  $Opt->{Data_Width}, "in" ]),
      e_port->new (["datab",  $Opt->{Data_Width}, "in" ]),
      e_port->new (["result", $Opt->{Data_Width}, "out"]),
      e_custom_instruction_slave->new ({
          name     => "s1",
          type_map => {
            result => "result",
            dataa  => "dataa",
            datab  => "datab",
          },
      }),
  );
  for (my $i=0; $i < ($Opt->{Data_Width}); $i++) {
    $module->add_contents (
      e_assign->new (["result[($datawidth - $i - 1)]", "dataa[$i]"]),
    );
  }

}


