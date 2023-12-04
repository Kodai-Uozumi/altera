package ifneeded ::quartus::cdb_manager 1.0 {

	if [ catch { load "" cdb_mgr } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) db_cdb_mgr] cdb_mgr
		set_dll_loading -static
	}
}

