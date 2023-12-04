package ifneeded ::quartus::timing_report 1.0 {

	if [ catch { load "" ttcl } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) tsm_ttcl] ttcl
		set_dll_loading -static
	}
}

package ifneeded ::quartus::timing_report 1.1 {

	if [ catch { load "" ttcl11 } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) tsm_ttcl] ttcl11
		set_dll_loading -static
	}
}

