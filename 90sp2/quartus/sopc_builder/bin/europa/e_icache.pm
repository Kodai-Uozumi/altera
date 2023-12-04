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






















use e_bdpram;
use e_lpm_equal;
use e_vfifo;
use europa_all;
use strict;





































my $fsm_codes = 3;


my ($IDLE, $READ, $WAIT) = &one_hot_encoding ($fsm_codes);
my ($IDLE_BIT, $READ_BIT, $WAIT_BIT) = (0 .. ($fsm_codes - 1));

sub make_instruction_cache_control
{
    my ($Opt, $project) = (@_);

    my $module = e_module->new ({name => $Opt->{name}."_icache_control"});
    $project->add_module ($module);      

    my $marker = e_default_module_marker->new ($module);

    e_port->adds ([ic_read            => 1, "in" ],
                  [ic_flush           => 1, "in" ],
                  [waitrequest        => 1, "out"], # internal signal
                  [ic_readdatavalid   => 1, "out"],

                  [i_read             => 1, "out"],
                  [i_flush            => 1, "out"],
                  [i_waitrequest      => 1, "in" ], # from avalon
                  [i_readdatavalid    => 1, "in" ],

                  [enable_cache       => 1, "in" ],  # LED1 pin T18
                  [hit                => 1, "in" ],
                  [fifo_valid         => 1, "in" ],
                  [use_cache_data     => 1, "out"],  # LED2 pin T19
                  [write_to_cache     => 1, "out"],
                  [push               => 1, "out"], 
                  );


    e_signal->adds
        ([state      => $fsm_codes],
         [state_next => $fsm_codes]);

    e_register->adds 
        ({out => "state", in => "state_next",
          enable => undef, async_value => $IDLE});

    e_process->add({
      clock   => "",
      contents=> [
        e_case->new ({
          switch   => "state",
          parallel => 1,

          default_sim => 0,
          contents => {
            $IDLE => [
              e_if->new({
                  comment  => " IDLE if cache disabled or we're not reading",
                  condition=> "ic_read & enable_cache & !wait_pending",
                  then     => [
                    e_if->new({
                        comment  => " READ on a Miss else WAIT or return data",
                        condition=> "!hit",
                        then     => 
			    ["state_next" => "i_waitrequest ? $IDLE : $READ"],
                        else     => 
			    ["state_next" => "pending ? $WAIT : $IDLE"],
                    }),
                  ],
                  else     => ["state_next" => $IDLE],
              }),
            ],
            $READ => [
              e_if->new({
                  comment  => " Delayed Post of Read Request on Miss",
                  condition=> "i_waitrequest",
                  then     => ["state_next" => $READ],
                  else     => ["state_next" => $IDLE],







              }),
            ],
































            $WAIT => [
              e_if->new({
                  comment  => " Wait for !pending",
                  condition=> "fifo_empty",
                  then     => ["state_next" => $IDLE],
                  else     => ["state_next" => $WAIT],
              }),
            ],
            default=> ["state_next" => $IDLE],
          },
        }),
      ],
    });

    e_assign->add({
      lhs => "use_cache_data",
      rhs => "enable_cache ".
             "? ( (state[$IDLE_BIT] & ic_read & hit & !pending)".

             " | ( state[$WAIT_BIT] & !pending) )".
             ": 1'b0",
         });


    e_assign->add({
      lhs => "waitrequest",   
      rhs => "enable_cache ".
          "? ( (state[$IDLE_BIT] & ic_read & (!hit | pending))".

           " | (state[$WAIT_BIT] & pending)".
           " | (state[$READ_BIT] & i_waitrequest) )".
          ": i_waitrequest",
    });
    e_assign->add({
      lhs => "write_to_cache",
      rhs => "i_readdatavalid",
    });
    e_assign->add({
      lhs => "i_read",          
      rhs => "enable_cache ".
          "? state[$READ_BIT] & !wait_pending".
          ": ic_read & !wait_pending",
    });
    e_assign->add({
      lhs => "i_flush",          
      rhs => "!enable_cache & ic_flush",
    });
    e_assign->add({
      lhs => "ic_readdatavalid",
      rhs => "enable_cache ".
          "? use_cache_data | ".
            "(i_readdatavalid & fifo_valid & !(ic_flush & pending)) ".
          ": i_readdatavalid",
    });
    e_assign->add({
      lhs => "push",
      rhs => "enable_cache ".
          "? ( state[$READ_BIT] & !(i_waitrequest | wait_pending) ) ".
          ": (ic_read & !i_waitrequest & !wait_pending)",
    });

    return $module;
}

sub make_instruction_cache
{
    my ($Opt, $project) = (@_);

    my @submodules =(&make_instruction_cache_control($Opt, $project),
                     );
   
    my $module = e_module->new ({name => $Opt->{name}."_icache"});
    $project->add_module ($module);      

    my $marker = e_default_module_marker->new ($module);

    foreach my $submod (@submodules) 
        { e_instance->add({module => $submod->name()}); }











    my $k_size = $Opt->{cache_icache_size_k};
    my $b_size = $Opt->{CONSTANTS}{CONSTANT}{nasys_icache_line_size}{value};
    my $size = ($k_size * 1024)/$b_size;
    my $icache_set_width = log2($size);








    my $icache_data_width = 16; # default to 16 for NY instruction cache















    my $set_lsb = $icache_data_width >> 4;
    my $address_width = $Opt->{i_Address_Width};
    my $icache_tag_width = $address_width - ($icache_set_width + $set_lsb);
    my $set_msb = $set_lsb + $icache_set_width - 1;
    my $tag_lsb = $set_msb + 1;
    my $tag_msb = $tag_lsb + $icache_tag_width - 1;

    if ($icache_tag_width < 2)
    {
        die ("Maximum ICache size must be 25% or less".
             " of Total Memory Map Size!\n".
             "  Current Memory size is ".((2 ** $address_width)/1024).
             " kbytes\n".
             "  Current ICache size is ".$k_size." kbytes\n".
             "Please adjust cache size and regenerate.\n");
    }










    my $icache_line_length = 1 + $icache_tag_width + $icache_data_width;
















    e_port->adds ([ic_read          => 1,                       "in" ],
                  [ic_address_m1    => $address_width,          "in" ],
                  [ic_address       => $address_width,          "in" ],
                  [ic_address_clken => 1,                       "in" ],
                  [ic_flush         => 1,                       "in" ],
                  [c_enable_cache   => 1,                       "in" ],
                  [c_invalidate     => 1,                       "in" ],
                  [c_invalid_set    => $icache_set_width,       "in" ],
                  [ic_waitrequest   => 1,                       "out"],
                  [ic_readdatavalid => 1,                       "out"],
                  [ic_readdata      => $icache_data_width,      "out"],

                  [i_read           => 1,                       "out"],
                  [i_address        => $address_width,          "out"],
                  [i_flush          => 1,                       "out"],
                  [i_waitrequest    => 1,                       "in" ],
                  [i_readdatavalid  => 1,                       "in" ],
                  [i_readdata       => $icache_data_width,      "in" ],
                  );


















    e_signal->adds ([cache_valid => 1                 ],
                    [cache_tag   => $icache_tag_width ],
                    [cache_data  => $icache_data_width], );


    e_signal->adds (
                    [ic_set_m1   => $icache_set_width],
                    [ic_tag      => $icache_tag_width], );

    e_assign->adds (["ic_set",    "ic_address   \[$set_msb:$set_lsb\]"],
                    ["ic_set_m1", "ic_address_m1\[$set_msb:$set_lsb\]"],
                    ["ic_tag",    "ic_address   \[$tag_msb:$tag_lsb\]"],
                    );


    e_assign->add
        ({
            lhs => "ic_readdata",
            rhs => "use_cache_data ? cache_data : i_readdata",
        });
    















    
    e_signal->adds
        ({name         => "ic_set_assumed",
          width        => $icache_set_width,
          never_export => 1,
         },
         {name         => "ic_set",
          width        => $icache_set_width,
          never_export => 1,
         },
         );
    e_register->adds 
        ({out    => "ic_set_assumed",
          in     => "ic_set_m1",
          enable => "ic_address_clken", },
         );





    e_signal->adds
        (

         {name => "tag_match", never_export => 1},
         );

    e_lpm_equal->adds
        (











         {
             module      => $Opt->{name}."_icache_tag_compare_module",
             name        => $Opt->{name}."_icache_tag_compare",
             port_map    => {
                 "aeb"   => "tag_match",
                 "dataa" => "cache_tag",
                 "datab" => "ic_tag",
             },
             data_width  => $icache_tag_width,
             chain_size  => 4,
         },
         );


    e_assign->add (["hit" => "tag_match && cache_valid"]); # && set_match


    e_assign->add (["i_address" => "ic_address"]);





    e_signal->adds
        (
         {name => "enable_cache",      never_export => 1},
         {name => "enable_pending",    never_export => 1},
         {name => "wait_pending",      never_export => 1},
         );

    e_assign->add (["wait_pending" => "c_enable_cache != enable_cache"]);

    my ($CHANGE_ENABLE, $WAIT_PENDING) = ("1'b0", "1'b1");

    e_process->add({
        comment => " Enable/Disable Logic.",
        clock => "clk",
        asynchronous_contents =>
            [
             e_assign->news
             (
              ["enable_cache" => "1'b0"],
              ["enable_pending" => $CHANGE_ENABLE],
              ),
             ],
        contents =>
            [
             e_case->new({
                 switch   => "enable_pending",
                 parallel => 1,
                 full => 1,
                 contents =>
                 {
                     default => [],
                     $CHANGE_ENABLE =>
                         [
                          e_if->new({
                              comment   => " wait for c_enable_cache change",
                              condition => "(wait_pending & ~ic_flush)",
                              then      =>
                                  [
                                   e_assign->new
                                   (["enable_pending" => $WAIT_PENDING]),
                                   ],
                              }),
                          ],
                     $WAIT_PENDING =>
                         [
                          e_if->new({
                              comment => " wait for pending xactions to clear",
                              condition => "fifo_empty",
                              then      =>
                                  [
                                   e_assign->news
                                   (
                                    ["enable_pending" => $CHANGE_ENABLE],
                                    ["enable_cache" => "c_enable_cache"],
                                    ),
                                   ],
                               }),
                          ],
                  },
               }),
               ],
    });
    




    e_signal->adds
        (
         {name => "pending",           never_export => 1},
         {name => "stall",             never_export => 1},
         {name => "fifo_almost_full",  never_export => 1},
         {name => "fifo_almost_empty", never_export => 1},
         {name => "stall",             never_export => 1},
         {name => "posted_address",    width => $address_width},
         {name => "posted_set",        width => $icache_set_width},
         {name => "posted_tag",        width => $icache_tag_width},
         );
    
    e_assign->adds
        (
         ["pending"    => "!fifo_empty"],
         ["stall"      => "fifo_full"],
         ["posted_set" => "posted_address \[$set_msb:$set_lsb\]"],
         ["posted_tag" => "posted_address \[$tag_msb:$tag_lsb\]"],
         ["ic_waitrequest" => "waitrequest | (wait_pending & ~ic_flush)"],

         );












    e_instance->add
        ({
            module => e_vfifo->new
                ({
                    name_stub  => $Opt->{name}."_icache",
                    data_width => $address_width,
                    depth      => &max (2, $project->get_max_slave_read_latency
                        ($Opt->{name},$Opt->{Instruction_Master_Name})),
                }),
            port_map => {
                "reset_n"    => "reset_n",
                "enable"     => "enable_cache",
                "invalidate" => "ic_flush & !ic_waitrequest",
                "wr"         => "push",
                "rd"         => "i_readdatavalid",
                "wr_data"    => "ic_address",
                "rd_data"    => "posted_address",
                "empty"      => "fifo_empty",
                "full"       => "fifo_full",
                "valid"      => "fifo_valid",
                "almost_full"=> "fifo_almost_full",
                "almost_empty"=>"fifo_almost_empty",
            },
        });





    e_signal->adds(
                   {
                       name => 'q_a',
                       width => $icache_line_length,
                       never_export => 1,
                   },
                   {
                       name => 'q_b',
                       width => $icache_line_length,
                       never_export => 1,
                   },
		   {
		       name => 'addr_match',
                       never_export => 1,
		   },
                   );

    e_assign->adds
        (
         ["cache_valid" => "q_a\[".($icache_line_length - 1)."\]"],
         ["cache_tag"   => "q_a\[".
          (($icache_tag_width + $icache_data_width) - 1).
          ":$icache_data_width\]"],
         ["cache_data"  => "q_a\[".($icache_data_width - 1).":0\]"],
         );


    e_assign->add (["addr_match" => "(ic_set_m1 == posted_set)"]);
    






    my $clear_string = $icache_tag_width + $icache_data_width . "{1'b0}";
    my %port_map =
        (
         address_a => "enable_cache ? ic_set_m1 : c_invalid_set",
         address_b => "fifo_empty ? ic_set : posted_set",
         data_a    => "{1'b0, {".$clear_string."} }",
         data_b    => "{1'b1, posted_tag, i_readdata}",
         wren_a    => "c_invalidate",
         wren_b    => "write_to_cache",# & !addr_match",
         clock0    => "clk",
         clock1    => "clk",
         clocken0  => "ic_address_clken | !enable_cache",
         clocken1  => "enable_cache",

         q_a       => "q_a",
         );

    e_bdpram->add(
                  {module          => $Opt->{name}."_icache_memory_module",
                   name            => $Opt->{name}."_icache_memory",
                   port_map        => \%port_map,                        
                   a_data_width    => $icache_line_length,
                   b_data_width    => $icache_line_length,
                   a_address_width => $icache_set_width,
                   b_address_width => $icache_set_width,
                  }
                  );


    return $module;
}

qq{
You ask me why I stay on this blue mountain?
I smile but do not answer. 
My mind is at ease!
Peach blossoms and flowing streams 
Pass away without a trace.
How different from the mundane world! 
- Li P’o (701 - 762) 
};
