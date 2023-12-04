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

e_deferred_control_register - description of the module goes here ...

=head1 SYNOPSIS

The e_deferred_control_register class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_deferred_control_register;

use e_control_register;
use europa_utils;
@ISA = qw (e_control_register);
use strict;





my %fields = (
              _field_is_deferred  => {},
              );
my %pointers = ();

&package_setup_fields_and_pointers(__PACKAGE__,
                                   \%fields,
                                   \%pointers);
















=item I<make_field_storage_register()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub make_field_storage_register
{
   my $this = shift;
   my ($field_name, $reg_out_name, $reg_in_signal) = (@_);



   return $this->SUPER::make_field_storage_register(@_)
       unless $this->_field_is_deferred()->{$field_name};

   my @result = ();
   my ($we_sig, @other_stuff) =  $this->make_field_write_enable($field_name);
   push (@result, $we_sig, @other_stuff);

   my $width = $this->_field_widths()->{$field_name};













   push (@result, 
         e_signal->new ({name  => "$field_name\_result", 
                         width => $this->_field_widths()->{$field_name},
                      }),




         e_assign->new 
           ({lhs => ["$field_name\_deferred_we" => 1],
             rhs => "(".$we_sig->name().                         ")  || " .
                    "(~pipe_freeze && $field_name\_stored_is_stale)     ",
              }),



         e_assign->new 
           ({lhs => "$field_name\_deferred_reg_in",
             rhs => "(".$we_sig->name().") ? 
                     (".$reg_in_signal->name().") : $field_name",
              }),
         

         e_pipe_register->new 
           ({out    => "$field_name\_stored",
             in     => "$field_name\_deferred_reg_in",
             enable => "$field_name\_deferred_we",
            }),

         e_assign->new 
           ({lhs => $field_name,
             rhs => "$field_name\_stored_is_stale ? 
                      $field_name\_result         :
                      $field_name\_stored         ",
            }),

         e_pipe_register->new 
           ({out        => "$field_name\_stored_is_stale",
             sync_set   => "$field_name\_update && 
                            ~is_cancelled       &&
                            ~is_neutrino         ",
             sync_reset => "1'b1",
             priority   => "set",
          }),
         );

   return @result;
}




=item I<is_recognized_line_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub is_recognized_line_name 
{
   my $this = shift;
   my $nm = shift;
   my $result = 0;



   if ($this->SUPER::is_recognized_line_name($nm)) {
      $result = 1;
   } elsif ($nm =~ /^defer/i) {
      $result = 1;
   }

   return $result;
}









=item I<_additional_line_processing()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _additional_line_processing 
{
   my $this = shift;
   my $field_name = shift or &ribbit ("no field-name");
   my $line_lists = shift or &ribbit ("no line-lists hash");
   return unless $line_lists->{defer};  # line is optional, after all.

   my $is_deferred_string = shift (@{$line_lists->{defer}});
   my $field_is_deferred = 0;

   if ($is_deferred_string =~ /[X1\*]/i) {
      $field_is_deferred = 1;
   }

   $this->_field_is_deferred()->{$field_name} = $field_is_deferred;
}   
   
"We hold these truths to be self-evident, that all men are created
equal, that they are endowed by their Creator with certain unalienable
Rights, that among these are Life, Liberty and the pursuit of
Happiness.--That to secure these rights, Governments are instituted
among Men, deriving their just powers from the consent of the
governed, --That whenever any Form of Government becomes destructive
of these ends, it is the Right of the People to alter or to abolish
it, and to institute new Government, laying its foundation on such
principles and organizing its powers in such form, as to them shall
seem most likely to effect their Safety and Happiness. Prudence,
indeed, will dictate that Governments long established should not be
changed for light and transient causes; and accordingly all experience
hath shewn, that mankind are more disposed to suffer, while evils are
sufferable, than to right themselves by abolishing the forms to which
they are accustomed. But when a long train of abuses and usurpations,
pursuing invariably the same Object evinces a design to reduce them
under absolute Despotism, it is their right, it is their duty, to
throw off such Government, and to provide new Guards for their future
security.--Such has been the patient sufferance of these Colonies; and
such is now the necessity which constrains them to alter their former
Systems of Government. The history of the present King of Great
Britain is a history of repeated injuries and usurpations, all having
in direct object the establishment of an absolute Tyranny over these
States. To prove this, let Facts be submitted to a candid world.
";
   



=back

=cut

=head1 EXAMPLE

Here is a usage example ...

=head1 AUTHOR

Santa Cruz Technology Center

=head1 BUGS AND LIMITATIONS

list them here ...

=head1 SEE ALSO

The inherited class e_control_register

=begin html

<A HREF="e_control_register.html">e_control_register</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
