package ifneeded ::quartus::sdc 1.5 {

	if [ catch { load "" sdc } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) tsm_sta] sdc
		set_dll_loading -static
	}
}

