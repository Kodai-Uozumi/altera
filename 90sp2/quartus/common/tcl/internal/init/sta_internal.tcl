package ifneeded ::quartus::sta_internal 1.0 {

	if [ catch { load "" sta_internal } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) tsm_sta] sta_internal
		set_dll_loading -static
	}
}

