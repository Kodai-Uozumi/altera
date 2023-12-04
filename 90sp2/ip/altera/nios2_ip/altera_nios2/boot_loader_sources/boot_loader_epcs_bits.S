// file: boot_loader_epcs_bits.S
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
// - This file contains routines common to the
//   boot-loader for the interface to the EPCS
//   Controller peripheral.
//

#include "boot_loader.h"

    .global sub_read_int_from_flash_epcs
    .global sub_read_byte_from_flash_epcs
    .global sub_streaming_copy_epcs
    .global sub_epcs_open_address
    .global sub_epcs_close
    .global sub_epcs_hang_forever

// EPCS control/status register offsets
#define EPCS_RXDATA_OFFSET  0x00
#define EPCS_TXDATA_OFFSET  0x04
#define EPCS_STATUS_OFFSET  0x08
#define EPCS_CONTROL_OFFSET 0x0C

// EPCS Bit Masks
#define EPCS_STATUS_TMT_MASK  0x20
#define EPCS_STATUS_TRDY_MASK 0x40
#define EPCS_STATUS_RRDY_MASK 0x80

#define EPCS_CONTROL_SSO_MASK 0x400

// EPCS commands
#define EPCS_COMMAND_READ 0x03


// |
// | Let the code begin
// |

    .text


////////
// epcs_hang_forever
//
// We found nothing of interest. Hang -- but be good and close the
// EPCS device first. If someone comes along and resets the CPU to do
// something useful, this will allow proper EPCS access.
//
sub_epcs_hang_forever:
    nextpc  return_address_less_4
    br      sub_epcs_close
fp_hang:
    br      fp_hang

////////
// EPCS_Open_Address
//
// "Open-up" the EPCS-device so we can start reading sequential bytes
// from a given address (the address is 'given' in r_flash_ptr).
//
// This is simply a front-end for the sub_tx_rx_int_epcs routine.
// as such, it doesn't need to fix up a return address.  Instead,
// it branches directly to sub_tx_rx_int_epcs, and lets the
// sub-routine return to origional caller.
//
//   Register usage:
//       argument:       r_flash_ptr
//       temporary:      r_eopen_eclose_tmp
//       return-value:   --none--
//
sub_epcs_open_address:
    // No fix-up, we're just a front-end

    // Enable device CS via control-register bit.
    movi    r_eopen_eclose_tmp, EPCS_CONTROL_SSO_MASK
    stwio   r_eopen_eclose_tmp, EPCS_CONTROL_OFFSET (r_epcs_base_address)

    // get the read command into our the transmit byte
    movhi   r_epcs_tx_value, (EPCS_COMMAND_READ << 8)

    // put the flash pointer into the lower 24 bits
    or      r_epcs_tx_value, r_epcs_tx_value, r_flash_ptr

    // functionally fall through to the tx_rx_int routine.
    br      sub_tx_rx_int_epcs

    // The EPCS flash is now open at r_flash_ptr.


////////
// EPCS_Close
//
// Terminate current EPCS transaction.
//
sub_epcs_close:
    // Fix-up return-address  (NOTE: LEAF)
    addi    return_address_less_4, return_address_less_4, 4

    // Wait until controller says "Transmitter empty."
close_ready_loop:
    ldwio   r_eopen_eclose_tmp, EPCS_STATUS_OFFSET (r_epcs_base_address)
    andi    r_eopen_eclose_tmp, r_eopen_eclose_tmp, EPCS_STATUS_TMT_MASK
    beq     r_eopen_eclose_tmp, r_zero, close_ready_loop

    // Deassert CS by clearing the SSO-bit (write zero to entire register):
    stwio   r_zero, EPCS_CONTROL_OFFSET (r_epcs_base_address)

    // Return
    jmp     return_address_less_4   // Don't worry--we fixed it.


////////
// sub_read_int_from_flash_epcs
//
// Alternate entry point for epcs_rx_tx.
//
//   Zero the epcs_tx_value before falling through to sub_tx_rx_int_epcs.
//
sub_read_int_from_flash_epcs:

    // This reads the NEXT sequential integer from the EPCS device,
    // on the assumption that a valid read-command, with address,
    // has already been sent, and the CS-bit has been left on.
    //
    // Zero the word we're transmitting.
    //
    mov     r_epcs_tx_value, r_zero

    //
    // fall through to the sub_tx_rx_int_epcs routine
    //


////////
// sub_tx_rx_int_epcs
//
//   Subroutine which reads writes four bytes to flash while
//   at the same time reading four bytes.  EPCS does this whether
//   you like it or not.  The four bytes start at a
//   not-necessarily-aligned flash offset.
//
//   Strangly, this routine writes MSB first, and reads LSB first.
//   This is required because the EPCS device itself takes commands
//   (which is the only reason we write to EPCS inside a boot loader)
//   MSB first, but SOFs and code are organized LSB first.
//
//   This routine shares its input argument with the tx_rx_byte
//   routine.  This is only safe as long as the tx_rx_byte routine
//   doesn't trash it's argument.
//
//   Register usage:
//      argument:            r_epcs_tx_value
//      local variable:      r_trie_count
//      local return ptr:    r_riff_return_address
//      return-value:        r_read_int_return_value
//
sub_tx_rx_int_epcs:
    // Fix-up and stash return address
    addi    r_riff_return_address, return_address_less_4, 4

    //
    // write bytes (MSB first) and read them (LSB first)
    //

    // clear the return value
    mov     r_read_int_return_value, r_zero

    // number of bytes to tx/rx
    movi    r_trie_count, 4

trie_loop:
    // position the transmit byte
    roli    r_epcs_tx_value, r_epcs_tx_value, 8

    // tx/rx a byte
    nextpc  return_address_less_4
    br      sub_tx_rx_byte_epcs

    // put it into the LSB of the result
    or      r_read_int_return_value, r_read_int_return_value, r_read_byte_return_value

    // rotate the result so that the latest byte is in the MSB,
    //  moving the other bytes down toward the LSB (no rori)
    roli    r_read_int_return_value, r_read_int_return_value, 24

    // decrement the counter, and loop
    subi    r_trie_count, r_trie_count, 1
    bne     r_trie_count, r_zero, trie_loop

    // Return.
    jmp     r_riff_return_address


////////
// sub_read_byte_from_flash_epcs
//
// Alternate entry point for epcs_rx_tx.
//
//   Zero the epcs_tx_value before falling through to the
//       epcs_tx_rx routine.
//
sub_read_byte_from_flash_epcs:

    // This reads the NEXT sequential byte from the EPCS device,
    // on the assumption that a valid read-command, with address,
    // has already been sent, and the CS-bit has been left on.
    //
    // Just by transmitting another zero to the device, we end up
    // getting-back the next sequential byte.
    //
    mov     r_epcs_tx_value, r_zero

    //
    // fall through to the sub_tx_rx_byte_epcs routine
    //


////////
// sub_tx_rx_byte_epcs
//
// EPCS devices are funny--every time you want to send something, you
// also recieve something.  Every time you want to recieve something,
// you must send something.
//
// This routine transmits its argument, and returns whatever was
// recieved as its result.
//
// Because this is a boot-copier, and there's not a damned thing we could
// do or say if we got an error, the possibility of error-conditions is
// entirely ignored.
//
// Register usage:
//   argument:       r_epcs_tx_value
//   temporary:      rf_temp
//   return-value:   r_read_byte_return_value
//
sub_tx_rx_byte_epcs:
    // Fix-up return-address  (NOTE: LEAF)
    addi    return_address_less_4, return_address_less_4, 4

    // Wait until controller is ready for a TX-char, then send it.
tx_ready_loop:
    ldwio   rf_temp, EPCS_STATUS_OFFSET (r_epcs_base_address)
    andi    rf_temp, rf_temp, EPCS_STATUS_TRDY_MASK
    beq     rf_temp, r_zero, tx_ready_loop

    stwio   r_epcs_tx_value, EPCS_TXDATA_OFFSET (r_epcs_base_address)

    // Wait until an RX-character shows-up, then get it.
rx_ready_loop:
    ldwio   rf_temp, EPCS_STATUS_OFFSET (r_epcs_base_address)
    andi    rf_temp, rf_temp, EPCS_STATUS_RRDY_MASK
    beq     rf_temp, r_zero, rx_ready_loop

    ldbuio  r_read_byte_return_value, EPCS_RXDATA_OFFSET (r_epcs_base_address)

    // Return
    jmp     return_address_less_4   // Don't worry--we fixed it.


////////
// Streaming copy
//
//   Copies r_data_size bytes from r_flash_ptr to r_dest
//
//   Register usage:
//       argument:   r_data_size - number of bytes to copy
//       argument:   r_dest      - destination of the copy
//       implied:    r_flash_ptr - source address for the copy
//       temporary:  rf_temp
//       return-value : none
//
//   All args are smashed by this routine
//
//   Note: we don't keep the flash ptr up to date.  Instead
//           we just keep streaming from the EPCS device
//
sub_streaming_copy_epcs:
    // Fix-up return-address  (NOTE: LEAF)
    addi    return_address_less_4, return_address_less_4, 4

    // for legibility
    #define r_dest_end r_data_size

    // convert the length to the ending address
    add     r_dest_end, r_data_size, r_dest
    subi    r_dest_end, r_dest_end, 1

    // Wait until controller is ready for a TX-char
epcs_copy_initial_wait:
    ldwio   rf_temp, EPCS_STATUS_OFFSET (r_epcs_base_address)
    andi    rf_temp, rf_temp, EPCS_STATUS_TRDY_MASK
    beq     rf_temp, r_zero, epcs_copy_initial_wait

    // prime the stream by sending the initial zero
    stwio   r_zero, EPCS_TXDATA_OFFSET (r_epcs_base_address)

    //
    // do {
    //   *r_dest++ = (char*)r_flash_ptr++)
    // while (r_dest <= r_dest_end);
    //
epcs_copy_loop:
    // Wait until an RX-character is available
    ldwio   rf_temp, EPCS_STATUS_OFFSET (r_epcs_base_address)
    andi    rf_temp, rf_temp, EPCS_STATUS_RRDY_MASK
    beq     rf_temp, r_zero, epcs_copy_loop

    // grab the RX-character, and immediately ask for another one
    //   no need to wait for TX ready, if RX is ready, then TX is too
    ldwio   rf_temp, EPCS_RXDATA_OFFSET (r_epcs_base_address)
    stwio   r_zero, EPCS_TXDATA_OFFSET (r_epcs_base_address)

    // store the character we retrieved, and update the destination ptr
    stbio   rf_temp, 0(r_dest)
    addi    r_dest, r_dest, 1

    // loop until the destination == the ending address
    bne     r_dest, r_dest_end, epcs_copy_loop

epcs_copy_last_wait:
    // Wait until an RX-character is available
    ldwio   rf_temp, EPCS_STATUS_OFFSET (r_epcs_base_address)
    andi    rf_temp, rf_temp, EPCS_STATUS_RRDY_MASK
    beq     rf_temp, r_zero, epcs_copy_last_wait

    // grab the last RX-character
    ldwio   rf_temp, EPCS_RXDATA_OFFSET (r_epcs_base_address)

    // store the last character
    stbio   rf_temp, 0(r_dest)

    // Return
    jmp     return_address_less_4   // Don't worry--we fixed it.

// end of file
