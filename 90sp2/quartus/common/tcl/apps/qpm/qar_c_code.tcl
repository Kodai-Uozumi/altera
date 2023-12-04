#############################################################################
##  $Header: //acds/rel/9.0sp2/quartus/qscripts/qpm/qar_c_code.tcl#1 $
##
##  Quartus II Archive Graphical User Interface
##  This script allows a user to easily archive project files.
##
##  ALTERA LEGAL NOTICE
##  
##  This script is  pursuant to the following license agreement
##  (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE
##  FOLLOWING): Copyright (c) 2009-2010 Altera Corporation, San Jose,
##  California, USA.  Permission is hereby granted, free of
##  charge, to any person obtaining a copy of this software and
##  associated documentation files (the "Software"), to deal in
##  the Software without restriction, including without limitation
##  the rights to use, copy, modify, merge, publish, distribute,
##  sublicense, and/or sell copies of the Software, and to permit
##  persons to whom the Software is furnished to do so, subject to
##  the following conditions:
##  
##  The above copyright notice and this permission notice shall be
##  included in all copies or substantial portions of the Software.
##  
##  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
##  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
##  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
##  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
##  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
##  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
##  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
##  OTHER DEALINGS IN THE SOFTWARE.
##  
##  This agreement shall be governed in all respects by the laws of
##  the State of California and by the laws of the United States of
##  America.
##
##
##  CONTACTING ALTERA
##  
##  You can contact Altera through one of the following ways:
##  
##  Mail:
##     Altera Corporation
##     Applications Department
##     101 Innovation Drive
##     San Jose, CA 95134
##  
##  Altera Website:
##     www.altera.com
##  
##  Online Support:
##     www.altera.com/mysupport
##  
##  Troubshooters Website:
##     www.altera.com/support/kdb/troubleshooter
##  
##  Technical Support Hotline:
##     (800) 800-EPLD or (800) 800-3753
##        7:00 a.m. to 5:00 p.m. Pacific Time, M-F
##     (408) 544-7000
##        7:00 a.m. to 5:00 p.m. Pacific Time, M-F
##  
##     From other locations, call (408) 544-7000 or your local
##     Altera distributor.
##  
##  The mySupport web site allows you to submit technical service
##  requests and to monitor the status of all of your requests
##  online, regardless of whether they were submitted via the
##  mySupport web site or the Technical Support Hotline. In order to
##  use the mySupport web site, you must first register for an
##  Altera.com account on the mySupport web site.
##  
##  The Troubleshooters web site provides interactive tools to
##  troubleshoot and solve common technical problems.
##

#############################################################################
##  Additional Packages Required
package require ::qpm::lib::ccl

#############################################################################
##  Export Functions & Declare Global Namespace Variables
namespace eval ::qpm::qar_c_code {

    namespace export main
    namespace export get_file_sets
    namespace export get_file_subsets
    namespace export get_file_set_ui_name
    namespace export get_file_set_is_default
    namespace export get_file_set_file_subsets
    namespace export get_file_subset_ui_name
    namespace export get_file_subset_description
    namespace export is_mapper_required

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
    variable pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

	variable archive_templates
	variable archive_packages
}

#############################################################################
##  Procedure:  load_plugins
##
##  Arguments:
##      None
##
##  Description:
##      Look for all files of the form qpm-<id>-template.tcl under
##      the QPM packages directory, and for each one, package require
##      it and get its name.
##      Build the archive_templates with it
proc ::qpm::qar_c_code::load_plugins {} {

	variable archive_templates
	variable archive_packages

	set archive_packages [::qpm::lib::ccl::get_ordered_list_of_pkgs 1]

	foreach archive_id [::qpm::lib::ccl::get_ordered_list_of_templates 1] {

		lappend archive_templates $archive_id
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qar_c_code::get_file_sets {} {
# -------------------------------------------------
# -------------------------------------------------

	variable archive_templates
	return $archive_templates
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qar_c_code::get_file_subsets {} {
# -------------------------------------------------
# -------------------------------------------------

	variable archive_packages
	return $archive_packages
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qar_c_code::get_file_set_ui_name { id } {
# -------------------------------------------------
# -------------------------------------------------

	return [::qpm::template::${id}::get_title]
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qar_c_code::get_file_set_is_default { id } {
# -------------------------------------------------
# -------------------------------------------------

	return [::qpm::template::${id}::is_default]
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qar_c_code::get_file_set_file_subsets { id } {
# -------------------------------------------------
# -------------------------------------------------

	return [::qpm::template::${id}::get_packages]
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qar_c_code::get_file_subset_ui_name { id } {
# -------------------------------------------------
# -------------------------------------------------

	return [::qpm::pkg::${id}::get_title]
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qar_c_code::get_file_subset_description { id } {
	# Returns the file subset ID description
# -------------------------------------------------
# -------------------------------------------------

	set text ""
	foreach line [::qpm::lib::ccl::get_package_description $id] {
		append text "$line\r\n"
	}
	return $text
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qar_c_code::get_file_subset_files_to_archive { id } {
	# Returns the file subset ID description
# -------------------------------------------------
# -------------------------------------------------

	return [::qpm::pkg::${id}::get_archive_files]
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qar_c_code::is_mapper_required { pkgs } {
	# Returns true if QMAP is required
# -------------------------------------------------
# -------------------------------------------------

	variable archive_templates
	variable archive_packages

	set is_required 0
	if {[string compare $pkgs ""] == 0} {
		set default_id ""
		foreach id $archive_templates {
			if {[::qpm::template::${id}::is_default]} {
				set default_id $id
			}
		}
		set pkgs [::qpm::qar_c_code::get_file_set_file_subsets $default_id]
	}
	foreach pkg $pkgs {
		if {[::qpm::pkg::${pkg}::requires_mapper]} {
			set is_required 1
		}
	}
	if {$is_required} {
		set is_required [::qpm::lib::ccl::is_mapper_required]
	}
	return $is_required
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qar_c_code::main {} {
	# Main function
# -------------------------------------------------
# -------------------------------------------------

	::qpm::qar_c_code::load_plugins
}
