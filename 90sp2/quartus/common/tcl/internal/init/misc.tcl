package ifneeded ::quartus::misc 1.0 {

	if [ catch { load "" misc } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) ccl_atcl] misc
		set_dll_loading -static
	}

	# BEGIN_PROCEDURE_HEADER ###################################################
	#
	proc escape_brackets_internal { str } {
	#
	# Description: Procedure definition for "escape_brackets" command.
	#
	# END_PROCEDURE_HEADER #####################################################
	
			regsub -all {\\} $str {\\\\} str
			return [regsub -all "(\[\\\[\\\]\])" $str "\\\\&"]
	}

	# BEGIN_PROCEDURE_HEADER ###################################################
	#
	proc enable_natural_bus_naming_internal {} {
	#
	# Description: Procedure definition for "enable_natural_bus_naming" command.
	#
	# END_PROCEDURE_HEADER #####################################################
	
		if {[info commands unknown_original] == ""} {
			rename unknown unknown_original
			proc unknown { cmd args } {
				if {[regexp {^[0-9*?]+$} $cmd] || [regexp {^[0-9]+\.\.[0-9]+$} $cmd]} {
					return "\[$cmd\]"
				} elseif {[string compare "" [info command help]] != 0 && [catch {help -search $cmd} result] && [string match "ERROR: *" $result] == 1} {
					return -code error $result
				} else {
					eval unknown_original $cmd $args
				}
			}
		}
		
		set_quartus_array -key natural_bus_naming 1
	}

	# BEGIN_PROCEDURE_HEADER ###################################################
	#
	proc disable_natural_bus_naming_internal {} {
	#
	# Description: Procedure definition for "disable_natural_bus_naming" command.
	#
	# END_PROCEDURE_HEADER #####################################################
	
		if {[info commands unknown_original] != ""} {
			rename unknown ""
			rename unknown_original unknown
		}
		
		set_quartus_array -key natural_bus_naming 0
	}
}

