package ifneeded ::quartus::ddr_timing_model 1.0 {

	if [ catch { load "" ddrtcl_timing } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) tsm_ddrtcl] ddrtcl_timing
		set_dll_loading -static
	}
}

