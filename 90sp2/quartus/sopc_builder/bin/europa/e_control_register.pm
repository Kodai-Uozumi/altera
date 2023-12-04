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

e_control_register - description of the module goes here ...

=head1 SYNOPSIS

The e_control_register class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_control_register;

use europa_utils;
use e_mux;
use e_state_register;
use pretty_picture;
use e_thing_that_can_go_in_a_module;

@ISA = qw (e_thing_that_can_go_in_a_module);

use strict;





my %fields = (
              _write_table             => [],
              _pretty_picture          => "",
              read_only               => 0,
              make_submodule          => 0,
         
              _built                  => 0,
              _parsed                 => 0,
              _field_names            => [],      # MSB..LSB order
              _field_lsbs             => {},
              _field_widths           => {},
              _field_reset_values     => {},
              _field_port_types       => {},
              _field_masks            => {},
              _field_write_selects    => {},
              _field_write_tables     => {},
              _field_priority_tables  => {},  # High-priority write terms
              _field_pipe_enables     => {},
              _input_multiplexers     => {},
              _subcomponents          => [],
                  
              _parent_objects         => [],
              _prototype              => e_module->dummy(),
              );
my %pointers = ();

&package_setup_fields_and_pointers(__PACKAGE__,
                                   \%fields,
                                   \%pointers);







=item I<write_table()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub write_table
{
   my $this = shift;
   &ribbit ("sorry--can't update write-table for an already-built register")
       if (scalar (@_) && $this->_built());
   return $this->_write_table(@_);
}



=item I<pretty_picture()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub pretty_picture
{
   my $this = shift;
   &ribbit ("sorry--can't change the picture of an already-built register")
       if (scalar (@_) && $this->_parsed());
   return $this->_pretty_picture(@_);
}












=item I<field_names()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub field_names
{
   my $this = shift;
   &ribbit ("access-only function") if @_;
   &ribbit ("too early to ask") if !$this->_parsed();
   return @{$this->_field_names()};
}









=item I<total_width()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub total_width
{
   my $this = shift;
   &ribbit ("access-only function") if @_;
   &ribbit ("too early to ask") if !$this->_parsed();

   my $w = 0;
   foreach my $field ($this->field_names()) {
      $w += $this->_field_widths()->{$field};
   }
   return $w;
}



























=item I<get_input_mux()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_input_mux
{
   my $this = shift;
   my $field_name = shift or &ribbit ("expected a field-name");
   &ribbit ("too many arguments") if @_;
   &ribbit ("expected a simple string") unless ref ($field_name) eq "";
   


   $this->_build() unless $this->_built();
   my $result = $this->_input_multiplexers()->{$field_name} 
     or &ribbit ("unrecognized field-name '$field_name' in ", $this->name());

   return $result;
}



=item I<add_field_write_table()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_field_write_table 
{
   my $this       = shift;
   my $field_name = shift or &ribbit ("Field-name required.");
   my $table      = shift or &ribbit ("table (list-ref) required.");
   my $priority   = shift;
   
   $priority = "last" if $priority eq "";

   &ribbit ("table argument must be list-ref") unless ref ($table) eq "ARRAY";
   &ribbit ("field argument must be name")     unless ref ($field_name) eq "";
   &ribbit ("can't add to write-table after I've been '_built'") 
       if $this->_built();
   &ribbit ("Write-table list must have even length") 
       unless (scalar (@{$table}) % 2) == 0;
   &ribbit ("priority must be 'first' or 'last'") 
       unless $priority =~ /(first)|(last)/i;

   while (@{$table})
   {
      my $selecto = shift (@{$table});
      my $value   = shift (@{$table});
      push (@{$this->_field_write_selects()->{$field_name}}, $selecto);






      if ($priority =~ /last/i) { 
         push    (@{$this->_field_write_tables()->{$field_name}}, 
                  $selecto, $value);
      } else {
         push    (@{$this->_field_priority_tables()->{$field_name}}, 
                  $selecto, $value);
      }
   }
}   
   
my $unique_name_counter;



=item I<_build()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _build
{
   my $this = shift;
   return if $this->_built();
   

   &ribbit ("who parsed my pretty picture?") if $this->_parsed();
   $this->_parse_pretty_picture();

   foreach my $field (@{$this->_field_names()}) 
   {


      my $width = $this->_field_widths()->{$field};
      my $lsb   = $this->_field_lsbs()->{$field};
      my $msb   = $lsb + $width - 1;

      my $range = ($width > 1) ? "[$msb : $lsb]" : "[$lsb]";
         $range = "" if $this->total_width() == 1;
      


      if ($this->read_only()) {
         my $do_export = $this->make_submodule();
         push (@{$this->_subcomponents()}, e_assign->new 
               ({lhs => e_signal->new([$field => $width, $do_export]),
                 rhs => $this->_field_reset_values()->{$field}, }));
         next;
      }




      
      my $reg_in_signal =  e_signal->new 
          ({name   => $this->name()."_$field\_reg_in",
            width  => $width,
            });







      my $input_mux = e_mux->new ({lhs     => $reg_in_signal,
                                   table   => [],
                                });
      $this->_input_multiplexers()->{$field} = $input_mux;



      $input_mux->add_table (@{$this->_field_priority_tables()->{$field}});





      my @write_table_copy = @{$this->write_table()};  # Destroyed by loop.
      while (@write_table_copy)
      {
         my $select = shift (@write_table_copy) or &ribbit ("?");
         my $value  = shift (@write_table_copy) 
             or &ribbit ("odd number of things in mux table");
         $input_mux->add_table ($select, "$value $range");
         
         push (@{$this->_field_write_selects()->{$field}}, $select);
      }


      $input_mux->add_table (@{$this->_field_write_tables()->{$field}});





      my $port_type = $this->_field_port_types()->{$field};
      my $field_signal;
      if ($port_type || $this->make_submodule()) 
      {
         my $pt = $port_type =~ /in/ ? "in" : "out";
         $field_signal = e_port->new   ([$field, $width, $pt]);
       } else {
          $field_signal = e_signal->new ([$field, $width    ]);
       }

      push (@{$this->_subcomponents()},  $field_signal);
      push (@{$this->_parent_objects()}, $field_signal) if $port_type;

      my $masked_reg_in_signal = $reg_in_signal;
      my $masked_reg_out_name = $field;
      my $mask                = $this->_field_masks()->{$field};
      if ($mask && ($mask !~ /^\s*-+\s*$/)) {
         $masked_reg_out_name  = $field . "_out_pre_mask";
         $masked_reg_in_signal = e_signal->new
             ([$reg_in_signal->name() . "_masked", $reg_in_signal->width()]);
         push (@{$this->_subcomponents()}, 
               e_assign->news ({lhs => $field,
                                rhs => "$masked_reg_out_name      & $mask"
                               },
                               {lhs => $masked_reg_in_signal,
                                rhs => $reg_in_signal->name() . " & $mask",
                               })
               );
      }
           
      push (@{$this->_subcomponents()}, 
            $reg_in_signal, $input_mux, 
            $this->make_field_storage_register ($field,
                                                $masked_reg_out_name, 
                                                $masked_reg_in_signal),
            );
   }
   


   push (@{$this->_subcomponents()},
         e_assign->new 
         ({lhs => e_signal->new ([$this->name(), $this->total_width()]),
           rhs => &concatenate ($this->field_names()),
        }));





   if ($this->make_submodule()) 
   {
      my $proto_name = 
          $this->name() . "_control_register_" . $unique_name_counter++;
      $this->_prototype({name => $proto_name});
      $this->_prototype()->add_contents (@{$this->_subcomponents()});
   }
   
   $this->_built(1);
}











=item I<make_field_storage_register()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub make_field_storage_register
{
   my $this = shift;
   my ($field_name, $reg_out_name, $reg_in_signal) = (@_);

   my @result = ();

   my ($we_sig, @other_stuff) =  $this->make_field_write_enable($field_name);
   push (@result, $we_sig, @other_stuff);
                                          
   push (@result, e_state_register->new 
         ({out         => $reg_out_name,
           in          => $reg_in_signal,
           enable      => $we_sig,
           async_value => $this->_field_reset_values()->{$field_name},
        })
      );

   return @result;
}












my $unique_we_counter = 0;


=item I<make_field_write_enable()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub make_field_write_enable
{
   my $this = shift;
   my $field_name = shift or &ribbit ("field name required");
   
   my $we_name = $field_name . "_write_enable_" . $unique_we_counter++;
   my @result = ();
   my $we_list_ref = $this->_field_write_selects()->{$field_name} or
       &ribbit ("Null WE-list for field: $field_name");
   my (@we_terms) = (@{$we_list_ref});
   @we_terms = map {"($_)"} @we_terms;














   my $pipe_en = $this->_field_pipe_enables()->{$field_name};
   
   if ((!$pipe_en                ) || 
       ( $pipe_en =~ /^\s*-+\s*$/)  ) {
      $pipe_en = "(pipe_run && ~is_cancelled && ~is_neutrino)";
   }

   push (@result, e_signal->new ([$we_name => 1]));
   push (@result, e_assign->new ({lhs => $we_name,
                                  rhs => "($pipe_en) && 
                                          (" . join (' || ', @we_terms) .")",
                                 }) );
    return @result;
}



=item I<required_line_names()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub required_line_names 
{
   return qw (bit name reset);
}



=item I<is_recognized_line_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub is_recognized_line_name
{
   my $this = shift;
   my $line_name = shift;


   
   foreach my $nm ($this->required_line_names(), "port", "mask", "pipe_en")
      { return 1 if $nm =~  /^$line_name$/i; } 
   return 0;
}































=item I<_parse_pretty_picture()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _parse_pretty_picture
{
   my $this = shift();
   &ribbit ("didn't expect unexpected argument") if @_;
   return if $this->_parsed();
   &ribbit ("who built my register?")     if     $this->_built();
   &ribbit ("where's my pretty picture?") unless $this->pretty_picture();

   my $line_lists = 
       &build_labelled_lists_from_text_table ($this->pretty_picture());

   


   foreach my $required_line ($this->required_line_names()) {
      &ribbit ("required line '$required_line' not found")
          unless $line_lists->{$required_line};
   }
   foreach my $line_name (keys (%{$line_lists})) { 
      &ribbit ("unrecognized line-name: $line_name") 
          unless $this->is_recognized_line_name($line_name);
   }







   while (scalar(@{$line_lists->{name}})) 
   {
      my $field_name     = shift (@{$line_lists->{name}    });
      my $reset_value    = shift (@{$line_lists->{reset}   });
      my $bit_string     = shift (@{$line_lists->{bit}     });
      my $port_string    = shift (@{$line_lists->{port}    });
      my $mask_string    = shift (@{$line_lists->{mask}    });
      my $pipe_en_string = shift (@{$line_lists->{pipe_en} });

      push (@{$this->_field_names()}, $field_name);
      $this->_field_reset_values()->{$field_name} = $reset_value;
      $this->_field_port_types()  ->{$field_name} = $port_string;
      $this->_field_masks()       ->{$field_name} = $mask_string;
      $this->_field_pipe_enables()->{$field_name} = $pipe_en_string;
      

      $this->_additional_line_processing ($field_name, $line_lists);

      my $unused_msb;
      ($unused_msb, 
       $this->_field_lsbs()->{$field_name},
       $this->_field_widths()->{$field_name}) = 
           &extract_msb_lsb_width_from_bit_string ($bit_string);
   }
   $this->_parsed(1);
}









=item I<_additional_line_processing()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _additional_line_processing {}   




=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
   my $this   = shift();
   my $parent = $this->parent(@_);
   my $pm = $this->parent_module() or &ribbit ("whosyerdaddy?");

   $this->_build() unless $this->_built();
   if ($this->make_submodule()) {
      $pm->project()->add_module($this->_prototype());
      $pm->add_contents 
          (e_instance->new ({module => $this->_prototype()->name()}),
           @{$this->_parent_objects()}
           );

   } else {
      $pm->add_contents (@{$this->_subcomponents()});
   }
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

The inherited class e_thing_that_can_go_in_a_module

=begin html

<A HREF="e_thing_that_can_go_in_a_module.html">e_thing_that_can_go_in_a_module</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
