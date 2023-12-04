package ifneeded ::quartus::file_manager 1.0 {

	if [ catch { load "" afm } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) sys_afm] afm
		set_dll_loading -static
	}
}

