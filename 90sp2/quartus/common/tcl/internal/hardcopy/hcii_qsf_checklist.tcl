# ----------------------------------------------------------------
#
namespace eval qsf_checklist {
#
# Description:	Provides information on HCII assignments
#				that requires verification.
#
# ----------------------------------------------------------------

	# ************************************************************
	#
	# Following array contains information about the assignments.
	# The format is:
	#
	#	-----------------
	#	key
	#	-----------------
	#
	#	  <qsf assignment>
	#
	#	-----------------
	#	values (in order)
	#	-----------------
	#
	#     <applicable flow type>     : <all|hcii_to_sii>
	#     <applicable device family> : <all|stratixii|hardcopyii|stratixiii>
	#     <recommended value>        : <value>
	#     <ui name>                  : <value>
	#     <master recommendation #>  : <value>
	#     <slave recommendation #>   : <value>
	#     <is enabled for TimeQuest> : <0 or 1>
	#
	# ************************************************************

	variable all "all"
	variable hcii_to_sii "hcii_to_sii"
	variable sii "stratixii"
	variable siii "stratixiii"
	variable siv "stratixiv"
	variable hcii "hardcopyii"
	variable hciii "hardcopyiii"
	variable hciv "hardcopyiv"
	variable on "ON"
	variable off "OFF"
	variable empty ""
	variable tq_on "1"
	variable tq_off "0"
	variable none "<None>"

	variable global_assignments [list \
\
	USE_TIMEQUEST_TIMING_ANALYZER  		    [list $all $all $on $empty TQ $empty $tq_off] \
	ENABLE_DRC_SETTINGS						[list $all $all $on "Enable Design Assistant" R18 R4 $tq_on] \
	FLOW_DISABLE_ASSEMBLER					[list $all $all $off "Disable Assembler" R60 R40 $tq_on] \
	ENABLE_RECOVERY_REMOVAL_ANALYSIS		[list $all $all $on $empty R19 R5 $tq_off] \
	FLOW_ENABLE_TIMING_CONSTRAINT_CHECK		[list $all $all $on $empty R20 R6 $tq_off] \
	DO_COMBINED_ANALYSIS					[list $all $all $on $empty R21 R7 $tq_off] \
	REPORT_IO_PATHS_SEPARATELY				[list $all $all $on $empty R22 R8 $tq_off] \
	ENABLE_CLOCK_LATENCY					[list $all $all $on $empty R23 R9 $tq_off] \
	CUT_OFF_IO_PIN_FEEDBACK					[list $all $all $on $empty R61 R41 $tq_off] \
	CUT_OFF_READ_DURING_WRITE_PATHS			[list $all $all $on $empty R61 R41 $tq_off] \
	CUT_OFF_CLEAR_AND_PRESET_PATHS			[list $all $all $on $empty R61 R41 $tq_off] \
	DEFAULT_HOLD_MULTICYCLE					[list $all $all "SAME AS MULTICYCLE" $empty R61 R41 $tq_off] \
	TSU_REQUIREMENT							[list $all $all $empty $empty R62 R42 $tq_off] \
	TCO_REQUIREMENT							[list $all $all $empty $empty R62 R42 $tq_off] \
	TPD_REQUIREMENT							[list $all $all $empty $empty R62 R42 $tq_off] \
	TH_REQUIREMENT							[list $all $all $empty $empty R62 R42 $tq_off] \
	MIN_TCO_REQUIREMENT						[list $all $all $empty $empty R62 R42 $tq_off] \
	MINIMUM_TPD_REQUIREMENT					[list $all $all $empty $empty R62 R42 $tq_off] \
	RESERVE_ALL_UNUSED_PINS					[list $all "$sii $hcii" "AS INPUT TRI-STATED WITH WEAK PULL-UP" $empty R64 R44 $tq_on] \
	RESERVE_ALL_UNUSED_PINS_WEAK_PULLUP			[list $all "$siii $hciii $siv $hciv" "AS INPUT TRI-STATED WITH WEAK PULL-UP" $empty R64 R44 $tq_on] \
	OPTIMIZE_HOLD_TIMING					[list $all $all "ALL PATHS" $empty R65 R45 $tq_on] \
	OPTIMIZE_FAST_CORNER_TIMING				[list $all $all $on $empty R68 R48 $tq_on] \
	TIMEQUEST_MULTICORNER_ANALYSIS			[list $all $all $on $empty R69 R49 $tq_on] \
	FLOW_HARDCOPY_DESIGN_READINESS_CHECK    [list $all $all $on $empty R70 R50 $tq_on] \
	USE_CHECKERED_PATTERN_AS_UNINITIALIZED_RAM_CONTENT    [list $all $all $off $empty $empty $empty $tq_on] \
    STRATIXII_MRAM_COMPATIBILITY            [list $all "$sii $hcii" $off $empty $empty $empty $tq_on] \
    PHYSICAL_SYNTHESIS_EFFORT                       [list $all $siii "FAST" $empty $empty $empty $tq_on] \
    PHYSICAL_SYNTHESIS_COMBO_LOGIC_FOR_AREA         [list $all $all $off $empty $empty $empty $tq_on] \
    PHYSICAL_SYNTHESIS_MAP_LOGIC_TO_MEMORY_FOR_AREA [list $all $all $off $empty $empty $empty $tq_on] \
    PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION [list $all $all $off $empty $empty $empty $tq_on] \
    PHYSICAL_SYNTHESIS_ASYNCHRONOUS_SIGNAL_PIPELINING [list $all $all $off $empty $empty $empty $tq_on] \
    MIGRATION_CONSTRAIN_CORE_RESOURCES      [list $all $all $on $empty $empty $empty $tq_on] \
	OPTIMIZE_SSN							[list $all "$siii" $off $empty $empty $empty $tq_on] \
	EDA_FORMAL_VERIFICATION_TOOL			[list $all "$siii $siv" $none $empty $empty $empty $tq_on] \
\
	]

	variable instance_assignments [list \
\
	CLOCK_ENABLE_MULTICYCLE					[list $all $all $empty $empty R63 R43 $tq_off] \
	CLOCK_ENABLE_MULTICYCLE_HOLD			[list $all $all $empty $empty R63 R43 $tq_off] \
	CLOCK_ENABLE_SOURCE_MULTICYCLE			[list $all $all $empty $empty R63 R43 $tq_off] \
	CLOCK_ENABLE_SOURCE_MULTICYCLE_HOLD		[list $all $all $empty $empty R63 R43 $tq_off] \
	INVERTED_CLOCK							[list $all $all $empty $empty R63 R43 $tq_off] \
	MAX_CLOCK_ARRIVAL_SKEW					[list $all $all $empty $empty R63 R43 $tq_off] \
	MAX_DATA_ARRIVAL_SKEW					[list $all $all $empty $empty R63 R43 $tq_off] \
	MAX_DELAY								[list $all $all $empty $empty R63 R43 $tq_off] \
	MIN_DELAY								[list $all $all $empty $empty R63 R43 $tq_off] \
	MIN_TCO_REQUIREMENT						[list $all $all $empty $empty R63 R43 $tq_off] \
	TCO_REQUIREMENT							[list $all $all $empty $empty R63 R43 $tq_off] \
	TH_REQUIREMENT							[list $all $all $empty $empty R63 R43 $tq_off] \
	TSU_REQUIREMENT							[list $all $all $empty $empty R63 R43 $tq_off] \
	VIRTUAL_CLOCK_REFERENCE					[list $all $all $empty $empty R63 R43 $tq_on] \
	VIRTUAL_PIN								[list $all $all $empty $empty R27 R13 $tq_on] \
	USE_CLK_FOR_VIRTUAL_PIN					[list $all $all $empty $empty R27 R13 $tq_on] \
	STP_VIRTUAL_PIN							[list $all $all $empty $empty R27 R13 $tq_on] \
	STP_VIRTUAL_PIN_CLK_SOURCE				[list $all $all $empty $empty R27 R13 $tq_on] \
	SIGNAL_PROBE_ENABLE				        [list $all $all $empty $empty $empty $empty $tq_on] \
	SIGNAL_PROBE_SOURCE				        [list $all $all $empty $empty $empty $empty $tq_on] \
\
	]

	variable checklist
	array set checklist {}

	namespace export \
	begin \
	end \
	get_assignment \
	is_hardcopyii_first \
	is_check_required_for_hardcopyii \
	is_check_required_for_hardcopyiii \
	is_check_required_for_stratixii \
	is_check_required_for_timequest \
	is_check_required_for_stratixiii \
	is_check_required_for_stratixiv \
	is_check_required_for_hardcopyiv \
	is_global \
	is_instance \
	get_recommendation \
	get_ui_name \
	get_master_rkey \
	get_slave_rkey

	# -------------------------------------------------
	# -------------------------------------------------
	proc initialize {} {
		# Initializes the checklist array if necessary.
	# -------------------------------------------------
	# -------------------------------------------------
		variable global_assignments
		variable instance_assignments
		variable checklist

		if {[array size checklist] == 0} {
				# initialize table
			set i 0
			foreach {j k} $global_assignments {
				set checklist($i) [list $j global $k]
				incr i
			}
			foreach {j k} $instance_assignments {
				set checklist($i) [list $j instance $k]
				incr i
			}
		}
	}

	# -------------------------------------------------
	# -------------------------------------------------
	proc begin {} {
		# Returns the begin iterator.
	# -------------------------------------------------
	# -------------------------------------------------
		initialize
		return 0
	}

	# -------------------------------------------------
	# -------------------------------------------------
	proc end {} { 
		# Returns the end iterator.
	# -------------------------------------------------
	# -------------------------------------------------
		variable checklist
		initialize
		return [array size checklist]
	}

	# -------------------------------------------------
	# -------------------------------------------------
	proc get_assignment {i} {
		# Returns the assignment name.
	# -------------------------------------------------
	# -------------------------------------------------
		variable checklist
		return [lindex $checklist($i) 0] 
	}

	# -------------------------------------------------
	# -------------------------------------------------
	proc is_global {i} {
		# Returns true if it's a global assignment.
	# -------------------------------------------------
	# -------------------------------------------------
		variable checklist
		return [expr {[string compare [lindex $checklist($i) 1] global] == 0}]
	}

	# -------------------------------------------------
	# -------------------------------------------------
	proc is_instance {i} {
		# Returns true if it's an instance assignment.
	# -------------------------------------------------
	# -------------------------------------------------
		variable checklist
		return [expr {[string compare [lindex $checklist($i) 1] instance] == 0}]
	}

	# -------------------------------------------------
	# -------------------------------------------------
	proc is_hardcopyii_first {i} {
		# Returns true if assignment needs to be checked
		# only in the HCII to SII migration flow.
	# -------------------------------------------------
	# -------------------------------------------------
		variable checklist
		variable hcii_to_sii
		return [expr {[string compare [lindex [lindex $checklist($i) 2] 0] $hcii_to_sii] == 0}]
	}

	# -------------------------------------------------
	# -------------------------------------------------
	proc is_check_required_for_hardcopyii {i} {
		# Returns true if assignment needs to
		# be checked for HardCopy II revision.
	# -------------------------------------------------
	# -------------------------------------------------
		variable checklist
		variable all
		variable hcii
		set device_family [lindex [lindex $checklist($i) 2] 1]
		return [expr {[string compare $device_family $all] == 0 || [string compare $device_family $hcii] == 0 || [lsearch $device_family $hcii] != -1}]
	}

	# -------------------------------------------------
	# -------------------------------------------------
	proc is_check_required_for_hardcopyiii {i} {
		# Returns true if assignment needs to
		# be checked for HardCopy III revision.
	# -------------------------------------------------
	# -------------------------------------------------
		variable checklist
		variable all
		variable hciii
		set device_family [lindex [lindex $checklist($i) 2] 1]
		return [expr {[string compare $device_family $all] == 0 || [string compare $device_family $hciii] == 0 || [lsearch $device_family $hciii] != -1}]
	}

	# -------------------------------------------------
	# -------------------------------------------------
	proc is_check_required_for_hardcopyiv {i} {
		# Returns true if assignment needs to
		# be checked for HardCopy IV revision.
	# -------------------------------------------------
	# -------------------------------------------------
		variable checklist
		variable all
		variable hciv
		set device_family [lindex [lindex $checklist($i) 2] 1]
		return [expr {[string compare $device_family $all] == 0 || [string compare $device_family $hciv] == 0 || [lsearch $device_family $hciv] != -1}]
	}


	# -------------------------------------------------
	# -------------------------------------------------
	proc is_check_required_for_stratixii {i} {
		# Returns true if assignment needs to
		# be checked for Stratix II revision.
	# -------------------------------------------------
	# -------------------------------------------------
		variable checklist
		variable all
		variable sii
		set device_family [lindex [lindex $checklist($i) 2] 1]
		return [expr {[string compare $device_family $all] == 0 || [string compare $device_family $sii] == 0 || [lsearch $device_family $sii] != -1}]
	}

	# -------------------------------------------------
	# -------------------------------------------------
	proc is_check_required_for_stratixiii {i} {
		# Returns true if assignment needs to
		# be checked for Stratix III revision.
	# -------------------------------------------------
	# -------------------------------------------------
		variable checklist
		variable all
		variable siii
		set device_family [lindex [lindex $checklist($i) 2] 1]
		return [expr {[string compare $device_family $all] == 0 || [string compare $device_family $siii] == 0 || [lsearch $device_family $siii] != -1}]
	}

	# -------------------------------------------------
	# -------------------------------------------------
	proc is_check_required_for_stratixiv {i} {
		# Returns true if assignment needs to
		# be checked for Stratix IV revision.
	# -------------------------------------------------
	# -------------------------------------------------
		variable checklist
		variable all
		variable siv
		set device_family [lindex [lindex $checklist($i) 2] 1]
		return [expr {[string compare $device_family $all] == 0 || [string compare $device_family $siv] == 0 || [lsearch $device_family $siv] != -1}]
	}

	# -------------------------------------------------
	# -------------------------------------------------
	proc is_check_required_for_timequest {i} {
		# Returns 1, if enabled for TQ;
		# 0, otherwise.
	# -------------------------------------------------
	# -------------------------------------------------
		variable checklist
		return [lindex [lindex $checklist($i) 2] 6]
	}

	# -------------------------------------------------
	# -------------------------------------------------
	proc get_recommendation {i} {
		# Returns the recommended value for the
		# assignment.
	# -------------------------------------------------
	# -------------------------------------------------
		variable checklist
		return [lindex [lindex $checklist($i) 2] 2]
	}

	# -------------------------------------------------
	# -------------------------------------------------
	proc get_ui_name {i} {
		# Returns the special UI name for
		# the assignment.
	# -------------------------------------------------
	# -------------------------------------------------
		variable checklist
		return [lindex [lindex $checklist($i) 2] 3]
	}

	# -------------------------------------------------
	# -------------------------------------------------
	proc get_master_rkey {i} {
		# Returns the master recommendation key for
		# the assignment.
	# -------------------------------------------------
	# -------------------------------------------------
		variable checklist
		return [lindex [lindex $checklist($i) 2] 4]
	}

	# -------------------------------------------------
	# -------------------------------------------------
	proc get_slave_rkey {i} {
		# Returns the slave recommendation key for
		# the assignment.
	# -------------------------------------------------
	# -------------------------------------------------
		variable checklist
		return [lindex [lindex $checklist($i) 2] 5]
	}
}
