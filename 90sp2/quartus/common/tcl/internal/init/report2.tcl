package ifneeded ::quartus::report2 1.0 {

	if [ catch { load "" report2 } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) db_rdb] report2
		set_dll_loading -static
	}
}

