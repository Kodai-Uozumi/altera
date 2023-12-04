package ifneeded ::quartus::internal_idu_test 1.0 {

	if [ catch { load "" idu } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) db_idu_tcl] idu
		set_dll_loading -static
	}
}

