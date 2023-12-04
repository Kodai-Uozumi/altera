package ifneeded ::quartus::advanced_device 1.0 {

	if [ catch { load "" adv_ddb } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) ddb_dtcl] adv_ddb
		set_dll_loading -static
	}
}

package ifneeded ::quartus::advanced_device 2.0 {

	if [ catch { load "" adv_ddb20 } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) ddb_dtcl] adv_ddb20
		set_dll_loading -static
	}
}

