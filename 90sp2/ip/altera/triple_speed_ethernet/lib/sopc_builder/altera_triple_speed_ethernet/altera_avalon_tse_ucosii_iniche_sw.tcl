#
# triple_speed_ethernet_sw.tcl
#

# Create a new driver named "triple_speed_ethernet_driver"
create_driver triple_speed_ethernet_driver_ucosii_iniche

# Associate it with some hardware known as "triple_speed_ethernet"
set_sw_property hw_class_name triple_speed_ethernet

# The version of this driver
set_sw_property version 9.0

# This driver may be incompatible with versions of hardware less
# than specified below. Updates to hardware and device drivers
# rendering the driver incompatible with older versions of
# hardware are noted with this property assignment.
set_sw_property min_compatible_hw_version 9.0

# Initialize the driver in alt_sys_init()
set_sw_property auto_initialize true

# Location in generated BSP that above sources will be copied into
set_sw_property bsp_subdirectory drivers

# This driver supports the UCOSII BSP (OS) type
add_sw_property supported_bsp_type UCOSII

# Add preprocessor flag "-DALTERA_TRIPLE_SPEED_MAC"
add_sw_property alt_cppflags_addition "-DALTERA_TRIPLE_SPEED_MAC"

#
# Source file listings...
#

# C/C++ source files
add_sw_property c_source HAL/src/altera_avalon_tse_system_info.c
add_sw_property c_source HAL/src/altera_avalon_tse.c
add_sw_property c_source UCOSII/src/iniche/ins_tse_mac.c


# Include files
add_sw_property include_source HAL/inc/altera_avalon_tse_system_info.h
add_sw_property include_source HAL/inc/altera_avalon_tse.h
add_sw_property include_source HAL/inc/triple_speed_ethernet.h
add_sw_property include_source inc/triple_speed_ethernet_regs.h
add_sw_property include_source UCOSII/inc/iniche/triple_speed_ethernet_iniche.h
add_sw_property include_source UCOSII/inc/iniche/ins_tse_mac.h

# Include Directory
add_sw_property include_directory HAL/inc
add_sw_property include_directory inc
add_sw_property include_directory UCOSII/inc/iniche


# End of file
