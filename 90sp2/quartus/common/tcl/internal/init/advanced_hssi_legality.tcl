package ifneeded ::quartus::advanced_hssi_legality 1.0 {

	if [ catch { load "" advanced_hssi_legality } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) db_rbc_tcl] advanced_hssi_legality
		set_dll_loading -static
	}
}

