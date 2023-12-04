package ifneeded ::quartus::advanced_wysiwyg 1.0 {

	if [ catch { load "" wys_info } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) db_wys] wys_info
		set_dll_loading -static
	}
}

