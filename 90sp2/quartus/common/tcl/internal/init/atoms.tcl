package ifneeded ::quartus::atoms 1.0 {

	if [ catch { load "" atoms } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) atm_ctcl] atoms
		set_dll_loading -static
	}
}

