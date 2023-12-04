/*
 * file: excalibur.ld
 *
 * This linker script is designed to work
 * with SOPC Builder, mk_custom_sdk, and nios-build.
 *
 * These three tools are completely CPU-agnostic
 * and can produce software for any SOPC Builder
 * compatible CPU that uses a GNU tool chain.
 *
 * (nios-build, despite its name, is CPU-agnostic.)
 *
 * This linker script is loosely based on
 * Red Hat's standard linker script as
 * ported to Nios.
 *
 * Modified by dvb@altera, 2000-2003
 */

ENTRY(_start)

SEARCH_DIR(/usr/altera/lib);

SECTIONS
{
  /* Read-only sections, merged into text segment: */

  . = nasys_program_mem;

  /*
   * Begin the read-only code section here.
   */

  .text      :
  {
    *(.text.prefix) /* Force prefix to be first */
    *(.init)
    *(.init.*)
    *(.text)
    *(.text.*)
    *(.gnu.linkonce.t*)
  } =0

  . = ALIGN(4);
  _etext = .;

  PROVIDE (etext = .);

  /*
   * Begin the read-only but not-relocated section of
   * memory here.
   */

  _nasys_rodata = .;

  .ctors   : 
  {
    _ctors_begin = .;
    KEEP (*(.ctors))
    _ctors_end = .;
  }
   .dtors         :
  {
    _dtors_begin = .;
    KEEP (*(.dtors))
    _dtors_end = .;
  }
  .rodata   :
  {
    *(.rodata)
    *(.rodata.*)
    *(.gnu.linkonce.r*)
  }

  _nasys_rodata_end = .;

  /*
   * --------------------------------------------------
   * the .data section contains initialized and writeable
   * variables. If we have separate code & data, we need
   * to have it load in code area, but have the symbols
   * resolve to the data area.
   */
  
  _nasys_data_source = .;
  _nasys_data_destination = (nasys_program_mem == nasys_data_mem) ? _nasys_data_source : nasys_data_mem;

  .data _nasys_data_destination : AT (_nasys_data_source)
  {
    _data = .;
    *(.data)
    *(.data.*)
    *(.gnu.linkonce.d*)
    SORT(CONSTRUCTORS)

    . = ALIGN(4);
    _edata = .;
    _nasys_data_destination_end = .;
    PROVIDE (edata = .);
  }

  _nasys_data_source_end = _nasys_data_source + SIZEOF(.data);

  /*
   * Lastly, the noninitialized storage area.
   * This will start immediately following
   * the initialized data destination address end.
   * This is either right next to the code,
   * if code address = data address, or out in
   * the data memory, if they're different.
   */

  __bss_start = .;
  _nasys_uninitialized_storage = .;

  .bss       :
  {
    _bss = .;
    *(.dynbss)
    *(.bss)
    *(.bss.*)
    *(COMMON)
    *(.dynsbss)
    *(.sbss)
    *(.sbss.*)
    *(.scommon)
    . = ALIGN(4);
  }
  _nasys_uninitialized_storage_end = .;

  /*
   * "_end" is used as the start of the mallocable memoryarea
   */

  _end = .;
  PROVIDE (end = .);

  /*
   * To see if you've exceeded memory, you can
   * check the symbols "_end" for the end of all static
   * data memory, and "_etext" for the end of the code,
   * against your memory map. -- dvb
   */

  /*
   * ------------------------------------------------------------
   * dvb say: "I'll leave all this stuff down here exactly
   * as I found it, for debugging info, without
   * understanding it."
   */

  /* Stabs debugging sections.  */
  .stab 0 : { *(.stab) }
  .stabstr 0 : { *(.stabstr) }
  .stab.excl 0 : { *(.stab.excl) }
  .stab.exclstr 0 : { *(.stab.exclstr) }
  .stab.index 0 : { *(.stab.index) }
  .stab.indexstr 0 : { *(.stab.indexstr) }
  .comment 0 : { *(.comment) }
  /* DWARF debug sections.
     Symbols in the DWARF debugging sections are relative to the beginning
     of the section so we begin them at 0.  */
  /* DWARF 1 */
  .debug          0 : { *(.debug) }
  .line           0 : { *(.line) }
  /* GNU DWARF 1 extensions */
  .debug_srcinfo  0 : { *(.debug_srcinfo) }
  .debug_sfnames  0 : { *(.debug_sfnames) }
  /* DWARF 1.1 and DWARF 2 */
  .debug_aranges  0 : { *(.debug_aranges) }
  .debug_pubnames 0 : { *(.debug_pubnames) }
  /* DWARF 2 */
  .debug_info     0 : { *(.debug_info) }
  .debug_abbrev   0 : { *(.debug_abbrev) }
  .debug_line     0 : { *(.debug_line) }
  .debug_frame    0 : { *(.debug_frame) }
  .debug_str      0 : { *(.debug_str) }
  .debug_loc      0 : { *(.debug_loc) }
  .debug_macinfo  0 : { *(.debug_macinfo) }
  /* SGI/MIPS DWARF 2 extensions */
  .debug_weaknames 0 : { *(.debug_weaknames) }
  .debug_funcnames 0 : { *(.debug_funcnames) }
  .debug_typenames 0 : { *(.debug_typenames) }
  .debug_varnames  0 : { *(.debug_varnames) }
  /* These must appear regardless of  .  */
}

