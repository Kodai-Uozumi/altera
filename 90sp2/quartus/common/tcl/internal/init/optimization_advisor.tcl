package ifneeded ::quartus::optimization_advisor 1.0 {

	if [ catch { load "" oaw } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) resr_oaw] oaw
		set_dll_loading -static
	}
}

