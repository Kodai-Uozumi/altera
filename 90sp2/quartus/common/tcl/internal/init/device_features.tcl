package ifneeded ::quartus::device_features 1.0 {

	if [ catch { load "" dev_fea } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) db_dftcl] dev_fea
		set_dll_loading -static
	}
}

