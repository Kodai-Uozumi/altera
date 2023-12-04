package ifneeded ::quartus::dbu 1.0 {

	if [ catch { load "" dbu } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) tsm_dbu] dbu
		set_dll_loading -static
	}
}

