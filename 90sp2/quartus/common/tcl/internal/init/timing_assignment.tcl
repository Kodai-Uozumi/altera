package ifneeded ::quartus::timing_assignment 1.0 {

	if [ catch { load "" timing_asgn } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) sys_pjc] timing_asgn
		set_dll_loading -static
	}
}

