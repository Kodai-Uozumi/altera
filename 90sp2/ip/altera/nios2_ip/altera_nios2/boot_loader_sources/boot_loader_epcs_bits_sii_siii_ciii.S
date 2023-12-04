// file: boot_loader_epcs_bits_sii_siii_ciii.S
// asmsyntax=nios2
//
// Copyright 2007 Altera Corporation, San Jose, California, USA.
// All rights reserved.
//
// Refactored by jrk, 2006.01.26
// Cyclone III/Stratix II GX added 2007.08.15
// - FPGA device-family-specific code moved to
//   separate sources.
// - This file contains EPCS boot routines
//   specific to the Stratix II, Stratix II GX,
//   and Cyclone III device families only;
//   support for other device families is
//   provided in separate sources, so that
//   separate (and thus small) boot loader
//   executables will be built.
//
// Refactored by dyum, 2008.03.06
// Adding Stratix III support
//
// Updated by dyum, 2008.03.25
// Adding ArriaGX support
//

#include "boot_loader.h"

    .global sub_find_payload_epcs

// |
// | Let the code begin
// |

    .text

// |
// | Find_Payload for EPCS (Stratix II/Stratix III/Cyclone III edition):
// |
// | The process:
// |  1) Open the EPCS at zero (where device-config lives)
// |
// |  2) We see a byte other than 0xFF, prior to where non-0xFF SII/SIII/CIII
// |     configuration data is expected (byte[32]), in which case we're
// |     not looking at a device configuration. Instead we assume we must
// |     be looking at a boot loader record. Skip the whole "length
// |     of the configuration" calculation, and start loading.
// |
// |  3) We find that the bitstream targets a Stratix II/III or Cyclone III
// |     device .Extract the precise FPGA configuration length. Close/re-open
// |     the EPCS device after the FPGA configuration before returning to load
// |
// |  4) We don't find anything other than 0xFF's before where we expect
// |     configuration data, or, our attempts to verify that what appears to
// |     be Stratix II/III/Cyclone III data fail. In these cases we have no
// |     other recourse than to hang.
// |
// | A note about nomenclature in this code's documentation: data[N] refers to
// | Nth unit of data, assuming that you start counting at zero.
// |

sub_find_payload_epcs:
    // Fix-up and save return-address
    addi    r_findp_return_address, return_address_less_4, 4

  //
  // Compute the address of the EPCS control/status register block.
  //
  // This is 1024 bytes (targeting Stratix II/III/Cyclone III) from the very
  // *start* of this program.
  //
  // Note: On Cyclone I/II its 512 bytes -- the SII/SIII/CIII boot loader
  // is just a hair too big to fit into 512. The enterprising engineer
  // with an appreciation for tightly-wound and barely-readable code
  // may wish to further optimize this. After stariing at the code for
  // an hour I figured, after optimizations, I'd still be a few instructions
  // over the top. I tried.
  //
  // | dvb adds: Since the code must be aligned on a 1024-byte
  // | boundary, we simply take our current address, and round up
  // | to the next 1024-byte boundary.
  //
  // | for debugging purposes, you may define EPCS_REGS_BASE
  // | to be the epcs registers base. Otherwise, it is presumed
  // | to be the first 1024-byte-boundary after this very code/
  //
    nextpc  r_findp_temp

#ifdef EPCS_REGS_BASE
    movhi   r_epcs_base_address, %hi(EPCS_REGS_BASE)
    addi    r_epcs_base_address, r_epcs_base_address, %lo(EPCS_REGS_BASE)
#else
    ori     r_epcs_base_address, r_findp_temp, 1023
    addi    r_epcs_base_address, r_epcs_base_address, 1
#endif

    //
    // 1) Open EPCS-device at flash-offset zero.
    //
    movi    r_flash_ptr, 0
    nextpc  return_address_less_4
    br      sub_epcs_open_address

    //
    // 2) Attempt to find software boot record
    //

    // Search until we expect configuration data to start
    movi    r_findp_count, 32

    // What we'll accept until we see the pattern
    movi    r_findp_temp, 0xFF

fp_look_for_software_boot_record:
    nextpc  return_address_less_4
    br      sub_read_byte_from_flash_epcs

    // Did we see something other than an 0xFF?
    bne     r_read_byte_return_value, r_findp_temp, fp_short_circuit

    // Update the loop counter, and loop
    subi    r_findp_count, r_findp_count, 1
    bne     r_findp_count, r_zero, fp_look_for_software_boot_record

    //
    // 3) We didn't find a boot record. Is there a bitstream?
    //
    //    A 7-bit Software-Device ID code is stored in bit[1]*
    //    of bytes [59..52] of the configuration data. Device IDs in the
    //    range 0x91..0x96 (inclusive) indicate that the configuration data
    //    targets Stratix II; 0xE1..0xE4 -- Stratix II GX; 0xF1..0xF7:
    //    Cyclone III; 0x01..0x07: Stratix III; 0x21..0x23 -- Arria GX
    //
    //    * Data is stored in EPCS backwards; each byte is reversed. Thus,
    //      if we're looking for data bit[1] we will actually grab bit[6].

    // Close & re-open EPCS where we expect the device ID code to start
    movi    r_flash_ptr, 52
    nextpc  return_address_less_4
    br      sub_epcs_close
    nextpc  return_address_less_4
    br      sub_epcs_open_address

    // Number of bytes we'll traverse to get the device ID (one bit each)
    movi    r_findp_count, 8

    // Clear the register we'll construct the ID into
    movi    r_findp_pattern, 0

fp_assemble_device_id:
    // Read sequential byte from EPCS
    nextpc  return_address_less_4
    br      sub_read_byte_from_flash_epcs

    // Mask off all but bit[6] as described above
    andi    r_read_byte_return_value, r_read_byte_return_value, 0x40

    // Shift to the MSB position of the 8-bit value we're constructing
    // (the data we're after is being read LSB first)
    slli    r_read_byte_return_value, r_read_byte_return_value, 0x1

    // Shift result register & capture new data into bit[7]
    srli    r_findp_pattern, r_findp_pattern, 0x1
    or      r_findp_pattern, r_findp_pattern, r_read_byte_return_value

    // Update loop counter & loop
    subi    r_findp_count, r_findp_count, 1
    bne     r_findp_count, r_zero, fp_assemble_device_id

    // We now have an 8-bit device ID stored in r_findp_pattern. Validate it.

    // Stratix III?
    movi    r_findp_temp, 0x01
    bltu    r_findp_pattern, r_findp_temp, fp_check_device_id_arria_gx
    movi    r_findp_temp, 0x07
    bgtu    r_findp_pattern, r_findp_temp, fp_check_device_id_arria_gx
    br      fp_device_id_ok

fp_check_device_id_arria_gx:
    // Arria GX?
    movi    r_findp_temp, 0x21
    bltu    r_findp_pattern, r_findp_temp, fp_check_device_id_stratix_ii
    movi    r_findp_temp, 0x23
    bgtu    r_findp_pattern, r_findp_temp, fp_check_device_id_stratix_ii
    br      fp_device_id_ok

fp_check_device_id_stratix_ii:
    // Stratix II?
    movi    r_findp_temp, 0x91
    bltu    r_findp_pattern, r_findp_temp, fp_check_device_id_stratix_ii_gx
    movi    r_findp_temp, 0x96
    bgtu    r_findp_pattern, r_findp_temp, fp_check_device_id_stratix_ii_gx
    br      fp_device_id_ok

fp_check_device_id_stratix_ii_gx:
    // Stratix II GX?
    movi    r_findp_temp, 0xE1
    bltu    r_findp_pattern, r_findp_temp, fp_check_device_id_cyclone_iii
    movi    r_findp_temp, 0xE4
    bgtu    r_findp_pattern, r_findp_temp, fp_check_device_id_cyclone_iii
    br      fp_device_id_ok

fp_check_device_id_cyclone_iii:
    // Cyclone III... if we do not validate here, hang forever.
    // Otherwise, drop down; the device ID is good.
    movi    r_findp_temp, 0xF1
    bltu    r_findp_pattern, r_findp_temp, sub_epcs_hang_forever
    movi    r_findp_temp, 0xF7
    bgtu    r_findp_pattern, r_findp_temp, sub_epcs_hang_forever

    //
    // If we arrive at this point we have verified that there is valid-looking
    // configuration data. Extract its length.
    //
    // Like searching for the Software-Device ID code, the configuration
    // bitstream length is encoded in a particular bit of a run of bytes.
	// Total length field is 32 bits, which goes from CB Option bits 86..55
	// corresponding to bit[3] of  byte[39] to byte[33] (for the most 
	// significant 7 bits) followed by the range of bits
    // made up of bit[2] of bytes[72..48]. The above note about EPCS
    // bit reversal still applies (so we're really looking at bits[4] and [5],
    // respectively.
    //

fp_device_id_ok:
    // First, loop through bits in bytes [48..72] - LSB of the length first
    // Number of bytes we'll traverse to get the length
    movi    r_findp_count, 25

    // Clear the register we'll construct the length into
    movi    r_findp_temp, 0

    // Close & re-open EPCS where we will start extracting the length
    movi    r_flash_ptr, 48
    nextpc  return_address_less_4
    br      sub_epcs_close
    nextpc  return_address_less_4
    br      sub_epcs_open_address

fp_assemble_configuration_length:
    // Read sequential byte from EPCS
    nextpc  return_address_less_4
    br      sub_read_byte_from_flash_epcs

    // Mask off all but bit[5] as described above
    andi    r_read_byte_return_value, r_read_byte_return_value, 0x20

    // Shift to the MSB position of the value we're constructing
    // (which happens to be 26 bits left of the bit we're working with)
    // (the data we're after is being read LSB first)... this may
    // seem backwards (it is), but the sub_read_byte_from_flash_epcs
    // routine auto increments the EPCS addres for us; thus the cleanest
    // implementation is to load data from sequential addresses, LSB first.
    slli    r_read_byte_return_value, r_read_byte_return_value, 26

    // Shift result register & capture new data into bit[31]
    srli    r_findp_temp, r_findp_temp, 0x1
    or      r_findp_temp, r_findp_temp, r_read_byte_return_value

    // Update loop counter & loop
    subi    r_findp_count, r_findp_count, 1
    bne     r_findp_count, r_zero, fp_assemble_configuration_length

    // We've assembled 25 bits of the length; 7 to go. 
    // We're gonna look at bit[3] of byte[33..39].

	// Number of bytes we'll traverse to get the length
	movi	r_findp_count, 7

	// Close & re-open EPCS at byte 33
	movi	r_flash_ptr, 33
	nextpc	return_address_less_4
	br		sub_epcs_close
	nextpc	return_address_less_4
	br		sub_epcs_open_address

fp_assemble_configuration_length_top_bits:
	// Read sequential bytes from EPCS
	nextpc	return_address_less_4
	br		sub_read_byte_from_flash_epcs

	// Mask off all but bit[4] as described above
	andi	r_read_byte_return_value, r_read_byte_return_value, 0x10
	
	// Shift to the MSB position of the value we're constructing as before
	slli	r_read_byte_return_value, r_read_byte_return_value, 27

	// Shift result register & capture new data into bit[31]
	srli	r_findp_temp, r_findp_temp, 0x1
	or		r_findp_temp, r_findp_temp, r_read_byte_return_value

	// Update loop counter & loop
	subi	r_findp_count, r_findp_count, 1
	bne		r_findp_count, r_zero, fp_assemble_configuration_length_top_bits

    // Put extracted length in the flash pointer
    mov     r_flash_ptr, r_findp_temp

    //
    // Finally, it turns out the length was given in BITS.  Round-up
    // to the next byte, and convert to bytes
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

    // Return; EPCS is now ready for boot-loading business
    jmp     r_findp_return_address

// end of file
