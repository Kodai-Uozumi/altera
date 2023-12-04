package ifneeded ::quartus::io_checker 1.0 {

	if [ catch { load "" fitio } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) fitter_fiochk] fitio
		set_dll_loading -static
	}
}

