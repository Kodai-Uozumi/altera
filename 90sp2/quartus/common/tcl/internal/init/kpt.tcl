package ifneeded ::quartus::kpt 1.0 {

	if [ catch { load "" kpt } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) db_kpt] kpt
		set_dll_loading -static
	}
}

