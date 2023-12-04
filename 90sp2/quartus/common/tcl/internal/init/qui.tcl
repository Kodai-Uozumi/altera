package ifneeded ::quartus::qui 1.0 {

	if [ catch { load "" qui } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) sys_qui] qui
		set_dll_loading -static
	}
}

