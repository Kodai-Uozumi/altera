##############################################################################
#
# File Name:    dtw_timing_analysis.tcl
#
# Summary:      This TK script is a simple Graphical User Interface to
#               generate timing requirements for DDR memory interfaces
#
# Licencing:
#               ALTERA LEGAL NOTICE
#               
#               This script is  pursuant to the following license agreement
#               (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE
#               FOLLOWING): Copyright (c) 2009-2010 Altera Corporation, San Jose,
#               California, USA.  Permission is hereby granted, free of
#               charge, to any person obtaining a copy of this software and
#               associated documentation files (the "Software"), to deal in
#               the Software without restriction, including without limitation
#               the rights to use, copy, modify, merge, publish, distribute,
#               sublicense, and/or sell copies of the Software, and to permit
#               persons to whom the Software is furnished to do so, subject to
#               the following conditions:
#               
#               The above copyright notice and this permission notice shall be
#               included in all copies or substantial portions of the Software.
#               
#               THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#               EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#               OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#               NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#               HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#               WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#               FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#               OTHER DEALINGS IN THE SOFTWARE.
#               
#               This agreement shall be governed in all respects by the laws of
#               the State of California and by the laws of the United States of
#               America.
#
#               
#
# Usage:
#
#               You can run this script from a command line by typing:
#                     quartus_sh -t dtw_timing_analysis.tcl -dwz_file <dwz_file>
#
###############################################################################

package require ::quartus::dtw_util
package require ::quartus::dtw_msg
package require ::quartus::dtw_dwz
package require cmdline
package require ::quartus::report
package require ::quartus::flow

namespace eval dtw { proc add_version_date { args } { } }

namespace eval dtw_automation {

	source ${quartus(tclpath)}apps/dtw/dtw_timing.tcl
    namespace import dtw_timing::get_ns

    set script_build 265

    array set pnl_str [list \
        timing_report_path          "Timing Analyzer" \
        tq_timing_report_path       "TimeQuest Timing Analyzer" \
        flow_elapsed_time_path      "Flow Elapsed Time" \
        timing_analyzer_settings    "Timing Analyzer Settings" \
        report_io_paths_separately  "Report IO Paths Separately" \
        use_fast_timing_models      "Use Fast Timing Models" \
        do_combined_analysis        "Report Combined Fast/Slow Timing" \
        slow_model                  "Slow Model" \
        fast_model                  "Fast Model" \
        clock_setup                 "Clock Setup" \
        clock_hold                  "Clock Hold" \
        recovery                    "Recovery" \
        removal                     "Removal" \
        pll_usage                   "Fitter||Resource Section||PLL Usage" \
        input_pins                  "Fitter||Resource Section||Input Pins" \
        output_pins                 "Fitter||Resource Section||Output Pins" \
        bidir_pins                  "Fitter||Resource Section||Bidir Pins" \
        current_phase               "Phase Shift" \
        actual_tco                  "Actual tco" \
        addr_ctrl_timegroup         {%settings_name%_addr_ctrl_timegroup} \
        dqs_ck_timegroup            {%settings_name%_dqs_ck_timegroup} \
        outclk_timegroup            {%settings_name%_outclk_timegroup} \
        mdas_pll                    {*_clk0} ]
    array set tan_settings [list \
        report_io_paths_separately  "" \
        use_fast_timing_models      "" \
        do_combined_analysis        "" ]
    set current_cycle_name          "Current Clock Cycle"
    set new_cycle_name              "New Clock Cycle"
    array set mem_rpt_str [list \
        timing_report_path          "Memory Interface Timing" \
        timing_summary              "Timing Summary" \
        recommended_settings        "Recommended Settings" \
        what_to_do_next             "What To Do Next" \
        margin_panel_headings       [list "Clock" "Current Margin (ns)" \
            "Ideal Margin (ns)" "Slow Setup (ns)" "Slow Hold (ns)" \
            "Fast Setup (ns)" "Fast Hold (ns)" "PLL Name" ] \
        recommended_panel_headings  [list "Clock" $current_cycle_name \
            $new_cycle_name "Current Phase" "New Phase" \
            "PLL Name"] ]

    # Paths in the Altera cores have these patterns in them.
    array set name_filter_defaults [list \
            ddr     "auk_ddr_datapath" \
            rldram2 "auk_rldramii_datapath" \
            qdr2    "auk_qdrii_sram_datapath" ]

    # Map from memory type to instance name piece for PLL names in 7.1
    array set memory_type_to_instance [list \
        ddr     ddr \
        rldram2 rldramii \
        qdr2    qdrii ]

    # Analyses and direction multipliers for each clock type
    array set clk_to_analyses [list \
        read_cap            [list "setup" 0 "hold" 0 ] \
        clk_resync          [list "setup" -1 "hold" 1 ] \
        clk_resync2         [list "setup" -1 "hold" 1 ] \
        clk_qdr_recap       [list "setup" 0 "hold" 0 ] \
        clk_read_postamble  [list "setup" 1 "hold" -1 ] \
        dqs_clock           [list "recovery" 1 "removal" -1 ] \
        clk_sys             [list "setup" 0 "hold" 0 ] \
        clk_dq_out          [list "setup" 0 "hold" 0 ] \
        clk_addr_ctrl_out   [list "setup" -1 "hold" 1 ] ]

    # Read-side reporting for DDR
    # read_clks variables named according to
    # read_clks_<use_hardware_dqs>_<is_clk_fedback_in>
    # DDR DQS and 2 PLL
    set read_clks_1_1 [list \
        read_cap            "Read capture" \
        clk_resync          "Fed-back clock" \
        clk_resync2         "Resynchronization clock" \
        clk_read_postamble  "Postamble clock" \
        dqs_clock           "Recovery/Removal" ]
    # DDR DQS and 1 PLL
    set read_clks_1_0 [list \
        read_cap            "Read capture" \
        clk_resync          "Resynchronization clock" \
        clk_read_postamble  "Postamble clock" \
        dqs_clock           "Recovery/Removal" ]
    # DDR non-DQS and 2 PLL
    set read_clks_0_1 [list \
        clk_resync          "Read capture" \
        clk_resync2         "Resynchronization clock" ]
    # DDR non-DQS and 1 PLL
    set read_clks_0_0 [list \
        clk_resync          "Read Capture" ]

    # Read-side reporting for RLD
    # read_clks_<memory_type>_<use_hardware_dqs>
    # RLDRAM II DQS mode
    set read_clks_rldram2_1 [list \
        read_cap            "Read Capture" ]
    # RLDRAM II non-DQS mode
    set read_clks_rldram2_0 [list \
        clk_resync          "Read Capture" ]

    # Read-side reporting for QDR
    # read_clks_<memory_type>_<use_hardware_dqs>
    # QDR II DQS mode
    set read_clks_qdr2_1 [list \
        read_cap            "Read Capture" \
        clk_qdr_recap       "Recaptured Data" ]
    # QDR II non-DQS mode
    set read_clks_qdr2_0 [list \
        clk_resync          "Read Capture" \
        clk_qdr_recap       "Recaptured Data" ]

    # Write-side reporting
    # Write-side clocks for DDR/QDR/RLD
    set write_clks_ddr [list \
        clk_sys             "tDQSS" \
        clk_dq_out          "Write Capture" \
        clk_addr_ctrl_out   "Address/Command" ]
    set write_clks_qdr2 [list \
        clk_dq_out          "Write Capture" \
        clk_addr_ctrl_out   "Address/Command" ]
    set write_clks_rldram2 [list \
        clk_dq_out          "Write Capture" \
        clk_addr_ctrl_out   "Address/Command" ]

    # Read-side recommendations for DDR
    # DDR DQS, 2 PLL
    array set read_clks_rec_1_1 [list \
        clk_resync          [list cycle_name "resync_cycle" \
                                pll_name "clk_resync" \
                                phase_name "resync_phase" ] \
        clk_resync2         [list cycle_name "resync_sys_cycle" \
                                pll_name "clk_resync2" \
                                phase_name "resync_sys_phase" ] \
        clk_read_postamble  [list cycle_name "inter_postamble_cycle" \
                                pll_name "clk_dqs_out" \
                                adjust_name "System postamble clock"] \
        dqs_clock           [list cycle_name "postamble_cycle" \
                                pll_name "clk_read_postamble" \
                                phase_name "postamble_phase" \
                                adjust_name "Postamble clock"] ]
    # DDR DQS, 1 PLL
    # dqs_clock used to be clk_read_postamble
    array set read_clks_rec_1_0 [list \
        clk_resync          [list cycle_name "resync_cycle" \
                                pll_name "clk_resync" \
                                phase_name "resync_phase" ] \
        clk_read_postamble  [list cycle_name "postamble_cycle" \
                                pll_name "clk_read_postamble" \
                                phase_name "postamble_phase" \
                                adjust_name "Postamble clock" ] \
        dqs_clock           [list cycle_name "postamble_cycle" \
                                pll_name "clk_read_postamble" \
                                phase_name "postamble_phase" \
                                adjust_name "Postamble clock" ] ]
    # DDR non-DQS, 2 PLL
    array set read_clks_rec_0_1 [list \
        clk_resync          [list cycle_name "resync_cycle" \
                                pll_name "clk_resync" \
                                phase_name "resync_phase" ] \
        clk_resync2         [list cycle_name "resync_sys_cycle" \
                                pll_name "clk_resync2" \
                                phase_name "resync_sys_phase" ] ]
    # DDR non-DQS, 1 PLL
    array set read_clks_rec_0_0 [list \
        clk_resync          [list cycle_name "resync_cycle" \
                                pll_name "clk_resync" \
                                phase_name "resync_phase" ] ]

    # Read-side recommendations for RLDRAM
    # RLDRAM II DQS mode - nothing to adjust!
    array set read_clks_rec_rldram2_1 [list ]
    # RLDRAM II non-DQS mode
    array set read_clks_rec_rldram2_0 [list \
        clk_resync          [list pll_name "clk_resync" \
                                adjust_name "Read Capture" ] ]

    # Read-side recommendations for QDR
    # QDR II DQS mode - Nothing to adjust!
    array set read_clks_rec_qdr2_1 [list ]
    # QDR II non-DQS mode
    array set read_clks_rec_qdr2_0 [list \
        clk_resync          [list pll_name "clk_resync" \
                                adjust_name "Read Capture" ] ]

    # Write-side recommendations for anything
    # Write-side clocks don't get cycle-adjusted
    array set write_clks_rec_ddr [list \
        clk_sys             [list pll_name "clk_sys" \
                                adjust_name "CK/CK#"] \
        clk_addr_ctrl_out   [list pll_name "clk_addr_ctrl_out" ] \
        clk_dq_out          [list pll_name "clk_dq_out" ] ]
    array set write_clks_rec_qdr2 [list \
        clk_addr_ctrl_out   [list pll_name "clk_addr_ctrl_out" ] \
        clk_dq_out          [list pll_name "clk_dq_out" ] ]
    array set write_clks_rec_rldram2 [list \
        clk_addr_ctrl_out   [list pll_name "clk_addr_ctrl_out" ] \
        clk_dq_out          [list pll_name "clk_dq_out" ] ]

    array set analysis_options [list \
        setup,tq        "-setup" \
        hold,tq         "-hold" \
        recovery,tq     "-recovery" \
        removal,tq      "-removal" \
        setup,tanrpt    "Clock Setup" \
        hold,tanrpt     "Clock Hold" \
        recovery,tanrpt "Recovery" \
        removal,tanrpt  "Removal" \
        mdas,tanrpt     "Maximum Data Arrival Skew" \
        setup,tantcl    "-setup" \
        hold,tantcl     "-hold" \
        recovery,tantcl "-recovery" \
        removal,tantcl  "-removal" ]

# First fix clock cycles
# in iptb, there are 2 clock cycles - resync and postamble
# iptb resync should match dtw resync_sys
# iptb postamble should match dtw postamble_sys_cycle
# If clock cycles match, tell people to do pll phases next
# swap clock shift and pll phase columns
# change phase shift in IPtb or pll megawizard
# do pll mw if you use other PLL taps, or you don't update PLL checkbox in iptb
# phase shift and intermediate postamble can be done at the same time
# intermed if phases don't match
    array set next_steps [list \
        cycles "Adjust the clock cycles as recommended." \
        cycles_a "Choose one of the following options:" \
        cycles_b "   a) Rerun this script and add the -auto_adjust_cycles option." \
        cycles_c "   b) Open DTW, update the clock cycles manually, then rerun this script with the same options." \
        cycles_d "These options do not change clock cycle settings in the IP Toolbench" \
        cycles_e "If necessary, update clock cycle settings for these clocks in the IP Toolbench:" \
        dqs_yes "   Resynchronization clock and postamble clock" \
        dqs_no "   Read capture clock" \
        phases "Adjust the PLL phases as recommended." \
        phases_a "To make the changes, follow these steps" \
        phases_b "   IP Toolbench Option" \
        phases_c "      1. Change recommended PLL phases in the IP Toolbench." \
        phases_d "      2. Regenerate the core." \
        phases_e "      3. Import the updated core settings in DTW and optionally recompile (see import steps below)." \
        phases_f "   PLL MegaWizard Option" \
        phases_g "      1. Change recommended PLL phases in the PLL MegaWizard." \
        phases_h "      2. Regenerate the PLL Megacore." \
        phases_i "      3. Manually update the same PLL phases in DTW." \
        import_a "To import updated core settings in DTW manually, follow these steps:" \
        import_b "   a) Perform Analysis & Synthesis, then open DTW and import the DDR settings file" \
        import_c "   b) Optionally compile the design and rerun this script to analyze timing." \
        import_d "To import updated core settings in DTW automatically, rerun this script with one of the following options:" \
        import_e "   a) -after_iptb import  This option just imports settings." \
        import_f "   b) -after_iptb import_and_compile  This option imports settings, recompiles, and analyzes timing." \
        insert "Adjust the System Postamble phase shift setting as recommended." \
        insert_a "   1. Change the Insert intermediate postamble registers option in IP Toolbench" \
        insert_b "   2. Regenerate the core." \
        insert_c "   3. Import the updated core settings in DTW and recompile (see import steps below)." \
        addr_cmd "You should use a dedicated clock for the address and command signals to meet timing." \
        tdqss "You should use a dedicated clock for the CK/CK# signals to meet timing." \
        rtl "   To use a dedicated clock, you must edit your RTL manually." \
        rtl_a "   Don't forget to update the clock information in DTW before you recompile." \
        oht "You should change the Optimize Hold Timing assignment because clock phase calculations may be incorrect." \
        oht_tq "   Turn off Optimize Hold Timing while you close timing on this memory interface." \
        oht_tan "   Set Optimize Hold Timing to I/O Paths and Minimum TPD Paths while you close timing on this memory interface." \
        oht_last "   Make this change, recompile your design, and rerun this script." \
        clk_periods "Review the following clock transfer clock periods. They are close but not identical." \
        clk_periods_a "If they are supposed to be identical, your timing analysis results may be incorrect." \
        clk_periods_b "   1. Create a new SDC file with appropriate period constraints that overwrite these clocks." \
        clk_periods_c "   2. Rerun the script with the -last_sdc_file <filename> option." \
        paths "Increase the number of paths reported by the Classic timing analyzer" \
        free_phases "You can get 0/90/180/270 degree shifts for fed-back and postamble clocks with the following clocks." \
        free_phases_a "   0: System clock" \
        free_phases_b "   -90: Write clock for DDR2/DDR/RLDRAM II DQ pins" \
        free_phases_c "   90: Clock for QDR II Q pins" \
        free_phases_d "   -180: Falling edge of the system clock" \
        free_phases_e "   -270: Falling edge of the -90 write clock" \
        free_phases_f "   270: Falling edge of the 90 write clock" \
    ]


    # Delay chains for DQS, DQ, CK/CK# should be 0 in the TCO column
    # if not, set to 0 in teh assignment editor.
    # Pad to input register values must be the same among all DQS in the interface, all DQ as well
    # Do something
    # DQS bus, NDQS bus columns are typically 0
     
    variable max_slack 999999999
    variable min_slack -999999999
    variable data_array
    variable sock 0
    array set auto_adjust_history [list]

    # debug: whether to print debug messages or not
    # tq_timeout: how many seconds to wait for TimeQuest to start before erroring
    # uses_tq: True if read-side or write-side is TQ
    # uses_tan: True if read-side or write-side is TAN
    # uses_tq_in_fitter: True if TQ is the timing engine in the fitter
    # write_phase_gap: Number of degrees above which we do not recommend
    #  a dedicated clock output even with negative slack
    # sdc_file: Location of SDC file to process for the interface
    # last_sdc_file: Optional SDC file to process after any other SDC files
    # mem_type_dqs_pll_mode:
    # period: Period of the DDR clock in ns
    # is_ddr: True if this is a DDR (not RLD/QDR) interface
    # r_r_margin_tradeoff: recovery removal margin tradeoff value
    # name_filter:
    # interface_name:
    # dwz_settings: Name of the dwz file, without the .dwz extension
    # oht_next_steps: Whether to warn about the optimize hold time setting

    array set script_options [list \
        debug           0 \
        tq_timeout      30 \
        uses_tq         0 \
        uses_tan        0 \
        uses_tq_in_fitter   0 \
        write_phase_gap 10 \
        dwz_settings    "" \
        sdc_file        "dwz" \
        interface_name  "" \
        name_filter     "" \
        is_ddr          1 \
        last_sdc_file   "" \
        r_r_margin_tradeoff "0 ns" \
        mem_type_dqs_pll_mode   "" \
        oht_next_steps  "none" \
    ]

    array set tq_clock_info [list]
    array set clock_transfers [list]

    set tree_index 0
}

################################################################################
# If the global debug variable is set, post the string as an extra_info
# message
proc dtw_automation::puts_debug { str } {
    variable script_options
    if { $script_options(debug) } { post_message -type extra_info $str }
}

################################################################################
# 6.0 SP1.21 for example
# set_global_assignment -name LAST_QUARTUS_VERSION "6.0 SP1"
proc dtw_automation::verify_versions_match { args } {

    variable data_array

    if { [catch { open db/${data_array(project_revision)}.db_info } fh] } {
        return -code error "Compile your project before running the script"
    }

    global quartus
    set versions_match 1
    set found_project_version 0

    # Read through the file to find the version it was last opened in.
    while { [gets $fh line] >= 0 } {

        if { [regexp -nocase -- {\s*Quartus_Version = (.*?)\s*$} \
            $line -> project_version] } {

            set found_project_version 1
            if { ! [string equal $project_version $quartus(version)] } {
                set versions_match 0
            }
            # We found the version line
            break
        }
    }
    catch { close $fh }
    if { ! $versions_match } {
        post_message -type warning "Software version: $quartus(version)"
        post_message -type warning "Project version:  $project_version"
    }
    return $versions_match
}

################################################################################
# DTW uses absolute path names in the dwz file. 
# If you move the project, the absolute names will probably be wrong.
# If the absolute name of the -dwz_file option doesn't match what's in
# the dwz file, be safe and give an error. Let the user decide whether they
# mean to do that.
proc dtw_automation::same_dwz_file_location { args } {

    set options {
        { "dwz_file.arg" "" "Name of DWZ file" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable data_array
    
    set dwz_file_option [file nativename [file join [pwd] $opts(dwz_file)]]
    set dwz_file_dwz [file nativename $data_array(output_filename)]
    puts_debug "dwz: $dwz_file_dwz"
    puts_debug "cmd_line: $dwz_file_option"

    return [string equal $dwz_file_option $dwz_file_dwz]
}

################################################################################
# postamble_phase, resync_phase, resync_sys_phase
proc dtw_automation::match_pll_phase_to_dwz { args } {

    variable script_options
    variable data_array
    variable read_clks_rec_${script_options(mem_type_dqs_pll_mode)}
    upvar 0 read_clks_rec_${script_options(mem_type_dqs_pll_mode)} read_clks_rec

    set ok 1

    foreach clk_name [array names read_clks_rec] {

        # It's possible that postamble might not be used
        if { [string equal "clk_read_postamble" $clk_name] && ! $data_array(use_postamble) } {
            continue
        }
        
        array unset clk_info
        array set clk_info $read_clks_rec($clk_name)

        # See whether there is a phase to adjust that affects DTW
        if { [info exists clk_info(phase_name)] && [info exists data_array($clk_info(phase_name))]  } {

            set actual_clock_name $data_array($clk_info(pll_name))

            # Missed a possible PLL name difference in 7.1+ here
            if { [is_71] } {
                set actual_clock_name [translate_pll_name -pll_name $actual_clock_name \
                    -is_timequest $data_array(use_timequest_names)]
            }
            
            if { [catch {get_pll_phase_shift -clk_name $clk_info(pll_name)} \
                reported_phase_shift] } {
                return -code error $reported_phase_shift
            }

            regexp {(-?[\d\.]+)} $data_array($clk_info(phase_name)) \
                -> dwz_phase_shift
    
            set phase_difference [expr {abs( $reported_phase_shift - $dwz_phase_shift )}]
            
            if { 5 >= $phase_difference } {
                # OK, phases are within 5 degrees
            } elseif { 182 >= $phase_difference && $phase_difference >= 178 } {
                # Phases are 180 degrees off
                post_message -type warning "Phase for $actual_clock_name\t\
                    Last compile: $reported_phase_shift\tIn DTW: $dwz_phase_shift"
                post_message -type warning "If the difference is by design, ignore this\
                    warning. Otherwise, update the phase setting in DTW"
            } elseif { 362 >= $phase_difference && $phase_difference >= 358 } {
                # phases are 360 degrees off
                post_message -type warning "Phase for $actual_clock_name\t\
                    Last compile: $reported_phase_shift\tIn DTW: $dwz_phase_shift"
                post_message -type warning "If the difference is by design, ignore this\
                    warning. Otherwise, update the phase setting in DTW"
            } else {
                set ok 0
                post_message -type error "Phase mismatch: $actual_clock_name\t\
                    Last compile: $reported_phase_shift\tIn DTW: $dwz_phase_shift"
            }
        }
    }

    if { ! $ok } {
        return -code error "Update DTW phases to match Quartus II compile results\
            or rerun the script with the -ignore_phase_difference option"
    } else {
        return 1
    }
}

################################################################################
# Check to make sure the user hasn't changed any of the names in the
# project without updating DTW.
proc dtw_automation::check_io_and_pll_names_match { args } {

    variable data_array
    variable pnl_str
    variable script_options
    
    set all_names_match 1
    
    # Put together a list of the I/O and PLL names to check
    set dwz_pin_names [list]
    set dwz_pll_names [list]
    
    # Get the list of all I/O pins beside dq/dm and dqs/dqsn
    foreach data_array_entry { 
        addr_ctrl_list \
        addr_list \
        ck_list \
        ckn_list \
        clk_pll_in \
        ctrl_list } {
        set dwz_pin_names [concat $dwz_pin_names $data_array($data_array_entry)]
    }
    # Handle dqsn pins
    array set dqs_dqsn $data_array(dqs_dqsn_list)
    foreach dqs $data_array(dqs_list) {
        set dwz_pin_names [concat $dwz_pin_names $dqs $dqs_dqsn($dqs)]
    }
    # Handle DQ and DM I/O pins
    set dwz_pin_names [concat $dwz_pin_names \
        [get_dq_pins -dqs_pins $data_array(dqs_list) -get_dm_also]]
    if { ! $script_options(is_ddr) } {
        set dwz_pin_names [concat $dwz_pin_names \
            [get_dq_pins -dqs_pins $data_array(ck_list) -get_dm_also]]
    }
    
    # Get the list of all PLLs used
    foreach data_array_entry {
        clk_addr_ctrl_out \
        clk_dq_out \
        clk_dqs_out \
        clk_read_postamble \
        clk_resync \
        clk_resync2 \
        clk_sys } {
        
        # Some designs do not have all PLLs
        if { [info exists data_array($data_array_entry)] } {

            # And some designs might need a different PLL name checked,
            # due to Classic/TQ-style naming allowed in 7.1
            set pll_name $data_array($data_array_entry)
            if { [is_71] } {
                set pll_name [translate_pll_name -pll_name $pll_name \
                    -is_timequest $data_array(use_timequest_names)]
            }
            set dwz_pll_names [concat $dwz_pll_names $pll_name]
        }
    }
    
    # Check I/O names
    if { [catch { check_names_match \
        -panel_names [list $pnl_str(input_pins) $pnl_str(output_pins) $pnl_str(bidir_pins)] \
        -dwz_names $dwz_pin_names } res] } {
        set err_message "The following I/O pins listed in DTW\
            do not exist in your design. Did you rename them?"
        # Post a message with faked sub-messages. Join a list of things to show
        # with newlines and some spaces to indent each one
        post_message -type error [join [linsert $res 0 $err_message] "\n   "]
        set all_names_match 0
    } else {
        # Names match - good
    }

    # Check PLL names
    if { [catch { check_names_match \
        -panel_names [list $pnl_str(pll_usage)] -dwz_names $dwz_pll_names -plls} res] } {
        set err_message "The following PLLs listed in DTW\
            do not exist in your design. Did you rename them?"
        # Post a message with faked sub-messages. Join a list of things to show
        # with newlines and some spaces to indent each one
        post_message -type error [join [linsert $res 0 $err_message] "\n   "]
        set all_names_match 0
    } else {
        # Names match - good
    }
    
    if { ! $all_names_match } {
        post_message -type error "Update the names in DTW and rerun this script."
    }
    
    return $all_names_match
}

################################################################################
proc dtw_automation::check_names_match { args } {

    set options {
        { "dwz_names.arg" "" "List of names from DWZ file to check" }
        { "panel_names.arg" "" "List of report panels to search in" }
        { "plls" "Flag to convert PLL names in the panel to TQ names" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable data_array
    
    set panel_ids [list]
    set missing_names [list]
    
    # Walk through the list of names to check
    # Walk through the list of panels to check in
    # Assemble a list of any that weren't found
    
    # Get a list of panel ids from the names
    foreach panel_name $opts(panel_names) {
        if { [catch {get_report_panel_id $panel_name} res] } {
            post_message -type warning "Can't find report panel $panel_name"
            post_message -type warning "Skipping name integrity check"
        } else {
            lappend panel_ids $res
        }
    }
    
    # Go through each dwz name to check
    foreach dwz_name $opts(dwz_names) {
    
        # Some things might have been blank because of how DTW stores data
        if { [string equal "" $dwz_name] } { continue }
        
        set exists_in_report 0
        foreach panel_id $panel_ids {

            # If the name exists in the panel, row_index won't be -1
            set row_index [get_report_panel_row_index -id $panel_id $dwz_name]
            puts_debug "check_names_match: Checking $dwz_name in $panel_id with index $row_index"
            if { -1 != $row_index } { set exists_in_report 1; break}
            if { $opts(plls) } {
                set row_index [get_report_panel_row_index -id $panel_id \
                    [[translate_pll_name -pll_name $dwz_name -is_timequest 1]]]
                if { -1 != $row_index } { set exists_in_report 1; break}
            }
        }
        
        if { ! $exists_in_report } { lappend missing_names $dwz_name }
    }
    
    if { 0 != [llength $missing_names] } {
        return -code error $missing_names
    }
}

################################################################################
# If the project uses TQ in the fitter, warn if the optimize hold timing
# setting is all paths or io paths.
# If it doesn't use TQ in the fitter, it uses TAN. Warn if the 
# optimize hold timing setting is all paths.
# The script_options variable is for use in the next steps panel
proc dtw_automation::check_optimize_hold_timing { args } {

    variable script_options
    variable mem_rpt_str

    if { [catch { get_global_assignment -name OPTIMIZE_HOLD_TIMING } oht_value] } {
    } else {

        set script_options(oht_next_steps) "none"
        if { $script_options(uses_tq_in_fitter) } {
            if { [regexp -nocase {all paths} $oht_value] || \
                [regexp -nocase {io paths} $oht_value] } {
                post_message -type warning "The Optimize Hold Timing setting\
                    may cause incorrect clock cycle calculations. Review the\
                    $mem_rpt_str(what_to_do_next) report for the recommended setting."
                set script_options(oht_next_steps) "tq"
            }
        } elseif { [regexp -nocase {all paths} $oht_value] } {
                post_message -type warning "The Optimize Hold Timing setting\
                    may cause incorrect clock cycle calculations. Review the\
                    $mem_rpt_str(what_to_do_next) report for the recommended setting."
            set script_options(oht_next_steps) "tan"
        }
    }
}

################################################################################
# The script generated by IP toolbench includes assignments that CUT DQS paths.
# These CUT assignments prevent timing analysis on the DQS clocks.
# The procedure gets all CUT assignments from the DQS pins to *. If the values
# are not OFF, it adds CUT = OFF assignments for each appropriate DQS signal
proc dtw_automation::check_cut_dqs { args } {

    variable data_array

    # See whether the CUT assignment is off
    foreach dqs $data_array(dqs_list) {
        set make_asgn 0
        # If there's an error getting the value, turn off the CUT assignment
        if { [catch {
            get_instance_assignment -from $dqs -to {*} -name "CUT"} value] } {

            puts_debug "Error checking CUT assignment for $dqs"
            set make_asgn 1
        } else {
            # If there's not an error, and it's not OFF, turn off the assignment
            if { ! [string equal -nocase "OFF" $value] } {
                set make_asgn 1
            }
        }
        if { $make_asgn } {
            puts_debug "Setting CUT to OFF for $dqs"
            set_instance_assignment -from $dqs -to {*} -name "CUT" "OFF"
            export_assignments
        }
    }
}

################################################################################
# Do tco's match? If not, warn about running extract tco's
# Return an error if there was an error running something
# Return 0 if the script should not continue
# Return 1 if the script should continue
# In 7.1 and beyond, extract tcos only if you're not using TimeQuest
# Tcos are not stored in the dwz, so you must always extract
# unless the extraction is skipped
# TODO - is there a "use defaults" option in DTW?
proc dtw_automation::check_extract_tcos { args } {

    set options {
        { "action.arg" "" "What to do" }
        { "project.arg" "" "Name of project" }
        { "dwz_file.arg" "" "Name of DWZ file" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable data_array
    variable script_options

    set action [string tolower $opts(action)]

    # Compare tcos unless we're always extracting.
    if {[string equal -nocase "yes" $action] || [string equal -nocase "no" $action]} {
        # By definition, tcos will match if we extract them
        # and we always want to continue if we purposely don't extract
        set matched 1
    } elseif { [is_71] } {
        # If it's 7.1, always extract. Because of the check that happens
        # before check_extract_tcos is called, this won't be called
        # if it's 7.1 and TQ in the fitter.
        set matched 1
        set action "yes"
        # We can set the action to yes here because control will get here only
        # if action is auto or prompt, and it's 7.1. If it's auto or prompt,
        # we need to do the extraction anyway.
    } else {
        if { [catch {compare_tco} matched] } {
            return -code error $matched
        }
    }

    switch -exact -- $action {
        "yes" {
            post_message "Extracting tcos"
            # TODO check whether -e puts back in the dwz file
            if { [catch {run_dtw -project $opts(project) \
                -dwz_file $opts(dwz_file) -dtw_options "-e" } res] } {

                return -code error $res
            }
            post_message "Done extracting tcos"
            # TODO
#            if { [catch {
#                set_timing_model -model "slow" -run_analysis} res] } {
#
#                return -code error $res
#            }
        }
        "no" {
            post_message -type warning \
                "Skipping tco extraction. For more accurate results,\
                rerun the script with -extract_tcos auto"
        }
        "auto" {
            if { $matched } {
                post_message "Reported tCO values match tCO values in DWZ file"
            } else {
                post_message -type warning \
                    "Tco mismatch between reported and saved values."
                post_message "Extracting tcos"
                # TODO check whether -e puts back in the dwz file
                if { [catch {run_dtw -project $opts(project) \
                    -dwz_file $opts(dwz_file) -dtw_options "-e" } res] } {
    
                    return -code error $res
                }
                post_message "Done extracting tcos"
                set matched 1
            }
        }
        "prompt" {
            if { $matched } {
                post_message "Reported tCO values match tCO values in DWZ file"
            } else {
                post_message -type error \
                    "Tco mismatch between reported and saved values."
                post_message "For most accurate results, rerun the script with\
                    -extract_tcos auto"
                post_message "To ignore this issue, rerun the script with\
                    -extract_tcos no"
                return -code error "Stopping script"
            }
        }
        default {
            return -code error \
                "Value for -extract_tcos option must be yes/no/auto/prompt"
        }
    }

    return $matched
}

################################################################################
# Get tco time to determine whether to run extract tco's
# Assume that if at least one matches, they're all OK.
proc dtw_automation::compare_tco { args } {

    variable data_array
    variable pnl_str
    variable min_slack
    variable max_slack
    variable script_options

    set max_tco $min_slack
    set min_tco $max_slack
    set found_tco 0
    array set model_to_panel [list "slow" "tco" "fast" "Minimum tco"]
    array set model_to_dwz_var [list \
        "slow,min" "sys_clk_slow_min_tco" "slow,max" "sys_clk_max_tco" \
        "fast,min" "sys_clk_min_tco" "fast,max" "sys_clk_fast_max_tco" ]

    if {[string equal "combined_fast_and_slow" $data_array(timing_model)] } {
        set model "slow"
    } else {
        set model $data_array(timing_model)
    }

    # Create the set of ck/ck# outputs
    set ckckn_names [concat $data_array(ck_list) $data_array(ckn_list)]

    # Get tcos for them
    if { $script_options(uses_tan) } {
        # Get the tco panel ID if it's a TAN-based analysis
        if { [catch { build_report_panel_id -model $model \
            -analysis $model_to_panel($model)} panel_id] } {
    
            return -code error $panel_id
        }

        # Search for all ck/ck# tco values in the panel
        foreach clk $ckckn_names {
            if { [catch { get_slack_for_path -to_pattern $clk \
                -panel_id $panel_id -column_heading $pnl_str(actual_tco) } res] } {
                # The ck/ck# pin wasn't listed in the report
                return -code error $res
            } else {
                set found_tco 1
                if { $res > $max_tco } { set max_tco $res }
                if { $res < $min_tco } { set min_tco $res }
            }
        }
    } elseif { $script_options(uses_tq) } {

        # TimeQuest analysis.
        # Get the tCO from the data arrival time to the pin.
        # tCO is data arrival time - launch time
        # Unfortunately, the only way I know of to do that in 6.0 is
        # to parse the output of report_timing.
        set ckckn_list [list $ckckn_names]
        set num_outputs [llength $ckckn_names]
        if { [catch {
            init_tq -model "slow"} res] } { return -code error $res }
        set fn [clock format [clock seconds] -format "%I%M%S.tq"]

        if { [catch { eval_remote [concat report_timing -to $ckckn_list \
            -setup -npaths $num_outputs -file $fn] } res] } {
            catch { file delete $fn }
            return -code error $res
        }

        if { [catch {open $fn} fh] } {
            return -code error $fh
        }

        set state "find_data_arrival"
        while { [gets $fh line] >= 0 } {

            switch -exact -- $state {
                find_data_arrival {
                    if { [regexp {Data Arrival Time\s*\;\s*(-?[\.0-9]+)} $line \
                        -> arrival] } {
                        # found data arrival time
                        set state "find_launch_time"
                    }
                }
                find_launch_time {
                    if {[regexp {\;\s*(-?[\.0-9]+)\s*.*launch edge time} $line \
                        -> launch] } {
                        # found launch time. What's the tco?
                        set this_tco [expr { $arrival - $launch }]
                        if { $this_tco > $max_tco } { set max_tco $this_tco }
                        if { $this_tco < $min_tco } { set min_tco $this_tco }
                        set state "find_data_arrival"
                        set found_tco 1
                    }
                }
            }
        }
        catch {
            close $fh
            file delete $fn
        }
    }

    puts_debug "compare_tco: reported: $min_tco \
        saved: $data_array($model_to_dwz_var($model,min))"
    puts_debug "compare_tco: reported: $max_tco \
        saved: $data_array($model_to_dwz_var($model,max))"

    if { ! $found_tco } {
        return -code error "Can't find tco value for ck/ckn outputs"
    } else {
        return [expr {
            [string equal $min_tco [dtw_timing::get_ns \
            $data_array($model_to_dwz_var($model,min))]] || \
            [string equal $max_tco [dtw_timing::get_ns \
            $data_array($model_to_dwz_var($model,max))]] \
        } ]
    }
}

################################################################################
# The Classic timing analyzer can't handle some multicycle values
# The .dwz.tcl file includes a warning when that happens
# You must use the TimeQuest analyzer in those cases.
proc dtw_automation::multicycle_warning_exists { } {

    variable data_array

    if { [string equal "fast" $data_array(timing_model)] } {
        set file_name $data_array(fast_tcl_out_filename)
    } else {
        set file_name $data_array(tcl_out_filename)
    }

    # 7.1 and beyond use "." for the fast name
    if { [string equal "." $file_name] } {
        return 0
    }

    set exists 0

    if { [catch {open $file_name} fh] } {
        return -code error $fh
    }

    while { [gets $fh line] >= 0 } {
        if { [regexp -nocase {warning.*multicycle} $line] } {
            set exists 1
            break
        }
    }
    catch {
        close $fh
    }

    return $exists
}

################################################################################
# Extract some setting values from the timing analyzer report panel.
# Return an error message if they can't all be found, or 1 if they can
proc dtw_automation::get_timing_analyzer_settings { } {

    variable pnl_str
    variable tan_settings

    set number_of_settings_to_get [llength [array names tan_settings]]
    set settings_not_found [list]
    set tan_settings_panel_name [join [list \
        [timing_report_root] $pnl_str(timing_analyzer_settings)] "||"]
    set panel_id [get_report_panel_id $tan_settings_panel_name]
    if { -1 == $panel_id } {
        return -code error \
            "Can't find $pnl_str(timing_analyzer_settings) report panel"
    }
    set setting_index [get_report_panel_column_index -id $panel_id "Setting"]

    # Walk through each of the options we're looking for.
    foreach option [array names tan_settings] {
        if { [catch {
            get_report_panel_data -id $panel_id -row_name $pnl_str($option) \
                -col $setting_index } cell_data] } {

            # The option was not included in the table
            lappend settings_not_found $pnl_str($option)
        } else {
            set tan_settings($option) $cell_data
            incr number_of_settings_to_get -1
        }
    }
    
    if { 0 != $number_of_settings_to_get } {
        return -code error "Can't find the following settings in the\
            $pnl_str(timing_analyzer_settings) report panel:\
            [join $settings_not_found {,}]"
    } else {
        return 1
    }
}

################################################################################
# Tell what the root of the timing report is, based on whether you're using
# TimeQuest or not
proc dtw_automation::timing_report_root { } {
    variable pnl_str
    variable script_options

    if { $script_options(uses_tq_in_fitter) } {
        return $pnl_str(tq_timing_report_path)
    } else {
        return $pnl_str(timing_report_path)
    }
}

################################################################################
# Tell whether we have to start TimeQuest or not, based on whether or not
# a socket exists.
proc dtw_automation::tq_is_running { } {
    variable sock
    if { [string equal 0 $sock] } { return 0 } else { return 1 }
}


################################################################################
# Start the TimeQuest analyzer. The TimeQuest analyzer runs a simple socket
# accept and listen script that accepts and evaluates commands and returns
# the results.
proc dtw_automation::start_tq { } {

    variable sock
    variable script_options

    # Write out the listener file that quartus_sta runs
    file delete sta_runner.tcl

    if { [catch {open sta_runner.tcl w} fh] } {
        return -code error $fh
    } else {

        # This is a short script that gets dumped out to a file.
        puts $fh {
        proc accept { sock addr port } {

            post_message "Accept $sock from $addr port $port"
            fconfigure $sock -buffering line
            fileevent $sock readable [list handle_input $sock]
        }

        proc handle_input { sock } {

            global ev errorInfo errorCode quit

            if { [eof $sock] } {
                close $sock
            } else {
                gets $sock line
                append ev $line\n
                if { [string length $ev] && [info complete $ev] } {
                    if { [string equal $ev "quit\n"] } {
                        set quit 1
                        set reply [list "ok" "" 0 0]
                        set lines 1
                    } else {
                        #puts $ev
                        set code [ catch { uplevel #0 $ev} res]
                        set reply [list $code $res $errorInfo $errorCode]\n
                        set lines [regsub -all \n $reply {} junk]
                    }
            
                    puts $sock $lines
                    puts -nonewline $sock $reply
                    flush $sock
                    set ev {}
                }
            }
        }

        # Return a list of SDC clock IDs
        proc get_ids { } {
            set foo [list]
            foreach_in_collection clk_id [get_clocks] {
                lappend foo $clk_id
            }
            return $foo
        }

        proc get_clk_inversions { args } {
            set col [eval get_timing_paths $args]
            foreach_in_collection path $col { }
            return [list \
                [get_path_info -from_clock_is_inverted $path] \
                [get_path_info -to_clock_is_inverted $path] \
                [get_clock_info -period [get_path_info -to_clock $path]]]
        }

        set quit 0
        if { [catch {socket -server accept 2345} server] } {
            post_message -type error $server
        } else {
            vwait quit
        }
        }
        # End of the script
        close $fh
    }

    # Kick off quartus_sta with the listener Tcl script
    if { [catch {exec quartus_sta -t sta_runner.tcl & } res] } {
        return -code error $res
    }

    set seconds $script_options(tq_timeout)

    # Wait for some number of seconds for the TimeQuest analyzer to start
    while { [string equal 0 $sock] && 0 < $seconds } {

        if { [catch {socket 127.0.0.1 2345} sock] } {
            # Sleep for 1 second
            set sock 0
            post_message \
                "Waiting $seconds seconds for the TimeQuest analyzer to start"
            after 1000
            incr seconds -1
        } else {
            post_message "Successfully started the TimeQuest analyzer"
        }
    }

    if { [string equal 0 $sock] } {
        return -code error "Could not start the TimeQuest analyzer"
    } else {
        return 1
    }
}

################################################################################
# Prepare a netlist in the TimeQuest analyzer with a given timing model.
proc dtw_automation::init_tq { args } {

    set options {
        { "model.arg" "" "Fast model or slow model?" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable data_array
    variable pnl_str
    variable script_options

    post_message "Wait while the netlist is prepared in the TimeQuest analyzer"

    # Attempt to get the netlist all ready
    if { [catch {

        # Open the project if it's not open
        if { ![eval_remote is_project_open] } {
            eval_remote project_open [file tail $data_array(project_path)] \
                -revision $data_array(project_revision)
        }

        # Remove the netlist if one exists
        if { [eval_remote timing_netlist_exist] } {
            eval_remote delete_timing_netlist
        }

        # Create it with fast model if necessary
        post_message "Preparing netlist with $opts(model) model"
        if { [string equal "fast" $opts(model)] } {
            eval_remote create_timing_netlist -fast_model
        } else {
            eval_remote create_timing_netlist
        }

        # Read the sdc file and update the netlist
        switch -exact -- $script_options(sdc_file) {
            "auto" {
                # If you use TimeQuest in the fitter, assume you know exactly
                #  what you're doing, and read whatever SDC files you set
                # Else... you use TAN in the fitter
                # If it's combined fast and slow, always read the same
                #  SDC file regardless of what model we're using for the netlist
                # Else... it's not combined fast and slow.
                # If it's fast, use the fast SDC file
                # Otherwise, use the slow SDC file
                if { $script_options(uses_tq_in_fitter) } {
                    eval_remote read_sdc
                } elseif { [string equal "combined_fast_and_slow" $data_array(timing_model)] } {
                    eval_remote post_message "Reading [file tail $data_array(sdc_filename)]"
                    eval_remote read_sdc [file tail $data_array(sdc_filename)]
                } elseif { [string equal "fast" $opts(model)] } {
                    # Fast model netlist requires fast constraints
                    eval_remote post_message "Reading [file tail $data_array(fast_sdc_filename)]"
                    eval_remote read_sdc [file tail $data_array(fast_sdc_filename)]
                } else {
                    eval_remote post_message "Reading [file tail $data_array(sdc_filename)]"
                    eval_remote read_sdc [file tail $data_array(sdc_filename)]
                }
            }
            "dwz" {
                # You get the SDC file names from what's specified in the DWZ
                # If you use combined fast and slow, always read the same SDC
                #  file regardless of what model we're using for the netlist
                # Else... it's not combined fast and slow
                # If it's fast, use the fast SDC file
                # Otherwise, use the slow SDC file
                if { [string equal "combined_fast_and_slow" $data_array(timing_model)] } {
                    eval_remote post_message "Reading [file tail $data_array(sdc_filename)]"
                    eval_remote read_sdc [file tail $data_array(sdc_filename)]
                } elseif { [string equal "fast" $opts(model)] } {
                    # Fast model netlist requires fast constraints
                    eval_remote post_message "Reading [file tail $data_array(fast_sdc_filename)]"
                    eval_remote read_sdc [file tail $data_array(fast_sdc_filename)]
                } else {
                    eval_remote post_message "Reading [file tail $data_array(sdc_filename)]"
                    eval_remote read_sdc [file tail $data_array(sdc_filename)]
                }
            }
            "project" { eval_remote read_sdc }
            default {
                if { [file exists $script_options(sdc_file)] } {
                    eval_remote post_message "Reading $script_options(sdc_file)"
                    eval_remote read_sdc $script_options(sdc_file)
                } else {
                    post_message -type warning "Could not find SDC file $script_options(sdc_file)"
                    return -code error "sdc_file options must be auto/dwz/project/<file name>"
                }
            }
        }

        # Allow another SDC file to be read to fix DTW SDC stuff
        if { ![string equal "" $script_options(last_sdc_file)] } {
            eval_remote read_sdc $script_options(last_sdc_file)
        }

        eval_remote update_timing_netlist

    } res] } {
        # There were errors getting the netlist ready
        return -code error $res
    } else {
        # Everything's ready
        post_message "Done preparing the netlist in the TimeQuest analyzer"
        return 1
    }
}

################################################################################
# Sends the command to quit the TimeQuest interpreter
proc dtw_automation::quit_tq { } {

    variable sock

    if { ![string equal 0 $sock] && [catch {
        
        # Remove the netlist if one exists
        if { [eval_remote timing_netlist_exist] } {
            eval_remote delete_timing_netlist
        }
        if { [eval eval_remote is_project_open] } {
            eval_remote project_close
        }
        eval_remote post_message "Quitting TimeQuest"
        eval_remote quit
        close $sock
        set sock 0
        catch { file delete sta_runner.tcl }
    } res] } {
        post_message -type error $res
    }
}

################################################################################
# From Welsh's book Practical Programming in Tcl and Tk
proc dtw_automation::eval_remote { args } {

    variable sock

    if { [llength $args] > 1 } {
        set cmd [concat $args]
    } else {
        set cmd [lindex $args 0]
    }

    puts_debug $cmd

    puts $sock $cmd
    flush $sock

    # read the lines back
    gets $sock lines
    set result {}
    while {$lines > 0} {
        gets $sock x
        append result $x\n
        incr lines -1
    }
    set code [lindex $result 0]
    set x [lindex $result 1]
    regsub "\[^\n]+$" [lindex $result 2] "remote server" stack
    set ec [lindex $result 3]
    return -code $code -errorinfo $stack -errorcode $ec $x
}

################################################################################
proc dtw_automation::get_tq_clock_info { } {

    variable tq_clock_info

    set clk_ids [eval_remote get_ids]

    foreach clk_id $clk_ids {
        set clk_name [eval_remote get_clock_info -name $clk_id]
        set tq_clock_info($clk_name,period) [eval_remote get_clock_info -period $clk_id]
        set tq_clock_info($clk_name,mult) [eval_remote get_clock_info -multiply_by $clk_id]
        set tq_clock_info($clk_name,div) [eval_remote get_clock_info -divide_by $clk_id]
        set tq_clock_info($clk_name,master) [eval_remote get_clock_info -master_clock $clk_id]
    }
}

################################################################################
proc dtw_automation::compare_clock_transfer_periods { } {

    variable tq_clock_info
    variable clock_transfers

    foreach src_clk [array names clock_transfers] {
        set dest_clk $clock_transfers($src_clk)
        set src_period $tq_clock_info($src_clk,period)
        set dest_period $tq_clock_info($dest_clk,period)

        puts_debug "compare_clock_transfer_periods"
        puts_debug "\t$src_clk\t$src_period"
        puts_debug "\t$dest_clk\t$dest_period"

        if { [string equal $src_period $dest_period] } {
            # If the periods are the same, we don't want to see them again.
            unset clock_transfers($src_clk)
        } else {
            set difference [expr { abs( $src_period - $dest_period ) }]
            set percent_difference [expr { 100 * $difference / $dest_period } ]

            # If the difference is greater than 5%,
            # we don't want to see them again.
            if { 5.0000 < $percent_difference } {
                unset clock_transfers($src_clk)
            }
        }
    }
}

################################################################################
proc dtw_automation::get_total { args } {

    set options {
        { "clk_name.arg" "" "Clock name" }
        { "info.arg" "" "What info do you want to get? cycle/phase" }
    }
    array set opts [::cmdline::getoptions args $options]

    upvar 1 $opts(clk_name) timing_data

    switch -exact -- $opts(info) {
        "cycle" {
            set temp [expr {$timing_data(current_cycle) + $timing_data(cycle_adjust)}]
            if { [info exists timing_data(phase_normalized_cycle_adjust)] } {
                incr temp $timing_data(phase_normalized_cycle_adjust)
            }
            return $temp
        }
        "phase" { return [expr {$timing_data(current_phase) + $timing_data(phase_adjust)}]}
        default { return -code error "get_total: unknown info: $opts(info)" }
    }
}

################################################################################
proc dtw_automation::control { args } {

    set options {
        { "project.arg" "" "Project name" }
        { "dwz_file.arg" "" "DWZ file name" }
        { "tool.arg" "tanrpt" "The tool to use for timing analysis"}
        { "read_side.arg" "tanrpt" "Do read-side? tanrpt/tantcl/tq/skip" }
        { "write_side.arg" "tq" "Do write-side? tanrpt/tantcl/tq/skip" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable pnl_str
    variable data_array
    variable script_options
    variable clk_to_analyses
    variable read_clks_${script_options(mem_type_dqs_pll_mode)}
    variable read_clks_rec_${script_options(mem_type_dqs_pll_mode)}
    variable write_clks_${data_array(memory_type)}
    upvar 0 read_clks_${script_options(mem_type_dqs_pll_mode)} read_clks
    upvar 0 read_clks_rec_${script_options(mem_type_dqs_pll_mode)} read_clks_rec
    upvar 0 write_clks_${data_array(memory_type)} write_clks

    set half_period [expr { $script_options(period) / 2 }]

    # Some timing analysis has been run right before this script.
    # It could be separate fast, separate slow, or combined
    # I have to know which it was to determine which data to get
    # and how to store it. I then might have to change constraints
    # and rerun TAN. Regardless, I have to then do the other model.
    # There's also the issue of DDR frequency and recommendations
    # for separate fast/slow or combined.
    if { [catch {get_analysis_corner_order -model $data_array(timing_model) } res] } {
        return -code error $res
    } else {
        foreach { first_model second_model } $res { break }
    }

    # Start timequest if necessary
    # If it's used in the extraction...
    if { $script_options(uses_tq) } {
        # Set up the timing netlist because it has to be used
        # for read or write.
        if { [catch {
            init_tq -model $first_model} res] } { return -code error $res }
        get_tq_clock_info
    }

    post_message "Starting timing extraction from $first_model model data"

    # Do read analysis if we're not skipping the read side.
    if { [process_side $opts(read_side)] } {
        foreach { clk unused } $read_clks {
            eval unified_extract -model $first_model -result_variable_name $clk \
                -analyses [list $clk_to_analyses($clk)] -tool $opts(read_side) \
                [get_u_e_opts -clk_name $clk -read_side $opts(read_side)]
        }
    }

    # Do write analysis if we're not skipping the write side.
    if { [process_side $opts(write_side)] } {
        foreach { clk unused } $write_clks {
            eval unified_extract -model $first_model -result_variable_name $clk \
                -analyses [list $clk_to_analyses($clk)] -tool $opts(write_side) \
                [get_u_e_opts -clk_name $clk -write_side $opts(write_side) ]
        }
    }


    # Now use the opposite model
    post_message "Finished timing extraction from $first_model model data"
    set_timing_model -model $second_model -run_analysis
    post_message "Starting timing extraction from $second_model model data"

    # Switch TimeQuest if necessary
    if { $script_options(uses_tq) } {
        if { [catch {
            init_tq -model $second_model } res] } { return -code error $res }
    }

    # Do read analysis if we're not skipping the read side.
    if { [process_side $opts(read_side)] } {
        foreach { clk unused } $read_clks {
            eval unified_extract -model $second_model -result_variable_name $clk \
                -analyses [list $clk_to_analyses($clk)] -tool $opts(read_side) \
                [get_u_e_opts -clk_name $clk -read_side $opts(read_side)]
        }
    }

    # Do write analysis if we're not skipping the write side.
    if { [process_side $opts(write_side)] } {
        foreach { clk unused } $write_clks {
            eval unified_extract -model $second_model -result_variable_name $clk \
                -analyses [list $clk_to_analyses($clk)] -tool $opts(write_side) \
                [get_u_e_opts -clk_name $clk -write_side $opts(write_side) ]
        }
    }

    post_message "Finished timing extraction from $second_model model data"
    set_timing_model -model $first_model -run_analysis

    # Do read analysis if we're not skipping the read side.
    if { [process_side $opts(read_side)] } {

        foreach { clk unused } $read_clks {
        
            # It's possible that postamble might not be used
            if { [string equal "clk_read_postamble" $clk] && ! $data_array(use_postamble) } {
                continue
            }
            
            calculate_min_and_abs_max -clk_variable_name $clk \
                -analyses_mults $clk_to_analyses($clk)
            calculate_total_margin -clk_variable_name $clk \
                -analyses $clk_to_analyses($clk)
            calculate_absolute_time -clk_variable_name $clk \
                -all_clk_info [array get read_clks_rec]
        }
        
#        puts_debug "clk_read_postamble(current_phase) is $clk_read_postamble(current_phase)"
    }

    # A big part of the read-side happens only for DDR memory
    if { [process_side $opts(read_side)] && $script_options(is_ddr) } {

        # Calculate how far the PLL has to go to balance setup and hold slacks.
        # clk_resync is always used.
        set clk_resync(shift_time) [expr {
            ( $clk_resync(hold,min) - $clk_resync(setup,min) ) / 2 } ]
        set clk_resync(rec_time) [expr {
            $clk_resync(abs_time) + $clk_resync(shift_time) } ]
        puts_debug "control: clk_resync(rec_time) is $clk_resync(abs_time) +\
            $clk_resync(shift_time) = $clk_resync(rec_time)"
            
        # The clk_resync2 calculation cascades from the value of the clk_resync
        # calculation in 2 PLL mode. 
        # clk_resync2 is used only in the 2 PLL mode.
        if { $data_array(is_clk_fedback_in) } {
            set clk_resync2(shift_time) [expr {
                ( $clk_resync2(hold,min) - $clk_resync2(setup,min) ) / 2 } ]
            set clk_resync2(rec_time) [expr {
                $clk_resync2(abs_time) + $clk_resync2(shift_time) + \
                $clk_resync(shift_time) } ]
            puts_debug "control: clk_resync2(rec_time) is $clk_resync2(abs_time) +\
                $clk_resync2(shift_time) + $clk_resync(shift_time) = $clk_resync2(rec_time)"
        }

        # Using DQS and postamble means there's recovery/removal stuff to do
        # Do it regardless of the state of fedback in
        # Using postamble implies using DQS
        # Calculate how much the clk_read_postamble must shift to
        # balance the recovery/removal slacks.
        if { $data_array(use_hardware_dqs) && $data_array(use_postamble) } {
            set clk_read_postamble(shift_time) [expr {
                ($dqs_clock(recovery,min) - $dqs_clock(removal,min)) / 2 } ]
            set clk_read_postamble(rec_time) [expr {
                $clk_read_postamble(abs_time) + $clk_read_postamble(shift_time)}]
            puts_debug "control: clk_read_postamble(rec_time) is $clk_read_postamble(abs_time) +\
                $clk_read_postamble(shift_time) = $clk_read_postamble(rec_time)"
        }

        # Using postamble implies you're also using DQS
        if { $data_array(is_clk_fedback_in) && $data_array(use_postamble) } {

            # The phase shift is the existing inter_postamble_phase
            # Put it in clk_dqs_out because that's the PLL name that
            # gets pointed to in the read_clks_rec array.
            # Later on in the reporting part, having this in clk_dqs_out
            # makes things really easy.
            # inter_postamble_phase occurs when you have fedback and postamble
            regexp -- {([\-\d]+)} $data_array(inter_postamble_phase) -> \
                clk_dqs_out(current_phase)

            # what would balance doing_rd_delayed slacks?
            # shift_time is the amount it's been shifted already to meet rec/rem
            # system postamble launches at clk_dqs_out(abs_time)
            # How much do I shift to balance the doing_rd_delayed slacks?
            # (hold - setup)/2 is the shift amount if we're shifting the
            # destination register. Because we are moving the source reg,
            # it's  (setup - hold)/2
            set clk_dqs_out(shift_time) [expr {
                ( $clk_read_postamble(setup,min) - $clk_read_postamble(hold,min) ) / 2 } ]
            set clk_dqs_out(rec_time) [expr {
                $clk_dqs_out(abs_time) + $clk_dqs_out(shift_time) \
                + $clk_read_postamble(shift_time)} ]
            puts_debug "control: clk_dqs_out(rec_time) is $clk_dqs_out(abs_time) +\
                $clk_dqs_out(shift_time) + $clk_read_postamble(shift_time) = $clk_dqs_out(rec_time)"

            # doing_rd_delayed can launch on positive or negative clock edges
            # So it can launch at 0 or 180. Take the recommended time
            # and figure out what whole and half cycle it is closest to
            # The clock edges are 0/180 or 0/-180 depending on software version
            # That requires a +half cycle or -half cycle, which is accommodated by plus_minus
            set exact_cycle [expr { $clk_dqs_out(rec_time) / double( $script_options(period) ) } ]
            set whole_cycle [expr { int($exact_cycle) } ]
            set fractional_cycle [expr { $exact_cycle - $whole_cycle } ]
            set half_cycle_adder 0
            set plus_minus [sign [inter_postamble_phase]]
            
            # If the fractional part is within a quarter cycle, stay at 0/+1 cycle
            # If the fractional part is in the middle 2 quarters, go to +/-180
            if { $fractional_cycle < 0.25 } {
                set part_of_cycle "current"
            } elseif { $fractional_cycle >= 0.75 } {
                set part_of_cycle "next"
            } else {
                set part_of_cycle "middle"
                set half_cycle_adder [expr { $plus_minus * 0.5 } ]
            }
            
            # Calculate new phase for clk_dqs_out, and the correct cycle number
            # based on whether it's + or - 180 adjustment, and the specified
            # places for the cycle position.
            # Set the phase value so it doesn't have to be calculated later
            switch -exact -- $part_of_cycle {
            "current" {
                # This cycle and 0 degrees
                set clk_dqs_out(new_phase) 0
            }
            "next" {
                # Next cycle and 0 degrees
                set clk_dqs_out(new_phase) 0
                incr whole_cycle
            }
            "middle" {
                # Next cycle and +/-180 degrees
                # If this is the version with 0/-180, to get in the middle
                # requires going to the next cycle because the sign of the
                # 180 is negative.
                set clk_dqs_out(new_phase) [expr { $plus_minus * 180 } ]
                if { -1 == $plus_minus } { incr whole_cycle }
            }
            }
            set margin_cycle [expr { $whole_cycle + $half_cycle_adder } ]
            
            # Now figure out whether anything should be done about margin
            # We might be able to improve the doing_rd_delayed timing
            # at the expense of clk_read_postamble. To check this,
            # multiply the whole/half cycle count by the period,
            # and see if it falls within the margin range.
            # If so, shift clk_read_postamble rec_time by the appropriate amount
            # ns is the default units for the margin calculation
            foreach { margin_value margin_units } $script_options(r_r_margin_tradeoff) { break }
            switch -exact -- $margin_units {
                "%" { set margin_value [expr { $dqs_clock(min_value) * $margin_value / 100 } ] }
                "ps" { set margin_value [dtw_timing::get_ns $script_options(r_r_margin_tradeoff) ] }
            }

            post_message "Allowing +/- [format {%.3f} $margin_value] ns\
                on Recovery/Removal margin to improve Postamble margin"

            set margin_check_time [expr { $script_options(period) * $margin_cycle } ]
            set high_window_edge [expr {$clk_read_postamble(rec_time) + $margin_value }]
            set low_window_edge [expr {$clk_read_postamble(rec_time) - $margin_value }]
            
            puts_debug "control: clk_read_postamble(rec_time) $clk_read_postamble(rec_time)"
            puts_debug "control: low window: $low_window_edge high window: $high_window_edge"
            puts_debug "control: time for margin check: $margin_check_time"
            
            if { $margin_check_time >= $low_window_edge && \
                $margin_check_time <= $high_window_edge } {
                # It's in the window. If it's in the window, we can set the
                # exact requested value, based on the difference between
                # the recommended time and the margin check time
                set clk_read_postamble(rec_time) [expr {
                    $clk_read_postamble(rec_time) + \
                    ( $clk_read_postamble(rec_time) - $margin_check_time ) } ]
            } elseif {$margin_check_time > $high_window_edge} {
                # It's outside the high end of the window
                set clk_read_postamble(rec_time) $high_window_edge
            } else {
                # It's outside the low end of the window
                set clk_read_postamble(rec_time) $low_window_edge
            }

            puts_debug "control: new clk_read_postamble(rec_time) $clk_read_postamble(rec_time)"
            puts_debug "control: position: $part_of_cycle cycle: $whole_cycle $fractional_cycle"
            puts_debug "control: margin_cycle: $margin_cycle"

            # Force the cycle value so it doesn't have to be calculated later            
            set clk_dqs_out(new_cycle) $whole_cycle
            puts_debug "control: calculated clk_dqs_out cycle: $clk_dqs_out(new_cycle) and phase $clk_dqs_out(new_phase)"
            
            if { $clk_dqs_out(current_phase) != $clk_dqs_out(new_phase) } {
                # Set a flag to say we flipped. Use in the "next steps" report
                set clk_dqs_out(flip) 1
            }
                       
        }

        # If we're doing postamble,
        # We still have to compute a clock shift for the dqs_clock.
        # You can get 0/90/180/270 shifts for free in the MegaWizard,
        # or set a specific shift if you use a separate PLL tap
#        if { $data_array(use_postamble) } {
#            calculate_phase_adjust -clk_name "clk_read_postamble" \
#                -normalize_min 0 -normalize_max 360
#            incr clk_read_postamble(cycle_adjust) [calculate_phase_adjust \
#                -clk_name "clk_read_postamble"]
#        }


    } elseif { [process_side $opts(read_side)] && ! $script_options(is_ddr) && \
        ! $data_array(use_hardware_dqs) } {

        # RLDRAM and QDR non-DQS get phase shifts on the read-side
        foreach { clk unused } $read_clks {
            upvar 0 $clk timing_data
            calculate_min_and_abs_max -clk_variable_name $clk \
                -analyses_mults $clk_to_analyses($clk)
            calculate_total_margin -clk_variable_name $clk \
                -analyses $clk_to_analyses($clk)
            set timing_data(delta_delay) \
                [expr {( $timing_data(hold,min) - $timing_data(setup,min) ) /2} ]
            calculate_phase_adjust -clk_name $clk
        }
    }

    # Do write analysis if we're not skipping the write side.
    if { [process_side $opts(write_side)] } {

        foreach { clk unused } $write_clks {
            calculate_min_and_abs_max -clk_variable_name $clk \
                -analyses_mults $clk_to_analyses($clk)
            calculate_total_margin -clk_variable_name $clk \
                -analyses $clk_to_analyses($clk)
#            -analyses [list mdas]
        }

        # Compute delta delays
        foreach { clk unused } $write_clks {
            upvar 0 $clk w_clk
            set w_clk(delta_delay) \
                [expr { ( $w_clk(hold,min) - $w_clk(setup,min) ) / 2} ]
            # Special case for address/command output
            if { [string equal "clk_addr_ctrl_out" $clk] } {
                set w_clk(delta_delay) [expr { -1 * $w_clk(delta_delay) } ]
            }
            calculate_phase_adjust -clk_name $clk -write_side
        }
    }

    compare_clock_transfer_periods

    report1 -read_side $opts(read_side) -write_side $opts(write_side)

    write_vwf -read_side $opts(read_side) -write_side $opts(write_side)
}

################################################################################
proc dtw_automation::get_analysis_corner_order { args } {

    set options {
        { "model.arg" "" "Timing model" }
    }

    array set opts [::cmdline::getoptions args $options]
    variable script_options

    switch -exact -- $opts(model) {
        combined_fast_and_slow {
            set order [list "slow" "fast"]
            if { $script_options(uses_tan) } {
                if { ![is_on "do_combined_analysis"] } {
                    return -code error "DTW constraints are for the\
                        combined fast/slow model, but the last timing analysis\
                        was not a combined analysis.\
                        Make constraints and analysis match."
                }
                if { [is_on "use_fast_timing_models"] } {
                    return -code error "DTW constraints are for the\
                        combined fast/slow model, but the last timing analysis\
                        was with fast model.\
                        Make constraints and analysis match."
                }
            }
        }
        slow {
            set order [list "slow" "fast"]
            if { $script_options(uses_tan) } {
                if { [is_on "use_fast_timing_models"] } {
                    return -code error "DTW constraints are for slow model,\
                        but the last timing analysis was with fast model.\
                        Make constraints and analysis match."
                }
                if { [is_on "do_combined_analysis"] } {
                    return -code error "DTW constraints are for slow model,\
                        but the last timing analysis was with combined models.\
                        Make constraints and analysis match."
                }
            }
        }
        fast {
            set order [list "fast" "slow"]
            if { $script_options(uses_tan) } {
                if { ! [is_on "use_fast_timing_models"] } {
                    return -code error "DTW constraints are for fast model,\
                        but the last timing analysis was with slow model.\
                        Make constraints and analysis match."
                }
                if { [is_on "do_combined_analysis"] } {
                    return -code error "DTW constraints are for fast model,\
                        but the last timing analysis was with combined models.\
                        Make constraints and analysis match."
                }
            }
        }
        separate_slow_and_fast {
            # New in 7.1
            set order [list "slow" "fast"]
        }
        default { return -code error "A valid timing model is not specified:\
            $opts(model)" }
    }

    return $order
}

################################################################################
proc dtw_automation::apply_extra_write_constraints { args } {

    set options {
        { "clk_name.arg" "" "Name of the clock" }
        { "tool.arg" "" "TAN/TQ/etc" }
    }

    array set opts [::cmdline::getoptions args $options]
    variable script_options
    variable data_array

    # First time through doesn't get -add_delay
    set add ""
    switch -exact -- $opts(clk_name) {
        clk_sys {
            set to [listify -collection get_ports -target $data_array(dqs_list)]
            # TODO - ckn_list
            foreach ck_item $data_array(ck_list) {
                set ck [listify -collection get_clocks -target $ck_item]
                send_tq_command set_output_delay -clock $ck \
                    -max $script_options(period) $to $add
                set add "-add_delay"
                send_tq_command set_output_delay -clock $ck -min 0 $to $add
           }
            }
        clk_dq_out {
            # Get the list of dq pins
            # TODO - what about dm pins?
            set dq_pins [list]
            foreach { dqs dq_list } $data_array(dqs_dq_list) {
                set dq_pins [concat $dq_pins $dq_list]
            }
            set to [listify -collection get_ports -target $dq_pins]
            foreach dqs_item $data_array(dqs_list) {
                set ck [listify -collection get_clocks -target $dqs_item]
                send_tq_command set_output_delay -clock $ck \
                    -max $script_options(period) $to $add
                set add "-add_delay"
                send_tq_command set_output_delay -clock $ck -min 0 $to $add
            }
            }
        clk_addr_ctrl_out {

            if { $script_options(is_ddr) } {
                set addr_ctrl $data_array(addr_ctrl_list)
            } else {
                set addr_ctrl [list \
                    [concat $data_array(addr_list) $data_array(ctrl_list)]]
            }
            set to [listify -collection get_ports -target $addr_ctrl]
            # TODO - ckn_list
            foreach ck_item $data_array(ck_list) {
                set ck [listify -collection get_clocks -target $ck_item]
                send_tq_command set_output_delay -clock $ck \
                    -max $script_options(period) $to $add
                set add "-add_delay"
                send_tq_command set_output_delay -clock $ck -min 0 $to $add
            }
            }
        default {
            post_message -type error "Unknown clock $opts(clk_name)"
        }
    }

    eval_remote update_timing_netlist
}

################################################################################
proc dtw_automation::unified_extract { args } {

    set options {
        { "model.arg" "" "Fast model or slow model?" }
        { "result_variable_name.arg" "" "One result variable name"}
        { "analyses.arg" "" "setup/hold, recovery/removal" }
        { "from.arg" "*" "Path source" }
        { "to.arg" "*" "Path destination" }
        { "tool.arg" "" "TAN report, TAN shell, STA"}
        { "to_clk.arg" "" "Clock names to report for" }
        { "from_clk.arg" "*" "Source clock name or pattern" }
        { "tan_io_check" "The panel build pays attention to io reporting" }
    }

    array set opts [::cmdline::getoptions args $options]
    variable max_slack
    variable analysis_options
    variable data_array
    
    # It's possible that postamble might not be used
    if { [string equal "clk_read_postamble" $opts(result_variable_name)] && ! $data_array(use_postamble) } {
        return
    }
    if { [string equal "dqs_clock" $opts(result_variable_name)] && ! $data_array(use_postamble) } {
        set opts(from) "*"
    }
    
    upvar 1 $opts(result_variable_name) timing_data

    # Go through setup/hold or recovery removal analysis
    foreach { analysis unused } $opts(analyses) {

        # Get the name or option that will be used
        set analysis_option $analysis_options($analysis,$opts(tool))
        set timing_data($opts(model),$analysis,max_slack) $max_slack

        switch -exact -- $opts(tool) {
        tq {

            # Start assembling the command.
            set cmd [list get_tq_slack_for_path $analysis_option \
                -from $opts(from) -from_clock $opts(from_clk) \
                -to $opts(to) -npaths 1]

            # Add the destination clock if necessary
            if { 0 < [llength $opts(to_clk)] } {
                lappend cmd "-to_clock" $opts(to_clk)
            }

            set path_slack [eval $cmd]

            set timing_data($opts(model),$analysis,$opts(from),$opts(to),slack) \
                $path_slack
            if { $path_slack < $timing_data($opts(model),$analysis,max_slack) } {
                set timing_data($opts(model),$analysis,max_slack) $path_slack
            }
        }
        tanrpt {
            # Get from the tan report
            if { 0 == [llength $opts(to_clk)] } {
                if { [catch {
                    build_report_panel_id -model $opts(model)
                    -analysis $analysis_option \
                    -tan_io_check $opts(tan_io_check)} panel_id] } {

                    post_message -type warning $panel_id
                    post_message -type warning "Defaulting to slack value of 0"
                    set path_slack 0
                } elseif { [catch {
                    get_slack_for_path -panel_id $panel_id \
                    -from_pattern $opts(from) -to_pattern $opts(to) \
                    -from_clk $opts(from_clk) } path_slack] } {
                    post_message -type warning $path_slack
                    post_message -type warning "Defaulting to slack value of 0"
                    set path_slack 0
                }
                set timing_data($opts(model),$analysis,max_slack) $path_slack
            } else {
                foreach clk $opts(to_clk) {
                    if { [catch {
                        build_report_panel_id -model $opts(model) \
                        -analysis $analysis_option -clk_name $clk \
                        -tan_io_check $opts(tan_io_check)} panel_id] } {

                        post_message -type warning $panel_id
                        post_message -type warning \
                            "Defaulting to slack value of 0"
                        set path_slack 0
                    } elseif { [catch {
                        get_slack_for_path -panel_id $panel_id \
                        -from_pattern $opts(from) -to_pattern $opts(to) \
                        -from_clk $opts(from_clk) } path_slack] } {
                        post_message -type warning $path_slack
                        post_message -type warning "Defaulting to slack value of 0"
                        set path_slack 0
                    }
                    set timing_data($opts(model),$analysis,$clk,slack) \
                        $path_slack
                    if { $path_slack < \
                        $timing_data($opts(model),$analysis,max_slack) } {
                        set timing_data($opts(model),$analysis,max_slack) \
                            $path_slack
                    }
                }
            }
        }
        }
        puts_debug "unified_extract: $opts(result_variable_name),$opts(model),\
            $analysis $timing_data($opts(model),$analysis,max_slack)"
    }
}

################################################################################
proc dtw_automation::listify { args } {

    set options {
        { "collection.arg" "" "Collection to use for TimeQuest" }
        { "target.arg" "" "Collection target" }
        { "tool.arg" "" "Are we using TimeQuest or Classic?" }
    }
    array set opts [::cmdline::getoptions args $options]

    if { [string equal "tq" $opts(tool)] } {
        return [list [list $opts(collection) $opts(target)]]
    } else {
        return $opts(target)
    }
}

################################################################################
proc dtw_automation::get_u_e_opts { args } {

    set options {
        { "clk_name.arg" "" "Clock to get options for" }
        { "read_side.arg" "tanrpt" "Do read-side? tanrpt/tantcl/tq/skip" }
        { "write_side.arg" "tq" "Do write-side? tanrpt/tantcl/tq/skip" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable data_array
    variable script_options
    variable clock_transfers
    set u_e_opts ""
    array set u_e_vals [list]

    # Have to try to get a list of the input pins.
    # Use input pins with read_cap when hardware DQS is used.
    # Use input pins with clk_resync when hardware DQS is not used.
#    if {([string equal "read_cap" $opts(clk_name)] && \
#            $data_array(use_hardware_dqs) ) || \
#        ([string equal "clk_resync" $opts(clk_name)] && \
#            !$data_array(use_hardware_dqs) ) } {
#
#        array set temp $data_array(dqs_dq_list)
#        set first_dqs [lindex [array names temp] 0]
#        set first_dq [lindex $temp($first_dqs) 0]
#        if { ![regsub {(.*)\[\d+\]} $first_dq {\1*} dq_pattern] } {
#            post_message -type warning "Can't create a match pattern for \
#                DQ pins. Defaulting to * pattern for input pin pattern"
#            set dq_pattern "*"
#        }
#
#    }

    # Put together appropriate options for each clock
    switch -exact -- $opts(clk_name) {
        read_cap {

            # If IO paths are reported separately in TAN,
            # there is no need to use a from filter, because the paths
            # are from only IOs in the panel. If IO paths are not
            # reported separately, you must use a from filter with the
            # DQ pin name pattern in it. TODO
            
            # from used to have $dq_pattern for -target
            # For read cap, the "dqs pins" are always in the dqs_list
            # entry in the data array
            set u_e_vals(-from) [listify -collection get_ports \
                -target [make_pin_patterns -pins [get_dq_pins \
                -dqs_pins $data_array(dqs_list)]] -tool $opts(read_side)]
            set u_e_vals(-to) [listify -collection get_registers \
                -target $script_options(name_filter) -tool $opts(read_side)]
            set u_e_vals(-tan_io_check) ""

            # If we're in 71, and TQ is turned on in the fitter, or read-side
            # analysis is happening with TQ, use the TQ names :-)
            if { [is_71] && $script_options(is_ddr) && \
                ( $script_options(uses_tq_in_fitter) || \
                [string equal "tq" $opts(read_side)] ) } {
                # Different for TimeQuest in 7.1
                # combination of ck/ckn pin names and dqs pin names
                set to_clk_list [list]
                set ck_ckn_patterns [make_pin_patterns \
                    -pins [concat $data_array(ck_list) $data_array(ckn_list) ] ]
                set dqs_patterns [make_pin_patterns -pins $data_array(dqs_list) ]
                foreach ck_ckn_pattern $ck_ckn_patterns {
                    foreach dqs_pattern $dqs_patterns {
                        lappend to_clk_list ${ck_ckn_pattern}${dqs_pattern} dtw_read_${dqs_pattern}
                    }
                }
                set u_e_vals(-to_clk) [list $to_clk_list]
                
            } elseif { [string equal "qdr2" $data_array(memory_type)] } {
            
                # QDR is special - use dqs/dqsn list
                set to_clk_list [list]
                array set dqs_dqsn_map $data_array(dqs_dqsn_list)
                foreach dqs $data_array(dqs_list) {
                    lappend to_clk_list $dqs $dqs_dqsn_map($dqs)
                }
                set u_e_fals(-to_clk) [list $to_clk_list]
                
            } elseif { [is_71] && [string equal "rldram2" $data_array(memory_type)] } {
                set to_clk_list [list]
                foreach clk_name $data_array(dqs_list) {
                    lappend to_clk_list "dtw_read_${clk_name}"
                }
                set u_e_vals(-to_clk) [list $to_clk_list]
            } else {
                set u_e_vals(-to_clk) [list $data_array(dqs_list)]
            }
            }
        clk_resync {
            if {$data_array(use_hardware_dqs)} {
                set u_e_vals(-from) [listify -collection get_registers \
                    -target $script_options(name_filter) -tool $opts(read_side)]
            } else {
                # from used to have $dq_pattern for -target
                # TODO - what's the approach for get_dq_pins here,
                # with non-dqs mode?
                set u_e_vals(-from) [listify -collection get_ports \
                    -target [make_pin_patterns -pins \
                    [get_dq_pins -dqs_pins $data_array(dqs_list)]] \
                    -tool $opts(read_side)]
            }
            set u_e_vals(-to_clk) [list $data_array(clk_resync)]
            set u_e_vals(-to) [listify -collection get_registers \
                -target $script_options(name_filter) -tool $opts(read_side)]
            }
        clk_resync2 {
            set u_e_vals(-from) [listify -collection get_registers \
                -target $script_options(name_filter) -tool $opts(read_side)]
            set u_e_vals(-to) [listify -collection get_registers \
                -target $script_options(name_filter) -tool $opts(read_side)]
            set u_e_vals(-from_clk) [list $data_array(clk_resync)]
            set u_e_vals(-to_clk) [list $data_array(clk_resync2)]
            if { [string equal "tq" $opts(read_side)] } {
                set clock_transfers($data_array(clk_resync)) \
                    $data_array(clk_resync2)
            }
            }
        clk_qdr_recap {
            set u_e_vals(-to) [listify -collection get_registers \
    		-target $script_options(qdr_recaptured_name_filter) -tool $opts(read_side)]
    	}
        clk_read_postamble {
            set u_e_vals(-from_clk) [list $data_array(clk_dqs_out)]
            set u_e_vals(-to_clk) [list $data_array(clk_read_postamble)]
            set u_e_vals(-from) [listify -collection get_registers \
                -target {*} -tool $opts(read_side)]
            if { [string equal "tq" $opts(read_side)] } {
                set clock_transfers($data_array(clk_dqs_out)) \
                    $data_array(clk_read_postamble)
            }
            }
        dqs_clock {

            if { [is_71] && \
                ( $script_options(uses_tq_in_fitter) || \
                [string equal "tq" $opts(read_side)] ) } {
                # Different for TimeQuest in 7.1
                # combination of ck/ckn pin names and dqs pin names
                set to_clk_list [list]
                set ck_ckn_patterns [make_pin_patterns \
                    -pins [concat $data_array(ck_list) $data_array(ckn_list) ] ]
                set dqs_patterns [make_pin_patterns -pins $data_array(dqs_list) ]
                foreach ck_ckn_pattern $ck_ckn_patterns {
                    foreach dqs_pattern $dqs_patterns {
                        lappend to_clk_list ${ck_ckn_pattern}${dqs_pattern}
                    }
                }
                set u_e_vals(-to_clk) [list $to_clk_list]
            } else {
                set u_e_vals(-to_clk) [list $data_array(dqs_list)]
            }
            set u_e_vals(-from) [listify -collection get_registers \
                -target $script_options(name_filter) -tool $opts(read_side)]
            }
        clk_sys {
            set u_e_vals(-to) [listify -collection get_ports \
                -target $data_array(dqs_list) -tool $opts(write_side)]
            }
        clk_dq_out {
            if { $script_options(is_ddr) } {
                set dqs_pins $data_array(dqs_list)
            } else {
                set dqs_pins $data_array(ck_list)
            }
            set u_e_vals(-to) [listify -collection get_ports \
                -target [get_dq_pins -dqs_pins $dqs_pins -get_dm_also] -tool $opts(write_side)]
            }
        clk_addr_ctrl_out {

            if { $script_options(is_ddr) } {
                set to $data_array(addr_ctrl_list)
            } else {
                set to [concat $data_array(addr_list) $data_array(ctrl_list)]
            }
            set u_e_vals(-to) [listify -collection get_ports -target $to \
                -tool $opts(write_side)]
            }
        default {
            post_message -type error "Unknown clock $opts(clk_name)"
        }
    }

    foreach op [array names u_e_vals] {
        append u_e_opts " $op $u_e_vals($op)"
    }

    return $u_e_opts
}

################################################################################
# This is special for QDR

proc dtw_automation::get_dq_pins { args } {

    set options {
        { "get_dm_also" "Get DM pins too" }
        { "dqs_pins.arg" "" "List of DQS pins to use" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable data_array
    
    set dq_pins [list]
    set dm_pins [list]
    
    # Get the dq pins associated with the DQS pins in the design
    array set dqs_to_dq_map $data_array(dqs_dq_list)
    array set dqs_to_dm_map $data_array(dqs_dm_list)
    
    # was foreach... $data_array(dqs_list)
    foreach dqs_signal $opts(dqs_pins) {
        set dq_pins [concat $dq_pins $dqs_to_dq_map($dqs_signal)]
        
        if { $opts(get_dm_also) } {
            set dm_pins [concat $dm_pins $dqs_to_dm_map($dqs_signal)]
        }
    }

    if { 0 == [llength $dq_pins] } {
        post_message -type error "Can't find any DQ pins in the design"
    }
    
    return [concat $dq_pins $dm_pins]
}

################################################################################
# Try to make a pattern that matches the DQ pins
proc dtw_automation::make_pin_patterns { args } {

    set options {
        { "pins.arg" "" "List of DQ pins" }
    }
    array set opts [::cmdline::getoptions args $options]

    set patterns [list]
    set current_pattern ""
    
    # Take the first DQ pin on the (sorted) list
    # knock out all the numbers
    # Stick that on the pattern list
    # When it doesn't match any more on the list, go back to the top
    
    foreach pin [lsort $opts(pins)] {
    
        # Get rid of [ and ] because they're special characters in string match
        regsub -all -- {[\[\]]} $pin {} pin
        
        if { [string equal "" $current_pattern] } {
            # There's no current pattern, so make one
            # Replace all the numbers with *
            regsub -all -- {\d+} $pin {*} current_pattern
            lappend patterns $current_pattern
            puts_debug "make_pin_patterns: Starting with $current_pattern"
        } elseif { [string match $current_pattern $pin] } {
            # Great - it matches, so nothing to do.
        } else {
            puts_debug "make_pin_patterns: $pin didn't match $current_pattern"
            # There's an existing pattern, and it didn't match
            # Make a new pattern
            regsub -all -- {\d+} $pin {*} current_pattern
            lappend patterns $current_pattern
        }
    }
    
    puts_debug "make_pin_patterns: $patterns"
    return $patterns
}

################################################################################
# If the panel name can't be found, the procedure returns an error with a
# message that includes the name of the panel that can't be found
# Otherwise it returns the panel ID, an integer greater than -1
proc dtw_automation::build_report_panel_id { args } {

    set options {
        { "model.arg" "" "Fast model or slow model?" }
        { "analysis.arg" "" "Setup, hold, recovery, removal, etc" }
        { "clk_name.arg" "" "Name of clk, if any" }
        { "tan_io_check.arg" "0" "Pay attention to separate io paths"}
    }
    array set opts [::cmdline::getoptions args $options]
    variable pnl_str
    variable data_array
    set panel_name ""

    # Need panel path
    set panel_path [list [timing_report_root]]
    # Model name in panels
    set pnl_model $pnl_str(${opts(model)}_model)

    # If we do combined, each panel starts with "Slow Model" or "Fast Model"
    if { [string equal -nocase "combined_fast_and_slow" \
        $data_array(timing_model)] } {
            lappend panel_path $pnl_model
            append panel_name "$pnl_model "
    }

    # Then the type of analysis - clock setup, recovery, etc
    append panel_name $opts(analysis)

    # Some of these are only for clock reporting
    if { 0 < [string length $opts(clk_name)] } {

        # If we're doing separate IO paths, there's a special piece for that
        if { $opts(tan_io_check) && [is_on "report_io_paths_separately"] } {
            append panel_name " (I/O paths)"
        }

        # Then if there's a clock, there's a colon and the clock name
        append panel_name ": '$opts(clk_name)'"
    }

    lappend panel_path $panel_name
    set full_name [join $panel_path "||"]
    puts_debug "build_report_panel_id: $full_name"
    set panel_id [get_report_panel_id $full_name]
    if { -1 == $panel_id } {
        return -code error "Can't find report panel named $full_name"
    } else {
        return $panel_id
    }
}

################################################################################
proc dtw_automation::get_slack_for_path { args } {

    set options {
        { "panel_id.arg" "" "Report panel ID" }
        { "from_pattern.arg" "*" "Pattern to match in the from column" }
        { "to_pattern.arg" "*" "Pattern to match in the to column" }
        { "column_heading.arg" "Slack" "Column to get data from" }
        { "from_clk.arg" "*" "Restrict to this from-clock name" }
    }
    array set opts [::cmdline::getoptions args $options]

    # If we're getting info from a min panel, what's the alternate column name?
    array set ch    [list "Slack" "Minimum Slack" "Actual tco" "Actual Min tco" ]
    set found       0
    set slack       ""
    set on_row      1
    set num_rows    [get_number_of_rows -id $opts(panel_id)]
    set data_index  [get_report_panel_column_index -id $opts(panel_id) \
        $opts(column_heading)]
    if { -1 == $data_index } {
        set data_index [get_report_panel_column_index -id $opts(panel_id) \
            $ch($opts(column_heading))]
    }
    set from_index      [get_report_panel_column_index -id $opts(panel_id) "From"]
    set to_index        [get_report_panel_column_index -id $opts(panel_id) "To"]
    set from_clk_index  [get_report_panel_column_index -id $opts(panel_id) \
                            "From Clock"]

    while { ! $found } {

        set row_data    [get_report_panel_row -id $opts(panel_id) -row $on_row]
        set from_node   [lindex $row_data $from_index]
        set to_node     [lindex $row_data $to_index]
        set from_clk    [lindex $row_data $from_clk_index]

        if {
            [string match [escape_brackets $opts(from_pattern)] $from_node] && \
            [string match [escape_brackets $opts(to_pattern)] $to_node] && \
            [string match [escape_brackets $opts(from_clk)] $from_clk] } {
            set slack   [lindex $row_data $data_index]
            set found   1
        } else {
            incr on_row
            if { $on_row == $num_rows } {
                set found 1
            }
        }
    }

    if { 0 < [string length $slack] } {
        return [dtw_timing::get_ns $slack]
    } else {

        set num_paths_to_report [get_global_assignment -name NUMBER_OF_PATHS_TO_REPORT]
        if { $on_row == [expr { $num_paths_to_report + 2 }] } {
            post_message -type warning "[lindex $row_data 0] [lindex $row_data 1]"
        }
        return -code error "Could not find any paths matching from\
            $opts(from_pattern) to $opts(to_pattern)"
    }
}

################################################################################
# Use the TimeQuest analyzer to get slack information for a particular path
proc dtw_automation::get_tq_slack_for_path { args } {

    # Create a temporary file name based on the current time
    set fn [clock format [clock seconds] -format "%I%M%S.tq"]
    regsub -all {\{(get_.*?)\}(?=($)|(\s+-))} $args {[\1]} args
    if { [catch { eval_remote [concat report_timing $args -file $fn] } res] } {
        catch { file delete $fn }
        return -code error $res
    } else {
        # TODO - return an error if no paths are returned
        catch { file delete $fn }
        return [lindex $res 1]
    }
}

#################################################################################
# Send a complex command to the TimeQuest analyzer (one with nested Tcl commands)
proc dtw_automation::send_tq_command { command args } {

    regsub -all {\{(get_.*?)\}(?=($)|(\s+-))} $args {[\1]} args
    if { [catch { eval_remote [concat $command $args] } res] } {
        return -code error $res
    } else {
        return $res
    }
}
###############################################################################
proc dtw_automation::set_timing_model { args } {

    set options {\
        { "model.arg" "" "Fast or slow model?" } \
        { "run_analysis" "Run analysis after setting the model?" } \
    }
    array set opts [::cmdline::getoptions args $options]
    variable data_array
    variable script_options

    set project [file tail $data_array(project_path)]
    set revision $data_array(project_revision)
    
    if { [string equal "combined_fast_and_slow" $data_array(timing_model)] } {
        # If it's combined fast and slow, there's nothing to apply
        set apply 0
        set opts(run_analysis) 0
    } elseif { [string equal "separate_slow_and_fast" $data_array(timing_model)] } {
        # New in 7.1 - if it's TimeQuest, don't rerun DTW. Just one SDC.
        set apply 0
        set opts(run_analysis) 0
    } elseif { [string equal "slow" $opts(model)] } {
        set apply 1
    } elseif { [string equal "fast" $opts(model)] } {
        set apply 1
    } else {
        return -code error "A valid timing model is not specified:\
            $opts(model) or $data_array(timing_model)"
    }

    # If a new model needs to be applied...
    if { $apply } {

        post_message "Running DTW to apply $opts(model) constraints"
        if { [catch {run_dtw -project $project \
            -dwz_file [file tail $data_array(output_filename)] \
            -dtw_options "--set timing_model $opts(model)" } res] } {

            return -code error $res
        }
    }

    # If timing analysis has to be rerun after applying a new the model...
    if { $script_options(uses_tan) && $opts(run_analysis) } {
        set tan_time [get_flow_time "Timing Analyzer"]
        if { [catch { run_tan -project $project -model $opts(model) \
            -previous_run_time $tan_time } res] } {

            return -code error $res
        }
    }
}

################################################################################
# For a given set of analyses, calculate the absolute maximum of the slow/fast
# model analyses, and the minimum of each slow/fast model analysis.
# Also calculate the minimum value of the slow/fast model for the given set
# of analyses.
proc dtw_automation::calculate_min_and_abs_max { args } {

    set options {
        { "clk_variable_name.arg" "" "Name of one clock variable" }
        { "analyses_mults.arg" "" "Names of analyses and sign multipliers" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable min_slack
    variable max_slack
    upvar 1 $opts(clk_variable_name) timing_data
    set timing_data(absolute_max_margin) $min_slack
    set timing_data(direction) 0
    set timing_data(min_value) $max_slack

    puts_debug "calculate_min_and_abs_max: $opts(clk_variable_name)"

    foreach { analysis mult } $opts(analyses_mults) {
        set model_slacks [list]
        foreach model [list "slow" "fast" ] {
            puts_debug "$model $analysis $timing_data($model,$analysis,max_slack)"

            # Calculate the maximum absolute value and direction
            set abs_value [expr {abs($timing_data($model,$analysis,max_slack))}]
            if { $abs_value > $timing_data(absolute_max_margin) } {
                set timing_data(absolute_max_margin) $abs_value
                set timing_data(direction) [expr {
                    $mult * [sign $timing_data($model,$analysis,max_slack)] } ]
            }

            lappend model_slacks $timing_data($model,$analysis,max_slack)

            # Calculate the minimum value
            if { $timing_data($model,$analysis,max_slack) < $timing_data(min_value) } {
                set timing_data(min_value) $timing_data($model,$analysis,max_slack)
            }
        }
        set timing_data($analysis,min) [min $model_slacks]
    }
    puts_debug "calculate_min_and_abs_max: direction is $timing_data(direction)"
}

################################################################################
# Computes the total margin by adding the minimum values from fast/slow model
# for a set of analyses.
proc dtw_automation::calculate_total_margin { args } {

    set options {
        { "clk_variable_name.arg" "" "Name of one clock variable" }
        { "analyses.arg" "" "Names of analyses" }
    }
    array set opts [::cmdline::getoptions args $options]
    upvar 1 $opts(clk_variable_name) timing_data
    set minimum_values [list]

    foreach { analysis unused } $opts(analyses) {
        lappend minimum_values $timing_data($analysis,min)
    }

    if { 1 == [llength $minimum_values] } {
        # Handle MDAS panel
        set timing_data(total_margin) $minimum_values
    } else {
        set timing_data(total_margin) \
            [expr { [lindex $minimum_values 0] + [lindex $minimum_values 1] } ]
    }
    puts_debug "calculate_total_margin: $opts(clk_variable_name)"
    puts_debug "     $timing_data(total_margin)"
}

################################################################################
proc dtw_automation::calculate_absolute_time { args } {

    set options {
        { "clk_variable_name.arg" "" "Name of one clock variable" }
        { "all_clk_info.arg" "" "List of information about all clocks" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable data_array
    variable script_options
    upvar 1 $opts(clk_variable_name) timing_data
    array set all_clk_info $opts(all_clk_info)
    
    set cycle_time 0
    set phase_time 0
    set current_cycle "N/A"
    
    if { ! [info exists all_clk_info($opts(clk_variable_name)) ]} {
        # covers read_cap
        return
    }
    
    array set clk_info $all_clk_info($opts(clk_variable_name))
    set cycle_name $clk_info(cycle_name)
    # This is the pll to modify to cause the timing associated with the
    # clk_variable_name to change
    set pll_name $clk_info(pll_name)
    
    # It's possible that postamble might not be used
    if { [string equal "clk_read_postamble" $pll_name] && ! $data_array(use_postamble) } {
        return
    }
    
    upvar 1 $pll_name target_clock_name
    
    set current_cycle $data_array($cycle_name)
    set cycle_time [expr { $script_options(period) * $current_cycle } ]
    
    # Get the phase shift for the clock
    if { [catch {get_pll_phase_shift -clk_name $pll_name } \
        ph ] } {
        post_message -type warning $ph
        post_message -type warning "Defaulting to phase shift of 0"
        set target_clock_name(current_phase) 0
    } else {
        set target_clock_name(current_phase) $ph
        set phase_time [expr {
            $script_options(period) * ($ph / double(360)) } ]
    }
    
    set abs_time [expr { $cycle_time + $phase_time } ]
    set target_clock_name(abs_time) $abs_time
    
    puts_debug "calculate_absolute_time: $opts(clk_variable_name) cycle: $cycle_name $current_cycle phase: $ph"
    puts_debug "calculate_absolute_time: $pll_name: time is $cycle_time + $phase_time = $abs_time"
}

################################################################################
proc dtw_automation::calculate_phase_adjust { args } {

    set options {
        { "clk_name.arg" "" "Name of the clock to get the PLL phase for" }
        { "normalize_min.arg" -360 "Minimum of normaliziation range" }
        { "normalize_max.arg" 360 "Maximum of normalization range" }
        { "write_side" "Turned on for write-side phase shift analysis" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable data_array
    variable script_options
    upvar 1 $opts(clk_name) timing_data

    if { [catch {get_pll_phase_shift -clk_name $opts(clk_name)} \
        timing_data(current_phase) ] } {
        post_message -type warning $timing_data(current_phase)
        post_message -type warning "Defaulting to phase shift of 0"
        set timing_data(current_phase) 0
    }

    set timing_data(phase_adjust) [expr {
        360 * ($timing_data(delta_delay) / $script_options(period)) }]
    set new_shift [expr { $timing_data(current_phase) + $timing_data(phase_adjust) }]

    puts_debug "calculate_phase_adjust: Adjusting $opts(clk_name)"
    puts_debug "calculate_phase_adjust:  delta delay is $timing_data(delta_delay)"
    puts_debug "calculate_phase_adjust:  Current: $timing_data(current_phase)   Adjust: $timing_data(phase_adjust)"
    puts_debug "calculate_phase_adjust:  pre-normalized new phase: $new_shift"
#    puts_debug "calculate_phase_adjust: pre-normalized phase adjust is $timing_data(phase_adjust)"
#    puts_debug "calculate_phase_adjust: pre-normalized new shift is $new_shift"

    # If the new shift is outside the normalizing range, calculate a multiplier 
    # to bring it back in the range.
    # We adjust the cycle if it crossed 0 or 360. It could have started at 0 and
    # gone negative, which is OK.
    if {$opts(normalize_min) > $new_shift} {
        # Was 1 - int(new_shift/360)
    	set phase_shift_normalize [expr { int(double($new_shift) / 360) - 1 } ]
    } elseif {$opts(normalize_max) <= $new_shift } {
		set phase_shift_normalize [expr { int(double($new_shift) / 360) } ] 
    } else {
        set phase_shift_normalize 0
    }

    set new_phase [expr { $new_shift - ($phase_shift_normalize * 360) } ]
#    set timing_data(new_phase) \
#        [expr { $new_shift - ($phase_shift_normalize * 360) } ]

    set timing_data(phase_adjust) [expr { $new_phase - $timing_data(current_phase) } ]

    puts_debug "calculate_phase_adjust:  normalized phase is $new_phase and normalized adjust is $timing_data(phase_adjust)"
    puts_debug "calculate_phase_adjust:  cycle adjusts by $phase_shift_normalize"

#    set timing_data(phase_normalized_cycle_adjust) $phase_shift_normalize
    return $phase_shift_normalize
}

################################################################################
# Define procedure for reading the PLL phases
# If the panel can't be found, return phase shift of 0
proc dtw_automation::get_pll_phase_shift { args } {

    set options {
        { "clk_name.arg" "" "Name of the clock to get the PLL phase for" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable data_array
    variable script_options
    variable pnl_str

    if { $script_options(get_pll_phase_from_dtw) } {

    } else {

        set actual_clock_name $data_array($opts(clk_name))
    	set panel_id [get_report_panel_id $pnl_str(pll_usage)]
    
        # It's possible the panel doesn't exist
        if { -1 == $panel_id } {
            return -code error "Can't find $pnl_str(pll_usage) report panel"
        }
    
        # It's possible the PLL names might have changed underneath us.
        # Fail gracefully.
        # Quartus II version 7.1 allows you to use Classic or TimeQuest names
        # for the PLLs. Handle the name difference.
        if { [is_71] } {
            set actual_clock_name [translate_pll_name -pll_name $actual_clock_name \
                -is_timequest $data_array(use_timequest_names)]
        }
        
        if { [catch {get_report_panel_data -id $panel_id \
            -col_name $pnl_str(current_phase) -row_name $actual_clock_name } phase_string] } {
            return -code error "Can't find $actual_clock_name in the $pnl_str(pll_usage) panel"
        }
    }

    regexp -- {^(.*?)\s} $phase_string -> pll_phase_shift
	return $pll_phase_shift
}

################################################################################
# Necessary for Quartus II 7.1 DTW script
# TimeQuest pll name format is different from Classic pll name format.
# Pass in the name of a pll and whether it should use a timequest style name,
# and you get back an appropriate conversion
proc dtw_automation::translate_pll_name { args } {

    set options {
        { "pll_name.arg" "" "Name of the PLL clock" }
        { "is_timequest.arg" "" "If it's TimeQuest style names" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable data_array
    
    set to_return $opts(pll_name)
    
    # Timequest PLL outputs are ...altpll_component|pll|clk[x]
    # Classic PLL outputs are ...altpll_component|_clkx
    # TimeQuest names also do not have the instance name
    # altpll_component -> altpll:altpll_component
    if { $opts(is_timequest) } {
        if { 0 == [regsub {pll\|clk\[(\d+)\]$} $opts(pll_name) {_clk\1} to_return] } {
            # Added check for replacements in 8.0. Stratix III PLL names were
            # different and weren't being detected correctly.
            regsub {pll\d+\|clk\[(\d+)\]$} $opts(pll_name) {clk[\1]} to_return
        }
        
    }
    
    # Does the name have the entities specified? If not, find the name that does
    # Sometimes names can be inconsistent with the use_timequest_names setting
    # This search will take care of the altpll:altpll_<stuff> name commented above
    if { ! [regexp {:} $to_return] } {
        regsub -all {\|} $to_return {*} pll_name_filter
        foreach_in_collection id [get_names -filter "*$pll_name_filter"] {
            set file_location [get_name_info -info file_location $id]
            if { [string equal "" $file_location] } {
                post_message -type warning "$opts(pll_name) does not exist in any design file."
                post_message -type warning "There may be assignments made to it that are invalid. Find and remove the assignments."
            } else {
                set to_return [get_name_info -info full_path $id]
            }
        }
    }
    
    puts_debug "translate_pll_name: Using $to_return for $opts(pll_name)"
    return $to_return
}

################################################################################
# Are we running in 7.1 DTW?
# The use_timequest_names entry does not exist before 7.1
# There is a version entry, but I don't know the rules for how it changes
# It looks like version 23 is 7.0 and before, and 24 is 7.1 and later
# To fix SPR 280489
# If the version number begins with numbers followed by a period,
# it's the old style. Otherwise it's new style, and is equivalent to >= 24
proc dtw_automation::is_71 { args } {

    variable data_array
    if { [regexp {^(\d+)\.} $data_array(version) -> main_version_number] } {
        return [expr { $main_version_number >= 24 }]
    } else {
        return 1
    }
#    regexp {^(\d+)} $data_array(version) -> main_version_number
#    return [expr { $main_version_number >= 24 }]
#    return [info exists data_array(use_timequest_names) ]
}
################################################################################
# 6.0 and earlier use 180. 6.0 SP1 and later use -180
proc dtw_automation::inter_postamble_phase { args } {

    global quartus

    # Assume the sign of 180 is negative, which is true for 6.0 SP1 and later
    set mult -1
    set value 180

    if { [regexp -- {Version ((\d+)\.(\d+)) } $quartus(version) -> \
        major_ver minor_ver] } {

        if { 5 >= $major_ver } {
            # positive 180
            set mult 1
        } elseif { 7 <= $major_ver } {
            # negative 180
        } elseif { 6 == $major_ver && 0 == $minor_ver }  {
            # Version 6.0
            if { [regexp -- {Service Pack ([123456789]+)} $quartus(version) -> \
                sp_ver] } {
                # 6.0 with a service pack - negative
            } else {
                # 6.0 with no service pack - positive
                set mult 1
            }
        } else {
            # Version 6.x, x greater than 0, negative
        }
    } else {
        post_message -type error "Can't determine software version."
        post_message -type warning \
            "Using default value of -180 for intermediate postamble phase"
    }
    return [format "%.1f" [expr { $mult * $value } ]]
}

################################################################################
# Populate the summary report
proc dtw_automation::report1 { args } {

    set options {
        { "row_data.arg" "" "List of data to add" }
        { "read_side.arg" "tanrpt" "Do read-side? tanrpt/tantcl/tq/skip" }
        { "write_side.arg" "tq" "Do write-side? tanrpt/tantcl/tq/skip" }
        { "new_inter_postamble_phase.arg" "" "New value of the phase" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable data_array
    variable pnl_str
    variable mem_rpt_str
    variable script_options
    variable clk_to_analyses
    variable read_clks_${script_options(mem_type_dqs_pll_mode)}
    variable read_clks_rec_${script_options(mem_type_dqs_pll_mode)}
    variable write_clks_${data_array(memory_type)}
    variable write_clks_rec_${data_array(memory_type)}
    upvar 0 read_clks_${script_options(mem_type_dqs_pll_mode)} read_clks
    upvar 0 read_clks_rec_${script_options(mem_type_dqs_pll_mode)} read_clks_rec
    upvar 0 write_clks_${data_array(memory_type)} write_clks
    upvar 0 write_clks_rec_${data_array(memory_type)} write_clks_rec
    variable next_steps
    variable clock_transfers
    variable tq_clock_info

    prep_panel -name $mem_rpt_str(timing_report_path) -type folder
    # If you're using TimeQuest, the Timing Analysis folder might not exist
#    prep_panel -name [timing_report_root] -type folder

    # Determine the path to the DDR reports for this interface
    set ddr_report_path [list $mem_rpt_str(timing_report_path)]

    # Tack on the dwz settings name too
    set mem_interface $script_options(interface_name)
    append mem_interface " (${script_options(dwz_settings)}.dwz)"

    lappend ddr_report_path $mem_interface

    # Create a folder for the report panels
    set new_folder_name [join $ddr_report_path "||"]
    set folder_id [prep_panel -name $new_folder_name -type folder]

    # Create the summary panel and add headings
    set foo $ddr_report_path
    lappend foo $mem_rpt_str(timing_summary)
    set summary_name [join $foo "||"]
    set summary_id [prep_panel -name $summary_name]
    add_row_to_table -id $summary_id $mem_rpt_str(margin_panel_headings)

    # If we're not skipping read-side analysis, report it.
    if { [process_side $opts(read_side)] } {

        # all read-side analyses
        foreach { clk clk_name } $read_clks {

            # It's possible that postamble might not be used
            if { [string equal "clk_read_postamble" $clk] && ! $data_array(use_postamble) } {
                continue
            }

            upvar 1 $clk timing_data
            set ideal_margin [expr {$timing_data(total_margin) / 2 }]
            set data_row [list \
                $clk_name [format "%.3f" $timing_data(min_value)] \
                [format "%.3f" $ideal_margin] ]
    
            foreach model [list "slow" "fast" ] {
                foreach { analysis unused } $clk_to_analyses($clk) {
                    lappend data_row \
                        [format "%.3f" $timing_data($model,$analysis,max_slack)]
                }
            }
    
            # Add the PLL name at the end of the row
            if { [info exists data_array($clk)] } {
                lappend data_row $data_array($clk)
            } else {
                lappend data_row [list]
            }
    
            add_row_to_table -id $summary_id $data_row
        }    
    }

    # If we're not skipping write-side analysis, report it.
    if { [process_side $opts(write_side)] } {

        # Flags for printing recommendations later
        set meets_tdqss 1
        set meets_addr_ctrl 1

        foreach { clk clk_name } $write_clks {

            upvar 1 $clk timing_data

            # Determine whether these domains have failed
            switch -exact -- $clk {
                clk_sys {
                    if {( 0 > $timing_data(min_value) ) && \
                        ($script_options(write_phase_gap) > abs($timing_data(phase_adjust))) } {
                        set meets_tdqss 0
                    }
                }
                clk_addr_ctrl_out {
                    if {( 0 > $timing_data(min_value) ) && \
                        ($script_options(write_phase_gap) > abs($timing_data(phase_adjust))) } {
                        set meets_addr_ctrl 0
                    }
                }
            }

            set ideal_margin [expr {$timing_data(total_margin) / 2}]
            set data_row [list \
                $clk_name [format "%.3f" $timing_data(min_value)] \
                [format "%.3f" $ideal_margin] ]
    
            foreach model [list "slow" "fast" ] {
                foreach { analysis unused } $clk_to_analyses($clk) {
                    lappend data_row \
                        [format "%.3f" $timing_data($model,$analysis,max_slack)]
                }
            }
    
            # Add the PLL name at the end of the row
            if { [info exists data_array($clk)] } {
                lappend data_row $data_array($clk)
            } else {
                lappend data_row [list]
            }
            add_row_to_table -id $summary_id $data_row
        }
    }

    # Create the recommended settings panel and add headings
    set foo $ddr_report_path
    lappend foo $mem_rpt_str(recommended_settings)
    set recommended_settings_name [join $foo "||"]
    set recommended_settings_id [prep_panel -name $recommended_settings_name]
    add_row_to_table -id $recommended_settings_id $mem_rpt_str(recommended_panel_headings)

    # If we're not skipping read-side analysis, report it.
    if { [process_side $opts(read_side)] } {

        # Sort of cheesy way to track this :-)
        set clk_cycles_equal 1

        # Go through the read-side phase and cycle adjust reporting
        foreach { clk clk_name } $read_clks {

            # If a clock name has no associated reporting info, there's nothing
            # to report for adjusting it.
            if { ![info exists read_clks_rec($clk)] } {
                continue
            }

            # Hack for DQS non-fedback
            if { ! $data_array(is_clk_fedback_in) && [string equal clk_read_postamble $clk] } {
                continue
            }

            # It's possible that postamble might not be used
            if { [string equal "clk_read_postamble" $clk] && ! $data_array(use_postamble) } {
                continue
            }

#            upvar 1 $clk timing_data
            array unset clk_info
            array set clk_info $read_clks_rec($clk)

            # What is the name for the clock that has adjustments made to it?
            # I define the exceptions. Else, get the normal clock name
            if { [info exists clk_info(adjust_name)] } {
                set clk_name $clk_info(adjust_name)
            }

            # It's possible that postamble might not be used when you're checking adjust clocks
            if { [string equal "clk_read_postamble" $clk_info(pll_name)] && ! $data_array(use_postamble) } {
                continue
            }

            # The clk_read_postamble clock is a special case
            # for getting the phase shifts.
            upvar 1 $clk_info(pll_name) alt_timing_data
            set current_phase $alt_timing_data(current_phase)

            puts_debug "report1: Getting cycle and phase for $clk"
            foreach { new_cycle new_phase } [get_cycle_and_phase \
                -clk_name $clk_info(pll_name) -data [array get alt_timing_data]] { break }
            
            # Put together the row of data to append to the table.
            # non-DQS implementations of RLDRAM and QDR have no cycle adjust
            if { ! [info exists clk_info(cycle_name)] } {
                set current_cycle "N/A"
                set new_cycle "N/A"
            } else {
                set current_cycle $data_array($clk_info(cycle_name))
                
                # How are we doing with equal clock cycles?
                set clk_cycles_equal [ expr { $clk_cycles_equal && ( \
                    $current_cycle == $new_cycle )}]
            }

            set data_row [list $clk_name \
                $current_cycle \
                $new_cycle \
                [format "%.0f" $current_phase] \
                [format "%.0f" $new_phase] \
                $data_array($clk_info(pll_name)) ]
            add_row_to_table -id $recommended_settings_id $data_row

        }
    }

    if { [process_side $opts(write_side)] } {

        # Go through the write-side
        foreach { clk clk_name } $write_clks {
            upvar 1 $clk timing_data
            array unset clk_info
            array set clk_info $write_clks_rec($clk)
    
            # What is the name for the clock that has adjustments made to it?
            # I define the exceptions. Else, get the normal clock name
            if { [info exists clk_info(adjust_name)] } {
                set clk_name $clk_info(adjust_name)
            }

            upvar 1 $clk_info(pll_name) alt_timing_data
            set current_phase $alt_timing_data(current_phase)
            set new_phase [get_total -clk_name "alt_timing_data" -info "phase"]
    
            # Put together the row of data to append to the table.
            set data_row [list $clk_name \
                "N/A" "N/A" \
                [format "%.0f" $current_phase] \
                [format "%.0f" $new_phase] \
                $data_array($clk_info(pll_name)) ]
            add_row_to_table -id $recommended_settings_id $data_row
        }
    }

    # Create the what to do next panel and add headings
    set foo $ddr_report_path
    lappend foo $mem_rpt_str(what_to_do_next)
    set what_to_do_next_name [join $foo "||"]
    set what_to_do_next_id [prep_panel -name $what_to_do_next_name]
    add_row_to_table -id $what_to_do_next_id [list $mem_rpt_str(what_to_do_next)]

    # You might have to change the Optimize Hold Timing setting
    if {![string equal "none" $script_options(oht_next_steps)] } {
        add_row_to_table -id $what_to_do_next_id [list $next_steps(oht)]
        set ohtns $script_options(oht_next_steps)
        add_row_to_table -id $what_to_do_next_id [list $next_steps(oht_${ohtns})]
        add_row_to_table -id $what_to_do_next_id [list $next_steps(oht_last)]
    }

    # There might be clock period differences
    if { 0 < [llength [array names clock_transfers]] } {

        foreach step [lsort [array names next_steps clk_periods*]] {
            add_row_to_table -id $what_to_do_next_id [list $next_steps($step)]
        }

        foreach src_clk [array names clock_transfers] {
            set dest_clk $clock_transfers($src_clk)
            set src_period $tq_clock_info($src_clk,period)
            set dest_period $tq_clock_info($dest_clk,period)
            add_row_to_table -id $what_to_do_next_id \
                [list "From: $src_clk $src_period"]
            add_row_to_table -id $what_to_do_next_id \
                [list "To: $dest_clk $dest_period"]
        }
    }

    # If we're not skipping read-side analysis, report next steps.
    if { [process_side $opts(read_side)] } {

        # First issue is if clock cycles are not equal
        if { ! $clk_cycles_equal } {
            foreach step [lsort [array names next_steps cycles*]] {
                add_row_to_table -id $what_to_do_next_id [list $next_steps($step)]
            }
            if { $data_array(use_hardware_dqs) } {
                add_row_to_table -id $what_to_do_next_id \
                    [list $next_steps(dqs_yes)]
            } else {
                add_row_to_table -id $what_to_do_next_id \
                    [list $next_steps(dqs_no)]
            }
        } else {
            # If they are equal, there's more stuff to do
            catch { upvar 1 clk_dqs_out foo }
            if { [info exists foo(flip)] } {
                foreach step [lsort [array names next_steps insert*]] {
                    add_row_to_table -id $what_to_do_next_id [list $next_steps($step)]
                }
            }
            
            # Adjust the phases
            foreach step [lsort [array names next_steps phases*]] {
                add_row_to_table -id $what_to_do_next_id [list $next_steps($step)]
            }
            
            # In some circumstances, you can use pre-existing clock taps
            array set top_hier [list]
            foreach c [list "clk_sys" "clk_read_postamble" "clk_resync"] {
                if { [info exists data_array($c)] } {
                    regexp -- {^(.*)\|.*?\|.*?$} $data_array($c) -> top_hier($c)
                }
            }
            if { [info exists top_hier(clk_sys)] } {
            
                set uses_same_pll 0
                # Check the postamble hierarchy if postamble is used
                # could use data_array(use_postamble)
                if { [info exists top_hier(clk_read_postamble)] } {
                    set uses_same_pll [string equal \
                        $top_hier(clk_sys) $top_hier(clk_read_postamble)]
                }
                
                if { [info exists top_hier(clk_resync)] } {
                    set uses_same_pll [expr { $uses_same_pll || [string equal \
                        $top_hier(clk_sys) $top_hier(clk_resync)] } ]
                }

                if { $uses_same_pll } {
                    foreach step [lsort [array names next_steps free_phases*]] {
                        add_row_to_table -id $what_to_do_next_id [list $next_steps($step)]
                    }
                }
            }
                        
            # And provide instructions to tell how to import updated settings to DTW
            foreach step [lsort [array names next_steps import*]] {
                add_row_to_table -id $what_to_do_next_id [list $next_steps($step)]
            }
        }
    }

    # If we're not skipping write-side analysis, report next steps.
    if { [process_side $opts(write_side)] } {
#        add_row_to_table -id $what_to_do_next_id \
#            [list "TODO - CK/CK# timing, Address/Command timing"]
        # If it doesn't meet tdqss, there's one thing to adjust
        if { ! $meets_tdqss } {
            add_row_to_table -id $what_to_do_next_id \
                [list $next_steps(tdqss)]
        }
        # If it doesn't meet address/control, there's another
        if { ! $meets_addr_ctrl } {
            add_row_to_table -id $what_to_do_next_id \
                [list $next_steps(addr_cmd)]
        }
        # If it doesn't meet either, there's a common message to print.
        if { ! $meets_tdqss || ! $meets_addr_ctrl } {
            foreach step [lsort [array names next_steps rtl*]] {
                add_row_to_table -id $what_to_do_next_id [list $next_steps($step)]
            }
        }
    }

    save_report_database
}

################################################################################
# Given a panel name, delete it if it exists, create it, and return the ID
# If it's a table and it exists, delete it, then create it
# If it's a table and it doesn't exist, create it
# If it's a folder and it exists, return
# If it's a folder and it doesn't exist, create it
proc dtw_automation::prep_panel { args } {

    set options {
        { "name.arg" "" "Name of table or panel" }
        { "type.arg" "table" "table or panel" }
    }
    array set opts [::cmdline::getoptions args $options]

    puts_debug "prep_panel: Working on $opts(name)"
    set id [get_report_panel_id $opts(name)]
    if { -1 != $id } {
        switch -exact -- $opts(type) {
            folder { return }
            table { delete_report_panel -id $id }
            default { return -code error "Specify folder or table" }
        }
    }
    switch -exact -- $opts(type) {
        folder { return [create_report_panel -folder $opts(name)] }
        table { return [create_report_panel -table $opts(name)] }
        default { return -code error "Specify folder or table" }
    }
}

################################################################################
proc dtw_automation::get_cycle_and_phase { args } {

    set options {
        { "data.arg" "" "Array with clock information" }
        { "clk_name.arg" "" "Name of the clock" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable script_options
    
    array set timing_data $opts(data)
    set cycle 0
    set flag 1

    if { [info exist timing_data(new_cycle)] && [info exist timing_data(new_phase)] } {
        # Deal with clk_dqs_out
        return [list $timing_data(new_cycle) $timing_data(new_phase)]
    } elseif { ! [info exist timing_data(rec_time)] } {
        return [list 0 0]
    } else {
        set result_time $timing_data(rec_time)
    }
    
    puts_debug "get_cycle_and_phase: rec_time is $result_time"
    while { $flag } {
    
        set temp_time [expr { $result_time - $script_options(period) } ]
        if { 0 > $temp_time } {
            set flag 0
        } else {
            set result_time $temp_time
            incr cycle
        }
    }
    
    # When we get here, temp_time is less than period
    set phase [expr { 360 * ($result_time / double($script_options(period)) ) } ]
    
    puts_debug "get_cycle_and_phase: cycle: $cycle phase: $phase"
    return [list $cycle $phase]
}

################################################################################
# Put this first. If -auto_adjust_cycles is used, see whether any need to be
# adjusted. If not, exit
# Return 1 if the rest of the automation script needs to be run.
# Return 0 if the cycles are all equal
proc dtw_automation::auto_adjust_cycles { args } {

    set options {
        { "project.arg" "" "Name of project" }
        { "dwz_file.arg" "" "Name of DWZ file" }
        { "stop_after.arg" "" "Maximum number of cycle adjust iterations" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable data_array
    variable script_options
    variable auto_adjust_history
    variable read_clks_rec_${script_options(mem_type_dqs_pll_mode)}
    upvar 0 read_clks_rec_${script_options(mem_type_dqs_pll_mode)} read_clks_rec

    array set updates [list]
    set identical 1

    if { [catch { compare_current_and_new_cycles -project $opts(project) \
        -dwz_file $opts(dwz_file) -updates_var updates } identical] } {

        # If there was an error, the shift recommendation panel could
        # not be found. That's probably because the script wasn't run yet
        # to do the reporting. Return and continue running the script to do
        # the reporting.
        post_message -type warning $identical
        return 1
    } elseif { ! $identical } {

        if { $opts(stop_after) <= [llength [array names auto_adjust_history]] } {
            post_message -type warning "The script has made $opts(stop_after)\
                cycle adjustments."
            post_message "If you want the script to continue, rerun the script\
                or rerun it and add the -stop_after <n> option."
            return 0
        }

        # There are changes to make; make them.
        # Assemble the options to pass to DTW in this string
        set dtw_options ""

        post_message "Updating DTW with the following clock cycle values:"
        # Assemble the cycles that have to change as options and values
        # on the command string.
        # If the script has made these settings before, stop the script
        # so it doesn't get in an infinite loop
        set history_key ""
        foreach clk [lsort [array names updates]] {
            array set clk_info $read_clks_rec($clk)
            set dwz_variable $clk_info(cycle_name)
            set new_value $updates($clk)
            post_message "$dwz_variable: $new_value"
            append dtw_options " --set $dwz_variable $new_value"
            append history_key $dwz_variable
            append history_key $new_value
        }

        # Has the script suggested these settings before?
        if { [info exists auto_adjust_history($history_key)] } {
            post_message -type warning "These cycle adjustments have been tried already.\
                The script is stopping to prevent an infinite loop."
            puts_debug $history_key
            return 0
        } else {
            set auto_adjust_history($history_key) 1
        }

        # Now run DTW to update the values
        if { [catch { run_dtw -project $opts(project) \
            -dwz_file $opts(dwz_file) -dtw_options $dtw_options } res ] } {

            return -code error $res
        } else {

            post_message "Successfully updated clock cycle values in DTW"
    
        if { $script_options(uses_tan) } {
                # Now we have to rerun TAN.
                set tan_time [get_flow_time "Timing Analyzer"]
                if { [catch { run_tan -project $opts(project) \
                    -model "same_as_last" \
                    -previous_run_time $tan_time } res] } {

                    return -code error $res
                } else {
                    # Ran TAN successfully
                    return 1
                }
            } else {
                # Doesn't use TAN
                return 1
            }
        }
    } else {
        # They are identical
        return 0
    }
}

################################################################################
proc dtw_automation::compare_current_and_new_cycles { args } {

    set options {
        { "project.arg" "" "Name of project" }
        { "dwz_file.arg" "" "Name of DWZ file" }
        { "updates_var.arg" "" "Variable name to hold cycle update info" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable data_array
    variable pnl_str
    variable mem_rpt_str
    variable script_options
    variable current_cycle_name
    variable new_cycle_name
    variable read_clks_${script_options(mem_type_dqs_pll_mode)}
    variable read_clks_rec_${script_options(mem_type_dqs_pll_mode)}
    upvar 0 read_clks_${script_options(mem_type_dqs_pll_mode)} read_clks
    upvar 0 read_clks_rec_${script_options(mem_type_dqs_pll_mode)} read_clks_rec

    upvar 1 $opts(updates_var) updates
    set identical 1

    # Determine the path to the reports for this interface
    set recommended_settings_path [list $mem_rpt_str(timing_report_path)]

    # Tack on the dwz settings name too
    set mem_interface $script_options(interface_name)
    append mem_interface " (${script_options(dwz_settings)}.dwz)"

    lappend recommended_settings_path $mem_interface
    lappend recommended_settings_path  $mem_rpt_str(recommended_settings)
    set recommended_settings_name [join $recommended_settings_path "||"]
    puts_debug $recommended_settings_name
    set recommended_settings_id [get_report_panel_id $recommended_settings_name]
    if { -1 == $recommended_settings_id } {
        return -code error "Couldn't find memory interface timing report,\
            running timing analysis first"
    } else {
        # Report exists. Now figure out whether any cycles have to be changed
    }

    set current_column [get_report_panel_column_index -id $recommended_settings_id \
        $current_cycle_name]
    set new_column [get_report_panel_column_index -id $recommended_settings_id \
        $new_cycle_name]

    # Use a slightly cumbersome method of looking through the report panel.
    # I look for all the clocks I know about, though only some will be found.
    # Doing it this way means there's less maintenance of this procedure if
    # clocks get added to or removed from the panel, or names are changed.
    foreach { clk clk_name } $read_clks {

        if { [info exists read_clks_rec($clk)] } {
            array unset clk_info
            array set clk_info $read_clks_rec($clk)
            if { [info exists clk_info(adjust_name)] } {
                # Some clocks change due to other clocks being changed
                set clk_name $clk_info(adjust_name)
            }
        }
        
        set row_id [get_report_panel_row_index -id $recommended_settings_id $clk_name]

        # Does the clock name exist in the report panel?
        if { -1 != $row_id } {

            set current [get_report_panel_data -id $recommended_settings_id \
                -col $current_column -row $row_id]
            set new [get_report_panel_data -id $recommended_settings_id \
                -col $new_column -row $row_id]

            # If the two are different, we have to make an update
            if { ! [string equal $current $new] } {
                set updates($clk) $new
                set identical 0
            }
        }
    }
    return $identical
}

################################################################################
proc dtw_automation::run_dtw { args } {

    set options {
        { "project.arg" "" "Name of project" }
        { "dwz_file.arg" "" "Name of DWZ file" }
        { "dtw_options.arg" "" "Options for DTW" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable data_array

    set command "quartus_sh --dtw -p $opts(project) -t $opts(dwz_file) \
        -c $data_array(project_revision) -q $opts(dtw_options)"

    # Close the project first, if necessary
    if { [is_project_open] } {
        catch { unload_report }
        project_close
    }

    # Try to run DTW with whatever the options are
    puts_debug "run_dtw: $command"
    if { [catch { eval exec $command } res] } {
        return -code error $res
    } else {

        # Now that DTW has been run, and the DWZ file has been updated, 
        # we have to re-read it
        set data_list [list]
        if {[catch {source $opts(dwz_file)}]} {
            return -code error "Error reading $opts(dwz_file)"
        } else {
            array unset data_array
            array set data_array $data_list
        }

        # Re-open the project, and load the report again.
        if { [catch { project_open $opts(project) \
            -revision $data_array(project_revision) } res] } {

            return -code error $res
        }

        # Catch error if report doesn't load
        if { [catch { load_report } res] } {
            post_message -type error "Can't load report after running DTW"
            return -code error $res
        }

        # return the output of DTW
        return $res
    }
}

################################################################################
proc dtw_automation::run_tan { args } {

    set options {
        { "project.arg" "" "Name of project" }
        { "tan_options.arg" "" "Options for TAN" }
        { "model.arg" "" "Run with a specific model: slow/fast/same_as_last" }
        { "previous_run_time.arg" "" "How long it took last time" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable data_array

    set command "quartus_tan $opts(project) --rev $data_array(project_revision)"

    if { ![string equal "" $opts(tan_options)] } {
        append command " $opts(tan_options)"
    } else {

        if { [string equal "same_as_last" $opts(model)] } {
            set opts(model) $data_array(timing_model)
        }
        switch -exact -- $opts(model) {
            "fast" { append command " --fast_model" }
            "slow" -
            "combined_fast_and_slow" { 
                # No other options are necessary to run with the slow model
            }
            default {
                post_message -type error "Invalid timing model: $opts(model)"
            }
        }
    }

    # Prepare for the timing analysis
    if { [is_project_open] } {
        catch { unload_report }
        project_close
    }
    
    # Try to run TAN with whatever the options are
    post_message "Wait while timing analysis is performed"
    puts_debug "run_tan: $command"

    if { ! [string equal "" $opts(previous_run_time)] } {
        display_end_time $opts(previous_run_time)
    }

    if { [catch { eval exec $command } res] } {
        return -code error $res
    } else {
        post_message "Completed timing analysis"
        # Re-open the project, and load the report again.
        if { [catch {project_open $opts(project) \
            -revision $data_array(project_revision) } res] } {

            return -code error $res
        }

        # Catch error on loading report
        if { [catch { load_report } res] } {
            post_message -type error "Can't load report after timing analysis"
            return -code error $res
        }

        if { [catch {get_timing_analyzer_settings} res] } {
            return -code error $res
        } else {
            return 1
        }
    }
}

################################################################################
proc dtw_automation::run_map { args } {

    set options {
        { "project.arg" "" "Name of project" }
        { "map_options.arg" "" "Options for MAP" }
        { "previous_run_time.arg" "" "How long it took last time" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable data_array

    set command "quartus_map $opts(project) --rev $data_array(project_revision)"

    if { ![string equal "" $opts(map_options)] } {
        append command " $opts(map_options)"
    }

    # Prepare for the analysis and synthesis
    if { [is_project_open] } {
        catch { unload_report }
        project_close
    }
    
    # Try to run MAP with whatever the options are
    post_message "Wait while analysis and synthesis is performed"
    puts_debug "run_map: $command"

    if { ! [string equal "" $opts(previous_run_time)] } {
        display_end_time $opts(previous_run_time)
    }

    if { [catch { eval exec $command } res] } {
        return -code error $res
    } else {
        post_message "Completed analysis and synthesis"
        return 1
    }
}

################################################################################
# Get the amount of time that the last run of a particular module took
proc dtw_automation::get_flow_time { module } {

    variable pnl_str

    set elapsed_time ""

    # If there's an error finding the panel, return ""
    if { [catch {
        get_report_panel_id $pnl_str(flow_elapsed_time_path)} panel_id] } {

        return $elapsed_time
    }

    # If there's no panel, return an empty string
    if { -1 == $panel_id } { return $elapsed_time }

    set num_rows [get_number_of_rows -id $panel_id]

    for { set i 1 } { $i < $num_rows } { incr i } {
        foreach { module_name time_value } \
            [get_report_panel_row -id $panel_id -row $i] { break }
        # In 6.0, the name was Timing Analyzer or TimeQuest Timing Analyzer
        # In 6.1, it's Classic Timing Analyzer or TimeQuest Timing Analyzer
        # Using regexp allows an easy way to match either one.
        if { [regexp $module $module_name] } {
            set elapsed_time $time_value
        }
#        if { [string equal $module $module_name] } {
#            set elapsed_time $time_value
#        }
    }
    return $elapsed_time
}

################################################################################
# Calculate a time when the timing analysis will probably end
proc dtw_automation::display_end_time { time_string } {

    foreach {hh mm ss}  [split $time_string ":"] { break }
    regsub {^0} $hh {} hh
    regsub {^0} $mm {} mm
    regsub {^0} $ss {} ss
    set estimated_secs  [expr { $ss + (60 * $mm) + (3600 * $hh) } ]
    set now             [clock seconds]
    set now_date        [clock format $now -format "%a %b %d %Y"]
    set estimated_time  [clock format [clock scan "$estimated_secs seconds" \
        -base $now] -format "%I:%M:%S %p"]
    set estimated_date  [clock format [clock scan "$estimated_secs seconds" \
        -base $now] -format "%a %b %d %Y"]
    set duration_msg    "Last time it took "

    if { ! [string equal "00" $hh] } {
        append duration_msg "about $hh hours and $mm minutes"
    } elseif { ! [string equal "00" $mm] } {
        append duration_msg "$mm minutes and $ss seconds"
    } else {
        append duration_msg "$ss seconds"
    }
    post_message $duration_msg
    set expected_end_msg \
        "This time it will probably finish at $estimated_time"
    if { ! [string equal $now_date $estimated_date] } {
        append expected_end_msg " on $estimated_date"
    }
    post_message $expected_end_msg
}

################################################################################
# Run quartus_map to do analysis and synthesis
# Run DTW and import the file generated out of IPTB
# Run a compilation
# Run this analysis script
proc dtw_automation::after_ip_toolbench { args } {

    set options {
        { "project.arg" "" "Name of project" }
        { "dwz_file.arg" "" "Name of DWZ file" }
        { "compile" "Compile after importing?" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable data_array

    # Try to open the project and try to load the report
    # If it fails, it's OK. Fail silently.
    catch { project_open $project -revision $data_array(project_revision) }
    catch { load_report }

    set map_time [get_flow_time "Analysis & Synthesis"]
    set total_time [get_flow_time "Total"]

    # Close the project if it was open.
    if { [is_project_open] } {
        catch { unload_report }
        project_close
    }

    post_message "Wait while analysis and synthesis is performed"
    if { ! [string equal "" $total_time] } { display_end_time $map_time }
    puts_debug "after_ip_toolbench: quartus_map $opts(project) \
        -c $data_array(project_revision)"
    if { [catch { exec quartus_map $opts(project) \
        -c $data_array(project_revision) } res] } {

        return -code error $res
    }
    post_message "Completed analysis and synthesis"

    post_message "Running DTW to import settings and generate constraints"
    if { [catch { run_dtw -project $opts(project) -dwz_file $opts(dwz_file) \
        -dtw_options "-i $data_array(import_path)" } res] } {

        return -code error $res
    }
    post_message "Done running DTW"

    # If we're not compiling, return 0 to cause the script to exit.
    # Without a report database, there's nothing else to do.
    if { ! $opts(compile) } {
        return 0
    }

    post_message "Wait while the design is compiled"
    if { ! [string equal "" $total_time] } { display_end_time $total_time }
    puts_debug "after_ip_toolbench: quartus_sh --flow compile $opts(project) \
        -c $data_array(project_revision)"
    if { [catch { exec quartus_sh --flow compile $opts(project) \
        -c $data_array(project_revision) } res] } {

        return -code error $res
    }
    post_message "Completed compilation"
    # Now that DTW has been run, and the DWZ file has been updated, 
    # we have to re-read it
    set data_list [list]
    if {[catch {source $opts(dwz_file)}]} {
        return -code error "Error reading $opts(dwz_file)"
    } else {
        array unset data_array
        array set data_array $data_list
    }

    # TODO - Is extract TCOs guaranteed to be correct now?

#    # Re-open the project, and load the report again.
#    if { [catch { project_open $opts(project) \
#        -revision $data_array(project_revision) } res] } {
#
#        return -code error $res
#    }
#
#    # Catch error when loading report
#    if { [catch { load_report } res] } {
#        post_message -type error "Can't load report after compiling project"
#        return -code error $res
#    }
}

################################################################################
# Returns the minimum of numbers in a list
proc dtw_automation::min { args } {
    if { [llength $args] > 1 } {
        set l [ concat $args]
    } else {
        set l [lindex $args 0]
    }
    set min [lindex $l 0]
    foreach a $l { if { $a < $min } { set min $a } }
    return $min
}

################################################################################
# Define procedure to return the sign of a number
proc dtw_automation::sign { number } {
	if { $number >= 0 } { return 1 } else { return -1 }
}

################################################################################
# Checks to see whether an on/off TAN setting is on.
proc dtw_automation::is_on { setting } {
    variable tan_settings
    if { ! [info exists tan_settings($setting)] } {
        return -code error "$setting is not defined in this script"
    }
    if { [string equal -nocase "on" $tan_settings($setting)] } \
        { return 1 } else { return 0 }
}

################################################################################
# Return 1 if the specified memory side (read/write) is being processed.
# It is being processed if the value is not "skip"
proc dtw_automation::process_side { side } {

    return [expr { ! [string equal -nocase "skip" $side] } ]
}

################################################################################
proc dtw_automation::write_vwf { args } {

    set options {
        { "file_name.arg" "" "Name vwf to write" }
        { "read_side.arg" "tanrpt" "Do read-side? tanrpt/tantcl/tq/skip" }
        { "write_side.arg" "tq" "Do write-side? tanrpt/tantcl/tq/skip" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable data_array
    variable script_options
    variable clk_to_analyses
    variable read_clks_${script_options(mem_type_dqs_pll_mode)}
    variable read_clks_rec_${script_options(mem_type_dqs_pll_mode)}
    upvar 0 read_clks_${script_options(mem_type_dqs_pll_mode)} read_clks
    upvar 0 read_clks_rec_${script_options(mem_type_dqs_pll_mode)} read_clks_rec

    if { [string equal "" $script_options(vwf_file_name)] } {
        return
    }
    if { [catch { open $script_options(vwf_file_name) w } fh] } {
        return -code error $fh
    }
    
    # Clock high and low time
    set half_period [format {%.3f} [expr { $script_options(period) / 2 }]]

    set legend_level_duration [list \
        Z $script_options(period) \
        X 2.000 \
        Z 5.000 \
        U 2.000 \
        Z 1.000 ]

    # Number of clock cycles to draw
    set clock_cycles 6
    
    # We need names for the data lines - something decent
    array set clk_to_data [list \
        read_cap    "DQ input" \
        clk_resync  "Fed-back data" \
        clk_resync2 "Resynchronization data" \
        clk_read_postamble  "Postamble data" \
        dqs_clock "Recovery/Removal" ]
        
    # Get the list of clock names and display names once.
    set clk_display_names [list]
    array set vwf_clk_info [list]
    
    # Are we actually doing read-side analysis?
    if { [process_side $opts(read_side)] } {

    foreach { clk clk_name } $read_clks {
    
        set current_phase 0
        set abs_time 0
        
        # What is the name for the clock that has adjustments made to it?
        # I define the exceptions. Else, get the normal clock name        
        if { [info exists read_clks_rec($clk)] } {
            array unset clk_info
            array set clk_info $read_clks_rec($clk)
            if { [info exists clk_info(adjust_name)] } {
                set clk_name $clk_info(adjust_name)
            }
            upvar 1 $clk_info(pll_name) alt_timing_data
            set current_phase $alt_timing_data(current_phase)
            set abs_time $alt_timing_data(abs_time)
        } else {
            continue
        }
        
        lappend clk_display_names $clk
        lappend clk_display_names $clk_name
        set vwf_clk_info($clk,name) $clk_name
        set vwf_clk_info($clk,current_phase) $current_phase
        set vwf_clk_info($clk,abs_time) $abs_time
    }
    
    # Write out the vwf header

    puts $fh "HEADER
{
	VERSION = 1;
	TIME_UNIT = ns;
	DATA_OFFSET = 0.0;
	DATA_DURATION = 1000.0;
	SIMULATION_TIME = 0.0;
	GRID_PHASE = 0.0;
	GRID_PERIOD = 10.0;
	GRID_DUTY_CYCLE = 50;
}"

    # Write out the signal information
    # Do it in order :-)
    # DQS clock
    # read_cap setup/hold
    # fedback clock
    # setup/hold
    # resynch clock
    # setup/hold
    # system postamble
    # setup/hold
    # postamble
    # recovery/removal
    
    # First write out the signal list
    foreach { clk clk_name } $clk_display_names {
    
        # Write out the clock signal first, followed by the data signal
        puts $fh [vwf_signal -channel $clk_name]
        puts $fh [vwf_signal -channel $clk_to_data($clk)]
    }
    
    # I want a waveform divider to separate the legend
    puts $fh [vwf_signal -channel "divider 1"]
    puts $fh [vwf_signal -channel "Legend"]

    # After the signal list, write out the transition list
    foreach { clk clk_name } $clk_display_names {

        upvar 1 $clk timing_data

        # The shift time could be negative because of a negative PLL phase shift
        # It can't be negative in the VWF, so normalize it with one clock period
        # if necessary.
        set shift_time [expr { $script_options(period) * ($vwf_clk_info($clk,current_phase)/double(360)) } ]
        if { 0 > $shift_time } { set shift_time [expr { $shift_time + $script_options(period) }] }

        # Write out the clock transition first...
        puts $fh "TRANSITION_LIST(\"$clk_name\")\n{\n	NODE\n	{\n		REPEAT = 1;"
        puts $fh "		LEVEL Z FOR [format {%.3f} $shift_time ];
		NODE
		{
			REPEAT = $clock_cycles;
			LEVEL 0 FOR $half_period;
			LEVEL 1 FOR $half_period;
		}
	}
}"

        # ...followed by the appropriate data
        # Draw out the setup/hold margin information
        # need abs_time, then use setup,min and hold,min to
        # show stuff
        set abs_time $vwf_clk_info($clk,abs_time)
        
        # Shove the data up half a clock cycle so it lines up with the rising edge
        set abs_time [expr { $abs_time + $half_period } ]
        
        foreach { first_analysis flip second_analysis unused } $clk_to_analyses($clk) { break }
        
        # For recovery and removal/postamble/system postamble, the source
        # registers get moved, so the setup/hold margins must be flipped on
        # the timing diagram so they show the appropriate way to shift the
        # clocks. 
        if { 1 == $flip } {
            set temp $first_analysis
            set first_analysis $second_analysis
            set second_analysis $temp
        }
        
        set start_time [expr { $abs_time - abs($timing_data($first_analysis,min)) } ]
        
        if { 0 < $timing_data($first_analysis,min) } {
            set first_level U
        } else {
            set first_level X
        }
        
        if { 0 < $timing_data($second_analysis,min) } {
            set second_level U
        } else {
            set second_level X
        }
        
        puts $fh "TRANSITION_LIST(\"$clk_to_data($clk)\")
{
	NODE
	{
		REPEAT = 1;
		LEVEL Z FOR [format {%.3f} $start_time ];
		LEVEL $first_level FOR [format {%.3f} [expr { abs($timing_data($first_analysis,min)) } ] ];
		LEVEL $second_level FOR [format {%.3f} [expr { abs($timing_data($second_analysis,min)) } ] ];
		LEVEL Z FOR 1;
	}
}"

    }
    # end of foreach for transition list

    # And after the clock/data transition list,
    # make a transition list for the legend. The waveform divider has
    # no transition list
    puts $fh "TRANSITION_LIST(\"Legend\")\n{\n    NODE\n    {\n        REPEAT = 1;"
    foreach { level duration } $legend_level_duration {
        puts $fh "        LEVEL $level FOR $duration;"
    }
    puts $fh "    }\n}"

    # After the transition list, write the display list
    foreach { clk clk_name } $clk_display_names {

        # Shove the data up half a clock cycle so it lines up with the rising edge
        set abs_time [expr { $vwf_clk_info($clk,abs_time) + $half_period } ]
        
        puts $fh [vwf_display_line -channel $clk_name \
            -comments [list \
            [list TIME [expr { $abs_time + 0.03}] RISE 2 RUN 45 TEXT \
                "Time: [format {%.3f} $vwf_clk_info($clk,abs_time)]"] \
            ] ]
        puts $fh [vwf_display_line -channel $clk_to_data($clk)]
    }
    
    # And we have to display the waveform divider...
    puts $fh [vwf_display_line -channel "divider 1" -is_divider]
    
    # ... and then the Legend
    # Add 1ns to the x and u to get the arrow heads a bit better centered.
    set legend_zero [expr { [lindex $legend_level_duration 1] / 2 } ]
    set legend_x [expr { ( 2 * $legend_zero ) + ([lindex $legend_level_duration 3] / 2) } ]
    set legend_u [expr { ( 2 * $legend_zero ) + [lindex $legend_level_duration 3] + \
        [lindex $legend_level_duration 5] + ([lindex $legend_level_duration 7] / 2) } ]
    puts $fh [vwf_display_line -channel "Legend" \
        -comments [list \
        [list TIME $legend_zero RISE 20 RUN 20 TEXT "Time: 0"] \
        [list TIME $legend_x RISE 20 RUN 20 TEXT "Indicates negative margin"] \
        [list TIME $legend_u RISE 20 RUN 20 TEXT "Indicates positive margin"] \
        ] ]
        
    # Put in the master time bar
    puts $fh [vwf_time_bar -time $half_period -is_master]

    # And relative time bars for the clock cycles
    set on_cycle 1
    while { $on_cycle <= $clock_cycles} {
        puts $fh [vwf_time_bar -time [expr { $half_period + ( $on_cycle * 2 * $half_period ) } ] ]
        incr on_cycle
    }

    # Finish up the file
    puts $fh ";"

    }
    # End of { [process_side $opts(read_side)] }
    
    close $fh
}

################################################################################
proc dtw_automation::vwf_signal { args } {

    set options {
        { "channel.arg" "" "Name of the signal" }
    }
    array set opts [::cmdline::getoptions args $options]

    return "SIGNAL(\"$opts(channel)\")
{
	VALUE_TYPE = NINE_LEVEL_BIT;
	SIGNAL_TYPE = SINGLE_BIT;
	WIDTH = 1;
	LSB_INDEX = -1;
	DIRECTION = INPUT;
	PARENT = \"\";
}"
}

################################################################################
proc dtw_automation::vwf_display_line { args } {

    set options {
        { "channel.arg" "" "Name of the signal" }
        { "is_divider" "Is the display line a divider?" }
        { "comments.arg" "" "List of comments" }
    }
    array set opts [::cmdline::getoptions args $options]
    variable tree_index
    
    set to_return "DISPLAY_LINE
{
	CHANNEL = \"$opts(channel)\";
	EXPAND_STATUS = COLLAPSED;
	RADIX = Binary;
	TREE_INDEX = $tree_index;
	TREE_LEVEL = 0;
"
    if { $opts(is_divider) } { append to_return "	IS_DIVIDER = ON;\n" }
    
    # Handle any comments
    foreach comment $opts(comments) {
        append to_return "	COMMENT\n	{\n"
        foreach {keyword value} $comment {
            switch -exact -- $keyword {
                "TEXT" { set value "\"$value\"" }
                "TIME" { set value [format {%.0f} [expr { 1000 * $value }]] }
            }            
            append to_return "		$keyword = $value;\n"
        }
        append to_return "		FONT_NAME = \"Arial\";
		FONT_SIZE = 0;
		FONT_STYLE = \"Regular\";
		FONT_COLOR = 0;
	}"
    }
    append to_return "}\n"

    incr tree_index
    return $to_return
}

################################################################################
proc dtw_automation::vwf_time_bar { args } {

    set options {
        { "time.arg" "" "Time for the time bar" }
        { "is_master" "Is this the master time bar?" }
    }
    array set opts [::cmdline::getoptions args $options]

    if { $opts(is_master) } { set master TRUE } else { set master FALSE }

    return "TIME_BAR\n{
	TIME = [format {%.0f} [expr { 1000 * $opts(time) } ] ];
	MASTER = $master;\n}"
}

################################################################################
#        { "get_pll_phase_from_dtw" "Get the current PLL phase from DTW instead of Quartus II report" }
proc dtw_automation::main { args } {

    set options {
        { "dwz_file.arg" "" "Name of dwz file to read" }
        { "after_iptb.arg" "none" "Action to take after regenerating the core with the IP Toolbench. none/import/import_and_compile" }
        { "auto_adjust_cycles" "Update the cycle adjust automatically?" }
        { "debug" "Print debug messages?" }
        { "extract_tcos.arg" "auto" "Extract tcos? yes/no/auto/prompt" }
        { "ignore_move" "Runs the script even though file names in the DWZ file have changed" }
        { "ignore_phase_difference" "Ignore the reported PLL phase difference" }
        { "ignore_version" "Open the project even though its version might not match the software version" }
        { "last_sdc_file.arg" "" "SDC file to read after reading all other sdc files" }
        { "name_filter.arg" "" "Filter for path names within core" }
        { "qdr_recaptured_name_filter.arg" "*io_recaptured_data*" "Name for the QDR recaptured data registers" }
        { "read_side.arg" "auto" "Do read-side analysis? tanrpt/tq/skip/auto" }
        { "rec_rem_margin_tradeoff.arg" "0ns" "Recovery/removal margin to trade off for better postamble margin" }
        { "sdc_file.arg" "dwz" "Location of SDC file to process for interface timing - auto/dwz/project/<file name>" }
        { "stop_after.arg" "5" "Number of iterations attempted with -auto_adjust_cycles" }
        { "vwf_file_name.arg" "" "Name for a VWF file with waveform information" }
        { "write_side.arg" "auto" "Do write-side analysis? tanrpt/tq/skip/auto" }
    }

    # Print help if the script is called with no arguments
    if { [string equal "" $args] } {
        puts [::cmdline::usage $options]
        return 0
    }

    # If the script is called with -? or -help, the cmdline package
    # returns the usage as an error message.
    if { [catch { ::cmdline::getoptions args $options } res ] } {
        puts $res
        return 0
    } else {
        array set opts $res
    }

    variable data_array
    variable pnl_str
    variable script_options
    variable name_filter_defaults
    variable script_build
    variable mem_rpt_str
    set flag 1
 	set data_list [list]

    post_message "Script build $script_build"

    # Error if the specified DWZ file doesn't exist
    if { ! [file exists $opts(dwz_file)] } {
        post_message -type error \
            "$opts(dwz_file) does not exist. Specify a valid file name"
        return 0
    }

    # Check that specified post-dtw SDC file exists
    if { ![string equal "" $opts(last_sdc_file)] } {
        if { ! [file exists $opts(last_sdc_file)] } {
            post_message -type error "SDC file specified for -last_sdc_file\
                $opts(last_sdc_file) does not exist"
            return 0
        }
    }

    # Verify syntax of the postamble margin tradeoff
    if { [regexp {^([0-9\.]+)\s*(ns|ps|%)$} $opts(rec_rem_margin_tradeoff) -> value units] } {
        set script_options(r_r_margin_tradeoff) "$value $units"
    } else {
        post_message -type error "Invalid value for -rec_rem_margin_tradeoff: $opts(rec_rem_margin_tradeoff)"
        return 0
    }

    # Try to source the DWZ file
	if {[catch {source $opts(dwz_file)}]} {
        post_message -type error "Can't read $opts(dwz_file)"
        return 0
    } else {
        array unset data_array
        array set data_array $data_list
    }

    # Make sure that the dwz filename in the DWZ file is the same one
    # passed in with the option
    if { ! $opts(ignore_move) } {
        if {![same_dwz_file_location -dwz_file $opts(dwz_file)] } {
            post_message -type error "You moved the project since the last time\
                you ran DTW. Some files may not be found."
            post_message -type error "Rerun DTW and update file locations, or\
                rerun the script with -ignore_move to override this warning."
            return 0
        }
    }

    # Get the project name
    set project [file tail $data_array(project_path)]

    # Warn if the project and software versions do not match.
    if { ! $opts(ignore_version) } {
        if { [catch { verify_versions_match } match ] } {
            post_message -type error $match
            return 0
        } elseif { ! $match } {
            post_message -type error "The project version and software\
                version are different. Use the correct software, or rerun the\
                script with -ignore_version to override this warning."
            return 0
        }
    }

    # Set various global options
    set script_options(debug) $opts(debug)
    set script_options(dwz_settings) \
        [file tail [file rootname $data_array(output_filename)]]
    set script_options(sdc_file) $opts(sdc_file)
    set script_options(interface_name) ""
    set script_options(last_sdc_file) $opts(last_sdc_file)
    set script_options(get_pll_phase_from_dtw) 0
    set script_options(vwf_file_name) $opts(vwf_file_name)
    set script_options(qdr_recaptured_name_filter) $opts(qdr_recaptured_name_filter)
    
    # Attempt to get the core name from the import file
    if { [info exists data_array(import_path)] } {
        set import_file [file tail $data_array(import_path)]
        if { [regexp -- {^(.*)_\w+?_settings.txt} $import_file \
            --> script_options(interface_name)] } {
            # We got the core name
        } else {
            post_message -type info "Couldn't automatically determine\
                memory interface name."
        }
    }

    # What is a known pattern in the core name?
    # If the name_filter option is not blank, use the specified name filter.
    # If the name_filter option is blank, we have to come up with something
    # for it. If the script_options(interface_name) is not blank, we can
    # use that.
    # If both of those are blank, it's an error, and the user has to
    # provide a name_filter.
    if { ![string equal "" $opts(name_filter)] } {

        regsub {^\*?(.*?)\*?} $opts(name_filter) {*\1*} opts(name_filter)
        set script_options(name_filter) $opts(name_filter)

    } elseif { ![string equal "" $script_options(interface_name)] } {

        # Assemble the name filter for paths in the core
        set nfd_temp $name_filter_defaults($data_array(memory_type))
        set script_options(name_filter) \
            *${script_options(interface_name)}_${nfd_temp}*
    } else {

        post_message -type error "Couldn't automatically determine a pattern\
            to match names in the hierarchy of this memory controller."
        post_message -type error "You must use the -name_filter option to\
            specify a pattern that matches names in the hierarchy \
            of this memory controller only."
        return 0

    }

    puts_debug "Name filter is $script_options(name_filter)"
    
    # Set up a mode string based on the memory type, hardware dqs or not,
    # and 1/2 PLLs
    switch -exact -- $data_array(memory_type) {
        "ddr" {
            set uhd $data_array(use_hardware_dqs)
            set icfi $data_array(is_clk_fedback_in)
            set script_options(mem_type_dqs_pll_mode) ${uhd}_${icfi}
            set script_options(period) [dtw_timing::get_ns $data_array(mem_tCK)]
            set script_options(is_ddr) 1
        }
        "qdr2" {
            set script_options(mem_type_dqs_pll_mode) \
                ${data_array(memory_type)}_${data_array(use_hardware_dqs)}
            set script_options(period) [dtw_timing::get_ns $data_array(q2_tKHKH)]
            set script_options(is_ddr) 0
        }
        "rldram2" {
            set script_options(mem_type_dqs_pll_mode) \
                ${data_array(memory_type)}_${data_array(use_hardware_dqs)}
            set script_options(period) [dtw_timing::get_ns $data_array(rl2_tCK)]
            set script_options(is_ddr) 0
        }
        default {
            post_message -type error "Unknown memory: $data_array(memory_type)"
            return 0
        }
    }

    puts_debug "Detected <MEM>_<DQS>_<PLL> mode:\
        $script_options(mem_type_dqs_pll_mode)"

    # Open the project and load the report
    if { [catch {project_open $project -revision $data_array(project_revision)} \
        res] } {
        post_message -type error $res
        return 0
    }

    if { [catch { load_report } res] } {
        post_message -type error "Can't load report. Is project compiled?"
        post_message -type error $res
        return 0
    }

    # Color command-line messages    
    set_user_option -name DISPLAY_COMMAND_LINE_MESSAGES_IN_COLOR 1

    # Check PLL phase shifts reported by the Quartus II software
    # against what's saved in the dwz file. Make sure they are close,
    # otherwise exit out explaining they're not the same
    if { ! $opts(ignore_phase_difference) } {
        if { [catch { match_pll_phase_to_dwz } res] } {
            post_message -type error $res
            return 0
        } elseif { 0 == $res } {
            return 0
        }
    }

    # Make sure all the names are correct
    if { ! [check_io_and_pll_names_match] } {
        return 0
    }
    
    #########################################################################
    # Move this into a separate procecure - just to clean up main
    #########################################################################

    # If there is an error getting the USE_TIMEQUEST_TIMING_ANALYZER assignment,
    # or you can get it and it's not ON, and read- and write-side
    # analyses are "auto", set to tan/tq. Else set it to tq/tq
    set asgn OFF
    if { [catch {
        get_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER} asgn] } {

        post_message "Couldn't find USE_TIMEQUEST_TIMING_ANALYZER setting in QSF"
    }

    # If we are using TimeQuest in the fitter...
    if { [string equal -nocase "ON" $asgn]} {
        set script_options(uses_tq_in_fitter) 1
        switch -exact -- $opts(read_side) {
            auto { set opts(read_side) "tq" }
            tanrpt {
                post_message -type error "You use the TimeQuest analyzer\
                    during fitting, so you can't use the tanrpt value for the\
                    -read_side option."
                return 0
            }
        }
        switch -exact -- $opts(write_side) {
            auto { set opts(write_side) "tq" }
            tanrpt {
                post_message -type error "You use the TimeQuest analyzer\
                    during fitting, so you can't use the tanrpt value for the\
                    -write_side option."
                return 0
            }
        }
    } else {
        # We use TAN in the fitter
        set script_options(uses_tq_in_fitter) 0
        if { [string equal -nocase "auto" $opts(read_side)] } {
            set opts(read_side) "tanrpt"
        }
        if { [string equal -nocase "auto" $opts(write_side)] } {
            set opts(write_side) "tq"
        }
    }

    # We may have to use TimeQuest on the read side if there is
    # a multicycle warning in the dwz.tcl file
    if { [string equal -nocase "tanrpt" $opts(read_side)] } {
        if { [catch {multicycle_warning_exists} exists] } {
            post_message -type warning "Not checking for unsupported\
                multicycle assignment because $exists"
        } elseif { $exists } {
            post_message -type warning "Timing constraints include a\
                multicycle assignment the Classic timing analyzer\
                does not support."
            post_message -type warning "Switching to the TimeQuest analyzer\
                for read-side analysis and reporting"
            set opts(read_side) "tq"
        }
    }

    # Set a flag for whether it uses TimeQuest or not.
    set script_options(uses_tq) [expr {
        [string equal -nocase "tq" $opts(read_side)] || \
        [string equal -nocase "tq" $opts(write_side)] }]
    # set a flag for whether it uses Classic Timing Analyzer or not
    set script_options(uses_tan) [expr {
        [string equal -nocase "tanrpt" $opts(read_side)] || \
        [string equal -nocase "tanrpt" $opts(write_side)] }]

    #########################################################################
    #########################################################################

    # If read-side reporting is with tanrpt, ensure recovery/removal analysis
    # is on for DDR
    # TODO
    set rr_asgn OFF
    if { [catch {
        get_global_assignment -name ENABLE_RECOVERY_REMOVAL_ANALYSIS } rr_asgn] } {

        post_message -type error "Couldn't find ENABLE_RECOVERY_REMOVAL_ANALYSIS setting in QSF"
        return 0

    } elseif { $script_options(is_ddr) && \
        [string equal -nocase "tanrpt" $opts(read_side)] && \
        ! [string equal -nocase "ON" $rr_asgn] } {
    
        post_message -type error "Turn on Enable Recovery/Removal analysis, then rerun timing analysis, then rerun this script"
        return 0
    }
    
    # Check for the optimize hold timing assignment
    check_optimize_hold_timing

    # Are the DQS signals cut?
    # TODO - is this TAN only?
    check_cut_dqs

    # TODO - This is write_side = tanrpt only
    # Swap the settings name into the TAN timegroups
    foreach tg [array names pnl_str *_timegroup] {
        regsub {%settings_name%} $pnl_str($tg) $script_options(dwz_settings) \
            pnl_str($tg)
    }

    # Start timequest if necessary, if it's used in the extraction...
    if { $script_options(uses_tq) } {
        # If it's not running...
        if {! [tq_is_running] } {
            # If there's an error starting it...
            if { [catch { start_tq } res] } {
                post_message -type error $res
                return 0
            }
        }
    }
    
    # The update process may need to be run multiple times.
    while { $flag } {
    
        # If it's being run after the IP toolbench, perform analysis and synthesis,
        # DTW import, and a complete compile, then continue.
        # Allow this to run before trying to open the project.
        switch -exact -- $opts(after_iptb) {
            "none" { }
            "import" {
                if { [catch { after_ip_toolbench -project $project \
                    -dwz_file $opts(dwz_file) } res] } {
    
                    post_message -type error $res
                }
                # If you don't compile, you can't do anything else...
                set flag 0
            }
            "import_and_compile" {
                if { [catch { after_ip_toolbench -project $project \
                    -dwz_file $opts(dwz_file) -compile } res] } {
    
                    post_message -type error $res
                    set flag 0
                }
                # This set of options does it all. But the second time through,
                # The settings don't need to be reimported.
                if { $opts(auto_adjust_cycles) } { set opts(after_iptb) "none" }
                # Pre-set extract tcos to allow the script to run to completion
                # TODO - enable on DDR memory type only
                if { [string equal -nocase "prompt" $opts(extract_tcos)] } {
                    post_message "Tcos will be extracted automatically because you\
                        are using the -after_iptb import_and_compile option"
                    set opts(extract_tcos) "auto"
                }
            }
            default {
                post_message -type error "Value for -after_iptb must be\
                    none/import/import_and_compile"
                set flag 0
            }
        }
    
        # Are cycles being automatically adjusted?
        if { $flag && $opts(auto_adjust_cycles) } {
            if { [catch { auto_adjust_cycles -project $project \
                -dwz_file $opts(dwz_file) -stop_after $opts(stop_after)} flag] } {
    
                post_message -type error $flag
                set flag 0
            }
        }
    
        # Check tcos only if it's DDR meory.
        # DTW shipped with 7.1 does not use tCO extraction with TimeQuest
        if { $flag && $script_options(is_ddr) } {
        
            if { [is_71] && $script_options(uses_tq_in_fitter) } {
                # skip TCO extraction
            } elseif { [catch {
                check_extract_tcos -project $project -action $opts(extract_tcos) \
                -dwz_file $opts(dwz_file)} flag] } {
    
                post_message -type error $flag
                set flag 0
            }
        }

        if { $flag && $script_options(uses_tan) } {
            if { [catch {get_timing_analyzer_settings} flag] } {
    
                post_message -type error $flag
                set flag 0
            }
        }

#            control -read_side $opts(read_side) -write_side $opts(write_side)
        if { $flag && [catch {
            control -read_side $opts(read_side) -write_side $opts(write_side)} res]} {
    
            post_message -type error $res
            set flag 0
        }

        
        # Stop if we're not auto-adjusting cycles
        if { ! $opts(auto_adjust_cycles) } {
            set flag 0
        }
    }

    # Close TimeQuest
    if { $script_options(uses_tq) } {
        quit_tq
    }

}

eval ::dtw_automation::main $quartus(args)

catch {
    unload_report
    project_close
}
