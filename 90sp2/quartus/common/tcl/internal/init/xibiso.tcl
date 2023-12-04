package ifneeded ::quartus::xibiso 1.0 {

	if [ catch { load "" xibiso } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) neto_xibiso] xibiso
		set_dll_loading -static
	}
}

