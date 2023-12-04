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







=head1 NAME

e_ptf_master - description of the module goes here ...

=head1 SYNOPSIS

The e_ptf_master class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_ptf_master;

use e_ptf_slave;

@ISA = ("e_ptf_slave");
use strict;
use europa_utils;







my %fields = (
              _already_updated => 0,
              );

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<_get_exclusively_named_port_by_type()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_exclusively_named_port_by_type
{
   my $this = shift;

   my $type = shift or &ribbit ("no type");

   my $return = 
       $this->_get_exclusively_named_port_or_its_complement
           ($type);


   $return = ""
       if (
           ($type =~ /^read(\_n)?$/) &&
           !($this->_get_exclusively_named_port_or_its_complement
            ("readdata")
             )
           );


   $return = ""
       if (
           ($type =~ /^write(\_n)?$/) &&
           !($this->_get_exclusively_named_port_or_its_complement
            ("writedata")
             )
           );




   if ($return && ($type =~ /^address(_n)*/))
   {
     $return .= "_to_slave";
   }
   
   return $return;
}







=item I<_get_actual_master_address()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_actual_master_address
{
   my $this = shift;

   return $this->_get_exclusively_named_port_or_its_complement
           ('address');
}



=item I<_get_address_width()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_address_width
{
   my $this = shift;


   my ($port) = $this->_get_port_or_its_complement('address', 'e_port');

   my $width = 0;
   if ($port)
   {
     $width = $port->width();
   }
   
   return $width;
}

=item I<_make_address_shunt()>

The address from the master comes into the master arbitrator,
goes through a piece of combinational logic, and goes out
to each slave.

The generated logic depends on ptf option
 <system>/WIZARD_SCRIPT_ARGUMENTS/optimize_master_address
which defaults to 1.
The address shunt logic is either
1) A simple assignment (optimize_master_address = 0)
2) Logic which attempts to capitalize on knowledge of
  all the master's slaves' base addresses and ranges.
  (optimize_master_address = 1, or the assignment doesn't exist).

=cut

sub _make_address_shunt
{
   my $this = shift;
   
   my $pm = $this->parent_module();
   my $module_name = $pm->name();
   my $master_name = $this->name();
   my $master_desc = "$module_name/$master_name";
   
   my $master_address = $this->_get_exclusively_named_port_by_type("address");
   return if !$master_address;

   my $thing_name = "$master_desc address to slave";
   
   my $assign = $this->_arbitrator()->get_and_set_once_by_name({
     comment => "optimize select-logic by passing only those address bits which matter.",
     thing => 'assign',
     name => $thing_name,
   });
   

   return if !$assign;
   
   my $address_width = $this->_get_address_width();
   my $actual_master_address = $this->_get_actual_master_address();
   


   $assign->lhs(e_signal->new([$master_address, $address_width, 1]));

   my $project = $pm->project();
   my $wsa =
     $project->spaceless_system_ptf()->{WIZARD_SCRIPT_ARGUMENTS};
   



   my $do_opt = $wsa->{optimize_master_address};
   $do_opt = 1 if !exists($wsa->{optimize_master_address});






   my $rhs;
   if (!$do_opt || $this->is_adapter())
   {

     $rhs = $actual_master_address;
   }
   else
   {



      
      my ($volatile_address_mask, $constant_address_value) =
           _get_volatile_and_constant_address_bits(
              $project,
              $module_name,
              $master_name,
              $master_desc);
              





      



      
      my @bits;
      my $ms_bit_index = $address_width - 1;
      my $ls_bit_index = $ms_bit_index - 1;
      while (1)
      {

        my $ms_bit_index_mask = 1 << $ms_bit_index;
        my $ls_bit_index_mask = 1 << $ls_bit_index;
        
        my $is_volatile_ms_bit =
          ($ms_bit_index_mask & $volatile_address_mask) ? 1 : 0;
        my $is_volatile_ls_bit =
          ($ls_bit_index_mask & $volatile_address_mask) ? 1 : 0;
          
        if (($ls_bit_index == -1) || ($is_volatile_ms_bit != $is_volatile_ls_bit))
        {
          my $term;







          if ($is_volatile_ms_bit)
          {


            $term = "$actual_master_address\[$ms_bit_index : @{[$ls_bit_index + 1]}]";
          }
          else
          {


            

            my $width = $ms_bit_index - $ls_bit_index;

            my $const_bits_mask = get_mask_of_1_bits($ms_bit_index + 1);
            if ($ls_bit_index > -1)
            {

              $const_bits_mask &= ~get_mask_of_1_bits($ls_bit_index);
            }
              

            my $const_bits = ($const_bits_mask & $constant_address_value) >> ($ls_bit_index + 1);
            

            $term = sprintf("%d'b%b", $width, $const_bits)
          }
          

          push @bits, $term;

          $ms_bit_index = $ls_bit_index;
        }



        last if $ls_bit_index == -1;
        




        $ls_bit_index--;
      }
      
      $rhs = concatenate(@bits);
      



      $this->_make_master_address_assertion(
        $master_desc,
        $volatile_address_mask,
        $constant_address_value,
        $address_width,
        $actual_master_address
      );
   }

   $assign->rhs($rhs);
}



=item I<_get_volatile_and_constant_address_bits()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_volatile_and_constant_address_bits
{
  my ($project, $module_name, $master_name, $master_desc) = @_;

  my @slave_names =
    $project->get_slaves_by_master_name($module_name, $master_name);

  my @base_and_last_addresses = ();
  
  for my $slave_desc (@slave_names)
  {

    next if ($project->SBI($slave_desc)->{Has_Base_Address} eq "0");
    
    my ($address_width, $base_addr, $last_addr) = 
      master_address_width_from_slave_parameters(
        $project, $master_desc, $slave_desc);

    push @base_and_last_addresses, ($base_addr, $last_addr);
  }




  return (0, 0) if (!@base_and_last_addresses);

  ribbit("Empty list!\n") if !@base_and_last_addresses;


  ribbit("Odd number of elements!") if (0 + @base_and_last_addresses & 1);



  map {if (/^0/) {$_ = oct($_)}} @base_and_last_addresses;



  my $base;
  map {

    if (!($_ & 1))
    {
      $base = $base_and_last_addresses[$_];
    }
    else
    {

      my $delta = $base_and_last_addresses[$_] - $base;
      if ($delta > 1)
      {








        $base_and_last_addresses[$_] = $base + next_higher_power_of_two($delta) - 1;
      }
    }
  } (0 .. @base_and_last_addresses - 1);
  













  my @shifted_addrs = @base_and_last_addresses;
  pop @base_and_last_addresses;
  shift @shifted_addrs;

  my $vol = 0;
  for (0 .. @base_and_last_addresses - 1)
  {
    $vol |= $base_and_last_addresses[$_] ^ $shifted_addrs[$_];
  }


  my $const = $base_and_last_addresses[0] & ~$vol;
  
  return ($vol, $const);
}



=item I<_can_handle_read_latency()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _can_handle_read_latency
{
   my $this = shift;
   return ($this->_get_exclusively_named_port_by_type
       ("readdatavalid") ne "");
}


















=item I<_make_master_address_assertion()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _make_master_address_assertion
{
  my $this = shift;
  my (
    $master_desc,
    $volatile_address_mask,
    $constant_address_value,
    $address_width,
    $actual_master_address
  ) = @_;



  my $allegedly_constant_bits =
    get_mask_of_1_bits($address_width) & (~$volatile_address_mask);



  if ($allegedly_constant_bits != 0)
  {
    my $master_sbi = $this->{SYSTEM_BUILDER_INFO};










    my $master_cs =
      $this->_get_exclusively_named_port_or_its_complement("chipselect");
    my $master_read =
      $this->_get_exclusively_named_port_or_its_complement("read");
    my $master_write =
      $this->_get_exclusively_named_port_or_its_complement("write");
    my @access;
    if ($master_write && $master_sbi->{Make_Write_Address_Bounds_Assertion})
    {
      push @access, $master_write;
    }

    if ($master_read && $master_sbi->{Make_Read_Address_Bounds_Assertion})
    {
      push @access, $master_read;
    }



    return if !@access;

    my $select = and_array($master_cs, or_array(@access));




    $this->_arbitrator()->add_contents(
      e_process->new({
        tag => 'simulation',
        contents => [
          e_if->new({
            condition =>
              sprintf(
                "($select && " .
                "($actual_master_address & %d'b%b) != %d'b%b)",
                $address_width,
                $allegedly_constant_bits,
                $address_width,
                $constant_address_value),
            then => [
              e_sim_write->new({show_time => 1,
                                spec_string =>
                "Assertion failure: master '$master_desc' attempted to " .
                "address outside its allowed range"}),
              e_stop->new(),
            ],
          }),
        ],
      }),
    );
  }
}

1;

=back

=cut

=head1 EXAMPLE

Here is a usage example ...

=head1 AUTHOR

Santa Cruz Technology Center

=head1 BUGS AND LIMITATIONS

list them here ...

=head1 SEE ALSO

The inherited class e_ptf_slave

=begin html

<A HREF="e_ptf_slave.html">e_ptf_slave</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
