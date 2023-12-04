# *************************************************************
#
# Filename:    HARDCOPY_MSGS.TCL
#
# Description: Provides an interface to post messages
#              for hardcopy Tcl scripts.
#
#              Copyright (c) Altera Corporation 1997 - 2009
#              All rights reserved.
#
# *************************************************************


# ---------------------------------------------------------------------------
#
namespace eval hardcopy_msgs {
#
# Description:	Define the namespace.
#
# Warning:		All defined variables should not be accessed.
#				Use defined accessors instead.
#
# ---------------------------------------------------------------------------

		# Map of message handles
	variable msgs
	array set msgs {}
		# Handle -> <help id> <formatted message> <raw message> <expected number of arguments>
	set msgs(E_CANNOT_FIND_DIRECTORY) [list EHARDCOPY_CANNOT_FIND_DIRECTORY "Cannot find specified directory: %s" "Cannot find specified directory: %1!s!" 1]
	set msgs(E_CANNOT_OPEN_FILE) [list EHARDCOPY_CANNOT_OPEN_FILE "Cannot open file %s" "Cannot open file %1!s!" 1]
	set msgs(E_GENERATE_HC_PLL_DELAY_HELP) [list EHARDCOPY_GENERATE_HC_PLL_DELAY_HELP "For more details, use \\\"quartus_cdb --help=generate_hc_pll_delay\\\"" "For more details, use \\\"quartus_cdb --help=generate_hc_pll_delay\\\"" 0]
	set msgs(E_HC_READY_HELP) [list EHARDCOPY_HC_READY_HELP "The HardCopy Design Readiness Check was not performed" "The HardCopy Design Readiness Check was not performed" 0]
	set msgs(E_HC_READY_ILLEGAL_PART_NAME) [list EHARDCOPY_HC_READY_ILLEGAL_PART_NAME "Target device %s is invalid -- specify a target device that belongs to the %s device family for the revision \\\"%s\\\"" "Target device %1!s! is invalid -- specify a target device that belongs to the %2!s! device family for the revision \\\"%3!s!\\\"" 3]
	set msgs(E_HC_READY_NOT_SUPPORTED_FAMILY) [list EHARDCOPY_HC_READY_NOT_SUPPORTED_FAMILY "Family \\\"%s\\\" is not supported by the HardCopy Design Readiness Check" "Family \\\"%1!s!\\\" is not supported by the HardCopy Design Readiness Check" 1]
	set msgs(E_HC_READY_NO_FULL_COMPILE) [list EHARDCOPY_HC_READY_NO_FULL_COMPILE "Run Fitter (quartus_fit) on revision %s before running the HardCopy Design Readiness Check" "Run Fitter (quartus_fit) on revision %1!s! before running the HardCopy Design Readiness Check" 1]
	set msgs(E_HC_READY_NO_MAP) [list EHARDCOPY_HC_READY_NO_MAP "Perform Analysis and Synthesis before performing the HardCopy Design Readiness Check" "Perform Analysis and Synthesis before performing the HardCopy Design Readiness Check" 0]
	set msgs(E_ILLEGAL_CHARACTER) [list EHARDCOPY_ILLEGAL_CHARACTER "Revision name contains illegal character %s" "Revision name contains illegal character %1!s!" 1]
	set msgs(E_ILLEGAL_FAMILY_NAME) [list EHARDCOPY_ILLEGAL_FAMILY_NAME "Device family \\\"%s\\\" is invalid -- specify a valid device family name" "Device family \\\"%1!s!\\\" is invalid -- specify a valid device family name" 1]
	set msgs(E_ILLEGAL_HC_COMPANION_DEVICE) [list EHARDCOPY_ILLEGAL_HC_COMPANION_DEVICE "The selected HardCopy companion device %s is not supported for HardCopy Migration." "The selected HardCopy companion device %1!s! is not supported for HardCopy Migration." 1]
	set msgs(E_ILLEGAL_MIG_DEVICE) [list EHARDCOPY_ILLEGAL_MIG_DEVICE "Invalid DEVICE_TECHNOLOGY_MIGRATION_LIST: %s" "Invalid DEVICE_TECHNOLOGY_MIGRATION_LIST: %1!s!" 1]
	set msgs(E_ILLEGAL_NODE_TYPE) [list EHARDCOPY_ILLEGAL_NODE_TYPE "The %s node is not a legal node type" "The %1!s! node is not a legal node type" 1]
	set msgs(E_ILLEGAL_SOURCE_DEVICE) [list EHARDCOPY_ILLEGAL_SOURCE_DEVICE "Source device %s is not valid -- make sure you select a valid device" "Source device %1!s! is not valid -- make sure you select a valid device" 1]
	set msgs(E_ILLEGAL_SOURCE_FAMILY) [list EHARDCOPY_ILLEGAL_SOURCE_FAMILY "Source device %s is not supported -- make sure that the device is either a Stratix II/Stratix III/Stratix IVE or HardCopy II/HardCopy III/HardCopy IVE device" "Source device %1!s! is not supported -- make sure that the device is either a Stratix II/Stratix III/Stratix IVE or HardCopy II/HardCopy III/HardCopy IVE device" 1]
	set msgs(E_MISSING_ENCRYPTED_SOURCE_FILE) [list EHARDCOPY_MISSING_ENCRYPTED_SOURCE_FILE "Can't generate programming files for the project because the encrypted source file cannot be located: \\\"%s\\\"" "Can't generate programming files for the project because the encrypted source file cannot be located: \\\"%1!s!\\\"" 1]
	set msgs(E_MUST_USE_TIMEQUEST) [list EHARDCOPY_MUST_USE_TIMEQUEST "TimeQuest Timing Analyzer must be turned ON for designs that require HardCopy migration or compilation." "TimeQuest Timing Analyzer must be turned ON for designs that require HardCopy migration or compilation." 0]
	set msgs(E_NETLIST_UNAVAILABLE) [list EHARDCOPY_NETLIST_UNAVAILABLE "Cannot retrieve information from the netlist" "Cannot retrieve information from the netlist" 0]
	set msgs(E_NO_COPY_DEST_DIRECTORY) [list EHARDCOPY_NO_COPY_DEST_DIRECTORY "Couldn't copy \\\"%s\\\" to \\\"%s\\\" because the destination file is an existing directory" "Couldn't copy \\\"%1!s!\\\" to \\\"%2!s!\\\" because the destination file is an existing directory" 2]
	set msgs(E_NO_COPY_PERMISSION) [list EHARDCOPY_NO_COPY_PERMISSION "Couldn't copy \\\"%s\\\" to \\\"%s\\\" -- make sure you have permission to write to the destination file" "Couldn't copy \\\"%1!s!\\\" to \\\"%2!s!\\\" -- make sure you have permission to write to the destination file" 2]
	set msgs(E_NO_COPY_SRC_DIRECTORY) [list EHARDCOPY_NO_COPY_SRC_DIRECTORY "Couldn't copy \\\"%s\\\" to \\\"%s\\\" because the source file has the same name as a directory" "Couldn't copy \\\"%1!s!\\\" to \\\"%2!s!\\\" because the source file has the same name as a directory" 2]
	set msgs(E_NO_LICENSE_FOR_ENCRYPTED_FILE) [list EHARDCOPY_NO_LICENSE_FOR_ENCRYPTED_FILE "Can't generate programming files for project because design file \\\"%s\\\" is encrypted. It does not have license file support that allows generation of programming files." "Can't generate programming files for project because design file \\\"%1!s!\\\" is encrypted. It does not have license file support that allows generation of programming files." 1]
	set msgs(E_NO_OPENCORE_PLUS_IN_HARDCOPY) [list EHARDCOPY_NO_OPENCORE_PLUS_IN_HARDCOPY "Current device family does not support OpenCore Plus IP cores" "Current device family does not support OpenCore Plus IP cores" 0]
	set msgs(E_NO_REPORT_DB) [list EHARDCOPY_NO_REPORT_DB "Report database is not loaded" "Report database is not loaded" 0]
	set msgs(E_ONLY_SUPPORT_STRATIX_AND_HARDCOPY) [list EHARDCOPY_ONLY_SUPPORT_STRATIX_AND_HARDCOPY "Feature is available only when the device of the current revision is either a HardCopy II/HardCopy III/HardCopy IVE or Stratix II/Stratix III/Stratix IVE device" "Feature is available only when the device of the current revision is either a HardCopy II/HardCopy III/HardCopy IVE or Stratix II/Stratix III/Stratix IVE device" 0]
	set msgs(E_OVERRIDE_REVISION_FAILED) [list EHARDCOPY_OVERRIDE_REVISION_FAILED "Failed in overwriting existing target revision named %s" "Failed in overwriting existing target revision named %1!s!" 1]
	set msgs(E_PAD_HAS_NO_MCF_NAME) [list EHARDCOPY_PAD_HAS_NO_MCF_NAME "Pad has no MCF name" "Pad has no MCF name" 0]
	set msgs(E_PLL_DELAY_NOT_SUPPORTED_FAMILY) [list EHARDCOPY_PLL_DELAY_NOT_SUPPORTED_FAMILY "Family \\\"%s\\\" is not supported in generating pll annotated delay." "Family \\\"%1!s!\\\" is not supported in generating pll annotated delay." 1]
	set msgs(E_PROJECT_DOES_NOT_EXIST) [list EHARDCOPY_PROJECT_DOES_NOT_EXIST "Project does not exist.  Check the project name again." "Project does not exist.  Check the project name again." 0]
	set msgs(E_PROJECT_IS_NOT_OPEN) [list EHARDCOPY_PROJECT_IS_NOT_OPEN "No open project found" "No open project found" 0]
	set msgs(E_REVISION_DOES_NOT_EXIST) [list EHARDCOPY_REVISION_DOES_NOT_EXIST "Revision specified does not exist.  Check the revision name again." "Revision specified does not exist.  Check the revision name again." 0]
	set msgs(E_REVISION_NOT_SUPPORTED) [list EHARDCOPY_REVISION_NOT_SUPPORTED "Device family \\\"%s\\\" not supported.  Run this check only on FPGA revision." "Device family \\\"%1!s!\\\" not supported.  Run this check only on FPGA revision." 1]
	set msgs(E_RUN_SUCCESSFUL_FIT_BEFORE_HC_READY) [list EHARDCOPY_RUN_SUCCESSFUL_FIT_BEFORE_HC_READY "Run the Fitter (quartus_fit) successfully on revision %s before running the HardCopy Design Readiness Check" "Run the Fitter (quartus_fit) successfully on revision %1!s! before running the HardCopy Design Readiness Check" 1]
	set msgs(E_RUN_TIMEQUEST) [list EHARDCOPY_RUN_TIMEQUEST "Run TimeQuest Timing Analyzer before running the current option" "Run TimeQuest Timing Analyzer before running the current option" 0]
	set msgs(E_SAME_REVISION) [list EHARDCOPY_SAME_REVISION "COMPANION_REVISION_NAME cannot be the same as the current revision name" "COMPANION_REVISION_NAME cannot be the same as the current revision name" 0]
	set msgs(E_SRC_FILE_MISSING) [list EHARDCOPY_SRC_FILE_MISSING "Could not copy \\\"%s\\\" to \\\"%s\\\" because the source file does not exist" "Could not copy \\\"%1!s!\\\" to \\\"%2!s!\\\" because the source file does not exist" 2]
	set msgs(E_TURN_OFF_QIC) [list EHARDCOPY_TURN_OFF_QIC "Cannot migrate project with Incremental Compilation enabled -- turn Incremental Compilation off and then recompile before performing migration." "Cannot migrate project with Incremental Compilation enabled -- turn Incremental Compilation off and then recompile before performing migration." 0]
	set msgs(E_UNDEFINED_MIG_DEVICE) [list EHARDCOPY_UNDEFINED_MIG_DEVICE "Your current revision has DEVICE_TECHNOLOGY_MIGRATION_LIST undefined -- make sure you select a valid migration device" "Your current revision has DEVICE_TECHNOLOGY_MIGRATION_LIST undefined -- make sure you select a valid migration device" 0]
	set msgs(E_UNDEF_MSG_NAME) [list EHARDCOPY_UNDEF_MSG_NAME "Message: %s is undefined" "Message: %1!s! is undefined" 1]
	set msgs(E_UNKNOWN_ATOM_TYPE) [list EHARDCOPY_UNKNOWN_ATOM_TYPE "Unknown atom type: %s" "Unknown atom type: %1!s!" 1]
	set msgs(E_UNSUPPORTED_COLLECTION_OPTION) [list EHARDCOPY_UNSUPPORTED_COLLECTION_OPTION "The specified collection type: %s is not supported" "The specified collection type: %1!s! is not supported" 1]
	set msgs(E_WRONG_FAMILY_MIG_DEVICE) [list EHARDCOPY_WRONG_FAMILY_MIG_DEVICE "Your current revision has DEVICE_TECHNOLOGY_MIGRATION_LIST set to %s which does not belong to the %s device family" "Your current revision has DEVICE_TECHNOLOGY_MIGRATION_LIST set to %1!s! which does not belong to the %2!s! device family" 2]
	set msgs(E_WRONG_STRING_LIST_OBJECT_TYPE) [list EHARDCOPY_WRONG_STRING_LIST_OBJECT_TYPE "Object is a string list" "Object is a string list" 0]
	set msgs(E_WRONG_STRING_OBJECT_TYPE) [list EHARDCOPY_WRONG_STRING_OBJECT_TYPE "Object: %s, is a string" "Object: %1!s!, is a string" 1]
	set msgs(E_WRONG_TIME_UNIT) [list EHARDCOPY_WRONG_TIME_UNIT "Unexpected time unit specified in %s" "Unexpected time unit specified in %1!s!" 1]
	set msgs(E_ZERO_SIZE_COLLECTION) [list EHARDCOPY_ZERO_SIZE_COLLECTION "The size of the list of passed PrimeTime names is 0 and Primetime cannot create a collection" "The size of the list of passed PrimeTime names is 0 and Primetime cannot create a collection" 0]
	set msgs(I_ALL_CLOCKS_RELATED) [list IHARDCOPY_ALL_CLOCKS_RELATED "All the clocks are related. There are no false path constraints generated between clock domains." "All the clocks are related. There are no false path constraints generated between clock domains." 0]
	set msgs(I_CHECK_REVISION) [list IHARDCOPY_CHECK_REVISION "Check revision \\\"%s\\\" for MIF dependency on uninitialized RAM content." "Check revision \\\"%1!s!\\\" for MIF dependency on uninitialized RAM content." 1]
	set msgs(I_CONVERT_DEFAULT_Q_ASGN) [list IHARDCOPY_CONVERT_DEFAULT_Q_ASGN "Corresponding assignment %s is not set. Therefore, the value from %s assignment is used." "Corresponding assignment %1!s! is not set. Therefore, the value from %2!s! assignment is used." 2]
	set msgs(I_CONVERT_Q_ASGN) [list IHARDCOPY_CONVERT_Q_ASGN "Converting assignment %s (%s)" "Converting assignment %1!s! (%2!s!)" 2]
	set msgs(I_COPIED_FILE) [list IHARDCOPY_COPIED_FILE "Copied \\\"%s\\\" to \\\"%s\\\"" "Copied \\\"%1!s!\\\" to \\\"%2!s!\\\"" 2]
	set msgs(I_COPIED_FILE_GENERIC) [list IHARDCOPY_COPIED_FILE_GENERIC "Copied \\\"%s\\\" to \\\"%s\\\"" "Copied \\\"%1!s!\\\" to \\\"%2!s!\\\"" 2]
	set msgs(I_CORE_VOLTAGE_DIFFERENCE) [list IHARDCOPY_CORE_VOLTAGE_DIFFERENCE "Board design should provide VCC voltage level for both 0.9V and %s to support HardCopy III and Stratix III devices" "Board design should provide VCC voltage level for both 0.9V and %1!s! to support HardCopy III and Stratix III devices" 1]
	set msgs(I_CUT_OFF_FROM) [list IHARDCOPY_CUT_OFF_FROM "The CUT = OFF -from %s will not be translated as it has already been accounted for in Quartus II." "The CUT = OFF -from %1!s! will not be translated as it has already been accounted for in Quartus II." 1]
	set msgs(I_CUT_OFF_FROM_TO) [list IHARDCOPY_CUT_OFF_FROM_TO "Assignment CUT=OFF from %s to %s will not be translated" "Assignment CUT=OFF from %1!s! to %2!s! will not be translated" 2]
	set msgs(I_CUT_OFF_TO) [list IHARDCOPY_CUT_OFF_TO "The CUT = OFF -to %s will not be translated as it has already been accounted for in Quartus II." "The CUT = OFF -to %1!s! will not be translated as it has already been accounted for in Quartus II." 1]
	set msgs(I_CUT_PATH_BETWEEN_CLK_DOMAIN_OFF) [list IHARDCOPY_CUT_PATH_BETWEEN_CLK_DOMAIN_OFF "Assignment cut_off_paths_between_clock_domains is set to off. No clock groups are generated." "Assignment cut_off_paths_between_clock_domains is set to off. No clock groups are generated." 0]
	set msgs(I_DELETE_CHECKERED) [list IHARDCOPY_DELETE_CHECKERED "Deleting checkered revision and its files." "Deleting checkered revision and its files." 0]
	set msgs(I_FAIL_TO_CONVERT_Q_ASGN) [list IHARDCOPY_FAIL_TO_CONVERT_Q_ASGN "Failed to convert assignment %s (%s)" "Failed to convert assignment %1!s! (%2!s!)" 2]
	set msgs(I_GENERATING_CHECKSUMS) [list IHARDCOPY_GENERATING_CHECKSUMS "Generating file checksum values" "Generating file checksum values" 0]
	set msgs(I_GOT_MIF) [list IHARDCOPY_GOT_MIF "All RAM blocks have a corresponding Memory Initialization File.  Skipping checkerboard pattern check." "All RAM blocks have a corresponding Memory Initialization File.  Skipping checkerboard pattern check." 0]
	set msgs(I_HC_READY_NO_FULL_COMPILE) [list IHARDCOPY_HC_READY_NO_FULL_COMPILE   "Full compilation was not performed. The HardCopy Design Readiness Check report cannot display default value information." "Full compilation was not performed. The HardCopy Design Readiness Check report cannot display default value information." 0]
	set msgs(I_IMPORTANT_MESSAGE_GENERATED) [list IHARDCOPY_IMPORTANT_MESSAGE_GENERATED "%s important information messages generated" "%1!s! important information messages generated" 1]
	set msgs(I_IOBANK_NO_SUPPORTED_PART) [list IHARDCOPY_IOBANK_NO_SUPPORTED_PART "Device %s doesn't has IO Bank %s, so the %s assignment with value %s can not be migrated" "Device %1!s! doesn't has IO Bank %2!s!, so the %3!s! assignment with value %4!s! can not be migrated" 4]
	set msgs(I_IOC_REG) [list IHARDCOPY_IOC_REG "Register %s is moved to I/O cell %s in the Quartus II software" "Register %1!s! is moved to I/O cell %2!s! in the Quartus II software" 2]
	set msgs(I_MIGRATING_BACK_ANNOTATION) [list IHARDCOPY_MIGRATING_BACK_ANNOTATION "Migrating back-annotated assignments" "Migrating back-annotated assignments" 0]
	set msgs(I_MIGRATING_GLOBAL) [list IHARDCOPY_MIGRATING_GLOBAL "Migrating global assignments" "Migrating global assignments" 0]
	set msgs(I_MIGRATING_INSTANCE) [list IHARDCOPY_MIGRATING_INSTANCE "Migrating instance assignments" "Migrating instance assignments" 0]
	set msgs(I_MIGRATING_PARAMETER) [list IHARDCOPY_MIGRATING_PARAMETER "Migrating user parameters" "Migrating user parameters" 0]
	set msgs(I_MIGRATING_PIN_LOCATION) [list IHARDCOPY_MIGRATING_PIN_LOCATION "Migrating pin assignments" "Migrating pin assignments" 0]
	set msgs(I_NO_BLOCK_TYPE_NODE) [list IHARDCOPY_NO_BLOCK_TYPE_NODE "No %s is found in the design" "No %1!s! is found in the design" 1]
	set msgs(I_NO_CLK_IN_INPUT_DELAY) [list IHARDCOPY_NO_CLK_IN_INPUT_DELAY "Destination of assignment may contain clock(s). set_input_delay command is not allowed to set on clock port(s) %s." "Destination of assignment may contain clock(s). set_input_delay command is not allowed to set on clock port(s) %1!s!." 1]
	set msgs(I_NO_CLK_IN_TAN_RPT) [list IHARDCOPY_NO_CLK_IN_TAN_RPT "No clocks were found in the Quartus II Classic Timing Analyzer report" "No clocks were found in the Quartus II Classic Timing Analyzer report" 0]
	set msgs(I_NO_EXTRA_REVISION) [list IHARDCOPY_NO_EXTRA_REVISION "No extra revision to be removed." "No extra revision to be removed." 0]
	set msgs(I_NO_PINS) [list IHARDCOPY_NO_PINS "Can't find any pins" "Can't find any pins" 0]
	set msgs(I_NO_RAMS) [list IHARDCOPY_NO_RAMS "Design has no M4K memory block or M512 memory block.  Skipping checkerboard pattern check." "Design has no M4K memory block or M512 memory block.  Skipping checkerboard pattern check." 0]
	set msgs(I_NO_RAM_HAVE_MIF) [list IHARDCOPY_NO_RAM_HAVE_MIF "No RAM is associated with Memory Initialization File" "No RAM is associated with Memory Initialization File" 0]
	set msgs(I_OPEN_FILE) [list IHARDCOPY_OPEN_FILE "Opening file %s for output" "Opening file %1!s! for output" 1]
	set msgs(I_OVERRIDE_REVISION) [list IHARDCOPY_OVERRIDE_REVISION "Overwriting existing target revision named %s" "Overwriting existing target revision named %1!s!" 1]
	set msgs(I_PLL_NO_COMPENSATION) [list IHARDCOPY_PLL_NO_COMPENSATION "%s PLL(s) is operating in a no compensation mode" "%1!s! PLL(s) is operating in a no compensation mode" 1]
	set msgs(I_READ_BACK_ANNOTATION) [list IHARDCOPY_READ_BACK_ANNOTATION "Reading assignments from back-annotation" "Reading assignments from back-annotation" 0]
	set msgs(I_READ_PIN_LOCATIONS) [list IHARDCOPY_READ_PIN_LOCATIONS "Reading pin locations from compilation database" "Reading pin locations from compilation database" 0]
	set msgs(I_READ_QSF) [list IHARDCOPY_READ_QSF "Reading Quartus II Settings File assignments" "Reading Quartus II Settings File assignments" 0]
	set msgs(I_RUN_EXE_TO_GENERATE_FILE) [list IHARDCOPY_RUN_EXE_TO_GENERATE_FILE "Run the Quartus II command-line executable %s to generate the file" "Run the Quartus II command-line executable %1!s! to generate the file" 1]
	set msgs(I_SCRIPT) [list IHARDCOPY_SCRIPT "Using Script \\\"%s\\\"" "Using Script \\\"%1!s!\\\"" 1]
	set msgs(I_SEPARATOR) [list IHARDCOPY_SEPARATOR "----------------------------------------------------------" "----------------------------------------------------------" 0]
	set msgs(I_SKIPPING_BACK_ANNOTATION) [list IHARDCOPY_SKIPPING_BACK_ANNOTATION "Skipping resource back-annoation because INI hcii_migration_dont_use_asl=on" "Skipping resource back-annoation because INI hcii_migration_dont_use_asl=on" 0]
	set msgs(I_SKIPPING_GLOBAL) [list IHARDCOPY_SKIPPING_GLOBAL "Not migrating global assignment named %s" "Not migrating global assignment named %1!s!" 1]
	set msgs(I_SKIPPING_INSTANCE) [list IHARDCOPY_SKIPPING_INSTANCE "Not migrating instance assignment named %s" "Not migrating instance assignment named %1!s!" 1]
	set msgs(I_SOURCE_DEVICE) [list IHARDCOPY_SOURCE_DEVICE "Source device: %s" "Source device: %1!s!" 1]
	set msgs(I_SOURCE_FAMILY) [list IHARDCOPY_SOURCE_FAMILY "Source family: %s" "Source family: %1!s!" 1]
	set msgs(I_SOURCE_REVISION) [list IHARDCOPY_SOURCE_REVISION "Using source revision named %s" "Using source revision named %1!s!" 1]
	set msgs(I_TARGET_DEVICE) [list IHARDCOPY_TARGET_DEVICE "Target device: %s" "Target device: %1!s!" 1]
	set msgs(I_TARGET_FAMILY) [list IHARDCOPY_TARGET_FAMILY "Target family: %s" "Target family: %1!s!" 1]
	set msgs(I_TARGET_REVISION) [list IHARDCOPY_TARGET_REVISION "Using target revision named %s" "Using target revision named %1!s!" 1]
	set msgs(I_UPDATE_CORE_MAX_JUNCTION_TEMP) [list IHARDCOPY_UPDATE_CORE_MAX_JUNCTION_TEMP "Family %s does not support %s MAX_CORE_JUNCTION_TEMP, change the value to 85 Degree Celcius." "Family %1!s! does not support %2!s! MAX_CORE_JUNCTION_TEMP, change the value to 85 Degree Celcius." 2]
	set msgs(I_UPDATE_CORE_MIN_JUNCTION_TEMP) [list IHARDCOPY_UPDATE_CORE_MIN_JUNCTION_TEMP "Family %s does not support %s MIN_CORE_JUNCTION_TEMP, change the value to 0 Degree Celcius." "Family %1!s! does not support %2!s! MIN_CORE_JUNCTION_TEMP, change the value to 0 Degree Celcius." 2]
	set msgs(W_BASE_CLK_ID_NAME_CNT_NOT_EQUAL) [list WHARDCOPY_BASE_CLK_ID_NAME_CNT_NOT_EQUAL "Number of base clock names are not equal to that of the base clock IDs" "Number of base clock names are not equal to that of the base clock IDs" 0]
	set msgs(W_CANNOT_CONVERT_ASGN) [list WHARDCOPY_CANNOT_CONVERT_ASGN "Cannot convert the Quartus II assignment" "Cannot convert the Quartus II assignment" 0]
	set msgs(W_CANNOT_CONVERT_CLK) [list WHARDCOPY_CANNOT_CONVERT_CLK "Cannot convert the Quartus II clock" "Cannot convert the Quartus II clock" 0]
	set msgs(W_CANNOT_FIND_BASE_CLK) [list WHARDCOPY_CANNOT_FIND_BASE_CLK "Cannot find a base clock for derived clock" "Cannot find a base clock for derived clock" 0]
	set msgs(W_CANNOT_OPEN_CLK_FILE) [list WHARDCOPY_CANNOT_OPEN_CLK_FILE "The %s file does not exist; therefore the clock conversion is not implemented" "The %1!s! file does not exist; therefore the clock conversion is not implemented" 1]
	set msgs(W_CANNOT_OPEN_COL_FILE) [list WHARDCOPY_CANNOT_OPEN_COL_FILE "The %s file does not exist; therefore the collection conversion is not implemented" "The %1!s! file does not exist; therefore the collection conversion is not implemented" 1]
	set msgs(W_CANNOT_OPEN_TA_FILE) [list WHARDCOPY_CANNOT_OPEN_TA_FILE "The %s file does not exist; therefore the tan assignment conversion is not implemented" "The %1!s! file does not exist; therefore the tan assignment conversion is not implemented" 1]
	set msgs(W_CLKS_P_NAME_NOT_FOUND) [list WHARDCOPY_CLKS_P_NAME_NOT_FOUND "Cannot find the corresponding PrimeTime name of the Quartus II clock %s" "Cannot find the corresponding PrimeTime name of the Quartus II clock %1!s!" 1]
	set msgs(W_CLKS_Q_NAME_NO_FOUND) [list WHARDCOPY_CLKS_Q_NAME_NO_FOUND "Cannot find the corresponding Quartus II name of the specified %s ID %s" "Cannot find the corresponding Quartus II name of the specified %1!s! ID %2!s!" 2]
	set msgs(W_CLK_ID_NAME_MISMATCH) [list WHARDCOPY_CLK_ID_NAME_MISMATCH "The name of %s ID %s should be %s, not %s" "The name of %1!s! ID %2!s! should be %3!s!, not %4!s!" 4]
	set msgs(W_CLOCK_NOT_ON_DEDICATED_PAD) [list WHARDCOPY_CLOCK_NOT_ON_DEDICATED_PAD "%s pin(s) drive global or regional clock, but are not placed in a dedicated clock pin position. Clock insertion delay will be different between FPGA and HardCopy companion revisions because of differences in local routing interconnect delays." "%1!s! pin(s) drive global or regional clock, but are not placed in a dedicated clock pin position. Clock insertion delay will be different between FPGA and HardCopy companion revisions because of differences in local routing interconnect delays." 1]
	set msgs(W_DEST_FILE_EXISTS) [list WHARDCOPY_DEST_FILE_EXISTS "Not copying \\\"%s\\\" to \\\"%s\\\" because the destination file already exists" "Not copying \\\"%1!s!\\\" to \\\"%2!s!\\\" because the destination file already exists" 2]
	set msgs(W_EMBEDDED_REG_SHOULD_MAP_TO_PIN) [list WHARDCOPY_EMBEDDED_REG_SHOULD_MAP_TO_PIN "Quartus II register %s should be mapped to PrimeTime pin %s" "Quartus II register %1!s! should be mapped to PrimeTime pin %2!s!" 2]
	set msgs(W_EMPTY_CLK_GROUP) [list WHARDCOPY_EMPTY_CLK_GROUP "Cannot find a corresponding PrimeTime clock for the clock group from the Quartus II base clock setting %s" "Cannot find a corresponding PrimeTime clock for the clock group from the Quartus II base clock setting %1!s!" 1]
	set msgs(W_EMPTY_OBJECT) [list WHARDCOPY_EMPTY_OBJECT "Found an empty object" "Found an empty object" 0]
	set msgs(W_EVALUATION_FAILED) [list WHARDCOPY_EVALUATION_FAILED "Unable to retrieve %s information" "Unable to retrieve %1!s! information" 1]
	set msgs(W_FAIL_BACK_ANNOTATION) [list WHARDCOPY_FAIL_BACK_ANNOTATION "Resource allocation cannot be back annotated -- a successful full compile is required" "Resource allocation cannot be back annotated -- a successful full compile is required" 0]
	set msgs(W_FAIL_RESOURCE_ALLCATION) [list WHARDCOPY_FAIL_RESOURCE_ALLCATION "Resource allocation cannot be migrated from the compiled database" "Resource allocation cannot be migrated from the compiled database" 0]
	set msgs(W_HC_NAME_NOT_CONVERTIBLE) [list WHARDCOPY_HC_NAME_NOT_CONVERTIBLE "Cannot convert the corresponding Quartus name of specified name ID %s to HardCopy name." "Cannot convert the corresponding Quartus name of specified name ID %1!s! to HardCopy name." 1]
	set msgs(W_INVALID_BASE_CLOCK) [list WHARDCOPY_INVALID_BASE_CLOCK "Base clock %s is not a valid clock" "Base clock %1!s! is not a valid clock" 1]
	set msgs(W_LIMITED_SUPPORT_OF_CUT) [list WHARDCOPY_LIMITED_SUPPORT_OF_CUT "Converting a Quartus II single-point Cut Timing Path assignment on a non-keeper node to PrimeTime set_false_path is not supported" "Converting a Quartus II single-point Cut Timing Path assignment on a non-keeper node to PrimeTime set_false_path is not supported" 0]
	set msgs(W_MULTI_BASE_CLK) [list WHARDCOPY_MULTI_BASE_CLK "Multiple base clocks are specified. All but the first base clock will be ignored." "Multiple base clocks are specified. All but the first base clock will be ignored." 0]
	set msgs(W_MULTI_HOLD_MC_ASGN) [list WHARDCOPY_MULTI_HOLD_MC_ASGN "Both Hold Multicycle and Source Hold Multicycle assignments are specified" "Both Hold Multicycle and Source Hold Multicycle assignments are specified" 0]
	set msgs(W_MULTI_MC_ASGN) [list WHARDCOPY_MULTI_MC_ASGN "Both Multicycle and Source Multicycle assignments are specified" "Both Multicycle and Source Multicycle assignments are specified" 0]
	set msgs(W_NOT_COMPILED) [list WHARDCOPY_NOT_COMPILED "Revision %s has not been compiled" "Revision %1!s! has not been compiled" 1]
	set msgs(W_NOT_COMPILED_WITH_FAMILY) [list WHARDCOPY_NOT_COMPILED_WITH_FAMILY "Revision %s has not been compiled for device family %s" "Revision %1!s! has not been compiled for device family %2!s!" 2]
	set msgs(W_NO_CLOCKS_DEFINED) [list WHARDCOPY_NO_CLOCKS_DEFINED "No clocks are defined" "No clocks are defined" 0]
	set msgs(W_NO_CLOCK_CONSTRAINT) [list WHARDCOPY_NO_CLOCK_CONSTRAINT "Clock %s is not constrained" "Clock %1!s! is not constrained" 1]
	set msgs(W_NO_IO_ASSIGNMENT) [list WHARDCOPY_NO_IO_ASSIGNMENT "%s pin(s) have no explicit %s assignments provided in the Quartus II Settings File. Add a specific %s assignment for these pins." "%1!s! pin(s) have no explicit %2!s! assignments provided in the Quartus II Settings File. Add a specific %3!s! assignment for these pins." 3]
	set msgs(W_NO_LOCATION_ASSIGNMENT) [list WHARDCOPY_NO_LOCATION_ASSIGNMENT "%s pin(s) do not have location assignments" "%1!s! pin(s) do not have location assignments" 1]
	set msgs(W_NO_PLL_RECONFIGURATION) [list WHARDCOPY_NO_PLL_RECONFIGURATION "%s PLL(s) do not have real-time reconfiguration. PLL configuration for each PLL is highly recommended for designs migrating to HardCopy devices." "%1!s! PLL(s) do not have real-time reconfiguration. PLL configuration for each PLL is highly recommended for designs migrating to HardCopy devices." 1]
	set msgs(W_PHYSICAL_NAME_NOT_FOUND) [list WHARDCOPY_PHYSICAL_NAME_NOT_FOUND "Cann't find the corresponding Quartus II script command name of the specified name ID %s in the physical netlist" "Cann't find the corresponding Quartus II script command name of the specified name ID %1!s! in the physical netlist" 1]
	set msgs(W_PIN_NOT_MIGRATED) [list WHARDCOPY_PIN_NOT_MIGRATED "Pin locations will not be migrated from the compilation database" "Pin locations will not be migrated from the compilation database" 0]
	set msgs(W_PLL_DRIVES_MULTIPLE_CLOCK_NETWORK_TYPE) [list WHARDCOPY_PLL_DRIVES_MULTIPLE_CLOCK_NETWORK_TYPE "Found %s PLL(s) with clock outputs that drive multiple clock network types" "Found %1!s! PLL(s) with clock outputs that drive multiple clock network types" 1]
	set msgs(W_PLL_NORMAL_COMPENSATION_FEEDING_IO) [list WHARDCOPY_PLL_NORMAL_COMPENSATION_FEEDING_IO "%s PLL(s) is in normal or source synchronous mode that is not fully compensated because it feeds an output pin. Only PLLs in zero delay buffer mode can fully compensate output pins." "%1!s! PLL(s) is in normal or source synchronous mode that is not fully compensated because it feeds an output pin. Only PLLs in zero delay buffer mode can fully compensate output pins." 1]
	set msgs(W_PROJECT_SHOW_ENTITY_NAME_OFF) [list WHARDCOPY_PROJECT_SHOW_ENTITY_NAME_OFF "Expected PROJECT_SHOW_ENTITY_NAME setting to be turned on, but it is turned off. Entity specific assignments will not be successfully converted." "Expected PROJECT_SHOW_ENTITY_NAME setting to be turned on, but it is turned off. Entity specific assignments will not be successfully converted." 0]
	set msgs(W_P_ASGN_DST_IS_EMPTY) [list WHARDCOPY_P_ASGN_DST_IS_EMPTY "The converted PrimeTime constraint destination is empty" "The converted PrimeTime constraint destination is empty" 0]
	set msgs(W_P_ASGN_SRC_IS_EMPTY) [list WHARDCOPY_P_ASGN_SRC_IS_EMPTY "The converted PrimeTime constraint source is empty" "The converted PrimeTime constraint source is empty" 0]
	set msgs(W_P_COL_IS_EMPTY) [list WHARDCOPY_P_COL_IS_EMPTY "Cannot generate collection %s because collection is empty" "Cannot generate collection %1!s! because collection is empty" 1]
	set msgs(W_P_NAME_NOT_FOUND) [list WHARDCOPY_P_NAME_NOT_FOUND "Can't find a corresponding PrimeTime script command name to the Quartus II script command name %s (%s)" "Can't find a corresponding PrimeTime script command name to the Quartus II script command name %1!s! (%2!s!)" 2]
	set msgs(W_P_NAME_OR_COLL_NOT_FOUND) [list WHARDCOPY_P_NAME_OR_COLL_NOT_FOUND "%s does not map to any node in the physical netlist" "%1!s! does not map to any node in the physical netlist" 1]
	set msgs(W_Q_ASGN_DST_IS_EMPTY) [list WHARDCOPY_Q_ASGN_DST_IS_EMPTY "The Quartus II assignment destination is empty" "The Quartus II assignment destination is empty" 0]
	set msgs(W_Q_NAME_NOT_FOUND) [list WHARDCOPY_Q_NAME_NOT_FOUND "Cannot find the corresponding Quartus II software name of the specified name ID %s" "Cannot find the corresponding Quartus II software name of the specified name ID %1!s!" 1]
	set msgs(W_RAM_HAVE_MIF) [list WHARDCOPY_RAM_HAVE_MIF "%s RAM(s) are associated with Memory Initialization File. The usage of Memory Initialization File is not allowed when migrating to a HardCopy device in non-ROM operation mode." "%1!s! RAM(s) are associated with Memory Initialization File. The usage of Memory Initialization File is not allowed when migrating to a HardCopy device in non-ROM operation mode." 1]
	set msgs(W_REPORT_PANEL_NOT_FOUND) [list WHARDCOPY_REPORT_PANEL_NOT_FOUND "%s panel cannot be found in %s" "%1!s! panel cannot be found in %2!s!" 2]
	set msgs(W_SETTING_NOT_MET) [list WHARDCOPY_SETTING_NOT_MET "%s %s setting(s) do not meet recommendation. Review the recommendation and perform the appropriate correction because it may affect the result of the migration to HardCopy." "%1!s! %2!s! setting(s) do not meet recommendation. Review the recommendation and perform the appropriate correction because it may affect the result of the migration to HardCopy." 2]
	set msgs(W_SHOULD_BE_NO_BASE_CLK) [list WHARDCOPY_SHOULD_BE_NO_BASE_CLK "There should be no base clock, but base clock %s appears" "There should be no base clock, but base clock %1!s! appears" 1]
	set msgs(W_UNCONNECTED_PINS) [list WHARDCOPY_UNCONNECTED_PINS "%s pin(s) are not connected" "%1!s! pin(s) are not connected" 1]
	set msgs(W_UNK_OBSERVABLE_PORT_TYPE) [list WHARDCOPY_UNK_OBSERVABLE_PORT_TYPE "Found unsupported port %s with port type: %s" "Found unsupported port %1!s! with port type: %2!s!" 2]
	set msgs(W_UNSUPPORTED_GLOBAL_ASGN) [list WHARDCOPY_UNSUPPORTED_GLOBAL_ASGN "Ignoring unsupported global %s = %s" "Ignoring unsupported global %1!s! = %2!s!" 2]
	set msgs(W_VALUE_IS_NOT_A_NUMBER) [list WHARDCOPY_VALUE_IS_NOT_A_NUMBER "Specified %s, %s, is not a number." "Specified %1!s!, %2!s!, is not a number." 2]
	set msgs(W_VALUE_SMALLER_THAN_0) [list WHARDCOPY_VALUE_SMALLER_THAN_0 "Value %s, %s, is less than 0" "Value %1!s!, %2!s!, is less than 0" 2]
	set msgs(W_WRONG_ASGN_EXPECTED_VALUE) [list WHARDCOPY_WRONG_ASGN_EXPECTED_VALUE "The %s assignment value should be %s, but instead is an incorrect assignment value: %s" "The %1!s! assignment value should be %2!s!, but instead is an incorrect assignment value: %3!s!" 3]
	set msgs(_ALL_CLOCKS_RELATED) [list HARDCOPY_ALL_CLOCKS_RELATED  "All clocks are related. No false path constraints are generated between clock domains." "All clocks are related. No false path constraints are generated between clock domains." 0]
	set msgs(_BASE_CLK_ID_NAME_CNT_NOT_EQUAL) [list HARDCOPY_BASE_CLK_ID_NAME_CNT_NOT_EQUAL  "The number of base clock names is not equal to that of base clock IDs." "The number of base clock names is not equal to that of base clock IDs." 0]
	set msgs(_CANNOT_FIND_BASE_CLK) [list HARDCOPY_CANNOT_FIND_BASE_CLK  "Cannot find a base clock for specified derived clock." "Cannot find a base clock for specified derived clock." 0]
	set msgs(_CLOCK_NOT_ON_DEDICATED_PAD) [list HARDCOPY_CLOCK_NOT_ON_DEDICATED_PAD  "%s pin(s) drives global or regional clock, but is not placed in a dedicated clock pin position. Clock insertion delay will be different between FPGA and HardCopy companion revisions because of differences in local routing interconnect delays." "%1!s! pin(s) drives global or regional clock, but is not placed in a dedicated clock pin position. Clock insertion delay will be different between FPGA and HardCopy companion revisions because of differences in local routing interconnect delays." 1]
	set msgs(_CONVERT_DEFAULT_Q_ASGN) [list HARDCOPY_CONVERT_DEFAULT_Q_ASGN  "Corresponding Quartus assignment: %s is not set. The value from %s assignment is used." "Corresponding Quartus assignment: %1!s! is not set. The value from %2!s! assignment is used." 2]
	set msgs(_CONVERT_Q_ASGN) [list HARDCOPY_CONVERT_Q_ASGN  "Converting Quartus assignment %s (%s)." "Converting Quartus assignment %1!s! (%2!s!)." 2]
	set msgs(_CORE_VOLTAGE_DIFFERENCE) [list HARDCOPY_CORE_VOLTAGE_DIFFERENCE  "HardCopy III devices only support 0.9V core voltage. Please ensure that the board design is able to provide VCC voltage level for both 0.9V and %s." "HardCopy III devices only support 0.9V core voltage. Please ensure that the board design is able to provide VCC voltage level for both 0.9V and %1!s!." 1]
	set msgs(_CUT_OFF_FROM_TO) [list HARDCOPY_CUT_OFF_FROM_TO  "The CUT = OFF -from %s -to %s will not be translated as it has already been accounted for in Quartus II." "The CUT = OFF -from %1!s! -to %2!s! will not be translated as it has already been accounted for in Quartus II." 2]
	set msgs(_CUT_OFF_TO) [list HARDCOPY_CUT_OFF_TO  "The CUT = OFF -to %s will not be translated as it has already been accounted for in Quartus II." "The CUT = OFF -to %1!s! will not be translated as it has already been accounted for in Quartus II." 1]
	set msgs(_CUT_PATH_BETWEEN_CLK_DOMAIN_OFF) [list HARDCOPY_CUT_PATH_BETWEEN_CLK_DOMAIN_OFF  "Quartus assignment: CUT_OFF_PATHS_BETWEEN_CLOCK_DOMAINS is set to OFF. No clock groups are generated." "Quartus assignment: CUT_OFF_PATHS_BETWEEN_CLOCK_DOMAINS is set to OFF. No clock groups are generated." 0]
	set msgs(_EMPTY_OBJECT) [list HARDCOPY_EMPTY_OBJECT  "Found an empty object." "Found an empty object." 0]
	set msgs(_EVALUATION_FAILED) [list HARDCOPY_EVALUATION_FAILED  "Unable to retrieve %s info." "Unable to retrieve %1!s! info." 1]
	set msgs(_FAIL_TO_CONVERT_Q_ASGN) [list HARDCOPY_FAIL_TO_CONVERT_Q_ASGN  "Failed to convert Quartus assignment %s (%s)." "Failed to convert Quartus assignment %1!s! (%2!s!)." 2]
	set msgs(_GOT_MIF) [list HARDCOPY_GOT_MIF  "All RAMs have a corresponding MIF.  Skipping checkerboard pattern check." "All RAMs have a corresponding MIF.  Skipping checkerboard pattern check." 0]
	set msgs(_HC_READY_ILLEGAL_PART_NAME) [list HARDCOPY_HC_READY_ILLEGAL_PART_NAME  "Part name %s is illegal -- specify a target device part belonging to the %s device family for the revision \\\"%s\\\"." "Part name %1!s! is illegal -- specify a target device part belonging to the %2!s! device family for the revision \\\"%3!s!\\\"." 3]
	set msgs(_HC_READY_NO_FULL_COMPILE) [list HARDCOPY_HC_READY_NO_FULL_COMPILE  "Run full compilation on revision %s before running HardCopy Design Readiness Check." "Run full compilation on revision %1!s! before running HardCopy Design Readiness Check." 1]
	set msgs(_ILLEGAL_CHARACTER) [list HARDCOPY_ILLEGAL_CHARACTER  "Revision name contains illegal character %s  ." "Revision name contains illegal character %1!s!  ." 1]
	set msgs(_ILLEGAL_FAMILY_NAME) [list HARDCOPY_ILLEGAL_FAMILY_NAME  "Family name \\\"%s\\\" is illegal. Please specify a valid family name." "Family name \\\"%1!s!\\\" is illegal. Please specify a valid family name." 1]
	set msgs(_ILLEGAL_MIG_DEVICE) [list HARDCOPY_ILLEGAL_MIG_DEVICE  "Illegal DEVICE_TECHNOLOGY_MIGRATION_LIST = %s" "Illegal DEVICE_TECHNOLOGY_MIGRATION_LIST = %1!s!" 1]
	set msgs(_ILLEGAL_SOURCE_FAMILY) [list HARDCOPY_ILLEGAL_SOURCE_FAMILY  "Source device family %s is not supported -- make sure the family is either a Stratix II or HardCopy II source device" "Source device family %1!s! is not supported -- make sure the family is either a Stratix II or HardCopy II source device" 1]
	set msgs(_IMPORTANT_MESSAGE_GENERATED) [list HARDCOPY_IMPORTANT_MESSAGE_GENERATED  "%s important info message was generated." "%1!s! important info message was generated." 1]
	set msgs(_INVALID_BASE_CLOCK) [list HARDCOPY_INVALID_BASE_CLOCK  "Specified base clock, %s, is not a valid clock." "Specified base clock, %1!s!, is not a valid clock." 1]
	set msgs(_IOC_REG) [list HARDCOPY_IOC_REG  "Quartus register %s is moved to I/O cell %s." "Quartus register %1!s! is moved to I/O cell %2!s!." 2]
	set msgs(_MIGRATING_BACK_ANNOTATION) [list HARDCOPY_MIGRATING_BACK_ANNOTATION  "Migrating Back-Annotated Assignments" "Migrating Back-Annotated Assignments" 0]
	set msgs(_MIGRATING_GLOBAL) [list HARDCOPY_MIGRATING_GLOBAL  "Migrating Global Assignments" "Migrating Global Assignments" 0]
	set msgs(_MIGRATING_INSTANCE) [list HARDCOPY_MIGRATING_INSTANCE  "Migrating Instance Assignments" "Migrating Instance Assignments" 0]
	set msgs(_MIGRATING_PARAMETER) [list HARDCOPY_MIGRATING_PARAMETER  "Migrating User Parameters" "Migrating User Parameters" 0]
	set msgs(_MIGRATING_PIN_LOCATION) [list HARDCOPY_MIGRATING_PIN_LOCATION  "Migrating Pin Assignments" "Migrating Pin Assignments" 0]
	set msgs(_MULTI_BASE_CLK) [list HARDCOPY_MULTI_BASE_CLK  "Multiple base clocks are specified. Ignore all but the first base clock." "Multiple base clocks are specified. Ignore all but the first base clock." 0]
	set msgs(_MULTI_HOLD_MC_ASGN) [list HARDCOPY_MULTI_HOLD_MC_ASGN  "Both Hold Multicycle and Source Hold Multicycle are set." "Both Hold Multicycle and Source Hold Multicycle are set." 0]
	set msgs(_MULTI_MC_ASGN) [list HARDCOPY_MULTI_MC_ASGN  "Both Multicycle and Source Multicycle are set." "Both Multicycle and Source Multicycle are set." 0]
	set msgs(_NETLIST_UNAVAILABLE) [list HARDCOPY_NETLIST_UNAVAILABLE  "Unable to retrieve information from netlist." "Unable to retrieve information from netlist." 0]
	set msgs(_NO_BLOCK_TYPE_NODE) [list HARDCOPY_NO_BLOCK_TYPE_NODE  "No %s was found in the design." "No %1!s! was found in the design." 1]
	set msgs(_NO_CLK_IN_INPUT_DELAY) [list HARDCOPY_NO_CLK_IN_INPUT_DELAY  "The Quartus assignment destination may consist of clock(s). Input delay is not allowed to set on clock port(s) {%s}" "The Quartus assignment destination may consist of clock(s). Input delay is not allowed to set on clock port(s) {%1!s!}" 1]
	set msgs(_NO_CLK_IN_TAN_RPT) [list HARDCOPY_NO_CLK_IN_TAN_RPT  "No clocks were found in the Timing Analysis report." "No clocks were found in the Timing Analysis report." 0]
	set msgs(_NO_IO_ASSIGNMENT) [list HARDCOPY_NO_IO_ASSIGNMENT  "%s pin(s) have no explicit %s assignments provided in the setting file and default values are being used. Please add a specific %s assignment for these pins." "%1!s! pin(s) have no explicit %2!s! assignments provided in the setting file and default values are being used. Please add a specific %3!s! assignment for these pins." 3]
	set msgs(_NO_LOCATION_ASSIGNMENT) [list HARDCOPY_NO_LOCATION_ASSIGNMENT  "%s pin(s) don't have location assignments." "%1!s! pin(s) don't have location assignments." 1]
	set msgs(_NO_PINS) [list HARDCOPY_NO_PINS  "Unable to find any pins." "Unable to find any pins." 0]
	set msgs(_NO_PLL_RECONFIGURATION) [list HARDCOPY_NO_PLL_RECONFIGURATION  "%s PLL(s) cannot be reconfigured in real-time. Altera recommends that each PLL be reconfigurable for designs migrating to HardCopy devices." "%1!s! PLL(s) cannot be reconfigured in real-time. Altera recommends that each PLL be reconfigurable for designs migrating to HardCopy devices." 1]
	set msgs(_NO_RAMS) [list HARDCOPY_NO_RAMS  "Design has no M4K or M512 RAMs.  Skipping checkerboard pattern check." "Design has no M4K or M512 RAMs.  Skipping checkerboard pattern check." 0]
	set msgs(_NO_RAM_HAVE_MIF) [list HARDCOPY_NO_RAM_HAVE_MIF  "No RAM have memory initialization file. No action required." "No RAM have memory initialization file. No action required." 0]
	set msgs(_ONLY_SUPPORT_SII_AND_HCII) [list HARDCOPY_ONLY_SUPPORT_SII_AND_HCII "This feature is only available when the family of the current revision is either HardCopy II or Stratix II." "This feature is only available when the family of the current revision is either HardCopy II or Stratix II." 0]
	set msgs(_OPEN_FILE) [list HARDCOPY_OPEN_FILE  "Opening %s for output." "Opening %1!s! for output." 1]
	set msgs(_OVERRIDE_REVISION) [list HARDCOPY_OVERRIDE_REVISION  "Overwriting existing Target Revision named %s" "Overwriting existing Target Revision named %1!s!" 1]
	set msgs(_OVERRIDE_REVISION_FAILED) [list HARDCOPY_OVERRIDE_REVISION_FAILED  "Failed in overwriting existing Target Revision named %s" "Failed in overwriting existing Target Revision named %1!s!" 1]
	set msgs(_PHYSICAL_NAME_NOT_FOUND) [list HARDCOPY_PHYSICAL_NAME_NOT_FOUND  "Cannot find the corresponding Quartus name of specified name ID %s in the physical atom netlist." "Cannot find the corresponding Quartus name of specified name ID %1!s! in the physical atom netlist." 1]
	set msgs(_PIN_NOT_MIGRATED) [list HARDCOPY_PIN_NOT_MIGRATED  "Pin Locations will not be migrated from the compiled database" "Pin Locations will not be migrated from the compiled database" 0]
	set msgs(_PLL_DRIVES_MULTIPLE_CLOCK_NETWORK_TYPE) [list HARDCOPY_PLL_DRIVES_MULTIPLE_CLOCK_NETWORK_TYPE  "Found %s PLL with clock outputs that drives multiple clock network types." "Found %1!s! PLL with clock outputs that drives multiple clock network types." 1]
	set msgs(_PLL_NORMAL_COMPENSATION_FEEDING_IO) [list HARDCOPY_PLL_NORMAL_COMPENSATION_FEEDING_IO  "%s PLL(s) is in normal or source synchronous mode that is not fully compensated because it feeds an output pin -- only PLLs in zero delay buffer mode can fully compensate output pins." "%1!s! PLL(s) is in normal or source synchronous mode that is not fully compensated because it feeds an output pin -- only PLLs in zero delay buffer mode can fully compensate output pins." 1]
	set msgs(_PLL_NO_COMPENSATION) [list HARDCOPY_PLL_NO_COMPENSATION  "%s PLL(s) is operating in a No Compensation mode." "%1!s! PLL(s) is operating in a No Compensation mode." 1]
	set msgs(_P_NAME_NOT_FOUND) [list HARDCOPY_P_NAME_NOT_FOUND  "Cannot find corresponding PrimeTime name for Quartus name %s (%s)." "Cannot find corresponding PrimeTime name for Quartus name %1!s! (%2!s!)." 2]
	set msgs(_P_NAME_OR_COLL_NOT_FOUND) [list HARDCOPY_P_NAME_OR_COLL_NOT_FOUND  "%s does not map to any node in the physical netlist." "%1!s! does not map to any node in the physical netlist." 1]
	set msgs(_RAM_HAVE_MIF) [list HARDCOPY_RAM_HAVE_MIF  "%s RAM(s) have Memory Initialization File (MIF). The usage of Memory Initialization File is not allowed when migrating to a HardCopy device in non-ROM operation mode." "%1!s! RAM(s) have Memory Initialization File (MIF). The usage of Memory Initialization File is not allowed when migrating to a HardCopy device in non-ROM operation mode." 1]
	set msgs(_READ_PIN_LOCATIONS) [list HARDCOPY_READ_PIN_LOCATIONS  "Reading Pin locations from compiler database" "Reading Pin locations from compiler database" 0]
	set msgs(_REPORT_PANEL_NOT_FOUND) [list HARDCOPY_REPORT_PANEL_NOT_FOUND  "%s panel cannot be found in %s." "%1!s! panel cannot be found in %2!s!." 2]
	set msgs(_RUN_EXE_TO_GENERATE_FILE) [list HARDCOPY_RUN_EXE_TO_GENERATE_FILE  "Run %s to generate the file." "Run %1!s! to generate the file." 1]
	set msgs(_RUN_SUCCESSFUL_FIT_BEFORE_HC_READY) [list HARDCOPY_RUN_SUCCESSFUL_FIT_BEFORE_HC_READY  "Run the Fitter (quartus_fit) successfully on revision %s before running the HardCopy Design Readiness Check." "Run the Fitter (quartus_fit) successfully on revision %1!s! before running the HardCopy Design Readiness Check." 1]
	set msgs(_SETTING_NOT_MET) [list HARDCOPY_SETTING_NOT_MET  "%s %s setting(s) do not meet recommendation. Please review the recommendation and do appropriate correction as it may affect the result of the migration to HardCopy." "%1!s! %2!s! setting(s) do not meet recommendation. Please review the recommendation and do appropriate correction as it may affect the result of the migration to HardCopy." 2]
	set msgs(_SHOULD_BE_NO_BASE_CLK) [list HARDCOPY_SHOULD_BE_NO_BASE_CLK  "Specified clock should have no base clock, but base clock named %s appears." "Specified clock should have no base clock, but base clock named %1!s! appears." 1]
	set msgs(_SOURCE_DEVICE) [list HARDCOPY_SOURCE_DEVICE  "Source Device = %s" "Source Device = %1!s!" 1]
	set msgs(_SOURCE_FAMILY) [list HARDCOPY_SOURCE_FAMILY  "Source Family = %s" "Source Family = %1!s!" 1]
	set msgs(_SOURCE_REVISION) [list HARDCOPY_SOURCE_REVISION  "Using Source Revision named %s" "Using Source Revision named %1!s!" 1]
	set msgs(_TARGET_DEVICE) [list HARDCOPY_TARGET_DEVICE  "Target Device = %s" "Target Device = %1!s!" 1]
	set msgs(_TARGET_FAMILY) [list HARDCOPY_TARGET_FAMILY  "Target Family = %s" "Target Family = %1!s!" 1]
	set msgs(_TARGET_REVISION) [list HARDCOPY_TARGET_REVISION  "Using Target Revision named %s" "Using Target Revision named %1!s!" 1]
	set msgs(_UNCONNECTED_PINS) [list HARDCOPY_UNCONNECTED_PINS  "%s pin(s) are not connected." "%1!s! pin(s) are not connected." 1]
	set msgs(_UNKNOWN_ATOM_TYPE) [list HARDCOPY_UNKNOWN_ATOM_TYPE  "Unknown atom type %s." "Unknown atom type %1!s!." 1]
	set msgs(_UNK_OBSERVABLE_PORT_TYPE) [list HARDCOPY_UNK_OBSERVABLE_PORT_TYPE  "Found unsupported %s port type: %s." "Found unsupported %1!s! port type: %2!s!." 2]
	set msgs(_VALUE_SMALLER_THAN_0) [list HARDCOPY_VALUE_SMALLER_THAN_0  "Specified %s, %s, is less than 0." "Specified %1!s!, %2!s!, is less than 0." 2]

		# Map of message types
	variable msg_types
	array set msg_types { \
		CW	{ critical_warning	"Critical Warning" } \
		E	{ error				Error } \
		EI	{ extra_info		"Extra Info" } \
		I	{ info				Info } \
		W	{ warning			Warning } \
	}
	
	# -------------------------------------------------
	# -------------------------------------------------
	#
	# Exported API's:
	#
	#  - post			- posts the message "Critical Warning: Hello World" given the msg handle "CW_HELLO_WORLD" (and optional variable sized arguments)
	#  - get_user_type	- returns "Critical Warning"
	#  - get_text		- returns "Hello World"
	#  - internal_error	- issues the Tcl version of an internal error
	#
	# Hidden API's:
	#
	#  - get_debug_type	- returns "critical_warning" used by "post_message -type <debug msg type>"
	#  - is_legal		- exits script program with error if handle is not defined in the .msg file
	#  - get_help_id	- returns the help id associated with GUI online help page
	#
	# -------------------------------------------------
	# -------------------------------------------------
	namespace export post get_user_type get_text internal_error
	
	# -------------------------------------------------
	# -------------------------------------------------
	proc internal_error {msg} {
		# Returns:
		#   An Internal Error.
	# -------------------------------------------------
	# -------------------------------------------------
		return -code error "\n!------- Internal Error -------!\n$msg\n!------- Internal Error -------!\n"
	}
	
	# -------------------------------------------------
	# -------------------------------------------------
	proc is_legal {handle} {
		# Returns:
		#   The actual handle.
		#
		#   The actual handle will differ when the user
		#   specifies the handle as a CW (Critical Warning)
		#   or EI (Extra Info). In this case, we
		#   need to convert them into I and W, respectively.
		#
		#   Script will exit if the handle is not
		#   a legally defined handle.
	# -------------------------------------------------
	# -------------------------------------------------
	
		variable msgs
	
		set orignal_handle $handle
	
		set underscore [string first "_" $handle]
		set type [string range $handle 0 [expr $underscore - 1]]
		if {[string compare $type EI] == 0} {
			set handle "I_[string range $handle [expr $underscore + 1] end]"
		} elseif {[string compare $type CW] == 0} {			
			set handle "W_[string range $handle [expr $underscore + 1] end]"
		}
	
		if {[string compare [array names msgs $handle] ""] == 0} {
			internal_error "Illegal handle: $orignal_handle"
		}
	
		return $handle
	}
	
	# -------------------------------------------------
	# -------------------------------------------------
	proc get_debug_type {handle} {
		# Returns:
		#   The message type for use internally
		#   by "post_message -type <debug msg type>"
		#   For example, the debug msg type
		#   "critical_warning"
		#   is equivalent to the user msg type
		#   "Critical Warning".
	# -------------------------------------------------
	# -------------------------------------------------
	
		variable msg_types
	
		is_legal $handle
	
		set type [string range $handle 0 [expr [string first "_" $handle] - 1]]
	
		return [lindex $msg_types($type) 0]
	}
	
	
	# -------------------------------------------------
	# -------------------------------------------------
	proc get_user_type {handle} {
		# Returns:
		#   The message type for pretty printing.
		#   This returns the string you see prepended
		#   to every user message.
		#   For example, the user msg type
		#   "Critical Warning"
		#   is equivalent to the debug msg type
		#   "critical_warning".
	# -------------------------------------------------
	# -------------------------------------------------
	
		variable msg_types
	
		is_legal $handle
	
		set type [string range $handle 0 [expr [string first "_" $handle] - 1]]
	
		return [lindex $msg_types($type) 1]
	}
	
	# -------------------------------------------------
	# -------------------------------------------------
	proc get_help_id {handle} {
		# Returns:
		#   The help id associated with Quartus II
		#   online help page.
	# -------------------------------------------------
	# -------------------------------------------------
	
		variable msgs
	
		set handle [is_legal $handle]
	
		return [lindex $msgs($handle) 0]
	}
	
	# -------------------------------------------------
	# -------------------------------------------------
	proc get_raw_text {handle} {
		# Returns:
		#   The raw text containing containing
		#   placeholders such as %1!s!
	# -------------------------------------------------
	# -------------------------------------------------
	
		variable msgs
	
		set handle [is_legal $handle]
	
		return [lindex $msgs($handle) 2]
	}
	
	# -------------------------------------------------
	# -------------------------------------------------
	proc get_expected_args_count {handle} {
		# Returns:
		#   The expected number of arguments
		#   for the handle.
	# -------------------------------------------------
	# -------------------------------------------------
	
		variable msgs
	
		set handle [is_legal $handle]
	
		return [lindex $msgs($handle) 3]
	}
	
	# -------------------------------------------------
	# -------------------------------------------------
	proc _get_text {handle args_list} {
		# Returns:
		#   The actual text users see when the
		#   message is posted
		#   (e.g. "Hello World")
		#   -- minus the prepending
		#   user msg type (returned by
		#   proc "get_user_type") and ": "
		#   (e.g. minus the "Info: " portion).
	# -------------------------------------------------
	# -------------------------------------------------
	
		variable msgs
	
		set handle [is_legal $handle]
	
		set tmp_msg	[lindex $msgs($handle) 1]
		set ret_msg	""
		set i		0
		set left	0
		while {1} {
			set right [string first "%s" $tmp_msg $left]
			if {$right == -1} {
				append ret_msg [string range $tmp_msg $left [string length $tmp_msg]]
				break
			}
			append ret_msg [string range $tmp_msg $left [expr $right - 1]] [lindex $args_list $i]
			set left [expr $right + 2]
			incr i
		}
	
		return $ret_msg
	}
	
	# -------------------------------------------------
	# -------------------------------------------------
	proc get_text {handle args} {
		# Returns:
		#   Same as "_get_text" except
		#   that this command can take a variable
		#   number of arguments.
	# -------------------------------------------------
	# -------------------------------------------------
	
		return [_get_text $handle $args]
	}
	
	# -------------------------------------------------
	# -------------------------------------------------
	proc post {handle args} {
		# Returns:
		#   Nothing.
		#   Posts the user message associated to
		#   the handle and optional variable-sized arguments.
		# Note:
		#   If you wish to post "Extra Info" or "Critical Warning"
		#   types, just prepend with "EI" or "CW" instead
		#   of the "I" and "W" types marked in your .msg file.
	# -------------------------------------------------
	# -------------------------------------------------
	
		set cmd "post_message \"[_get_text $handle $args]\" \
							  -raw_text \"[get_raw_text $handle]\" \
							  -type \"[get_debug_type $handle]\" \
							  -help_id \"[get_help_id $handle]\""
	
		set expected [get_expected_args_count $handle]
		set actual 0
		foreach i $args { append raw_args "$i "; incr actual }
		if {$expected != $actual} {
			internal_error "Expected $expected argument[expr {$expected == 1 ? "" : "s"}] for message \"$handle\" but got $actual instead"
		} elseif {$actual > 0} {
			append cmd " -raw_args \"$raw_args\""
		}
	
		eval $cmd
	}
	
	# --------------------------------------------------------------------------
	# --------------------------------------------------------------------------
	proc output_msg { ostream handle args } {
		# Output a message (referenced by msg_name with optional arguments) to
		# the specified stream.
	# --------------------------------------------------------------------------
	# --------------------------------------------------------------------------
		set msg [_get_text $handle $args]
	#	set msg_type_str [hcii_msg::get_msg_type_str $handle 1]
	        set user_type [get_user_type $handle]
		set help_id [get_help_id $handle]
		puts $ostream "# $user_type (code = $help_id): $msg"
	}
	
	# --------------------------------------------------------------------------
	# --------------------------------------------------------------------------
	proc output_msg_list { ostream msg_list_ref } {
		# Output a list of messages to the specified stream.
	# --------------------------------------------------------------------------
	# --------------------------------------------------------------------------
		upvar $msg_list_ref msg_list
		foreach msg $msg_list {
			output_msg $ostream [lindex $msg 0] [lindex $msg 1]
		}
	}
	
	
	# --------------------------------------------------------------------------
	# --------------------------------------------------------------------------
	proc post_list { msg_list_ref } {
		# Post a list of messages.
	# --------------------------------------------------------------------------
	# --------------------------------------------------------------------------
		upvar $msg_list_ref msg_list
		foreach msg $msg_list {
	                if { [llength $msg] == 1 } {
	                    post [lindex $msg 0]
	                } else {
	                    set handle [lindex $msg 0]
	                    set arguments [lindex $msg 1]
	                    set cmd "post $handle $arguments"
	                    eval $cmd
	                }
		}
	}
	
	# --------------------------------------------------------------------------
	# --------------------------------------------------------------------------
	proc post_debug_msg {handle args} {
		# Post a debug message (referenced by handle with optional arguments).
	# --------------------------------------------------------------------------
	# --------------------------------------------------------------------------
		msg_vdebug [_get_text $handle $args]
	}
	
	
	

}

