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

e_lpm_altsyncram - description of the module goes here ...

=head1 SYNOPSIS

The e_lpm_altsyncram class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_lpm_altsyncram;
use e_lpm_base;
@ISA = ("e_lpm_base");

use strict;
use europa_utils;





=item I<vhdl_declare_component()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub vhdl_declare_component
{
return q[
component altsyncram 
   generic
      (operation_mode                     : string  := "single_port";
      width_a                             : integer := 8;
      widthad_a                           : integer := 2;
      numwords_a                          : integer := 4;
      outdata_reg_a                       : string  := "unregistered";    
      address_aclr_a                      : string  := "none";    
      outdata_aclr_a                      : string  := "none";    
      indata_aclr_a                       : string  := "clear0";    
      wrcontrol_aclr_a                    : string  := "clear0";    
      byteena_aclr_a                      : string  := "none";    
      width_byteena_a                     : integer := 1;    
      width_b                             : integer := 8;
      widthad_b                           : integer := 4;
      numwords_b                          : integer := 4;
      rdcontrol_reg_b                     : string  := "clock1";    
      address_reg_b                       : string  := "clock1";    
      indata_reg_b                        : string  := "clock1";    
      wrcontrol_wraddress_reg_b           : string  := "clock1";    
      byteena_reg_b                       : string  := "clock1";    
      outdata_reg_b                       : string  := "unregistered";    
      outdata_aclr_b                      : string  := "none";    
      rdcontrol_aclr_b                    : string  := "none";    
      indata_aclr_b                       : string  := "none";    
      wrcontrol_aclr_b                    : string  := "none";    
      address_aclr_b                      : string  := "none";    
      byteena_aclr_b                      : string  := "none";    
      clock_enable_input_a                : string  := "normal";
      clock_enable_output_a               : string  := "normal";
      clock_enable_input_b                : string  := "normal";
      clock_enable_output_b               : string  := "normal";
      width_byteena_b                     : integer := 1;    
      byte_size                           : integer := 8; 
      read_during_write_mode_mixed_ports  : string  := "dont_care";    
      ram_block_type                      : string  := "auto";    
      init_file                           : string  := "unused";    
      init_file_layout                    : string  := "unused";    
      maximum_depth                       : integer := 0;    
      intended_device_family              : string  := "stratix";
      lpm_hint                            : string  := "unused";
      lpm_type                            : string  := "altsyncram" );

   port (wren_a, wren_b, aclr0,
           aclr1, addressstall_a,
           addressstall_b          : in std_logic                                          := '0';
        rden_b, clock0, clock1,
           clocken0, clocken1      : in std_logic                                          := '1';
        data_a                     : in std_logic_vector(width_a - 1 downto 0)             := (others => '0');
        data_b                     : in std_logic_vector(width_b - 1 downto 0)             := (others => '0');
        address_a                  : in std_logic_vector(widthad_a - 1 downto 0)           := (others => '0');
        address_b                  : in std_logic_vector(widthad_b - 1 downto 0)           := (others => '0');
        byteena_a                  : in std_logic_vector( (width_byteena_a  - 1) downto 0) := (others => 'z');
        byteena_b                  : in std_logic_vector( (width_byteena_b  - 1) downto 0) := (others => 'z');
        q_a                        : out std_logic_vector(width_a - 1 downto 0);
        q_b                        : out std_logic_vector(width_b - 1 downto 0));

end component;
];
}



=item I<set_port_map_defaults()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub set_port_map_defaults
{


   my $this = shift;
   $this->port_map({addressstall_a => 0,
                    addressstall_b => 0,
                    clocken0 => 1,
                    clocken1 => 1,
                 });
}



=item I<set_parameter_map_defaults()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub set_parameter_map_defaults
{

   my $this = shift;
   $this->set_b_clock(0);
}



=item I<set_b_clock()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub set_b_clock
{
   my $this = shift;
   if (@_)
   {
      my $val = shift;
      $val =~ s/^(\d)/clock$1/;

      foreach my $parameter qw(
                               rdcontrol_reg_b
                               address_reg_b
                               indata_reg_b
                               wrcontrol_wraddress_reg_b
                               byteena_reg_b
                               )
      {
         $this->parameter_map({rdcontrol_reg_b => $val});
      }
   }
}



=item I<set_autoparameters()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub set_autoparameters
{
   my $this = shift;
   my $return = $this->SUPER::set_autoparameters(@_);

   my $parameter_map = $this->parameter_map();
   foreach my $port ('a','b')
   {

      my $word_size = $parameter_map->{"widthad_$port"};
      $this->parameter_map({"numwords_$port" => 2**$word_size});


      my $byteenable_port = "byteena_$port";
      if ($this->port_map()->{$byteenable_port} eq '')
      {
         my $datawidth = $parameter_map->{"width_$port"};
         my $bytewidth = $datawidth / 8;
         $this->port_map({$byteenable_port => "{$bytewidth\{1\'b1\}}"});

         $this->parameter_map({width_byteena_a => $bytewidth});
      }
   }

   my $device = $this->parent_module()->project()->device_family();
   my $Device = $device;
   $Device =~ s/^(\w)(.*)$/$1.lc($2)/e;
   $this->parameter_map({intended_device_family => $Device});
   return $return;
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

The inherited class e_lpm_base

=begin html

<A HREF="e_lpm_base.html">e_lpm_base</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
