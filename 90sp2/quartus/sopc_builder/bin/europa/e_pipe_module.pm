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

e_pipe_module - description of the module goes here ...

=head1 SYNOPSIS

The e_pipe_module class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_pipe_module;
use europa_utils;
use e_pipe_register;
use e_module;
@ISA = ("e_module");
use strict;

my %known_stage_numbers = ();




my %fields = (
              stage         => 0,
              pipe_clk_en   => "pipe_run",
              );
my %pointers = (
                _tmp_project => e_project->dummy(),
                );

&package_setup_fields_and_pointers(__PACKAGE__,
                                   \%fields,
                                   \%pointers);


=item I<new()>

Object constructor

=cut

sub new 
{
   my $that = shift;
   my $self = $that->SUPER::new(@_);

   $self->add_pipeline_ports(); 
   $self->validate();
   return $self;
}












=item I<define_stages()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub define_stages
{
   my $this = shift;
   &ribbit ("Please call this function statically") unless ref ($this) eq "";
   my (@stage_defs) = (@_);
   
   foreach my $def (@stage_defs) 
   {
      &ribbit ("expected list-refs (name/number pairs) as arguments")
          unless (ref ($def) eq "ARRAY") && (scalar (@{$def}) == 2);
      my ($label, $number) = (@{$def});
      &ribbit ("Suspicious attempt to re-label stage '$label'")
          if exists ($known_stage_numbers{$label});
      $known_stage_numbers{$label} = $number;
   }
}









my %pipe_clk_en_signals = ();



=item I<get_stage_clk_en_signal()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_stage_clk_en_signal
{
   my $this = shift;
   my $stage_num = shift;
   &ribbit ("Please call this function statically") unless ref ($this) eq "";
   &ribbit ("Please call with stage-number") unless $stage_num =~/^\d+$/;
   
   my $result = $pipe_clk_en_signals {$stage_num};


   $result = $fields{pipe_clk_en} if !$result;
   
   return $result;
}

























my %sequential_signal_widths       = ();
my %sequential_signal_origins      = ();
my %sequential_signal_reset_values = ();


=item I<define_sequential_signals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub define_sequential_signals
{
   my $this = shift;
   &ribbit ("Please call this function statically") unless ref ($this) eq "";
   my (@sig_defs) = (@_);
   
   foreach my $sig_def (@sig_defs) 
   {
      &ribbit ("expected list-refs (name/number/origin triads) as arguments")
          unless (ref ($sig_def) eq "ARRAY") && (scalar (@{$sig_def}) <= 4);
      my ($sig_name, $width, $origin, $reset_val) = (@{$sig_def});

      &ribbit ("Suspicious attempt to re-define pipe-signal  '$sig_name'")
          if exists ($sequential_signal_widths{$sig_name});

      $width     = 1   if !$width;            # Default width is 1.
      $reset_val = "0" if $reset_val eq "";   # Reset to zero by default.


      &ribbit ("unknown stage name: $origin") 
          if $origin && !exists ($known_stage_numbers{$origin});
      my $origin = $known_stage_numbers{$origin} if $origin;

      $sequential_signal_origins     {$sig_name} = $origin;
      $sequential_signal_widths      {$sig_name} = $width;
      $sequential_signal_reset_values{$sig_name} = $reset_val;
   }
}














=item I<project()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub project
{
   my $this = shift;
   return $this->SUPER::project() unless @_;
   my $proj = shift or &ribbit ("project-argument required");
   &ribbit ("argument must be an e_project") 
       unless &is_blessed ($proj) && $proj->isa ("e_project");
   return $this->_tmp_project($proj);
}







=item I<validate()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub validate
{
   my $this = shift;
   &ribbit ("too many arguments") if @_;
   my $mod_name = $this->name();
   my $stage_name = $this->stage() 
       or &ribbit ("pipe-module $mod_name not assigned to a stage");

   &ribbit ("pipe-module $mod_name assigned to unknown stage $stage_name")
       unless exists $known_stage_numbers{$stage_name};




   my $stage_num = $known_stage_numbers{$stage_name};
   $pipe_clk_en_signals{$stage_num} = $this->pipe_clk_en()
       if (!exists ($pipe_clk_en_signals{$stage_num}) );

   &ribbit ("module ", $this->name(), " has incosistent clk_en signal")
       if $pipe_clk_en_signals{$stage_num} ne $this->pipe_clk_en();
   
   print ".";

   $this->_tmp_project()->add_module($this);
}









=item I<get_stage_number()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_stage_number
{
   my $this = shift;
   if (ref ($this) eq "")
   {

      my $stage_name = shift;
      &ribbit ("stage-name argument required") if $stage_name eq "";
      &ribbit ("expected name-string") unless ref ($stage_name) eq "";
      &ribbit ("too many arguments") if @_;



      return $stage_name if $stage_name =~ /^\d+$/;

      return $known_stage_numbers{$stage_name};
   } else {

      &ribbit ("access-only function") if @_;
      return e_pipe_module->get_stage_number($this->stage());
   }      
}   
















=item I<add_contents()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_contents 
{
   my $this = shift;
   my $result = $this->SUPER::add_contents (@_);
   foreach my $thing (@_) {
      $thing->parent ($this);
   }
}











=item I<add_pipeline_ports()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_pipeline_ports
{
   my $this = shift;
   &ribbit ("unexpected arguments") if @_;
   
   my $N = $this->get_stage_number();





   my @contents = ();
   foreach my $sig_name (keys(%sequential_signal_widths)) 
   {

      next unless $sequential_signal_origins{$sig_name} < $N;

      my $sig_width = $sequential_signal_widths{$sig_name};
      push (@contents, e_assign->new 
            ({lhs => e_signal->new 
                  ({name         => $sig_name, 
                    width        => $sig_width,
                    never_export => 1,           }),
              rhs => e_port->new   (["$sig_name\_$N" => $sig_width, "in"]) 
             })
            );
   }

   push (@contents, 
         e_assign->new
          ({lhs => e_signal->new ({name         => "local_pipe_clk_en",
                                   width        => 1,
                                   never_export => 1,           }),
            rhs => $this->pipe_clk_en(),
          }),
         );
   push (@contents, 
         e_assign->new({lhs => e_signal->new ({name         => "pipe_state_we",
                                               width        => 1,
                                               never_export => 1,           }),
                        rhs => "local_pipe_clk_en && 
                                ~is_neutrino      && 
                                ~is_cancelled      ",
                     }),
         );
   $this->add_contents (@contents);
}












=item I<create_delay_logic()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub create_delay_logic
{
   my $this = shift;
   my ($arg) = (@_) or &ribbit ("no arguments (named-arg hash, please)");

   &validate_parameter ({hash => $arg,   name => "source_signal"});
   &validate_parameter ({hash => $arg,   name => "dest_signal"  });
   &validate_parameter ({hash => $arg,   name => "source_stage" });
   &validate_parameter ({hash => $arg,   name => "width"        });
   &validate_parameter ({hash => $arg,   name => "dest_stage"   ,
                         default => $this->get_stage_number()});

   &ribbit ("source-signal must be a -name-") 
       unless ref ($arg->{source_signal}) eq "";


   my $dest_stage_number   = 
       e_pipe_module->get_stage_number ($arg->{dest_stage});
   my $source_stage_number = 
       e_pipe_module->get_stage_number ($arg->{source_stage});


   if ($source_stage_number == $dest_stage_number) {
      return e_assign->new ([$arg->{dest_signal}, $arg->{source_signal}]);
   }

   my $sig_name = $arg->{source_signal};
   my @result = ();
   foreach my $i ($source_stage_number+1 .. $dest_stage_number)
   {
      my $local_sig = e_signal->new (["$sig_name\_$i", $arg->{width}]);
      if (($i - $source_stage_number <= 1)) {
         push (@result, e_assign->new ([$local_sig, $arg->{source_signal}]));
      } else {
         my $prev_stage = $i-1;
         my $local_clk_en = $pipe_clk_en_signals{$prev_stage};
         &ribbit ("no local clock-enable signal for pipe-stage # $prev_stage")
             unless $local_clk_en;
         push (@result, e_register->new 
               ({out    => $local_sig,
                 in     => "$sig_name\_$prev_stage",
                 enable => $local_clk_en,
                })
               );
      } 
   }
   
   push (@result, 
         e_assign->new ({lhs => $arg->{dest_signal}, 
                         rhs => "$sig_name\_$dest_stage_number" })
         );
   
   return @result;
}



















=item I<build_sequential_signals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub build_sequential_signals
{
   my $this = shift;
   &ribbit ("Please call statically") unless ref ($this) eq "";

   my @result = ();
   my $N = e_pipe_module->get_max_delay();
   foreach my $pipe_sig (keys(%sequential_signal_widths))
   {
      my $w            = $sequential_signal_widths{$pipe_sig};
      my $origin_stage = $sequential_signal_origins{$pipe_sig};
      my $reset_val    = $sequential_signal_reset_values{$pipe_sig};
      foreach my $i (0..$N)
      {
         next if $i < $origin_stage;
         my $local_sig_name = join ("_", $pipe_sig, $i);
         push (@result, e_signal->new ({name  => $local_sig_name,
                                        width => $w,
                                        never_export => 1     }));

         if ($i == $origin_stage) {
            push (@result, e_assign->new ({lhs => $local_sig_name,
                                           rhs => $pipe_sig,      })
                  );
         } else {
            my $prev_stage = $i-1;
            my $local_clk_en = $pipe_clk_en_signals{$prev_stage};
            push (@result, e_register->new({out    => $local_sig_name,
                                            in     => "$pipe_sig\_$prev_stage",
                                            enable => $local_clk_en,
                                            async_value => $reset_val,
                                          })
                  );
         }
      }
   }
   return @result;
}



=item I<get_max_delay()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_max_delay
{
   my $this = shift;
   &ribbit ("Please call statically") unless ref ($this) eq "";
   return &max (values (%known_stage_numbers));
}















=item I<provide_to_all_stages()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub provide_to_all_stages
{
   my $this = shift;
   &ribbit ("Please call statically") unless ref ($this) eq "";
   &ribbit ("Please don't call this function.  It scares the children.");
   my (@in_signal_list) = (@_) or &ribbit ("missing arguments.");
   my $max_delay = e_pipe_module->get_max_delay();

   my @result = ();
   foreach my $in_signal (@in_signal_list) 
   {
      my $sig_name = $in_signal->name();
      my $w        = $in_signal->width();

      push (@result, 
            e_assign->new 
            ({lhs => e_signal->new (["$sig_name\_0", $w]),
              rhs => $sig_name,
             })    );

      foreach my $i (1..$max_delay)
      {
         my $last = $i-1;
         my $reg_in  = e_signal->new ({name         => "$sig_name\_".$last,
                                       width        => $w,
                                       never_export => 1,
                                    });

         my $reg_out = e_signal->new ({name         => "$sig_name\_".$i,
                                       width        => $w,
                                       never_export => 1,
                                    });

         push (@result, e_pipe_register->new ({in  => $reg_in,
                                               out => $reg_out,
                                            }),
               );
      }
   }
   return @result;
}
   
"You know what you doing!";

=back

=cut

=head1 EXAMPLE

Here is a usage example ...

=head1 AUTHOR

Santa Cruz Technology Center

=head1 BUGS AND LIMITATIONS

list them here ...

=head1 SEE ALSO

The inherited class e_module

=begin html

<A HREF="e_module.html">e_module</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
