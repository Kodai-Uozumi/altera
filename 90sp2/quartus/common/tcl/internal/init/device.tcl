package ifneeded ::quartus::device 1.0 {

	if [ catch { load "" ddb } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) ddb_dev] ddb
		set_dll_loading -static
	}
}

