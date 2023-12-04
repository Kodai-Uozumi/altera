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
use europa_all;
use strict;
































my $fsm_codes = 4;



my @CC = &one_hot_encoding ($fsm_codes);
my @CC_BITS = (0 .. ($fsm_codes -1));


sub make_data_cache_control
{
  my ($Opt, $project) = (@_);

  my $module = e_module->new ({name => $Opt->{name}."_dcache_control"});
  $project->add_module ($module);      

  my $marker = e_default_module_marker->new ($module);

  e_port->adds (
    [dc_read            => 1, "in" ],
    [dc_waitrequest     => 1, "out"],

    [d_read             => 1, "out"],
    [d_waitrequest      => 1, "in" ],
    
    [enable_cache       => 1, "in" ],
    [hit                => 1, "in" ],
    [use_cache_data     => 1, "out"],  # LED2 pin T19
    [write_to_cache     => 1, "out"],
    

  );


























  

  e_signal->adds ([cc      => 4],
                  [cc_next => 4],);

  e_register->adds 
      ({out => "cc", in => "cc_next", enable => undef, async_value => $CC[0]},
      );


  e_process->add({
    clock   => "",
    contents=> [
      e_if->new ({
        comment   => " IDLE",
        condition => "cc[$CC_BITS[0]]",
        then => 
            [
             e_if->new({
                 comment  => " Do nothing if cache disabled",
                 condition=> "enable_cache",
                 then     =>
                     [ # Reads and writes never happen simultaneously
                       e_if->new({
                           comment  => " READ: Go to wait on a Miss;".
                               "else data comes back from the RAM",
                               condition=> "dc_read",
                               then     => ["cc_next" => $CC[2]],
                               elsif    => ({
                                   comment  => " WRITE: Wait for write-thru.",
                                   condition=> "dc_write",
                                   then     => ["cc_next" => $CC[1]],
                                   else     => ["cc_next" => $CC[0]],
                               }),
                           }),
                       ],
                 else     => ["cc_next" => $CC[0]],
             }),
             ],
        elsif => {
          comment   => " WAIT",
          condition => "cc[$CC_BITS[1]]",
          then =>
              [
               e_if->new({
                   comment  => " Wait for Rd Data",
                   condition=> "!d_waitrequest",
                   then     => ["cc_next" => $CC[3]],
                   else     => ["cc_next" => $CC[1]],
               }),
               ],
          elsif => {
              comment   => " HIT?",
              condition => "cc[$CC_BITS[2]]",
              then =>
                  [
                   e_if->new({
                       comment  => " If Hit => done, else Wait for Rd Data.",
                       condition=> "hit",
                       then     => ["cc_next" => $CC[0]],
                       else     => ["cc_next" => $CC[1]],
                   }),
                   ],
              else => [cc_next => $CC[0]],
          },
        },
    }),  # end of e_if
    ],  # end of contents
  });


  e_assign->add({
      lhs => "use_cache_data",
      rhs => "enable_cache & dc_read & hit",
  });



  e_assign->add({
      lhs => "dc_waitrequest",
      rhs => "enable_cache ? (!cc_next[$CC_BITS[0]]) : d_waitrequest",
  });




  e_assign->add({
      lhs => "write_to_cache",
      rhs => "cc_next[$CC_BITS[3]]",
  }); # "(!d_waitrequest & (dc_write | d_read))",

  e_assign->add({
      lhs => "d_read",
      rhs => "enable_cache ? cc[$CC_BITS[1]] & dc_read : dc_read",
  });


  e_assign->add({
      lhs => "d_write",
      rhs => "dc_write & (!cc[$CC_BITS[3]])",
  });

  return $module;
}

sub make_data_cache
{
    my ($Opt, $project) = (@_);

    my @submodules =(&make_data_cache_control($Opt, $project),
                     );
   
    my $module = e_module->new ({name => $Opt->{name}."_dcache"});
    $project->add_module ($module);      

    my $marker = e_default_module_marker->new ($module);

    foreach my $submod (@submodules) 
        { e_instance->add({module => $submod->name()}); }











    my $k_size = $Opt->{cache_dcache_size_k};
    my $b_size = $Opt->{CONSTANTS}{CONSTANT}{nasys_dcache_line_size}{value};
    my $size = ($k_size * 1024)/$b_size;
    my $dcache_set_width = log2($size);



    my $dcache_data_width = 32; # default to 32 for now, but use var...
















    my $set_lsb = $dcache_data_width >> 4;
    my $address_width = $Opt->{d_Address_Width};
    my $dcache_tag_width = $address_width - ($dcache_set_width + $set_lsb);
    my $set_msb = $set_lsb + $dcache_set_width - 1;
    my $tag_lsb = $set_msb + 1;
    my $tag_msb = $tag_lsb + $dcache_tag_width - 1;

    if ($dcache_tag_width < 2)
    {
        die ("\nMaximum DCache size must be 25% or less".
             " of Total Memory Map Size!\n".
             "  Current Memory size is ".((2 ** $address_width)/1024).
             " kbytes\n".
             "  Current DCache size is ".$k_size." kbytes\n".
             "Please adjust cache size and regenerate.\n");
    }










    my $dcache_line_length = 1 + $dcache_tag_width + $dcache_data_width;


    my $dcache_byteena_width = $dcache_data_width >> 3; # divide by 8.
















    e_port->adds (
          [dc_read          => 1,                       "in" ],
          [dc_read_pre      => 1,                       "in" ],
          [dc_address_pre   => $address_width,          "in" ],
          [dc_address       => $address_width,          "in" ],
          [c_suppress       => 1,                       "in" ],
          [c_enable_cache   => 1,                       "in" ],
          [c_invalidate     => 1,                       "in" ],
          [c_invalid_set    => $dcache_set_width,       "in" ],
          [dc_waitrequest   => 1,                       "out"],
          [dc_readdata      => $dcache_data_width,      "out"],

          [dc_write         => 1,                       "in" ],
          [dc_writedata     => $dcache_data_width,      "in" ],
          [dc_byteenable    => $dcache_byteena_width,   "in" ],

          [d_write          => 1,                       "out"],
          [d_writedata      => $dcache_data_width,      "out"],
          [d_byteenable     => $dcache_byteena_width,   "out"],

          [d_read           => 1,                       "out"],
          [d_address        => $address_width,          "out"],
          [d_waitrequest    => 1,                       "in" ],
          [d_readdata       => $dcache_data_width,      "in" ],



    );






    e_signal->adds ([cache_valid => 1 ],
                    [cache_tag   => $dcache_tag_width ],
                    [cache_data  => $dcache_data_width],
                    [writedata   => $dcache_data_width],
                    [readdata    => $dcache_data_width],
                    [d_readdata_d=> $dcache_data_width],
                    [writevalid  => 1 ],
                    [dc_clk_en   => 1 ],
                    );


    e_signal->adds ([dc_set      => $dcache_set_width],
                    [dc_set_pre  => $dcache_set_width],
                    [dc_tag      => $dcache_tag_width],
                    );

    e_assign->adds (["dc_set",     "dc_address    \[$set_msb:$set_lsb\]"],
                    ["dc_set_pre", "dc_address_pre\[$set_msb:$set_lsb\]"],
                    ["dc_tag",     "dc_address    \[$tag_msb:$tag_lsb\]"],
                    );


    e_register->add
        ({out => "enable_cache", in => "c_enable_cache", enable => undef});


    e_register->adds
      ({out => "d_readdata_d", in => "d_readdata",
        enable => undef, async_value => $dcache_data_width."'b0"},
       );


    e_assign->add
        (["readdata" => "enable_cache ? d_readdata_d : d_readdata"]);


    e_assign->add 
        (["dc_readdata" => "use_cache_data ? cache_data : readdata"]);



    e_assign->add 
        (["writedata" => "dc_write ? dc_writedata : d_readdata"]);





    e_assign->add
        (["writevalid" =>
          "enable_cache && ".
          "( ((dc_write | dc_read) && &dc_byteenable && !c_suppress_d) )"]);



    e_assign->add
        (["dc_clk_en" => "dc_read_pre & !dc_waitrequest"]);





    e_signal->add ([set => $dcache_set_width]);
    e_register->adds 
        ( # set is our own internal register'd copy of dc_set
          {out    => "set",
           in     => "dc_set_pre",
           enable => "dc_clk_en", },  # was dc_address_clken

          {out    => "c_suppress_d",
           in     => "c_suppress",
           enable => "!dc_waitrequest", }, # supression is for 1 read OR write
          );



    e_register->adds
      ({out => "set_match", in => "(set == dc_set)",
        enable => undef, async_value => "1'b0"},
       {out => "tag_match", in => "(cache_tag == dc_tag)",
        enable => undef, async_value => "1'b0"},
       {out => "cache_valid_d", in => "cache_valid",
        enable => undef, async_value => "1'b0"},
       {out => "c_suppress_d_d", in => "c_suppress_d",
        enable => undef, async_value => "1'b0"},
      );


    e_assign->add(["hit" =>
                   "set_match & tag_match & cache_valid_d & !c_suppress_d_d"]);


    e_assign->adds (["d_address", "dc_address"],
                    ["d_writedata", "dc_writedata"],
                    ["d_byteenable", "dc_byteenable"],
                    );





    e_signal->adds(
        {
            name => 'q_a',
            width => $dcache_line_length,
            never_export => 1,
        },
        {
            name => 'q_b',
            width => $dcache_line_length,
            never_export => 1,
        },
    );

    e_assign->adds
        (
         ["cache_valid" => "q_a\[".($dcache_line_length - 1)."\]"],
         ["cache_tag"   => "q_a\[".
          (($dcache_tag_width + $dcache_data_width) - 1).
          ":$dcache_data_width\]"],
         ["cache_data"  => "q_a\[".($dcache_data_width - 1).":0\]"],
         );






    my $clear_string = $dcache_tag_width + $dcache_data_width . "{1'b0}";
    my %port_map = (
        wren_a    => "write_to_cache",
        wren_b    => "c_invalidate",
        data_a    => "{writevalid, dc_tag, writedata}",
        data_b    => "{1'b0, {".$clear_string."}}",
        address_a => "write_to_cache ? dc_set : dc_set_pre",
        address_b => "c_invalid_set",
        clock0    => "clk",
        clock1    => "clk",
        clocken0  => "enable_cache & (write_to_cache | dc_clk_en)",
        clocken1  => "!enable_cache",

        q_a       => "q_a",
    );

    e_bdpram->add(
                  {module          => $Opt->{name}."_dcache_memory_module",
                   name            => $Opt->{name}."_dcache_memory",
                   port_map        => \%port_map,                        
                   a_data_width    => $dcache_line_length,
                   b_data_width    => $dcache_line_length,
                   a_address_width => $dcache_set_width,
                   b_address_width => $dcache_set_width,
                  }
                  );


    return $module;
}

qq{
Just detach from all sound and form,
And do not dwell in detachment,
And do not dwell in intellectual understanding,
This is practice. 
- Baizhang 
};
