package ifneeded ::quartus::ioo 1.0 {

	if [ catch { load "" oracle } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) tsm_ioo] oracle
		set_dll_loading -static
	}
}

