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
package e_fifo_with_registered_outputs;
use europa_utils;
@ISA = ("e_instance");
use strict;












my %fields = ( depth => 4 );

my %pointers = ();

&package_setup_fields_and_pointers( __PACKAGE__, \%fields, \%pointers, );

sub new {
 my $class = shift;
 my $this  = $class->SUPER::new(@_);
 $this->setup_module;
 return $this;
}

sub setup_module {
 my $this = shift;

 my $name = $this->name() || ribbit("Please setup a name for the module");
 my $mod = e_module->new( { name => $name . "_module" } );

 my $depth = $this->depth();
 my $width = 8;

 my @width_conduit_array = ( "data_in", "data_out" );

 e_assign->new( [ "data_out", "stage_0" ] )->within($mod);
 e_assign->new( [ "full",     "full_" . ( $depth - 1 ) ] )->within($mod);
 e_assign->new( [ "empty",    "!full_0" ] )->within($mod);


 e_assign->new( [ "full_$depth", 0 ] )->within($mod);

 for ( my $stage = $depth - 1 ; $stage >= 0 ; $stage-- ) {
  my $higher_stage;
  if ( $stage < $depth - 1 ) {
   $higher_stage = "stage_" . ( $stage + 1 );
  }
  else {
   $higher_stage = "data_in";
  }
  my $out      = "stage_$stage";
  my $data_mux = e_mux->new(
   {
    name => "data_$stage",
    type => "selecto",




    selecto => "full_" . ( $stage + 1 ) . " & ~clear_fifo",
    table => [
     0 => "data_in",
     1 => $higher_stage,
    ],
    out      => "p$stage\_$out",
   }
  );
  
  my $lower_control_bit = "full_" . ($stage + 1);
  my $data_reg = e_register->new(
   {
    name => "data_reg_$stage",
    in => "p$stage\_$out",
    out => "$out",
    sync_reset => "sync_reset & full_$stage & !(($lower_control_bit == 0) & read & write)",
    enable => "clear_fifo | sync_reset | read | (write & !full_$stage)",
   }
  );
    
  push( @width_conduit_array, $out );
  $mod->add_contents($data_mux);
  $mod->add_contents($data_reg);
  
  my $lower_control_stage;
  my $higher_control_stage;
  if ( $stage != 0 ) {
   $higher_control_stage = "full_" . ( $stage - 1 );
  }
  else {
   $higher_control_stage = 1;
  }
  if ( $stage < $depth - 1 ) {
   $lower_control_stage = "full_" . ( $stage + 1 );
  }
  else {
   $lower_control_stage = 0;
  }

  my $control_mux = e_mux->new(
   {
    name    => "control_$stage",
    type    => "selecto",
    selecto => "(read & !write)",
    table   => [
     0 => $higher_control_stage,
     1 => $lower_control_stage,
    ],
    out => "p$stage\_full_$stage",
   }
  );
 
  my $clear_fifo = "clear_fifo";
  if($stage == 0)
  {
    $clear_fifo = "clear_fifo & ~write";
  }

  my $control_reg = e_register->new(
   {
    name       => "control_reg_$stage",
    in         => "p$stage\_full_$stage",
    out        => "full_$stage",
    enable     => "clear_fifo | (read ^ write) | (write & !full_0)",
    sync_reset => $clear_fifo,
   }
  );






  $mod->add_contents($control_mux);
  $mod->add_contents($control_reg);
 }
 
 my $how_many_ones = "how_many_ones";
 my $one_count_plus_one = "one_count_plus_one";
 my $one_count_minus_one = "one_count_minus_one";
 my $updated_one_count = "updated_one_count";

 e_signal->new({ name => $how_many_ones, width => (Bits_To_Encode($depth) + 1)})
               ->within($mod);

 e_assign->new([$one_count_plus_one, "$how_many_ones + 1"])->within($mod);
 e_assign->new([$one_count_minus_one, "$how_many_ones - 1"])->within($mod);

 e_width_conduit->new( [
                         $how_many_ones,
                         $one_count_plus_one,
                         $one_count_minus_one,
                         $updated_one_count
                       ]
		       )->within($mod);
          
 e_mux->new(
  {
    name      => "updated_one_count",
    table     => [
                   "((clear_fifo | sync_reset) & !write)" => "0",
                   "((clear_fifo | sync_reset) & write)" => "|data_in",
                   "read & (|data_in) & write & (|stage_0)"
                               => $how_many_ones,
                   "write & (|data_in)"  => $one_count_plus_one,
                   "read & (|stage_0)"  => $one_count_minus_one
                 ],
    default   => $how_many_ones,
    out       => $updated_one_count,
  }
 )->within($mod);
                   					
 e_register->new(
  {
   name        => "counts how many ones in the data pipeline",
   in          => $updated_one_count,
   out         => $how_many_ones,
   enable      => "clear_fifo | sync_reset | read | write",
  }
 )->within($mod);

 e_register->new(
  {
   name        => "this fifo contains ones in the data pipeline",
   in          => "~(|$updated_one_count)",
   out         => "fifo_contains_ones_n",
   enable      => "clear_fifo | sync_reset | read | write",
   async_value => "1",
  }
 )->within($mod);

 e_width_conduit->new( \@width_conduit_array )->within($mod);
 $this->module($mod);
}

return 1;
