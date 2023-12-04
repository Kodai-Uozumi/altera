package ifneeded ::quartus::help 1.0 {

	if [ catch { load "" help } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) ccl_atcl] help
		set_dll_loading -static
	}
}

