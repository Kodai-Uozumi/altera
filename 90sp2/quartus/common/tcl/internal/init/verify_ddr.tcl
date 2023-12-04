package ifneeded ::quartus::verify_ddr 1.0 {

	if [ catch { load "" ddrtcl } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) tsm_ddrtcl] ddrtcl
		set_dll_loading -static
	}
}

