package ifneeded ::quartus::qic_project_utilities 1.0 {

	if [ catch { load "" qpu } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) prj_qpu] qpu
		set_dll_loading -static
	}
}

