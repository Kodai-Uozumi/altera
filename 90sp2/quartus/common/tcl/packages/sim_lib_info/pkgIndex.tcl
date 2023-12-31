# Tcl package index file, version 1.1
# This file is generated by the "pkg_mkIndex -lazy" command
# and sourced either when an application starts up or
# by a "package unknown" script.  It invokes the
# "package ifneeded" command to set up package-related
# information so that packages will be loaded automatically
# in response to "package require" commands.  When this
# script is sourced, the variable $dir must contain the
# full path name of this file's directory.

package ifneeded ::quartus::sim_lib_info 1.0 [list tclPkgSetup $dir ::quartus::sim_lib_info 1.0 {{sim_lib_info_pkg.tcl source {::quartus::sim_lib_info::get_family_independent_sim_models ::quartus::sim_lib_info::get_family_specific_sim_models ::quartus::sim_lib_info::get_sim_models_for_family ::quartus::sim_lib_info::get_sim_models_for_library ::quartus::sim_lib_info::get_supported_family_list ::quartus::sim_lib_info::is_family_supported}}}]
