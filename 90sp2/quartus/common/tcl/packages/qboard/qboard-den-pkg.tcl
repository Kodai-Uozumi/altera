package provide ::qboard::den 1.0

# ----------------------------------------------------------------
#
namespace eval ::qboard::den {
#
# Description: DE2 Configuration
#
# ----------------------------------------------------------------


	namespace export get_name
	namespace export get_revision
	namespace export set_default_assignments 

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
    
    variable pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]
    variable board_name "DE Nano Kit"
}

# ----------------------------------------------------------------
#
proc ::qboard::den::get_revision { } {
#
# Description: Get revision
#
# ----------------------------------------------------------------

	variable pvcs_revision
	return $pvcs_revision
}

# ----------------------------------------------------------------
#
proc ::qboard::den::get_name { } {
#
# Description: Get revision
#
# ----------------------------------------------------------------

	variable board_name
	return $board_name
}

# ----------------------------------------------------------------
#
proc ::qboard::den::set_default_assignments { } {
	#
	# Description: Make all required QSF assignments
	#
	# ----------------------------------------------------------------

	# Set QBOARD's Family and Device
	set_global_assignment -name FAMILY "MAX II"
	set_global_assignment -name DEVICE EPM2210F324C3

	# Pin & Location Assignments
	# ==========================

	# Other Assignments
	# =====================
	set_location_assignment PIN_J6 -to CLOCK_50 -tag qboard
	set_location_assignment PIN_U14 -to KEY[2] -tag qboard
	set_location_assignment PIN_V15 -to KEY[1] -tag qboard
	set_location_assignment PIN_U15 -to KEY[0] -tag qboard
	set_location_assignment PIN_U13 -to LED[0] -tag qboard
	set_location_assignment PIN_V13 -to LED[1] -tag qboard
	set_location_assignment PIN_U12 -to LED[2] -tag qboard
	set_location_assignment PIN_V12 -to LED[3] -tag qboard
	set_location_assignment PIN_V5 -to LED[4] -tag qboard
	set_location_assignment PIN_U5 -to LED[5] -tag qboard
	set_location_assignment PIN_V4 -to LED[6] -tag qboard
	set_location_assignment PIN_U4 -to LED[7] -tag qboard
	set_location_assignment PIN_V14 -to KEY[3] -tag qboard

}
