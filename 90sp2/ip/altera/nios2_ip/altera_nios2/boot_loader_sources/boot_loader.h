// file: boot_loader.h
// asmsyntax=nios2
//
// Copyright 2003-2004 Altera Corporation, San Jose, California, USA.
// All rights reserved.
//
// Register definitions for the boot loader code

// Symbolic definitions for how registers are used in this program
// program
#define r_zero                      r0
#define r_asm_tmp                   r1

#define r_flash_ptr                 r2
#define r_data_size                 r3
#define r_dest                      r4

#define r_halt_record               r5

#define r_read_int_return_value     r6
#define r_riff_count                r7
#define r_riff_return_address       r8
#define rf_temp                     r9

#define r_read_byte_return_value    r10

#define r_epcs_tx_value             r11

#define r_eopen_eclose_tmp          r12

#define r_findp_return_address      r13
#define r_findp_temp                r14
#define r_findp_pattern             r15
#define r_findp_count               r16

#define r_revbyte_mask              r17

#define r_epcs_base_address         r18

#define r_flush_counter             r19

#define r_trie_count                r20

#ifdef PROFILE
 #define r_prof_addr                r21
 #define r_prof_data                r22
#endif

#define return_address_less_4       r23


// end of file
