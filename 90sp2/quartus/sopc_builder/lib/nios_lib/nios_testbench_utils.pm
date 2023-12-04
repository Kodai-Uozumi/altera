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


























package nios_testbench_utils;
use Exporter;
@ISA = Exporter;
@EXPORT = qw(
    &create_x_checkers
    &create_trace_checker_testend
);

use europa_all;
use europa_utils;
use cpu_utils;
use strict;

















sub
create_x_checkers
{
    my ($x_signals_ref) = @_;

    foreach my $x_signal (@$x_signals_ref) {
        my $sig = $x_signal->{sig};
        my $qual = $x_signal->{qual};
        my $do_not_stop = $x_signal->{warn};

        if ($qual) {
            e_process->adds({ 
              tag      => "simulation",
              contents => [ 
                e_if->new({ 
                  condition => $qual,
                  then      => [ 
                    e_if_x->new({ 
                      condition     => $sig, 
                      do_not_stop   => $do_not_stop,
                    }) 
                  ],
                })
              ],
              asynchronous_contents => 
                [e_thing_that_can_go_in_a_module->new()],
            });
        } else {
            e_process_x->adds({
              check_x     => $sig,
              do_not_stop => $do_not_stop
            });
        }
    }
}



sub
create_trace_checker_testend
{
    my $args = shift;   # Reference to hash with all arguments.

    validate_hash_keys("args", $args, [
      "inst_retire_expr",
      "trace_event_expr",
      "test_end_expr",
      "trace_args",
      "checker_args",
      "num_threads",
      "filename_base",
      "language",
      "pli_function_name",
    ]);

    my $inst_retire_expr = not_empty_scalar($args, "inst_retire_expr");
    my $trace_event_expr = not_empty_scalar($args, "trace_event_expr");
    my $test_end_expr = optional_scalar($args, "test_end_expr");
    my $trace_args = optional_array($args, "trace_args");
    my $checker_args = optional_array($args, "checker_args");
    my $num_threads = manditory_int($args, "num_threads");
    my $filename_base = not_empty_scalar($args, "filename_base");
    my $language = not_empty_scalar($args, "language");
    my $pli_function_name = not_empty_scalar($args, "pli_function_name");

    my @process_objs;

    if ($trace_args) {



        my $header_spec = "version 3\\nnumThreads " . $num_threads . "\\n";
        my $trace_string = join(",", map {"%0h"} (@$trace_args));
    
        $trace_string .= "\\n";

        my $file_name = $filename_base . ".tr";
        my $file_handle = "trace_handle";


        e_sim_fopen->adds({
           file_name        => $file_name,
           file_handle      => $file_handle,
           contents         => [
                e_sim_write->new ({
                  spec_string => $header_spec,
                  file_handle => $file_handle,
                })
           ],
        });

        my $condition = "(~reset_n || ($trace_event_expr)) && ~test_has_ended";
    
        push(@process_objs,
          e_if->new({ 
            condition => $condition,
            then      => [ 
              e_sim_write->new ({
                spec_string => $trace_string,
                expressions => $trace_args,
                show_time   => 1,
                file_handle => $file_handle,
              })
            ],
          })
        );
    }

    if ($checker_args && ($language eq "verilog")) {

        push(@process_objs,
          e_if->new({ 
            condition => "~reset_n || ($trace_event_expr)",
            then      => [ 
              e_sim_cmd->new({ 
                function_name => $pli_function_name,
                args          => $checker_args,
              }) 
            ],
          })
        );
    }

    if ($test_end_expr) {


        e_register->adds(


          {out => ["test_ending", 1, $force_export],
           in => "($inst_retire_expr) & ($test_end_expr)",
           enable => "1'b1"},



          {out => ["test_ending_d1", 1, 0, $force_never_export],
           in => "test_ending",
           enable => "1'b1"},
          {out => ["test_ending_d2", 1, 0, $force_never_export],
           in => "test_ending_d1",
           enable => "1'b1"},




          {out => ["test_has_ended", 1, $force_export],
           in => "($inst_retire_expr) & ($test_end_expr) | test_has_ended",
           enable => "1'b1"},
        );

        push(@process_objs,



          e_if->new({ 
            condition => "test_ending_d2",
            then      => [ 
              e_sim_write->new({ 
                spec_string => "Detected end of test\\n",
                show_time   => 1,
              }),
              e_stop->new()
            ],
          })
        );
    } else {

        e_assign->add([["test_has_ended", 1, $force_export], "1'b0"]);
    }

    if (scalar(@process_objs)) {
        e_process->adds({
          tag      => "simulation",
          contents => \@process_objs,
        });
    }
}





1;

