#
# altera_nios2_driver_hal.tcl
#

# Create a new driver
create_driver altera_nios2_hal_driver

# Associate it with some hardware known as "altera_nios2"
set_sw_property hw_class_name altera_nios2

# The version of this driver
set_sw_property version 9.0

# This driver may be incompatible with versions of hardware less
# than specified below. Updates to hardware and device drivers
# rendering the driver incompatible with older versions of
# hardware are noted with this property assignment.
set_sw_property min_compatible_hw_version 8.0

# Initialize the driver in alt_sys_init()
set_sw_property auto_initialize false

# Location in generated BSP that above sources will be copied into
set_sw_property bsp_subdirectory HAL

# This driver supports the HAL BSP (OS) type
add_sw_property supported_bsp_type HAL

#
# Source file listings...
#

# C/C++ source files
add_sw_property c_source HAL/src/alt_busy_sleep.c
add_sw_property c_source HAL/src/alt_irq_vars.c
add_sw_property c_source HAL/src/alt_usleep.c
add_sw_property c_source HAL/src/alt_icache_flush.c
add_sw_property c_source HAL/src/alt_icache_flush_all.c
add_sw_property c_source HAL/src/alt_dcache_flush.c
add_sw_property c_source HAL/src/alt_dcache_flush_all.c
add_sw_property c_source HAL/src/alt_dcache_flush_no_writeback.c
add_sw_property c_source HAL/src/alt_instruction_exception_entry.c
add_sw_property c_source HAL/src/alt_remap_cached.c
add_sw_property c_source HAL/src/alt_remap_uncached.c
add_sw_property c_source HAL/src/alt_uncached_free.c
add_sw_property c_source HAL/src/alt_uncached_malloc.c
add_sw_property c_source HAL/src/alt_do_ctors.c
add_sw_property c_source HAL/src/alt_do_dtors.c
add_sw_property c_source HAL/src/alt_gmon.c

# Include files
add_sw_property include_source HAL/inc/alt_types.h
add_sw_property include_source HAL/inc/io.h
add_sw_property include_source HAL/inc/nios2.h
add_sw_property include_source HAL/inc/priv/alt_busy_sleep.h
add_sw_property include_source HAL/inc/priv/nios2_gmon_data.h
add_sw_property include_source HAL/inc/sys/alt_debug.h
add_sw_property include_source HAL/inc/sys/alt_exceptions.h
add_sw_property include_source HAL/inc/sys/alt_irq_entry.h
add_sw_property include_source HAL/inc/sys/alt_irq.h
add_sw_property include_source HAL/inc/sys/alt_sim.h
add_sw_property include_source HAL/inc/sys/alt_stack.h
add_sw_property include_source HAL/inc/sys/alt_warning.h

# Assembly source files
add_sw_property asm_source HAL/src/alt_exception_entry.S
add_sw_property asm_source HAL/src/alt_exception_trap.S
add_sw_property asm_source HAL/src/alt_exception_muldiv.S
add_sw_property asm_source HAL/src/alt_irq_entry.S
add_sw_property asm_source HAL/src/alt_software_exception.S
add_sw_property asm_source HAL/src/alt_mcount.S
add_sw_property asm_source HAL/src/alt_log_macro.S
add_sw_property asm_source HAL/src/crt0.S

# End of file
