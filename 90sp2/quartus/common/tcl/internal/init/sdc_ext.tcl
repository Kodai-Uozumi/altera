package ifneeded ::quartus::sdc_ext 1.0 {

	if [ catch { load "" sdc_ext } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) tsm_sta] sdc_ext
		set_dll_loading -static
	}
}

