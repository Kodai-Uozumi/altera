proc load_internal_script {script} {

	set fullpath [file join [file dirname [info script]] $script]
	if {[file exists $fullpath] == 0} {
		set fullpath [file join $::quartus(tclpath) internal $script]
		if {[file exists $fullpath] == 0} {
			set fullpath [file join $::quartus(binpath) $script]
		}
	}

	source $fullpath
}

load_internal_script "sys_pjc.tcl"
load_internal_script "prj_asd_import.tcl"