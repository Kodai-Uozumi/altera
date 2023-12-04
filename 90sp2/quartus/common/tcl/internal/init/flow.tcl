package ifneeded ::quartus::flow 1.0 {

	if [ catch { load "" flow } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) sys_flow] flow
		set_dll_loading -static
	}
}

package ifneeded ::quartus::flow 1.1 {

	if [ catch { load "" flow11 } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) sys_flow] flow11
		set_dll_loading -static
	}
}

