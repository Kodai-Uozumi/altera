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

e_ptf_project - description of the module goes here ...

=head1 SYNOPSIS

The e_ptf_project class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_ptf_project;
use e_project;
use e_ptf_top_module;

@ISA = ("e_project");
use strict;
use europa_utils;
use mk_bsf;







my %fields = (
              _AUTOLOAD_ACCEPT_ALL    => 1,
              do_setup_quartus_synth  => 1,
              do_make_symbol          => 1,
              do_make_sim_project     => 1,
              do_make_top_level_instance_wrapper => 1,
              _fictitious_user_design => e_module->dummy(),
              _top_model_instances    => [],
              );

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<new()>

Object constructor

=cut

sub new
{
   my $this  = shift;
   my $self = $this->SUPER::new(@_);

   my $fields = $self->ptf_to_hash
       ($self->spaceless_ptf_hash()->{SYSTEM});

   $self->set($fields);
   $self->top($fields->{name});
   $self->_fictitious_user_design({name => "Enclosing design",
                                   project => $self,
                                  });

   my $tm = e_test_module->new
       ({
          name => "test_bench",

          export_no_signals => 1,
          contents => 
              [
               e_instance->new({name => "DUT",
                                module => $self->top(),
                                comment => "Set us up the Dut",
                             })
               ]
       });

   $self->test_module($tm);
   $tm->project($self);
   
   my $fields = $self->ptf_to_hash
       ($self->spaceless_ptf_hash()->{SYSTEM});

   if (exists ($self->{MODULE}))
   {
      foreach my $module_hash ($self->ptf_to_hashes
                               ($self->{MODULE}))
      {
         $module_hash->{project} = $self;
         my $SBI = $module_hash->{SYSTEM_BUILDER_INFO};
         next unless 
             ($SBI->{Is_Enabled});

         my $e_mod = e_ptf_module->new
             ($module_hash);



         if (!$e_mod->{MASTER})
         {
            my $instantiate_this = 0;
            foreach my $slave (values (%{$e_mod->{SLAVE}}))
            {
               $instantiate_this += 
                   keys %{$slave->{SYSTEM_BUILDER_INFO}{MASTERED_BY}};
            }
            next unless $instantiate_this;
         }

         $self->add_module($e_mod);
         
         my $epi = e_ptf_instance->new
             ({module => $e_mod});
         $epi->project($self);

         if ($SBI->{Instantiate_In_System_Module})
         {
            $self->top()->add_contents ($epi);
         }
         else
         {

            my $language = $self->language();
            $language =~ s/^v/V/;

            my $section = "$language\_Sim_Model_Files";
            if ($e_mod->{HDL_INFO}->{$section} || $SBI->{Instantiate_In_Test_Module})
            {
               $self->test_module()->add_contents ($epi);
            }
            elsif ($e_mod->do_make_memory_model())
            {


               


               $self->test_module()->add_contents ($epi);
            } else {






               $self->_fictitious_user_design()->add_contents ($epi);
            }
         }

         my $bridge_mod = $e_mod->bridge_arbitration_module();
         unless ($bridge_mod->isa_dummy())
         {
            $self->add_module($bridge_mod);
            e_instance->new({module => $bridge_mod})
                ->within($self->top());
         }

      }
   }
   
   return $self;
}



























=item I<_automatically_create_new_top_module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _automatically_create_new_top_module
{
   my $this = shift;
   my $name = shift || &ribbit ("Required argument 'name' missing.");
   &ribbit ("too many arguments") if scalar(@_) != 0;


   my $e_ptf_top = e_ptf_top_module->new({name => $name});
   $e_ptf_top->project($this);
   return $e_ptf_top;
}



=item I<_update_ptf()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _update_ptf
{

}



=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
  my $this = shift;
  $this->_fictitious_user_design()->update();
  my $return = $this->SUPER::update(@_);

  my $top = $this->top();
  foreach my $instance (@{$this->_top_model_instances()})
  {
     $instance->within($top);
  }
  
  return $return;
}



=item I<identify_signal_widths()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub identify_signal_widths
{
   my $this = shift;
   my $return = $this->SUPER::identify_signal_widths(@_);

   $this->top()->wire_defaults();

   if ($this->SYS_WSA()->{do_build_sim})
   {
      $this->do_modelsim_assertion_work();
   }

   return $return;
}



=item I<_get_unique_sim_hdl_files()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_unique_sim_hdl_files
{
  my $this = shift;

  my $file_list = $this->module_ptf()->{HDL_INFO}{Simulation_HDL_Files};

  my @files = split (/\s*,\s*/s,$file_list);

  my @unique_files;
  my %file_already_included;  
  foreach my $file (@files)
    {
      push (@unique_files, $file) unless $file_already_included{$file};
      $file_already_included{$file}++;
    }
  foreach my $super_file ($this->SUPER::_get_unique_sim_hdl_files())
    {
      push (@unique_files, $super_file) 
	unless $file_already_included{$super_file};
      $file_already_included{$super_file}++;
    }
  return (@unique_files);
}




=item I<to_esf()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_esf 
{
  my $this = shift;


  my %esf_settings;
  if (exists ($this->{MODULE}))
  {
    foreach my $module_name (keys %{$this->{MODULE}})
    {
      my $module_from_project = $this->get_module_by_name($module_name)
          or &ribbit
              ("could not find a module named ",
                "($module_name) in the project");
      $module_from_project->to_esf(\%esf_settings);

    }
  }


  my $string;
  foreach my $key (keys %esf_settings) {
    $string .= "$key\n{\n     ";
    $string .= join ";\n     ", @{$esf_settings{$key}};
    $string .= ";\n}\n";
  }
  my $esf_file_name = $this->_system_name(). ".esf";

  open (ESF_FILE, "> $esf_file_name") || die
    "Cannot open file $esf_file_name ($!)\n";
  print ESF_FILE "$string";
  close (ESF_FILE);
}



=item I<do_modelsim_assertion_work()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub do_modelsim_assertion_work
{
  my $this = shift;

  if ($this->SYS_WSA()->{do_modelsim_list})
  {
    my @sim_assertion_spec;
    my @contents = @{$this->top()->_updated_contents()};

    for my $thing (grep {ref $_ eq 'e_instance'} @contents)
    {
      push @sim_assertion_spec, $thing->get_modelsim_list_info();
    }


    my $prefix;

    $prefix = $this->test_module()->name();


    my ($system_top_instance_name) = @{$this->top->_instantiated_by()};
    ribbit("Can't find system-top instance")
      if !defined $system_top_instance_name;
    $prefix .= "/" . $system_top_instance_name->name();

    my $dofile = $this->simulation_directory() . "/modelsim_list.do";
    open FILE, ">$dofile" or ribbit("Can't open do file '$dofile'");
    print STDERR "Creating file '$dofile'\n";
    


    my %written_signals;
    for my $spec (@sim_assertion_spec)
    {
      print FILE "# instance_name: $spec->{instance_name}\n";
      print FILE "# file_name: $spec->{file_name}\n";
      print FILE "# package_name: $spec->{package_name}\n";
      print FILE "# test_function: $spec->{test_function}\n";
      for my $sig (@{$spec->{signals}})
      {
        if (not exists $written_signals{$sig->_exclusive_name()})
        {
          print FILE "add list -hex $prefix/@{[$sig->_exclusive_name()]}\n";
        }

        $written_signals{$sig->_exclusive_name()} = 1;
      }
      print FILE "\n";
    }
    
    close FILE;
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

The inherited class e_project

=begin html

<A HREF="e_project.html">e_project</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
