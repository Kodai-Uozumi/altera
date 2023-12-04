package ifneeded ::quartus::hdb_manager 1.0 {

	if [ catch { load "" hdb } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) db_hdb] hdb
		set_dll_loading -static
	}
}

