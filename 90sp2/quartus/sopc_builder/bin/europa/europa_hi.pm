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


























use e_blind_instance;
use europa_all;
use strict;

my @roms = (
            e_signal->new([data_out => 3]),
            e_rom->new
            ([test_rom => 
              {
                 address => "d7_delay_this",
                 q         => "data_out",
              },
              ])
            );

my @rams = (
            e_signal->news([d_delay_this => 12],
                           [data_outb => 3],
                           [d_delay_this2 => 12],
                           [data_outa => 3]),
            
            e_ram->news
            (
             [test_ram  => {rdaddress => "d_delay_this",
                            q         => "data_outb",}],
             [test_ram2 => {rdaddress => "d_delay_this2",
                            q         => "data_outa",}]
             )
            );

e_module->new
({
   name => "hi",
   contents =>
       [



        e_signal->news ([d1_goo     => 4, 1 ],
                        [delay_this => 3,   ],
                        ),
        
        e_process->new
        ({
           a_conts => [ e_assign->new (["d1_goo",0] )],
           conts   => [ e_assign->new (["d1_goo",
                                        "d1_goo[d1_goo.msb : 0] + d1_goo[d1_goo.msb : 0] + 1"])
                        ],
        }),











        e_blind_instance->new
        ({
           module => "asdf",
           in_port_map => {clk => "clk",
                           reset_n => "reset_n",
                           new => "foo",
                        },
           out_port_map => {booger => "erk"},
        }),

        e_signal->news
        ([ erg => 1],
         [ bar => 1],
         ),

        e_register->new
        ({
           delay      => 8,
           in         => "delay_this",
           async_value => 32,
           async_set  => "erg",



           enable     => "",
        }),

        e_signal->news
        ([select_this => 4],
         [mux_out     => 1]
         ),
        
        e_mux->new
        ({
           type => "selecto",
           selecto => "select_this",
           table => [
                     0 => "bar",
                     1 => "foo",
                     ],
               out  => "mux_out",
            }),

        @rams,
        @roms,
        ]
});

1;
