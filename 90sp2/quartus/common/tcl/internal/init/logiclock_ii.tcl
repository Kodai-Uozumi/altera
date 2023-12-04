package ifneeded ::quartus::logiclock_ii 1.0 {

	if [ catch { load "" llu } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) db_llu] llu
		set_dll_loading -static
	}
}

