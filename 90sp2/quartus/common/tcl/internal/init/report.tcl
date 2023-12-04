package ifneeded ::quartus::report 1.0 {

	if [ catch { load "" rdb } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) db_rdb] rdb
		set_dll_loading -static
	}
}

package ifneeded ::quartus::report 2.0 {

	if [ catch { load "" rdb20 } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) db_rdb] rdb20
		set_dll_loading -static
	}
}

package ifneeded ::quartus::report 2.1 {

	if [ catch { load "" rdb21 } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) db_rdb] rdb21
		set_dll_loading -static
	}
}

