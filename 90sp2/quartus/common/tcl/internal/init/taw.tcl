package ifneeded ::quartus::taw 1.0 {

	if [ catch { load "" taw } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) tsm_taw] taw
		set_dll_loading -static
	}
}

