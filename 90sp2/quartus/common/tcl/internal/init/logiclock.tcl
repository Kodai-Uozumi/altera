package ifneeded ::quartus::logiclock 1.0 {

	if [ catch { load "" xru } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) db_qtk_tcl] xru
		set_dll_loading -static
	}
}

