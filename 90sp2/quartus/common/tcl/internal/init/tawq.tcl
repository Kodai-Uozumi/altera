package ifneeded ::quartus::tawq 1.0 {

	if [ catch { load "" tawq } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) tsm_tawq] tawq
		set_dll_loading -static
	}
}

