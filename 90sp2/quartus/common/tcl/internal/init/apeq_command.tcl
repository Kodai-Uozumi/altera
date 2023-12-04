package ifneeded ::quartus::apeq_command 1.0 {

	if [ catch { load "" apeq_command } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) ace_apeq_command] apeq_command
		set_dll_loading -static
	}
}

