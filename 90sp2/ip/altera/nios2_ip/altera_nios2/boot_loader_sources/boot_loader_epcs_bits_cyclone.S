// file: boot_loader_epcs_bits_cyclone.S
// asmsyntax=nios2
//
// Copyright 2006 Altera Corporation, San Jose, California, USA.
// All rights reserved.
//
// written by TPA, moved around by dvb, 2003-2004
// routines for accessing data out of EPCS serial
// flash device. This device is made of registers
// and you gotta talk to the registers to get
// your bytes.
//
// optimized by kds 2004.
//
// re-factored by jrk, 2006.01.26:
// - FPGA device-family-specific code moved to
//   separate sources.
// - This file contains EPCS boot routines
//   specific to the Cyclone I & Cyclone II
//   device families only; Stratix II support
//   is provided in a separate file, so that
//   separate (and thus small) boot loader
//   executables will be built.
//

#include "boot_loader.h"

    .global sub_find_payload_epcs

// |
// | Let the code begin
// |

    .text

//
// Find_Payload for EPCS:
//
// The process:
//     - Open the EPCS at zero (where device-config lives)
//     - Analyze the config. to get the payload-start-address.
//     - Close the EPCS.
//     - Open the EPCS up again at the payload-address.
//
sub_find_payload_epcs:
    // Fix-up and save return-address
    addi    r_findp_return_address, return_address_less_4, 4

  //
  // Compute the address of the EPCS control/status register block.
  //
  // This is 512 bytes from the very *start* of this program.
  //
  // | dvb adds: Since the code must be aligned on a 512-byte
  // | boundary, we simply take our current address, and round up
  // | to the next 512-byte boundary.
  //
  // | for debugging purposes, you may define EPCS_REGS_BASE
  // | to be the epcs registers base. Otherwise, it is presumed
  // | to be the first 512-byte-boundary after this very code.
  //
    nextpc  r_findp_temp

#ifdef EPCS_REGS_BASE
    movhi   r_epcs_base_address, %hi(EPCS_REGS_BASE)
    addi    r_epcs_base_address, r_epcs_base_address, %lo(EPCS_REGS_BASE)
#else
    ori     r_epcs_base_address, r_findp_temp, 511
    addi    r_epcs_base_address, r_epcs_base_address, 1
#endif

    //
    // Open EPCS-device at flash-offset zero.
    //
    movi    r_flash_ptr, 0
    nextpc  return_address_less_4
    br      sub_epcs_open_address

    //
    // Analyze the device config by sequentially reading bytes out of the
    //  flash until one of three things happen:
    //       1) We find an 0xA6 (well, really 0x56 because we're not reversing
    //           the bits while searching).  When we find it, we've found the
    //           device configuration, and can continue figuring out it's
    //           length
    //       2) We see a byte other than 0xFF, in which case we're not looking
    //           at a device configuration at all.  Instead we assume we must
    //           be looking at a boot loader record.  Skip the whole "length
    //           of the configuration" calculation, and start loading.
    //       3) We don't find anything other than 0xFF's for an arbitrarily
    //           long time.  We then surmise that the flash must be blank, and
    //           having no other recourse, we hang.
    //

    // search an arbitrarily large number of bytes
    movi    r_findp_count, 0x400

    // the pattern we're looking for
    movi    r_findp_pattern, 0x56

    // what we'll accept until we see the pattern
    movi    r_findp_temp, 0xFF

fp_look_for_56_loop:
    nextpc  return_address_less_4
    br      sub_read_byte_from_flash_epcs

    // did we find our pattern?
    beq     r_read_byte_return_value, r_findp_pattern, fp_found_sync

    // did we see something other than an FF?
    bne     r_read_byte_return_value, r_findp_temp, fp_short_circuit

    // update the loop counter, and loop
    subi    r_findp_count, r_findp_count, 1
    bne     r_findp_count, r_zero, fp_look_for_56_loop

    // we didn't find a pattern, or anything else for that matter. Hang. 
    br      sub_epcs_hang_forever

fp_found_sync:
    // The magic sync pattern is followed by four bytes we aren't interested
    //  in.  Toss 'em.
    nextpc  return_address_less_4
    br      sub_read_int_from_flash_epcs

    // The next four bytes are the length of the configuration
    // They are in little-endian order, but (perversely), they
    // are each bit-reversed.
    nextpc  return_address_less_4
    br      sub_read_int_from_flash_epcs

    // put length in the flash pointer
    mov     r_flash_ptr, r_read_int_return_value

    // Ok, we've got the length, but in EPCS devices, Quartus stores the
    //   bytes in bit-reversed order.
    //
    //   We're going to reverse the bits by reversing nibbles, then di-bits,
    //   then bits, like this:
    //
    //  76543210 -- nibbles --> 32107654 -- di-bits --> 10325476 -- bits --> 01234567
    //
    //   Here are the machinations the following loop goes through.
    //       You'll notice that the sequence only illustrates one byte.
    //       Never fear, all of the bytes in the word are being reversed
    //       at the same time
    //
    //   ("x" == unknown, "." == zero)
    //
    //                             byte        temp        mask    count
    //                           --------    --------    --------  -----
    //   Initial state           76543210    xxxxxxxx    00001111    4
    //
    // 1 temp = byte & mask      76543210    ....3210    00001111    4
    // 2 temp <<= count          76543210    3210....    00001111    4
    // 3 byte >>= count          xxxx7654    3210....    00001111    4
    // 4 byte &= mask            ....7654    3210....    00001111    4
    // 5 byte |= temp            32107654    3210....    00001111    4
    // 6 count >>= 1             32107654    3210....    00001111    2
    // 7 temp = mask << count    32107654    00111100    00001111    2
    // 8 mask ^= temp            32107654    00111100    00110011    2
    //
    //   loop on (count != 0)
    //
    //   temp = byte & mask      32107654    ..10..54    00110011    2
    //   temp <<= count          32107654    10..54..    00110011    2
    //   byte >>= count          xx321076    10..54..    00110011    2
    //   byte &= mask            ..32..76    10..54..    00110011    2
    //   byte |= temp            10325476    10..54..    00110011    2
    //   count >>= 1             10325476    10..54..    00110011    1
    //   temp = mask << count    10325476    01100110    00110011    1
    //   mask ^= temp            10325476    01100110    01010101    1
    //
    //   loop on (count != 0)
    //
    //   temp = byte & mask      10325476    .0.2.4.6    01010101    1
    //   temp <<= count          10325476    0.2.4.6.    01010101    1
    //   byte >>= count          x1032547    0.2.4.6.    01010101    1
    //   byte &= mask            .1.3.5.7    0.2.4.6.    01010101    1
    //   byte |= temp            01234567    0.2.4.6.    01010101    1
    //   count >>= 1             01234567    0.2.4.6.    01010101    0
    //   temp = mask << count    01234567    01010101    01010101    0
    //   mask ^= temp            01234567    01010101    00000000    0
    //

    // initialize the mask
    movhi   r_revbyte_mask, 0x0F0F
    addi    r_revbyte_mask, r_revbyte_mask, 0x0F0F

    // load the count
    movi    r_findp_count, 4

fp_reverse_loop:
    // mask off half of the bits, and put the result in TEMP
    and     r_findp_temp, r_flash_ptr, r_revbyte_mask       // 1

    // shift the bits in TEMP over to where we want 'em
    sll     r_findp_temp, r_findp_temp, r_findp_count       // 2

    // shift the bits in PTR the other way, so that they
    //   don't collide with those in TEMP
    srl     r_flash_ptr, r_flash_ptr, r_findp_count         // 3

    // mask off the bits in PTR we're going to replace with those from TEMP
    and     r_flash_ptr, r_flash_ptr, r_revbyte_mask        // 4

    // combine the bits in PTR with the bits from TEMP
    or      r_flash_ptr, r_flash_ptr, r_findp_temp          // 5

    // update the shift COUNT
    srli    r_findp_count, r_findp_count, 1                 // 6

    // shift the MASK
    sll     r_findp_temp, r_revbyte_mask, r_findp_count     // 7

    // update the MASK
    xor     r_revbyte_mask, r_revbyte_mask, r_findp_temp    // 8

    // loop if there's more to do
    bne     r_findp_count, r_zero, fp_reverse_loop

    //
    // Finally, it turns out the length was given in BITS.  Round-up
    //  to the next byte, and convert to bytes
    //
    addi    r_flash_ptr, r_flash_ptr, 7      // r_flash_ptr += 7
    srli    r_flash_ptr, r_flash_ptr, 3      // r_flash_ptr /= 8;

fp_short_circuit:
    // Close the EPCS device
    nextpc  return_address_less_4
    br      sub_epcs_close

    // Open it up again (at r_flash_ptr)
    nextpc  return_address_less_4
    br      sub_epcs_open_address

    jmp     r_findp_return_address

// end of file
