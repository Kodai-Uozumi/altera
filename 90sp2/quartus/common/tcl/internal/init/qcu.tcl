package ifneeded ::quartus::qcu 1.0 {

	if [ catch { load "" qcu } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) comp_qcu] qcu
		set_dll_loading -static
	}
}

