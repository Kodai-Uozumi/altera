package ifneeded ::quartus::hspo 1.0 {

	if [ catch { load "" hspice } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) neto_hspo] hspice
		set_dll_loading -static
	}
}

