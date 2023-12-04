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

e_ptf_class_update_to_2_0 - description of the module goes here ...

=head1 SYNOPSIS

The e_ptf_class_update_to_2_0 class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_ptf_class_update_to_2_0;

use e_ptf_update_to_2_0;
@ISA = ("e_ptf_update_to_2_0");
use e_ptf;
use europa_utils;
use strict;







my %fields   = ();
my %pointers = ();



=item I<new()>

Object constructor

=cut

sub new
{
   my $this  = shift;
   my $self = bless __PACKAGE__->SUPER::new();

   $self->_common_member_setup (\%fields, \%pointers);
   $self->set(@_);
   return $self;
}










=item I<ptf_update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub ptf_update
{
   my $this = shift;


   my @slaves;
   my $nios_hash;
   my $nios_name;

   my $class_hash;

   foreach my $class (keys %{$this->ptf_hash()})
   {
      die unless ($class =~ /CLASS\s+/);
      die ("more than one class")
          if ($class_hash++);

      $class_hash = $this->ptf_hash()->{$class};


      return 
          unless ($class_hash->{System_Generator_Version} < 2.0);


      $this->ptf_to_file("",$this->ptf_file().".bak");
      warn 
          ("Backing up pre version 2.0 class.ptf to class.ptf.bak\n");

      $class_hash->{System_Generator_Version} = "2.0";

      my $class_md  = $class_hash->{MODULE_DEFAULTS};

      my $class_sbi = $class_md->{SYSTEM_BUILDER_INFO} 
      or &ribbit
          ("no SBI, try ",join ("\n",keys (%$class_hash)));

      my $master_or_slave = "SLAVE s1";
      $master_or_slave = "MASTER m1"
          if ($class_sbi->{Is_Bus_Master});

      $class_sbi->{Bus_Type} = "Avalon"; 
      $class_md->{$master_or_slave}->{SYSTEM_BUILDER_INFO} 
      = $class_sbi;

      $class_md->{SYSTEM_BUILDER_INFO} =       
      {
         Instantiate_In_System_Module =>
             $class_sbi->{Instantiate_In_System_Module},

         Is_Enabled => $class_sbi->{Is_Enabled},
      };

      delete $class_sbi->{Instantiate_In_System_Module};
      delete $class_sbi->{Is_Enabled};
      delete $class_sbi->{Is_Bus_Master};


      my $ports = $class_md->{PORT_WIRING};

      foreach my $port (keys (%$ports))
      {
         next unless $port =~ /^PORT\s/;
         my $value = $ports->{$port};
         my $avalon_role = $value->{avalon_role};
         if ($avalon_role)
         {
            $value->{type} = $avalon_role;
            $value->{type} =~ s/n$/\_n/;
            delete $value->{avalon_role};
         }
      }
   }

   $this->ptf_to_file();
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

The inherited class e_ptf_update_to_2_0

=begin html

<A HREF="e_ptf_update_to_2_0.html">e_ptf_update_to_2_0</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
