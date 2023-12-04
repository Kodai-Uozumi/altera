package ifneeded ::quartus::sta 1.0 {

	if [ catch { load "" sta } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) tsm_sta] sta
		set_dll_loading -static
	}
}

