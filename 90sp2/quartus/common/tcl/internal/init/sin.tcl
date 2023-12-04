package ifneeded ::quartus::sin 1.0 {

	if [ catch { load "" sin } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) tsm_sin] sin
		set_dll_loading -static
	}
}

