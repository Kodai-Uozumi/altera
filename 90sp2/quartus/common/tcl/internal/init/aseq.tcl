package ifneeded ::quartus::aseq 1.0 {

	if [ catch { load "" aseq } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) saui_aseq] aseq
		set_dll_loading -static
	}
}

