package ifneeded ::quartus::backannotate 1.0 {

	if [ catch { load "" asl } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) prj_asl] asl
		set_dll_loading -static
	}
}

package ifneeded ::quartus::backannotate 1.1 {

	if [ catch { load "" asl11 } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) prj_asl] asl11
		set_dll_loading -static
	}
}

