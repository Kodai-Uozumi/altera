package ifneeded ::quartus::placer_delay_matrix 1.0 {

	if [ catch { load "" pldm } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) tsm_pldm_ygr] pldm
		set_dll_loading -static
	}
}

