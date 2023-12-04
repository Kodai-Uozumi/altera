package ifneeded ::quartus::advanced_timing 1.1 {

	if [ catch { load "" advanced_tdb } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) tsm_tdb] advanced_tdb
		set_dll_loading -static
	}
}

package ifneeded ::quartus::advanced_timing 1.2 {

	if [ catch { load "" advanced_tdb12 } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) tsm_tdb] advanced_tdb12
		set_dll_loading -static
	}
}

