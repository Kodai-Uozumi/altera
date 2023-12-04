package ifneeded ::quartus::pin_planner_db 1.0 {

	if [ catch { load "" dpf } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) db_dpf] dpf
		set_dll_loading -static
	}
}

