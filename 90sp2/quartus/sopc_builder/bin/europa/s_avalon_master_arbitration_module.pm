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

s_avalon_master_arbitration_module - description of the module goes here ...

=head1 SYNOPSIS

The s_avalon_master_arbitration_module class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package s_avalon_master_arbitration_module;

use e_ptf_master_arbitration_module;
@ISA = ("e_ptf_master_arbitration_module");
use strict;
use europa_utils;
use e_mux;






my %fields   = (_individual_request_array => []);
my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<add_irq()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_irq 
{
   my $this  = shift;

   my $master_arbitrator = $this;
   my $master = $this->_master_or_slave()
       or &ribbit ("Unable to find master of $this");
   my $master_desc = $master->get_id();

   my $irq_connection_scheme =
       $master->{SYSTEM_BUILDER_INFO}{Irq_Scheme} ||
       'priority_encoded';

   my $irq_call = "_handle_${irq_connection_scheme}_irq_scheme";

   if (!$this->can("$irq_call"))
   {
      &ribbit ("$master_desc has unknown irq connection scheme ".
               $irq_connection_scheme);
   }
   return $this->$irq_call(@_);
}



=item I<_handle_priority_encoded_irq_scheme()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_priority_encoded_irq_scheme
{
   my $this  = shift;
   my $slave_id = shift or &ribbit ("no slave id");
   my $irq_port   = shift or &ribbit ("No irq port");
   my $irq_number = shift;

   if ($irq_number eq '')
   {
      &ribbit ("no irq number");
   }

   my $master_arbitrator = $this;
   my $master = $this->_master_or_slave()
       or &ribbit ("Unable to find master of $this");
   my $master_desc = $master->get_id();

   my $master_irq = $master->_get_exclusively_named_port_by_type("irq")
       or return;

   my $master_arbitrator_mux;
   if ($master_irq)
   {
      $master_arbitrator->get_and_set_thing_by_name
          ({
             thing     => "mux",
             name      => "irq mux",
             default   => "",
             lhs       => $master_irq,
             type      => "and_or",
             add_table => [$irq_port,$irq_port],
          });
   }
   my $master_irqnumber = 
       $master->_get_exclusively_named_port_by_type("irqnumber");

   
   if ($master_irqnumber)
   {
      ($master_irqnumber =~ /^\s*[^\~]/) || &ribbit 
          ("$master_desc: irqnumber_n ($master_irqnumber) doesn't make sense");
      $master_arbitrator_mux = $master_arbitrator->_get_mux_of_type
          ("$master_desc irqnumber");
      $master_arbitrator_mux->default("");
      $master_arbitrator_mux->lhs($master_irqnumber);








      my %table = reverse (map
                           {$_->expression();}
                           @{$master_arbitrator_mux->table()});

      return if ($irq_number eq "NC");
      &ribbit ("$master_desc: $irq_port belonging to $slave_id has same irq $irq_number as slave with pin $table{$irq_number}\n")
          if (($table{$irq_number}) && ($irq_port ne $table{$irq_number}));

      $table{$irq_number} = $irq_port;


      $master_arbitrator_mux->table([]);
      foreach my $irq_num (sort {eval ($a) <=> eval ($b)} (keys
                                                           (%table)))
      {
         $master_arbitrator_mux->add_table($table{$irq_num},
                                           $irq_num);
      }
   }
}



=item I<_handle_individual_requests_irq_scheme()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_individual_requests_irq_scheme
{
   my $this = shift;
   my $slave_id = shift or &ribbit ("no slave id");
   my $irq_port   = shift or &ribbit ("No irq port");
   my $irq_number = shift;

   my $master = $this->_master_or_slave()
       or &ribbit ("Unable to find master of $this");
   my $master_desc = $master->get_id();

   my $master_irq_name =
       $master->_get_exclusively_named_port_or_its_complement
       ('irq') or return;

   my ($master_irq_port, $negate) = $master->
       _get_port_or_its_complement('irq');

   $master_irq_port or &ribbit ("$master_desc has no irq pin");
   my $master_width = $master_irq_port->width();
   my $master_msb = $master_width - 1;

   if (($irq_number > $master_msb) || ($irq_number < 0))
   {
      &ribbit ("$slave_id irq number out of range for $master_desc."
               ."slave_irq:$irq_number, master_range:(0..$master_msb)");
   }

   my $irq_array = $this->_individual_request_array();
   if (!@$irq_array)
   {
      map {$irq_array->[$_] = "1'b0";} (0 ..$master_msb);
   }

   $irq_array->[$irq_number] = $irq_port;

   $this->get_and_set_thing_by_name
       ({
          thing => 'assign',
          name  => 'irq assign',
          lhs   => [$master_irq_name => $master_width, 1],
          rhs   => &concatenate(reverse (@$irq_array)),
       });
}



=item I<_display_signals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _display_signals
{
   my $this  = shift;
   my $master_id = shift;
   my $type_of_transaction = shift;
   my $read_or_write = shift;
   my $port_types = shift;
   my $pending_string = shift;
   my $file_handle = shift;

   my $master = $this->_get_slave($master_id);
   my $READ_OR_WRITE = uc($read_or_write);
   my @string = ("$master_id $type_of_transaction");
   my @variables;

   foreach my $type (@$port_types)
   {
      my $master_port =
          $master->_get_exclusively_named_port_by_type($type);
      if ($master_port)
      {
         push (@string ,"$type := 0x%X");
         push (@variables, $master_port);
      }
   }

   my $output_string = join (', ',@string);

   if ($pending_string ne '')
   {
      $pending_string = $pending_string.'\n';
   }
   $output_string .= '\n';

   my $initial_condition =
       $master->_get_exclusively_named_port_by_type($read_or_write);

   if ($initial_condition)
   {
      $this->get_and_set_once_by_name
          ({thing => 'process',
            name  => "$master_id $type_of_transaction monitor",
            tag   => 'simulation',
            contents => 
                [e_if->new
                 ({condition => $initial_condition,
                   then => [e_if->new
                            ({condition => $master->_get_exclusively_named_port_or_its_complement('waitrequest_n'),
                              then      => [e_sim_write->new
                                            ({spec_string => $output_string,
                                              expressions => \@variables,
                                              show_time   => 1,
                                              file_handle => $file_handle,
                                           })],
                                  else      => ($pending_string ne '')? 
                                  [e_sim_write->new({spec_string => $pending_string,
                                                     file_handle => $file_handle,
                                                  })]:[],
                               })]
                            }),
                 ],
                            });
   }
}



=item I<log_transactions()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub log_transactions
{
   my $this = shift;

   my $master = $this->_master_or_slave();
   my $master_id = $master->get_id();

   my $log_transactions = $master->{SYSTEM_BUILDER_INFO}{Log_Transactions};

   my $file_handle;
   my $file_name;
   if ($log_transactions =~ /^([A-Za-z_](\w|\.)*)$/)
   {
      $file_name = $log_transactions;
      $file_handle = $this->_make_signal($master_id.'/LOGFILE');
      $this->get_and_set_once_by_name
          ({
             thing => 'sim_fopen',
             name  => "$file_handle log to file",
             file_name => $file_name,
             file_handle => $file_handle,
          })
   }

   if ($log_transactions)
   {
      my @variables;
      my $address_string;

      if ($master->_get_exclusively_named_port_by_type('writedata'))
      {
         $this->_display_signals(
                                 $master_id,
                                 'WRITE',
                                 'write',
                                 ['address', 'writedata', 'burstcount'],
                                 '.',
                                 $file_handle);
      }

      if ($master->_get_exclusively_named_port_by_type('readdata'))
      {
         my @display_signals = qw (flush address burstcount);
         my $pending = '';
         my $latency_enable = $master->_get_exclusively_named_port_by_type('readdatavalid');
         if (!$latency_enable)
         {
            push (@display_signals, 'readdata');
            $pending = '.';
         }

         $this->_display_signals($master_id,
                                 'READ',
                                 'read',
                                 \@display_signals,
                                 $pending,
                                 $file_handle
                                 );

         if ($latency_enable)
         {
            $this->get_and_set_once_by_name
                ({thing => 'process',
                  name  => "$master_id read latency monitor",
                  tag   => 'simulation',
                  contents => 
                      [e_if->new
                       ({condition => $latency_enable,
                         then => [e_sim_write->new
                                  ({
                                     delay       => 1,
                                     show_time   => 1,
                                     file_handle => $file_handle,
                                     spec_string => "    $master_id receives 0x%X.\\n",
                                     expressions =>
                                        [$this->_get_exclusively_named_port_by_type
                                         ('readdata')],                                        
                                     }),
                                  ]
                               }),
                       ],
                });
         }
      }
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

The inherited class e_ptf_master_arbitration_module

=begin html

<A HREF="e_ptf_master_arbitration_module.html">e_ptf_master_arbitration_module</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
