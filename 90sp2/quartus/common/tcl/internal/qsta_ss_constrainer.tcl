################################################################################
# TODO - Known issues and limitations
# * Many spurious warnings about :empty_col could not be matched with a
#    clock - most are related to get_clocks_on_node, where getting
#    the master clock pin for a virtual clock results in a warning.
# * Do not use the Minimum data valid timing requirement field. No SDC 
#    constraints are generated for it.
# * If you target a HardCopy device, GUI elements say FPGA instead of
#    "HardCopy device"
# * Waveform zooming is disabled on the timing requirements page.
# * When you use a system synchronous common clock clocking configuration,
#    you must manually create a virtual clock that matches the clock
#    parameters of the clock on the FPGA clock input port.
# * If the checkbox next to an interface is grayed out, you must step
#    through each page of its wizard to make it valid so SDC constraints
#    can be generated for it.
# * Messages in the interface tree about invalid clocks are not removed
#    even after the clock in question has been validated
# * If you edit a clock used by multiple interfaces, the parameters you
#    use for the last edit are used for the clock in the multiple
#    interfaces, even if the clock parameters were different in another
#    interface.
# * If a clock is reported as invalid because a source or target name has
#    changed, clocks that depend on it are not also reported as invalid.
# * The target for the output clock in a source synchronous output in a
#    Stratix GX device is incorrect.
# * If the source and destination clocks take more than 20 cycles to repeat,
#    the setup and hold relationships used to calculate
#    timing constraints will be wrong.
# * The hold relationship used to calculate timing constraints may not be
#    closest to 0 of all worst-case relationships, but it is a worst-case
#    relationship
# * If you use the script to generate SDC constraints, then edit your design
#    so data port names or directions used in the script change, the script
#    does not warn you of the changes the next time you use the script.
#    You must make any necessary updates by stepping through the wizard for
#    each affected interface.
# * The board trace delay values must use the same units, even though you
#    can set the units to different values
# * On the timing requirements page, you must click Update waveform diagram
#    if you want to see the diagram update as a result of a change you have
#    made on the page.
# * If you enter board trace delay values, you must enter them for all three
#    traces, even though the source clock trace delay is ignored for source
#    synchronous source clock configurations, and the destination clock trace
#    delay is ignored for source synchronous destination clock configurations
# 
# TODO - UI improvements
# There are a variety of UI improvements I could do to make it more user
# friendly
# * Add text describing support for min/max and nominal +/- variation style
#    board trace delay values (E)
# * Add a progress bar while update_timing_netlist is running (M)
# * Name browser found/matching listbox headings (M)
# * Disable the next button when the netlist is being created/updated (M)
# * Handle targeting a HardCopy device in the diagrams and titleframes
#    that say "FPGA" (M)
# * Add drag-and-drop ordering support for interfaces in tree (M/H)
# * Add a delete/remove button for the interfaces tree (E)
# * Bind delete to the data ports list (M)
# * Add MegaWizard-style tabs to navigate (H)
# * Include explanatory comment in SDC file for max/min delays that align
#    skew method clocks (E)
# * Add introductory text to timing requirements page (E)
# * Bind <Return> in the clock_port_name entry widgets to invoke
#    wizard::wizard_back_next -next (M)
# * Add checkboxes to include SDC and reporting script files in project
#    Disable unless there are file names specified. (M)
# * Use wizard::handle_cancel to put up a confirmation dialog when you click
#    Cancel (E)
# * Add an option to copy an interface in the interfaces tree. Insert it
#    named "Copy of <original name>" (M)
# * Annotate the timing diagram with vertical time bars at 10ns intervals (M)
# * Annotate the timing diagram with time values (M)
# * If you have picked skew timing for a source sync interface, then you
#    change the interface to system sync, skew is no longer a valid IO timing
#    method. Currently you are warned with a post_message. Maybe you should
#    be warned with a tk message box (E)
#
# TODO - New functionality
# * Use the term interface to refer to a group of constraints of multiple
#    buses and IO pins. Use the tree structure to define interfaces
#    at the first tree level, and buses and IOs within the interface at
#    the second tree level. (H)
# * Validate all port names when the wizard is started, and report missing
#    names in the interfaces tree (H)
# * When editing data ports page, gray out data port names that do not exist in
#    the current version of the design, so they're easy to see to remove (M)
# * Add new clock_configuration for a clock that feeds back into the FPGA (M)
# * Add clock uncertainties and latencies on the board timing frame (H)
# * Include derive_clock_uncertainty in the generated SDC file (E)
# * Add UI option to specify period/mc for alignment method. (M)
# * Add option to use derive_pll_clocks results. Don't allow editing of
#    clocks that come out of that, depending on the option. Then use
#    derive_pll_clocks in the SDC. Put derive_pll_clocks option up front.
#    It has to be before you have a chance to edit the clocks. (H)
# * When you choose system sync common clock, don't allow entry of the
#    virtual clock. Make it automatically with the same parameters as the
#    clock(s) on the input clock port(s) (M/H)
# * Another idea is to compare base and virtual clocks and error if there are
#    not ones with identical settings (M)
# * Add generated SDC file and reporting script to project file list.
#    If you use the file picker box, it returns a full path. There's usually
#    no reason to save the full path unless it's not in the project
#    directory. Maybe strip off enough to make it relative to the
#    project directory? If it goes to another drive, then that whole path
#    gets saved. (M)
# * Get information about buses that might have been entered already with
#    the pin planner (H)
# * Get information about board traces that might have been entered already
#    with advanced IO timing (H)
# * When to save on exit and when to exit without saving?
# * Auto-update the clock diagram on requirement value change (H)
# * If there are invalid clocks in clocks_data, add an item to the clock
#    entry windows that lets you populate the settings with settings from
#    invalid clocks that exist in clocks_data. Populate any settings except
#    for source and target. Filter the list according to the invalid clock
#    type e.g. display only generated clocks in the generated clock dialog. (M)
#
# TODO - Internal checks I can do better
# * Do validity checking against the design names and the names saved in
#    the iowizard file, and indicate any problems when you start the script
#    (like dtw_timing_analysis) (M)
# * Validate entries in shift and transfer spinboxes to ensure integers (E)
# * Check to make sure iowizard file is writeable and catch the puts
#    in case something goes wrong (full disk, etc) - full disk dies silently
# * Check to make sure the SDC file is writeable and catch the puts
#    in case something goes wrong (full disk, etc)
# * Ensure the adjust cycle is preset even if you raise that page out of
#    order (M)
# * Validate data_register_names on timing netlist creation (M)
# * Validate data_port_names on timing netlist creation (M)
# * I have to check master clock names (recursively) when I validate clocks (M)
# * SDR interfaces where clock and data have common clocks and a DDIO reg
#    driving clock out implies inverted for center aligned and non-inverted for
#    edge aligned
# * DDR interfaces where clock and data have common clocks and a DDIO reg
#    driving clock out forces edge aligned and non-inverted
# * Check phase shift difference of source and dest for source sync clock
#    configuration against degree_shift value and warn if too far off
# * +/- values for tco/mintco probably aren't what the user intended
#
# TODO - Internal infrastructure I can improve
# * Shift as necessary to get smallest positive setup/hold launch and
#    latch times. I can do this with advance_to_next_valid_setup_3 (M/H)
# * Add done/not-done flags to each page so I can know whether
#    SDC can be generated (M/H)
# * Be smarter about what clocks to save. Don't write out ones from an
#    SDC file. Be careful about ones that were auto-generated. If they were
#    modified, then save them. Otherwise, don't. That will be tricky. (H)
# * Check support for Stratix II, III, IV, and Cyclone II, III (M/H)
# * Add support for Stratix GX (M)
# * Switch to the trace command to enable and disable GUI elements (M/H)
# * Consider making shared_data global (H)
# * Can I save enough data about clock periods and waveform to avoid
#    creating the timing netlist every time you run the script (H)
# * Switch first two pages so you pick the interface first, then create the
#    timing netlist if you want to change something (H)
# * Support iowizard file that is saved somewhere other than the
#    project directory (M)
# * Build regtest infrastructure (H)
# * Write out clock info to iowizard file in the order it's in the tree,
#    so any dependencies are guaranteed to be met if the clock info is read
#    back in list order (H)
# * For board timing numbers, allow freeform entry with a regexp validator
#    to allow stuff in ns, ps, mils, inches, and +/- ns, ps, mils, inches,
#    or percent (M)
# * If you have a clock used by an interface, should you be able to edit that
#    clock if it's used in another interface, and change a setting?
#    That affects a bunch of stuff, including how I de-dup clocks when saving
#    the data into the project namespace to write into the iowizard file.
#    For example, if I constrain one interface and use clock A, then
#    constrain another interface, but change the phase shift of A, what do
#    I do? Which has priority? Can you even do that? (H)
# * Consider switching in clocks_info namespace the direction, clock_configuration,
#    and data_rate variables to other_data (M)
# * If data port names change, visit src or dest clock depending on direction
# * If direction changes, visit clock configuration, src clock, dest clock,
#    clock relationship
# * Data rate changes -> src clock, dest clock, clock relationship, requirements
# * If clock configuration changes, visit src clock, dest clock, relationship
#    info, requirements info
# * If clock port name changes, visit src clock, dest clock
# * If target changes, visit requirements
# * Fill old_data at init_ time.
# * Don't attempt to populate clock trees if direction is unset.
#    Additionally, depending on direction and clock configuration, don't
#    attempt to populate if there's no register ID.
# * Rework clock tree population time. Maybe populate clock trees when the
#    wizard is shown. Otherwise, if you raise a clock tree page, the
#    tree might not be populated (M)
# * init_diagram_info needs work to include valid values (M)
# * Potentially disable editing all clocks that are SDC-defined. (M)
# * Potentially disable editing all clocks that are auto-generated through
#    the derive_pll_clocks command the script runs (M)
# * What should I do if there are errors during file generation when you
#    click Finish in the manager GUI? Pop an error dialog and not exit?
#    I shouldn't fail silently. Fail, but post the error messages? (M)
# * Gray out same/opposite radio buttons when you turn on advanced false paths
# * List as a message pages that must be visited for an interface to become
#    valid (M)
# * sdc_info namespace has alignment_method variable which is not aligned with
#    the alignment method var in the interface data (M)
# * Just visiting the src_clock and dest_clock pages is not enough to get them
#    out of the pages_to_see list. The clocks in those trees must be valid.
#    At least one clock on the final node must be valid.
# * Pull clock_status into its own namespace
# * Validate data port names when the page manager page is being changed
#    in handle_back_next (H)
# * Instead of binding clicks on the interfaces tree to update_nav_buttons_state,
#    and having that procedure reach back to the interfaces namespace to
#    get the selected interfaces, consider using ensure_selected in the
#    interfaces namespace and pushing the result into the gui namespace
#    with update_nav_buttons_state -enable or -disable
# * Any clocks that are placeholders should be stuck in the interfaces tree
#    as messages when the wizard is withdrawn. (H)
# * Does there need to be more granularity on how the clocks data is stored?
#    Placeholders don't get saved, but unvalidated clocks should be flagged
#    as messages. I know that any clock coming out of the wizard with
#    clock_status of 1 is validated and not a placeholder. We should still save
#    to the iowizard file clocks that are not placeholders but have status of 0.
# * All clocks coming out of the src and dest trees have to be checked against
#    clocks_data and valid_clocks. Any clocks that are valid have to be
#    checked for existence in clocks_data and removed if in there. For example,
#    you could have a clock called foo that was not validated because its
#    target node had been changed. However, if you make a clock called foo
#    in the clock trees window, and it is validated, it has to be pulled from
#    clocks_data. (H)
# * Retire src_and_dest_clocks, and save the results coming back from
#    validate_src_tree_clocks and validate_dest_tree_clocks to populate the
#    combobox.
# * validate_{src,dest}_tree_clocks needs to walk up the tree and ensure that
#    there's a validated chain of clocks back to an input port
# * validate_relationship_info might need to check advanced_false_paths (M)
# * When to do validation? Validate on any done. When you click done,
#    validate the information from the page you were on when you clicked
#    done. Then take each of the items in pages_to_see and validate those
#    pages. Push the information forward into those pages and do the validation.
# * In a bidirectional data port case, should no radio button be selected, to
#    force you to select one before you continue? (E)
# * Fix timing diagram insertion after zoom (H)
# * Force all trace delay values to use the same units. Have one combobox
#    to pick the units for all 3 values. That makes it neater in the SDC
#    because different units would require multiple long conversion strings
#    but a single unit would mean only one conversion string. (M)
# * Disable the next button on each screen until enough information is
#    filled in to make it valid to go to the next screen (H)
#
# Updates from version 23 beta to version 24 beta
# * Updated waveform drawing calculation to account for multicycles
# * Switched messages about pages_to_see variable from going to the console
#    to going to the log file
# * Fixed problem where waveform diagram canvas was not erased in between
#    editing different interfaces.
# * Fixed error when validating a non-standard clock shift amount in the
#    clock_relationship page
# * If the timing netlist can't be created, the script handles this condition
#    and displays an error message, instead of a Tcl/Tk error message
# * Updated clock derivation process to first attempt to derive pll clocks
#    and appropriate base clocks, then if there is an error with that, to
#    fall back to deriving only PLL clocks, then only after those attempts,
#    to create base clocks. This change means at least the same number of
#    clocks as before will be derived with correct values, and probably more,
#    in most cases (because of support for the -create_base_clocks option)
# * Added text to SDC generation page telling users to add the SDC file
#    to the project files list.
# * Fixed a bug where each time you previewed SDC constraints, an additional
#    copy of the constraints was added. ret_str was set as a namespace
#    variable, not a variable local to the new_sdc procedure.
# * Fixed a problem where selecting a clock port for a source synchronous
#    interface with the name finder returned the name in curly braces. That
#    behavior resulted in a port name string comparison returning false,
#    causing the generated clock dialog to be shown when creating a generated
#    clock on a source synchronous output clock port, instead of the simplified
#    generated clock dialog.
# * Fixed a bug where selecting the src_sync_destination_clock clocking
#    configuration had an error preventing validation. The fill_src_tree
#    procedure referred to the dest_tree variable
#
# Updates from version 24 beta to 25 beta
# * Script was writing a copy of the SDC constraints to standard out.
#    Behavior changed to not do that any more.
# * Fixed an error with the name of the variable used to store the name of
#    the clock port name in a source synchronous interface. When you double-
#    clicked to create the generated clock on the output port, the complete
#    generated clock dialog appeared, instead of the simplified version.
# * When a master clock was required for creating a clock, the name of
#    the master clock was not being added to to the clock_info array before
#    the generated clock dialogs were drawn. As a result, no master clock was
#    specified, so the newly created clock was invalid because multiple
#    master clocks were not disambiguated
# * Fixed problem where data waveform would be drawn incorrectly. Waveform
#    is drawn by calculating setup/hold latch times and inserting alternating
#    valid/invalid windows between those times. When setup/hold latch times
#    did not interleave (typically when a DDR waveform was shifted by more than
#    one clock cycle), the valid/invalid windows were drawn so they overlapped.
# * Added worst case slack reporting to timing reporting script
# * The algorithm to determine when the -add_delay option is necessary was
#    incorrect. It tracked only the exact combination of -clock and -clock_fall
#    options and ignored whether there were other combinations of those
#    options. When there is more than one combination of -clock and -clock_fall
#    the -add option is always required, because without it, some constraints
#    will always be removed.
# * A previous fix for clock port names with bit selects was incomplete.
#    Modified the validate_port_names procedure to return a flat string when
#    only one port is called for
# * The wrong diagram was drawn for the source sync dest clock configuration
# * There was an error in the procedure to draw the source sync dest clock
#    diagram. The wrong X and Y coordinates were used to draw the clock source.
# * Timing requirements namespace initialized the io_timing_method when the
#    initial chunk of data was passed in. A timing method of max_skew was
#    set as the default for source sync interfaces. If the clocking config was
#    changed to system sync, a message indicated that skew was not supported
#    for system sync. The user never selected either, so it was confusing.
#    It is not necessary to initialize the io_timing_method until we prepare
#    to raise the page.
# * Moved the call for check_shift_and_duration from init_timing_req to 
#    prep_for_raise, because it depends on the value of io_timing_method.
#    io_timing_method may not be set by init_timing_req, per the previous fix.
# * There was no check to ensure that that the clock port for source
#    synchronous interfaces was an output.
# * The wording for the clock port entry with the source sync dest clock
#    clocking config said to enter the name of the clock port that received
#    the clock. That is wrong, because for an output configuration, the
#    dest clock is virtual, and for an input configuration, the source clock
#    comes out of the dest device as a generated clock.
# * Added case-insensitive option to name_finder dialog
# * Moved the check for skew timing for system sync out of init_timing_req
#    into prep_for_raise. It used the io_timing_method variable, which is
#    now being set (if unset) in prep_for_raise
# * Automated testing failed due to a DISPLAY variable being required. One is
#    required when the BWidget package is loaded. If the BWidget package is
#    loaded outside the script, it can be sourced in an environment without a
#    DISPLAY variable.
#
# Updates from version 25 beta to 26 beta
# * The script checked to make sure that the clock port in a source
#    synchronous interface was an output port, without checking to see whether
#    the clock port should be used.
# * Changed [get_clocks] calls to [all_clocks] per SPR 280332
# * Fixed problem where 3-series families, derivatives, and newer, have the
#    DDR register -> output paths cut in the model, so you couldn't
#    constrain output interfaces.

lappend auto_path quartus(binpath)
#package require BWidget
package require cmdline
package require struct
load_package report

################################################################################
# Namespace for building messages and displaying them in a Tk tree, with
# a look and feel similar to Quartus II messages
namespace eval q_messages {

    variable message_index 0
    
    # Holds the icons created with the image create photo command, below.
    variable icons
    array set icons [list]

    # What color does each type of message get displayed in?
    variable color_map
    array set color_map { Info green4 {Extra Info} green4 Warning blue \
        {Critical Warning} blue Error red Debug black}

    # The raw icon data that will be converted to Tk images
    variable icon_data
    array set icon_data [list]
    set icon_data(Info) {R0lGODdhEAAQAPMAAAAAAAAA/wCAAICAAICAgMDAwP9/////AP///wAAAAAA
        AAAAAAAAAAAAAAAAAAAAACwAAAAAEAAQAAAEOhDJSWslZRJiEe8Z9UlBqZ1U
        GUrh2k1AVwYVME5zvVW5yI0zk8T20t1ilYLtJiEAkJvd68OceoqWagQAOw==}
    set icon_data(Warning) {R0lGODdhEAAQAPMAAAAAAAAA/wCAAICAAICAgMDAwP9/////AP///wAAAAAA
        AAAAAAAAAAAAAAAAAAAAACwAAAAAEAAQAAAEQRDJSatFp1w7zgHENnleKHYk
        KHoAUG5oy5oUkbpvRX54RiMozyD4oe2OnoKJmOnNMEfZTglFIgkEphUUwnq/
        YEQEADs=}
    set icon_data(Error) {R0lGODdhEAAQAPMAAAAAAAAA/wCAAAokaoAAAICAgMDAwP8AAP///wAAAAAA
        AAAAAAAAAAAAAAAAAAAAACwAAAAAEAAQAAAEQRDJSWslJx9CLMJa2FFgaFIa
        EqrZCE4ZnBVsXIm1LZlEccqa3uoWLLx2B2CBlloVJSWTZjmJiqgUo6hH8yy/
        WEkEADs=}
    set n {Critical Warning}
    set icon_data($n) {R0lGODdhEAAQAPIAAAAAAICAAMDAwICAgP//AP///wAAAAAAACwAAAAAEAAQ
        AAADP1i63F5EPBcIAWMua7OuHKZxnEeRltgMaOmkQAgIZgFeMRBfJqrvEc8N
        BuRBSDoch3aEyUqDYSs1yFSv2GwhAQA7}
    set n {Extra Info}
    set icon_data($n) {R0lGODdhEAAQAPIAAAAAAMDAwICAgAAA/////wAAAAAAAAAAACwAAAAAEAAQ
        AAADOUi63C1hCeEIrZFdMvqQoNKJn5JlXDkuQON5DLClFSFv66pM1vLGs5qN
        JyQEbo7ZhFi5BGuUp/CZAAA7}
    set icon_data(Debug) {R0lGODdhEAAQAPIAAAAAAMDAwICAgAAA/////wAAAAAAAAAAACwAAAAAEAAQ
        AAADOUi63C1hCeEIrZFdMvqQoNKJn5JlXDkuQON5DLClFSFv66pM1vLGs5qN
        JyQEbo7ZhFi5BGuUp/CZAAA7}

    proc init_message_images { args } {

        variable icon_data
        variable icons
        
        # Walk through all the icon data and create the images.
        foreach ibuild [array names icon_data] {

            # This is two steps due to this suggestion:
            # http://wiki.tcl.tk/643
            set icons($ibuild) [image create photo]
            $icons($ibuild) put $icon_data($ibuild)
        }
    }

    ################################
    # Format a raw Quartus II message and insert it into a tree with an
    # appropriate icon, at a specified parent. Also automatically process
    # sub messages. This procedure would be called by a procedure intercepting
    # calls to msg_tcl_post_message
    proc build_message { args } {
    
        set options { \
            { "tree.arg" "" "Tree widget to build messages in" }
            { "msg_struct.arg" "" "Message struct" } \
            { "insert_at.arg" "" "Parent to insert child at" } \
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable icons
        variable message_index
        variable color_map
        
        # Break apart the message struct
        foreach { m_type m_code m_contents m_string m_subs m_locs m_severity } \
    	   $opts(msg_struct) { break }
    
    	$opts(tree) insert end $opts(insert_at) msg_${message_index} -text \
    	    $m_string -fill $color_map($m_type) -image $icons($m_type)
    	set parent msg_${message_index}
    	incr message_index

        # Walk through each of the submessages and recurse on them.
        foreach m $m_subs {
    	   build_message -msg_struct $m -insert_at $parent -tree $opts(tree)
        }
    }

    ################################
    # I create message lists similar to Quartus II messages, but there's a lot
    # of information I don't need, like the contents, the locations, etc.
    # Format such a message and insert it into a tree with an appropriate icon,
    # at a specified parent. Also automatically process sub-messages
    # Return the node of the top-level message os it can be used later as the
    # parent for sub messages
    proc build_generic_message { args } {

        set options { \
            { "tree.arg" "" "Tree widget to build messages in" }
            { "msg_list.arg" "" "Message list" } \
            { "insert_at.arg" "" "Parent to insert child at" } \
            { "type.arg" "" "Info, warning, error, etc"}
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable icons
        variable message_index
        variable color_map
        
        # Break apart the message struct
        foreach { m_string m_subs } $opts(msg_list) { break }
    
    	$opts(tree) insert end $opts(insert_at) msg_${message_index} -text \
    	    "${opts(type)}: $m_string" -fill $color_map($opts(type)) \
            -image $icons($opts(type))
    	
        set insertion_node msg_${message_index}
            
    	set parent msg_${message_index}
    	incr message_index

        # Walk through each of the submessages and recurse on them.
        foreach m $m_subs {
    	   build_generic_message -msg_list $m -insert_at $parent \
                -tree $opts(tree) -type $opts(type)
        }
        
        return $insertion_node
    }
}
# End of q_message namespace

################################################################################
# Namespace for the name finder dialog box.
# Handles dialog box creation, searches for names, transfers between
# match and selected lists.
namespace eval name_finder {

    variable filter         ""
    variable match_list     [list]
    variable selected_list  [list]
    variable entry_path     ""
    variable nf_dialog      ""
    variable force_one      0
    variable case_insensitive   0
    
    ##############################################
    # Assemble a dialog for the name finder
    proc assemble_dialog { args } {
    
        set options {
            { "parent.arg" "" "Parent widget of the dialog" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        variable filter
        variable match_list
        variable selected_list
        variable entry_path
        variable nf_dialog
        variable case_insensitive
        
        set nf_dialog [Dialog .nf_dialog -modal local -side bottom \
            -anchor e -parent $opts(parent) -title "Name Finder" \
            -cancel 1 -transient no]
        $nf_dialog add -name ok -width 10
        $nf_dialog add -name cancel -width 10
        
        # Configure the validation on the OK button
        $nf_dialog itemconfigure 0 -command "[namespace code verify_one_or_many]\
            -dialog $nf_dialog -index 0"
            
        set f [$nf_dialog getframe]
    
        # Filter label and entry at the top
        grid [LabelFrame $f.lf -text "Filter:   " -side left] -sticky ew -pady 5
        set subf [$f.lf getframe]
        set e [entry $subf.e -textvariable [namespace which -variable filter]]
        pack $e -side top -fill x -expand true

        # Titleframe for the options
        set options_tf [TitleFrame $f.o -text "Options" -ipad 4]
        set subf [$options_tf getframe]
        pack [checkbutton $subf.ci -text "Case-insensitive" -variable \
            [namespace which -variable case_insensitive]] -side top -anchor w
        
        # Titleframe for the matches
        set match_tf [TitleFrame $f.t -text "Matches" -ipad 8]
        set subf [$match_tf getframe]
        pack [button $subf.l -text "List" -width 10] -side top -anchor w -pady 4
    
        # Frame to hold the listboxes and button frame
        set lbf [frame $subf.f]
        set lsw [ScrolledWindow $lbf.lsw -auto both]
        pack [listbox $lsw.lb -selectmode extended -bg white \
            -listvariable [namespace which -variable match_list]] \
            -fill both -expand true
        $lsw setwidget $lsw.lb
        pack $lsw -side left -fill both -expand true
    
        # a or d means add or delete
        # o or a means one or all
        set bf [frame $lbf.b]
        pack [button $bf.ao -text ">" -width 4] -side top -pady 4
        pack [button $bf.aa -text ">>" -width 4] -side top -pady 4
        pack [button $bf.do -text "<" -width 4] -side top -pady 4
        pack [button $bf.da -text "<<" -width 4] -side top -pady 4
        pack $bf -side left -anchor n -padx 8
        
        set rsw [ScrolledWindow $lbf.rsw -auto both]
        pack [listbox $rsw.lb -bg white -selectmode extended \
            -listvariable [namespace which -variable selected_list]] \
            -fill both -expand true
        $rsw setwidget $rsw.lb
        pack $rsw -side left -fill both -expand true
    
        pack $lbf -side top -fill both -expand true -anchor n
        
        grid $options_tf -sticky news -pady 4
        grid $match_tf -sticky news
        grid rowconfigure $f 2 -weight 1
        grid columnconfigure $f 0 -weight 1

        $bf.ao configure -command [namespace code [list transfer_nodes \
            -from_listbox $lsw.lb -from_list_var match_list \
            -to_list_var selected_list -selected]]
        $bf.aa configure -command [namespace code [list transfer_nodes \
            -from_listbox $lsw.lb -from_list_var match_list \
            -to_list_var selected_list -all]]
        $bf.do configure -command [namespace code [list transfer_nodes \
            -from_listbox $rsw.lb -from_list_var selected_list \
            -to_list_var match_list -selected -remove]]
        $bf.da configure -command [namespace code [list transfer_nodes \
            -from_listbox $rsw.lb -from_list_var selected_list \
            -to_list_var match_list -all -remove]]
        bind $lsw.lb <Double-1> [namespace code [list transfer_nodes \
            -from_listbox $lsw.lb -from_list_var match_list \
            -to_list_var selected_list -selected]]
        bind $rsw.lb <Double-1> [namespace code [list transfer_nodes \
            -from_listbox $rsw.lb -from_list_var selected_list \
            -to_list_var match_list -selected -remove]]
        $subf.l configure -command [namespace code populate_match]
        bind $e <Return> [list $subf.l invoke]
        wm protocol $nf_dialog WM_DELETE_WINDOW [list $nf_dialog withdraw]
        
        set entry_path $e
    }

    ##############################################
    # Fill in the matching nodes list based on the
    # filter string entered
    proc populate_match { } {
    
        variable filter
        variable match_list
        variable case_insensitive
        
        set temp_list [list]
        set command "get_ports $filter"
        if { $case_insensitive } {
            append command " -nocase"
        }
        foreach_in_collection id [eval $command] {
            lappend temp_list [get_node_info -name $id]
        }
        set match_list [lsort -dictionary $temp_list]
    }

    ##############################################
    # Transfer nodes between two listboxes. Optionally
    # remove them from the source listbox.
    # TimeQuest doesn't remove nodes from the left listbox when you
    # put them in the right listbox, but it doesn't insert duplicates
    # if you try again. It does remove them from the right listbox though, if
    # you transfer from right to left
    proc transfer_nodes { args } {
    
        set options {
            { "from_listbox.arg" "" "Source listbox" }
            { "from_list_var.arg" "" "Source list"}
            { "to_list_var.arg" "" "Destination list"}
            { "selected" "Transfer only the selected ones"}
            { "all" "Transfer all of them"}
            { "remove" "Remove the nodes from the source list box?"}
        }
        array set opts [::cmdline::getoptions args $options]
    
        upvar 1 $opts(from_list_var) from_list
        upvar 1 $opts(to_list_var) to_list
    
        # First put together a list of items that gets inserted in the to_list
        if { $opts(selected) } {
            foreach item [$opts(from_listbox) curselection] {
                lappend items [$opts(from_listbox) get $item]
            }
        } elseif { $opts(all) } {
            set items $from_list
        }
    
        # Then do the actual insertion, but only if they don't exist
        # in the to list
        foreach item $items {
            if { -1 == [util::lsearch_with_brackets $to_list $item] } {
                lappend to_list $item
            }
        }
    
        # If they're being removed from the from_list, do it via the listbox.
        if { $opts(remove) } {
    
            if { $opts(all) } {
                $opts(from_listbox) selection set 0 end
            }
    
            foreach item [lsort -decreasing -integer [$opts(from_listbox) curselection]] {
                $opts(from_listbox) delete $item
            }
        }
    }

    ##############################################
    # Show the dialog, with an optional set of
    # prefilled selected. Also pass in the name of
    # a variable to hold the result. Return 1 on
    # OK, 0 on cancel
    proc show_dialog { args } {

        set options {
            { "prefill_selected.arg" "" "A list to show in the selected side" }
            { "selected_var.arg" "" "Name of the variable for result"}
            { "force_one" "Allow only one selected item" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable nf_dialog
        variable filter
        variable entry_path
        variable match_list
        variable selected_list
        variable force_one
        
        set filter "*"
        set match_list [list]
        set selected_list $opts(prefill_selected)
        
        # Initialize the force_one variable in the namespace, regardless of
        # whether it is 1 or 0
        set force_one $opts(force_one)
        
        set dialog_result [$nf_dialog draw $entry_path]
        if { 0 == $dialog_result } {
            upvar 1 $opts(selected_var) return_list
            if { $force_one } {
                set return_list [lindex $selected_list 0]
            } else {
                set return_list $selected_list
            }
            return 1
        } else {
            return 0
        }
    }
    
    ############################################3
    proc verify_one_or_many { args } {
    
        set options {
            { "dialog.arg" "" "Name of the dialog that would be withdrawn" }
            { "index.arg" "" "Button index that was clicked" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable force_one
        variable selected_list
        
        # If we're requiring one item to be selected, and not one
        # is selected, put up a message and don't exit the dialog
        if { $force_one && (1 != [llength $selected_list]) } {
            tk_messageBox -icon error -type ok -default ok \
                -title "Selection error" -parent [focus] -message \
                "Only one I/O port can be selected. You selected [llength $selected_list]."
        } else {
            $opts(dialog) enddialog $opts(index)
        }
    }
}
# End of name_finder namespace

################################################################################
# Holds information related to the Quartus II project and manages the
# first page of the GUI when you run the script.
# This namespace holds information about all the clocks in the project,
# and tracks how each clock was created.
namespace eval project_info {

    # GUI elements
    variable sdc_files_lb
    
    variable create_timing_netlist_button   ""
    variable project_file           ""
    variable old_project_file       ""
    variable revision               ""
    variable old_revision           ""
    variable read_sdc               0
    variable old_read_sdc           0
    variable checked_sdc_files      [list]
    variable old_checked_sdc_files  [list]
    variable tq_elapsed_time        ""
    variable netlist_button_default_text "Create/update timing netlist"
    variable sdc_defined_clock_ids     [list]
    variable data_file_defined_clock_ids   [list]
    variable auto_generated_clock_ids  [list]
    variable default_virtual_clock  ""
    variable open_button
    variable first_time             1
    variable clocks_data
    array set clocks_data [list]
    variable images
    array set images [list]
    variable valid_clocks
    array set valid_clocks [list]
    variable last_saved_by_version  ""
    
    ############################################################################
    # Assembles an array of two images, one that is an empty square and one
    # that is a checked square. They're used in the SDC files listbox
    proc create_images { args } {
    
        variable images

        set images(unchecked) [image create bitmap -data {
        #define unchecked_width 11
        #define unchecked_height 11
        static unsigned char unchecked_bits[] = {
           0xff, 0x07, 0x01, 0x04, 0x01, 0x04, 0x01, 0x04, 0x01, 0x04, 0x01, 0x04,
           0x01, 0x04, 0x01, 0x04, 0x01, 0x04, 0x01, 0x04, 0xff, 0x07};
        }]
        set images(checked) [image create bitmap -data {
        #define checked_width 11
        #define checked_height 11
        static unsigned char checked_bits[] = {
           0xff, 0x07, 0x01, 0x04, 0x01, 0x05, 0x81, 0x05, 0xc5, 0x05, 0xed, 0x04,
           0x7d, 0x04, 0x39, 0x04, 0x11, 0x04, 0x01, 0x04, 0xff, 0x07};
        }]
    }
        
    ################################################
    # Put together the project GUI page, on the frame
    # that's passed in
    proc assemble_tab { args } {
    
        set options {
            { "frame.arg" "" "Frame to assemble the project tab on" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable sdc_files_lb
        variable create_timing_netlist_button
        variable project_file
        variable revision
        variable read_sdc
        variable netlist_button_default_text
        variable tq_elapsed_time
        variable open_button
        
        # Don't pack this frame, because it comes from a getframe
        set f $opts(frame)

        # Title frame to hold the project name picker and revision combobox
        set proj_tf [TitleFrame $f.project -text "Project" -ipad 8]
        set sub_f [$proj_tf getframe]
        
        # Brief instructions
        pack [label $sub_f.l -text "Your project and revision"] \
            -anchor nw
        pack [Separator $sub_f.sep -relief groove] \
            -side top -anchor n -fill x -expand true -pady 5
        
        # Set up the project name picker
        set proj_lf [LabelFrame $sub_f.proj_lf -side left -text "Project file"]
        set ssub_f [$proj_lf getframe]
        set proj_bu [button $ssub_f.b -text "Open..." -width 10]
#        pack $proj_bu -side right
        pack [entry $ssub_f.e -textvariable \
            [namespace which -variable project_file]] -side right -fill x \
            -expand true
        pack $proj_lf -fill x -expand true -pady 5
        
        # Set up the revision combobox
        set rev_lf [LabelFrame $sub_f.rev_lf -side left -text "Revision"]
        set ssub_f [$rev_lf getframe]
        set rev_cb [ComboBox $ssub_f.rev_cb -textvariable \
            [namespace which -variable revision]]
        pack $rev_cb -fill x -expand true
        pack $rev_lf -fill x -expand true -pady 5
        
        # Align the labels for Project and Revision
        LabelFrame::align $proj_lf $rev_lf
        
        # Grid in the top titleframe
        grid $proj_tf -sticky news

        # Set up the title frame to hold the list of SDC files
        set sdc_tf [TitleFrame $f.sdc_files -text "SDC files" -ipad 8]
        set sub_f [$sdc_tf getframe]

        # Brief instructions
        grid [label $sub_f.l0 -text "SDC files that have been added to\
            your project appear in the list below." \
            -justify left] \
            -sticky w
        grid [label $sub_f.l1 -text "You can control which SDC files this\
            script reads by checking or unchecking them." \
            -justify left] \
            -sticky w
        grid [Separator $sub_f.sep -relief groove] \
            -sticky ew -pady 5

        set read_sdc_cb [checkbutton $sub_f.cb -text \
            "Read SDC file(s). If files listed contain clock\
            constraints, turn on this option and select those files." \
            -justify left \
            -variable [namespace which -variable read_sdc]]
        grid $read_sdc_cb -sticky w
        
        # Set up for the list of SDC files
        set sdc_files_sw [ScrolledWindow $sub_f.sw -auto both]
        set sdc_files_lb [ListBox $sdc_files_sw.lb -bg white -deltay 16 \
            -height 8]
        $sdc_files_sw setwidget $sdc_files_lb
        grid $sdc_files_sw -sticky news
        
        # Make the SDC files listbox the thing to expand
        grid rowconfigure $sub_f 4 -weight 1
        
        # Expand the column on resize
        grid columnconfigure $sub_f 0 -weight 1
        
        # Grid in the SDC files titleframe
        grid $sdc_tf -sticky news -pady 8

        # Set up timing netlist titleframe
        set net_tf [TitleFrame $f.netlist -text "Timing netlist" -ipad 8]
        set sub_f [$net_tf getframe]

        # Brief instructions
        pack [label $sub_f.l -text "Create/update a timing netlist when you open\
            a project, change the revision, or select different SDC files." \
            -justify left] \
            -side top -anchor nw
        pack [Separator $sub_f.sep -relief groove] \
            -side top -anchor nw -fill x -expand true -pady 5

        # Estimated time
        set time_lf [LabelFrame $sub_f.tq_lf -text "Estimated time based on last\
            compilation:" -side left]
        set sssub_f [$time_lf getframe]
        pack [label $sssub_f.l -textvariable \
            [namespace which -variable tq_elapsed_time] -justify left] \
            -side top -anchor nw
        pack $time_lf -side top -anchor nw

        # Create timing netlist button
        set netlist_bu [button $sub_f.b -text $netlist_button_default_text \
            -width 30 -command [namespace code on_create_timing_netlist_button]]
        set create_timing_netlist_button $netlist_bu
        pack $netlist_bu -side top -pady 8

        # Grid in the timing netlist titleframe
        grid $net_tf -sticky news
        
        # Configure resize behavior
        grid columnconfigure $f 0 -weight 1
        grid rowconfigure $f 1 -weight 1
        
        # Disable the revision labelframe, the SDC titleframe, and the
        # timing netlist titleframe.
        # Put them in a variable so they can be used later
        set disabled_widgets [list $rev_lf $sdc_tf $net_tf]
        foreach w $disabled_widgets {
            util::recursive_widget_state -widget $w -state disabled
            util::recursive_widget_state -widget [$w getframe] -state disabled
        }

        # Handle the Open button for a project
        $proj_bu configure -command "[namespace code on_open_button] \
            -widgets [list $disabled_widgets] \
            -revisions_combobox $rev_cb"
        set open_button $proj_bu
        
        # Handle switching the revision
        $rev_cb configure -modifycmd "[namespace code on_revision_combobox] \
            -revision_var revision"
        
        # Toggle the checkmark next to the SDC file in the list of SDC files
        $sdc_files_lb bindImage <Button-1> "[namespace code on_sdc_files_listbox] \
            -sel" 
        $sdc_files_lb bindText <Button-1> "[namespace code on_sdc_files_listbox] \
            -sel" 

        # Handle the "Read SDC file(s) checkbox"
        $read_sdc_cb configure -command [namespace code on_read_sdc_checkbutton]

    }

    #############################################
    # Handle the Open... button
    # Now that the project is already open when the script is run,
    # this procedure is called to start the script.
    proc on_open_button { args } {

        set options {
            { "widgets.arg" "" "Widgets to enable" }
            { "revisions_combobox.arg" "" "Revisions combobox" }
        }
        array set opts [::cmdline::getoptions args $options]

# [open_project]
        if { 1 } {

            # if we open a project, enable lots of widgets
            foreach w $opts(widgets) {
                util::recursive_widget_state -widget $w -state "normal"
                util::recursive_widget_state -widget [$w getframe] -state "normal"
            }

            # get the list of project revisions
            $opts(revisions_combobox) configure -values [get_project_revisions]
            $opts(revisions_combobox) setvalue first

            # Load the data file, if it exists
            if { [catch {load_data_file} res] } {
                # There was an error reading the data file.
                # You can quit now and not lose it, or continue and lose it.
                post_message -type error "Could not read data file [data_file_name]"
                switch -exact -- [ask_to_quit_on_data_file_error -error_text $res] {
                    "yes" { gui::ExitApp -dont_save_file }
                    "no" { set data [list] }
                }
            } else {
                set data $res
            }
            
            interfaces::init_interfaces -data $data
            
            # populate and configure the SDC files listbox
            populate_sdc_files_listbox
            set_sdc_files_listbox_state

            # Set the last elapsed time
            set_timequest_elapsed_time

            # set the netlist button text
            update_timing_netlist_button -reset_to_default_text
        }
    }

    #########################################################
    # Show a message box to warn about data file syntax errors.
    # Exit immediately or continue, according to what the user chooses
    proc ask_to_quit_on_data_file_error { args } {
    
        set options {
            { "error_text.arg" "" "The error text" }
        }
        array set opts [::cmdline::getoptions args $options]

        return [tk_messageBox -icon error -type yesno -default yes \
            -title "Could not read data file [data_file_name]" \
            -parent [focus] -message \
            "There is an error in the file that stores information you entered ([data_file_name]).\
            \nYou will lose all the information you entered if you continue.\
            \nYou may be able to edit the file to correct the error if you quit now.\
            \nThe following message may help identify the line with the error.\
            \n\n${opts(error_text)}\n\nDo you want to quit?" \
        ]
    }
    
    #############################################
    # Things to do when you change the revision
    # * set the current revision to the new revision
    # * refill the SDC files box
    # * get the last elapsed time
    # * set the create netlist button text
    proc on_revision_combobox { args } {

        set options {
            { "revision_var.arg" "" "Variable with revision name"}
        }
        array set opts [::cmdline::getoptions args $options]

        upvar $opts(revision_var) revision
        set_current_revision $revision

        if { [project_info_changed -project_revision] } {
        
            # Load a new data file
            if { [catch {load_data_file} res] } {
                # There was an error reading the data file.
                # You can quit now and not lose it, or continue and lose it.
                post_message -type error "Could not read data file [data_file_name]"
                switch -exact -- [ask_to_quit_on_data_file_error -error_text $res] {
                    "yes" { gui::ExitApp -dont_save_file }
                    "no" { set data [list] }
                }
            } else {
                set data $res
            }
            
            interfaces::init_interfaces -data $res
            
            populate_sdc_files_listbox
            set_sdc_files_listbox_state
            set_timequest_elapsed_time
            update_timing_netlist_button -reset_to_default_text
        }
    }

    ############################################
    # Handle clicks on the checkboxes in the SDC
    # listbox. Boxes that were unchecked get checked, and vice versa
    proc on_sdc_files_listbox { args } {
    
        set options {
            { "sel.arg" "" "Selection"}
        }
        array set opts [::cmdline::getoptions args $options]

        flip_sdc_file_selection -sel $opts(sel)
        update_timing_netlist_button -reset_to_default_text
    }
    
    #############################################
    # Handle the Read SDC file(s) checkbutton
    # The SDC files listbox has to be enabled or disabled appropriately
    # And if you want to change reading SDC files, we have to reset the text
    # on the create timing netlist button
    proc on_read_sdc_checkbutton { args } {

        set_sdc_files_listbox_state
        update_timing_netlist_button -reset_to_default_text
    }
    
    ######################################################
    # A procedure to wrap up any text updates to make to the 
    # create timing netlist button
    proc update_timing_netlist_button { args } {
    
        set options {
            { "reset_to_default_text" "Set defautlt text" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable create_timing_netlist_button
        variable netlist_button_default_text
        
        if { $opts(reset_to_default_text) } {
            $create_timing_netlist_button configure -text $netlist_button_default_text
        } else {
            return -code error "Unknown option for update_timing_netlist_button"
        }
    }
    
    ######################################
    # Handle the create/update netlist button
    proc on_create_timing_netlist_button { args } {

        variable first_time
        variable create_timing_netlist_button
        
        . configure -cursor "watch"
        $create_timing_netlist_button configure -text "Working..." -state "disabled"

        update idletasks

        # If we have a new project or revision, recreate the timing netlist
        if { [project_info_changed -project_revision] } {
            if { [timing_netlist_exist] } {
                delete_timing_netlist
            }
            
            if { [catch { create_timing_netlist } res] } {
                # There was an error creating the timing netlist. This could
                # happen for a few reasons. The most common reason would be that
                # the project has not been completely compiled.
                # Alert the user, configure the button text, and return
                tk_messageBox -icon error -type ok -default ok \
                    -title "Netlist creation error" -parent [focus] -message \
                    "The timing netlist could not be created for the\
                    following reason. If necessary, exit this script,\
                    compile your design and rerun this script.\n\n$res"
                $create_timing_netlist_button configure -text "Error"
                . configure -cursor ""
                return
            
            }
        }

        # If the constraints changed, reset the design to prep for rereading
        # constraints
        if { [project_info_changed -sdc] } {
            reset_design
        }

        # If anything changed, reread constraints and clear out I/O names
        if { [project_info_changed] || $first_time } {
            if { $first_time } { set first_time 0 }
            initialize_sta_constraints
        }

        $create_timing_netlist_button configure -text "Done" -state "normal"
        . configure -cursor ""
    }

    ################################################   
    # Present a file open dialog box for a user to
    # open a project. Don't open the project if the
    # software and project versions don't match.
    # Return 1 if the project was opened successfully,
    # 0 otherwise
    proc open_project { args } {

        variable project_file
        global quartus

        set types {
            {{Project Files}       {.qpf}        }
        }
        set chosen_file [tk_getOpenFile -filetypes $types]

        if { ! [string equal "" $chosen_file]} {

            set project_file $chosen_file
            set project_name [file root [file tail $chosen_file]]
            cd [file dirname $chosen_file]

            # If the project version is different than the script version,
            # don't open it.
            if { [catch {util::get_project_version -project $project_name} res] } {

                tk_messageBox -icon error -type ok -default ok \
                    -title "Project error" -parent [focus] -message $res
                return 0

            } elseif { ! [string equal $res $quartus(version)] } {

                tk_messageBox -icon error -type ok -default ok \
                    -title "Software version mismatch" -parent [focus] -message \
                    "The Quartus II software version you used to\
                    compile the project is different than the version you\
                    are using to run this script.\
                    \nSoftware version: $quartus(version)\
                    \nProject version: $res"
                return 0

            } else {

                if { [is_project_open] } { project_close }
                project_open $project_name -current_revision
                return 1
            }
        } else {
            return 0
        }
    }

    ##################################################
    # Fill the listbox with the names of any SDC files
    # that are part of the project.
    # If the SDC file is in the checked_sdc_files list, indicating
    # it is to be read, draw a checked box next to it in the listbox.
    # If it is not in the checked_sdc_files list, draw an unchecked
    # box next to it in the listbox.
    proc populate_sdc_files_listbox { args } {
        
        variable sdc_files_lb
        variable images
        variable checked_sdc_files
        
        set box_item_id 0
        set sdc_file_collection [get_all_global_assignments -name "SDC_FILE"]
        
        # Clean out the list box first
        $sdc_files_lb delete [$sdc_files_lb items]
    
        # For each SDC file in the project, add it if it exists
        foreach_in_collection asgn $sdc_file_collection {
    
            foreach { section name value entity tag } $asgn { break }
            
            if { [file exists $value] } {
                incr box_item_id
                $sdc_files_lb insert end $box_item_id -text $value
                    
                if { -1 == [lsearch $checked_sdc_files $value] } {
                    # If the file is not in the checked list
                    $sdc_files_lb itemconfigure $box_item_id \
                        -data [list "sdc_file" $value "checked" 0] \
                        -image $images(unchecked)
                } else {
                    # If the file is in the checked list
                    $sdc_files_lb itemconfigure $box_item_id \
                        -data [list "sdc_file" $value "checked" 1] \
                        -image $images(checked)
                }
            }
        }
        
        # It's possible there are no SDC files. Tell the user.
        if { 0 == $box_item_id } {
            $sdc_files_lb insert end $box_item_id -text \
                "There are no SDC files in your project file list." \
                -data [list "sdc_file" {} "checked" 0]
        }    
    }

    ############################################
    # Enables or disables the SDC files listbox based on the state of
    # the read_sdc variable backing the Read SDC files checkbutton
    # In addition to enabling/disabling, the
    # procedure also sets the foreground color
    # to black for enabled or grey50 for disabled. 
    proc set_sdc_files_listbox_state { args } {
    
        variable sdc_files_lb
        variable images
        variable read_sdc
    
        if { $read_sdc } {
            set state "normal"
            set fg_color "black"
        } else {
            set state "disabled"
            set fg_color "grey50"
        }
    
        # Enable or disable the listbox
        $sdc_files_lb configure -state $state
    
        # Configure the checked and unchecked images
        $images(checked) configure -foreground $fg_color
        $images(unchecked) configure -foreground $fg_color
    
        # Set the foreground color of the items in the listbox
        foreach item [$sdc_files_lb items] {
            $sdc_files_lb itemconfigure $item -foreground $fg_color
        }
    }

    ###########################################
    # Get the elapsed time of the last TQ run during compilation
    # and put that value into the variable backing the label in the GUI
    # that says how long to expect the netlist to take.
    proc set_timequest_elapsed_time { args } {

        variable tq_elapsed_time

        if { [catch {util::get_module_elapsed_time -regexp_pattern {^TimeQuest}} res] } {
            set tq_elapsed_time "unknown - this may take a few minutes."
        } elseif { [regexp {^(\d+):(\d+):(\d+)$} $res -> hours minutes seconds] } {
    
            # Strip any leading zeros
            regexp {0(\d)} $hours -> hours
            regexp {0(\d)} $minutes -> minutes
    
            if { ![string equal "0" $hours] } {
                set tq_elapsed_time "about $hours hours and $minutes minutes."
            } elseif { $minutes > 0 } {
                set tq_elapsed_time "about $minutes minutes."
            } else {
                set tq_elapsed_time "less than 1 minute."
            }
        } else {
            set tq_elapsed_time "unknown - this may take a few minutes"
        }
    }
    
    ###############################################
    # Returns 1 if there was a change in the values
    # on the project tab.
    proc project_info_changed { args } {
    
        set options {
            { "project_revision" "Did project/revision change?" }
            { "sdc" "Did SDC stuff change?" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        variable project_file
        variable revision
        variable read_sdc
        variable checked_sdc_files
        variable old_project_file
        variable old_revision
        variable old_read_sdc
        variable old_checked_sdc_files
        
        set project_changed [expr {![string equal $project_file $old_project_file]}]
        set revision_changed [expr {![string equal $revision $old_revision]}]
        set read_sdc_changed [expr { $read_sdc != $old_read_sdc }]
        set checked_sdc_changed [expr { $read_sdc && \
            ! [util::check_lists_equal $checked_sdc_files $old_checked_sdc_files]}]
            
        if { $opts(project_revision) } {
            return [expr { $project_changed || $revision_changed }]
        } elseif { $opts(sdc) } {
            return [expr { $read_sdc_changed || $checked_sdc_changed }]
        } else {
            return [expr { $project_changed || $revision_changed || \
                $read_sdc_changed || $checked_sdc_changed }]
        }
    }

    ###########################################
    # Allows you to check or uncheck SDC files
    # in the listbox of SDC files
    # Also keeps the data associated up to date
    # Also inserts or removes the selection from
    # the list of checked SDC files
    # so changes to the list can be tracked
    proc flip_sdc_file_selection { args } {
    
        set options {
            { "sel.arg" "" "Selected node" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable sdc_files_lb
        variable images
        variable checked_sdc_files

        array set temp [$sdc_files_lb itemcget $opts(sel) -data]
        if { $temp(checked) } {
            set temp(checked) 0
            $sdc_files_lb itemconfigure $opts(sel) -image $images(unchecked)
        } else {
            set temp(checked) 1
            $sdc_files_lb itemconfigure $opts(sel) -image $images(checked)
        }
        $sdc_files_lb itemconfigure $opts(sel) -data [array get temp]

        # If it's now checked, it was not before,
        # so it must be added to the list
        # If it's not checked, it was before,
        # so it must be removed from the list
        if { $temp(checked) } {
            lappend checked_sdc_files $temp(sdc_file)
        } else {
            set item_index [lsearch $checked_sdc_files $temp(sdc_file)]
            set checked_sdc_files [lreplace $checked_sdc_files \
                $item_index $item_index]
        }
    }

    ############################################################################
    # This procedure iterates over all the clocks defined in the iowizard
    # data file. It checks to make sure the source and target names exist,
    # and if they do (the clock is valid), the clock information is transfered
    # from the array of clocks read in from the iowizard file to an array
    # of valid clocks. At the end of the procedure, all entries left in
    # the clocks_data array are clocks that are not valid (source, target, or
    # both don't exist in the netlist). All clocks that are valid have
    # been put into the valid clocks array.
    proc validate_clock_names { args } {
    
        variable clocks_data
        variable valid_clocks
        
        log::log_message "\nValidating clocks read in from the iowizard file"
        log::log_message "------------------------------------------------"
        
        # Clear out any existing errors
        array unset clock_errors
        array set clock_errors [list]
        
        # Check each of the clocks. If a source or target name doesn't exist
        # in the netlist, the clock can't be made
        foreach clock_name [array names clocks_data] {
        
            array unset temp
            array set temp $clocks_data($clock_name)
            array unset clock_info
            array set clock_info $temp(clock_info)
            
            if { [clock_source_and_target_exist -clock_info_var clock_info \
                -error_var clock_errors] } {
            
                # If they exist, put them in the valid data structure and
                # remove the data from the clocks_data structure
                set valid_clocks($clock_info(name)) $clocks_data($clock_name)
                unset clocks_data($clock_name)
                log::log_message "Successfully validated $clock_info(name)"
                
            } else {
                # Provide the error somewhere
                log::log_message "$clock_info(name) had the following errors:"
                log::log_message $clock_errors($clock_info(name))
            }
        }
        
        return [array get clock_errors]
    }
     
    ############################################################################
    # This procedure checks whether the source and target for a particular
    # clock exist in the netlist. Users can run the wizard and create clocks,
    # then change the design names or design hierarchy, and then rerun
    # this script. It's possible that the clock target or source names
    # will have changed, resulting in clocks that are invalid.
    # Pass in the name of a variable that holds the clock_info array,
    # and the name of a variable that holds a list of error messages.
    # If either the source or target nodes don't exist in the netlist,
    # an error message is generated and put into the error list variable.
    # The procedure returns whether or not there are errors (missing source
    # or target nodes)
    # Virtual clocks have no source or target, so they are always valid
    proc clock_source_and_target_exist { args } {
    
        set options {
            { "clock_info_var.arg" "" "" }
            { "error_var.arg" "" "Array of errors that were found" }
        }
        array set opts [::cmdline::getoptions args $options]
        
        upvar $opts(clock_info_var) clock_info
        upvar $opts(error_var) clock_errors
        
        set has_errors 0
        
        set clock_name $clock_info(name)
        
        # If there's a target specified (base or generated clocks),
        # then check to make sure only one name from the netlist matches.
        if { [info exist clock_info(targets)] } {
        
            set target_collection [get_nodes $clock_info(targets)]
            set num_targets [get_collection_size $target_collection]

            if { 0 == $num_targets } {
                lappend clock_errors($clock_name) [list "$clock_name was not\
                    created because its target named $clock_info(targets)\
                    can not be found."]
                set has_errors 1
            } elseif { 1 == $num_targets } {
                # Good
            } else {
                # More than 1 node matches.
                set matching_nodes [list]
                foreach_in_collection id $target_collection {
                    if { 10 > [llength $matching_nodes] } {
                        # Make sure we don't get a huge list if the node
                        # name is something like *. Limit the list to 10.
                        lappend matching_nodes [get_node_info -name $id]
                    }
                }
                
                set matching_nodes [lsort -dictionary $matching_nodes]
                
                # If there are more than 10 matching nodes, just say how many
                # are not on this list.
                set num_matching_nodes [llength $matching_nodes]
                if { $num_targets > 10 } {
                    lappend matching_nodes "[expr { $num_targets - $num_matching_nodes }] \
                        more node(s) match but this list is limited to 10 node names."
                }
                
                set msg [list "$clock_name was not created because there are\
                    $num_targets node names that match\
                    its target named $clock_info(targets) but only 1 should match." \
                    $matching_nodes]
#                lappend msg $matching_nodes
                lappend clock_errors($clock_name) $msg
                set has_errors 1
            }
        }
        
        # If there's a source specified (generated clocks), get its ID
        # then check to make sure only one name from the netlist matches.
        if { [info exist clock_info(source)] } {
        
            set source_collection [get_nodes $clock_info(source)]
            set num_sources [get_collection_size $source_collection]

            if { 0 == $num_sources } {
                lappend clock_errors($clock_name) [list "$clock_name was not\
                    created because its source named $clock_info(source)\
                    can not be found."]
                set has_errors 1
            } elseif { 1 == $num_sources } {
                # Good
            } else {
                # More than 1 node matches
                set matching_nodes [list]
                foreach_in_collection id $source_collection {
                    if { 10 > [llength $matching_nodes] } {
                        # Make sure we don't get a huge list if the node
                        # name is something like *. Limit the list to 10.
                        lappend matching_nodes [get_node_info -name $id]
                    }
                }
                
                set matching_nodes [lsort -dictionary $matching_nodes]
                
                # If there are more than 10 matching nodes, just say how many
                # are not on this list.
                set num_matching_nodes [llength $matching_nodes]
                if { $num_targets > 10 } {
                    lappend matching_nodes "[expr { $num_targets - $num_matching_nodes }] \
                        more node(s) match but this list is limited to 10 node names."
                }
                
                set msg [list "$clock_name was not created because there are\
                    $num_sources node names that match\
                    its source named $clock_info(source) but only 1 should match." \
                    $matching_nodes]
#                lappend msg $matching_nodes
                lappend clock_errors($clock_name) $msg
                set has_errors 1
            }
        }
        
        # If there are no errors, return 1, else return 0
        return [expr { ! $has_errors }]
    }
    
    ############################################################################
    # This procedure does the read_sdc/update_timing_netlist part of 
    # preparing TimeQuest.
    # It also builds the lists of which clocks were created from reading an
    # existing SDC file, which were created from the information saved in
    # the iowizard file, and which were created from the derive_clocks and
    # derive_pll_clocks commands
    # The timing netlist must exist before this procedure is called.
    proc initialize_sta_constraints { args } {
    
        variable sdc_files_lb
        variable read_sdc
        variable default_virtual_clock
        variable sdc_defined_clock_ids
        variable data_file_defined_clock_ids
        variable auto_generated_clock_ids
#        variable clocks_data
        variable valid_clocks
        
        . configure -cursor "watch"
        update idletasks

        # If you choose to read SDC files, read any that you checked.
        if { $read_sdc } {
    
            # To find out whether an SDC file is checked, you have to
            # get the data associated with it from the listbox, and
            # get the value of checked from the data array
            foreach item [$sdc_files_lb items] {
                array unset temp
                array set temp [$sdc_files_lb itemcget $item -data]
                if { $temp(checked) } {
                    read_sdc $temp(sdc_file)
                }
            }
        }

        # Save a list of the clock IDs that exist because they were generated
        # in the SDC file(s).
        # Reduce warnings. If you call get_clocks when no clocks
        # exist in the design, it gives a warning. That could make people
        # worry when using this script. If you've chosen to read SDC files,
        # chances are very good they contain clocks, so you won't get the
        # warning. If you haven't
        # chosen to read SDC files, there can't be any SDC defined clocks,
        # by definition.
        set sdc_defined_clock_ids [list]
        set sdc_defined_clock_names [list]
        if { $read_sdc } {
            foreach_in_collection clock_id [all_clocks] {
                lappend sdc_defined_clock_ids $clock_id
                lappend sdc_defined_clock_names [get_clock_info -name $clock_id]
            }
        }

        # Next, create any clocks saved in the iowizard file.
        
        # Validate the source and target names to make sure any clock
        # that is created here will be valid
        # Clock errors is an array mapping clock names to errors.
        array unset clock_errors
        array set clock_errors [validate_clock_names]
        
        # We have to run any of them that were not created already by the SDC files,
        # and before we run derive_clocks/derive_pll_clocks to catch anything
        # else left over.
        set data_file_defined_clock_ids [list]
        set data_file_defined_clock_names [util::get_list_elements \
            -from [array names valid_clocks] -not_in \
            -list $sdc_defined_clock_names]
        
        # Walk through all clocks that are valid that were not created
        # in an SDC file previously read.
        foreach clock_name $data_file_defined_clock_names {
        
            array unset temp
            array set temp $valid_clocks($clock_name)
            
            # We have to make the clock
            set clock_cmd [clocks_info::make_clock_command_string \
                -clock_type $temp(clock_type) \
                -clock_info $temp(clock_info) -target_type $temp(target_type)]
            eval $clock_cmd
            
            # And save the ID of the clock, for later use.
            lappend data_file_defined_clock_ids \
                [util::get_clock_id -clock_name $clock_name]
        }
        
        # Derive clocks to cover anything that wasn't caught by the SDC
        set before_derive_clocks [concat $sdc_defined_clock_ids $data_file_defined_clock_ids]
        
        # Use the -create_base_clocks option if it is available
        if { [catch { derive_pll_clocks -create_base_clocks } res] } {
            # The option is not supported, so just do derive_pll_clocks
            derive_pll_clocks
        }
        
        # We want to make any base clocks necessary, but use the default
        # of 10ns period only if we can't get the actual value from
        # a PLL file. 
        derive_clocks -period 10
#        derive_pll_clocks
        set default_virtual_clock [format %X [clock seconds]]
#        create_clock -name $default_virtual_clock -period 10

        # Save a list of the clock IDs that got generated by derive_clocks
        # or derive_pll_clocks
        set auto_generated_clock_ids [util::get_list_elements \
            -from [util::collection_to_list [all_clocks]] \
            -not_in -list $before_derive_clocks]

        # Add input and output delays so the circuit is constrained
#        set_input_delay -clock $default_virtual_clock 5 [all_inputs]
#        set_output_delay -clock $default_virtual_clock 5 [all_outputs]

#        derive_clock_uncertainty
        update_timing_netlist

        . configure -cursor ""

        do_clock_messages -clock_error_var clock_errors
    }

    ###################################################
    # Handles posting all messages related to clock validation.
    # The procedure gets a list of all the interfaces in the tree,
    # gets the clock_tree_names for each interface, and checks to see
    # whether each clock exists in the get_clocks list, and checks
    # to see whether each clock exists in the clock_errors array.
    # It calls to insert all messages related to the clock validation
    proc do_clock_messages { args } {
    
        set options {
            { "clock_error_var.arg" "" "Variable name with clock error info" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        upvar $opts(clock_error_var) clock_errors
        
        # Build a list of the clocks that have been created
        set clock_names [list]
        foreach_in_collection clock_id [all_clocks] {
            lappend clock_names [get_clock_info -name $clock_id]
        }
        
        # Walk through all the interfaces
        foreach node [interfaces::get_interfaces -all_but_create] {
        
            # Get the list of clock names used in the interface
            array unset interface_info
            array set interface_info [interfaces::get_interface_info \
                -keys [list "clock_tree_names"] \
                -interface $node]
                
            # We may need to insert a message saying that some clocks
            # don't exist any more
            set clock_message_done 0
            set insertion_node ""
            
            # I use separate trees for source and dest tree clocks now.
            # Some clocks may be in both. I want to warn about any of them
            # only once.
            array unset seen_clock
            array set seen_clock [list]
            
            # Walk through the list of clock names used in this interface
            foreach interface_clock $interface_info(clock_tree_names) {

                # If we haven't seen this clock yet, say we have seen it.
                # If we have seen the clock already, go to the next one.
                if { ! [info exists seen_clock($interface_clock)] } {
                    set seen_clock($interface_clock) 1
                } else {
                    continue
                }
                
                set clock_exists [expr { -1 != [util::lsearch_with_brackets $clock_names $interface_clock] }]
                set clock_has_errors [info exists clock_errors($interface_clock)]
                
                # If there are any errors or something doesn't exist, a note
                # to that effect has to be put in. It gets put in as a child
                # to a generic message saying that there were some problems.
                # Put in the generic message once.
                if { $clock_has_errors || (! $clock_exists) } {
                    if { ! $clock_message_done } {
                        set insertion_node [interfaces::insert_message \
                            -node $node -type Warning \
                            -msg_list [list "Some clocks used to constrain this\
                                interface do not exist."]]
                        set clock_message_done 1
                    }
                }

                # If one of the clock names is in the error list,
                # insert the associated error(s) under this interface node.
                # If it has errors, it also probably does not exist, but
                # there's a chance it does, because of derive_clocks and
                # derive_pll_clocks. The priority is to warn if it has errors.
                if { $clock_has_errors } {

                    interfaces::insert_message \
                        -node $insertion_node -type Warning \
                        -msg_list [lindex $clock_errors($interface_clock) 0]
                        
                } elseif { ! $clock_exists } {
                
                    # If the clock name doesn't exist in the clock_names list,
                    # warn
                    interfaces::insert_message -node $insertion_node -type Warning \
                    -msg_list [list "$interface_clock was not created. It might be\
                        defined in an SDC file that was not read when you ran\
                        this script."]
                }
                
            }
        }
    }
    
    #########################################
    # Save the state of the critical project
    # information. Later the old_ information
    # is used to tell whether anything on the
    # tab changed.
    proc copy_current_project_info_to_old { args } {
    
        variable project_file
        variable revision
        variable read_sdc
        variable checked_sdc_files
        variable old_project_file
        variable old_revision
        variable old_read_sdc
        variable old_checked_sdc_files
        
        # When we switch to the project tab, save the state of the
        # fields on the page
        set old_project_file $project_file
        set old_revision $revision
        set old_read_sdc $read_sdc
        set old_checked_sdc_files $checked_sdc_files
    
    }

    ##################################################
    # Some clocks might have been created because they
    # exist in an SDC file. Others might have been
    # created by derive_clocks or derive_pll_clocks.
    # One might be the virtual clock I use to constrain
    # all inputs/outputs.
    # Do the checks against the lists of clock IDs that were created in
    # initialize_sta_constraints
    # Return 1 if the specified clock ID/name matches
    # the specified creator flag
    proc is_clock_created_by { args } {

        set options {
            { "default_virtual" "Look at the default virtual clock" }
            { "file_defined" "Look in SDC and data file defined clock list" }
            { "auto_generated" "Look in auto-generated clock list" }
            { "sdc_defined" "Look only in SDC-defined clock list" }
            { "clock_id.arg" "" "ID of clock to check" }
            { "clock_name.arg" "" "Name of clock to check" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable default_virtual_clock
        variable sdc_defined_clock_ids
        variable data_file_defined_clock_ids
        variable auto_generated_clock_ids

        if { $opts(default_virtual) } {
            # If we're inquiring about the default virtual clock,
            # that's stored by name. If the name is blank, get the
            # name based on the ID.
            if { [string equal "" $opts(clock_name)] } {
                set opts(clock_name) [get_clock_info -name $opts(clock_id)]
            }
            return [string equal $default_virtual_clock $opts(clock_name)]

        } elseif { $opts(file_defined) } {
            # If we're inquiring about an SDC or .iowizard clock,
            # that's stored by ID. If the ID is blank, get the ID based on
            # the name
            if { [string equal "" $opts(clock_id)] } {
                set opts(clock_id) [util::get_clock_id -clock_name $opts(clock_name)]
            }
            set is_in_sdc [expr { -1 != [util::lsearch_with_brackets \
                $sdc_defined_clock_ids $opts(clock_id)]}]
            set is_in_data_file [expr { -1 != [util::lsearch_with_brackets \
                $data_file_defined_clock_ids $opts(clock_id)]}]
            return [expr { $is_in_sdc || $is_in_data_file }]

        } elseif { $opts(sdc_defined) } {
            # If we're inquiring about an SDC clock,
            # that's stored by ID. If the ID is blank, get the ID based on
            # the name
        
            if { [string equal "" $opts(clock_id)] } {
                set opts(clock_id) [util::get_clock_id -clock_name $opts(clock_name)]
            }
            return [expr { -1 != [util::lsearch_with_brackets \
                $sdc_defined_clock_ids $opts(clock_name)]}]
        
        } elseif { $opts(auto_generated) } {

            # If we're inquiring about auto-generated clocks,
            # they're stored by ID. If the ID is blank, get the
            # ID based on the name
            if { [string equal "" $opts(clock_id)] } {
                set opts(clock_id) [util::get_clock_id -clock_name $opts(clock_name)]
            }
            return [expr { -1 != [util::lsearch_with_brackets \
                $auto_generated_clock_ids $opts(clock_id)]}]

        } else {
            return -code error "Unknown clock $opts(clock_name)"
        }
    }

    ######################################3
    # Return the state of the read_sdc checkbox. Used in new_sdc namespace
    proc get_read_sdc_checkbutton_value { args } {
        variable read_sdc
        return $read_sdc
    }
    
    ############################################
    # Handle the script being started from quartus_sta
    # The project will already be open
    proc on_script_run { args } {
    
        variable open_button
        variable project_file
        global quartus
        
        set project_file \
            [file join [pwd] ${quartus(settings)}.qsf]
#        copy_current_project_info_to_old
        $open_button invoke
        
    }
    
    ##############################################
    # Load data stored in the .iowizard file
    # Returns an error if there was an error sourcing the data file,
    # returns the data if it was read successfully, and returns
    # an empty list (no data) if no data file exists
    proc load_data_file { args } {
    
        set options {
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable clocks_data
        variable read_sdc
        variable checked_sdc_files
        variable last_saved_by_version
        
        set tree_data ""
        
        if { [file exists [data_file_name]] } {
            post_message "Reading data file [data_file_name]"
            
            # Clear out anything that could keep old data values
            set last_saved_by_version ""
            catch { unset clocks_data }
            
            if { [catch {source [data_file_name]} res] } {
                return -code error $res
            } else {
                # The load was successful.
                # The output file information has to get copied over now.
                if { [info exist sdc_output_file] && [info exists reporting_output_file] } {
                    sdc_info::set_file_info -sdc_output_file $sdc_output_file \
                        -reporting_output_file $reporting_output_file
                }
                return $tree_data
            }
        } else {
            post_message "No data file exists, so [data_file_name] will be created"
            return [list]
        }
    }
    
    ###################################################
    # Write out a .iowizard file
    # I should save all clocks that exist on the src and dest trees
    # Right before updating netlist, get_clocks, and run any of the
    # saved clocks that don't yet exist
    proc save_data_file { args } {
    
        log::log_message "\nWriting .iowizard file\n-----------------"
        
        set options {
            { "file_name.arg" "" "name of the file to save into" }
        }
        array set opts [::cmdline::getoptions args $options]

        # Write out clock settings
        # Write out information for each interface
        # - description name (tree text)
        # - data port names
        # - clock path clock names
        # - clock path node names
        # - clock_configuration
        # - FPGA or external device requirements target
        # - timing requirements type (skew, tsu, etc)
        # - timing requirement value(s)
        # - board trace information
        # Current revision name
        # Read SDC files checkbox state
        # SDC output file name
        # advanced settings
        
        global script_version
        variable read_sdc
        variable checked_sdc_files
        variable clocks_data
        variable valid_clocks
        
        set foo [interfaces::serialize_tree]
        
        if { [catch {open $opts(file_name) w} fh ] } {
            post_message -type error $fh
        } else {
        
            # Start with the data for each interface
            puts $fh "set tree_data \[list \\"
            foreach { key value } $foo {
                switch -exact -- $key {
                    "text" {
                        puts $fh " txt [list $value] \\"
                    }
                    "checked" {
                        puts $fh " checked $value \\"
                    }
                    "data" {
                        puts $fh " $key \[list \\"
                        array unset temp
                        array set temp $value
                        foreach n [lsort -dictionary [array names temp]] {
                            if { [include_in_data_file -item_to_check $n] } {
                                puts $fh "  $n [list $temp($n)] \\"
                            }
                        }
                        puts $fh " \] \\"
                    }
                    default {
                        post_message -type error "Unknown values in save_data_file:\
                            $key $value"
                    }
                }
            }
            puts $fh {]}
            
            # Now that we've written out the interface data, get the clocks
            # to write out into the file.
            
            puts $fh "array set clocks_data \[list \\"

            # It's possible that if you exit early, the clocks
            # won't have been created.
            # In that case, reuse the clocks that were read in originally.
            # If a timing netlist exists, an attempt has been made to validate
            # clocks. Any that were validated were taken out of clocks_data.
            # Any that were not validated are still in clocks_data.
            # Therefore, I can always attempt to write out clocks_data.
            # If everything was validated, nothing will be written out.
            # If some things were not validated, we'll still save them for next
            # time.
            if { [timing_netlist_exist] } {
            
                # Walk through all the valid clocks I have
                foreach clock_name [array names valid_clocks] {

                    if { [is_clock_created_by -sdc_defined -clock_name $clock_name] } {
                        # Skip it
                        continue
                    }

                    array unset temp_data
                    array set temp_data $valid_clocks($clock_name)
                    
                    # Prep the line to write out
                    set data_string "$clock_name \[list clock_type $temp_data(clock_type)"
                    
                    # If it's virtual, there's no target. Generated and base
                    # have a target, and so have a target type.
                    # If you've gone through the wizard, valid_clocks has
                    # been repopulated with whatever you created in the
                    # source and dest trees. If exit the script before
                    # going through the wizard, valid_clocks does not have
                    # a target_id, because the target_id gets into the
                    # data structure only when the clock graph is being built.
                    # In that case, reuse the target_type that exited
                    # when the iowizard file was read in, because
                    # it's impossible for the target type to change if the
                    # clock graph is not built.
                    # See also procedure to create SDC for clocks
                    if { [string equal "virtual" $temp_data(clock_type) ] } {
                        append data_string " target_type {}"
                    } elseif { [info exists temp_data(target_id)] } {
                        append data_string " target_type [get_node_info -type $temp_data(target_id)]"
                    } else {
                        append data_string " target_type $temp_data(target_type)"
                    }
                    
                    append data_string " clock_info \[list $temp_data(clock_info)\] \] \\"

                    puts $fh " $data_string"
                }

            }
            
            # Regardless of whether the timing netlist exists, there might
            # be clocks in clocks_data. If the timing netlist did not exist,
            # clocks data will have everything that was read in. If clocks
            # were validated, clocks_data contains any clocks that could not
            # be validated.
            foreach { name data } [array get clocks_data] {
                puts $fh " $name \[list $data \] \\"
            }

            puts $fh {]}
            
            # Write in the value of the read_sdc checkbox
            puts $fh "set read_sdc $read_sdc"
            
            # Write in the value of the checked SDC files
            puts $fh "set checked_sdc_files \[list \\"
            foreach csf $checked_sdc_files {
                puts $fh " $csf \\"
            }
            puts $fh {]}
            
            # Write in the SDC and reporting file names
            set sdc_out {}
            set rep_out {}
            sdc_info::get_file_info -sdc_output_file_var_name sdc_out \
                -reporting_output_file_var_name rep_out
                
            # Don't get tripped up by empty entries - if they're empty,
            # a blank string has to be written into the iowizard file
            # so it sources correctly when read
            if { [string equal "" $sdc_out] } { set sdc_out "{}" }
            if { [string equal "" $rep_out] } { set rep_out "{}" }
            puts $fh "set sdc_output_file $sdc_out"
            puts $fh "set reporting_output_file $rep_out"
            
            # Write out the script version that created the file
            puts $fh "set last_saved_by_version \"$script_version\""
            
            catch { close $fh }
        }
        
        # Make sure the data file is part of the project
        set file_is_included 0
        foreach_in_collection asgn_id [get_all_assignments -type global -name MISC_FILE] {
            if { [string equal [data_file_name] \
                [get_assignment_info $asgn_id -value]] } {
                set file_is_included 1
            } 
        }
        
        if { ! $file_is_included } {
            # If the file is not part of the project, add it.
            set_global_assignment -name MISC_FILE \
                -comment "Data file for I/O Timing Constrainer" \
                [data_file_name]
        }
    }
    
    ########################################################
    # Return the name of the data file
    proc data_file_name { args } {
    
        variable revision
        return ${revision}.iowizard
    }
    
    ####################################################
    # When you use a new version of the script on an old data file,
    # some items may be obsolete. They can be skipped.
    proc include_in_data_file { args } {
    
        set options {
            { "item_to_check.arg" "" "Item to check" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable last_saved_by_version
        global script_version
        
        if { [string equal $script_version $last_saved_by_version] } {
            # If the script version is the same as what last saved the
            # data file, the item can always be included
            return 1
        } elseif { [string equal "" $last_saved_by_version] } {
            # If there is no last_saved_by_version value, it's before
            # the board_method and clock/data trace delay variables were
            # removed.
            switch -exact -- $opts(item_to_check) {
                "board_timing_method" -
                "max_clock_trace_delay" -
                "min_clock_trace_delay" -
                "max_data_trace_delay" -
                "min_data_trace_delay" -
                "clock_trace" -
                "clock_trace_tolerance" -
                "data_trace" -
                "data_trace_tolerance" {
                    # None of those items get written out to the data file.
                    return 0
                }
                default { return 1 }
            }
        } else {
            # In all other cases, keep the data
            return 1
        }
    }
    
    #################################################
    # Store the data from the clock trees
    # Yucky cross-namespace solution to reach into clocks_info namespace
    # and get information out of the clock trees into the valid_clocks array
    proc save_clock_trees_data { args } {
    
        variable valid_clocks
        
        clocks_info::get_clock_trees_data -data_var valid_clocks
    }
    
    ################################################################################
    # Returns a list with SDC command strings.
    # Optionally returns them in a flat array form preceded in the list by
    # the clock name
    proc get_clock_creation_sdc_commands { args } {
    
        set options {
            { "clock_names.arg" "" "List of clock names to make SDC for" }
            { "include_clock_names" "Also return the name of the clock" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable valid_clocks
        
        set to_return [list]
        
        # Go through the list of clock names to make SDC for
        foreach clock_name $opts(clock_names) {

            if { [catch { util::get_clock_id -clock_name $clock_name } clock_id] } {
                # Clock doesn't exist
                # TODO - warn?
                continue
            }
            
            if { ! [info exists valid_clocks($clock_name)] } {
                return -code error "Can't create SDC for $clock_name - it doesn't exist\
                    in valid_clocks"
            }
            
            array unset clock_data
            array set clock_data $valid_clocks($clock_name)
            
            switch -exact -- $clock_data(clock_type) {
                "base" -
                "generated" {
                    # When the data comes out of valid clocks,
                    # if it is from a clock that has been created in
                    # this session, target_type has not been set up yet.
                    # see procedure to save data file
                    if { [info exists clock_data(target_id)] } {
                        set target_type [get_node_info -type $clock_data(target_id)]
                    } else {
                        set target_type $clock_data(target_type)
                    }
                }
                "virtual" {
                    set target_type ""
                }
                default {
                    return -code error "Unknown value for clock_type in\
                        get_clock_creation_sdc_commands: $clock_data(clock_type)"
                }
            }

            # Now we have all the information to create the SDC
            # command. If we want to interleave with the names, do that now
            if { $opts(include_clock_names) } {
                lappend to_return $clock_name
            }
            lappend to_return [clocks_info::make_clock_command_string \
                -clock_info $clock_data(clock_info) -clock_type $clock_data(clock_type) \
                -target_type $target_type]
        }
        return $to_return
    }

    #############################################
    # Come up with any -exclusive clock groups for multi-clock situations
    # Create the constraints and comments to explain clock groups.
    # Return a text string that can be put straight into an SDC file.
    proc generate_sdc_for_clock_groups { args } {
    
        set options {
            { "clock_names.arg" "" "List of clock names to check for exclusivity" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable valid_clocks

        # Map targets to the clocks on them
        array set target_to_clocks [list]
        
        # Flag to say whether we have any targets with multiple clocks
        set has_targets_with_multiple_clocks 0
        
        set return_string ""
        
        # Walk through all the clock names we want.
        # Find out what the target for each one is.
        # Any target with more than one clock will need a -exclusive.
        foreach clock_name $opts(clock_names) {

            if { [catch { util::get_clock_id -clock_name $clock_name } clock_id] } {
                # Clock doesn't exist
                # TODO - warn?
                continue
            }
            
            if { ! [info exists valid_clocks($clock_name)] } {
                return -code error "Can't check $clock_name for clock groups.\
                    it doesn't exist in valid_clocks"
            }
            
            array unset clock_data
            array set clock_data $valid_clocks($clock_name)
            
            switch -exact -- $clock_data(clock_type) {
                "base" -
                "generated" {
                    # When the data comes out of valid clocks,
                    # if it is from a clock that has been created in
                    # this session, target_type has not been set up yet.
                    # see procedure to save data file
                    if { [info exists clock_data(target_id)] } {
                        set target_name [get_node_info -name $clock_data(target_id)]
                    } else {
                        array unset clock_info
                        array set clock_info $clock_data(clock_info)
                        set target_name $clock_info(targets)
                    }
                    
                    if { [info exists target_to_clocks($target_name)] } {
                        # The target won't exist in the array unless we've put
                        # something on it before.
                        set has_targets_with_multiple_clocks 1
                    }
                    lappend target_to_clocks($target_name) $clock_name
                }
                "virtual" {
                    # Don't do anything for virtual clocks.
                    # We could later though - just add a key to the target_to_clocks
                    # array called "virtual"
                    set target_name "virtual"
                }
                default {
                    return -code error "Unknown value for clock_type in\
                        generate_sdc_for_clock_groups: $clock_data(clock_type)"
                }
            }
        }
        
        # We've gone through the clocks we wanted to look at.
        # Set up a header to explain clock groups
        if { $has_targets_with_multiple_clocks } {
            append return_string \
                "# Multiple clocks in your design are assigned to the same target node(s).\
                \n# The following exclusive clock groups cut timing paths between clocks on\
                \n# the same node because the clocks can never be active at the same time.\n\n"
        } else {
            return ""
        }
        
        # Now see what clocks are on any target.
        foreach target [array names target_to_clocks] {
        
            if { [string equal "virtual" $target] } {
                # Placeholder - do we want to make all virtual clocks
                # we define asynchronous? I'm not so sure.
            } elseif { 1 != [llength $target_to_clocks($target)] } {
                append return_string "# Exclusive clock groups for clocks on $target\n"
                append return_string "set_clock_groups -exclusive"
                foreach clock_name $target_to_clocks($target) {
                    append return_string " -group { $clock_name }"
                }
                append return_string "\n\n"
            }
        }
        return $return_string
    }
}
# End of project_info namespace

################################################################################
# Contains procedures to create and support the interfaces page in the main GUI
namespace eval interfaces {

    variable images
    array set images [list]
    variable data_tree              ""
    variable node_index             0
    variable double_click_text      "<Double-click to create a name or\
        description for the bus or I/O you are constraining>"
    
    #############################################
    # Create an array of images (question mark and check mark) to use in the
    # interfaces tree to indicate status - not all data entered vs all data
    # entered
    proc create_images { args } {

        variable images
        set icon_data(question) {R0lGODlhEAAQALMAAAAAAIAAAACAAICAAAAAgIAAgACAgPfdh4CAgP8AAAD/
            AAAA//XBDP8A/wD///79+yH5BAAAAAAALAAAAAAQABAAgwAAAIAAAACAAICA
            AAAAgIAAgACAgPfdh4CAgP8AAAD/AAAA//XBDP8A/wD///79+wQn8MlJq734
            sL2x5KAHhhhzPODpoZyape/oae1KM+tE5yzOkzkOLxcBADs=}
        set icon_data(check) {R0lGODlhEAAQALMAAAAAAIAAAACAAICAAAAAgIAAgACAgMDAwICAgP8AAAD/
            AAAA////AP8A/wD//////yH5BAAAAAAALAAAAAAQABAAgwAAAIAAAACAAICA
            AAAAgIAAgACAgMDAwICAgP8AAAD/AAAA////AP8A/wD//////wQj8MlJq704
            P6WpEp30hRsYjhYqmpXimi/mfnE2q3bd4WTvaxEAOw==}
        
        foreach ibuild [lsort -dictionary [array names icon_data]] {
        
            # This is two steps due to this suggestion:
            # http://wiki.tcl.tk/643
            set images($ibuild) [image create photo]
            $images($ibuild) put $icon_data($ibuild)
        }
    }
    
    ###########################################
    # Set up the interfaces page on the frame passed in
    proc assemble_tab { args } {
    
        set options {
            { "frame.arg" "" "Frame to assemble the tab on" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable data_tree
        variable double_click_text
        
        # Don't pack this frame, because it comes from a getframe
        set f $opts(frame)

        # Set up interfaces title frame
        set int_tf [TitleFrame $f.data -ipad 8 -text "Buses"]
        set sub_f [$int_tf getframe]
        
        # Brief instructions for data ports
        
        grid [label $sub_f.l2 -text "The list below contains buses or I/Os\
            you are creating I/O constraints for."] -sticky w
        grid [label $sub_f.l1 -text "To enter information for a new bus or I/O,\
            double-click below and enter a name for it, press Enter, then click Next."] \
            -sticky w
        grid [label $sub_f.l0 -text "To edit constraints for a bus or I/O\
            listed below, select the name, then click Next."] -sticky w
        grid [label $sub_f.l3 -text "Click Finish to choose SDC files\
            for interface constraints."] -sticky w
        grid [Separator $sub_f.sep -relief groove] \
            -sticky ew -pady 5
        
        # Add the tree for the interfaces list
        set int_sw [ScrolledWindow $sub_f.sw -auto both]
        set data_tree [Tree $int_sw.tr -bg white -deltay 16 -linesfill "gray50"]
        $int_sw setwidget $data_tree
        grid $int_sw -sticky news

if { 0 } {
        # We need a button to use to edit interfaces
        grid [Button $sub_f.edit -text "Edit" -width 10 \
            -command [namespace code start_wizard]] -sticky n
}        
        # Pack in the interfaces title frame
#        pack $int_tf -side top -fill both -expand true
        grid $int_tf -sticky news
        # Expand on resize
        grid rowconfigure $sub_f 5 -weight 1
        grid columnconfigure $sub_f 0 -weight 1
        
        grid rowconfigure $f 0 -weight 1
        grid columnconfigure $f 0 -weight 1

        #####################################
        # Set up for enabling the next button
        # This event will get fired twice when you double-click to
        # edit a name. Oh well.
        $data_tree bindText <Button-1> \
            "+[namespace code gui::update_nav_buttons_state] -based_on_page"
        
        ##########################
        # Set up for adding interfaces
        $data_tree insert end "root" "add" -text $double_click_text
        $data_tree bindText <Double-1> [namespace code add_or_edit]
        
        # Delete an interface
        $data_tree bindText <Key-Delete> [namespace code delete_interface]
        bind $data_tree.c <Delete> [namespace code delete_interface]

    }

    ######################################################
    # Set the check or question mark image for the specified node in the tree,
    # or whatever node is selected if the node option is blank
    # The image depends on how many pages there are to see.
    # The number of pages to see is greater than zero when some pages have
    # required information that has not been entered.
    proc set_interface_image { args } {
    
        set options {
            { "num_pages_to_see.arg" "" "How many pages there are to see" }
            { "node.arg" "" "Tree node" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable data_tree
        variable images
        
        if { [string equal "" $opts(node)] } {
            set sel [$data_tree selection get]
        } else {
            set sel $opts(node)
        }
        
        if { 0 < $opts(num_pages_to_see) } {
            $data_tree itemconfigure $sel -image $images(question)
        } else {
            $data_tree itemconfigure $sel -image $images(check)
        }
    }
    
    ####################################################
    # Add an interface if you click on the "add" node
    # or edit if you click on a named node
    # data_port_names       The names of the I/Os you're constraining
    # data_register_names   Names of the registers connected to the I/Os
    # clock_port_name       Name of the clock port for a source sync interface
    # clock_configuration   system_sync_common_clock, system_sync_different_clock,
    #                           source_sync_source_clock, dest_clock
    # direction             input or output
    # data_rate             sdr or ddr
    # transfer_edge         same or opposite
    # degree_shift          relationship between clock and data
    # io_timing_method     skew, data valid, setup/hold, tco
    # constraint_target     fpga or external
    
    proc add_or_edit { n } {
    
        variable images
        variable data_tree
        variable node_index
        variable double_click_text

        
        if { [string equal "add" $n] } {
            set initial_text ""
        } else {
            set initial_text [$data_tree itemcget $n -text]
        }

        set edit_result [$data_tree edit $n $initial_text]

        # If there's actually an edit made...
        if { ! [string equal "" $edit_result] } {
        
            # Was it the add node?
            if { [string equal "add" $n] } {
            
# Was part of the list of data that was inserted
#                        "board_timing_method"   "" \
#                        "max_clock_trace_delay" "" \
#                        "min_clock_trace_delay" "" \
#                        "max_data_trace_delay"  "" \
#                        "min_data_trace_delay"  "" \
#                        "clock_trace"           "" \
#                        "clock_trace_tolerance" "" \
#                        "data_trace"            "" \
#                        "data_trace_tolerance"  "" \
                
                $data_tree insert end "root" $node_index -text $edit_result \
                    -image $images(question) -drawcross never \
                    -data [list \
                        "data_port_names"   [list] \
                        "data_register_names"   [list] \
                        "direction"         "" \
                        "data_rate"         "" \
                        "clock_configuration"   "" \
                        "clock_port_name"   "" \
                        "clock_tree_names"  [list] \
                        "transfer_edge"     "" \
                        "degree_shift"      "" \
                        "io_timing_method"  "" \
                        "constraint_target" "" \
                        "src_clock_name"    "" \
                        "dest_clock_name"   "" \
                        "adjust_cycles"     "" \
                        "src_shift_cycles"  "" \
                        "dest_shift_cycles" "" \
                        "src_transfer_cycles"   "" \
                        "dest_transfer_cycles"  "" \
                        "extra_setup_cuts"  [list] \
                        "extra_hold_cuts"   [list] \
                        "max_skew"          "" \
                        "min_valid"         "" \
                        "setup"             "" \
                        "hold"              "" \
                        "tco_max"           "" \
                        "tco_min"           "" \
                        "data_trace_delay"      "" \
                        "src_clock_trace_delay" "" \
                        "dest_clock_trace_delay"    "" \
                        "trace_propagation_rate"    "" \
                        "advanced"              "" \
                        "alignment_method"      "mc" \
                        "advanced_false_paths"  "" \
                        "pages_to_see" [list "data_ports" "clocking_conf" \
                            "src_clock" "dest_clock" "clock_relationship" \
                            "board" "requirements" ] \
                    ]
                $data_tree selection set $node_index
                checked_interfaces::add $node_index
                incr node_index
                $data_tree itemconfigure "add" -text $double_click_text
                
            } else {
            
                # An existing node
                $data_tree itemconfigure $n -text $edit_result
            }
        }
        
        # The edit might end up with something selected. In that case,
        # we'd have to enable Next if it wasn't already enabled.
        gui::update_nav_buttons_state -based_on_page
    }
    
    
    ####################################
    # We're deleting an interface from the list.
    # Remove it from the tree, and remove it from the checked_interfaces
    # list, if it exists in the list.
    proc delete_interface { args } {
    
        variable data_tree
        
        # The highlighted node in the tree that gets deleted
        set sel [$data_tree selection get]
        
        if { 0 < [llength $sel] } {
        
            # First check to see whether the interface was in the
            # checked interfaces list, and remove it if it was
            if { [checked_interfaces::is_checked $sel] } {
                checked_interfaces::remove $sel
            }
            
            # Then delete the interface from the tree
            $data_tree delete [list $sel]
        }
    }
    
    #####################################################
    # Insert interface items in the tree
    # This is called with the data read in from the iowizard
    # file. 
    proc init_interfaces { args } {
    
        set options {
            { "data.arg" "" "Interface data" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        variable data_tree
        variable node_index
        variable images
        
        # First delete all nodes except for the add entry
        foreach n [$data_tree nodes "root"] {
            if { [string equal "add" $n] } { continue }
            $data_tree delete $n
        }
        
        # Do a simple check on the validity of the data that came from the
        # data file
        if { [string equal "data" [lindex $opts(data) 2]] } {
            post_message -type error "Data file does not include information on\
                checked interfaces"
            return
        }
        
        # Reset the node index
        set node_index 0

        # Clear out the list of checked interfaces
        checked_interfaces::reset
        
        # Put in the items one by one
        if { [llength $opts(data)] > 0 && 0 == ([llength $opts(data)] % 6)} {
            foreach { foo txt foo checked foo data } $opts(data) {
                $data_tree insert end "root" $node_index -text $txt \
                    -data $data -open 1 -drawcross never
                # If the node is checked to be included when SDC is generated,
                # add it to the list
                if { $checked } {
                    checked_interfaces::add $node_index
                }
                array unset t
                array set t $data
                set_interface_image -node $node_index -num_pages_to_see [llength $t(pages_to_see)]
                incr node_index
            }
            
        }
    }
    
    ####################################################
    # Handle requests for various information about a particular
    # interface. If you don't specify a node, it uses the node
    # that is currently selected in the tree, 
    proc get_interface_info { args } {
    
        set options {
            { "keys.arg" "" "Information to get" }
            { "all_keys" "Return a flat array with all data" }
            { "interface.arg" "" "Specify the interface to get info for" }
            { "name" "Return the name of the interface" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable data_tree
        
        # What node are we getting info from?
        if { [string equal "" $opts(interface)] } {
            set sel [$data_tree selection get]
        } else {
            set sel $opts(interface)
        }
        
        if { [string equal "" $sel] } {
            return -code error "No selected node in interfaces tree on get"
        }
        
        # Are we getting the name?
        if { $opts(name) } {
            return [$data_tree itemcget $sel -text]
        }
        
        array set data [$data_tree itemcget $sel -data]

        if { $opts(all_keys) } {
            return [array get data]
        } else {
            set to_return [list]
            foreach key $opts(keys) {
                if { ! [info exists data($key)] } {
                    post_message -type warning "Can't find value for $key for\
                        node $sel in the data file"
                    lappend to_return $key
                    lappend to_return {}
                } else {
                    lappend to_return $key $data($key)
                }
            }
            return $to_return
        }
    }

    ####################################################
    # Save information into the tree for the highlighted node
    proc save_interface_info { args } {
    
        set options {
            { "key.arg" "" "Information to save" }
            { "value.arg" "" "Value to save" }
            { "data.arg" "" "Information to save" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable data_tree
        
        set sel [$data_tree selection get]
        if { [string equal "" $sel] } {
            return -code error "No selected node in interfaces tree on save"
        }

        if { 0 == [llength $opts(data)] } {
            array set new_data [list $opts(key) $opts(value)]
        } else {
            array set new_data $opts(data)
        }
        
        array set data [$data_tree itemcget $sel -data]
        
        foreach key [array names new_data] {
            if { ! [info exists data($key)] } {
                post_message "Adding $key for node $sel in your data file"
            }
            set data($key) $new_data($key)
            
        }
        
        $data_tree itemconfigure $sel -data [array get data]
    }

    ###################################################
    # Validate interface - ensure there is one selected,
    # and that it's not the add item
    proc ensure_selected { args } {
    
        variable data_tree
        
        set sel [get_interfaces -selected]

        if { 1 == [llength [$data_tree nodes "root"]] } {
            # If there is only one entry in the tree
            return -code error "You must add an interface before continuing."
        } elseif { [string equal "" $sel] || [string equal "add" $sel] } {
            return -code error "You must select an interface to constrain or\
                edit before continuing."
        } else {
            return 1
        }
    }
    
    #########################################################
    # Helper procedure to write out tree contents
    # Put all the data into a big list, along with the name of the
    # tree node, and whether it is checked for SDC generation
    proc serialize_tree { args } {
    
        variable data_tree
        
        set to_return [list]
        
        foreach node [$data_tree nodes "root"] {
        
            if { [string equal "add" $node] } { continue }
            
            lappend to_return \
                "text" [$data_tree itemcget $node -text] \
                "checked" [checked_interfaces::is_checked $node] \
                "data" [$data_tree itemcget $node -data]
        }
        return $to_return
    }
    
    #########################################################
    proc delete_messages { args } {
    
        set options {
            { "node.arg" "" "Interface node" }
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable data_tree
        
        # Delete all children of the specified node
        $data_tree delete [$data_tree nodes $opts(node)]
    }
    
    ###########################################################
    proc insert_message { args } {

        set options {
            { "node.arg" "" "Interface node" }
            { "msg_list.arg" "" "Message to insert" }
            { "type.arg" "" "message type"}
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable data_tree
        
        return [q_messages::build_generic_message -tree $data_tree \
            -insert_at $opts(node) -msg_list $opts(msg_list) \
            -type $opts(type)]
    }
    
    #############################################################
    # Get a list of interfaces in the tree.
    # Each interface is specified by an ID in the tree.
    # Those IDs are what get returned.
    # You can get all the interfaces except for the create entry,
    # or you can get the interface that is currently highlighted
    # Never return the create node, because we never want to know if
    # that is selected. If it is selected, it is equivalent to 
    # nothing we care about being selected.
    proc get_interfaces { args } {
    
        set options {
            { "all_but_create" "Return the IDs of the interfaces" }
            { "selected" "Return the ID of the selected interface" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable data_tree
        
        if { $opts(all_but_create) } {
            # A list of all the interfaces in the tree, excluding 'create'
            return [lrange [$data_tree nodes root] 1 end]
        } elseif { $opts(selected) } {
            set sel [$data_tree selection get]
            if { [string equal "add" $sel] } {
                return ""
            } else {
                return $sel
            }
        } else {
            return -code error "Unknown option for get_interfaces"
        }
    }
    
}

################################################################################
namespace eval data_info {

    variable data_list [list \
        "data_port_names"   [list] \
        "direction"         "" \
        "data_rate"         "" \
        "data_register_names" [list] \
    ]
    variable shared_data
    variable old_data
    array set shared_data $data_list
    array set old_data $data_list
    
    variable data_port_name         ""
    variable direction_tf           ""
    variable intermediate_direction ""
#    trace add variable shared_data(data_rate) write [namespace code update_data_rate]
    
    proc update_data_rate { n1 n2 args } {
#    puts "called from trace with $n1 $n2 $args"
        variable shared_data
        if { [string equal "data_rate" $n2] } {
        clock_diagram::init_diagram_info \
            -data_rate $shared_data(data_rate)
        clock_relationship::init_relationship_info \
            -data_rate $shared_data(data_rate)
        clock_relationship::configure_alignment_frame \
            -data_rate $shared_data(data_rate)
        requirements_info::init_timing_req \
            -data_rate $shared_data(data_rate)
    }
    }
    
    ################################################
    # Put together the I/O tab, on the frame
    # that's passed in
    proc assemble_tab { args } {
    
        set options {
            { "frame.arg" "" "Frame to assemble the tab on" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable data_port_name
        variable shared_data
        variable direction_tf
        variable intermediate_direction
        
        # Don't pack this frame, because it comes from a getframe
        set f $opts(frame)

        # Set up the nav frame
#        set nav_frame [frame $f.nav]
#        grid $nav_frame -sticky news
        
        # Set up data ports title frame
        set dp_tf [TitleFrame $f.data -ipad 8 -text "Data port names"]
        set sub_f [$dp_tf getframe]
        
        # Brief instructions for data ports
        grid [label $sub_f.l0 -text "Add the names of the data ports in the\
            bus or I/O you are constraining."] -sticky w
        grid [label $sub_f.l1 -text "All the data ports in this list must\
            connect to registers with the same clock."] -sticky w
        grid [label $sub_f.l2 -text "Wildcards are supported"] -sticky w
        grid [Separator $sub_f.sep -relief groove] \
            -sticky ew -pady 5
        
        # Add the name entry with add/remove/... buttons
        set ssub_f [frame $sub_f.f]
        set dp_entry    [entry $ssub_f.e -textvariable \
            [namespace which -variable data_port_name]]
        set dp_browse   [button $ssub_f.browse -text "..." -width 2]
        set dp_add      [button $ssub_f.add -text "Add" -width 10 -state disabled]
        set dp_remove   [button $ssub_f.remove -text "Remove" -width 10 -state disabled]
        pack $dp_entry -side left -anchor n -fill x -expand true
        pack $dp_browse $dp_add $dp_remove -side left -anchor n -padx 4
        grid $ssub_f -sticky ew -pady 5

        # Add the listbox for the data port names list
        set dp_sw [ScrolledWindow $sub_f.sw -auto both]
        set dp_lb [listbox $dp_sw.dp -bg white -listvariable \
            [namespace which -variable shared_data](data_port_names) \
            -selectmode extended]
        $dp_sw setwidget $dp_lb
        grid $dp_sw -sticky news

        # Expand on resize
        grid rowconfigure $sub_f 5 -weight 1
        grid columnconfigure $sub_f 0 -weight 1

        # Grid in the data ports title frame
        grid $dp_tf -sticky news

        # Make a direction titleframe for when it's a bidir interface
        # This titleframe should be enabled only when bidir ports are
        # chosen.
        # The radio button should update correctly when you add and remove
        # entries to the data port names listbox
        # If you have multiple direction ports, set the intermediate direction
        # to blank so the radio button goes away
        set direction_tf [TitleFrame $f.direction_tf \
            -text "Direction" -ipad 8]
        set f_direction [$direction_tf getframe]
        pack [radiobutton $f_direction.input -text "Input" -value "input" \
            -variable [namespace which -variable intermediate_direction]] -side top -anchor nw
        pack [radiobutton $f_direction.output -text "Output" -value "output" \
            -variable [namespace which -variable intermediate_direction]] -side top -anchor nw
        grid $direction_tf -sticky news
        trace add variable shared_data(data_port_names) write \
            [namespace code enable_disable_direction_tf]
        
        # Choices for the interface rate
        set dr_tf [TitleFrame $f.rate -text "Data rate" -ipad 8]
        set f_rate [$dr_tf getframe]
        pack [label $f_rate.l0 -text "The data rate depends on the\
            clocking scheme for the registers connected to the data ports above."] \
            -side top -anchor nw
        pack [label $f_rate.ls -text "A single data rate interface transfers\
            data once during a clock cycle (rising or falling edge)." \
            -justify left] \
            -side top -anchor nw
        pack [label $f_rate.ld -text "A double data rate interface transfers\
            data twice during a clock cycle (rising and falling edges)." \
            -justify left] \
            -side top -anchor nw
        pack [Separator $f_rate.sep] -fill x -expand true -pady 5
        pack [radiobutton $f_rate.sdr -text "Single data rate" -variable \
            [namespace which -variable shared_data](data_rate) -value "sdr"] \
            -side top -anchor w
        pack [radiobutton $f_rate.ddr -text "Double data rate" -variable \
            [namespace which -variable shared_data](data_rate) -value "ddr"] \
            -side top -anchor w
#        pack $dr_tf -side top -anchor nw -fill x -expand true
        grid $dr_tf -sticky news -pady 8

        # Handle clicking on the ... for the data ports list
        $dp_browse configure -command "name_finder::show_dialog \
            -selected_var [namespace which -variable shared_data](data_port_names)"

        # Disable or enable the Add button
        bind $dp_entry <KeyRelease> "[namespace code on_dp_entry] \
            -add_button $dp_add"

        # Handle the add button
        $dp_add configure -command "[namespace code on_dp_add] \
            -dp_name_var data_port_name"
        bind $dp_entry <Return> [list $dp_add invoke]
        
        # Remove the selected item in the listbox when you click Remove
        # Also when you press delete
        $dp_remove configure -command "[namespace code on_dp_remove] \
            -dp_listbox $dp_lb -button $dp_remove"
        bind $dp_lb <Key-Delete> [list $dp_remove invoke]
        
        # Enable the Remove button when there's something clicked in the listbox
        bind $dp_lb <ButtonRelease-1> "[namespace code on_dp_lb] \
            -button $dp_remove"

        # Expand data ports on resize
        grid rowconfigure $f 0 -weight 1
        grid columnconfigure $f 0 -weight 1

#        return $nav_frame
    }

    ###########################################
    # Handle KeyRelease on the data port name entry field
    # If there is text in the field, then the Add button
    # can be enabled. If there is no text in the field, then
    # the add button must be disabled.
    proc on_dp_entry { args } {
    
        set options {
            { "add_button.arg" "" "Add button" }
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable data_port_name
        
        if { 0 == [string length $data_port_name] } {
            $opts(add_button) configure -state disabled
        } else {
            $opts(add_button) configure -state normal
        }
    }
    
    ###########################################
    # Handle the add button
    # Allow wildcards to be entered this way
    # When you click Add (or press Enter in the data port name entry field)
    # do a simple validation - check to make sure there is at least
    # one port name that matches whatever you entered.
    # If there is, stick the thing you entered on the data port names list
    # and clean out the data port name entry field.
    # Later, more extensive validation will ensure that everything that
    # matches goes the same direction, is clocked by one clock, etc.
    # If what you entered fails the simple validation, show an error message
    # telling you that no port names matching that name were found.
    proc on_dp_add { args } {

        set options {
            { "dp_name_var.arg" "" "Variable for the data port name in the entry" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data

        upvar $opts(dp_name_var) data_port_name

        set name_collection [get_ports $data_port_name]
        
        if { 0 == [get_collection_size $name_collection] } {
            tk_messageBox -icon error -type ok -default ok \
                -title "Error validating I/O ports" -parent [focus] -message \
                "No I/O ports matching $data_port_name were found in the design"
        } else {
            lappend shared_data(data_port_names) $data_port_name
            set data_port_name ""
        }
    }

    ###########################################
    # Handle the remove button
    # When you click Remove, take out whatever entries in the data port names
    # listbox are selected. Also disable the remove button, because after
    # things have been removed, nothing is highlighted to be valid to remove.
    proc on_dp_remove { args } {

        set options {
            { "dp_listbox.arg" "" "Listbox with data port names" }
            { "button.arg" "" "The remove button" }
        }
        array set opts [::cmdline::getoptions args $options]

        set sel [lsort -decreasing -integer [$opts(dp_listbox) curselection]]
        foreach item $sel { $opts(dp_listbox) delete $item }
        $opts(button) configure -state disabled
    }

    ###########################################
    # Handle clicks on the data ports listbox
    # When you click on something in the data ports listbox, enable the
    # remove button if there are things in the listbox, so you can
    # remove some of them if you want.
    proc on_dp_lb { args } {

        set options {
            { "button.arg" "" "The remove button" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data

        if { 0 < [llength $shared_data(data_port_names)] } {
            $opts(button) configure -state normal
        }
    }

    #############################################
    # enable or disable the direction titleframe
    # if necessary for bidir ports. Blank out intermediate_direction
    # if there's mixed directions
    # This procedure gets called by a trace command that watches writes
    # to shared_data(data_port_names)
    proc enable_disable_direction_tf { n1 n2 args } {

        variable direction_tf
        variable intermediate_direction
        variable shared_data
        
        if { ! [string equal "data_port_names" $n2] } { return }
        
        if { [catch { get_ports_direction -names $shared_data(data_port_names) } dir] } {
            # There was an error.
            # either there were no ports chosen, or there are multiple directions.
            # Either reason means we disable and blank out
            set intermediate_direction ""
            util::recursive_widget_state -widget $direction_tf -state "disabled"
            
        } elseif { [string equal "bidir" $dir] } {
            # The ports are all bidirectional.
            # Enable the frame and set intermediate_direction if we
            # have a direction
            util::recursive_widget_state -widget $direction_tf -state "normal"
            if { [string equal "" $intermediate_direction] } {
                # If there's no value for intermediate direction,
                # give it whatever is in shared data unless that's blank too.
                # In that case, default to input
                if { [string equal "" $shared_data(direction)] } {
                    set intermediate_direction "input"
                } else {
                    set intermediate_direction $shared_data(direction)
                }
            }
        } else {
            # Ports are input or output
            # Disable the frame but set intermediate_direction to reflect the
            # direction
            util::recursive_widget_state -widget $direction_tf -state "disabled"
            set intermediate_direction $dir
        }
        
    }
    
    #############################################
    # Returns a string (input, output, or bidir) based on
    # the direction of the specified port_id
    proc port_direction { args } {
    
        set options {
            { "port_id.arg" "" "port ID to check" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        if { [catch {get_node_info -name $opts(port_id)} res] } {
            return -code error "port_direction: $res"
        } else {
            set name $res
        }
        set type [get_node_info -type $opts(port_id)]
        
        if { ! [string equal "port" $type] } {
            return -code error "port_direction: The node named $name with ID\
                $opts(port_id) is a $type but must be a port"
        } elseif { [get_port_info -is_inout_port $opts(port_id)] } {
            # Must check bidir first, because TQ reports a bidir is also
            # an input and an output!
            return "bidir"
        } elseif { [get_port_info -is_input_port $opts(port_id)] } {
            return "input"
        } elseif { [get_port_info -is_output_port $opts(port_id)] } {
            return "output"
        } else {
            return -code error "port_direction: Can't identify direction\
                for port $name with ID $opts(port_id)"
        }
    }
    
    #############################################
    # Returns a string (input or output) based on
    # the direction of the specified port names,
    # or an error if they're not all the same direction
    proc get_ports_direction { args } {
    
        set options {
            { "names.arg" "" "Names to check" }
            { "type.arg" "data" "Clock or data" }
            { "error_var.arg" "" "Variable for error messages" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        # If we want to get errors back, set up the errors variable
        if { [string equal "" $opts(error_var)] } {
            set errors [list]
        } else {
            upvar $opts(error_var) errors
        }
        
        # Return 0 if there are no ports specified
        if { 0 == [llength $opts(names)] } {
            lappend errors [list "No $opts(type) port names were entered.\
                You must specify at least one port name"]
            return -code error "unspecified ports"
        }

        array unset directions
        array set directions [list]

        # Put each port_id into an array entry based on its direction
        foreach_in_collection port_id [get_ports $opts(names)] {
            set dir [port_direction -port_id $port_id]
            lappend directions($dir) $port_id
        }

        # There's one array name per direction.
        # If there's only one array name, all ports are the same direction
        if { 1 == [array size directions] } {
            return [lindex [array names directions] 0]
        } elseif { 0 == [array size directions] } {
            # If directions is zero size, then get_ports $opts(names)
            # didn't return anything. If the procedure got to there,
            # then names must have been specified. If no names were specified,
            # it would have returned the unspecified ports error.
            # Therefore, we know no ports matched $opts(names)
            lappend errors [list "No port names match $opts(names)"]
            return -code error "no matching ports"
        } else {
            set sub_msg [list]
            foreach direction [array names directions] {
                lappend sub_msg [list "[llength $directions($direction)] $direction"]
            }
            lappend errors [list "All $opts(type) ports must be the same\
                direction. You have the following mix." $sub_msg]
            return -code error "multiple directions"
        }
    }
    
    #########################################
    # Returns a flat array of a register that
    # is connected to each port - maps a port ID to its connected register ID
    # TODO - does this work correctly for SIII?
    proc ports_registers { args } {
    
        set options {
            { "names.arg" "" "Names of ports to get registers for" }
            { "array_var_name.arg" "" "Variable name of result array" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        # Set up a queue to traverse the netlist with
        set queue [::struct::queue]
    
        upvar $opts(array_var_name) port_id_to_reg_id

        set ports_without_registers [list]
        
        # If no names are specified, return an empty list
        if { 0 == [llength $opts(names)] } { return [list] }
        
        # Walk through each port specified
        foreach_in_collection port_id [get_ports $opts(names)] {
    
            set direction [port_direction -port_id $port_id]
    
            # Start the traversal at the port
            $queue clear
            $queue put $port_id
        
            set done 0
            set target_reg_id ""
    
            while { ! $done } {
        
                # Here's the node to work on
                set node_id [$queue get]
        
                # Get some information about the node
                set node_type [get_node_info -type $node_id]
                set node_name [get_node_info -name $node_id]
                set node_loc  [get_node_info -location $node_id]

                # We care about register nodes
                if { [string equal "reg" $node_type] } {
                    if { [regexp {ddio_ina\[\d+\]~ddio_out_reg$} $node_name] } {
                        # Skip ~ddio_out_reg on the inputs
                    } elseif { [regexp {ddio_outa\[\d+\]~ddio_data_in_reg$} $node_name] } {
                        # Skip ~ddio_data_in_reg on the outputs
                    } else {
                        set target_reg_id $node_id
                        set done 1
                    }

                } else {

                    # It's not a register node. If the port was an input,
                    # get the fanout edges of the node we're on.
                    # If the port was an output, get the clock edges of the
                    # node we're on.
                    switch -exact -- $direction {
                        "input" {
                            foreach edge_id [get_node_info -fanout_edges $node_id] {
                                $queue put [get_edge_info -dst $edge_id]
                            }
                        }
                        "output" {
                            if { [regexp {^DDIO} $node_loc] } {
                                # Some families have paths from DDR output registers
                                # cut, because the only path that really matters
                                # is the clock driving the mux
                                set cell_name [get_node_info -cell $node_id]
                                foreach_in_collection buried_reg [get_cell_info -buried_regs $cell_name] {
                                    $queue put $buried_reg
                                }
                            } else {
                                foreach edge_id [get_node_info -clock_edges $node_id] {
                                    $queue put [get_edge_info -src $edge_id]
                                }
                            }
                        }
                        default {
                            return -code error "Unknown value for direction in\
                                ports_registers: $direction"
                        }
                    }
                }

                # Error condition
                if { ! $done && (0 == [$queue size]) } {
                    lappend ports_without_registers [get_port_info -name $port_id]
                    post_message -type error "Can't find a register connected to $port_id"
                    set done 1
                }
            }

            if { ! [string equal "" $target_reg_id] } {
                set port_id_to_reg_id($port_id) $target_reg_id
            }
        }
        
        $queue destroy
        
        return $ports_without_registers
#        return [array get port_id_to_reg_id]
    }
    
    #########################################
    # Returns a list with the node that feeds
    # the clock, and whether a register is altddio
    # TODO - does this work for SIII?
    proc register_clock_node_and_type { args } {
    
        set options {
            { "register_id.arg" "" "ID of register to check" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        set node_id $opts(register_id)
        set in_same_cell 1
        set is_ddio 0
        set was_ddio 0

        # We call this procedure with a register ID. I have to figure out
        # two things - the clock source and whether the register is a DDIO
        # register. To figure out the clock source, walk backwards from
        # the register ID to its clock_edge source, etc, etc, until the
        # cell of the node is no longer the same cell the register is in.
        # At that point, we have the clock source.
        while { $in_same_cell } {

            set clock_edge_ids [get_node_info -clock_edges $node_id]
            
            if { 1 != [llength $clock_edge_ids] } {
                post_message -type error "$node_id does not have 1 clock edge"
                set done 1
                
            } else {

                # We have one clock edge. Follow it back
                set src_id [get_edge_info -src [lindex $clock_edge_ids 0]]
                set src_parent_cell [get_node_info -cell $src_id]
#                set cell_pin_names [get_cell_info -pin_names $src_parent_cell]

                # Get the cell of the node that is the destination of that
                # clock edge. At the beginning, it is the parent cell of
                # the register we start with
                set node_parent_cell [get_node_info -cell $node_id]

                set in_same_cell [string equal $node_parent_cell $src_parent_cell]
                set node_id $src_id
if { 0 } {
                set was_ddio [expr { $was_ddio || $is_ddio } ]
}
#puts "node id:   $node_id node parent cell: $node_parent_cell"
#puts "source id: $src_id source parent cell: $src_parent_cell"
#puts "pin names: $cell_pin_names"
            }
#puts "in same cell: $in_same_cell is_ddio: $is_ddio"
        }
        
        # I might need to get specific based on the family
        foreach_in_collection asgn_id [get_all_assignments -type global -name FAMILY] { break }
        set device_family [get_assignment_info -value $asgn_id]
        switch -exact -- $device_family {
            "Stratix III" { }
            "Stratix II" { }
            default { }
        }
        # I think I can figure out whether or not it's a DDIO cell based on
        # the name of the cell with the register ID passed in.
        set reg_cell [get_cell_info -name [get_node_info -cell $opts(register_id)]]
        set was_ddio [regexp {auto_generated\|ddio_(in|out)} $reg_cell]
    
        return [list $node_id $was_ddio]
    }

    ##########################################
    # Returns a list with the node that feeds
    # the clocks, and whether the registers are altddio 
    proc registers_clock_nodes_and_types { args } {
    
        set options {
            { "register_ids.arg" "" "" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        # Check for register drivers and types
        set all_are_ddio 1
        set any_are_ddio 0
        array set clock_driver_nodes [list]

        foreach id $opts(register_ids) {
            foreach { source_node_id is_ddio } \
                [register_clock_node_and_type -register_id $id] { break }
            set all_are_ddio [expr { $all_are_ddio && $is_ddio }]
            set any_are_ddio [expr { $any_are_ddio || $is_ddio }]
            lappend clock_driver_nodes($source_node_id) $id
        }
    
        # Check the types - if any and all match, everything's the same
        return [list \
            "clock_driver_nodes" [array names clock_driver_nodes] \
            "reg_types_match" [expr { $all_are_ddio == $any_are_ddio }] \
            "is_ddio" $all_are_ddio ]
        
    }

    ##################################################
    # Returns an error if there are any invalid names,
    # or inconsistencies in the data and clock port
    # selections.
    # Returns a flag for whether the registers connect
    # to the data ports are DDIO if there are no errors.
    # Couple of things to do for the data ports
    # 1) They must all exist
    # 2) They must all be the same direction
    # 3) They must all connect to the same type of
    #     register (ddio or non-ddio)
    # 4) They must all have the same clock
    # Set the direction during validation
    # Set the data_register_names during validation
    # Update a list of the error messages
    # Update data
    # Return a 1 or 0 for whether it's a valid result
    proc validate_data_ports { args } {
    
        set options {
            { "data_var.arg" "" "Name of the variable to populate with results" }
            { "error_messages_var.arg" "" "Name of the variable to hold error messages" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data
        variable intermediate_direction
        
        # Things are valid or not. If anything is invalid, set to zero.
        set is_valid 1
        
        # We may want to get information back, particularly during the back/next
        # process. If there's no data variable specified, set up a dummy
        # array to hold the results. Else connect the results array to the
        # variable for the data.
        if { [string equal "" $opts(data_var)] } {
            array set results [list]
        } else {
            upvar $opts(data_var) results
        }
        
        # We may want to get error messages back. If we do, hook
        # up the error messages var to the specified variable.
        if { [string equal "" $opts(error_messages_var)] } {
            set error_messages [list]
        } else {
            upvar $opts(error_messages_var) error_messages
        }

        # After some errors, it's pointless to check for others
        set valid_data_port_names [list]
        set skip_data 0

        # Check data port names for validity
        if { [catch {util::validate_port_names -names $shared_data(data_port_names) \
            -type "data" -valid_var valid_data_port_names -error_var error_messages} res] } {
            # There was an actual error validating port names. That's bad.
            return -code error $res
            
        } elseif { ! $res } {
            # If the result is not valid, reflect that.
            # If it is valid, that's great, but don't set it back to 1.
            set is_valid $res
        }

        # Skip all further data port checks if there are no valid
        # data port names
        set skip_data [expr { 0 == [llength $valid_data_port_names] } ]

        # Check data ports' direction. If directions don't match, stop
        if { ! $skip_data } {
            if { [catch {get_ports_direction -names $valid_data_port_names \
                -type "data" -error_var error_messages} res] } {
                
                # couldn't verify the ports directions - could be a variety
                # of things, but they're now in error_messages
                set shared_data(direction) ""
                set skip_data 1
                set is_valid 0
            } elseif { [string equal "bidir" $res] } {
                # If the ports are bidir, you have to get the direction
                # from the radio button.
                set shared_direction(direction) $intermediate_direction
            } else {
                # You could get the direction from the radio button, because
                # the radio button direction is always correct if the
                # validation comes back OK. The radio button direction is set
                # from the get_ports_direction routine in enable_disable_direction_tf
                # Let's get it direct from the validation routine.
                set shared_data(direction) $res
            }
        }

        # Get IDs of registers that connect to the data ports
        if { ! $skip_data } {
            array unset port_id_to_reg_id
            set ports_without_registers [ports_registers \
                -names $valid_data_port_names \
                -array_var_name port_id_to_reg_id] 
            set data_register_ids [list]
            foreach port_id [array names port_id_to_reg_id] {
                lappend data_register_ids $port_id_to_reg_id($port_id)
                set register_name [get_node_info -name $port_id_to_reg_id($port_id)]
                if { -1 == [util::lsearch_with_brackets \
                    $shared_data(data_register_names) $register_name] } {
                    lappend shared_data(data_register_names) $register_name
                }
            }
            
            # Skip all further data port checks if there are missing registers
            if { 0 < [llength $ports_without_registers] } {
                set msg [list "Can't find any registers connected to the\
                    following data ports:" \
                    [lsort -dictionary $ports_without_registers]]
                lappend error_messages $msg
                set skip_data 1
                set is_valid 0
            }
        }

        # Check for register clock port drivers and register types
        # If data ports are in more than one direction, this is a
        # pointless check to do.
        if { ! $skip_data && ![string equal "" $shared_data(direction)] } {
            array unset temp
            array set temp [registers_clock_nodes_and_types -register_ids \
                $data_register_ids]
            set num_clock_driver_node_ids [llength $temp(clock_driver_nodes)]
            set io_registers_are_ddio $temp(is_ddio)
        
            # All registers must have the same clock port driver (a total of 1)
            if { 1 != $num_clock_driver_node_ids } {
                lappend error_messages [list "The data port registers must be driven\
                    by one clock, but they are driven by\
                    $num_clock_driver_node_ids"]
                set is_valid 0
            } else {
#                set registers_clock_node_name \
#                    [get_node_info -name $temp(clock_driver_nodes)]
            }
            
            # All registers must have the same type
            if { ! $temp(reg_types_match) } {
                lappend error_messages [list "All data ports must be connected to\
                    the same type of register, either ALTDDIO or regular\
                    registers. Your data ports are connected to both types\
                    of registers."]
                set is_valid 0
            }
        }
        
        # Check IO registers against data rate setting
        # You can use DDR registers in SDR mode, but you can't use
        # normal registers in DDR mode.
        if { ! $skip_data } {
            if { [string equal "ddr" $shared_data(data_rate)] && \
                ! $io_registers_are_ddio } {
                lappend error_messages [list "The data ports do not connect to\
                    ALTDDIO registers, but the data\
                    rate is set to double data rate."]
                set is_valid 0
            }
        }
        
        if { $is_valid } {
            array set results [list \
                "direction" $shared_data(direction) \
                "data_register_names" $shared_data(data_register_names) \
                "data_port_names" $shared_data(data_port_names) \
                "register_id" [lindex $data_register_ids 0] \
                "data_rate" $shared_data(data_rate) \
            ]
        }
        
        return $is_valid
        
    }

    #########################################
    # Returns 1 if there was a change in the
    # values on the I/O tab.
    proc data_info_changed { args } {
    
        set options {
            { "data_port_names" "Did data ports change?" }
            { "direction" "Did the direction change?" }
            { "data_rate" "Did the data rate change?" }
            { "data_register_names" "Did the registers connected to ports change" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data
        variable old_data
        
        set changes 0
        
        if { $opts(data_port_names) } {
            set changes [expr { $changes || \
            (![util::check_lists_equal $old_data(data_port_names) $shared_data(data_port_names)])}]
        }
        if { $opts(direction) } {
            set changes [expr { $changes || \
            (! [string equal $old_data(direction) $shared_data(direction)]) }]
        }
        if { $opts(data_register_names) } {
            set changes [expr { $changes || \
            (! [util::check_lists_equal $old_data(data_register_names) $shared_data(data_register_names)]) }]
        }
        if { $opts(data_rate) } {
            set changes [expr { $changes || \
            (! [string equal $old_data(data_rate) $shared_data(data_rate)]) }]
        }

        return $changes
    }

    #########################################
    # Save the state of the critical I/O
    # information. Later the old_ information
    # is used to tell whether anything on the
    # tab changed.
    proc copy_current_data_info_to_old { args } {
    
        set options {
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data
        variable old_data
        
        catch { array unset old_data }
        array set old_data [array get shared_data]
    }

    ##########################################
    # Initialize some values in the I/O tab
    # Old values should be init'ed to whatever is in the tree,
    # so we can detect changes. If defaults are necessary, use them
    # when the tree data is blank
    proc init_data_info { args } {

        set options {
            { "data.arg" "" "Flat array of data" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data
        variable data_port_name
        variable old_data
        variable intermediate_direction
        
        # Initialize the data from the tree
        if { 0 < [llength $opts(data)] } {

            array set temp $opts(data)
            
            foreach k [array names shared_data] {
                set shared_data($k) $temp($k)
                unset temp($k)
            }

            if { 0 < [array size temp] } {
                post_message -type warning "More data than expected when\
                    initializing data_info: [array names temp]"
            }
            
            # Copy the settings over to old_data before initing
            # default values
            array unset old_data
            array set old_data [array get shared_data]
            
            # If data rate is sdr or ddr, that's fine. If it's blank, init it
            # to sdr. For any other value, warn
            switch -exact -- $shared_data(data_rate) {
                "sdr" -
                "ddr" { }
                "" { set shared_data(data_rate) "sdr" }
                default {
                    return -code error "Unknown value for data_rate\
                        in init_data_info: $shared_data(data_rate)"
                }
            }

#            if { 0 == [llength $shared_data(data_register_names)] } {
#                set shared_data(data_register_names) [list]
#            }
            
            set data_port_name ""
            set intermediate_direction $shared_data(direction)
        }
        
        
    }

    #############################################
    # Get the data to save it into the tree
    proc get_shared_data { args } {
    
        set options {
            { "keys.arg" "" "Variables to get" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data

        if { 0 == [llength $opts(keys)] } {
            return [array get shared_data]
        } else {
            set to_return [list]
            foreach key $opts(keys) {
                if { ! [info exists shared_data($key)] } {
                    post_message -type warning "Can't find value for $key \
                        in data_info namespace"
                    lappend to_return $key
                    lappend to_return {}
                } else {
                    lappend to_return $key $shared_data($key)
                }
            }
            return $to_return
        }
    }
}

################################################################################
# Holds high-level data about the clocking topology used by the interface
# This namespace is not responsible for clock creation and editing.
# The clock configuration, and optionally the clock port name, are set here
namespace eval clocking_config {

    # data_list contains variables that are set or changed on the
    # clocking info page.
    # other_data_list contains variables that are used on the clocking
    # info page, but are set or changed on a previous page.
    variable data_list [list \
        "clock_port_name"       "" \
        "clock_configuration"   "" \
    ]
    variable other_data_list [list \
        "data_port_names"       [list] \
        "direction"             "" \
    ]
    variable shared_data
    variable other_data
    variable old_data
    array set shared_data $data_list
    array set other_data $other_data_list
    array set old_data $data_list
    
    # The diagrams array holds the diagrams, one for each clock configuration
    # There's an array of widget names for the clock configuration radio
    # buttons so they can be invoked to trigger GUI enable/disable updates
    variable diagrams
    array set diagrams              [list]
    variable clock_configuration_radio_buttons
    array set clock_configuration_radio_buttons [list]
    
    variable clock_port_name_src    ""
    variable clock_port_name_dest   ""
    variable enabled_clock_output   ""
    
    ################################################
    # Put together the interface diagram tab, on the frame
    # that's passed in
    proc assemble_tab { args } {
    
        set options {
            { "frame.arg" "" "Frame to assemble the tab on" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data
        variable diagrams
        variable clock_port_name_src
        variable clock_port_name_dest
        variable clock_configuration_radio_buttons
        
        # Don't pack this frame, because it comes from a getframe
        set f $opts(frame)

        # Set up the nav frame
#        set nav_frame [frame $f.nav]
#        pack $nav_frame -side top -anchor nw -fill x -expand true

        # Set up clock and data config title frame
        set cdc_tf [TitleFrame $f.cdc -ipad 8 -text "Clock configuration"]
        set sub_f [$cdc_tf getframe]
        
        # Brief instructions
        grid [label $sub_f.l -text "Select the diagram that matches the clock\
            configuration of this interface. Ignore any PLLs for this step." \
            -justify left] - - -sticky w
        grid [Separator $sub_f.sep -relief groove] - - -sticky ew -pady 5

        # Add the diagrams        
        set diagrams(system_sync_common_clock) [canvas $sub_f.system_sync_common_clock]
        set diagrams(system_sync_different_clock) [canvas $sub_f.system_sync_different_clock]
        set diagrams(source_sync_source_clock) [canvas $sub_f.source_sync_source_clock]
        set diagrams(source_sync_dest_clock) [canvas $sub_f.source_sync_dest_clock]

        # Draw the diagrams
        # There are parts that are common to every diagram

        # system sync common clock
        draw_diagram::draw_system_sync_common_clock \
            -canvas $diagrams(system_sync_common_clock) \
            -src_x_offset 32 -dest_x_offset 182

        # system sync different clock
        draw_diagram::draw_system_sync_different_clock \
            -canvas $diagrams(system_sync_different_clock) \
            -src_x_offset 32 -dest_x_offset 182

        # source sync source clock
        draw_diagram::draw_source_sync_source_clock \
            -canvas $diagrams(source_sync_source_clock) \
            -src_x_offset 32 -dest_x_offset 182

        # source sync dest clock
        draw_diagram::draw_source_sync_dest_clock \
            -canvas $diagrams(source_sync_dest_clock) \
            -src_x_offset 32 -dest_x_offset 182

        # Size the canvases
        foreach config [list "system_sync_common_clock" "system_sync_different_clock" \
            "source_sync_source_clock" "source_sync_dest_clock"] {
            set bbox [$diagrams($config) bbox all]
            $diagrams($config) config -height [expr { 5 + [lindex $bbox 3] }] \
                -width [expr { 5 + [lindex $bbox 2] }]
            $diagrams($config) move all 0 5
        }

        # make two frames to hold clock output port labels and entries
        # sso is source sync output, ssi is source sync input
        set sso [frame $sub_f.sso]
        set ssi [frame $sub_f.ssi]

        # Set up the radio buttons for the choice
        set rb0 [radiobutton $sub_f.rb0 -text "" -variable \
            [namespace which -variable shared_data](clock_configuration) \
            -value "system_sync_common_clock" \
            -command "[namespace code swap_highlights]"]
        set rb1 [radiobutton $sub_f.rb1 -text "" -variable \
            [namespace which -variable shared_data](clock_configuration) \
            -value "system_sync_different_clock" \
            -command "[namespace code swap_highlights]"]
        set rb2 [radiobutton $sub_f.rb2 -text "" -variable \
            [namespace which -variable shared_data](clock_configuration) \
            -value "source_sync_source_clock" \
            -command "[namespace code swap_highlights] \
            -output_clock_frame $sso"]
        set rb3 [radiobutton $sub_f.rb3 -text "" -variable \
            [namespace which -variable shared_data](clock_configuration) \
            -value "source_sync_dest_clock" \
            -command "[namespace code swap_highlights] \
            -output_clock_frame $ssi"]

        # Clock output port name for the source sync output
        grid [label $sso.l -text "Enter the name of the port\
            \nthat transmits the output clock" -justify left] - -sticky w
        grid [entry $sso.e -textvariable \
            [namespace which -variable clock_port_name_src]] \
            [button $sso.b -text "..." -width 2] -sticky ew

        # Clock output port name for the source sync input
        grid [label $ssi.l -text "Enter the name of the port\
            \nthat transmits the output clock" -justify left] - -sticky w
        grid [entry $ssi.e -textvariable \
            [namespace which -variable clock_port_name_dest]] \
            [button $ssi.b -text "..." -width 2] -sticky ew

        # Grid in the radio buttons, diagram canvases, and
        # clock output frames as appropriate
        grid $rb0 $diagrams(system_sync_common_clock) x -padx 2 -sticky ew
        grid $rb1 $diagrams(system_sync_different_clock) x -padx 2 -sticky ew
        grid $rb2 $diagrams(source_sync_source_clock) $sso -padx 2 -sticky ew
        grid $rb3 $diagrams(source_sync_dest_clock) $ssi -padx 2 -sticky ew

        # Bind canvas clicks to radio buttons
        bind $diagrams(system_sync_common_clock) <Button-1> \
            [namespace code [list $rb0 invoke]]
        bind $diagrams(system_sync_different_clock) <Button-1> \
            [namespace code [list $rb1 invoke]]
        bind $diagrams(source_sync_source_clock) <Button-1> \
            [namespace code [list $rb2 invoke]]
        bind $diagrams(source_sync_dest_clock) <Button-1> \
            [namespace code [list $rb3 invoke]]

        # Pack the whole thing into the frame and expand it
        pack $cdc_tf -side top -fill x -expand true -anchor nw

        # Disable both clock output frames, and hook up their
        # name finder buttons
        util::recursive_widget_state -widget $sso -state "disabled"
        util::recursive_widget_state -widget $ssi -state "disabled"
        $sso.b configure -command "name_finder::show_dialog -force_one \
            -selected_var [namespace which -variable clock_port_name_src]"
        $ssi.b configure -command "name_finder::show_dialog -force_one \
            -selected_var [namespace which -variable clock_port_name_dest]"

        # Expand on resize
        grid columnconfigure $sso 0 -weight 1
        grid columnconfigure $ssi 0 -weight 1
        grid columnconfigure $sub_f 2 -weight 1

        foreach { conf rb } [list \
            system_sync_common_clock    $rb0 \
            system_sync_different_clock $rb1 \
            source_sync_source_clock    $rb2 \
            source_sync_dest_clock      $rb3 ] {
            
            set clock_configuration_radio_buttons($conf) $rb
        }
        
#        return $nav_frame
    }

    ###################################################
    proc swap_highlights { args } {
    
        set options {
            { "output_clock_frame.arg" "" "Frame that holds output clock info" }
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable shared_data
        variable other_data
        variable diagrams
        variable enabled_clock_output
        variable clock_port_name_src
        variable clock_port_name_dest
        
        # Handle moving highlight when clicking on radio button
#        $diagrams($old_clock_configuration) configure -bg "SystemButtonFace"
#        $diagrams($clock_configuration) configure -bg "grey50"
#        set old_clock_configuration $clock_configuration
        
        # Enable or disable the clock output port entry appropriately
        if { ![string equal "" $enabled_clock_output] } {
            util::recursive_widget_state -widget $enabled_clock_output -state disabled
            set enabled_clock_output ""
            set clock_port_name_src ""
            set clock_port_name_dest ""
        }

        switch -exact -- $other_data(direction) {
            "input" {
                if { [string equal "source_sync_dest_clock" $shared_data(clock_configuration)] } {
                    util::recursive_widget_state -widget $opts(output_clock_frame) -state "normal"
                    set enabled_clock_output $opts(output_clock_frame)
                    set clock_port_name_dest $shared_data(clock_port_name)
                }
            }
            "output" {
                if { [string equal "source_sync_source_clock" $shared_data(clock_configuration)] } {
                    util::recursive_widget_state -widget $opts(output_clock_frame) -state "normal"
                    set enabled_clock_output $opts(output_clock_frame)
                    set clock_port_name_src $shared_data(clock_port_name)
                }
            }
            default {
                return -code error "Unknown value for direction in swap_highlights:\
                    $other_data(direction)"
            }
        }

        # For most situations, there is no clock port name,
        # so this is good.
        # For the situations where there is a clock port name,
        # the name was transfered into the _src or _dest variables
        # already. It will be transfered back into clock_port_name
        # when we click Next
#        set shared_data(clock_port_name) ""

    }

    #########################################
    # Returns 1 if there was a change in the
    # values on the I/O tab.
    proc clocking_config_changed { args } {
    
        set options {
            { "clock_port_name" "Did clock port name change?" }
            { "clock_configuration" "Did the clock configuration change?" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data
        variable old_data

        set changes 0
        
        if { $opts(clock_port_name) } {
            set changes [expr { $changes || \
            (! [string equal $old_data(clock_port_name) $shared_data(clock_port_name)]) }]
        }
        if { $opts(clock_configuration) } {
            set changes [expr { $changes || \
            (! [string equal $old_data(clock_configuration) $shared_data(clock_configuration)]) }]
        }

        return $changes
    }

    #########################################
    # Save the state of the critical I/O
    # information. Later the old_ information
    # is used to tell whether anything on the
    # tab changed.
    proc copy_current_clocking_config_to_old { args } {
    
        set options {
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable shared_data
        variable old_data
        variable clock_port_name_src
        variable clock_port_name_dest

        switch -exact -- $shared_data(clock_configuration) {
            "source_sync_source_clock" { set shared_data(clock_port_name) $clock_port_name_src }
            "source_sync_dest_clock" { set shared_data(clock_port_name) $clock_port_name_dest }
            "system_sync_common_clock" -
            "system_sync_different_clock" { set shared_data(clock_port_name) "" }
            default {
                return -code error "Unknown value for clock_configuration in\
                    copy_current_clocking_config_to_old: $shared_data(clock_configuration)"
            }
        }
        
        catch { array unset old_data }
        array set old_data [array get shared_data]
    }

    ##########################################
    # Initialize some values in the I/O tab
    # Old values should be init'ed to whatever is in the tree,
    # so we can detect changes. If defaults are necessary, use them
    # when the tree data is blank
    proc init_clocking_config { args } {

        set options {
            { "data.arg" "" "Flat array of data" }
            { "update_direction.arg" "" "current direction" }
            { "data_port_names.arg" "" "Data port names" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data
        variable other_data
        variable old_data
        variable clock_port_name_src
        variable clock_port_name_dest
        
        # Initialize data from the tree
        if { 0 < [llength $opts(data)] } {
        
            array set temp $opts(data)
            
            foreach k [array names shared_data] {
                set shared_data($k) $temp($k)
                unset temp($k)
            }

            foreach k [array names other_data] {
                set other_data($k) $temp($k)
                unset temp($k)
            }

            if { 0 < [array size temp] } {
                post_message -type warning "More data than expected when\
                    initializing clock_diagram: [array names temp]"
            }
            
            # Copy the settings over to old_data before initing default values
            array unset old_data
            array set old_data [array get shared_data]
            
            # Set up a default value for clock_configuration
            # clock_configuration gets set on this tab, so it's OK if it's blank.
            # We have to have something for the clock configuration radio button,
            # so give it a default if it's blank
            # Init the clock port name variables based on the clock configuration
            switch -exact -- $shared_data(clock_configuration) {
                "source_sync_source_clock" {
                    set clock_port_name_src $shared_data(clock_port_name)
                    set clock_port_name_dest ""
                }
                "source_sync_dest_clock" {
                    set clock_port_name_src ""
                    set clock_port_name_dest $shared_data(clock_port_name)
                }
                "system_sync_common_clock" -
                "system_sync_different_clock" {
                    set clock_port_name_src ""
                    set clock_port_name_dest ""
                }
                "" {
                    # Give a default value if blank.
                    set shared_data(clock_configuration) "system_sync_common_clock"
                    set clock_port_name_src ""
                    set clock_port_name_dest ""
                }
                default {
                    # Return if it's any other value
                    return -code error "The value for clock_configuration\
                        is invalid in init_clocking_config: $shared_data(clock_configuration)"
                }
            }
            
            # For most situations, there is no clock port name,
            # so this is good.
            # For the situations where there is a clock port name,
            # the name was transfered into the _src or _dest variables
            # already. It will be transfered back into clock_port_name
            # when we click Next
#            set shared_data(clock_port_name) ""

        }
        # end of default data configuration part
        
        # Update the direction
        if { ![string equal "" $opts(update_direction)] } {
            set other_data(direction) $opts(update_direction)
        }

        # Update data port names
        if { 0 < [llength $opts(data_port_names)] } {
            set other_data(data_port_names) $opts(data_port_names)
        }
    }

    #############################################
    # Get the data to save it into the tree
    proc get_shared_data { args } {
    
        set options {
            { "keys.arg" "" "Variables to get" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        variable shared_data

        if { 0 == [llength $opts(keys)] } {
            return [array get shared_data]
        } else {
            set to_return [list]
            foreach key $opts(keys) {
                if { ! [info exists shared_data($key)] } {
                    post_message -type warning "Can't find value for $key \
                        in clocking_config namespace"
                    lappend to_return $key
                    lappend to_return {}
                } else {
                    lappend to_return $key $shared_data($key)
                }
            }
            return $to_return
        }
    }
    
    #########################################
    # Validate the clock port
    # Set clock_port_name during validation
    proc validate_clock_port { args } {

        set options {
            { "data_var.arg" "" "Name of the variable to populate with results" }
            { "error_messages_var.arg" "" "Name of the variable to hold error messages" }
            { "pre_validation.arg" "" "What do we do for pre-validation" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data
        variable other_data
        variable clock_port_name_src
        variable clock_port_name_dest

        # Things are valid or not. If anything is invalid, set to zero.
        set is_valid 1
        
        # We may want to get information back, particularly during the back/next
        # process. If there's no data variable specified, set up a dummy
        # array to hold the results. Else connect the results array to the
        # variable for the data.
        if { [string equal "" $opts(data_var)] } {
            array set results [list]
        } else {
            upvar $opts(data_var) results
        }
        
        # We may want to get error messages back. If we do, hook
        # up the error messages var to the specified variable.
        if { [string equal "" $opts(error_messages_var)] } {
            set error_messages [list]
        } else {
            upvar $opts(error_messages_var) error_messages
        }

        # Do prevalidation if necessary
        switch -exact -- $opts(pre_validation) {
            "skip" { }
            "run_and_return" -
            "return_on_invalid" {
                 # Make sure that there are data ports selected.
                if { [string equal "" $other_data(direction)] } {
                    lappend error_messages [list "You must choose data ports or a bus to\
                        constrain before you select the interface clock configuration"]
                    set is_valid 0
                }
                if { 0 == [llength $other_data(data_port_names)] } {
                    lappend error_messages [list "You must choose data ports or a bus to\
                        constrain before you select the interface clock configuration"]
                    set is_valid 0
                }
            }
            default {
                return -code error "Unknown option for -pre_validation in\
                    validate_clock_port: $opts(pre_validation)"
            }
        }
        switch -exact -- $opts(pre_validation) {
            "skip" { }
            "run_and_return" { return $is_valid }
            "return_on_invalid" { if { ! $is_valid } { return $is_valid } }
        }
        # End of pre-validation
        
        set valid_clock_port_name ""

        switch -exact -- $shared_data(clock_configuration) {
        "system_sync_common_clock" -
        "system_sync_different_clock" {
            # these are just OK by default
        }
        "source_sync_source_clock" {
            if { [string equal "output" $other_data(direction)] } {
                # Check clock port name for validity
                if { [catch {util::validate_port_names -names $clock_port_name_src \
                    -type "clock" -one_port -valid_var valid_clock_port_name \
                    -error_var error_messages} res] } {
                    
                    # There was an actual error validating port names. That's bad.
                    return -code error $res
                
                } elseif { ! $res } {
                    # If the result is not valid, reflect that.
                    # If it is valid, that's great, but don't set it back to 1.
                    set is_valid $res
                } else {
                
                    # The port name exists and is valid

                    # First make sure the clock port is an output port.
                    foreach_in_collection port_id [get_ports $valid_clock_port_name] { break }
                    if { [catch { data_info::port_direction -port_id $port_id } res] } {
                        # There was an error. urf.
                        return -code error $res
                    } elseif { [string equal "output" $res] } {
                        # Yay - it's an output.
                        # Do nothing
                    } else {
                        lappend error_messages [list "$valid_clock_port_name is a(n) $res\
                            port, but must be an output port."]
                        set is_valid 0
                    }

                    # Make sure the clock port is not also a data port
                    # Have to expand to cover data_out* matching data_out[1]
                    foreach data_port_patern $other_data(data_port_names) {
                        foreach_in_collection data_port_id [get_ports $data_port_patern] {
                            set data_port_name [get_port_info -name $data_port_id]
                            if { [string equal $valid_clock_port_name $data_port_name] } {
                                # The clock port name matches a data port name. Bad.
                                lappend error_messages [list "$valid_clock_port_name matches\
                                    the name of a data port. The clock port must not be\
                                    part of the list of data ports."]
                                set is_valid 0
                            }
                        }
                    }
                }
            }
        }
        "source_sync_dest_clock" {
            if { [string equal "input" $other_data(direction)] } {
                # Check clock port name for validity
                if { [catch {util::validate_port_names -names $clock_port_name_dest \
                    -type "clock" -one_port -valid_var valid_clock_port_name \
                    -error_var error_messages} res] } {

                    # There was an actual error validating port names. That's bad.
                    return -code error $res
                    
                } elseif { ! $res } {
                
                    # If the result is not valid, reflect that.
                    # If it is valid, that's great, but don't set it back to 1.
                    set is_valid $res
                } else {

                    # The port name exists and is valid

                    # First make sure the clock port is an output port
                    foreach_in_collection port_id [get_ports $valid_clock_port_name] { break }
                    if { [catch { data_info::port_direction -port_id $port_id } res] } {
                        # There was an error. urf.
                        return -code error $res
                    } elseif { [string equal "output" $res] } {
                        # Yay - it's an output.
                        # Do nothing
                    } else {
                        lappend error_messages [list "$valid_clock_port_name is a(n) $res\
                            port, but must be an output port."]
                        set is_valid 0
                    }


                    # Make sure the clock port is not also a data port
                    if { -1 != [util::lsearch_with_brackets \
                        $other_data(data_port_names) $valid_clock_port_name] } {
                        lappend error_messages [list "$valid_clock_port_name matches\
                            the name of a data port. The clock port must not be\
                            part of the list of data ports."]
                        set is_valid 0
                    }
                }
            }
            
        }
        default {
            lappend error_messages [list "No clock configuration is selected.\
                You must select the clock configuration this interface uses"]
            set is_valid 0
        }
        }

        if { $is_valid } {
            set shared_data(clock_port_name) $valid_clock_port_name
            array set results [list \
                "clock_port_name" $shared_data(clock_port_name) \
                "clock_configuration" $shared_data(clock_configuration) \
            ]
        }
        
        return $is_valid
    }
    
    #############################################
    # Do whatever "last minute" things are necessary to prepare the page to be raised
    # Initialize variables behind radio buttons
    # Update chip diagram labels
    proc prep_for_raise { args } {
    
        set options {
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data
        variable other_data
        variable clock_configuration_radio_buttons
        variable diagrams
        
        # Update the chip diagram labels.
        foreach d [array names diagrams] {
            draw_diagram::update_chip_diagram_labels \
                -canvas $diagrams($d) -direction $other_data(direction)
        }
#        update_chip_diagram_labels -direction $other_data(direction)
        
        # Make the initial configuration selection.
        # Do this because the last two radio buttons enable and
        # disable frames
        $clock_configuration_radio_buttons($shared_data(clock_configuration)) \
            invoke
    }
}


################################################################################
# 
namespace eval clock_entry {

    variable base_dialog
    variable generated_dialog
    variable output_dialog
    variable clock_info
    variable base_entry_widget
    variable generated_entry_widget
    variable generated_frequency_button
    variable generated_waveform_button
    variable output_entry_widget
    variable output_polarity_frame
    variable prev_clock_name
    
    array set clock_info [list \
        name    "" \
        period  "" \
        source  "" \
        wer     "" \
        wef     "" \
        type    "base" \
        targets "" \
        divide_by     "" \
        multiply_by    "" \
        duty_cycle    "" \
        phase   "" \
        offset  "" \
        based_on "frequency" \
        edge1    "" \
        edge2   "" \
        edge3   "" \
        edgeshift1   "" \
        edgeshift2  "" \
        edgeshift3  "" \
        invert  0 \
        master_clock "" \
    ]
    
    ################################################################################
    proc assemble_base_clock_dialog { args } {
    
        set options {
            { "parent.arg" "" "Parent frame of the widgets" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable base_entry_widget
        variable clock_info
        variable base_dialog

        set base_dialog [Dialog .bc_dialog -modal local -side bottom \
            -anchor e -parent $opts(parent) -title "Create Clock" \
            -default 0 -cancel 1 -transient no]
        $base_dialog add -name ok -width 10
        $base_dialog add -name cancel -width 10
        
        # Configure the validation on the OK button
        $base_dialog itemconfigure 0 -command "[namespace code verify_clock]\
            -dialog $base_dialog -index 0"
             
        set f [$base_dialog getframe]
    
        set cnlf [LabelFrame $f.cnlf -side left -text "Clock name:"]
        set cnsubf [$cnlf getframe]
        entry $cnsubf.e -textvariable [namespace which -variable clock_info](name)
        pack $cnsubf.e $cnsubf -side left -anchor w -fill x -expand true
    
        set plf [LabelFrame $f.plf -side left -text "Period:"]
        set psubf [$plf getframe]
        entry $psubf.e -width 10 -textvariable \
            [namespace which -variable clock_info](period) -validate all \
            -validatecommand [list util::validate_float %P %V -positive]
        pack $psubf.e $psubf [label $psubf.l -text "ns"] -side left -anchor w

        frame $f.f
        TitleFrame $f.f.we -text "Waveform edges" -ipad 8
        set we_f [$f.f.we getframe]
        
        label $we_f.r_l -text "Rising:"
        entry $we_f.r_e -width 10 -textvariable \
            [namespace which -variable clock_info](wer) -validate all \
            -validatecommand [list util::validate_float %P %V -positive]
        label $we_f.r_u -text "ns"
        
        label $we_f.f_l -text "Falling:"
        entry $we_f.f_e -width 10 -textvariable \
            [namespace which -variable clock_info](wef) -validate all \
            -validatecommand [list util::validate_float %P %V -positive]
        label $we_f.f_u -text "ns"
    
        set tlf [LabelFrame $f.tlf -side left -text "Targets:"]
        set tsubf [$tlf getframe]
        label $tsubf.l -textvariable \
            [namespace which -variable clock_info](targets) -anchor w
        pack $tsubf.l $tsubf -side left -anchor w -fill x -expand true
    
        grid $we_f.r_l $we_f.r_e $we_f.r_u -sticky w -pady 2
        grid $we_f.f_l $we_f.f_e $we_f.f_u -sticky w -pady 2
        pack $f.f.we $we_f -side top -fill both -expand true
        
        pack $cnlf -side top -anchor w -fill x -expand true -pady 2
        pack $plf -side top -anchor w -pady 2
        pack $f.f -side top -anchor w
        pack $tlf -side top -anchor w -fill x -expand true
    
        LabelFrame::align $cnlf $plf $tlf
    
        # Withdraw the window when you click X instead of deleting it
        wm protocol $base_dialog WM_DELETE_WINDOW [list $base_dialog withdraw]
        
        # Return the path of the entry widget so focus can be given to it
        # by the dialog box draw
        set base_entry_widget $cnsubf.e
    }
    
    ################################################################################
    proc assemble_generated_clock_dialog { args } {
    
        set options {
            { "parent.arg" "" "Frame to use for the widgets" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        variable clock_info
        variable generated_dialog
        variable generated_entry_widget
        variable generated_frequency_button
        variable generated_waveform_button

        set generated_dialog [Dialog .gc_dialog -modal local -side bottom \
            -anchor e -parent $opts(parent) -title "Create Generated Clock" \
            -default 0 -cancel 1 -transient no]
        $generated_dialog add -name ok -width 10
        $generated_dialog add -name cancel -width 10
        
        # Configure the validation on the OK button
        $generated_dialog itemconfigure 0 -command "[namespace code verify_clock]\
            -dialog $generated_dialog -index 0"

        set f [$generated_dialog getframe]
    
        set cnlf [LabelFrame $f.cnlf -side left -text "Clock name:"]
        set cnsubf [$cnlf getframe]
        entry $cnsubf.e -textvariable \
            [namespace which -variable clock_info](name)
        pack $cnsubf.e -side left -anchor w -fill x -expand true
    
        set slf [LabelFrame $f.slf -side left -text "Source:"]
        set ssubf [$slf getframe]
        label $ssubf.l -textvariable \
            [namespace which -variable clock_info](source) -anchor w
        pack $ssubf.l -side left -anchor w -fill x -expand true
    
        set mcnlf [LabelFrame $f.mcnlf -side left -text "Master clock:"]
        set mcnsubf [$mcnlf getframe]
        label $mcnsubf.l -textvariable \
            [namespace which -variable clock_info](master_clock) -anchor w
        pack $mcnsubf.l -side left -anchor w -fill x -expand true
    
        frame $f.f
        TitleFrame $f.f.rts -text "Relationship to source" -ipad 8
        set rts_f [$f.f.rts getframe]
    
        radiobutton $rts_f.bof -text "Based on frequency" -value "frequency" \
            -variable [namespace which -variable clock_info](based_on)
        
        label $rts_f.db_l -text "Divide by:"
        entry $rts_f.db_e -width 10 -textvariable \
            [namespace which -variable clock_info](divide_by) \
            -validate all -validatecommand [list util::validate_int %P %V -positive]
        
        label $rts_f.mb_l -text "Multiply by:"
        entry $rts_f.mb_e -width 10 -textvariable \
            [namespace which -variable clock_info](multiply_by) \
            -validate all -validatecommand [list util::validate_int %P %V -positive]
        
        label $rts_f.dc_l -text "Duty cycle:"
        entry $rts_f.dc_e -width 10 -textvariable \
            [namespace which -variable clock_info](duty_cycle) \
            -validate all -validatecommand [list util::validate_float %P %V -positive]
    
        label $rts_f.p_l -text "Phase:"
        entry $rts_f.p_e -width 10 -textvariable \
            [namespace which -variable clock_info](phase) \
            -validate all -validatecommand [list util::validate_float %P %V]
        
        label $rts_f.o_l -text "Offset"
        entry $rts_f.o_e -width 10 -textvariable \
            [namespace which -variable clock_info](offset) \
            -validate all -validatecommand [list util::validate_float %P %V]
        
        radiobutton $rts_f.bow -text "Based on waveform" -value "waveform" \
            -variable [namespace which -variable clock_info](based_on)
        
        label $rts_f.el_l -text "Edge list:"
        entry $rts_f.el_e1 -width 10 -textvariable \
            [namespace which -variable clock_info](edge1);# -state "disabled"
        entry $rts_f.el_e2 -width 10 -textvariable \
            [namespace which -variable clock_info](edge2);# -state "disabled"
        entry $rts_f.el_e3 -width 10 -textvariable \
            [namespace which -variable clock_info](edge3);# -state "disabled"
    
        label $rts_f.esl_l -text "Edge shift list:"
        entry $rts_f.esl_e1 -width 10 -textvariable \
            [namespace which -variable clock_info](edgeshift1);# -state "disabled"
        label $rts_f.esl_u1 -text "ns"
        entry $rts_f.esl_e2 -width 10 -textvariable \
            [namespace which -variable clock_info](edgeshift2);# -state "disabled"
        label $rts_f.esl_u2 -text "ns"
        entry $rts_f.esl_e3 -width 10 -textvariable \
            [namespace which -variable clock_info](edgeshift3);# -state "disabled"
        label $rts_f.esl_u3 -text "ns"
        
        checkbutton $rts_f.iw -text "Invert waveform" -variable \
            [namespace which -variable clock_info](invert)
    
        set tlf [LabelFrame $f.tlf -side left -text "Targets:"]
        set tsubf [$tlf getframe]
        label $tsubf.l -textvariable \
            [namespace which -variable clock_info](targets) -anchor w
        pack $tsubf.l -side left -anchor w -fill x -expand true
    
        # Grid the Relationship to source frame
        grid $rts_f.bof - - - - - - - -sticky w
        grid x $rts_f.db_l $rts_f.db_e x $rts_f.p_l x $rts_f.p_e x
        grid x $rts_f.mb_l $rts_f.mb_e x $rts_f.o_l x $rts_f.o_e x
        grid x $rts_f.dc_l $rts_f.dc_e x x x x x
        grid $rts_f.bow - - - - - - - -sticky w
        grid x $rts_f.el_l $rts_f.el_e1 x $rts_f.el_e2 x $rts_f.el_e3 x
        grid x $rts_f.esl_l $rts_f.esl_e1 $rts_f.esl_u1 $rts_f.esl_e2 $rts_f.esl_u2 $rts_f.esl_e3 $rts_f.esl_u3
        grid $rts_f.iw - - - - - - - -sticky w
        pack $rts_f $f.f.rts -side top -fill both -expand true
        grid columnconfigure $rts_f 0 -minsize 15
    
        pack $cnlf $slf $mcnlf -side top -anchor w -fill x -expand true -pady 2
        pack $f.f -side top -anchor w
        pack $tlf -side top -anchor w -fill x -expand true
    
        LabelFrame::align $cnlf $slf $mcnlf $tlf

        set frequency_widgets [list $rts_f.db_e $rts_f.mb_e $rts_f.dc_e \
            $rts_f.p_e $rts_f.o_e]
        set waveform_widgets [list $rts_f.el_e1 $rts_f.el_e2 $rts_f.el_e3 \
            $rts_f.esl_e1 $rts_f.esl_e2 $rts_f.esl_e3]

        # Handle "based on" clicks
        $rts_f.bof configure -command "util::enable_disable_widgets \
            -normal_widgets [list $frequency_widgets] \
            -disabled_widgets [list $waveform_widgets]"
        $rts_f.bow configure -command "util::enable_disable_widgets \
            -normal_widgets [list $waveform_widgets] \
            -disabled_widgets [list $frequency_widgets]"

        # Withdraw the window when you click X instead of deleting it
        wm protocol $generated_dialog WM_DELETE_WINDOW [list $generated_dialog withdraw]
        
        # Set the path of the entry widget so focus can be given to it
        # by the dialog box draw
        # Also set the frequency and waveform buttons so they can be
        # invoked depending on the based_on value for generated clocks
        set generated_entry_widget $cnsubf.e
        set generated_frequency_button $rts_f.bof
        set generated_waveform_button $rts_f.bow
    }

    ################################################################################
    # Special dialog for output clock ports only. It has a restricted set of choices
    # because clocks on output ports for SDR are only 1:1, non-inverted, and
    # for DDR can be only inverted or non-inverted. 
    proc assemble_output_clock_dialog { args } {
    
        set options {
            { "parent.arg" "" "Frame to use for the widgets" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable clock_info
        variable output_entry_widget
        variable output_polarity_frame
        variable output_dialog
        
        set output_dialog [Dialog .oc_dialog -modal local -side bottom \
            -anchor e -parent $opts(parent) -title "Create Generated Clock" \
            -default 0 -cancel 1 -transient no]
        $output_dialog add -name ok -width 10
        $output_dialog add -name cancel -width 10
        
        # Configure the validation on the OK button
        $output_dialog itemconfigure 0 -command "[namespace code verify_clock]\
            -dialog $output_dialog -index 0"

        set f [$output_dialog getframe]
    
        # Clock name labelframe
        set cnlf [LabelFrame $f.cnlf -side left -text "Clock name:"]
        set cnsubf [$cnlf getframe]
        entry $cnsubf.e -textvariable [namespace which -variable clock_info](name)
        pack $cnsubf.e -side left -anchor w -fill x -expand true
    
        # Source name labelframe
        set slf [LabelFrame $f.slf -side left -text "Source:"]
        set ssubf [$slf getframe]
        label $ssubf.l -textvariable \
            [namespace which -variable clock_info](source) -anchor w
        pack $ssubf.l -side left -anchor w -fill x -expand true
    
        # Master clock name labelframe
        set mcnlf [LabelFrame $f.mcnlf -side left -text "Master clock:"]
        set mcnsubf [$mcnlf getframe]
        label $mcnsubf.l -textvariable \
            [namespace which -variable clock_info](master_clock) -anchor w
        pack $mcnsubf.l -side left -anchor w -fill x -expand true
    
        # Output clock polarity titleframe 
        set potf [TitleFrame $f.potf -text "Output clock polarity" -ipad 8]
        set subf [$potf getframe]
        label $subf.l -text "How are the data pins connected for the ALTDDIO_OUT\
            register that drives the output clock?"
        Separator $subf.sep
        radiobutton $subf.normal -text "Normal - datain_h to VCC and datain_l to GND" \
            -value 0 -variable [namespace which -variable clock_info](invert)
        radiobutton $subf.inverted -text "Inverted - datain_h to GND and datain_l to VCC" \
            -value 1 -variable [namespace which -variable clock_info](invert)
        pack $subf.l -side top -anchor nw
        pack $subf.sep -side top -anchor nw -fill x -expand true -pady 5
        pack $subf.normal $subf.inverted -side top -anchor nw
    
        # Target name labelframe
        set tlf [LabelFrame $f.tlf -side left -text "Targets:"]
        set tsubf [$tlf getframe]
        label $tsubf.l -textvariable \
            [namespace which -variable clock_info](targets) -anchor w
        pack $tsubf.l -side left -anchor w -fill x -expand true
    
        # Pack in the labelframes and titleframe
        pack $cnlf $slf $mcnlf $potf $tlf -side top -anchor nw -fill x -expand true \
            -pady 4
    
        # Align the labelframe contents
        LabelFrame::align $cnlf $slf $mcnlf $tlf
    
        # Withdraw the window when you click X instead of deleting it
        wm protocol $output_dialog WM_DELETE_WINDOW [list $output_dialog withdraw]
        

        # Set the path of the entry widget so focus can be given to it
        # by the dialog box draw
        # Also set the path of the polarity titleframe so it can be enabled
        # or disabled for DDR/SDR
        set output_entry_widget $cnsubf.e
        set output_polarity_frame $potf
    }

    ############################################
    # Show the appropriate clock entry dialog
    # based on the selected node
    proc show_dialog { args } {
    
        set options {
            { "widget.arg" "" "Widget that holds the clock path tree" }
            { "new_clock_id_var.arg" "" "Variable name for a new clock ID" }
            { "node_id.arg" "" "Selected clock path node" }
            { "clock_port_name.arg" "" "Clock port name for generated clock dialog" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable clock_info
        variable base_dialog
        variable generated_dialog
        variable output_dialog
        variable base_entry_widget
        variable generated_entry_widget
        variable generated_frequency_button
        variable generated_waveform_button
        variable output_entry_widget
        variable output_polarity_frame
        variable prev_clock_name
        
        upvar $opts(new_clock_id_var) new_clock_id

        # All nodes that get or have clocks have the clock_type entry
        # in their data
        # If clock_type doesn't exist, return
        array set node_data [$opts(widget) itemcget $opts(node_id) -data]
        if { ! [info exists node_data(clock_type)] } {
            return
        }
    
        # Initialize everything so there's no stale data when the base or
        # generated dialogs are displayed
        init_clock_info
        array set clock_info $node_data(clock_info)
        set prev_clock_name $clock_info(name)

        # If there's an error when the user edits a clock, I need to save
        # data I can use to restore the clock to what it was before
        # the error.
        if { ! $node_data(placeholder) } {
            array set restore_info [util::remove_clock_default_values -clock_id $opts(node_id) \
                -type $node_data(clock_type)]

            # If it's a generated clock, there's a source to set, and maybe a master
            switch -exact -- $node_data(clock_type) {
                "generated" {
                    set restore_info(source) \
                        [get_node_info -name $node_data(source_id)]
                    if { [info exists node_data(master_clock_id)] } {
                        set restore_info(master_clock) \
                            [get_clock_info -name $node_data(master_clock_id)]
                    }
                }
                "virtual" -
                "base" { }
                default {
                    return -code error "Unknown clock_type in show_dialog:\
                        $node_data(clock_type)"
                }
            }
        
            # If it's not a virtual clock, there's a target to set
            switch -exact -- $node_data(clock_type) {
                "base" -
                "generated" {
                    set restore_info(targets) [get_node_info -name $node_data(target_id)]
                }
                "virtual" { }
                default {
                    return -code error "Unknown clock_type in show_dialog:\
                        $node_data(clock_type)"
                }
            }
        }
    
        # Fill in a master clock name if necessary
        if { [info exists node_data(master_clock_id)] } {
            set clock_info(master_clock) \
                [get_clock_info -name $node_data(master_clock_id)]
        }
        
        set done 0
        set had_error 0

        # Stay in a loop to show the dialog until there is no error,
        # or it's canceled.
        while { ! $done } {
        
            # Now that all the fields have been filled, show the correct dialog
            # Put focus in the Clock name entry field
            switch -exact -- $node_data(clock_type) {
                "virtual" -
                "base" {
                    set dialog_result [$base_dialog draw $base_entry_widget]
                }
                "generated" {
                    # clock_port_name was refered to directly through the 
                    # namespace - ugh. clocking_config::shared_data(clock_port_name))
                    if { ! [string equal $clock_info(targets) $opts(clock_port_name)] } {
    
                        # If the target is not the output port, show the generic
                        # generated clock dialog. Invoke frequency or dialog radio-
                        # buttons depending on the value of based_on, then show the
                        # dialog.
                        switch -exact -- $clock_info(based_on) {
                            "frequency" { $generated_frequency_button invoke }
                            "waveform"  { $generated_waveform_button invoke }
                        }
                        set dialog_result \
                            [$generated_dialog draw $generated_entry_widget]
                    } else {
    
                        # If it is the output port, show the special generated dialog.
                        if { [info exists node_data(is_ddio_fed)] } {
                            util::recursive_widget_state -widget \
                                $output_polarity_frame -state "normal"
                        } else {
                            util::recursive_widget_state -widget \
                                $output_polarity_frame -state "disabled"
                        }
                        set dialog_result \
                            [$output_dialog draw $output_entry_widget]
                    }
                }
                default {
                    return -code error "Unknown clock_type in show_dialog:\
                        $node_data(clock_type)"
                }
            }

            # Process the dialog result.
            # 0 is OK, 1 is cancel
            if { 0 == $dialog_result } {
            
                # The user pressed OK
                # Try to make whatever update they entered.
                if { [catch { clocks_info::update_clock_in_tree -widget $opts(widget) \
                    -node_id $opts(node_id) -clock_info [array get clock_info] \
                    -clock_type $node_data(clock_type) } res] } {

                    # There was an error creating the clock
                    # Go through the loop again
                    tk_messageBox -icon error -type ok -default ok \
                        -title "Error creating clock" -parent [focus] -message $res
                    set done 0
                    set had_error 1

                } else {

                    # The clock was created successfully. All done.
                    set new_clock_id $res
                    set done 1
                    set had_error 0
                }

            } elseif { $had_error && ! $node_data(placeholder) } {

                # The user pressed cancel after an error creating a clock.
                # If the error happened when editing a placeholder,
                # there's no problem because it's not actually a clock yet.
                # If the error happened when editing a clock,
                # roll it back to the restore_info
                # Use -skip_remove here because you shouldn't attempt to
                # remove the clock that's being replaced by the rollback.
                # In a previous step, the clock on the node was removed,
                # and the new clock to replace it had an error. Therefore
                # there is no clock now on the node, so we should not attempt
                # to remove one. Attempting to remove one generates warning
                # messages we can avoid.
                if { [catch { clocks_info::update_clock_in_tree -widget $opts(widget) \
                    -node_id $opts(node_id) -clock_info [array get restore_info] \
                    -clock_type $node_data(clock_type) -skip_remove } res] } {

                    # If there's actually an error here, there's no easy way to 
                    # recover. Just return.
                    return -code error "Error restoring clock.\
                        Quit and restart this script.\n$res"

                } else {

                    set new_clock_id $res
                    set done 1

                }

            } else {
                # You get here if you just cancelled out
                set done 1
            }
        }
        
        return [list $dialog_result $had_error]
    }

    ############################################
    # Set the variable clock_info to known values
    proc init_clock_info { } {
    
        variable clock_info
    
        # Initialize everything out so there's no stale data
        foreach o [array names clock_info] {
            switch -exact -- $o {
                "type" { set clock_info(type) "base" }
                "based_on" { set clock_info(based_on) "frequency" }
                "invert" { set clock_info(invert) 0 }
                default { set clock_info($o) "" }
            }
        }
    }
    
    ############################################
    # Don't let the user overwrite an existing clock
    proc verify_clock { args } {

        set options {
            { "dialog.arg" "" "Name of the dialog that would be withdrawn" }
            { "index.arg" "" "Button index that was clicked" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable clock_info
        variable prev_clock_name
        
        set is_bad 0
        set msg ""
        
        # If the clock name is being changed, we have to make sure it will not
        # overwrite any clocks that already exist in the design that have the
        # same name.
        if { ! [string equal $prev_clock_name $clock_info(name)] } {
        
            # The name is being changed, so we have to check the new name.
            # Get clocks with the name that was entered in the dialog
            set clocks_collection [get_clocks $clock_info(name)]
            
            # Get how many clocks with that name there are
            if { [catch { get_collection_size $clocks_collection } num_clocks] } {
            
                # If there was an error, probably no name was entered,
                # so we can just keep going with the default flow
                
            } elseif { 1 == $num_clocks } {
            
                # A clock by that name exists already.
                set is_bad 1
                
                # We can figure out a little more to improve the error message
                # If there is a target, report that.
                foreach_in_collection clock_id $clocks_collection { break }
                set targets_col [get_clock_info -targets $clock_id]

                if { [catch { get_collection_size $targets_col } num_targets] } {
                
                    # There was an error getting the targets. Hrm.
                    # We can just punt, I think. The only time when I think
                    # this could ever be a problem is if a virtual clock
                    # somehow has a problem with targets.
                    set msg "Error validating clocks because a clock named\
                        $clock_info(name) already exists in your design.\
                        \n$num_targets"
    
                } elseif { 0 == $num_targets } {

                    set msg "A virtual clock named $clock_info(name) already\
                        exists in your design.\nEach clock must have a unique name.\
                        Change one of the names to continue."

                } elseif { 1 == $num_targets } {
                
                    foreach_in_collection target_id $targets_col { break }
                    set target_name [get_node_info -name $target_id]
                    set msg "A clock named $clock_info(name) already exists on\
                        $target_name in your design.\nEach clock must have a\
                        unique name. Change one of the names to continue."
                        
                } else {
                    set msg "Can't validate clocks because $clock_info(name) has\
                        $num_targets targets."
                }
                
            } elseif { 1 < $num_clocks } {
                # This is bad. More than 1 clock by that name exists.
                # I don't think this error mode is possible, but I'll
                # distinguish it anyway.
                set is_bad 1
                set msg "Can't validate $clock_info(name) because\
                    more than 1 clock matches its name."
                return
            } else {
                # Fine.
            }
        }
        
        # If it is valid, end the dialog
        if { $is_bad } {
            tk_messageBox -icon error -type ok -default ok \
                -title "Clock error" -parent [focus] -message $msg                
        } else {
            $opts(dialog) enddialog $opts(index)
        }
    }

}

################################################################################
namespace eval clocks_info {

    variable data_list [list \
        "direction"             "" \
        "data_register_names"   [list] \
        "clock_configuration"   "" \
        "clock_port_name"       "" \
        "clock_tree_names"      [list] \
    ]
    variable shared_data
    variable old_data
    array set shared_data $data_list
    array set old_data $data_list

    variable clock_status
    array set clock_status [list]
    variable old_clock_status
    variable src_tree
    variable dest_tree
    variable data_clock_graph ""
    variable output_clock_graph ""
    variable data_clock_graph_root ""
    variable output_clock_graph_root ""
    variable old_data_clock_graph_root ""
    variable old_output_clock_graph_root ""
    variable instruction_text
    variable output_virtual_overview "The tree below contains virtual clocks\
        that describe the clock driving the destination register in the\
        external device.\n "
    variable input_virtual_overview "The tree below contains virtual clocks\
        that describe the clock driving the source register in the\
        external device.\n "
    variable output_src_overview "The tree below lists all nodes in the\
        clock path to the data output registers.\
        \nIt also shows any clocks that are applied to each node."
    variable output_dest_overview "The tree below lists all nodes in the\
        clock path to the output clock port.\
        \nIt also shows any clocks that are applied to each node."
    variable input_overview "The tree below lists all nodes in the\
        clock path to the data input registers.\
        \nIt also shows any clocks that are applied to each node."
    variable images
    array set images [list]
    variable clock_settings_changed     ""
    
    #############################################
    #
    proc create_images { args } {

        variable images
        set icon_data(question) {R0lGODlhEAAQALMAAAAAAIAAAACAAICAAAAAgIAAgACAgPfdh4CAgP8AAAD/
            AAAA//XBDP8A/wD///79+yH5BAAAAAAALAAAAAAQABAAgwAAAIAAAACAAICA
            AAAAgIAAgACAgPfdh4CAgP8AAAD/AAAA//XBDP8A/wD///79+wQn8MlJq734
            sL2x5KAHhhhzPODpoZyape/oae1KM+tE5yzOkzkOLxcBADs=}
        set icon_data(check) {R0lGODlhEAAQALMAAAAAAIAAAACAAICAAAAAgIAAgACAgMDAwICAgP8AAAD/
            AAAA////AP8A/wD//////yH5BAAAAAAALAAAAAAQABAAgwAAAIAAAACAAICA
            AAAAgIAAgACAgMDAwICAgP8AAAD/AAAA////AP8A/wD//////wQj8MlJq704
            P6WpEp30hRsYjhYqmpXimi/mfnE2q3bd4WTvaxEAOw==}
        
        foreach ibuild [lsort -dictionary [array names icon_data]] {
        
            # This is two steps due to this suggestion:
            # http://wiki.tcl.tk/643
            set images($ibuild) [image create photo]
            $images($ibuild) put $icon_data($ibuild)
        }
    }
    
    #############################################
    # Put together the source/dest clock path tab
    proc assemble_tab { args } {
    
        set options {
            { "frame.arg" "" "Frame to assemble the tab on" }
            { "text.arg" "" "TitleFrame text" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable instruction_text
        variable images
        
        # Don't pack this frame, because it comes from a getframe
        set f $opts(frame)

        set clock_tf [TitleFrame $f.clocks -text $opts(text) -ipad 8]
        set sub_f [$clock_tf getframe]
        
        # Brief instructions
        grid [label $sub_f.text -textvariable \
            [namespace which -variable instruction_text] -justify left] \
            -sticky w
        
        # Frame to hold checkmark icon key
        set ssub_f [frame $sub_f.fc]
        pack [label $ssub_f.i -image $images(check)] -side left
        pack [label $ssub_f.l -text "indicates a valid clock constraint."] \
            -side left
        grid $ssub_f -sticky ew
        
        # Frame to hold question mark icon key
        set ssub_f [frame $sub_f.fq]
        pack [label $ssub_f.i -image $images(question)] -side left
        pack [label $ssub_f.l -text "indicates that review or editing is required."] \
            -side left
        grid $ssub_f -sticky ew
        
        # Brief instructions
        grid [label $sub_f.l0 -text "Double-click to create any required clocks\
            indicated in the tree below"] \
            -sticky w
        grid [label $sub_f.l1 -text "Double-click to edit or review any clocks\
            shown with a question mark so they become valid."] \
            -sticky w
            
        # Separator line
        grid [Separator $sub_f.sep -relief groove] -sticky ew -pady 5
        
        # Scrolled window and tree to hold clock path nodes
        set cp_sw [ScrolledWindow $sub_f.sw -auto both]
        set cp_tr [Tree $cp_sw.tr -deltay 16 -height 16]
        $cp_sw setwidget $cp_tr
        grid $cp_sw -sticky news
        
        # Expand on resize
        grid rowconfigure $sub_f 6 -weight 1
        grid columnconfigure $sub_f 0 -weight 1
        
        pack $clock_tf -side top -anchor n -fill both -expand true

        $cp_tr bindText <Double-1> "+ [namespace code on_clock_path] \
            -widget $cp_tr -sel"
        $cp_tr bindImage <Double-1> "+ [namespace code on_clock_path] \
            -widget $cp_tr -sel"
        
        return $cp_tr
    }    

    ########################################
    # Assemble the source clock path tab
    proc assemble_src_tab { args } {
    
        set options {
            { "frame.arg" "" "Frame to assemble the tab on" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable src_tree

        set src_tree [assemble_tab -frame $opts(frame) \
            -text "Source clock path"]
    }
    
    ########################################
    # Assemble the destination clock path tab
    proc assemble_dest_tab { args } {
    
        set options {
            { "frame.arg" "" "Frame to assemble the tab on" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable dest_tree

        set dest_tree [assemble_tab -frame $opts(frame) \
            -text "Destination clock path"]
    }

    #####################################
    # Transfer information in for the clock
    # path graphs
#            { "register_id.arg" "" "Update the register ID" }
#            { "clock_port_id.arg" "" "Clock port ID" }
    proc init_clocks_info { args } {

        log::log_message "Calling init_clocks_info $args"
        set options {
            { "data.arg" "" "Flat array with stuff to init" }
            { "update_direction.arg" "" "Update the direction" }
            { "data_register_names.arg" "" "Update the data register names" }
            { "clock_port_name.arg" "" "Clock port name" }
            { "update_clock_port_name" "Update the clock port name" }
            { "clock_configuration.arg" "" "Interface clock configuration" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data
        variable data_clock_graph_root
        variable output_clock_graph_root
        variable old_data
        variable old_clock_status
        variable old_data_clock_graph_root
        variable old_output_clock_graph_root
        variable data_list
        
        if { 0 < [llength $opts(data)] } {

            array set temp $opts(data)
            
            foreach k [array names shared_data] {
                set shared_data($k) $temp($k)
                unset temp($k)
            }

            if { 0 < [array size temp] } {
                post_message -type warning "More data than expected when\
                    initializing clocks_info: [array names temp]"
            }
            
            # Handle the clock port name, if there is one (if it's not blank)
            if { ![string equal "" $shared_data(clock_port_name)] } {
                foreach_in_collection output_clock_graph_root \
                    [get_ports $shared_data(clock_port_name)] { break }
            } else {
                set output_clock_graph_root ""
            }
            
            # Handle the register ID, if there is one (if it's not blank)
            if { 0 < [llength $shared_data(data_register_names)] } {
                # Get the register ID of the first data register name in the list
                foreach_in_collection data_clock_graph_root \
                    [get_registers [lindex $shared_data(data_register_names) 0]] \
                    { break }
            } else {
                set data_clock_graph_root ""
            }
            
            # When we pass in the first batch of data from the data file,
            # say the clock settings have changed.
            clock_settings_change_flag -set
            
            # Clear out the old data
            array unset old_data
#            array set old_data $data_list
            array set old_data [array get shared_data]
            array unset old_clock_status
            set old_data_clock_graph_root ""
            set old_output_clock_graph_root ""
#            set old_data_clock_graph_root $data_clock_graph_root
#            set old_output_clock_graph_root $output_clock_graph_root
            
        }
        
        # Set shared_data if update_direction is input or output.
        # Warn otherwise if not blank
        switch -exact -- $opts(update_direction) {
            "input" -
            "output" { set shared_data(direction) $opts(update_direction) }
            "" { }
            default {
                return -code error "Unknown value for update_direction in\
                    init_clocks_info: $opts(update_direction)"
            }
        }
        
        # Handle a change in the register ID, if there is one (if it's not blank)
        if { 0 < [llength $opts(data_register_names)] } {
            # Get the register ID of the first data register name in the list
            foreach_in_collection data_clock_graph_root \
                [get_registers [lindex $opts(data_register_names) 0]] { break }
        }
        
        # Handle a change in the clock port name, if there is one
        if { $opts(update_clock_port_name) } {
            if { [string equal "" $opts(clock_port_name)] } {
                set output_clock_graph_root ""
                set shared_data(clock_port_name) ""
            } else {
                foreach_in_collection output_clock_graph_root \
                    [get_ports $opts(clock_port_name)] { break }
                set shared_data(clock_port_name) $opts(clock_port_name)
            }
        }
        
        switch -exact -- $opts(clock_configuration) {
            "system_sync_common_clock" -
            "system_sync_different_clock" -
            "source_sync_source_clock" -
            "source_sync_dest_clock" {
                set shared_data(clock_configuration) $opts(clock_configuration)
            }
            "" { }
            default {
                return -code error "Unknown value for clock_configuration\
                    in init_clocks_info: $opts(clock_configuration)"
            }
        }
        
        log::log_message "After init_clocks_info call, output_clock_graph_root is $output_clock_graph_root"
    }
    
    ############################################
    proc prep_src_for_raise { args } {
    
        set_src_tree_instructions
    }
    
    ##############################################
    proc prep_dest_for_raise { args } {
    
        set_dest_tree_instructions
    }
    
    ########################################
    # Save the current clock_status values
    proc save_current_clocks_info { args } {
    
        variable clock_status
        variable old_clock_status
        variable data_clock_graph_root
        variable output_clock_graph_root
        variable old_data_clock_graph_root
        variable old_output_clock_graph_root
        variable shared_data
        variable old_data
        
        array unset old_clock_status
        array set old_clock_status [array get clock_status]
        array unset old_data
        array set old_data [array get shared_data]
        set old_data_clock_graph_root $data_clock_graph_root
        set old_output_clock_graph_root $output_clock_graph_root
    }

    ###########################################
    # return 1 if clocks information changed.
    # If the graph roots changed
    # If the appropriate tree is empty
    # If the clock_status array changed
    proc clocks_info_changed { args } {
    
        set options {
            { "src" "Check source tree" }
            { "dest" "Check dest tree" }
            { "root_nodes" "Check graph roots" }
            { "settings" "Clock settings" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        variable src_tree
        variable dest_tree
        variable clock_status
        variable data_clock_graph_root
        variable output_clock_graph_root
        variable old_clock_status
        variable old_data_clock_graph_root
        variable old_output_clock_graph_root
        variable shared_data
        variable old_data
        
        if { $opts(root_nodes) } {
#puts "old data: $old_data_clock_graph_root"
#puts "current data: $data_clock_graph_root"
#puts "old clock: $old_output_clock_graph_root"
#puts "current clock: $output_clock_graph_root"
            return [expr {
                ![string equal $data_clock_graph_root \
                    $old_data_clock_graph_root] || \
                ![string equal $output_clock_graph_root \
                    $old_output_clock_graph_root] } ]

        } elseif { $opts(src) } {

            if { 0 == [llength [$src_tree nodes "root"]] } {
                return 1
            } elseif { ! [util::check_arrays_equal clock_status old_clock_status] } {
                return 1
            } elseif { ! [string equal $old_data(clock_configuration) $shared_data(clock_configuration)] } {
                return 1
            } else {
                return 0
            }

        } elseif { $opts(dest) } {

            if { 0 == [llength [$dest_tree nodes "root"]] } {
                return 1
            } elseif { ! [util::check_arrays_equal clock_status old_clock_status] } {
                return 1
            } elseif { ! [string equal $old_data(clock_configuration) $shared_data(clock_configuration)] } {
                return 1
            } else {
                return 0
            }
        } elseif { $opts(settings) } {
            return [clock_settings_change_flag -query]
        }
    }

    #####################################
    # Make the clock path graphs
    proc init_clock_path_graphs { args } {

        set options {
        }
        array set opts [::cmdline::getoptions args $options]

        variable data_clock_graph
        variable output_clock_graph
        variable data_clock_graph_root
        variable output_clock_graph_root
        variable src_tree
        variable dest_tree
        variable shared_data
        
        # Destroy it, then
        # Create the graph to the data registers for both input and output
        # Clear out the appropriate tree, depending on the direction.
        # source tree always gets cleared out because it does for
        # the output anyway, and for the input, if the data register
        # changed (dest tree), odds are good the clock input port
        # changed too (src tree)

        # Graphs hold the structure of the clocking circuits
        catch { $data_clock_graph destroy }
        catch { $output_clock_graph destroy }

        netlist::create_clock_path_graph -graph_var data_clock_graph \
            -no_clock -root_node $data_clock_graph_root
            
        switch -exact -- $shared_data(direction) {
            "input" {
                if { [string equal "source_sync_dest_clock" $shared_data(clock_configuration)] } {
                    netlist::create_clock_path_graph \
                        -graph_var output_clock_graph \
                        -root_node $output_clock_graph_root
                }
            }
            "output" {
                if { [string equal "source_sync_source_clock" $shared_data(clock_configuration)] } {
                    netlist::create_clock_path_graph \
                        -graph_var output_clock_graph \
                        -root_node $output_clock_graph_root
                }
            }
            default {
                return -code error "Unknown value for direction in\
                    init_clock_path_graphs: $shared_data(direction)"
            }
        }

        # Trees hold the visual representation of the clocks on each node
        # of the clock path
        $dest_tree delete [$dest_tree nodes "root"]
        $src_tree delete [$src_tree nodes "root"]

    }

    ###################################################
    proc init_clock_path_graphs_2 { args } {

        set options {
            { "data_graph" "Init the data clock graph" }
            { "clock_graph" "Init the clock clock graph" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable data_clock_graph
        variable output_clock_graph
        variable data_clock_graph_root
        variable output_clock_graph_root
        variable src_tree
        variable dest_tree
        
        # Destroy it, then
        # Create the graph to the data registers for both input and output
        # Clear out the appropriate tree, depending on the direction.
        # source tree always gets cleared out because it does for
        # the output anyway, and for the input, if the data register
        # changed (dest tree), odds are good the clock input port
        # changed too (src tree)

        # Graphs hold the structure of the clocking circuits

        if { $opts(data_graph) } {
            catch { $data_clock_graph destroy }
            if { ! [string equal "" $data_clock_graph_root] } {
                netlist::create_clock_path_graph -graph_var data_clock_graph \
                    -no_clock -root_node $data_clock_graph_root
            }
        }
        
        if { $opts(clock_graph) } {
            catch { $output_clock_graph destroy }
            if { ! [string equal "" $output_clock_graph_root] } {
                netlist::create_clock_path_graph \
                    -graph_var output_clock_graph \
                    -root_node $output_clock_graph_root
            }
        }

        # Trees hold the visual representation of the clocks on each node
        # of the clock path
#        $dest_tree delete [$dest_tree nodes "root"]
#        $src_tree delete [$src_tree nodes "root"]

    }

    #####################################
    proc set_src_tree_instructions { args } {
    
        variable instruction_text
        variable input_overview
        variable output_src_overview
        variable input_virtual_overview
        variable shared_data
    
        switch -exact -- $shared_data(direction) {
            "output" { set instruction_text $output_src_overview }
            "input" {
            
                switch -exact -- $shared_data(clock_configuration) {
                    "system_sync_common_clock" -
                    "system_sync_different_clock" -
                    "source_sync_source_clock" {
                        set instruction_text $input_virtual_overview
                    }
                    "source_sync_dest_clock" {
                        set instruction_text $input_overview
                    }
                    default {
                        return -code error "Unknown value for clock_configuration in\
                            set_src_tree_instructions: $shared_data(clock_configuration)"
                    }
                }
            }
            default {
                return -code error "Unknown value for direction in\
                    set_src_tree_instructions: $shared_data(direction)"
            }
        }
    }
    
    #####################################
    # Fill the source tree
    # Return 1 if all the clocks in the source tree are valid
    proc fill_src_tree { args } {

        set options {
            { "ignore_incomplete_data" "Don't fill if there's not enough data" }
        }
        array set opts [::cmdline::getoptions args $options]
        variable data_clock_graph
        variable output_clock_graph
        variable data_clock_graph_root
        variable output_clock_graph_root
        variable src_tree
        variable clock_status
        variable images
        variable shared_data
        
        # Clear out the clock path tree
        $src_tree delete [$src_tree nodes "root"]

        set widget_index 0

        switch -exact -- $shared_data(direction) {
            "output" {
            
                set num_nodes [llength [$data_clock_graph nodes]]
                if { $opts(ignore_incomplete_data) } {
                    if { 0 == $num_nodes } { return 0 }
                } else {
                    if { 0 == $num_nodes } {
                        return -code error "No nodes in data path clock graph\
                            for source tree"
                    }
                }
                
                netlist::reset_clock_path_graph -graph_var data_clock_graph
                # Add information for the clock leaves
                $data_clock_graph walk $data_clock_graph_root -order post \
                    -type dfs -dir backward \
                    -command [list netlist::insert_clock_leaves widget_index]
                # Put the nodes into the clock path tree
                $data_clock_graph walk $data_clock_graph_root -order post \
                    -type dfs -dir backward \
                    -command [list netlist::populate_gui_clock_path $src_tree "root" clock_status]
                }
            "input" {
            
                switch -exact -- $shared_data(clock_configuration) {
                "system_sync_common_clock" -
                "system_sync_different_clock" -
                "source_sync_source_clock" {
                    set temp [fill_with_virtuals -tree $src_tree]
                }
                "source_sync_dest_clock" {

                    set num_nodes [llength [$output_clock_graph nodes]]
                    if { $opts(ignore_incomplete_data) } {
                        if { 0 == $num_nodes } { return 0 }
                    } else {
                        if { 0 == $num_nodes } {
                            return -code error "No nodes in output path clock graph\
                                for source tree"
                        }
                    }
                
                    netlist::reset_clock_path_graph -graph_var output_clock_graph
                    # Add information for the clock leaves
                    $output_clock_graph walk $output_clock_graph_root -order post \
                        -type dfs -dir backward \
                        -command [list netlist::insert_clock_leaves widget_index]
                    # Put the nodes into the clock path tree
                    $output_clock_graph walk $output_clock_graph_root -order post \
                        -type dfs -dir backward \
                        -command [list netlist::populate_gui_clock_path $src_tree "root" clock_status]
                }
                default {
                    if { $opts(ignore_incomplete_data) } {
                        return 0
                    } else {
                        return -code error "Unknown value for clock_configuration in\
                            fill_src_tree: $shared_data(clock_configuration)"
                    }
                }
                }
            }
            default {
                if { $opts(ignore_incomplete_data) } {
                    return 0
                } else {
                    return -code error "Unknown value for direction in\
                        fill_src_tree: $shared_data(direction)"
                }
            }
        }
        
        # Put in the check marks/question marks
        set num_question 0
        foreach c [array names clock_status] {
            if { ! [$src_tree exists $c] } { continue }
            if { $clock_status($c) } {
                $src_tree itemconfigure $c -image $images(check)
            } else {
                incr num_question
                $src_tree itemconfigure $c -image $images(question)
            }
        }

        # I want to return 1 if every clock is valid
        return [expr { 0 == $num_question }]
    }

    ###########################################
    # Fill the specified tree with virtual clocks
    proc fill_with_virtuals { args } {
    
        set options {
            { "tree.arg" "" "Tree that gets the virtual clocks put in it" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable clock_status
        variable images
        
        # Return a list of the virtual clock names put in the tree
        set to_return [list]
        
        # The source clocks for input side are virtual clocks.
        # Populate the tree with virtual clocks.
        # No virtual clock will ever be auto-generated, so they
        # are either from the SDC, or entered interactively by the
        # user. Even if a virtual clock exists that is not from the SDC,
        # (i.e. entered interactively), always add an option to
        #  "Click to create a virtual clock" option. It might be
        # necessary in a multi-frequency interface

        # Put in the "click to make a virtual clock" entry
        # Don't show an image next to this entry, and don't track its
        # status as verified or unverified
#        set clock_status(create) 0
        $opts(tree) insert end "root" "create" -text \
            "<Double-click to create a virtual clock>" \
            -data [list "clock_type" "virtual" "placeholder" 1 \
            "clock_info" {} "target_id" "" ]; # -image $images(question)
    
        # Get the virtual clock names so they can be sorted alphabetically
        array set virtual_name_to_id [list]
        foreach_in_collection clock_id [all_clocks] {
            set targets_collection [get_clock_info -targets $clock_id]
            if { [catch { get_collection_size $targets_collection } res] } {
                # If there was an error, there was no collection, so there
                # were no targets, so it is virtual.
                set name [get_clock_info -name $clock_id]
                set virtual_name_to_id($name) $clock_id
            } elseif { 0 == $res } {
                # If the size is 0, there were no targets, so it is virtual
                set name [get_clock_info -name $clock_id]
                set virtual_name_to_id($name) $clock_id
            } else {
                # There is at least one target, so it is not virtual.
            }
        }

        # Put the virtual clocks in the list alphabetically
        foreach name [lsort -dictionary [array names virtual_name_to_id]] {

            # Skip the one used by this script to make sure everything
            # is constrained
            if { [project_info::is_clock_created_by -default_virtual \
                -clock_name $name] } { continue }

            array unset data
            array set data [list "clock_type" "virtual" "target_id" ""]

            # If we've seen this clock already, and it has been validated,
            # what is its information and how do we show it?        
            if { [info exists clock_status($virtual_name_to_id($name))] && $clock_status($virtual_name_to_id($name)) } {

                # If we have seen the clock already, and it is validated,
                # it means we are coming back here.
                # We would not be coming back here still needing to
                # create the virtual clock for the interface
                set data(placeholder) 0
    
            } elseif { ! [project_info::is_clock_created_by -file_defined \
                -clock_name $name] } {
                # If the clock ID does not exist in the list of SDC
                # defined clocks, it was added interactively.
                set data(placeholder) 1
                set clock_status($virtual_name_to_id($name)) 0
            } else {

                # It does exist in the list of SDC defined clocks, so it is
                # valid.
                set data(placeholder) 0
                set clock_status($virtual_name_to_id($name)) 1
            }

            array unset clock_info
            array set clock_info [util::remove_clock_default_values \
                -clock_id $virtual_name_to_id($name) -type "virtual"]
            set data(clock_info) [array get clock_info]

            $opts(tree) insert end "root" $virtual_name_to_id($name) \
                -text $name -data [array get data] -image $images(check)
                
            lappend to_return $name
        }
    
        return $to_return
    }
    
    #####################################
    proc set_dest_tree_instructions { args } {
    
        variable instruction_text
        variable input_overview
        variable output_virtual_overview
        variable output_dest_overview
        variable shared_data
    
        switch -exact -- $shared_data(direction) {
            "input" { set instruction_text $input_overview }
            "output" {

                switch -exact -- $shared_data(clock_configuration) {
                    "system_sync_common_clock" -
                    "system_sync_different_clock" -
                    "source_sync_dest_clock" {
                        set instruction_text $output_virtual_overview
                    }
                    "source_sync_source_clock" {
                        set instruction_text $output_dest_overview
                    }
                    default {
                        return -code error "Unknown value for clock_configuration in\
                            set_dest_tree_instructions: $shared_data(clock_configuration)"
                    }
                }
            }
            default {
                return -code error "Unknown value for direction in\
                    set_dest_tree_instructions: $shared_data(direction)"
            }
        }
    }
    
    #####################################
    # Fill the destination tree
    proc fill_dest_tree { args } {
    
        set options {
            { "ignore_incomplete_data" "Don't fill if there's not enough data" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable data_clock_graph
        variable output_clock_graph
        variable data_clock_graph_root
        variable output_clock_graph_root
        variable dest_tree
        variable clock_status
        variable images
        variable shared_data

        # Clear out the clock path tree
        $dest_tree delete [$dest_tree nodes "root"]

        set widget_index 0

        switch -exact -- $shared_data(direction) {
            "input" {

                set num_nodes [llength [$data_clock_graph nodes]]
                if { $opts(ignore_incomplete_data) } {
                    if { 0 == $num_nodes } { return 0 }
                } else {
                    if { 0 == $num_nodes } {
                        return -code error "No nodes in data path clock graph\
                            for dest tree"
                    }
                }
                
                netlist::reset_clock_path_graph -graph_var data_clock_graph
                # Add information for the clock leaves
                $data_clock_graph walk $data_clock_graph_root -order post \
                    -type dfs -dir backward \
                    -command [list netlist::insert_clock_leaves widget_index]
                # Put the nodes into the clock path tree
                $data_clock_graph walk $data_clock_graph_root -order post \
                    -type dfs -dir backward \
                    -command [list netlist::populate_gui_clock_path $dest_tree "root" clock_status]
            }
            "output" {

                switch -exact -- $shared_data(clock_configuration) {
                "system_sync_common_clock" -
                "system_sync_different_clock" -
                "source_sync_dest_clock" {
                    set temp [fill_with_virtuals -tree $dest_tree]
                }
                "source_sync_source_clock" {

                    set num_nodes [llength [$output_clock_graph nodes]]
                    if { $opts(ignore_incomplete_data) } {
                        if { 0 == $num_nodes } { return 0 }
                    } else {
                        if { 0 == $num_nodes } {
                            return -code error "No nodes in output path clock graph\
                                for dest tree"
                        }
                    }
                
                    netlist::reset_clock_path_graph -graph_var output_clock_graph
                    # Add information for the clock leaves
                    $output_clock_graph walk $output_clock_graph_root -order post \
                        -type dfs -dir backward \
                        -command [list netlist::insert_clock_leaves widget_index]
                    # Put the nodes into the clock path tree
                    $output_clock_graph walk $output_clock_graph_root -order post \
                        -type dfs -dir backward \
                        -command [list netlist::populate_gui_clock_path $dest_tree "root" clock_status]
                }
                default {
                    if { $opts(ignore_incomplete_data) } {
                        return 0
                    } else {
                        return -code error "Unknown value for clock_configuration in\
                            fill_dest_tree: $shared_data(clock_configuration)"
                    }
                }
                }
            }
            default {
                if { $opts(ignore_incomplete_data) } {
                    return 0
                } else {
                    return -code error "Unknown value for direction in\
                        fill_dest_tree: $shared_data(direction)"
                }
            }
        }

        # Put in the check marks/question marks
        set num_question 0
        foreach c [array names clock_status] {
            if { ! [$dest_tree exists $c] } { continue }
            if { $clock_status($c) } {
                $dest_tree itemconfigure $c -image $images(check)
            } else {
                incr num_question
                $dest_tree itemconfigure $c -image $images(question)
            }
        }

        # I want to return 1 if every clock is valid
        return [expr { 0 == $num_question }]
    }

    #####################################
    # Handle double-clicks on the clock
    # path tree
    proc on_clock_path { args } {
    
        set options {
            { "widget.arg" "" "Tree that was double-clicked" }
            { "sel.arg" "" "Node in the tree that was clicked on" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable clock_status
        variable images
        variable shared_data
        
        # This is what was clicked on
        set sel [lindex $opts(sel) 0]

        # If the item is not selectable, return
        if { ! [$opts(widget) itemcget $sel -selectable] } {
            return
        }

        # Save the info for restore_info
        # Call show_dialog
        foreach { cancelled had_error } \
            [clock_entry::show_dialog -widget $opts(widget) -node_id $sel \
                -new_clock_id_var new_clock_id -clock_port_name \
                $shared_data(clock_port_name)] { break }
        
        # If there was no error, run update_clocks
        # If there was an error, process the restore info,
        #  and invalidate and disable fed clocks
        if { $cancelled && $had_error } {

            # The user hit Cancel
            # The old clock no longer exists, so it has no status
            # Even though the replacement was successful, consider it
            # unverified, so the user has to review it.
            unset clock_status($sel)
            set clock_status($new_clock_id) 0
            $opts(widget) itemconfigure $new_clock_id -image $images(question)

            # If there are clocks that depend on the one in an error
            # state, those must be unvalidated and disabled.
            # Now walk through all the clocks with the original node ID as
            # their master clock ID and update to point to the replacement
            # and invalidate them too.
            foreach c [get_clocks_with_this_master_id \
                -clock_tree $opts(widget) -clock_id $sel] {

                # Put in the new master_clock_id
                # Also put its name into clock_info
                array unset temp_node_data
                array unset temp_clock_info
                array set temp_node_data [$opts(widget) itemcget $c -data]
                array set temp_clock_info $temp_node_data(clock_info)
                set temp_node_data(master_clock_id) $new_clock_id
                set temp_clock_info(master_clock) [get_clock_info -name $new_clock_id]
                set temp_node_data(clock_info) [array get temp_clock_info]
                $opts(widget) itemconfigure $c -data [array get temp_node_data]

                # Invalidate the node
                set clock_status($c) 0
                $opts(widget) itemconfigure $c -image $images(question)

                # If it was enabled, disable it.
                if { [$opts(widget) itemcget $c -selectable] } {
                    $opts(widget) itemconfigure $c -selectable 0
                    $opts(widget) itemconfigure $c -fill "grey50"
                }
            }

        } elseif { ! $cancelled } {

            # The user hit OK
            # The old clock no longer exists, so it has no status
            # Consider the new one verified, and show it as checked.
            if { ![string equal "create" $sel] } {
                unset clock_status($sel)
            }
            set clock_status($new_clock_id) 1
            $opts(widget) itemconfigure $new_clock_id -image $images(check)

            update_clocks \
                -replacement_pair [list $sel $new_clock_id] \
                -widget $opts(widget) \
                -known_clocks [util::collection_to_list [all_clocks]]
            
            clock_settings_change_flag -set
        }
    }

    ################################################################################
    # Remove existing clock
    # Create new one
    # Update the GUI tree
    proc update_clock_in_tree { args } {
    
        log::log_message "Calling update_clock_in_tree $args"
        
        set options {
            { "widget.arg" "" "Widget that holds the clock path tree" }
            { "node_id.arg" "" "Selected clock path node" }
            { "clock_info.arg" "" "" }
            { "clock_type.arg" "" "" }
            { "skip_remove" "Don't attempt to run remove_clock" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        array set node_data [$opts(widget) itemcget $opts(node_id) -data]
        array set clock_info $opts(clock_info)

        # Remove an existing clock
        if { ! $node_data(placeholder) && ! $opts(skip_remove) } {
            log::log_message " remove_clock [get_clock_info -name $opts(node_id)]"
            if { [catch { remove_clock [get_clock_info -name $opts(node_id)] } res] } {
                log::log_message $res
            }
        }

        # Create a new clock
        switch -exact -- $opts(clock_type) {
            "virtual" {
                set target_type ""
            }
            "base" -
            "generated" {
                set target_type [get_node_info -type $node_data(target_id)]
            }
            default {
                return -code error "Unknown value for clock_type in\
                    update_clock_in_tree: $opts(clock_type)"
            }
        }
        set command [make_clock_command_string \
            -clock_info $opts(clock_info) \
            -clock_type $opts(clock_type) \
            -target_type $target_type]
    
        # If there's an error creating the clock, return the error
        # Otherwise update the GUI and return the new clock ID
        if { [catch { eval $command } res] } {
            return -code error $res
        } else {
            # Update the GUI tree
            set node_data(placeholder) 0
            set node_data(clock_info) \
                [remove_empty_clock_options -data $opts(clock_info) \
                -type $opts(clock_type)]
            set new_clock_id [util::get_clock_id -clock_name $clock_info(name)]
            set new_text $clock_info(name)
            set insertion_index [$opts(widget) index $opts(node_id)]
            set parent [$opts(widget) parent $opts(node_id)]
            
            # Don't replace the tree entry to create a virtual clock
            if { [string equal "create" $opts(node_id)] } {
                set insertion_index "end"
                $opts(widget) selection clear
            } else {
                $opts(widget) delete $opts(node_id)
            }
            
            $opts(widget) insert $insertion_index $parent \
                $new_clock_id -text $new_text -data [array get node_data]
    
            log::log_message " Saving the following data from $opts(node_id)\
                to $new_clock_id"
            log::log_message " [array get node_data]"
    
            return $new_clock_id
        }
    }

    ############################################
    # Pass in a list of data (a flattened array)
    # This strips out anything that's not set
    proc remove_empty_clock_options { args } {
    
        set options {
            { "data.arg" "" "Data string to work on" }
            { "type.arg" "" "base, generated, or virtual" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        array set clock_info $opts(data)
    
        # Walk through all items in the clock_info array.
        # Some values don't have to be saved at all
        # Some don't have to be saved if the field is blank
        # clock_info shouldn't have source_id any more
#                "source_id" -
#                "source" -
#                "targets" -
#                "target_id" -
#                "master_clock" 
        foreach item [array names clock_info] {
    
            switch -exact -- $item {
                "type" { unset clock_info($item) }
                "invert" -
                "based_on" {
                    if { ! [string equal "generated" $opts(type)] } {
                        unset clock_info($item)
                    }
                }
                default {
                    if { [string equal "" $clock_info($item)] } {
                        unset clock_info($item)
                    }
                }
            }
        }
        return [array get clock_info]
    }

    ################################################################################
    # put on queue pair of old id and replacement id (1)
    # while queue (2)
    #  get pair (3)
    #  foreach clock with master clock id == old id (4)
    #   if there is a newly valid clock to use instead (5)
    #    push on queue pair of clock and newly valid clock (6)
    #    replace in tree clock with newly valid clock (7)
    #   copy over the node data, including updated master clock id (8)
    proc update_clocks { args } {
    
        log::log_message "Calling update_clocks $args"
        
        set options {
            { "replacement_pair.arg" "" "" }
            { "widget.arg" "" "Clock tree path to look in" }
            { "known_clocks.arg" "" "Clock IDs before updating starts" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        variable images
        variable clock_status

        set known_clocks $opts(known_clocks)
    
        set queue [::struct::queue]
    
        # (1)
        $queue put $opts(replacement_pair)
    
        # (2)
        while { 0 < [$queue size] } {
    
            # (3)
            # old_id and new_id are the IDs of master clocks
            foreach { old_id new_id } [$queue get] { break }
            log::log_message "In update_clocks, processing $old_id -> $new_id"
    
            # I believe that if the old and new IDs are the same,
            # nothing has to be redone. Old and new IDs will be the 
            # same if the name of the clock stayed the same
            # new_id and old_id are the same, but slave clock must be reenabled,
            # but not redone.
    #        if { [string equal $old_id $new_id] } { continue }
    
            # (4)
            foreach slave_id [get_clocks_with_this_master_id \
                -clock_tree $opts(widget) -clock_id $old_id] {

                log::log_message " $slave_id has $old_id as its master clock"
                # Get clock data for the clock we're checking. It will need
                # its master clock ID updated at the least. It might get
                # completely replaced.
                array unset temp_node_data
                array set temp_node_data [$opts(widget) itemcget $slave_id -data]
    
                # The new master clock ID is always new_id, regardless of whether
                # or not the node it feeds ($slave_id) gets replaced
                set temp_node_data(master_clock_id) $new_id
    
                # See if there's a newly valid clock that should be
                # put in place of $slave_id
                set replacement_clock_id [newly_valid_clock_replacement \
                    -known_clocks $known_clocks \
                    -clock_id $slave_id -node_data [array get temp_node_data]]
    
                # (5)
                # There's a new valid clock if we haven't returned
                # the same id value
                if { ! [string equal $slave_id $replacement_clock_id] } {
                    log::log_message " will replace $slave_id with newly valid\
                        $replacement_clock_id"
                    # Need to know about the one we're swapping in.
                    lappend known_clocks $replacement_clock_id
    
                    # (6)
                    $queue put [list $slave_id $replacement_clock_id]
    
                    # Get the clock info to put in
                    array set clock_info [util::remove_clock_default_values \
                        -clock_id $replacement_clock_id \
                        -type "generated" ]
                    set clock_info(source) [get_node_info -name $temp_node_data(source_id)]
                    set clock_info(master_clock) [get_clock_info -name $temp_node_data(master_clock_id)]
                    set clock_info(targets) [get_node_info -name $temp_node_data(target_id)]
                    
                    set temp_node_data(clock_info) [array get clock_info]
    #                set temp_node_data(clock_info) [util::remove_clock_default_values \
    #                    -clock_id $replacement_clock_id \
    #                    -type "generated" ]
    
                    if { [catch { remove_clock $clock_info(name) } res] } {
                        log::log_message $res
                    }
                    if { [catch { eval [make_clock_command_string \
                        -clock_info [array get clock_info] \
                        -clock_type $temp_node_data(clock_type)] \
                        -target_type [get_node_info -type $temp_node_data(target_id)]} res] } {
                        return -code error "Error recreating clock. Quit and restart the script.\
                            \n$res"
                    }
                    # (7)
                    # Update the GUI tree
                    set insertion_index [$opts(widget) index $slave_id]
                    set parent [$opts(widget) parent $slave_id]
                    $opts(widget) delete $slave_id
                    $opts(widget) insert $insertion_index $parent \
                        $replacement_clock_id \
                        -text [get_clock_info -name $replacement_clock_id] \
                        -image $images(question)
    
                    # Replaced one now has no status, new one must be verified
                    unset clock_status($slave_id)
                    set clock_status($replacement_clock_id) 0
                    set config_id $replacement_clock_id
    
                } elseif { ![string equal $old_id $new_id] } {
                    # This else clause used to have  && ! $temp_node_data(placeholder) in the
                    # condition. In fact, the master clock name has to be updated for
                    # placeholders too. Remove existing clock and put on the new one
                    # only if this is not a placeholder
                    
                    log::log_message " updating clock definition on $slave_id\
                        to account for changed master clock"
                    # Remove the existing slave clock if it's not a placeholder
                    # Make a new one based on the now up-to-date temp_node_data
                    # The clock ID doesn't change because the slave name is not
                    # changing.
                    array unset clock_info
                    array set clock_info $temp_node_data(clock_info)
                    set clock_info(master_clock) [get_clock_info -name $temp_node_data(master_clock_id)]
    
                    set temp_node_data(clock_info) [array get clock_info]
                    
                    if { ! $temp_node_data(placeholder) } {
                        if { [catch { remove_clock $clock_info(name) } res] } {
                            log::log_message $res
                        }
                        if { [catch { eval [make_clock_command_string \
                            -clock_info [array get clock_info] \
                            -clock_type $temp_node_data(clock_type) \
                            -target_type [get_node_info -type $temp_node_data(target_id)]] } res] } {
                            return -code error "Error recreating clock. Quit and restart the script.\
                                \n$res"
                        }
                    }
                    set config_id $slave_id
                } else {
                    set config_id $slave_id
                }
                
                # (8)
                $opts(widget) itemconfigure $config_id -data [array get temp_node_data]
                if { $clock_status($new_id) && ! [$opts(widget) itemcget $config_id -selectable] } {
                    $opts(widget) itemconfigure $config_id -selectable 1
                    $opts(widget) itemconfigure $config_id -fill "black"
                }
           }
        }
        $queue destroy
        
#        return [array get clock_status]
    }

    ################################################################################
    # Is there a clock that applies here that just became valid?
    # Return a clock ID
    # If the clock ID that is returned is the same as the one that was passed in,
    # then no newly valid clock replaces it. If the clock ID that is returned
    # is different than the one that was passed in, then the returned clock ID
    # is a newly valid clock that replaces what was passed in.
    proc newly_valid_clock_replacement { args } {
    
        log::log_message "Calling newly_valid_clock_replacement $args"
        
        set options {
            { "known_clocks.arg" "" "List of clock IDs" }
            { "clock_id.arg" "" "Clock that gets its master replaced" }
            { "node_data.arg" "" "Data for the clock that gets its master replaced" }
        }
        array set opts [::cmdline::getoptions args $options]
    #        { "new_clock_id.arg" "" "Clock that just got created" }
    
        # Data for the clock that has a master clock that will
        # be replaced by new_clock_id
        array set node_data $opts(node_data)
        set master_clock_name [get_clock_info -name $node_data(master_clock_id)]
        set clock_source_name [get_node_info -name $node_data(source_id)]
        set clock_target_name [get_node_info -name $node_data(target_id)]
    
        log::log_message "  checking for new clocks to match $master_clock_name\
            fed by $clock_source_name"
        log::log_message "   target of $clock_target_name"
        # By default, return the same clock ID that was passed in.
        set to_return $opts(clock_id)
    
        # Walk through all the clocks that became valid after the new one
        # was created/replaced
        foreach test_id [util::get_list_elements \
            -from [util::collection_to_list [all_clocks]] \
            -not_in -list $opts(known_clocks)] {
            log::log_message "    $test_id became valid"
            
            # Check the number of targets the newly valid clock has
            set test_target_col [get_clock_info -targets $test_id]
            if { 1 != [get_collection_size $test_target_col] } {
                # It doesn't have exactly one target. Skip it.
                # It could be a virtual clock if it has none.
                # I'm ignoring the fact that it could have more than 1 (unlikely)
                continue
            }
    
            # What are the master name, source name, and target id of the
            # newly valid clock?
            set test_master_name [get_clock_info -master_clock $test_id]
            set test_source_name [get_clock_info -master_clock_pin $test_id]
            foreach_in_collection test_target_id $test_target_col { break }
            set test_target_name [get_node_info -name $test_target_id]
    
            log::log_message "     master name of $test_master_name and source\
                of $test_source_name"
            log::log_message "      target of $test_target_name"
            # If the target ID of the clock with the master ID that has changed
            # matches the target ID of the newly valid clock, and
            # if the name of the newly created clock matches the name of the
            # master clock for a clock that just became valid, and
            # if the source name of the clock with the master ID that has changed
            # matches the source name of a clock that just became valid,
            # we should replace the clock with the master ID that has changed with
            # the clock that just became valid.
            if {[string equal $clock_target_name $test_target_name] && \
                [string equal $master_clock_name $test_master_name] && \
                [string equal $clock_source_name $test_source_name] } {
                set to_return $test_id
            }
        }
        return $to_return
    }

    ################################################################################
    # Returns a list of clocks with the specified master id that are in the
    # specified tree
    proc get_clocks_with_this_master_id { args } {

        set options {
            { "clock_id.arg" "" "ID of clock that's being checked" }
            { "clock_tree.arg" "" "Clock tree to get it from" }
        }
        array set opts [::cmdline::getoptions args $options]

        set to_return [list]
        set queue [::struct::queue]
        foreach c [$opts(clock_tree) nodes "root"] { $queue put $c }

        while { 0 < [$queue size] } {

            set node_id [$queue get]
            array unset node_data
            array set node_data [$opts(clock_tree) itemcget $node_id -data]

            if { ! [info exists node_data(clock_type)] } {

                # If the node we're on is not a clock node, put all its
                # children on the queue, list any clocks on the node
                # (to make any that just became valid appear) and keep going
                catch { get_clocks_on_node -node_id $node_id } res
                foreach c [$opts(clock_tree) nodes $node_id] { $queue put $c }
                continue

            } elseif { [info exists node_data(master_clock_id)] } {

                # If there's a master clock, and it's the item passed in,
                # stick it on the list to return.
                if { [string equal $opts(clock_id) $node_data(master_clock_id)] } {
                    lappend to_return $node_id
                }
            }
        }
        $queue destroy
        return $to_return
    }

    ############################################################################
    # Validate source tree clocks
    # What is considered valid? At least one clock in the list of clocks
    # to return?
    proc validate_src_tree_clocks { args } {
    
        set options {
            { "data_var.arg" "" "Name of the variable to populate with results" }
            { "error_messages_var.arg" "" "Name of the variable to hold error messages" }
            { "pre_validation.arg" "" "How to deal with prevalidation" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable src_tree
        variable data_clock_graph_root
        variable output_clock_graph_root
        variable shared_data
        variable clock_status
        
        # Things are valid or not. If anything is invalid, set to zero.
        set is_valid 1
        
        set src_tree_clocks [list]
        set sub_msg [list]
        
        # We may want to get information back, particularly during the back/next
        # process. If there's no data variable specified, set up a dummy
        # array to hold the results. Else connect the results array to the
        # variable for the data.
        if { [string equal "" $opts(data_var)] } {
            array set results [list]
        } else {
            upvar $opts(data_var) results
        }
        
        # We may want to get error messages back. If we do, hook
        # up the error messages var to the specified variable.
        if { [string equal "" $opts(error_messages_var)] } {
            set error_messages [list]
        } else {
            upvar $opts(error_messages_var) error_messages
        }

        # Do prevalidation if necessary
        switch -exact -- $opts(pre_validation) {
            "skip" { }
            "run_and_return" -
            "return_on_invalid" {
                # Check to make sure required information is here already
                if { [string equal "" $shared_data(clock_configuration)] } {
                    lappend error_messages [list "You must select the clock configuration\
                        this interface uses"]
                    set is_valid 0
                }
                # Check the direction
                switch -exact -- $shared_data(direction) {
                    "output" {
                        # If it's output, the source always feeds a register.
                        if { [string equal "" $data_clock_graph_root] } {
                            lappend error_messages [list "You must choose data ports or a bus to\
                                constrain before you constrain clocks for the source"]
                            set is_valid 0
                        }
                    }
                    "input" {
                        # If it's input, and source_sync_dest_clock, it requires a node
                        if { [string equal "source_sync_dest_clock" $shared_data(clock_configuration)] && \
                            [string equal "" $output_clock_graph_root] } {
                            lappend error_messages [list "You must choose data ports or a bus to\
                                constrain before you constrain clocks for the source"]
                            set is_valid 0
                        }
                    }
                    default {
                        lappend error_messages [list "You must choose data ports or a bus to\
                            constrain before you constrain clocks for the source"]
                        set is_valid 0
                    }
                }
            }
            default {
                return -code error "Unknown option for -pre_validation in\
                    validate_src_tree_clocks: $opts(pre_validation)"
            }
        }
        switch -exact -- $opts(pre_validation) {
            "skip" { }
            "run_and_return" { return $is_valid }
            "return_on_invalid" { if { ! $is_valid } { return $is_valid } }
        }
        # End of pre-validation


        # Source clocks depend on direction. For an output, the source clock
        # is always driving a register. For an input, the source clock
        # is often a virtual clock, but not always.
        switch -exact -- $shared_data(direction) {
            "output" {
                # Source clocks are the clocks on the node before the register.
                # Tree is like this:
                # +-+ clock path node A
                # | + clock name
                # |
                # +-+ clock path node B
                # | + clock name
                # |
                # +-+ register node
                #
                # register_index is the position of "register node" in the tree
                # clock_node_index is the position of "clock path node B" in the tree
                # clock_node_id is the name of the "clock path node B" node in
                # the tree, which is a netlist node ID. 
                set register_index [$src_tree index $data_clock_graph_root]
                set clock_node_index [expr { $register_index - 1 }]
                set clock_node_id [$src_tree nodes \
                    [$src_tree parent $data_clock_graph_root] $clock_node_index]
                    
                # Then get a list of the clocks on that node.
                # Get the list based on what's in the tree, not on all clocks
                # that exist
                foreach clock_id [get_clock_path_clock_ids -no_placeholders \
                    -clock_tree $src_tree -generated -base -validated \
                    -start_at $clock_node_id] {
                    
                    lappend src_tree_clocks [get_clock_info -name $clock_id]
                }
                set sub_msg [list "Review or create the clocks in the clock path"]
            }
            "input" {

                switch -exact -- $shared_data(clock_configuration) {
                    "system_sync_common_clock" -
                    "system_sync_different_clock" -
                    "source_sync_source_clock" {
                        # Get all virtual clocks for the source
                        foreach c [get_clock_path_clock_ids -virtual -validated \
                            -no_placeholders -clock_tree $src_tree] {
                            lappend src_tree_clocks [get_clock_info -name $c]
                        }
                        set sub_msg [list "Create at least one virtual clock."]
                    }
                    "source_sync_dest_clock" {
                        # Source clocks are all clocks on the output clock port
                        # Get the list based only on what's in the tree,
                        # not on all clocks that exist.
                        foreach clock_id [get_clock_path_clock_ids -no_placeholders \
                            -clock_tree $src_tree -generated -validated \
                            -start_at $output_clock_graph_root] {
                            lappend src_tree_clocks [get_clock_info -name $clock_id]
                        }
                        set sub_msg [list "Review or create the clocks in the clock path"]
                    }
                    default {
                        return -code error "Unknown value for clock_configuration in\
                            validate_src_tree_clocks: $shared_data(clock_configuration)"
                    }
                }
                
            }
            default {
                return -code error "Unknown value for direction in\
                    validate_src_tree_clocks: $shared_data(direction)"
            }
        }
    
        # Now Figure out validity, results, and any messages
        if { 0 == [llength $src_tree_clocks] } {
            set is_valid 0
            lappend error_messages [list "No validated clock exists as a\
                source clock." [list $sub_msg]]
        } else {
            array set results [list "src_clocks" $src_tree_clocks]
        }
        
        return $is_valid
    }
    
    ############################################################################
    # Validate dest tree clocks
    # What is considered valid? At least one clock in the list of clocks
    # to return?
    proc validate_dest_tree_clocks { args } {
    
        set options {
            { "data_var.arg" "" "Name of the variable to populate with results" }
            { "error_messages_var.arg" "" "Name of the variable to hold error messages" }
            { "pre_validation.arg" "" "How to deal with prevalidation" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable dest_tree
        variable data_clock_graph_root
        variable output_clock_graph_root
        variable shared_data

        # Things are valid or not. If anything is invalid, set to zero.
        set is_valid 1
        
        set dest_tree_clocks [list]
        set sub_msg [list]
        
        # We may want to get information back, particularly during the back/next
        # process. If there's no data variable specified, set up a dummy
        # array to hold the results. Else connect the results array to the
        # variable for the data.
        if { [string equal "" $opts(data_var)] } {
            array set results [list]
        } else {
            upvar $opts(data_var) results
        }
        
        # We may want to get error messages back. If we do, hook
        # up the error messages var to the specified variable.
        if { [string equal "" $opts(error_messages_var)] } {
            set error_messages [list]
        } else {
            upvar $opts(error_messages_var) error_messages
        }

        # Do prevalidation if necessary
        switch -exact -- $opts(pre_validation) {
            "skip" { }
            "run_and_return" -
            "return_on_invalid" {
                # Check to make sure required information is here already
                if { [string equal "" $shared_data(clock_configuration)] } {
                    lappend error_messages [list "You must select the clock configuration\
                        this interface uses"]
                    set is_valid 0
                }
                # Check the direction
                switch -exact -- $shared_data(direction) {
                    "input" {
                        # If it's input, the dest always feeds a register.
                        if { [string equal "" $data_clock_graph_root] } {
                            lappend error_messages [list "You must choose data ports or a bus to\
                                constrain before you constrain clocks for the destination"]
                            set is_valid 0
                        }
                    }
                    "input" {
                        # If it's input, and source_sync_source_clock, it requires a node
                        if { [string equal "source_sync_source_clock" $shared_data(clock_configuration)] && \
                            [string equal "" $output_clock_graph_root] } {
                            lappend error_messages [list "You must choose data ports or a bus to\
                                constrain before you constrain clocks for the destination"]
                            set is_valid 0
                        }
                    }
                    default {
                        lappend error_messages [list "You must choose data ports or a bus to\
                            constrain before you constrain clocks for the destination"]
                        set is_valid 0
                    }
                }
            }
            default {
                return -code error "Unknown option for -pre_validation in\
                    validate_dest_tree_clocks: $opts(pre_validation)"
            }
        }
        switch -exact -- $opts(pre_validation) {
            "skip" { }
            "run_and_return" { return $is_valid }
            "return_on_invalid" { if { ! $is_valid } { return $is_valid } }
        }
        # End of pre-validation

        
        # Destination clocks depend on direction. For an input, the dest clock
        # is always driving a register. For an output, the dest clock
        # is often a virtual clock, but not always.
        switch -exact -- $shared_data(direction) {
            "output" {
                # Clocks on the output clock port are the dest clocks                
                switch -exact -- $shared_data(clock_configuration) {
                    "system_sync_common_clock" -
                    "system_sync_different_clock" -
                    "source_sync_dest_clock" {
                        # Get all virtual clocks for the dest
                        foreach c [get_clock_path_clock_ids -virtual -validated \
                            -no_placeholders -clock_tree $dest_tree] {
                            lappend dest_tree_clocks [get_clock_info -name $c]
                        }
                        set sub_msg [list "Create at least one virtual clock."]
                    }
                    "source_sync_source_clock" {
                        # Destination clocks are all clocks on the output clock port
                        # Get the list based only on what's in the tree,
                        # not on all clocks that exist.
                        foreach clock_id [get_clock_path_clock_ids -no_placeholders \
                            -clock_tree $dest_tree -generated -validated \
                            -start_at $output_clock_graph_root] {
                            lappend dest_tree_clocks [get_clock_info -name $clock_id]
                        }
                        set sub_msg [list "Review or create the clocks in the clock path"]

                    }
                    default {
                        return -code error "Unknown value for clock_configuration in\
                            validate_dest_tree_clocks: $shared_data(clock_configuration)"
                    }
                }
            }
            "input" {
                # Dest clocks are the clocks on the node before the register.
                # Tree is like this:
                # +-+ clock path node A
                # | + clock name
                # |
                # +-+ clock path node B
                # | + clock name
                # |
                # +-+ register node
                #
                # register_index is the position of "register node" in the tree
                # clock_node_index is the position of "clock path node B" in the tree
                # clock_node_id is the name of the "clock path node B" node in
                # the tree, which is a netlist node ID. 
                set register_index [$dest_tree index $data_clock_graph_root]
                set clock_node_index [expr { $register_index - 1 }]
                set clock_node_id [$dest_tree nodes \
                    [$dest_tree parent $data_clock_graph_root] $clock_node_index]
                
                # Then get a list of the clocks on that node
                # Get the list based on what's in the tree, not on all clocks
                # that exist
                foreach clock_id [get_clock_path_clock_ids -no_placeholders \
                    -clock_tree $dest_tree -generated -base -validated \
                    -start_at $clock_node_id] {
                    lappend dest_tree_clocks [get_clock_info -name $clock_id]
                }
                set sub_msg [list "Review or create the clocks in the clock path"]
            }
            default {
                return -code error "Unknown value for direction in\
                    validate_dest_tree_clocks: $shared_data(direction)"
            }
        }

        # Now Figure out validity, results, and any messages
        if { 0 == [llength $dest_tree_clocks] } {
            set is_valid 0
            lappend error_messages [list "No validated clock exists as a\
                destination clock." [list $sub_msg]]
        } else {
            array set results [list "dest_clocks" $dest_tree_clocks]
        }
        
        return $is_valid

    }
    
    ################################################################################
    # Return a list of all the clocks matching the specified types from
    # the given tree
    proc get_clock_path_clock_ids { args } {
    
        set options {
            { "no_placeholders" "Don't add any placeholder IDs" }
            { "clock_tree.arg" "" "Clock tree to get the clocks from"}
            { "generated" "Include generated clocks" }
            { "base" "Include base clocks" }
            { "virtual" "Include virtual clocks" }
            { "start_at.arg" "root" "Restrict to nodes below this node" }
            { "validated" "Must be valid by clock_status" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        variable clock_status
        
        set to_return [list]
    
        # If the tree hasn't even been created yet, fail gracefully
        if { 0 == [llength [$opts(clock_tree) nodes "root"]] } {
            return $to_return
        }
        
        # Where do we start in the clock path tree?
        set queue [::struct::queue]
        $queue put $opts(start_at)

        # Go through every node in the clock paths tree
        while { 0 < [$queue size] } {
    
            set node_id [$queue get]
    
            # If the node has children, the node is not a clock node.
            set children [$opts(clock_tree) nodes $node_id]
    
            if { 0 < [llength $children] } {
    
                # Put its children on the queue and keep going.
                foreach child $children { $queue put $child }
    
            } else {
    
                # Get the data on the node
                array unset node_data
                array set node_data [$opts(clock_tree) itemcget $node_id -data]
    
                # If the node does not have a clock_type data, it's not a clock
                if { ! [info exists node_data(clock_type)] } { continue }
    
                # Skip unvalidated clocks if necessary
                if { $opts(validated) && [info exists clock_status($node_id)] && \
                    ! $clock_status($node_id) } { continue }
                
                # Skip placeholders if necessary
                if { $node_data(placeholder) && \
                    $opts(no_placeholders) } { continue }
    
                # The clock_type string tells what kind of clock it is.
                # If that type is a flag to the procedure, append the node_id
                if { $opts($node_data(clock_type)) } {
                    lappend to_return $node_id
                }
            }
        }
        $queue destroy
        return $to_return
    }

    ############################################################################
    # 
    proc get_clock_trees_data { args } {
    
        set options {
            { "data_var.arg" "" "Name of the variable to store the data in" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        variable src_tree
        variable dest_tree
        variable clock_status
        
        log::log_message "Getting clock trees data\n"
        
        upvar $opts(data_var) name_to_data
        
        foreach tree [list $src_tree $dest_tree] {
        
            foreach clock_id [get_clock_path_clock_ids -clock_tree $tree\
                -generated -base -virtual -no_placeholders] {
                
                # If the clock has been validated, save it out
                if { $clock_status($clock_id) } {
                    set clock_name [get_clock_info -name $clock_id]
                    set name_to_data($clock_name) [$tree itemcget $clock_id -data]
                }
            }
        }
    }

    ################################################################################
    proc make_clock_command_string { args } {

        log::log_message "Calling make_clock_command_string $args"

        set options {
            { "clock_info.arg" "" "List with clock info" }
            { "clock_type.arg" "" "base, generated, virtual" }
            { "target_type.arg" "" "Type of the target - pin, port, etc"}
        }
        array set opts [::cmdline::getoptions args $options]
    
        # Set up the array with the clock information
        array set clock_info $opts(clock_info)

        # Set up an array to hold option names and their values
        array set options_values [list]
    
        # The clock name is one of the few things base and generated clocks
        # have in common.
        set options_values(-name) $clock_info(name)
    
        # Get different options depending on whether it's a base clock or
        # generated clock
        switch -exact -- $opts(clock_type) {
        "virtual" -
        "base" {
    
            # Command to create the clock
            set command "create_clock"
    
            # Base and virtual have a period
            set options_values(-period) $clock_info(period)
    
            # Do rising/falling waveform definition
            # If either is not blank, get both of them
            # That way, if only one is populated, there will be an error
            set options_values(-waveform) [list]
            if {([info exists clock_info(wer)] && ![string equal "" $clock_info(wer)])} {
                lappend options_values(-waveform) $clock_info(wer)
            }
            if {([info exists clock_info(wef)] && ![string equal "" $clock_info(wef)])} {
                lappend options_values(-waveform) $clock_info(wef)
            }
            # If we haven't put anything in -waveform, remove it
            if { 0 < [llength $options_values(-waveform)] } {
                set options_values(-waveform) [list $options_values(-waveform)]
            } else {
                unset options_values(-waveform)
            }
        }
        "generated" {
    
            # command to create the clock
            set command "create_generated_clock"
    
            # We may be able to skip a master clock
#            if { [info exists clock_info(master_clock_id)] && \
#                ![string equal "" $clock_info(master_clock_id)] } {
#                set options_values(-master_clock) \
#                    [get_clock_info -name $clock_info(master_clock_id)]
#            }
            if { [info exists clock_info(master_clock)] && \
                ![string equal "" $clock_info(master_clock)] } {
                set options_values(-master_clock) $clock_info(master_clock)
            }
    
            # Source of the generated clock
#            set source_name [get_node_info -name $clock_info(source_id)]
            if { [string equal "" $clock_info(source)] } {
                post_message -type warning "Empty source string when calling\
                    make_clock_command_string with $opts(clock_info)"
            }
            set source_name $clock_info(source)
            set options_values(-source) "\[get_pins $source_name\]"
    
            # A generated clock might be inverted
            if { [info exists clock_info(invert)] } {
                if { $clock_info(invert) } { set options_values(-invert) "" }
            }
            
            # And we require different options if the generated clock is based
            # on frequency or a waveform
            switch -exact -- $clock_info(based_on) {
            "frequency" {
    
                if { [info exists clock_info(divide_by)] && \
                    ![string equal "" $clock_info(divide_by)] } {
                    set options_values(-divide_by) $clock_info(divide_by)
                }
                if { [info exists clock_info(multiply_by)] && \
                    ![string equal "" $clock_info(multiply_by)] } {
                    set options_values(-multiply_by) $clock_info(multiply_by)
                }
                if { [info exists clock_info(duty_cycle)] && \
                    ![string equal "" $clock_info(duty_cycle)] } {
                    set options_values(-duty_cycle) $clock_info(duty_cycle)
                }
                if { [info exists clock_info(phase)] && \
                    ![string equal "" $clock_info(phase)] } {
                    set options_values(-phase) $clock_info(phase)
                }
                if { [info exists clock_info(offset)] && \
                    ![string equal "" $clock_info(offset)] } {
                    set options_values(-offset) $clock_info(offset)
                }
    
            }
            "waveform" {
    
                set edges [list]
                set edge_shift [list]
                foreach e { edge1 edge2 edge3 } {
                    if { [info exists clock_info($e)] && \
                        ![string equal "" $clock_info($e)] } {
                        lappend edges $clock_info($e)
                    }
                }
                set options_values(-edges) [list $edges]
                foreach e { edgeshift1 edgeshift2 edgeshift3 } {
                    if { [info exists clock_info($e)] && \
                        ![string equal "" $clock_info($e)] } {
                        lappend edge_shift $clock_info($e)
                    }
                }
                set options_values(-edge_shift) [list $edge_shift]   
                     
            }
            default {
                return -code error "Bad value for based_on in\
                    make_clock_command_string: $clock_info(based_on)"
            }
            }
        
        }
        default {
            return -code error "Clock type is wrong in make_clock_command_string\
                $opts(clock_type)"
        }
        }

        # Now we have all the options that apply, and their values,
        # in the options_values array.
        # Turn those into a command string, then add on the final
        # stuff for the targets. Using -add is harmless if it's the 
        # only clock on the node (which would be typical), and it 
        # covers the case where there actually are multiple clocks
        # on the node.
        foreach opt [array names options_values] {
            append command " $opt $options_values($opt)"
        }
        append command " -add"
        
        # Get the target string for non-virtual clocks
        # If it's not virtual, put on the targets
#[get_node_info -type $clock_info(target_id)]
        switch -exact -- $opts(clock_type) {
            "base" -
            "generated" {
#                set target_name [get_node_info -name $clock_info(target_id)]
                switch -exact -- $opts(target_type) {
                    "port" { append command " \[get_ports $clock_info(targets)\]" }
                    default { append command " \[get_pins $clock_info(targets)\]" }
                }
            }
            "virtual" { }
            default {
                return -code error "Unknown value for clock_type in\
                    make_clock_command_string: $opts(clock_type)"
            }
        }
    
        log::log_message " Returning $command"
        return $command
    }

    ##########################################
    # Return a list of clock IDs that have the
    # specified node ID as a target
    # Do the matching based on whether node names,
    # not IDs, match
    # node_x can be reg_x, for example, and I
    # don't know how to tell that they're
    # the same apart from names
    proc get_clocks_on_node { args } {

        set options {
            { "node_id.arg" "" "node ID to check for clock existing on" }
            { "base" "Return only base clocks" }
            { "generated" "Return only generated clocks" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        set matching_clock_ids [list]
        set node_name [get_node_info -name $opts(node_id)]
        
        # Always use the most up-to-date clock collection
        set existing_clocks [all_clocks]

        # If for some reason there are no clocks, catch that and return an empty
        # list
        if { [catch {get_collection_size $existing_clocks} res] } {
            return $matching_clock_ids
        } elseif { 0 == $res } {
            return $matching_clock_ids
        }
        # Walk through all clocks that exist in the project
        foreach_in_collection clock_id $existing_clocks {
#post_message "getting master clock for id $clock_id"
            set master_clock_name [get_clock_info -master_clock_pin $clock_id]

            if { [string equal "" $master_clock_name] && $opts(generated) } {
            
                # Use the master clock pin to determine whether the clock
                # is a base clock or not
                # If the master clock name is blank, it's a base clock.
                # If it's a base clock, and we want generated ones, skip to
                # the next clock
                continue
    
            } elseif { ! [string equal "" $master_clock_name] && $opts(base) } {
    
                # If the master clock name is not blank, it's a generated clock.
                # If it's a generated clock, and we want base ones, skip to the
                # next clock.
                continue
            }

            # When we get here, we're guaranteed that the clock_id we're looking
            # at is the type (base or generated) that we want.
            foreach_in_collection target_id [get_clock_info -targets $clock_id] {

                # If the names of the nodes match, keep it.
                set target_name [get_node_info -name $target_id]
    
                if { [string equal $node_name $target_name] } {
                    lappend matching_clock_ids $clock_id
                }
            }
        }
    
        return $matching_clock_ids
    }

    ########################################
    # Find clock relationships
    # Returns a pair of times that are launch and latch for setup or hold
    proc find_clock_relationship_2 { args } {
    
        log::log_message " Calling find_clock_relationship_2 $args"
        
        set options {
            { "src_clock_id.arg" "" "ID of the source clock" }
            { "dest_clock_id.arg" "" "ID of the dest clock" }
            { "launch_edge.arg" "" "rise or fall" }
            { "latch_edge.arg" "" "rise or fall" }
            { "setup" "Find setup relationship" }
            { "hold" "Find hold relationship" }
            { "sigma.arg" "0.015" "15ps sigma" }
            { "dms.arg" "1" "Destination multicycle setup" }
            { "dmh.arg" "0" "Destination multicycle hold" }
            { "sms.arg" "1" "Source multicycle setup" }
            { "smh.arg" "0" "Source multicycle hold" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        # Keep track of the minimum launch/latch difference
        set min_setup_difference 99999999999
        set min_hold_difference 99999999999
        
        # What are the launch and latch times that result in
        # the minimum difference?
        set min_setup_launch_time 0
        set min_setup_latch_time 0
        set min_hold_launch_time 0
        set min_hold_latch_time 0

        # Try to be a little more intelligent about getting hold edges
        # that are all positive. If a hold edge time was negative, replace
        # the edge times if the difference is equal to what it was before,
        # not just greater than the previous value plus sigma. 
        set min_hold_edge_time_was_negative 0
        
        # The period is the adder amount if things have to be shifted
        set src_period [get_clock_info -period $opts(src_clock_id)]
        set dest_period [get_clock_info -period $opts(dest_clock_id)]
        
        # Get the rise and fall edges for each clock
        foreach { src_rise src_fall } [get_clock_info -waveform $opts(src_clock_id)] \
            { break }
        foreach { dest_rise dest_fall } [get_clock_info -waveform $opts(dest_clock_id)] \
            { break }

        # The potential misalignment we'll allow increases as you go out past
        # more and more clock periods
        # Increase sigma during the while loop
        set sigma $opts(sigma)
        set sigma_adder "0.005"
        
if { 0 } {
        # All edges must not be negative.
        # If we're using the source rising edge, make sure it's at least 0. Etc.
        while { [string equal "rise" $opts(launch_edge)] && ($src_rise < 0) } {
            set src_rise [expr { $src_rise + $src_period }]
        }
        while { [string equal "fall" $opts(launch_edge)] && ($src_fall < 0) } {
            set src_fall [expr { $src_fall + $src_period }]
        }
}
        while { [string equal "fall" $opts(launch_edge)] && ($src_fall >= $src_period) } {
            # Back up, because a negatively shifted clock may report
            # its first falling edge as being greater than the period
            set src_fall [expr { $src_fall - $src_period }]
        }
if { 0 } {
        while { [string equal "rise" $opts(latch_edge)] && ($dest_rise < 0) } {
            set dest_rise [expr { $dest_rise + $dest_period }]
        }
        while { [string equal "fall" $opts(latch_edge)] && ($dest_fall < 0) } {
            set dest_fall [expr { $dest_fall + $dest_period }]
        }
}
        while { [string equal "fall" $opts(latch_edge)] && ( $dest_fall >= $dest_period ) } {
            # Back up, because a negatively shifted clock may report
            # its first falling edge as being greater than the period
            set dest_fall [expr { $dest_fall - $dest_period }]
        }

        
        # For any particular rr/rf/fr/ff combination, there is only one
        # launch/latch edge pair.
        switch -exact -- $opts(launch_edge) {
            "rise" { set launch_edge_time $src_rise }
            "fall" { set launch_edge_time $src_fall }
            default { return -code error "Must specify rise or fall for\
                -launch_edge in find_clock_relationship_2"
            }
        }
        switch -exact -- $opts(latch_edge) {
            "rise" { set latch_edge_time $dest_rise }
            "fall" { set latch_edge_time $dest_fall }
            default { return -code error "Must specify rise or fall for\
                -latch_edge in find_clock_relationshp_2"
            }
        }
        
        # What is the offset between the clocks? Pass this into advance_to_next
        # to be able to align clock edges even when they're shifted
        # When two clocks are not shifted at all, offset is 0
        # With two 10ns clocks, dest shifted 90 degrees, offset is 2.5 
        set offset [expr {$latch_edge_time - $launch_edge_time }]
        
        # We have a special case for hold.
        # For hold, it's possible for the launch time to be negative, but
        # for there to be a hold relationship with positive launch and latch times.
        # We need to support that.
        # For any x,y hold transfer, where x and y are one of rise/fall, back up
        # one launch cycle if the x egde time is less than the y edge time.
        # For example, take two aligned waveforms where we want a FR hold relationship.
        # The edges passed in here will be launch > latch, which will cause it to
        # advance to the next edge. In cases where one waveform is a large multiple
        # We can get the first one if we back up the launch time
        # to the previous launch time.
#        if { $opts(hold) } {
#            if { $launch_edge_time > $latch_edge_time } {
#                set launch_edge_time [expr { $launch_edge_time - $src_period }]
#            }
#        }
        
        # When we're here, we have non-negative launch and latch times,
        # we have the correct times for the rise or fall edges selected with
        # the arguments for the procedure. Now we have to find the worst case
        # setup or hold relationships
        
        # If the launch and latch edges are not already valid, make them so
#        if { $latch_edge_time <= $launch_edge_time } { }
        foreach { launch_edge_time latch_edge_time } \
            [advance_to_next_valid_setup_3 -make_valid \
            -src_period $src_period -dest_period $dest_period \
            -launch_edge_time $launch_edge_time \
            -latch_edge_time $latch_edge_time \
            -sigma $sigma -offset $offset] { break }

        
        # We have a valid relationship between launch_edge_time and latch_edge_time
        # Now modify it to handle MCs
        foreach { test_setup_launch_time test_setup_latch_time } \
            [advance_to_next_valid_setup_3 -setup_mc \
            -src_period $src_period -dest_period $dest_period \
            -launch_edge_time $launch_edge_time \
            -latch_edge_time $latch_edge_time \
            -sigma $sigma -offset $offset \
            -sms $opts(sms) -dms $opts(dms) ] { break }
        
        # TODO - here I should move it forward if necessary to handle setup
        # multicycles that push launch or latch times negative
if { 0 } {
        set done [expr { ($test_setup_launch_time >= 0) && ($test_setup_latch_time >= 0) }]
        while { ! $done } {
            foreach { foo_launch foo_latch } \
                [advance_to_next_valid_setup_3 -setup_mc \
                -src_period $src_period -dest_period $dest_period \
                -launch_edge_time $launch_edge_time \
                -latch_edge_time $latch_edge_time \
                -sigma $sigma -offset $offset \
                -sms $opts(sms) -dms $opts(dms) ] { break }
        }
}        
        # Set initial condition. We'll use this to know when to stop - when
        # does the edge difference match the initial edge difference
        # What is the difference in edge times at the beginning?
        # Setup is latch - launch
        # hold is launch - latch
        set initial_edge_difference [expr { $latch_edge_time - $launch_edge_time }]

        # Set the initial setup relationship stuff
        set min_setup_launch_time $test_setup_launch_time
        set min_setup_latch_time $test_setup_latch_time        
        set min_setup_difference [expr { $test_setup_latch_time - $test_setup_launch_time }]
        
#puts "initial setup difference is $min_setup_difference"
#puts "  Starting analysis\n\tLaunch $launch_edge_time and latch $latch_edge_time"
#puts "\tSetup value $min_setup_difference"

        set done 0
        set bigstep 0
        while { ! $done } {

            # We have a valid setup relationship already, because
            # latch > launch.
            
            # What about hold? We also have a valid hold relationship.
            # We have to compute both hold relationships for this setup
            # relationship.
            foreach { next_hold_launch prev_hold_latch } \
                [advance_to_next_valid_setup_3 -prev_next_hold \
                -src_period $src_period -dest_period $dest_period \
                -launch_edge_time $test_setup_launch_time \
                -latch_edge_time $test_setup_latch_time \
                -sigma $sigma -offset $offset ] { break }
            
            # hold is launch - latch, src is launch and dest is latch

            # Hold difference from this launch edge to previous latch
            set hold_difference_1 [expr { $test_setup_launch_time - $prev_hold_latch }]
            # Hold difference from next launch edge to this latch
            set hold_difference_2 [expr { $next_hold_launch - $test_setup_latch_time }]

            log::log_message "  Hold check for $test_setup_launch_time and $test_setup_latch_time"
            log::log_message "   1: launch $test_setup_launch_time latch: $prev_hold_latch"
            log::log_message "      $hold_difference_1"
            log::log_message "   2: launch: $next_hold_launch latch: $test_setup_latch_time"
            log::log_message "      $hold_difference_2"

            # Apply any hold multicycles to the first hold check
            foreach { ht1_launch ht1_latch } \
                [advance_to_next_valid_setup_3 -hold_mc \
                -src_period $src_period -dest_period $dest_period \
                -launch_edge_time $test_setup_launch_time \
                -latch_edge_time $prev_hold_latch \
                -sigma $sigma -offset $offset \
                -smh $opts(smh) -dmh $opts(dmh) ] { break }
                
            # Apply any hold multicycles to the second hold check
            foreach { ht2_launch ht2_latch } \
                [advance_to_next_valid_setup_3 -hold_mc \
                -src_period $src_period -dest_period $dest_period \
                -launch_edge_time $next_hold_launch \
                -latch_edge_time $test_setup_latch_time \
                -sigma $sigma -offset $offset \
                -smh $opts(smh) -dmh $opts(dmh) ] { break }
                
            # Note whether either of them has negative edge times
            set hold_check_1_has_neg_time [expr {
                ($ht1_latch < 0) || ($ht1_launch < 0) }]
            set hold_check_2_has_neg_time [expr {
                ($ht2_latch < 0) || ($ht2_launch < 0) }]
            
            # If a check has a neg launch/latch time, there's a higher bar to use it instead
            # of min difference
            # If a check doesn't have a neg launch/latch time, there's a lower bar to use it
            # instead of min difference
            # If there was a negative min hold edge time, do a
            # test to advance it - If this hold difference is the same
            # as the one if it was negative, use this one
            if { $min_hold_edge_time_was_negative || (0 == $bigstep) } {
                # We're on the first round
                if { $hold_check_1_has_neg_time } {
                    # check 1 has negative edge times, so make both bars low
                    set adder_1 0
                    set adder_2 0
                } elseif { $hold_check_2_has_neg_time } {
                    # If we get here, hold check 1 has positive edge times
                    set adder_1 0
                    set adder_2 $sigma
                } else {
                    # If we get here, hold check 1 has positive edge times
                    # and hold check 2 has positive edge times
                    set adder_1 0
                    set adder_2 $sigma
                }
                
            } else {
                # Use a high bar to replace any time because the previous round
                # did not have a negative edge time
                set adder_1 $sigma
                set adder_2 $sigma
            }

            # Now do the hold relationship checks
            if { $hold_difference_1 + $adder_1 <= $min_hold_difference } {
                log::log_message "   Replacing $min_hold_difference with check 1 value"
                set min_hold_difference $hold_difference_1
#                set min_hold_launch_time $test_setup_launch_time
#                set min_hold_latch_time $prev_hold_latch
                set min_hold_launch_time $ht1_launch
                set min_hold_latch_time $ht1_latch
            }
            if { $hold_difference_2 + $adder_2 <= $min_hold_difference } {
                log::log_message "   Replacing $min_hold_difference with check 2 value"
                set min_hold_difference $hold_difference_2
#                set min_hold_launch_time $next_hold_launch
#                set min_hold_latch_time $test_setup_latch_time
                set min_hold_launch_time $ht2_launch
                set min_hold_latch_time $ht2_latch

            }

            # Are hold edge times negative?
            # If so, we'll accept another hold difference later on,
            # if it is the same value as the current min
            set min_hold_edge_time_was_negative [expr {
                ($min_hold_latch_time < 0) || ($min_hold_launch_time < 0) }]

            # We have checked the two hold relationships for valid setup
            # relationship that existed going into this loop iteration.
            # Let's move the launch edge forward and check setup 
            # relationships again
#            set launch_edge_time [expr { $launch_edge_time + $src_period }]
#            if { ($launch_edge_time < $latch_edge_time) && \
#                ($launch_edge_time + $opts(sigma) > $latch_edge_time) } {
#                set launch_edge_time $latch_edge_time
#            }
#            set next_launch_edge_time [expr { $launch_edge_time + $src_period }]

            ###############
            foreach { launch_edge_time latch_edge_time } \
                [advance_to_next_valid_setup_3 -advance \
                -src_period $src_period -dest_period $dest_period \
                -launch_edge_time $launch_edge_time \
                -latch_edge_time $latch_edge_time \
                -sigma $sigma -offset $offset] { break }
                
            log::log_message "  Advanced setup to launch $launch_edge_time and\
                latch $latch_edge_time"

            # We have a valid relationship
            # Now modify it to handle setup MCs
            foreach { test_setup_launch_time test_setup_latch_time } \
                [advance_to_next_valid_setup_3 -setup_mc \
                -src_period $src_period -dest_period $dest_period \
                -launch_edge_time $launch_edge_time \
                -latch_edge_time $latch_edge_time \
                -sigma $sigma -offset $offset \
                -sms $opts(sms) -dms $opts(dms)] { break }
            
            # Setup difference is easy
            set edge_difference [expr { $latch_edge_time - $launch_edge_time }]
            log::log_message "   Setup edge relationship is $edge_difference compared\
                to initial value of $initial_edge_difference"
            
            # Is the difference the same as what we started with?
            if { [util::fuzzy_comparison $edge_difference == $initial_edge_difference] } {

                # We've returned to the initial condition, so stop and
                # use the minimum so far
                set done 1
                
            } else {

                set setup_difference [expr { $test_setup_latch_time - $test_setup_launch_time }]
                log::log_message " Setup check for $test_setup_launch_time and $test_setup_latch_time"
                log::log_message "  $setup_difference and min is $min_setup_difference"
                if { ($setup_difference + $sigma) < $min_setup_difference } {
                    set min_setup_difference $setup_difference
                    set min_setup_launch_time $test_setup_launch_time
                    set min_setup_latch_time $test_setup_latch_time
                }
            }
            incr bigstep
            if { $bigstep > 20 } {
                post_message -type error "Unable to determine setup and hold\
                    relationships after 20 clock cycles."
                set done 1
            }
            set sigma [expr { $sigma + $sigma_adder }]
        }

        # If we get here, and a hold edge was still negative, try one last time to
        # get positive edge times for the hold relationship?
        
        
        if { $opts(setup) } {
            return [list $min_setup_launch_time $min_setup_latch_time]
        } elseif { $opts(hold) } {
            return [list $min_hold_launch_time $min_hold_latch_time]
        } else {
            # We should never get here
            return -code error "Must specify -setup or -hold"
        }
    }
    
    ######################################
    # Make sure that launch is < latch, and that there is no launch edge
    # closer to the latch
    proc advance_to_next_valid_setup_3 { args } {

        log::log_message " Calling advance_to_next_valid_setup_3 $args"

        set options {
            { "src_period.arg" "" "Source clock period" }
            { "dest_period.arg" "" "Destination clock period" }
            { "launch_edge_time.arg" "" "Launch edge time to start at" }
            { "latch_edge_time.arg" "" "Latch edge time to start at" }
            { "sigma.arg" "" "Sigma to handle close clock multiples" }
            { "offset.arg" "" "Offset between two clocks" }
            { "sms.arg" "1" "Source multicycle setup" }
            { "smh.arg" "0" "Source multicycle hold" }
            { "dms.arg" "1" "Dest multicycle setup" }
            { "dmh.arg" "0" "Dest multicycle hold" }
            { "advance" "Advance to next setup relationship" }
            { "setup_mc" "Do multicycle setup adjustments only" }
            { "hold_mc" "Do multicycle hold adjustments only" }
            { "prev_next_hold" "Get prev/next launch/latch edges for hold checks" }
            { "make_valid" "Move only latch enough to make it a valid setup" }
        }
        array set opts [::cmdline::getoptions args $options]

        set src_period $opts(src_period)
        set dest_period $opts(dest_period)
        set launch_edge_time $opts(launch_edge_time)
        set latch_edge_time $opts(latch_edge_time)
        set done 0
        set offset $opts(offset)
        set advance_move "begin"
        
        if { [string equal "" $opts(sigma)] } {
            return -code error "Must specify -sigma for advance_to_next_valid_setup_3"
        }
        
        # Because of 3 decimal places for arithmetic, clocks that are
        # not even multiples of each other (x, x/3) can come in
        # very close, but not clean multiples of each other.
        # In that case, pick whichever value
        # is more regular (e.g. 10 is better than 3.333). If the source
        # period is more regular, then the launch edge time is OK as is,
        # but recalculate the latch edge time based on the src clock.
        # If the dest period is more regular, then the latch time is OK
        # as is, but recalculate the launch edge time based on the dest clock

        #############################
        # All we're doing here is checking to see whether
        # previous or next edges are aligned or close to
        # aligned. If they're close to aligned, fix them
        ##############################
        
        while { ! $done } {
            # Check this launch and latch edge against each other
            if { $latch_edge_time == ($launch_edge_time + $offset)} {
                # If they're actually equal, don't do anything
            } elseif { $opts(sigma) >= abs($latch_edge_time - ($launch_edge_time + $offset)) } {
                if { 0 != $offset } {
                    log::log_message " Realigning: launch $launch_edge_time latch $latch_edge_time\
                        and offset $offset"
                }
                switch -exact -- [util::closer_to_integer $src_period $dest_period] \
                    $src_period {
                        set latch_edge_time [expr { $launch_edge_time + $offset }]
                    } \
                    $dest_period {
                        set launch_edge_time [expr { $latch_edge_time - $offset }]
                    } \
                    default {
                        return -code error "Unknown period value in\
                            advance_to_next_valid_setup_3"
                    }
            }
            
            # Calculate the next launch and latch edges, and check them for
            # correction if they're close to equal.
            # Do the same for prev launch and latch edges
            set next_launch_edge_time [expr { $launch_edge_time + $src_period }]
            set next_latch_edge_time [expr { $latch_edge_time + $dest_period }]
            set prev_launch_edge_time [expr { $launch_edge_time - $src_period }]
            set prev_latch_edge_time [expr { $latch_edge_time - $dest_period }]
            
            # Compare next launch to this latch
            if { ($next_launch_edge_time + $offset) == $latch_edge_time } {
                # Do nothing
            } elseif { $opts(sigma) >= abs(($next_launch_edge_time + $offset) - $latch_edge_time) } {
                if { 0 != $offset } {
                    log::log_message " Realigning: next launch $next_launch_edge_time\
                        latch $latch_edge_time and offset $offset"
                }
                switch -exact -- [util::closer_to_integer $src_period $dest_period] \
                    $src_period {
                        set latch_edge_time [expr { $next_launch_edge_time + $offset }]
                    } \
                    $dest_period {
                        set next_launch_edge_time [expr { $latch_edge_time - $offset }]
                    } \
                    default {
                        return -code error "Unknown period value in\
                            advance_to_next_valid_setup_3"
                    }
            }
            
            # Compare prev launch to this latch
            if { ($prev_launch_edge_time + $offset) == $latch_edge_time } {
                # Do nothing
            } elseif { $opts(sigma) >= abs(($prev_launch_edge_time + $offset) - $latch_edge_time) } {
                if { 0 != $offset } {
                    log::log_message " Realigning: prev launch $prev_launch_edge_time\
                        latch $latch_edge_time and offset $offset"
                }
                switch -exact -- [util::closer_to_integer $src_period $dest_period] \
                    $src_period {
                        set latch_edge_time [expr { $prev_launch_edge_time + $offset }]
                    } \
                    $dest_period {
                        set prev_launch_edge_time [expr { $latch_edge_time - $offset }]
                    } \
                    default {
                        return -code error "Unknown period value in\
                            advance_to_next_valid_setup_3"
                    }
            }
            
            # Compare this launch to next latch
            if { ($launch_edge_time + $offset) == $next_latch_edge_time } {
                # Do nothing
            } elseif { $opts(sigma) >= abs(($launch_edge_time + $offset) - $next_latch_edge_time) } {
                if { 0 != $offset } {
                    log::log_message " Realigning: launch $launch_edge_time next latch\
                        $next_latch_edge_time and offset $offset"
                }
                switch -exact -- [util::closer_to_integer $src_period $dest_period] \
                    $src_period {
                        set next_latch_edge_time [expr { $launch_edge_time + $offset }]
                    } \
                    $dest_period {
                        set launch_edge_time [expr { $next_latch_edge_time - $offset }]
                    } \
                    default {
                        return -code error "Unknown period value in\
                            advance_to_next_valid_setup_3"
                    }
            }
            
            # Compare this launch to prev latch
            if { ($launch_edge_time + $offset) == $prev_latch_edge_time } {
                # Do nothing
            } elseif { $opts(sigma) >= abs(($launch_edge_time + $offset) - $prev_latch_edge_time) } {
                if { 0 != $offset } {
                    log::log_message " Realigning: launch $launch_edge_time prev latch\
                        $prev_latch_edge_time and offset $offset"
                }
                switch -exact -- [util::closer_to_integer $src_period $dest_period] \
                    $src_period {
                        set prev_latch_edge_time [expr { $launch_edge_time + $offset }]
                    } \
                    $dest_period {
                        set launch_edge_time [expr { $prev_latch_edge_time - $offset }]
                    } \
                    default {
                        return -code error "Unknown period value in\
                            advance_to_next_valid_setup_3"
                    }
            }
            
            # Compare next launch to next latch
            if { ($next_launch_edge_time + $offset) == $next_latch_edge_time } {
                # If they're actually equal, don't do anything
            } elseif { $opts(sigma) >= abs(($next_launch_edge_time + $offset) - $next_latch_edge_time) } {
                if { 0 != $offset } {
                    log::log_message " Realigning: next launch $next_launch_edge_time\
                        next latch $next_latch_edge_time and offset $offset"
                }
                switch -exact -- [util::closer_to_integer $src_period $dest_period] \
                    $src_period {
                        set next_latch_edge_time [expr { $next_launch_edge_time + $offset }]
                    } \
                    $dest_period {
                        set next_launch_edge_time [expr { $next_latch_edge_time - $offset }]
                    } \
                    default {
                        return -code error "Unknown period value in\
                            advance_to_next_valid_setup_3"
                    }
            }
            
            # Compare prev launch to prev latch
            if { ($prev_launch_edge_time + $offset) == $prev_latch_edge_time } {
                # If they're actually equal, don't do anything
            } elseif { $opts(sigma) >= abs(($prev_launch_edge_time + $offset) - $prev_latch_edge_time) } {
                if { 0 != $offset } {
                    log::log_message " Realigning: prev launch $prev_launch_edge_time\
                        prev latch $prev_latch_edge_time and offset $offset"
                }
                switch -exact -- [util::closer_to_integer $src_period $dest_period] \
                    $src_period {
                        set prev_latch_edge_time [expr { $prev_launch_edge_time + $offset }]
                    } \
                    $dest_period {
                        set prev_launch_edge_time [expr { $prev_latch_edge_time - $offset }]
                    } \
                    default {
                        return -code error "Unknown period value in\
                            advance_to_next_valid_setup_3"
                    }
            }
            
            ####################################
            # When we get here, the launch and latch
            # edges, and prev and next launch and latch
            # edges have been aligned if necessary.
            ####################################
            
            if { $opts(prev_next_hold) } {
                # I want the previous and next latch and launch edges
                # for hold checks
                set launch_edge_time $next_launch_edge_time
                set latch_edge_time $prev_latch_edge_time
                set done 1
                log::log_message "  Returning next launch:\
                    $launch_edge_time and prev latch: $latch_edge_time"
                    
            } elseif { $opts(setup_mc) } {
                # If I'm doing only adjustment for multicycles,
                # I just shove edges around until setup MCs are 1.
                
                if { $opts(sms) > 1 } {
                    # push back
                    set launch_edge_time $prev_launch_edge_time
                    incr opts(sms) -1
                    
                } elseif { $opts(sms) < 1 } {
                    # push forward
                    set launch_edge_time $next_launch_edge_time
                    incr opts(sms)
                
                } elseif { $opts(dms) > 1 } {
                    # Push forward
                    set latch_edge_time $next_latch_edge_time
                    incr opts(dms) -1
                    
                } elseif { $opts(dms) < 1 } {
                    # Push back
                    set latch_edge_time $prev_latch_edge_time
                    incr opts(dms)
                } else {
                    set done 1
                    log::log_message "  Returning setup mc launch:\
                        $launch_edge_time and latch $latch_edge_time"                    
                }
            
                
            } elseif { $opts(hold_mc) } {
                # If I'm doing only adjustment for multicycles,
                # I just shove edges around until hold MCs are 0.
                
                if { $opts(smh) > 0 } {
                    # push forward
                    set launch_edge_time $next_launch_edge_time
                    incr opts(smh) -1
                    
                } elseif { $opts(smh) < 0 } {
                    # push back
                    set launch_edge_time $prev_launch_edge_time
                    incr opts(smh)
                
                } elseif { $opts(dmh) > 0 } {
                    # Push forward
                    set latch_edge_time $prev_latch_edge_time
                    incr opts(dmh) -1
                    
                } elseif { $opts(dmh) < 0 } {
                    # Push back
                    set latch_edge_time $next_latch_edge_time
                    incr opts(dmh)
                } else {
                    set done 1
                    log::log_message "  Returning hold mc launch:\
                        $launch_edge_time and latch $latch_edge_time"                    
                    
                }
            
                
            } elseif { $opts(advance) } {
                # Move to the next valid setup relationship
                # Don't consider offset in here, because this part is 
                # all about the absolute times.
if { 0 } {
                # If launch = latch, take next latch as the latch edge.
                # Adding the offset in here makes that check wrong.
                if { $launch_edge_time == $latch_edge_time } {
                
                    # If the launch and latch are equal, go to next latch
                    set latch_edge_time $next_latch_edge_time
                    
                } elseif { $next_launch_edge_time == $latch_edge_time } {
                
                    # If the next launch equals the latch time, they're
                    # coming into alignment. In that case, we're guaranteed to
                    # get a valid setup relationship by taking the next launch time
                    # and the next latch time.
                    set launch_edge_time $next_launch_edge_time
                    set latch_edge_time $next_latch_edge_time
                    
                } elseif { $next_launch_edge_time < $latch_edge_time } {
                
                    # If the next launch edge is less than the current latch,
                    # it's a valid setup relationship
                    set launch_edge_time $next_launch_edge_time
        
                } elseif { $next_launch_edge_time == $next_latch_edge_time } {
                
                    # Next launch and next latch are the same.
                    # Push out next latch an extra cycle
                    set launch_edge_time $next_launch_edge_time
                    set latch_edge_time [expr { $next_latch_edge_time + $dest_period }]
                    
                } elseif { $next_launch_edge_time < $next_latch_edge_time } {
                
                    # Next launch is greater than this latch_edge_time, but
                    # less than the next latch edge time, so both have to
                    # be moved.
                    set launch_edge_time $next_launch_edge_time
                    set latch_edge_time $next_latch_edge_time
                    
                } else {
                
                    # When we get here, we've established that next_launch_edge_time
                    # is greater than next_latch_edge_time.
                    # Just shove up latch.
                    set latch_edge_time $next_latch_edge_time
                    
                }
}
                # Push out the latch edge until it is greater than the
                # next launch edge
                # Then advance the launch edge until next launch edge is
                # greater than latch edge
                switch -exact -- $advance_move {
                "begin" {
                    if { $latch_edge_time <= $next_launch_edge_time } {
                        set latch_edge_time $next_latch_edge_time
                        log::log_message "   Advanced latch edge time to $next_latch_edge_time"
                    } else {
                        set advance_move "launch"
                    }
                }
                "launch" {
                    if { $next_launch_edge_time < $latch_edge_time } {
                        set launch_edge_time $next_launch_edge_time
                        log::log_message "   Advanced launch edge time to $next_launch_edge_time"
                    } else {
                        set done 1
                    }
                }
                }
                
            } elseif { $opts(make_valid) } {
if { 0 } {            
                # All I want to do is move the latch edge enough to make a
                # valid setup relationship
                if { $latch_edge_time <= $launch_edge_time } {
                    set latch_edge_time $next_latch_edge_time
                    log::log_message "   Make valid latch edge time to $next_latch_edge_time"
                } else {
                    set done 1
                }
}                
                switch -exact -- $advance_move {
                "begin" {
                    if { $latch_edge_time <= $launch_edge_time } {
                        set latch_edge_time $next_latch_edge_time
                        log::log_message "   Made valid latch edge time to $next_latch_edge_time"
                    } else {
                        set advance_move "launch"
                    }
                }
                "launch" {
                    if { $next_launch_edge_time < $latch_edge_time } {
                        set launch_edge_time $next_launch_edge_time
                        log::log_message "   Made valid launch edge time to $next_launch_edge_time"
                    } else {
                        set done 1
                    }
                }
                }

            }
        }
        
        return [list $launch_edge_time $latch_edge_time]
    }
    

    #############################
    # Set the changes flag to 0, so we can track
    # whether there were changes made to the clock settings
    proc clock_settings_change_flag { args } {

        set options {
            { "reset" "Reset to zero" }
            { "set" "Set to one" }
            { "query" "Return the status" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable clock_settings_changed
        
        if { $opts(reset) } {
            set clock_settings_changed 0
        } elseif { $opts(set) } {
            set clock_settings_changed 1
        } elseif { $opts(query) } {
            if { [string equal "" $clock_settings_changed] } {
                return -code error "clock_settings_changed variable has not been\
                    set but is being queried."
            } else {
                return $clock_settings_changed
            }
        } else {
            return -code error "Unknown option for clock_settings_change_flag"
        }
    }
    
    #############################################
    # Get the data to save it into the tree
    proc get_shared_data { args } {
    
        set options {
            { "keys.arg" "" "Variables to get" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data

        if { 0 == [llength $opts(keys)] } {
            return [array get shared_data]
        } else {
            set to_return [list]
            foreach key $opts(keys) {
                if { ! [info exists shared_data($key)] } {
                    post_message -type warning "Can't find value for $key \
                        in clocks_info namespace"
                    lappend to_return $key
                    lappend to_return {}
                } else {
                    lappend to_return $key $shared_data($key)
                }
            }
            return $to_return
        }
    }
    
    #######################################
    proc save_clock_tree_names { args } {
    
        variable shared_data
        variable src_tree
        variable dest_tree
        
        set shared_data(clock_tree_names) [list]
        
        foreach clock_id [get_clock_path_clock_ids -clock_tree $src_tree \
            -no_placeholders -generated -base -virtual] {
            lappend shared_data(clock_tree_names) [get_clock_info -name $clock_id]
        }
        foreach clock_id [get_clock_path_clock_ids -clock_tree $dest_tree \
            -no_placeholders -generated -base -virtual] {
            set name [get_clock_info -name $clock_id]
            if { -1 == [util::lsearch_with_brackets \
                $shared_data(clock_tree_names) $name] } {
                lappend shared_data(clock_tree_names) $name
            }
        }
            
    }
}

################################################################################
namespace eval netlist {

    ########################################
    # Create a graph of the clock path, and
    # mark the nodes in the path
    proc create_clock_path_graph { args } {

        log::log_message "Called create_clock_path_graph $args"
        
        set options {
            { "graph_var.arg" "" "Name of the graph to initialize" }
            { "no_clock" "Add no_clock flag to root node" }
            { "root_node.arg" "" "Root node for the graph" }
            { "rebuild.arg" "" "Rebuild the graph from scratch?" }
        }
        array set opts [::cmdline::getoptions args $options]

        upvar $opts(graph_var) graph

        set graph [::struct::graph]
        $graph node insert $opts(root_node)
        if { $opts(no_clock) } {
            $graph node set $opts(root_node) "no_clock" 1
        }
        build_clock_path_2 -graph $graph -destination $opts(root_node)
        $graph walk $opts(root_node) -order post \
            -type dfs -dir backward -command mark_clock_path_nodes_2

    }

    ########################################
    # Remove some key attributes from the graph.
    # Get rid of clock_ids, clock_to_source,
    # source_to_clocks
    proc reset_clock_path_graph { args } {
    
        set options {
            { "graph.arg" "" "Graph to reset" }
            { "graph_var.arg" "" "Name of graph to reset" }
        }
        array set opts [::cmdline::getoptions args $options]

        if { ! [string equal "" $opts(graph_var)] } {
            upvar $opts(graph_var) graph
        } else {
            set graph $opts(graph)
        }

        set keys_to_remove [list "clock_ids" "clock_to_source" \
            "source_to_clocks"]

        foreach key $keys_to_remove {
            foreach node [$graph nodes -key $key] {
                $graph node unset $node $key
            }
        }
    }
    
    ################################################################################
    # Builds a graph to the specified destination based on the structure of the
    # timing netlist
    proc build_clock_path_2 { args } {
    
        set options {
            { "graph.arg" "" "Name of variable that holds the graph" }
            { "destination.arg" "" "Node ID to trace the clock path to" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        # Create a queue of node IDs to process, starting with the destination ID
        set queue [::struct::queue]
        $queue put $opts(destination) 
    
        # While there are nodes to process...
        while { 0 < [$queue size] } {
    
            # Get a node ID
            set node_id [$queue get]

            # Get some information about the node
            set node_type [get_node_info -type $node_id]
            set node_loc [get_node_info -location $node_id]
            set node_name [get_node_info -name $node_id]
            set clock_edges [get_node_info -clock_edges $node_id]

#post_message "Working on $node_id at $node_loc called $node_name"
            # A DDIO output cell has 3 clock_edges - the high and low data registers,
            # and the comb path for the mux.
            # When creating the tree, don't follow the register paths.
            # So we need to know whether this is a DDIO cell or not
            if { 3 == [llength $clock_edges] } {
                set is_ddio_out [expr {
                    [regexp {^PIN} $node_loc] || \
                    [regexp {altddio_out_component} $node_name] }]
            } else {
                # In 3-series families, derivatives, and newer, only the mux path
                # exists. Reg paths are cut.
                
                set is_ddio_out 0
            }
    
            # Don't go down clock select lines of clock control blocks
            if { [regexp {^CLKCTRL} $node_loc] && (1 < [llength $clock_edges]) } {
                set is_clkctrl 1
            } else {
                set is_clkctrl 0
            }
            
            # Walk through all the clock edges that feed the node
            foreach clock_edge $clock_edges {
    
                set src_node_id [get_edge_info -src $clock_edge]
                set src_type [get_node_info -type $src_node_id]
                set src_name [get_node_info -name $src_node_id]
    
                # Skip the clock edge if node_id is DDIO and the src is not comb
                # Skip the clock edge if node_id is CLKCTRL and the src name is *clkselect[n]
                if { $is_ddio_out && (! [string equal "pin" $src_type]) } {
                    # Skip it
                } elseif { $is_clkctrl && [regexp {clkselect\[\d+\]$} $src_name] } {
                    # Skip it
                } else {
    
                    if { [$opts(graph) node exists $src_node_id] } {
                        # If we do have the source node ID already in the graph,
                        # all we have to do is connect the two.
                    } else {
                        # If we don't have the source node ID in the tree yet,
                        # insert it and put it on the queue to follow
                        # Then connect it to node_id
                        $opts(graph) node insert $src_node_id
                        $queue put $src_node_id
                    }
                    # The "start" node is the source, and
                    # the "end" node is the one we're working on, because we're
                    # following fanins of the netlist.
                    $opts(graph) arc insert $src_node_id $node_id
                        
                }
            }
        }
    
        # Get rid of the queue
        $queue destroy
    }

    ################################################################################
    # A register in the clock path must be kept to apply a generated clock to
    # The name to display is the name of the node with type reg. The clock input
    # that's the source is the comb source of the clock_edge (|clk). The reg output
    # that's the target of the clock is the next comb node, |regout
    # An input port in the clock path must be kept to apply a base clock to
    # Clock control blocks are comb nodes. If they have an input pin named
    # clkselect[n], there's more than 1 input. Suppress the select pin but keep
    # outclk as the target
    # PLLs don't have one node for the PLL. Sequential nodes are the inclk and clk
    # pins. So I'll have to prune the full hierarchy name, and set the
    # source and target.
    proc mark_clock_path_nodes_2 { action graph node_id } {
    
        set node_type [get_node_info -type $node_id]
        set node_name [get_node_info -name $node_id]
        set node_location [get_node_info -location $node_id]
        set fanout_ids [$graph nodes -out $node_id]
        set fanin_ids [$graph nodes -in $node_id]
#post_message "Working on $node_id"
        # Mark registers that are plain registers
        if { [string equal "reg" $node_type] } {
    
            # I certainly expect these things to be false for plain registers
            # There should be 0 or 1 fanout IDs and 1 fanin ID
            if { (1 < [llength $fanout_ids]) || \
                (1 != [llength $fanin_ids]) } {
                post_message -type warning "$node_id $node_name has unexpected\
                    fanin or fanout IDs"
            } else {
    
                # Set the target and source of the register
                $graph node lappend $node_id "source_id" [lindex $fanin_ids 0]
                set fe [get_node_info -fanout_edges $node_id]
                if { 0 == [llength $fe] } {
                    # 3-series, derivatives, and newer can have no fanouts
                    # from a DDR output register.
                    if { [regexp {^DDIO} $node_location] } {
                        # Good
                        $graph node lappend $node_id "target_id" $node_id
                    } else {
                        # Don't know what to do in this situation
                        post_message -type error "$node_id has [llength $fe]\
                            fanouts but must have 1"                
                    }
                } else {
                    if { 1 < [llength $fe] } {
                        post_message -type error "$node_id has [llength $fe] fanouts but must have 1"
                    }
                    $graph node lappend $node_id "target_id" [get_edge_info -dst [lindex $fe 0]]
                }
                $graph node set $node_id "clock_type" "generated"
                    
                # Set the fanin and fanout not to show
#                $graph node set [lindex $fanin_ids 0] "hide" 1
    
                # It's possible that we traverse the graph with a reg node
                # as the destination, in which case there is no fanout.
#                if { 0 < [llength $fanout_ids] } {
#                    $graph node set [lindex $fanout_ids 0] "hide" 1
#                }
            }
        
        } elseif { [string equal "port" $node_type] } {
    
            # If it's an input port, it gets a base clock
            # Also, hide a following combout port
            if { [get_port_info -is_input_port $node_id] } {
            
                # An input port gets a base clock
                $graph node set $node_id "target_id" $node_id
                $graph node set $node_id "clock_type" "base"
                    
                # There should be only 1 fanout node
                if { 1 == [llength $fanout_ids] } {
if { 0 } {
                    # If it's a pin node in an IOC, hide it
                    set fanout_id [lindex $fanout_ids 0]
                    set fanout_type [get_node_info -type $fanout_id]
                    set fanout_location [get_node_info -location $fanout_id]
                    if { [string equal "pin" $fanout_type] && \
                        [regexp {^IOC} $fanout_location] } {
                        $graph node set [lindex $fanout_ids 0] "hide" 1
                    } else {
                        post_message -type warning "$node_id $node_name parent is not\
                            a pin node in an IOC but is $fanout_type at $fanout_location"
                    }
}
                } else {
                    post_message -type warning "$node_id $node_name fans out to more than 1 ID"
                }
            
            } elseif { [get_port_info -is_output_port $node_id] } {
            
                # If it's an output port, it gets a generated clock
                $graph node lappend $node_id "target_id" $node_id
                $graph node set $node_id "clock_type" "generated"

                # This should never be true.
                if { 1 < [llength $fanin_ids] } {
                    post_message -type warning "$node_id $node_name output port has\
                        more than 1 fanin: $fanin_ids"
                }
    
                set fanin_id [lindex $fanin_ids 0]
                set fanin_id_location [get_node_info -location $fanin_id]

                # The fanin ID to the output port is whatever precedes it,
                # but in SIII, that is on the other side of the IOOBUF
                while { [regexp {^IOOBUF} $fanin_id_location] } {
                    set fanin_ids [$graph nodes -in $fanin_id]
                    if { 1 < [llength $fanin_ids] } {
                        post_message -type warning "$fanin_id has more than 1 fanin"
                    }
                    set fanin_id [lindex $fanin_ids 0]
                    set fanin_id_location [get_node_info -location $fanin_id]
                }

                # Now get the name and type
                set fanin_id_name [get_node_info -name $fanin_id]
                set fanin_id_type [get_node_info -type $fanin_id]

                # If it is a DDIO feeding the output port, set the DDIO as the
                # source_id of the output port.
                # Also the DDIO port doesn't get a clock.
                # Ports should be fed by comb nodes (pins in 8.0).
                # If the feeder is just the
                # datain pin of the port, that's the source, and it
                # gets hidden
                if { [string equal "pin" $fanin_id_type] } {
                
                    $graph node lappend $node_id "source_id" $fanin_id

                    if { [regexp {\|(outclk|dataout)$} $fanin_id_name] } {
                        $graph node set $fanin_id "no_clock" 1
                        # Need to know that it's DDIO-fed for deciding
                        # which generated clock dialog box to show
                        $graph node set $node_id "is_ddio_fed" 1
                    } else {
                        $graph node set $fanin_id "hide" 1
                    }
                }
            }
        } elseif { [regexp {^CLKCTRL} $node_location] } {
        
            # Handle clock control blocks
            if { [string equal "pin" $node_type] && \
                [regexp {\|outclk$} $node_name] } {
    
                # If the outclock node has one fanin, no extra clocks are necessary
                # and the whole thing can be hidden. Hide the outclock node here
                if { 1 == [llength $fanin_ids] } {
                    $graph node set $node_id "hide" 1
                } else {
                    # There's more than one input. Generated clocks are necessary.
                    # Set the target and source of the clock control block
                    foreach fanin_id $fanin_ids {
                        $graph node lappend $node_id "source_id" $fanin_id
                    }
                    $graph node lappend $node_id "target_id" $node_id
                    $graph node set $node_id "clock_type" "generated"
                    $graph node set $node_id "divide_by" 1
                    $graph node set $node_id "multiply_by" 1
                }
    
                # Regardless of how many inputs it has, hide them all.
                foreach fanin_id $fanin_ids {
                    $graph node set $fanin_id "hide" 1
                }
            }
        } elseif { [regexp {^PLL} $node_location] } {
        
            # We always have to see PLLs because they always need generated clocks.
            # However, we never have to see the inputs.
            if { [regexp {\|clk\[\d+\]$} $node_name] } {
#post_message "working on pll node $node_name"                
                # SIII PLLs have a pin in the middle that SII ones didn't.
                # We have to pass the pin and get to inclk[x]
                # Finding multiple fanins is a stop condition, and it's
                # an easy check to do to see whether we can skip backing up.
                set done [expr { 1 < [llength $fanin_ids] }]
                    
                while { ! $done } {

                    # Finding the inclk port is also a stop condition
                    set fanin_id [lindex $fanin_ids 0]
                    set fanin_id_name [get_node_info -name $fanin_id]
                    if { [regexp {\|inclk\[\d+\]$} $fanin_id_name] } {
                        set done 1
                    } else {

                        set fanin_ids [$graph nodes -in $fanin_id]
                        if { 1 < [llength $fanin_ids] } {
                            set done 1
                        }
                    }
                }
                
                foreach fanin_id $fanin_ids {
                    # Each input is a source ID for the output
                    # Regardless of how many inputs it has, hide them all.
                    $graph node lappend $node_id "source_id" $fanin_id
#                    $graph node set $fanin_id "hide" 1
#post_message "Hiding node $fanin_id for $node_id"
                }
    
                # The target of the generated clock will be the this node
                $graph node lappend $node_id "target_id" $node_id
                $graph node set $node_id "clock_type" "generated"
                
                # TODO - get PLL information such as multiply/divide by,
                # phase shift, offset, based on $node_name
                # Column names are Mult, Div, Phase Shift
                # PLL name may be _clk<n>
                # Save those in the graph node, then pull them into the clock leaf
                # get_node_info -name comb_0
                # inst3|altpll_component|pll|clk[0]
                # but compilation report has pll:inst3|altpll:altpll_component|_clk0
            
            } else {
                $graph node set $node_id "hide" 1
#post_message "Hide $node_id in PLL"
            }
        } elseif { [string equal "pin" $node_type] } {

            # In Stratix III, pins in IOOBUFs and IOIBUFs get hidden
            if { [regexp {^IO[IO]BUF} $node_location] } {
                $graph node set $node_id "hide" 1
#post_message "Hid $node_id"
            }
            
            # Most pins get hidden. However, some pins get stuff set for them.
            # If a pin has had something set, don't add the hide key
            if { 0 == [llength [$graph node keys $node_id]] } {
                $graph node set $node_id "hide" 1
#post_message "hid $node_id"
            }
    
        }
    
    }

    ################################################################################
    # Every node gets one clock by default.
    # When I stick generated clocks on nodes, and there are multiple clocks,
    # I have to keep track of which master clock to associate.
    # When I work on a source ID, I need to know the order of multiple clocks
    # on its source(s), so I can use them later for master clocks.
    # foreach source node, get its fanin nodes with clocks on them
    #  foreach fanin node
    #   foreach clock on a fanin node, insert a clock leaf in the clock path tree
    #     with data of the source ID and the node ID of the clock on the fanin node
    #     During that insert process, compare to all existing clocks on that node.
    #     If the master name and master pin match, insert the existing clock instead
    proc insert_clock_leaves { index_name action graph node_id } {
    
        upvar $index_name widget_index
    
        # If this node doesn't get shown in the GUI, skip it.
        if { [$graph node keyexists $node_id "hide"] } { return }
    
        # If this node doesn't get a clock made for it, skip it.
        if { [$graph node keyexists $node_id "no_clock"] } { return }
        
        log::log_message "Calling insert_clock_leaves with index of $widget_index,\
            for $node_id"
    
        set clock_type [$graph node get $node_id "clock_type"]
    
        if { [string equal "base" $clock_type] } {

            # Get the base clocks that exist on the node
            set existing_base_clocks [clocks_info::get_clocks_on_node -node_id $node_id -base]
            set num_existing_base_clocks [llength $existing_base_clocks]

            # If there were no base clocks on the node, insert a place for one
            # If it's a base clock, we need to put a placeholder in only if
            # there are no clocks on it already.
            if { 0 == $num_existing_base_clocks } {
    
                # Insert a placeholder for a base clock on the node we're looking at
                $graph node lappend $node_id "clock_ids" $widget_index
                incr widget_index
                
            } else {
            
                # Put clock IDs in the tree for the base clocks that already exist
                foreach clock_id $existing_base_clocks {
                    $graph node lappend $node_id "clock_ids" $clock_id
                }
            }

        } elseif { [string equal "generated" $clock_type] } {
 
            # Deal with nodes with generated clocks
            set existing_generated_clocks \
                [clocks_info::get_clocks_on_node -node_id $node_id -generated]
    
            # Get the source IDs - they should exist.
            set source_ids [list]
            if { [$graph node keyexists $node_id "source_id"] } {
                set source_ids [$graph node get $node_id "source_id"]
            }
    
            # Maps a particular clock id (that is applied to a target) to the
            # pin that is its source
            array unset new_clock_source_id
            array set new_clock_source_id [list]
    
            # Map which clock IDs feed a particular source pin
            array unset source_fanin_clock_ids
            array set source_fanin_clock_ids [list]
    
            # Work on each source ID - for each source ID are some number of
            # corresponding clocks on the output
    
            foreach source_id $source_ids {
    
                # Get the name for later use
                set source_name [get_node_info -name $source_id]
                
                set fanin_nodes_with_clocks [get_fanin_nodes_with_clocks \
                    -node_id $source_id -graph $graph]
    
                # What are the IDs of clocks that feed the source ID?
                set source_fanin_clock_ids($source_id) [list]
    
                # fanin_nodes_with_clocks now has keys of the node IDs that have
                # clocks on them, that feed source_id, and values of the clock IDs
                # or placeholders
                foreach previous_clock_node_id $fanin_nodes_with_clocks {
    
                    foreach master_clock [$graph node get $previous_clock_node_id "clock_ids"] {
    
                        # master clock always feeds the source ID
                        lappend source_fanin_clock_ids($source_id) $master_clock
                        set new_clock_id [get_generated_clock_or_placeholder \
                            -master_clock_id $master_clock \
                            -gen_clocks_on_node $existing_generated_clocks \
                            -source_id $source_id -index_var widget_index]
    
                        # Here we have finished checking to see whether any existing
                        # clocks apply to this node/source_id/master combination
                        $graph node lappend $node_id "clock_ids" $new_clock_id
                        # Map the source pin for the new clock ID 
                        lappend new_clock_source_id($new_clock_id) $source_id
    
                    }
                    # Here, we've walked through all the clocks on nodes that feed
                    # this source_id
                }
                # Here, we've walked through all the nodes that feed this source_id
                
            }
            # Here, we've walked through all source_ids for the specified node.
            
            $graph node set $node_id "clock_to_source" [array get new_clock_source_id]
            $graph node set $node_id "source_to_clocks" [array get source_fanin_clock_ids]
    
        } else {
            post_message -warning "$node_id doesn't have a clock_type"
        }
        
        log::log_message " Inserted a clock leaf with the following data:"
        log::log_message "  [$graph node getall $node_id]"
    }
    
    ################################################################################
    # Pass in a source pin and a master clock name or ID
    # Go through all generated clocks
    # If a generated clock applies to this pin and master clock combination,
    # return its clock id. Otherwise return an index for a placeholder
    proc get_generated_clock_or_placeholder { args } {
    
        set options {
            { "source_id.arg" "" "ID to check against -master_clock_pin" }
            { "master_clock_id.arg" "" "ID of master clock to check"}
            { "gen_clocks_on_node.arg" "" "Generated clocks on the node" }
            { "index_var.arg" "" "Name of index variable" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        upvar $opts(index_var) widget_index
    
        # Check to see whether an existing generated clock
        # can apply to the output. Assume it can't, so assume
        # We'll use a placeholder.
        set use_placeholder 1
    
        # master_clock_id is what feeds this particular source_id
        # If master_clock is only a placeholder, don't even bother
        # seeing whether an existing generated clock matches,
        # because it can't.
        if { [string is double $opts(master_clock_id)] } {
            # If the master clock ID is just a number, it is one of
            # the script's placeholders.
            # get_object_info prints a warning if it doesn't match
            # anything, which can worry people.
        } elseif { [catch { get_object_info -type $opts(master_clock_id)} res] } {
        
            # master_clock_id is only a placeholder, we need a new
            # output clock

        } elseif { [string equal "clk" $res] } {

            set master_clock_name [get_clock_info -name $opts(master_clock_id)]
    
            # master_clock_id is an actual clock. Is there a generated
            # clock that applies to this node/source_id/master
            # combination? If so, use it.
            foreach clock_id $opts(gen_clocks_on_node) {
            
                # It covers this particular combination only if
                # The name of master_clock_id matches the -master_clock
                # option for clock_id and
                # The -master_clock_pin matches the source_id we're
                # working on
#post_message "getting master clock info for id $clock_id"
                set gen_clock_master_name [get_clock_info -master_clock $clock_id]
                set gen_clock_master_pin [get_clock_info -master_clock_pin $clock_id]
        
                if { [string equal $master_clock_name $gen_clock_master_name] && \
                    [string equal [get_node_info -name $opts(source_id)] $gen_clock_master_pin] } {
        
                    set use_placeholder 0
                    break
                }
            }
    
        } else {
            # This should not happen
            post_message -type warning "Type of $master_clock is not a clock"
        }
    
        # We have to create a placeholder if there
        # are no matching generated clocks
        if { $use_placeholder } {
            set new_clock_id $widget_index
            incr widget_index
        } else {
            set new_clock_id $clock_id
        }
    
        return $new_clock_id
    }

    ################################################################################
    # TODO - if a PLL has a generated clock on one of its outputs, copy the
    # specified multiply and divide values to any placeholders on the other outputs
    # gui_tree is the tree where the clock paths get displayed
    # gui_parent is the parent in the tree where nodes get inserted
    proc populate_gui_clock_path { gui_tree gui_parent clock_status_var action graph node_id } {
    
#        global images 

        upvar $clock_status_var clock_status

        # Some nodes in the clock path get hidden. These may be input pins for
        # cells, for example.
        if { [$graph node keyexists $node_id "hide"] } { return }
    
        # We're not hiding the node if we get here
    
        set node_location [get_node_info -location $node_id]
        set node_name [get_node_info -name $node_id]
    
        # Insert an item in the tree with the node name and location
        $gui_tree insert end $gui_parent $node_id -text \
            "$node_name ($node_location)" -open true -selectable 0
        
        # Some nodes we want to show, but they don't get a clock.
        # One example is a DDIO output in an IOC that drives off chip
        if { [$graph node keyexists $node_id "no_clock"] } { return }
    
        # The node gets a clock if we get here
        # Get the data that was created for the node by insert_clock_leaves
        array set node_data [$graph node getall $node_id]
        log::log_message "Data from graph for $node_id is [array get node_data]"
        
        set source_id_index 0
        set previous_source_id ""
    
        # We walk through the list of clock IDs to insert clock items
        # in the GUI tree.
        foreach clock_id $node_data(clock_ids) {
    
            # Array for data we will insert with the node in the GUI
            array unset gui_data
            array set gui_data [list]
    
            set clock_type $node_data(clock_type)
            set gui_data(clock_type) $clock_type
    
            # Special flag if it's fed by a DDIO
            # If it is, we show the special generated clock dialog
            if { [info exists node_data(is_ddio_fed)] } {
                set gui_data(is_ddio_fed) 1
            }

            array unset clock_info

            # If we've seen this clock already, and it has been validated,
            # what is its information and how do we show it?        
            if { [info exists clock_status($clock_id)] && $clock_status($clock_id) } {
    
                # Get the clock info for this clock
                array set clock_info [util::remove_clock_default_values -clock_id $clock_id \
                    -type $clock_type ]
                set gui_data(placeholder) 0

            } elseif { [project_info::is_clock_created_by -file_defined -clock_id $clock_id] } {
                # This clock hasn't been validated yet. However, it exists
                # in the list of sdc defined clocks, from the user's
                # SDC file, so it's validated by definition
                set clock_status($clock_id) 1
                # Get the clock info for this clock
                array set clock_info [util::remove_clock_default_values -clock_id $clock_id \
                    -type $clock_type ]
                set gui_data(placeholder) 0
        
            } elseif { [project_info::is_clock_created_by -auto_generated -clock_id $clock_id] } {
                # If the clock ID exists in the list of auto generated clocks,
                # it was not from the user's SDC file, so it must be validated
                set clock_status($clock_id) 0
                # Get the clock info for this clock
                if { [string equal "generated" $clock_type] } {
                    array set clock_info [util::remove_clock_default_values -clock_id $clock_id \
                        -type $clock_type]
                } else {
                    set clock_info(name) [get_clock_info -name $clock_id]
                }
                set gui_data(placeholder) 0
    
            } else {
    
                # And there are plenty of ways no clock can get created
                # automatically. One is required and it has to be created.
                set clock_status($clock_id) 0
                # Get the clock info for this clock
                array set clock_info [list]
                # If the placeholder is a generated clock, it has a source name
#                if { [string equal "generated" $clock_type] } {
#                    set clock_info(source) [get_node_info -name $node_data(source_id)]
#                }
                set gui_data(placeholder) 1
            }
    
            # If the clock has not been verified, and it's a generated clock,
            # there are some things to initialize
            # The based_on information gets used when the clock creation dialog
            # boxes are displayed.
            if { ! $clock_status($clock_id) && \
                [string equal "generated" $clock_type] } {
                    set clock_info(based_on) "frequency"
            }
    
            # We always have a target for base and generated clocks, regardless
            # of their status
            switch -exact -- $clock_type {
            "base" -
            "generated" {
                set clock_info(targets) [get_node_info -name $node_data(target_id)]
            }
            "virtual" { }
            default {
                return -code error "Unknown clock_type in populate_gui_clock_path:\
                    $clock_type"
            }
            }
            
            # Say what the clock target is
            set gui_data(target_id) $node_data(target_id)
    
            # Anything special to put in the data if it's a base clock?
            if { [string equal "base" $clock_type] } {
    
                # All base clocks are enabled to click on
                set leaf_state "normal"
                
            } elseif { [string equal "generated" $clock_type] } {
    
                array unset clock_to_source
                array unset source_to_clocks
                array set clock_to_source $node_data(clock_to_source)
                array set source_to_clocks $node_data(source_to_clocks)
    
                set source_id $clock_to_source($clock_id)
                set gui_data(source_id) $source_id
    
                # We always have a source for generated clocks
                set clock_info(source) [get_node_info -name $source_id]
                
                # Set up for walking through the source to clocks
                if { ! [string equal $previous_source_id $source_id] } {
                    set source_id_index 0
                    set previous_source_id $source_id
                }
    
                # In many cases, a master clock is unnecessary
                # A master clock is necessary only when there are multiple
                # clocks on a source
                if { 1 == [llength $source_to_clocks($source_id)] } {
    
                    # The leaf is always enabled if a master clock is unnecessary
                    set leaf_state "normal"
    
                } else {
    
                    # Set a master clock if there are multiple clocks on the source
                    set gui_data(master_clock_id) [lindex $source_to_clocks($source_id) $source_id_index]
                    
                    # The tree leaf should be disabled if its master clock is just
                    # a placeholder or has not been validated
                    array unset master_clock_data
                    array set master_clock_data \
                        [$gui_tree itemcget $gui_data(master_clock_id) -data]
    # If statement had $master_clock_data(validated)
                    if { ! $clock_status($gui_data(master_clock_id)) || \
                        $master_clock_data(placeholder) } {
                        set leaf_state "disabled"
                    } else {
                        set leaf_state "normal"
                        set clock_info(master_clock) [get_clock_info -name $gui_data(master_clock_id)]
                    }
                }
    
                # Some generated clocks may have information we can prefill
                foreach o { multiply_by divide_by } {
                    if { [info exists node_data($o)] } { set gui_data($o) $node_data($o) }
                }
                
                incr source_id_index
            }
    
            # If there's a generated clock, get that bit of info
#            if { [info exists gui_data(master_clock_id)] } {
#                set clock_info(master_clock) [get_clock_info -name $gui_data(master_clock_id)]
#            }
            
            # Save the clock info
            set gui_data(clock_info) [array get clock_info]
    
            # Get the name of the clock. SDC-generated and auto-generated
            # clocks both have valid names. Placeholders don't.
            # node_text will be either the name of the clock,
            # or a string that says you need a base clock or a generated clock
#            if { [catch { get_object_info -name $clock_id } node_text] } { }
            if { ! $gui_data(placeholder) } {
                set node_text [get_clock_info -name $clock_id]
            } elseif {[string equal "base" $clock_type] } {
                set node_text "<Double-click to create required base clock>"
            } elseif { [string equal "generated" $clock_type] } {
                set node_text "<Double-click to create required generated clock>"
            } else {
                # We should never get here
                post_message -type warning "Can't determine a name for $node_id\
                    in populate_gui_clock_path"
                set node_text "Invalid clock type"
            }

            log::log_message "Inserting $clock_id in the GUI with data:\
                \n [array get gui_data]"
            $gui_tree insert end $node_id \
                $clock_id -text $node_text -data \
                [array get gui_data]
    
            # Disable the clock as appropriate
            if { [string equal "disabled" $leaf_state] } {
                $gui_tree itemconfigure $clock_id -selectable 0
                $gui_tree itemconfigure $clock_id -fill "grey50"
            }
            
            # Show a check or question mark as appropriate
#            if { $clock_status($clock_id) } {
#                $gui_tree itemconfigure $clock_id -image $images(check)
#            } else {
#                $gui_tree itemconfigure $clock_id -image $images(question)
#            }
        }
    
    }

    ################################################################################
    # Procedure takes a node ID and comes up with a list of clocks that feed the
    # node. Or a list of potential clocks, because they might not have been created
    # yet
    proc get_fanin_nodes_with_clocks { args } {
    
        set options {
            { "node_id.arg" "" "Node ID" }
            { "graph.arg" "" "graph" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        set fanin_nodes_with_clocks [list]
    
        set queue [::struct::queue]
        foreach fanin_id [$opts(graph) nodes -in $opts(node_id)] { $queue put $fanin_id }
        # queue now has all fanin IDs for opts(source_id)
    
        while { 0 < [$queue size] } {
        
            set node_id [$queue get]
    
            # If there's a clock_type on the node, it has a clock we need
            # to know about.
            if { [$opts(graph) node keyexists $node_id "clock_type"] } {
                # Save the target node ID that will get a clock
                lappend fanin_nodes_with_clocks $node_id
            } else {
                # Get its fanins and continue
                foreach fanin_id [$opts(graph) nodes -in $node_id] { $queue put $fanin_id }
            }        
        }
    
        # fanin_nodes_with_clocks now has are all the node IDs with clocks that
        # feed the source_id.
    
        # Get rid of the queue
        $queue destroy
        
        return $fanin_nodes_with_clocks
    }


}

################################################################################
#
namespace eval clock_relationship {

    # GUI elements
    variable src_clock_cb
    variable dest_clock_cb
    variable al_tf
    variable rate_pm
    variable setup_hold_false_path_frame
    
    variable data_list [list \
        "src_clock_name"    "" \
        "dest_clock_name"   "" \
        "transfer_edge"     "" \
        "degree_shift"      "" \
        "extra_setup_cuts"  [list] \
        "extra_hold_cuts"   [list] \
        "advanced_false_paths"  "" \
    ]
    variable ns_data
    variable old_data
    array set ns_data $data_list
    array set old_data $data_list
    variable other_data
    array set other_data [list \
        "data_rate"     "" \
        "clock_configuration"   "" \
    ]

    variable other_shift
    variable old_other_shift
    variable temp_setup_cuts
    variable temp_hold_cuts
    array set temp_setup_cuts [list "rise,rise" 0 "rise,fall" 0 "fall,rise" 0 "fall,fall" 0]
    array set temp_hold_cuts [list "rise,rise" 0 "rise,fall" 0 "fall,rise" 0 "fall,fall" 0]
    
    variable src_clocks [list]
    variable dest_clocks [list]
    
    ########################################
    #
    proc assemble_tab { args } {

        set options {
            { "frame.arg" "" "Frame to assemble the tab on" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable src_clock_cb
        variable dest_clock_cb
        variable ns_data
        variable al_tf
        variable rate_pm
        variable other_shift
        variable temp_setup_cuts
        variable temp_hold_cuts
        variable setup_hold_false_path_frame
        
        set f $opts(frame)

        # Set up the nav frame
#        set nav_frame [frame $f.nav]
#        pack $nav_frame -side top -anchor nw -fill x -expand true

        ##############################################
        # Title frame for the interface clocks
        set ic_tf [TitleFrame $f.clocks -text "Interface clocks" -ipad 8]
        set sub_f [$ic_tf getframe]
        
        # Brief instructions
        pack [label $sub_f.l0 -text "In a multi-clock I/O interface, there\
            can be multiple source or destination clocks." -justify left] \
            -side top -anchor nw
        pack [label $sub_f.text -text "If there are multiple source or\
            destination clocks, select one of each to use when constraints\
            are generated." -justify left] \
            -side top -anchor nw
        pack [Separator $sub_f.sep -relief groove] \
            -side top -anchor n -fill x -expand true -pady 5
        
        # Labelframes for clock comboboxes
        set src_clock_lf [LabelFrame $sub_f.src_clock -side left \
            -text "Source clock"]
        set src_clock_subf [$src_clock_lf getframe]
        set dest_clock_lf [LabelFrame $sub_f.dest_clock -side left \
            -text "Destination clock"]
        set dest_clock_subf [$dest_clock_lf getframe]
        
        # Comboboxes to choose the interface clocks
        set src_clock_cb [ComboBox $src_clock_subf.cb -textvariable \
            [namespace which -variable ns_data](src_clock_name)]
        set dest_clock_cb [ComboBox $dest_clock_subf.cb -textvariable \
            [namespace which -variable ns_data](dest_clock_name)]
        pack $src_clock_cb $dest_clock_cb -side top -fill x -expand true
        pack $src_clock_lf $dest_clock_lf -side top -pady 5 -fill x -expand true
        LabelFrame::align $src_clock_lf $dest_clock_lf

        grid $ic_tf -sticky news
#        pack $ic_tf -side top -anchor nw -fill x -expand true -pady 8

        #########################################################
        # Set up the basic and advanced settings for transfer edge
        set dt_nb [NoteBook $f.dt_nb -homogeneous 1 -side top]
        set f_basic [$dt_nb insert end "basic" -text "Data transfer edges"]
        set f_advanced [$dt_nb insert end "advanced" -text "Advanced settings"]
        
        # Pack in the text for the basic page
        pack [label $f_basic.l0 -text "The data transfer edges depend on the\
            desired operation of your design and the register clock polarities."] \
            -side top -anchor nw
        pack [label $f_basic.ls -text "For same edge data transfer, the launch and\
            latch clock edges are the same polarity." -justify left] \
            -side top -anchor nw
        pack [label $f_basic.lo -text "For opposite edge data transfer, the launch and\
            latch clock edges are opposite polarity." \
            -justify left] \
            -side top -anchor nw
        pack [Separator $f_basic.sep] -side top -fill x -expand true -pady 5
        
        pack [radiobutton $f_basic.same -text "Same edge" -variable \
            [namespace which -variable ns_data](transfer_edge) -value "same"] \
            -side top -anchor nw
        pack [radiobutton $f_basic.opposite -text "Opposite edge" -variable \
            [namespace which -variable ns_data](transfer_edge) -value "opposite"] \
            -side top -anchor nw
        pack [frame $f_basic.foo] -side top -anchor nw -fill both -expand true
        
        # Done with the basic page here
        
        # Make the frame for showing the matrix of rise/fall setup/hold extra cuts
        pack [label $f_advanced.l0 -text "You can override the data transfer edges\
            that this script analyzes or cuts by default."] \
            -side top -anchor nw
        pack [label $f_advanced.l1 -text "All transfers with\
            a check mark will be cut. All transfers without a check mark will be analyzed."] \
            -side top -anchor nw
#        pack [label $f_advanced.l2 -text "Non-default false paths are typically\
#            used for interfaces with a divided down clock."] \
#            -side top -anchor nw
        pack [Separator $f_advanced.sep] -side top -fill x -expand true -pady 5
        pack [checkbutton $f_advanced.cb -text "Override default data transfer\
            edge combinations" -variable \
            [namespace which -variable ns_data](advanced_false_paths)] \
            -side top -anchor nw
        
        # We need an extra frame to hold the setup and hold false path boxes
        set setup_hold_false_path_frame [frame $f_advanced.shf]
        
        set stf [TitleFrame $setup_hold_false_path_frame.setup -text "Setup false paths"]
        make_rise_fall_grid -var_name [namespace which -variable temp_setup_cuts] \
            -frame [$stf getframe] -data_key extra_setup_cuts

        set htf [TitleFrame $setup_hold_false_path_frame.hold -text "Hold false paths"]
        make_rise_fall_grid -var_name [namespace which -variable temp_hold_cuts] \
            -frame [$htf getframe] -data_key extra_hold_cuts
        
        $f_advanced.cb configure -command [namespace code enable_disable_advanced_false_paths]
            
        # Pack the setup and hold text frames in
        pack $stf -side left -anchor nw
        pack $htf -side left -padx 8 -anchor nw

        # Pack the frame that holds the setup and hold frames and the switch button
        pack $setup_hold_false_path_frame -side top -anchor nw -fill x -expand true
 
        $dt_nb compute_size
        $dt_nb raise "basic"
        grid $dt_nb -sticky news -pady 5
#        pack $dt_nb -side top -fill x -expand true -pady 8
        
        #########################################################
        # Choices for the alignment. Choices depend on whether it's SDR or DDR
        set al_tf [TitleFrame $f.alignment -text "Source synchronous clock/data alignment" -ipad 8]
        set ssub_f [$al_tf getframe]
        
        # Intro text is common
        pack [label $ssub_f.la -text "How is the clock aligned with the data\
            at the IO pins,\
            and which direction is it shifted to achieve that alignment?" ] \
            -side top -anchor nw
        pack [Separator $ssub_f.sep] -fill x -expand true -pady 5

        # Separate pages for SDR and DDR
        set rate_pm [PagesManager $ssub_f.pm]
        set ddr_f [$rate_pm add "ddr"]
        set sdr_f [$rate_pm add "sdr"]
        
        # Edge aligned DDR
        pack [label $ddr_f.ea -text "Edge aligned (also known as\
            source simultaneous)"] -side top -anchor nw
        pack [radiobutton $ddr_f.zero -text "0 degree shift" -variable \
            [namespace which -variable ns_data](degree_shift) -value 0] \
            -side top -anchor nw
        pack [radiobutton $ddr_f.oneeighty -text "+/- 180 degree shift" -variable \
            [namespace which -variable ns_data](degree_shift) -value 180] \
            -side top -anchor nw
        
        # Center aligned DDR
        pack [label $ddr_f.ca -text "Center aligned (also known as\
            source centered)"] -side top -anchor nw
        pack [radiobutton $ddr_f.plusninety -text "+90 degree shift" -variable \
            [namespace which -variable ns_data](degree_shift) -value 90] \
            -side top -anchor nw
        pack [radiobutton $ddr_f.minusninety -text "-90 degree shift" -variable \
            [namespace which -variable ns_data](degree_shift) -value -90] \
            -side top -anchor nw

        # Edge aligned SDR
        pack [label $sdr_f.ea -text "Edge aligned (also known as\
            source simultaneous)"] -side top -anchor nw
        pack [radiobutton $sdr_f.zero -text "0 degree shift" -variable \
            [namespace which -variable ns_data](degree_shift) -value 0] \
            -side top -anchor nw
        
        # Center aligned SDR
        pack [label $sdr_f.ca -text "Center aligned (also known as\
            source centered)"] -side top -anchor nw
        pack [radiobutton $sdr_f.oneeighty -text "+/- 180 degree shift" -variable \
            [namespace which -variable ns_data](degree_shift) -value 180] \
            -side top -anchor nw

        $rate_pm raise "ddr"
        $rate_pm compute_size
        pack $rate_pm -side top -anchor nw
        
        # Other aligned is common to SDR and DDR
        pack [label $ssub_f.oa -text "Other amount"] \
            -side top -anchor w
        frame $ssub_f.other_frame
        pack [radiobutton $ssub_f.other_frame.other -variable \
            [namespace which -variable ns_data](degree_shift) -value "other"] \
            -side left
        pack [entry $ssub_f.other_frame.oe -width 4 -textvariable \
            [namespace which -variable other_shift]] -side left
        pack [label $ssub_f.other_frame.ol -text " degree shift"] -side left
        pack $ssub_f.other_frame -side top -anchor nw
        
        grid $al_tf -sticky news 
        # Pack in the alignment title frame
#        pack $al_tf -side top -anchor nw -fill x -expand true

        # Grid in a dummy frame to take up space
        grid [frame $f.foo] -sticky news
        grid rowconfigure $f 3 -weight 1
        grid columnconfigure $f 0 -weight 1
#        return $nav_frame
    }
    
    
    ####################################
    proc make_rise_fall_grid { args } {

        set options {
            { "var_name.arg" "" "Variable name for checkboxes" }
            { "frame.arg" "" "Frame to make it in" }
            { "data_key.arg" "" "Key in shared_data array for list to work on"}
        }
        array set opts [::cmdline::getoptions args $options]

        set f $opts(frame)

        grid x [label $f.tr -text "Dest rise"] [label $f.tf -text "Dest fall"]
        grid [label $f.lr -text "Source rise"] \
            [checkbutton $f.rr -variable ${opts(var_name)}(rise,rise) \
                -command [namespace code [list get_advanced_transfer_edges \
                    -array_name $opts(var_name) -value "rise,rise" \
                    -data_key $opts(data_key)]]] \
            [checkbutton $f.rf -variable ${opts(var_name)}(rise,fall) \
                -command [namespace code [list get_advanced_transfer_edges \
                    -array_name $opts(var_name) -value "rise,fall" \
                    -data_key $opts(data_key)]]]
        grid [label $f.lf -text "Source fall"] \
            [checkbutton $f.fr -variable ${opts(var_name)}(fall,rise) \
                -command [namespace code [list get_advanced_transfer_edges \
                    -array_name $opts(var_name) -value "fall,rise" \
                    -data_key $opts(data_key)]]] \
            [checkbutton $f.ff -variable ${opts(var_name)}(fall,fall) \
                -command [namespace code [list get_advanced_transfer_edges \
                    -array_name $opts(var_name) -value "fall,fall" \
                    -data_key $opts(data_key)]]]
    }
    
    ###########################################
    # Populate the advanced transfer edge checkboxes
    proc set_advanced_transfer_edges { args } {
    
        variable temp_setup_cuts
        variable temp_hold_cuts
        variable ns_data
        
        foreach combo [array names temp_setup_cuts] {
            set temp_setup_cuts($combo) \
                [expr { -1 != [lsearch $ns_data(extra_setup_cuts) $combo] }]
        }
        foreach combo [array names temp_hold_cuts] {
            set temp_hold_cuts($combo) \
                [expr { -1 != [lsearch $ns_data(extra_hold_cuts) $combo] }]
        }
        
    }
    
    ###########################################
    # Set the extra setup/hold cuts values based on the checkbox values
    proc get_advanced_transfer_edges { args } {

        set options {
            { "array_name.arg" "" "Name for the checkbutton array" }
            { "data_key.arg" "" "Variable to put or remove values from" }
            { "value.arg" "" "rise/fall value"}
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable ns_data
        
        upvar $opts(array_name) arr

        if { $arr($opts(value)) } {
            lappend ns_data($opts(data_key)) $opts(value)
        } else {
            set item_index [lsearch $ns_data($opts(data_key)) $opts(value)]
            set ns_data($opts(data_key)) [lreplace $ns_data($opts(data_key)) $item_index $item_index]
        }
        
    }
    
    #########################################
    # Enable or disable the advanced false path frame, depending on whether or
    # not you're using advanced false paths.
    proc enable_disable_advanced_false_paths { args } {
    
        set options {
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable ns_data
        variable setup_hold_false_path_frame

        if { $ns_data(advanced_false_paths) } {
            set state "normal"
        } else {
            set state "disabled"
        }

        util::recursive_widget_state -widget $setup_hold_false_path_frame -state $state
    }
    
    ##########################################
    # Initialize some values in the relationships tab
#            { "register_id.arg" "" "Data register ID" }
    proc init_relationship_info { args } {

        set options {
            { "data.arg" "" "Flat array of data" }
            { "data_rate.arg" "" "sdr or ddr" }
            { "clock_configuration.arg" "" "clock configuration" }
            { "src_clocks.arg" "" "Source clock tree names" }
            { "dest_clocks.arg" "" "Destination clock tree names" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable ns_data
        variable other_data
        variable other_shift
#        variable register_id
        variable old_data
        variable old_other_shift
        variable data_list
        variable src_clocks
        variable dest_clocks
        
        # Init the data for the namespace
        if { 0 < [llength $opts(data)] } {
        
            array set temp $opts(data)
            
            foreach k [array names ns_data] {
                set ns_data($k) $temp($k)
                unset temp($k)
            }
            foreach k [array names other_data] {
                set other_data($k) $temp($k)
                unset temp($k)
            }

            if { 0 < [array size temp] } {
                post_message -type warning "More data than expected when\
                    initializing clock_relationship: [array names temp]"
            }
            
            # Clear out old data
            set old_other_shift ""
            set other_shift ""
            array unset old_data
            array set old_data $data_list
            
        }
        # End of batch init data
        
        # Set up the degree shift appropriately based on the data rate
        if { ! [string equal "" $opts(data_rate)] } {
            set other_data(data_rate) $opts(data_rate)
        }

        # Handle updates to clock configuration
        if { ! [string equal "" $opts(clock_configuration)] } {
            set other_data(clock_configuration) $opts(clock_configuration)
        }

        # Init clock tree names
        if { 0 < [llength $opts(src_clocks)] } {
            set src_clocks $opts(src_clocks)
        }
        if { 0 < [llength $opts(dest_clocks)] } {
            set dest_clocks $opts(dest_clocks)
        }

    }

    ##################################################
    proc pre_validate_and_initialize { args } {
    
        set options {
            { "error_messages_var.arg" "" "Name of the variable to hold error messages" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable ns_data
        variable other_data
        
        # Things are valid or not. If anything is invalid, set to zero.
        set is_valid 1
        
        # Things for this page
        
        # We may want to get error messages back. If we do, hook
        # up the error messages var to the specified variable.
        if { [string equal "" $opts(error_messages_var)] } {
            set error_messages [list]
        } else {
            upvar $opts(error_messages_var) error_messages
        }
                
        # Data rate comes from the data_ports page, so it's not OK if it's blank 
        switch -exact -- $other_data(data_rate) {
            "sdr" {
                # SDR can do zero degrees, or +/-180, or something custom.
                # Edge aligned covers 0, and center covers +/-180
                switch -exact -- $ns_data(degree_shift) {
                    0 -
                    180 { }
                    default {
                        set other_shift $ns_data(degree_shift)
                        set ns_data(degree_shift) "other"
                    }
                }
            }
            "ddr" {
                # DDR can do more shifts that aren't custom.
                # Edge aligned covers both 0 and 180, and center covers +/-90.
                switch -exact -- $ns_data(degree_shift) {
                    0 -
                    90 -
                    -90 -
                    180 { }
                    default {
                        set other_shift $ns_data(degree_shift)
                        set ns_data(degree_shift) "other"
                    }
                }
            }
            "" {
                lappend error_messages [list "You must choose the I/O ports or\
                    bus to configure before you can configure the clock relationship"]
                set is_valid 0
            }
            default {
                lappend error_messages [list "The value for data_rate is invalid:\
                    $other_data(data_rate)"
                set is_valid 0
            }
        }
        
        return $is_valid
    }
    
    ##############################################
    proc prep_for_raise { args } {
    
        variable ns_data
        variable other_data
        
        # We have to have a transfer edge set for the radio buttons
        switch -exact -- $ns_data(transfer_edge) {
            "same" -
            "opposite" { }
            "" { set ns_data(transfer_edge) "same" }
            default {
                return -code error "The value for transfer_edge\
                    must be same or opposite but is $ns_data(transfer_edge)"
            }
        }
        
        # TODO - describe exactly why this is here :-)
        set_advanced_transfer_edges

        # Advanced false paths
        # We have to have a value for the advanced_false_paths checkbox 
        # Force to accept only values of 0 or 1 - if the value is 0 or 1,
        # leave it alone. Else, force to 0
        switch -exact -- $ns_data(advanced_false_paths) {
            "0" -
            "1" { }
            "" { set ns_data(advanced_false_paths) 0 }
            default {
                return -code error "The value for advanced_false_paths\
                    must be 0 or 1 but is $ns_data(advanced_false_paths)"
            }
        }

        # Init the degree shift if it's blank
        # We have to have a degree shift set for the radio buttons
        if { [string equal "" $ns_data(degree_shift)] } {
            set ns_data(degree_shift) 0
        }
        
        # Configure the alignment frame for source sync
        configure_alignment_frame -is_source_sync \
            [regexp {source_sync} $other_data(clock_configuration)]
        
        # Set up the alignment frame
        # Set up the degree shift appropriately based on the data rate 
        configure_alignment_frame -data_rate $other_data(data_rate)
        
        # Are we using advanced false paths?
        enable_disable_advanced_false_paths
        
    }
    
    #############################################
    # Get the data to save it into the tree
    proc get_shared_data { args } {
    
        set options {
            { "keys.arg" "" "Variables to get" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable ns_data
        variable other_shift
        
        array set temp [array get ns_data]
        if { [string equal "other" $temp(degree_shift)] } {
            set temp(degree_shift) $other_shift
        }

        if { 0 == [llength $opts(keys)] } {
            return [array get temp]
        } else {
            set to_return [list]
            foreach key $opts(keys) {
                if { ! [info exists temp($key)] } {
                    post_message -type warning "Can't find value for $key \
                        in clock_relationship namespace"
                    lappend to_return $key
                    lappend to_return {}
                } else {
                    lappend to_return $key $temp($key)
                }
            }
            return $to_return
        }

    }

    ###########################################################
    # Fill the comboboxes with the source and dest clocks that
    # have been constrained for the interface
    # Before filling, check whether the previously chosen clock
    # name exists in the current list of clock names.
    # If it does, let it be the one selected
    # If it doesn't, default to the first value in the combobox list
    proc fill_src_and_dest_clock_comboboxes { args } {
    
        variable src_clock_cb
        variable dest_clock_cb
        variable ns_data
        variable src_clocks
        variable dest_clocks
        
#        array set temp [clocks_info::src_and_dest_clocks]

        # A list to return when previously saved clock names don't
        # exist any more
        set nonexistant_clocks [list]
        
        # Do it for the source clock
        # Keep the name of the previous clock
        # Search the list of existing source clocks to see whether the
        # previous clock name still exists
        # Set the combobox to be the list of existing source clocks
        # If the previous clock name does not
        # exist now, set a value.
        # If the previous clock name was not blank, put it
        # on the nonexistant clocks list to return
        set old_src_clock_name $ns_data(src_clock_name)
        # lsearch was in temp(src_clocks)
        set src_clock_name_index [util::lsearch_with_brackets \
            $src_clocks $ns_data(src_clock_name)]
        # combobox configure values was temp(src_clocks)
        $src_clock_cb configure -values $src_clocks
        if { -1 == $src_clock_name_index } {
            $src_clock_cb setvalue first
            if { ! [string equal "" $old_src_clock_name] } {
                lappend nonexistant_clocks $old_src_clock_name
            }
        }
        
        # Do it for the destination clock
        set old_dest_clock_name $ns_data(dest_clock_name)
        # lsearch was in temp(dest_clocks)
        set dest_clock_name_index [util::lsearch_with_brackets \
            $dest_clocks $ns_data(dest_clock_name)]
        # combobox configure values was temp(dest_clocks)
        $dest_clock_cb configure -values $dest_clocks
        if { -1 == $dest_clock_name_index } {
            $dest_clock_cb setvalue first
            if { ! [string equal "" $old_dest_clock_name] } {
                lappend nonexistant_clocks $old_dest_clock_name
            }
        }
        
        # Warn if previously used clocks don't exist this time
        if { 0 < [llength $nonexistant_clocks] } {
            set error_messages [list]
            lappend error_messages [list "The following clocks were used to constrain this\
                interface, but they don't currently exist:" [list $nonexistant_clocks]]
            tk_messageBox -icon warning -type ok -default ok \
                -title "Clock warning" -parent [focus] -message \
                [util::make_message_for_dialog -messages \
                [list "Review the source and destination clocks" $error_messages]]
        }
        
#        return $nonexistant_clocks
    }

    ##############################################################
    # If the interface is source sync, the clock/data alignment
    # frame must be enabled.
    # If the interface is not, the clock/data alignment frame
    # must be disabled
    proc configure_alignment_frame { args } {

        set options {
            { "is_source_sync.arg" "" "Is this a source sync interface?" }
            { "data_rate.arg" "" "SDR or DDR" }
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable al_tf
        variable rate_pm
        
        switch -exact -- $opts(is_source_sync) {
            "0" {
                util::recursive_widget_state -widget $al_tf -state "disabled"
                util::recursive_widget_state -widget [$al_tf getframe] \
                    -state "disabled"
            }
            "1" {
                util::recursive_widget_state -widget $al_tf -state "normal"
                util::recursive_widget_state -widget [$al_tf getframe] \
                    -state "normal"
            }
            "" { }
            default {
                return -code error "Unknown value for is_source_sync in\
                    configure_alignment_frame: $opts(is_source_sync)"
            }
        }
        
        switch -exact -- $opts(data_rate) {
            "sdr" -
            "ddr" {
                $rate_pm raise $opts(data_rate)
            }
            "" { }
            default {
                return -code error "Unknown value for data_rate in\
                    configure_alignment_frame: $opts(data_rate)"
            }
        }
    }

    ##############################################################
    proc validate_relationship_info { args } {
    
        set options {
            { "data_var.arg" "" "Name of the variable to populate with results" }
            { "error_messages_var.arg" "" "Name of the variable to hold error messages" }
            { "pre_validation.arg" "" "What to do for pre-validation" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable ns_data
        variable other_data
        variable other_shift
        
        # Things are valid or not. If anything is invalid, set to zero.
        set is_valid 1
        
        # We may want to get information back, particularly during the back/next
        # process. If there's no data variable specified, set up a dummy
        # array to hold the results. Else connect the results array to the
        # variable for the data.
        if { [string equal "" $opts(data_var)] } {
            array set results [list]
        } else {
            upvar $opts(data_var) results
        }
        
        # We may want to get error messages back. If we do, hook
        # up the error messages var to the specified variable.
        if { [string equal "" $opts(error_messages_var)] } {
            set error_messages [list]
        } else {
            upvar $opts(error_messages_var) error_messages
        }

        # Do pre-validation
        switch -exact -- $opts(pre_validation) {
            "skip" { }
            "run_and_return" -
            "return_on_invalid" {
                # We need clock_configuration so the alignment frame can be enabled
                # or disabled appropriately.
                # clock_configuration comes from the previous page, so if it's blank
                # it's bad. 
                if { [string equal "" $other_data(clock_configuration)] } {
                    lappend error_messages [list "You must choose the clock\
                        configuration before you can configure the clock relationship"]
                    set is_valid 0
                }
                # We need data rate
                if { [string equal "" $other_data(data_rate)] } {
                    lappend error_messages [list "You must choose the I/O ports or\
                        bus to configure before you can configure the clock relationship"]
                    set is_valid 0
                }
            }
            default {
                return -code error "Unknown option for -pre_validation in\
                    validate_relationship_info: $opts(pre_validation)"
            }
        }
        switch -exact -- $opts(pre_validation) {
            "skip" { }
            "run_and_return" { return $is_valid }
            "return_on_invalid" { if { ! $is_valid } { return $is_valid } }
        }
        # End of pre-validation
        
        
        # Ensure there are clocks selected
        if { [string equal "" $ns_data(src_clock_name)] } {
            lappend error_messages [list "No source clock is selected for the interface.\
                Select a source clock from the list of valid clocks"]
            set is_valid 0
        }
        if { [string equal "" $ns_data(dest_clock_name)] } {
            lappend error_messages [list "No destination clock is selected for the interface.\
                Select a destination clock from the list of valid clocks"]
            set is_valid 0
        }
        # Ensure there's a data transfer edge selected
        switch -exact -- $ns_data(transfer_edge) {
            "same" -
            "opposite" {
                # Good
            }
            default {
                lappend error_messages [list "You must select same or opposite\
                    edge data transfer."]
                set is_valid 0
            }
        }
        
        # If it's source sync, ensure there's a phase shift selected
        switch -exact -- $other_data(clock_configuration) {
            "source_sync_source_clock" -
            "source_sync_dest_clock" {
                switch -exact -- $ns_data(degree_shift) {
                    0 -
                    90 -
                    -90 -
                    180 { }
                    "other" {
                        # Make sure there's a value in other_shift
                        if { [string equal "" $other_shift] } {
                        
                            lappend error_messages [list "No phase shift is entered\
                                for the clock/data alignment. You must enter a phase shift"]
                            set is_valid 0
                            
                        } elseif { ![string is double $other_shift] } {
                            
                            set sub_msg [list "The invalid phase shift value is $other_shift"]
                            lappend error_messages [list "The phase shift entered\
                                for the clock/data alignment is invalid.\
                                Enter a numeric value for the phase shift" [list $sub_msg]]
                            set is_valid 0
                        }
                    }
                    default {
                        lappend error_messages [list "No clock/data alignment value\
                            is selected. You must select one."]
                        set is_valid 0
                    }
                }
            }
            "system_sync_common_clock" -
            "system_sync_different_clock" { }
            default {
                return -code error "Unknown value for clock_configuration in\
                    validate_relationship_info: $other_data(clock_configuration)"
            }
        }
        
        # Figure out which clock has the shorter period, and pass that along
        # so the adjust end can be preset appropriately if it's blank
        # If the clocks are close, always prefer the dest.
        set src_period [get_clock_info -period \
            [util::get_clock_id -clock_name $ns_data(src_clock_name)]]
        set dest_period [get_clock_info -period \
            [util::get_clock_id -clock_name $ns_data(dest_clock_name)]]
        set period_ratio [expr { double($src_period/$dest_period) }]
        if { $period_ratio < 0.99 } {
            set shorter "src"
        } else {
            set shorter "dest"
        }
        
        if { $is_valid } {
        
            if { [string equal "other" $ns_data(degree_shift)] } {
                set ds $other_shift
            } else {
                set ds $ns_data(degree_shift)
            }
            
            array set results [list \
                "transfer_edge"     $ns_data(transfer_edge) \
                "src_clock_name"    $ns_data(src_clock_name) \
                "dest_clock_name"   $ns_data(dest_clock_name) \
                "degree_shift"      $ds \
                "extra_setup_cuts"  $ns_data(extra_setup_cuts) \
                "extra_hold_cuts"   $ns_data(extra_hold_cuts) \
                "advanced_false_paths" $ns_data(advanced_false_paths) \
                "shorter"           $shorter \
            ]
        }
        
        return $is_valid
    }
    
    #####################################################
    # Did the degree shift, source or dest clock names,
    # or transfer edge change since last time?
    proc relationship_info_changed { args } {
    
        set options {
            { "degree_shift" "Degree shift changed?" }
            { "transfer_edge" "Transfer edge changed?" }
            { "clock_names" "Source or dest clock names changed?" }
            { "advanced_false_paths" "Advanced false path stuff changed?" }
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable ns_data
        variable old_data
        variable other_shift
        variable old_other_shift
        
        if { [string equal "other" $ns_data(degree_shift)] } {
            set alignment_changed [expr { $other_shift != $old_other_shift }]
        } else {
            set alignment_changed [expr { $ns_data(degree_shift) != $old_data(degree_shift) }]
        }
        set transfer_edge_changed [expr { ![string equal \
            $ns_data(transfer_edge) $old_data(transfer_edge)] }]        
        set src_clock_name_changed [expr { ![string equal \
            $ns_data(src_clock_name) $old_data(src_clock_name) ] }]
        set dest_clock_name_changed  [expr { ![string equal \
            $ns_data(dest_clock_name) $old_data(dest_clock_name) ] }]
        set advanced_cuts_changed \
            [expr { $ns_data(advanced_false_paths) != $old_data(advanced_false_paths) }]
        
        # Special case for advanced transfer edge
        # If we're doing advanced false paths, did they change?
        if { $ns_data(advanced_false_paths) } {
            set advanced_cuts_changed [expr { $advanced_cuts_changed || \
                [util::check_lists_equal $ns_data(extra_setup_cuts) $old_data(extra_setup_cuts)] || \
                [util::check_lists_equal $ns_data(extra_hold_cuts) $old_data(extra_hold_cuts)] }]
        }
        
        if { $opts(degree_shift) } { return $alignment_changed }
        if { $opts(transfer_edge) } { return $transfer_edge_changed }
        if { $opts(clock_names) } {
            return [expr { $src_clock_name_changed || $dest_clock_name_changed }]
        }
        if { $opts(advanced_false_paths) } { return $advanced_cuts_changed }
        
    }
    
    ###################################################
    # Save data when we click back and land on the clock
    # relationship page. Then when we click next again,
    # we can compare the current values to the saved
    # values to see whether any stuff later has to be
    # recalculated
    proc copy_current_relationship_info_to_old { args } {
    
        variable ns_data
        variable old_data
        variable other_shift
        variable old_other_shift
        
        catch { array unset old_data }
        array set old_data [array get ns_data]
        set old_other_shift $other_shift
    }
    
}

################################################################################
# How to separate clock_diagram and requirements_info
# Numbers from requirements_info are required to draw waveforms
# They can also change, so should be passed by reference when the
# waveform is drawn.
# Clock waveforms can be drawn based on the source and destination clocks
# chosen in clock_relationships
# Anything that can't be changed on the requirements or targets tabs
# should be passed in to clock_diagram ahead of time
namespace eval clock_diagram {

    # GUI elements
    variable ic_can
    
    variable data_list [list \
        "data_register_names"   [list] \
        "src_clock_name"    "" \
        "dest_clock_name"   "" \
        "direction"         "" \
        "data_rate"         "" \
        "transfer_edge"     "" \
        "alignment_method"  "" \
        "extra_setup_cuts"  [list] \
        "extra_hold_cuts"   [list] \
        "degree_shift"      "" \
        "advanced_false_paths" "" \
    ]
    variable shared_data
    variable old_data
    array set shared_data $data_list 
    array set old_data $data_list

#    variable register_id
    variable diagram_dialog
    variable mult           20
    
    ########################################
    #
    proc assemble_tab { args } {

        set options {
            { "frame.arg" "" "Frame to assemble the tab on" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable ic_can
        
        set ssub_f $opts(frame)

        # Setup/hold relationship titleframe
#        set sh_tf [TitleFrame $f.setup_hold -text "Setup and hold relationships" \
#            -ipad 8]
#        set ssub_f [$sh_tf getframe]
#        pack [Separator $ssub_f.sep -relief groove] \
#            -side top -anchor n -fill x -expand true -pady 5            

        # Scrolled canvas to draw the clock waveforms
        set ic_sw [ScrolledWindow $ssub_f.sw -auto both -relief sunken]
        set ic_can [canvas $ic_sw.can -height 100 -width 400 \
            -scrollregion {-5000 0 5000 100} -bg white]
        $ic_sw setwidget $ic_can
        
        pack $ic_sw -side top -fill x -expand true
        pack $ic_can -side top -fill both -expand true
        
        # Frame to hold zoom in/out buttons
        set zoom_f [frame $ssub_f.zoom]
        pack [button $zoom_f.out -text "Zoom out" -state disabled -command \
            [namespace code [list zoom_canvas -canvas $ic_can -out]] ] \
            -side left
        pack [button $zoom_f.in -text "Zoom in" -state disabled -command \
            [namespace code [list zoom_canvas -canvas $ic_can -in]] ] \
            -side left
        pack $zoom_f -side top -anchor nw
        
        pack [label $ssub_f.l0 -text "Orange arrows show the setup relationship.\
            Blue arrows show the hold relationship."] \
            -side top -anchor nw
        pack [label $ssub_f.l1 -text "Dashed line arrows show the default setup\
            and hold relationships."] \
            -side top -anchor nw
        pack [label $ssub_f.l2 -text "Solid line arrows show the actual setup and\
            hold relationships." -justify left] \
            -side top -anchor nw

        # Pack the setup/hold relationship titleframe
#        pack $sh_tf -side top -fill x -expand true -pady 8
        
    }
    
    ###############################################################
    proc assemble_diagram_dialog { args } {

        set options {
            { "parent.arg" "" "Parent frame of the widgets" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable diagram_dialog
        
        set diagram_dialog [Dialog .cd_dialog -modal none -side bottom \
            -anchor c -parent $opts(parent) -place right \
            -title "Waveform Diagram" -default 0 -transient no]
        $diagram_dialog add -text "Close" -width 10 -command \
            [namespace code close_diagram_dialog]
        
        assemble_tab -frame [$diagram_dialog getframe]
        
        # Withdraw the window when you click X instead of deleting it
        wm protocol $diagram_dialog WM_DELETE_WINDOW \
            [namespace code close_diagram_dialog]
        
    }
    
    ################################################
    proc close_diagram_dialog { args } {
    
        variable diagram_dialog
        $diagram_dialog withdraw
        requirements_info::update_button
    }
    
    ##############################################################
    proc show_diagram_dialog { args } {
    
        variable diagram_dialog
        variable mult
        
        # For a non-modal dialog, this command returns immediately
        $diagram_dialog draw
        set mult 20
    }
    
    ######################################
#            { "register_id.arg" "" "ID of register being clocked" }
    proc init_diagram_info { args } {
    
        set options {
            { "data.arg" "" "Flat array of data" }
            { "update_direction.arg" "" "current direction" }
            { "data_rate.arg" "" "Double or single data rate" }
            { "transfer_edge.arg" "" "same or opposite" }
            { "data_register_names.arg" "" "Names of registers being clocked" }
            { "src_clock_name.arg" "" "Source clock name" }
            { "dest_clock_name.arg" " Destination clock name" }
            { "degree_shift.arg" "" "Degree shift" }
            { "extra_setup_cuts.arg" "" "Additional setup cuts" }
            { "extra_hold_cuts.arg" "" "Additional hold cuts" }
            { "advanced_false_paths.arg" "" "Advanced false paths" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data
#        variable register_id
        variable mult
        variable old_data
        variable data_list
        
        # Initialize the data from the tree
        if { 0 < [llength $opts(data)] } {
        
            array set temp $opts(data)
            
            foreach k [array names shared_data] {
                set shared_data($k) $temp($k)
                unset temp($k)
            }

            if { 0 < [array size temp] } {
                post_message -type warning "More data than expected when\
                    initializing clock_diagram: [array names temp]"
            }
if { 0 } {
            if { 0 == [llength $shared_data(extra_setup_cuts)] } {
                set shared_data(extra_setup_cuts) [list]
            }
            if { 0 == [llength $shared_data(extra_hold_cuts)] } {
                set shared_data(extra_hold_cuts) [list]
            }

            if { [string equal "" $shared_data(advanced_false_paths)] } {
                set shared_data(advanced_false_paths) 0
            }
}
            # Advanced false paths
            # Force to accept only values of 0 or 1 - if the value is 0 or 1,
            # leave it alone. Else, force to 0
            switch -exact -- $shared_data(advanced_false_paths) {
                "0" -
                "1" { }
                "" { set shared_data(advanced_false_paths) 0 }
                default {
                    return -code error "Unknown value for advanced_false_paths\
                        in init_diagram_info: $shared_data(advanced_false_paths)"
                }
            }
            # When the data is loaded in the first time,
            # reset the multiplier
            set mult 20
            
            # Clear out old data
            array unset old_data
            array set old_data $data_list
        }

        switch -exact -- $opts(data_rate) {
            "sdr" -
            "ddr" { set shared_data(data_rate) $opts(data_rate) }
            "" { }
            default {
                return -code error "Unknown value for data_rate in\
                    init_diagram_info: $opts(data_rate)"
            }
        }
                
        if { ![string equal "" $opts(update_direction)] } {
            set shared_data(direction) $opts(update_direction)
        }
        
        if { ![string equal "" $opts(transfer_edge)] } {
            set shared_data(transfer_edge) $opts(transfer_edge)
        }

        if { ![string equal "" $opts(extra_setup_cuts)] } {
            set shared_data(extra_setup_cuts) $opts(extra_setup_cuts)
        }

        if { ![string equal "" $opts(extra_hold_cuts)] } {
            set shared_data(extra_hold_cuts) $opts(extra_hold_cuts)
        }

        if { ![string equal "" $opts(advanced_false_paths)] } {
            set shared_data(advanced_false_paths) $opts(advanced_false_paths)
        }
if { 0 } {
        if { ![string equal "" $opts(register_id)] } {
            set register_id $opts(register_id)
        }
}
        if { 0 < [llength $opts(data_register_names)] } {
            set shared_data(data_register_names) $opts(data_register_names)
        }
        
        if { ![string equal "" $opts(src_clock_name)] } {
            set shared_data(src_clock_name) $opts(src_clock_name)
        }

        if { ![string equal "" $opts(dest_clock_name)] } {
            set shared_data(dest_clock_name) $opts(dest_clock_name)
        }

        if { ![string equal "" $opts(degree_shift)] } {
            set shared_data(degree_shift) $opts(degree_shift)
        }
        
    }
    
    ################################################
    proc erase_canvas { args } {
    
        set options {
            { "clocks" "Erase clocks" }
            { "default_relationship" "erase relationship arrows" }
            { "actual_relationship" "erase relationship arrows" }
            { "data" "erase data window" }
        }
        
        array set opts [::cmdline::getoptions args $options]
        variable ic_can
        
        if { $opts(clocks) } { $ic_can delete "src"; $ic_can delete "dest" } 
        if { $opts(default_relationship) } { $ic_can delete "default_arrow" } 
        if { $opts(actual_relationship) } { $ic_can delete "actual_arrow" } 
        if { $opts(data) } { $ic_can delete "data" }

    }
    
    #######################################3
    # 
    proc zoom_canvas { args } {
    
        set options {
            { "canvas.arg" "" "" }
            { "in" "Zoom in" }
            { "out" "Zoom out" }
            
        }
        array set opts [::cmdline::getoptions args $options]

        variable mult
        
        foreach { off_screen displayed } [$opts(canvas) xview] { break }
        set bbox [$opts(canvas) bbox all]
        foreach { x1 y1 x2 y2 } $bbox { break }
        set total_width [expr { $x2 - $x1 }]
        set left_boundary [expr { (double($off_screen) * $total_width) + $x1 }]
#        set display_width [expr { double($displayed) * $total_width }]
        set right_boundary [expr { (double($displayed) * $total_width) + $x1 }]
        set middle_of_window [expr { ($right_boundary + $left_boundary) / 2 }]
        
#        puts "offscreen is $off_screen and displayed is $displayed"
#        puts "bbox is $bbox"
#        puts "left boundary is $left_boundary"
#        puts "right boundary is $right_boundary"
#        puts "middle of window is $middle_of_window\n"
        if { $opts(in) } {
            $opts(canvas) scale all $middle_of_window 0 1.5 1.0
            set mult [expr { 1.5 * $mult }]
        } elseif { $opts(out) } {
            $opts(canvas) scale all $middle_of_window 0 0.75 1.0
            set mult [expr { 0.75 * $mult }]
        }
        
        $opts(canvas) config -scrollregion [$opts(canvas) bbox all]
    }
    
    ##############################################################
    proc draw_clocks { args } {

        log::log_message "\nDrawing clocks in the diagram dialog"
        log::log_message "-------------------------------------"
        
        set options {
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable shared_data
#        variable register_id
        variable ic_can
        variable mult
        
        array set setup_cut_edges [list]
        array set hold_cut_edges [list]

#            -register_name [get_node_info -name $register_id] 
        util::get_transfer_edge_cuts \
            -register_name [lindex $shared_data(data_register_names) 0] \
            -data_rate $shared_data(data_rate) \
            -transfer_edge $shared_data(transfer_edge) \
            -direction $shared_data(direction) \
            -io_timing_method "setup_hold" \
            -setup_cut_edges_var setup_cut_edges \
            -hold_cut_edges_var hold_cut_edges \
            -extra_setup_cuts $shared_data(extra_setup_cuts) \
            -extra_hold_cuts $shared_data(extra_hold_cuts) \
            -advanced_false_paths $shared_data(advanced_false_paths)
        set constraint_pairs [list "rise" "rise" "rise" "fall" "fall" "rise" "fall" "fall"]
        
        set src_clock_id [util::get_clock_id -clock_name $shared_data(src_clock_name)]
        set dest_clock_id [util::get_clock_id -clock_name $shared_data(dest_clock_name)]
        
        set src_clock_period [get_clock_info -period $src_clock_id]
        set dest_clock_period [get_clock_info -period $dest_clock_id]
        
        # Set bounds
        set min_time 0
        set max_time 0
        
        set setup_rel [list]
        set hold_rel [list]
        
        # Get the times of the default transfers
        foreach { from to } $constraint_pairs {
        
            # Do it if it's not cut
            if { ! $setup_cut_edges($from,$to) } {
            
                log::log_message "\nFinding setup relationship for $from $to edges"
                log::log_message "-------------------------------------------------"

                foreach { setup_launch_time setup_latch_time } \
                    [clocks_info::find_clock_relationship_2 \
                    -src_clock_id $src_clock_id -dest_clock_id $dest_clock_id \
                    -launch_edge $from -latch_edge $to -setup \
                    -dms 1 \
                    -dmh 0 \
                    -sms 1 \
                    -smh 0 ] { break }
                lappend setup_rel $setup_launch_time $setup_latch_time
                if { $setup_launch_time < $min_time } { set min_time $setup_launch_time }
                if { $setup_latch_time < $min_time } { set min_time $setup_latch_time }
                if { $setup_launch_time > $max_time } { set max_time $setup_launch_time }
                if { $setup_latch_time > $max_time } { set max_time $setup_latch_time }
            }
            
            # Do it if it's not cut
            if { ! $hold_cut_edges($from,$to) } {
            
                log::log_message "\nFinding hold relationship for $from $to edges"
                log::log_message "-------------------------------------------------"

                foreach { hold_launch_time hold_latch_time } \
                    [clocks_info::find_clock_relationship_2 \
                    -src_clock_id $src_clock_id -dest_clock_id $dest_clock_id \
                    -launch_edge $from -latch_edge $to -hold \
                    -dms 1 \
                    -dmh 0 \
                    -sms 1 \
                    -smh 0 ] { break }
                lappend hold_rel $hold_launch_time $hold_latch_time
                if { $hold_launch_time < $min_time } { set min_time $hold_launch_time }
                if { $hold_latch_time < $min_time } { set min_time $hold_latch_time }
                if { $hold_launch_time > $max_time } { set max_time $hold_launch_time }
                if { $hold_latch_time > $max_time } { set max_time $hold_latch_time }
            }
        }
        
        # I want to make sure I draw enough waveforms for people
        # to use with long multicycles. I could make the waveforms
        # dynamically lengthen as the canvas is zoomed out,
        # but this is good enough for now.
        # Choose the larger period
        # Draw 10 of the large period waveforms to the left of the
        # launch time.
        # Draw 10 of the large period waveforms to the right of the
        # latch time
        # Draw that length of the shorter period waveforms too
        # Move the canvas to make the middle of the launch/latch time
        # be the middle of the canvas
        # Scale it appropriately so the launch/latch time difference
        # is about 30% of the canvas width
        if { $src_clock_period > $dest_clock_period } {
            set max_period $src_clock_period
        } else {
            set max_period $dest_clock_period
        }
                
        set left_time [expr { $min_time - (10 * $max_period) }]
        set right_time [expr { $max_time + (10 * $max_period) }]
        
        # Draw the clock waveforms
        draw_diagram::draw_clock -canvas $ic_can -tags "src" \
            -y 5 -clock_id $src_clock_id \
            -left_bound $left_time -right_bound $right_time -mult $mult
        draw_diagram::draw_clock -canvas $ic_can -tags "dest" \
            -y 50 -clock_id $dest_clock_id \
            -left_bound $left_time -right_bound $right_time -mult $mult
            
        # Draw the default launch/latch times
        draw_relationship_arrows_2 -setup_times $setup_rel \
            -hold_times $hold_rel -type "default"

        $ic_can config -scrollregion [$ic_can bbox all]
        
    }
    
    ######################################
    proc draw_relationship_arrows_2 { args } {
    
        log::log_message "Calling draw_relationship_arrows_2 $args"
        set options {
            { "setup_times.arg" "" "Pairs of setup launch/latch" }
            { "hold_times.arg" "" "Pairs of hold launch/latch" }
            { "type.arg" "" "default or actual relationship" }
            { "tag.arg" "" "Tags to use" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable ic_can
        variable mult

        switch -exact -- $opts(type) {
            "actual" {
                set end_shift 3
                set width 2
                set dash ""
                set tag "actual_arrow"
            }
            "" {
                return -code error "Unspecified value for type in\
                    draw_relationship_arrows_2: $opts(type)"
            }
            default {
                set end_shift -3
                set width 2
                set dash "-"
                set tag "default_arrow"
            }
        }
        
        foreach { launch latch } $opts(setup_times) {
        
            $ic_can create line [expr { $mult * $launch + $end_shift }] 16 \
                [expr { $mult * $latch + $end_shift }] 49 \
                -fill orange -arrow last -width $width \
                -tag $tag -dash $dash
        }
        
        foreach { launch latch } $opts(hold_times) {
        
            $ic_can create line [expr { $mult * $launch - $end_shift }] 16 \
                [expr { $mult * $latch - $end_shift }] 49 \
                -fill blue -arrow first -width $width \
                -tag $tag -dash $dash
        }
        
    }
    
    ###########################################
    # For tsu, draw as edge - tsu, because positive tsu is left of edge
    # for th, draw as edge + th, because positive th is right of edge
    # for tco and min tco, draw as edge +, because positive is right of edge
    # for skew, draw +/- edge.
    # If there's a period shift, add or subtract that to/from the edge time
    # for valid windows, draw lines from a setup to the right toward a hold
    # for invalid windows, draw lines from a hold to the right toward a setup
    # for valid windows, draw lines from a tco to the right towards a mintco
    # for invalid windows, draw lines from a mintco to the right towards a tco
    # in other words, if the least value is a tsu or tco, draw valid to right
    # if least value is a th or mintco, draw invalid to right
    # Calculate the default setup relationship for the edge combination
    # we want (rr, rf, fr, ff). Then figure out what the hold relationship
    # needs to be. Calculate the default hold relationship 
    # I need to know what multicycle values to pass into find_clock_relationship
    # what values get added to launch and latch times to draw setup/hold
    proc draw_data_waveforms { args } {
    
        log::log_message "\nCreating data waveform diagram\n-----------------"
        
        set options {
            { "data_var.arg" "" "Data for the interface" }
        }
        array set opts [::cmdline::getoptions args $options]

        upvar 1 $opts(data_var) data

        variable shared_data
#        variable register_id
        variable ic_can
        variable mult
        
        # Default setup and hold multicycles
        set setup_dms 1
        set setup_dmh 0
        set setup_sms 1
        set setup_smh 0
        set hold_dms 1
        set hold_dmh 0
        set hold_sms 1
        set hold_smh 0
        
        set setup_times [list]
        set hold_times [list]

        array set setup_cut_edges [list]
        array set hold_cut_edges [list]
        set src_clock_id [util::get_clock_id -clock_name $shared_data(src_clock_name)]
        set dest_clock_id [util::get_clock_id -clock_name $shared_data(dest_clock_name)]

        set src_clock_period [get_clock_info -period $src_clock_id]
        set dest_clock_period [get_clock_info -period $dest_clock_id]
        foreach { dest_clock_phase foo } [sdc_info::get_complete_phase_shift \
            -clock_id $dest_clock_id] { break }
        foreach { src_clock_phase foo } [sdc_info::get_complete_phase_shift \
            -clock_id $src_clock_id] { break }

        # Delete the data waveform and arrows
        erase_canvas -data -actual_relationship
        
        # This gets the appropriate rise/fall combinations that are
        # valid for timing analysis.
#            -register_name [get_node_info -name $register_id] 
        util::get_transfer_edge_cuts \
            -register_name [lindex $shared_data(data_register_names) 0] \
            -data_rate $shared_data(data_rate) \
            -transfer_edge $shared_data(transfer_edge) \
            -direction $shared_data(direction) \
            -io_timing_method $data(io_timing_method) \
            -setup_cut_edges_var setup_cut_edges \
            -hold_cut_edges_var hold_cut_edges \
            -extra_setup_cuts $shared_data(extra_setup_cuts) \
            -extra_hold_cuts $shared_data(extra_hold_cuts) \
            -advanced_false_paths $shared_data(advanced_false_paths)
        set constraint_pairs [list "rise" "rise" "rise" "fall" "fall" "rise" "fall" "fall"]

#        set repeat_time [expr { $src_clock_period * $data(src_transfer_cycles) }]
#        if { 0 == $repeat_time } { set repeat_time $src_clock_period }


        # Calculate the data repeat time for subsequent data windows
        switch -exact -- $data(adjust_cycles) {
            "src" {
                set repeat_time [expr { $src_clock_period * $data(src_transfer_cycles) }]
                if { 0 == $repeat_time } { set repeat_time $src_clock_period }
            }
            "dest" {
                set repeat_time [expr { $dest_clock_period * $data(dest_transfer_cycles) }]
                if { 0 == $repeat_time } { set repeat_time $dest_clock_period }
            }
            default {
                return -code error "Unknown value for adjust_cycles in draw_data_waveform:\
                    $data(adjust_cycles)"
            }
        }

        
        # Calculate the shift amounts for drawing the data waveforms
        switch -exact -- $shared_data(alignment_method) {
            "period" {
                foreach { s h_src h_dest } [get_cycle_shifts_2 \
                    -direction $shared_data(direction) \
                    -adjust_cycles $data(adjust_cycles) \
                    -src_shift_cycles $data(src_shift_cycles) \
                    -dest_shift_cycles $data(dest_shift_cycles) \
                    -src_transfer_cycles $data(src_transfer_cycles) \
                    -dest_transfer_cycles $data(dest_transfer_cycles) \
                    -transfer_edge $shared_data(transfer_edge) \
                    -data_rate $shared_data(data_rate) \
                    -dest_clock_phase $dest_clock_phase \
                    -src_clock_phase $src_clock_phase \
                    -io_timing_method $data(io_timing_method)] { break }
                    
                # When we get here, setup and hold period adders are
                # the time amount that the setup and hold requirements get
                # shifted by. They're any additional periods necessary
                # for alignment, assuming a default clock setup/hold relationship
            }
            "mc" {
            
                # Get the setup and hold multicycles
                foreach { s_s h_s h_h } [get_cycle_shifts_2 \
                    -direction $shared_data(direction) \
                    -adjust_cycles $data(adjust_cycles) \
                    -src_shift_cycles $data(src_shift_cycles) \
                    -dest_shift_cycles $data(dest_shift_cycles) \
                    -src_transfer_cycles $data(src_transfer_cycles) \
                    -dest_transfer_cycles $data(dest_transfer_cycles) \
                    -transfer_edge $shared_data(transfer_edge) \
                    -data_rate $shared_data(data_rate) \
                    -dest_clock_phase $dest_clock_phase \
                    -src_clock_phase $src_clock_phase \
                    -io_timing_method $data(io_timing_method) \
                    -multicycle] { break }
                    
                # If the shift cycles target is the source clock,
                # what was returned is the source multicycle values
                # If it's the dest clock, what was returned is the
                # dest multicycle values
                switch -exact -- $data(adjust_cycles) {
                    "src" {
                        set setup_sms $s_s
                        set hold_sms $h_s
                        set hold_smh $h_h
                    }
                    "dest" {
                        set setup_dms $s_s
                        set hold_dms $h_s
                        set hold_dmh $h_h
                    }
                }
#puts "dms $dms dmh $dmh sms $sms smh $smh"
            }
            default {
                return -code error "Unknown value for alignment_method in\
                    draw_data_waveforms: $shared_data(alignment_method)"
            }
        }

        # Compute any necessary setup and hold adders. These are used when drawing
        # the waveforms
        switch -exact -- $data(io_timing_method) {
            "setup_hold" -
            "clock_to_out" {
                switch -exact -- $shared_data(alignment_method) {
                    "period" {
                        # Calculate the setup period adder, based on whether
                        # the shift is based on the source or destination clock
                        switch -exact -- $data(adjust_cycles) {
                            "src" {
                                set setup_period_adder [expr { $s * $src_clock_period }]
                            }
                            "dest" {
                                set setup_period_adder [expr { $s * $dest_clock_period }]
                            }
                            default {
                                return -code error "Unknown value for adjust_cycles\
                                    in draw_data_waveforms: $data(adjust_cycles)"
                            }
                        }
                        set hold_period_adder [expr { $h_src * $src_clock_period + \
                            $h_dest * $dest_clock_period }]                    
                    }
                    "mc" {
                        # If we're doing alignment with multicycles, there are no
                        # additional periods that get added or subtracted, so
                        # the setup and hold adders are zero.
                        # If we're doing skew timing, there is an additional setup/hold
                        # adder
                        # For setup/hold and clock to out timing,
                        # there's no adder necessary for period alignment,
                        # because the launch/latch values computed take
                        # the multicycle value into account
                        set setup_period_adder 0
                        set hold_period_adder 0
                    }
                    default {
                        return -code error "Unknown value for alignment_method in\
                            draw_data_waveforms: $shared_data(alignment_method)"
                    }
                }
            }
            "max_skew" -
            "min_valid" {
                # Regardless of the alignment method, we have to compute
                # setup and hold adders for skew
                switch -exact -- $data(adjust_cycles) {
                    "src" {
                        set setup_period_adder [expr { -1 * \
                            (double($shared_data(degree_shift)) / 360.0) * $src_clock_period }]
                        set hold_period_adder [expr {
                            (double($shared_data(degree_shift)) / 360.0) * $dest_clock_period \
                             }]
                    }
                    "dest" {
                        set setup_period_adder [expr { -1 * \
                            (double($shared_data(degree_shift)) / 360.0) * $dest_clock_period }]
                        set hold_period_adder [expr {
                            (double($shared_data(degree_shift)) / 360.0) * $dest_clock_period \
                             }]
                    }
                    default {
                        return -code error "Unknown value for adjust_cycles\
                            in draw_data_waveforms: $data(adjust_cycles)"
                    }
                }
            
            }
            default {
                return -code error "Unknown value for io_timing_method in\
                    draw_data_waveforms: $data(io_timing_method)"
            }
        }
        
        log::log_message " setup period adder is $setup_period_adder\
            and hold period adder is $hold_period_adder"

        # Get clock edges
        # Do this with the appropriate multicycles from the GUI
        foreach { from to } $constraint_pairs {
        
            # Do it if the relationship is not cut
            if { ! $setup_cut_edges($from,$to) } {
            
                log::log_message "\nFinding setup relationship for $from $to edges"
                log::log_message "-------------------------------------------------"

                foreach { setup_launch_time setup_latch_time } \
                    [clocks_info::find_clock_relationship_2 \
                    -src_clock_id $src_clock_id -dest_clock_id $dest_clock_id \
                    -launch_edge $from -latch_edge $to -setup \
                    -dms $setup_dms \
                    -dmh 0 \
                    -sms $setup_sms \
                    -smh 0 ] { break }
                log::log_message "  setup_launch_time is $setup_launch_time\
                    setup_latch_time is $setup_latch_time"

                draw_relationship_arrows_2 -setup_times \
                    [list $setup_launch_time $setup_latch_time] -type "actual"
                    
                # Add the correct things together based on io_timing_method
                switch -exact -- $data(io_timing_method) {
                    "setup_hold" {
                        set setup_time [expr { $setup_latch_time + \
                            $setup_period_adder - $data(setup) }]
                    }
                    "clock_to_out" {
                        set setup_time [expr { $setup_launch_time + \
                            $setup_period_adder + $data(tco_max) }]
                    }
                    "max_skew" {
                        # For output, do it off the latch time, and
                        # account for the degree_shift
                        set setup_time [expr { $setup_latch_time + \
                            $setup_period_adder - \
                            $data(max_skew) }]

                    }
                    "min_valid" {
                        post_message -type warning "min_valid is not supported by
                            draw_data_waveforms"
                    }
                    default {
                        return -code error "Unknown io_timing_method in draw_data_waveforms:
                            $data(io_timing_method)"
                    }
                }
                lappend setup_times $setup_time

            }
            
            # Do it if the relationship is not cut
            if { ! $hold_cut_edges($from,$to) } {
            
                log::log_message "\nFinding hold relationship for $from $to edges"
                log::log_message "-------------------------------------------------"
                
                foreach { hold_launch_time hold_latch_time } \
                    [clocks_info::find_clock_relationship_2 \
                    -src_clock_id $src_clock_id -dest_clock_id $dest_clock_id \
                    -launch_edge $from -latch_edge $to -hold \
                    -dms $hold_dms \
                    -dmh $hold_dmh \
                    -sms $hold_sms \
                    -smh $hold_smh ] { break }
                log::log_message "  hold_launch is $hold_launch_time\
                    hold_latch is $hold_latch_time"

                draw_relationship_arrows_2 -hold_times \
                    [list $hold_launch_time $hold_latch_time] -type "actual"

                # Add the correct things together based on io_timing_method
                switch -exact -- $data(io_timing_method) {
                    "setup_hold" {
                        set hold_time [expr { $hold_latch_time + \
                            $hold_period_adder + $data(hold) }]
                    }
                    "clock_to_out" {
                        set hold_time [expr { $hold_launch_time + \
                            $hold_period_adder + $data(tco_min) }]
                    }
                    "max_skew" {
                        set hold_time [expr { $hold_latch_time - \
                            $hold_period_adder + $data(max_skew) }]
                    }
                    "min_valid" {
                        post_message -type warning "min_valid is not supported by
                            draw_data_waveforms"
                    }
                    default {
                        return -code error "Unknown io_timing_method in draw_data_waveforms:
                            $data(io_timing_method"
                    }
                }
                lappend hold_times $hold_time

            }

        }

        # Get the sorted list of setup and hold times
        set setup_times [lsort -increasing -real $setup_times]
        set hold_times [lsort -increasing -real $hold_times]

        log::log_message "\nDone getting setup and hold times\n-----------------"
        log::log_message " Setup times are $setup_times"
        log::log_message " Hold times are $hold_times"

        # Check to make sure we have the same number of setup and hold times.
        # If we don't, we can't draw the diagram, because we don't know what
        # the correct windows are.
        set num_setup_times [llength $setup_times]
        set num_hold_times [llength $hold_times]
        
        if { $num_setup_times != $num_hold_times } {
        
            log::log_message "Unequal number of setup and hold times."

            set sub_msg [list]
            lappend sub_msg [list "Number of setup relationships: $num_setup_times"]
            lappend sub_msg [list "Number of hold relationships: $num_hold_times"]
            
            tk_messageBox -icon warning -type ok -default ok \
                -title "Waveform" -parent [focus] -message \
                [util::make_message_for_dialog -messages \
                [list "The data waveform will not be drawn because the number of\
                    setup and hold relationships is not equal." $sub_msg]]
            return
        } elseif { 0 == $num_setup_times } {
            log::log_message "No setup times."
            tk_messageBox -icon warning -type ok -default ok \
                -title "Waveform" -parent [focus] -message \
                "The data waveform will not be drawn because there are no\
                    valid setup relationships."
            return
        } elseif { 0 == $num_hold_times } {
            log::log_message "Unequal number of setup and hold times."
            tk_messageBox -icon warning -type ok -default ok \
                -title "Waveform" -parent [focus] -message \
                "The data waveform will not be drawn because there are no\
                    valid hold relationships."
            return
        }
        
        # Check to make sure that DDR times are interleaved.
        # SDR times always get something stuck on to interleave
        switch -exact -- [llength $setup_times] {
            "1" {
            
                set initial_setup [lindex $setup_times 0]
                set initial_hold [lindex $hold_times 0]
                set initial_setup_less_than_initial_hold \
                    [expr { $initial_setup < $initial_hold }]
                
                if { $initial_setup_less_than_initial_hold } {
                    lappend setup_times [expr { $initial_setup + $repeat_time }]
                } else {
                    lappend hold_times [expr { $initial_hold + $repeat_time }]
                }
            }
            default {
            
                foreach { setup_temp hold_temp } [interleave_setup_hold \
                    -setup_times $setup_times -hold_times $hold_times \
                    -repeat $repeat_time] { break }
                set setup_times [lsort -increasing -real $setup_temp]
                set hold_times [lsort -increasing -real $hold_temp]
                set initial_setup [lindex $setup_times 0]
                set initial_hold [lindex $hold_times 0]
                set initial_setup_less_than_initial_hold \
                    [expr { $initial_setup < $initial_hold }]
            }
        }

        # The state of the data window depends on the io timing method,
        # and whether the setup or hold number is less 
        switch -exact -- $data(io_timing_method) {
            "setup_hold" -
            "clock_to_out" {
                if { $initial_setup_less_than_initial_hold } {
                    set data_state "valid"
                } else {
                    set data_state "invalid"
                }
            }
            "max_skew" {
                # skew is opposite the setup/hold. Skew defines the data invalid
                # time, so setup before hold bounds the invalid time.
                if { $initial_setup_less_than_initial_hold } {
                    set data_state "invalid"
                } else {
                    set data_state "valid"
                }
            }
            "min_valid" {
                post_message -type warning "min_valid is not supported by
                    draw_data_waveforms"
            }
            default {
                return -code error "Unknown io_timing_method in draw_data_waveforms:
                    $data(io_timing_method"
            }
        }

        set setup_times [lsort -increasing -real $setup_times]
        set hold_times [lsort -increasing -real $hold_times]
        set num_setup_times [llength $setup_times]
        set num_hold_times [llength $hold_times]
        
        log::log_message " Updated setup times are $setup_times"
        log::log_message " Updated hold times are $hold_times"
        
        # prepare to draw the data windows
        # Walk through the lists of setup and hold times, which are boundaries
        # for the valid/invalid windows.
        # Valid and invalid windows alternate. 
        set done 0
        set setup_index 0
        set hold_index 0
        while { ! $done } {
        
            set setup [lindex $setup_times $setup_index]
            set hold [lindex $hold_times $hold_index]
            if { $setup < $hold } {
                set left $setup
                set right $hold
            } else {
                set left $hold
                set right $setup
            }
            draw_diagram::draw_data_window -canvas $ic_can \
                -tags "data" -y 70 -left $left -right $right \
                -type $data_state -mult $mult
            log::log_message " $data_state window between $left and $right"
            switch -exact -- $data_state {
                "valid" {
                    switch -exact -- $data(io_timing_method) {
                        "setup_hold" -
                        "clock_to_out" { incr setup_index }
                        "max_skew" -
                        "min_valid" { incr hold_index }
                    }
                    set data_state "invalid"
                }
                "invalid" {
                    switch -exact -- $data(io_timing_method) {
                        "setup_hold" -
                        "clock_to_out" { incr hold_index }
                        "max_skew" -
                        "min_valid" { incr setup_index }
                    }
                    set data_state "valid"
                }
                default {
                    return -code error "Unknown value for data_state in\
                        draw_data_waveforms: $data_state"
                }
            }
            if { $setup_index == $num_setup_times || $hold_index == $num_hold_times } {
                set done 1
            }
        }
    }
    
    ##############################################
    # Return interleaved setup/hold times
    # For DDR, take the two that are closest to each other, and
    # add or subtract the repeat values appropriately.
    proc interleave_setup_hold { args } {
    
        set options {
            { "setup_times.arg" "" "Setup times" }
            { "hold_times.arg" "" "Hold times" }
            { "repeat.arg" "" "Repeat time" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        set setup_times $opts(setup_times)
        set hold_times $opts(hold_times)
        
        # Walk through the lists of times
        set done 0
        while { ! $done } {
        
            set setup_times [lsort -increasing -real $setup_times]
            set hold_times [lsort -increasing -real $hold_times]
        
            set setup_max [lindex $setup_times end]
            set setup_min [lindex $setup_times 0]
            set hold_max [lindex $hold_times end]
            set hold_min [lindex $hold_times 0]

            if { $setup_max < $hold_min } {
            
                set setup_prev_max [lindex $setup_times end-1]
                set hold_next_min [lindex $hold_times 1]
                
                lappend setup_times [expr { $setup_max + $opts(repeat) }] \
                    [expr { $setup_prev_max + $opts(repeat) }]
                lappend hold_times [expr { $hold_min - $opts(repeat) }] \
                    [expr { $hold_next_min - $opts(repeat) }]
                    
            } elseif { $setup_min > $hold_max } {
            
                set setup_next_min [lindex $setup_times 1]
                set hold_prev_max [lindex $hold_times end-1]
                
                lappend setup_times [expr { $setup_min - $opts(repeat) }] \
                    [expr { $setup_next_min - $opts(repeat) }]
                lappend hold_times [expr { $hold_max + $opts(repeat) }] \
                    [expr { $hold_prev_max + $opts(repeat) }]
                    
            } else {
                set done 1
            }
        }
        
        return [list $setup_times $hold_times]
    }
    
    ########################################
    # Return the number of clock cycles to shift
    # setup or hold numbers by
    proc get_cycle_shifts_2 { args } {
    
        log::log_message "Calling get_cycle_shifts_2 $args"
        
        set options {
            { "direction.arg" "" "input or output" }
            { "adjust_cycles.arg" "" "src or dest" }
            { "src_shift_cycles.arg" "" "from the gui" }
            { "dest_shift_cycles.arg" "" "from the gui" }
            { "src_transfer_cycles.arg" "" "from the gui" }
            { "dest_transfer_cycles.arg" "" "from the gui" }
            { "transfer_edge.arg" "" "same or opposite" }
            { "data_rate.arg" "" "sdr or ddr" }
            { "multicycle" "return actual MC values" }
            { "dest_clock_phase.arg" "" "Phase of destination clock" }
            { "src_clock_phase.arg" "" "Phase of source clock" }
            { "io_timing_method.arg" "" "I/O timing method" }
        }
        array set opts [::cmdline::getoptions args $options]
        
        # The calculation for the number of cycles to shift the setup
        # is common to everything.
        switch -exact -- $opts(adjust_cycles) {
            "src" {
                # setup_mc used to be src_shift_cycles + 1
                # setup_cycle stays at positive src_shift_cycles because it is the
                # number of pixels something gets shifted to draw it.
                set setup_cycle $opts(src_shift_cycles)
                set setup_rel_setup_mc [expr { -1 * $opts(src_shift_cycles) + 1 }]
                
                # If the setup shifts by x source cycles, hold shifts by that
                # many source cycles too
                set hold_src_cycle $opts(src_shift_cycles)
                set hold_dest_cycle 0
            }
            "dest" {
                set setup_cycle $opts(dest_shift_cycles)
                set setup_rel_setup_mc [expr { $opts(dest_shift_cycles) + 1 }]

                # If the setup shifts by x dest cycles, hold shifts by that
                # many dest cycles too.
                set hold_src_cycle 0
                set hold_dest_cycle $opts(dest_shift_cycles)
            }
            default {
                return -code error "Unknown value for adjust_cycles in\
                    get_cycle_shifts_2: $opts(adjust_cycles)"
            }
        }

        switch -exact -- $opts(io_timing_method) {
        "setup_hold" -
        "clock_to_out" {
        }
        }

        # Do the hold multicycle second
        if { [string equal "setup_hold" $opts(io_timing_method)] || \
            [string equal "clock_to_out" $opts(io_timing_method)] || \
            ([string equal "input" $opts(direction)] && [string equal "max_skew" $opts(io_timing_method)]) } {

            switch -exact -- $opts(data_rate) {
            "sdr" {

                # When you do SDR hold analysis, use the same DMS or SMS
                # as you do for setup analysis
                set hold_rel_setup_mc $setup_rel_setup_mc

                # If we're system centric SDR, use the transfer cycles number
                switch -exact -- $opts(adjust_cycles) {
                "src" {
                    set hold_src_cycle [expr { $hold_src_cycle + 1 - $opts(src_transfer_cycles) }]
#                    set hold_cycle [expr { $opts(src_shift_cycles) + 1 - \
#                        $opts(src_transfer_cycles) }]
                    set hold_rel_hold_mc [expr { $opts(src_transfer_cycles) - 1 }]
                }
                "dest" {
                    set hold_dest_cycle [expr { $hold_dest_cycle + 1 - $opts(dest_transfer_cycles) }]
#                    set hold_cycle [expr { $opts(dest_shift_cycles) + 1 - \
#                        $opts(dest_transfer_cycles) }]
                    set hold_rel_hold_mc [expr { $opts(dest_transfer_cycles) - 1 }]
                }
                default {
                    return -code error "Unknown value for adjust_cycles in\
                        get_cycle_shifts_2: $opts(adjust_cycles)"
                }
                }
            }
            "ddr" {
            
                # When you do DDR hold analysis, use a DMS or SMS of 1
#                set hold_rel_setup_mc 1
                set hold_rel_hold_mc 0
                # DDR ignores the transfer cycles values in the GUI
                # For DDR, the hold multicycle is directly related to the
                # setup multicycle, and is the number of cycles it has to
                # shift.
                switch -exact -- $opts(transfer_edge) {
                "same" {
                    if { $opts(dest_clock_phase) <= $opts(src_clock_phase) } {
                        set hold_rel_setup_mc [expr { 1 + $setup_rel_setup_mc }]
                    } else {
                        set hold_rel_setup_mc $setup_rel_setup_mc
                    }
#                    set hold_rel_setup_mc [expr { $setup_rel_setup_mc + 1 }]
 #                   if { $opts(dest_clock_phase) <= $opts(src_clock_phase) } {
 #                       set hold_rel_hold_mc [expr { -1 * $setup_rel_setup_mc }]
 #                   } else {
 #                       set hold_rel_hold_mc [expr { 1 - $setup_rel_setup_mc }]
 #                   }
                }
                "opposite" {
                    if { $opts(dest_clock_phase) <= $opts(src_clock_phase) } {
                        set hold_rel_setup_mc $setup_rel_setup_mc
                    } else {
                        set hold_rel_setup_mc [expr { 1 + $setup_rel_setup_mc }]
                    }
#                    set hold_rel_setup_mc [expr { $setup_rel_setup_mc }]
#                    if { $opts(dest_clock_phase) <= $opts(src_clock_phase) } {
#                        set hold_rel_hold_mc [expr { 1 - $setup_rel_setup_mc }]
#                    } else {
#                        set hold_rel_hold_mc [expr { -1 * $setup_rel_setup_mc }]
#                    }
                }
                default {
                    return -code error "Unknown value for transfer_edge in\
                        get_cycle_shifts_2: $opts(transfer_edge)"
                }
                }
                
                # For DDR, transfer cycles affects the hold multicycle
                # exactly the same regardless of the phase relationship
                switch -exact -- $opts(adjust_cycles) {
                "src" {
                    set hold_rel_hold_mc [expr { $hold_rel_hold_mc + $opts(src_transfer_cycles) - 1 }]
                    set hold_src_cycle [expr { $hold_src_cycle + 1 - $opts(src_transfer_cycles) }]
                    
                }
                "dest" {
                    set hold_rel_hold_mc [expr { $hold_rel_hold_mc + $opts(dest_transfer_cycles) - 1 }]
                    set hold_dest_cycle [expr { $hold_dest_cycle + 1 - $opts(dest_transfer_cycles) }]
                }
                default {
                    return -code error "Unknown value for adjust_cycles in\
                        get_cycle_shifts_2: $opts(adjust_cycles)"
                }
                }
                
                # Hold cycle is how many periods something needs to shift
                # if it's happening with periods
                #set hold_cycle [expr { -1 * $hold_rel_hold_mc }]
            }
            default {
                return -code error "Unknown data_rate in get_cycle_shifts_2:\
                    $opts(data_rate)"
            }
            }
            
        } else {
#        "max_skew" -
#        "min_valid" { }
            set hold_rel_setup_mc $setup_rel_setup_mc
            switch -exact -- $opts(adjust_cycles) {
            "src" {
                set hold_rel_hold_mc [expr { $opts(src_transfer_cycles) - 1 }]
                set hold_src_cycle [expr { $hold_src_cycle + 1 }]
            }
            "dest" {
                set hold_rel_hold_mc [expr { $opts(dest_transfer_cycles) - 1 }]
                set hold_dest_cycle [expr { $hold_dest_cycle + 1 }]
            }
            default {
                return -code error "Unknown value for adjust_cycles in\
                    get_cycle_shifts_2: $opts(adjust_cycles)"
            }
            }
#            set hold_cycle $setup_rel_setup_mc
#            set hold_cycle $setup_cycle

# When this was a switch statement, it had a closing brace here
        }
        
        if { $opts(multicycle) } {
            return [list $setup_rel_setup_mc $hold_rel_setup_mc $hold_rel_hold_mc]
        } else {
            return [list $setup_cycle $hold_src_cycle $hold_dest_cycle]
        }

    }

}

################################################################################
#
namespace eval board_info {

    variable data_list [list \
        "constraint_target"     "" \
        "data_trace_delay"      "" \
        "src_clock_trace_delay" "" \
        "dest_clock_trace_delay"    "" \
        "trace_propagation_rate"    "" \
    ]
    variable other_data_list [list \
        "clock_configuration"   "" \
        "direction"             "" \
    ]
    variable shared_data
    variable other_data
    variable old_data
    array set shared_data $data_list
    array set other_data $other_data_list
    array set old_data $data_list
    
    # GUI elements
    variable board_canvas
    variable board_tf
    variable propagation_widgets    [list]
    
    # For the units combobox
    variable units_list [list "ns" "ps" "mil" "in" "cm" "mm"]

    # delay_values backs the entry widgets in the GUI
    variable delay_values
    array set delay_values [list]
    
    # delay_units backs the comboboxes in the GUI
    variable delay_units
    array set delay_units [list]
    
    # canvas_item_configuration saves the attributes of the
    # items in the canvas when the board timing frame is disabled
    variable canvas_item_configuration

    # Used to tell whether a unit is a length unit, which requires
    # enabling the trace propagation widgets
    variable length_units [list "mil" "in" "cm" "mm"]
    
    #####################################################
    proc assemble_tab { args } {

        set options {
            { "frame.arg" "" "Frame to assemble the tab on" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data
        variable board_canvas
        variable board_tf
        variable propagation_widgets
        variable delay_values
        variable delay_units
        variable units_list
        
        set f $opts(frame)

        # Set up the nav frame
#        set nav_frame [frame $f.nav]
#        pack $nav_frame -side top -anchor nw -fill x -expand true

        # Set up title frame
        set target_tf [TitleFrame $f.tf -ipad 8 \
            -text "I/O timing requirements target"]
        set sub_f [$target_tf getframe]

        # Add instructions
        pack [label $sub_f.l -text "Do the interface timing requirements\
            apply to the FPGA or the external device it interfaces with?\
            \n\nYou cannot enter board trace delay information when the I/O\
            timing requirements are for the FPGA.\
            \nYou can enter board trace delay information only when the I/O\
            timing requirements are for the external device." -justify left] \
            -side top -anchor nw
        pack [Separator $sub_f.sep -relief groove] \
            -side top -anchor n -fill x -expand true -pady 5

        # choices for the target
        set f_boundary [frame $sub_f.boundary]
        pack [label $f_boundary.l -text "Interface timing requirements apply to"] \
            -side top -anchor w
        pack [radiobutton $f_boundary.rb0 -text "FPGA" \
            -variable [namespace which -variable shared_data](constraint_target) \
            -value "fpga"] \
            -side top -anchor w
        pack [radiobutton $f_boundary.rb1 -text "External device" \
            -variable [namespace which -variable shared_data](constraint_target) \
            -value "external"] \
            -side top -anchor w
        pack $f_boundary -side top -anchor nw

        grid $target_tf -sticky news

        # Add frame for board timing
        set board_tf [TitleFrame $f.bt -ipad 8 \
            -text "Board timing"]
        set sub_f [$board_tf getframe]
        
        # Put in the instructions
        pack [label $sub_f.l -text "Enter trace delay values" -justify left] \
            -side top -anchor nw
        pack [Separator $sub_f.sep -relief groove] -side top -fill x -expand true \
            -pady 5

        # Put in the canvas
        # This holds the diagram of the interface
        set board_canvas [canvas $sub_f.bc -height 120]
        pack $board_canvas -side top -anchor nw
        
        # Make a subframe to hold the grid where you enter trace delay values
        set ssub_f [frame $sub_f.f]
        grid [label $ssub_f.ldd0 -text "Data trace delay" -justify left] \
            [entry $ssub_f.dde -width 15 -textvariable \
                [namespace which -variable delay_values](data_trace) ] \
            [ComboBox $ssub_f.cbdd -values $units_list -width 4 -editable false \
                -textvariable [namespace which -variable delay_units](data_trace)] \
            -sticky w
        grid [label $ssub_f.lsc0 -text "Source clock trace delay" -justify left] \
            [entry $ssub_f.sce -width 15 -textvariable \
                [namespace which -variable delay_values](src_clock_trace) ] \
            [ComboBox $ssub_f.cbsc -values $units_list -width 4 -editable false \
                -textvariable [namespace which -variable delay_units](src_clock_trace)] \
            -sticky w -pady 5
        grid [label $ssub_f.ldc0 -text "Destination clock trace delay" -justify left] \
            [entry $ssub_f.dce -width 15 -textvariable \
                [namespace which -variable delay_values](dest_clock_trace) ] \
            [ComboBox $ssub_f.cbdc -values $units_list -width 4 -editable false \
                -textvariable [namespace which -variable delay_units](dest_clock_trace)] \
            -sticky w
        grid [label $ssub_f.lpd0 -text "Trace propagation rate" -justify left] \
            [entry $ssub_f.tpe -width 15 -textvariable \
                [namespace which -variable delay_values](trace_propagation) ] \
            [label $ssub_f.lpd1 -text "ps/in"] \
            -sticky w -pady 5
        set propagation_widgets [grid slaves $ssub_f -row 3]
        
        pack $ssub_f -side top -anchor nw
        grid $board_tf -sticky news -pady 5
        
        # Grid in an expanding frame to push everything else to the top
        grid [frame $f.foo] -sticky news
        grid rowconfigure $f 2 -weight 1
        
        # Set the resize behavior so the frames expand on resize
        grid columnconfigure $f 0 -weight 1
        
        # Configure entry widgets to highlight and unhighlight the diagram
        bind $ssub_f.dde <FocusIn> "[namespace code configure_trace_highlights] \
            -add_to_tag data_connection"
        bind $ssub_f.dde <FocusOut> "[namespace code configure_trace_highlights] \
            -remove_from_tag data_connection"
        bind $ssub_f.sce <FocusIn> "[namespace code configure_trace_highlights] \
            -add_to_tag src_clock_connection"
        bind $ssub_f.sce <FocusOut> "[namespace code configure_trace_highlights] \
            -remove_from_tag src_clock_connection"
        bind $ssub_f.dce <FocusIn> "[namespace code configure_trace_highlights] \
            -add_to_tag dest_clock_connection"
        bind $ssub_f.dce <FocusOut> "[namespace code configure_trace_highlights] \
            -remove_from_tag dest_clock_connection"
        
        # If we pick units that are length-based, enable the propagation rate entry
        $ssub_f.cbdd configure -modifycmd [namespace code on_delay_unit]
        $ssub_f.cbsc configure -modifycmd [namespace code on_delay_unit]
        $ssub_f.cbdc configure -modifycmd [namespace code on_delay_unit]

        # Respond to clicks on the constraint target radio buttons
        $f_boundary.rb1 configure -command "[namespace code gray_ungray_board_tf] \
            -state normal"
        $f_boundary.rb0 configure -command "[namespace code gray_ungray_board_tf] \
            -state disabled"
    }
    
    ########################################################
    # This procedure takes a string representation of a trace delay,
    # which consists of a value and a unit. It also takes the type
    # of delay it is, such as data, src_clock, or dest_clock.
    # It returns an array with information about the minimum and
    # maximum values that trace delay can have.
    # The information includes a variable name for the maximum value, a variable
    # name for the minimum value, the unit used in the trace delay
    # string, and a numeric representation of the maximum and minimum
    # values.
    # Example 1:
    # The trace delay value "1.2 ns" has its value of 1.2 and units of ns
    # Assume the type is data_trace
    # The maximum and minimum values that trace can have are the same: 1.2 ns.
    # Therefore, the string name of the maximum value is just "data_trace_delay"
    # and the string name of the minimum value is also "data_trace_delay"
    # The numeric maximum value is 1.2, and the numeric minimum value is 1.2
    # Example 2:
    # The trace delay value is "1000 +/- 50 mil"
    # Its value is "1000 +/- 50" and its units is mil
    # Assume the type is src_clock
    # The maximum delay value the trace can have is 1000 + 50
    # The minimum delay value the trace can have is 1000 - 50
    # The variable name of the maximum value is max_src_clock_trace_delay, and
    # the minimum is min_src_clock_trace_delay
    # The conversion expression is the string to convert mils to ns
    proc get_delay_info { args } {

        set options {
            { "string.arg" "" "delay string" }
            { "type.arg" "" "type of delay" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        array set results [list]
        
        # Get the min and max values
        if { [regexp {^(.*?)\s(\w+)$} $opts(string) -> value unit] } {
            # Happy

            # Get information for the unit
            set results(conversion_expression) [util::get_conversion_expression \
                -unit $unit]
            set results(unit) $unit
            
            if { [string is double $value] } {
                # It's just a single value for the max and the min
                # There are not separate max and min values. Min and max values
                # are the same.
                set results(max_var_name) "${opts(type)}_trace_delay"
                set results(min_var_name) "${opts(type)}_trace_delay"
                set results(max_value) $value
                set results(min_value) $value
                
            } elseif { [regexp {([\d\.]+)\s\+/-\s([\d\.]+)} $value -> nominal variation] } {
                # It's nominal with a variation
                # There are separate min and max values.
                if { [string is double $nominal] && [string is double $variation] } {
                    set results(max_var_name) "max_${opts(type)}_trace_delay"
                    set results(min_var_name) "min_${opts(type)}_trace_delay"
                    set results(max_value) "($nominal + $variation)"
                    set results(min_value) "($nominal - $variation)"
                } else {
                    return -code error "get_delay_info error: One of the following\
                        values is not a valid number: $nominal and $variation"
                }
            } elseif { [regexp {([\d\.]+)\s-\s([\d\.]+)} $value -> left right] } {
                # It's min and max
                if { [string is double $left] && [string is double $right] } {

                    set results(max_var_name) "max_${opts(type)}_trace_delay"
                    set results(min_var_name) "min_${opts(type)}_trace_delay"

                    if { $left < $right } {
                        set results(max_value) $right
                        set results(min_value) $left
                    } else {
                        set results(max_value) $left
                        set results(min_value) $right
                    }
                
                } else {
                    return -code error "get_delay_value error: One of the following\
                        values is not a valid number: $left and $right"
                }
            } else {
                # Nothing matched - that's bad.
                return -code error "Can't determine a numeric value in get_delay_info\
                    for $value"
            }
            
            return [array get results]
            
        } else {
            # There's a problem - we can't even get the value and unit
            # parts separate.
            return -code error "Can't extract value and units for $opts(string)"
        }
    }
    
    ########################################################
    proc delays_use_length_units { args } {
    
        variable delay_units
        
        set is_length 0
        foreach delay [array names delay_units] {
            # If the lsearch result is not -1 then it matched some element,
            # which means it is a length unit
            if { [is_length_unit -string $delay_units($delay)] } { set is_length 1 }                
        }
        return $is_length            
    }
    
    ########################################################
    proc is_length_unit { args } {

        set options {
            { "string.arg" "" "unit string" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        variable length_units
        return [expr { -1 != [lsearch $length_units $opts(string)] }]
    }
    
    ########################################################
    proc on_delay_unit { args } {

        set options {
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data
        variable propagation_widgets
        
        # Enable or disable the trace propagation frame
        if { [string equal "external" $shared_data(constraint_target)] } {
        
            if { [delays_use_length_units] } {
                foreach w $propagation_widgets {
                    util::recursive_widget_state -widget $w -state "normal" -exclude *.shell*
                }
            } else {
                foreach w $propagation_widgets {
                    util::recursive_widget_state -widget $w -state "disabled" -exclude *.shell*
                }
            }
        }        
    }
    
    ########################################################
    proc gray_ungray_board_tf { args } {
    
        set options {
            { "state.arg" "" "normal or disabled" }
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable board_canvas
        variable canvas_item_configuration
        variable board_tf
        
        # This accommodates a strange bug that occurs when a combobox
        # has focus, and you click either of the constraint target
        # radio buttons. Not only does the wizard lose focus, but it
        # also drops in the Windows window stacking order, so it is
        # behind the 3-step main GUI. Before enabling/disabling things
        # here, save the current focus (which is the wizard) so it
        # can be restored after the enable/disable.
        set current_focus [focus]
        
        switch -exact -- $opts(state) {
            "normal" {
                # If it's already normal, we don't need to do it again
                if { [string equal "normal" [$board_tf cget -state]] } { return }
                
                util::recursive_widget_state -widget $board_tf -state "normal"
                draw_diagram::enable_disable_canvas -canvas $board_canvas \
                    -restore -state_variable_name canvas_item_configuration
                    
                # Might need to disable propagation delay widgets
                on_delay_unit
            }
            "disabled" {
                # If we're already disabled, we don't need to do it again.
                if { [string equal "disabled" [$board_tf cget -state]] } { return }
                
                util::recursive_widget_state -widget $board_tf -state "disabled"
                draw_diagram::enable_disable_canvas -canvas $board_canvas \
                    -disable -state_variable_name canvas_item_configuration
            }
            default {
                return -code error "Invalid option for state in gray_ungray_board_tf:\
                    $opts(state)"
            }
        }
        
        focus $current_focus

    }
    
    ######################################################
    proc init_board_info { args } {
    
        set options {
            { "data.arg" "" "Flat array of data" }
            { "update_direction.arg" "" "current direction" }
            { "clock_configuration.arg" "" "Clocking configuration" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data
        variable other_data
        variable old_data
        variable clock_port_name_src
        variable clock_port_name_dest
        variable delay_values
        variable delay_units
        
        # Initialize data from the tree
        if { 0 < [llength $opts(data)] } {
        
            array set temp $opts(data)
            
            foreach k [array names shared_data] {
                set shared_data($k) $temp($k)
                unset temp($k)
            }

            foreach k [array names other_data] {
                set other_data($k) $temp($k)
                unset temp($k)
            }

            if { 0 < [array size temp] } {
                post_message -type warning "More data than expected when\
                    initializing board_info: [array names temp]"
            }
            
            # Copy the settings over to old_data before initing default values
            array unset old_data
            array set old_data [array get shared_data]
            
            # We have to have a constraint_target set for the radio button
            switch -exact -- $shared_data(constraint_target) {
                "fpga" -
                "external" { }
                "" { set shared_data(constraint_target) "fpga" }
                default {
                    return -code error "Unknown value for\
                        constraint_target in init_board_info:\
                        $shared_data(constraint_target)"
                }
            }

if { 0 } {            
            # We need a board_timing_method valeu for the radio button
            switch -exact -- $shared_data(board_timing_method) {
                "min_max" -
                "typ_tolerance" { }
                "" { set shared_data(board_timing_data) "typ_tolerance" }
                default {
                    return -code error "Unknown value for board_timing_method\
                        in init_board_info: $shared_data(board_timing_method)"
                }
            }
}

            # Process and fill trace delay values and units
            if { [regexp {^(.*)\s(\w+)$} $shared_data(data_trace_delay) -> \
                value unit] } {
                # Happy
                set delay_values(data_trace) $value
                set delay_units(data_trace) $unit
            } else {
                set delay_values(data_trace) ""
                set delay_units(data_trace) ""
            }
            
            # Process and fill source clock trace delay value and unit
            if { [regexp {^(.*)\s(\w+)$} $shared_data(src_clock_trace_delay) -> \
                value unit] } {
                # Happy
                set delay_values(src_clock_trace) $value
                set delay_units(src_clock_trace) $unit
            } else {
                set delay_values(src_clock_trace) ""
                set delay_units(src_clock_trace) ""
            }
            
            # Process and fill dest clock trace delay value and unit
            if { [regexp {^(.*?)\s(\w+)$} $shared_data(dest_clock_trace_delay) -> \
                value unit] } {
                # Happy
                set delay_values(dest_clock_trace) $value
                set delay_units(dest_clock_trace) $unit
            } else {
                set delay_values(dest_clock_trace) ""
                set delay_units(dest_clock_trace) ""
            }
            
            # Process and fill trace propagaion rate
            if { [string is double $shared_data(trace_propagation_rate)] } {
                set delay_values(trace_propagation) $shared_data(trace_propagation_rate)
            } else {
                set delay_values(trace_propagation) ""
            }
if { 0 } {
            if { [regexp {^(.*)\s(\w+)$} $shared_data(trace_propagation_rate) -> \
                value unit] } {
                # Happy
                set delay_values(trace_propagation) $value
                set delay_units(trace_propagation) $unit
            } else {
                set delay_values(trace_propagation) ""
                set delay_units(trace_propagation) ""
            }
}            
        }
        # Done initing based on initial data
        
        # Update the direction
        if { ![string equal "" $opts(update_direction)] } {
            set other_data(direction) $opts(update_direction)
        }

        # Update the clock configuration
        switch -exact -- $opts(clock_configuration) {
            "system_sync_common_clock" -
            "system_sync_different_clock" -
            "source_sync_source_clock" -
            "source_sync_dest_clock" {
                set other_data(clock_configuration) $opts(clock_configuration)
            }
            "" { }
            default {
                return -code error "Unknown value for clock_configuration\
                    in init_board_info: $opts(clock_configuration)"
            }
        }
    }
    
    ######################################################
    proc board_info_changed { args } {
    
        set options {
            { "constraint_target" "Did the constraint target change?" }
            { "trace_delays" "Did the trace delays change?" }
        }
        array set opts [::cmdline::getoptions args $options]
        variable shared_data
        variable old_data
        
        # Did the constraint target change?
        if { $opts(constraint_target) } {
            return [expr { ! [string equal \
                $shared_data(constraint_target) $old_data(constraint_target)] }]
        }
        
        # Did any trace delays change?
        if { $opts(trace_delays) } {
        
            # Trace delays changed if any one of them changed
            return [expr {
                ! [string equal $old_data(data_trace_delay) $shared_data(data_trace_delay)] || \
                ! [string equal $old_data(src_clock_trace_delay) $shared_data(src_clock_trace_delay)] || \
                ! [string equal $old_data(dest_clock_trace_delay) $shared_data(dest_clock_trace_delay)] || \
                ! [string equal $old_data(trace_propagation_rate) $shared_data(trace_propagation_rate)] \
            } ]
        }
    }
    
    ######################################################
    proc copy_current_board_info_to_old { args } {
    
        variable shared_data
        variable old_data
        
        array unset old_data
        array set old_data [array get shared_data]
    }
    
    ######################################################
    # Draw the correct circuit on the canvas
    proc prep_for_raise { args } {
    
        variable board_canvas
        variable other_data
        variable shared_data
        variable canvas_item_configuration
        variable delay_units
        
        # Clear out the canvas
        $board_canvas delete all
        
        # The canvas will get a new drawing, so get rid of the configuration
        # information saved for items in any previous canvas
        array unset canvas_item_configuration
        
        # Draw the correct picture
        switch -exact -- $other_data(clock_configuration) {
            "system_sync_common_clock" {
                draw_diagram::draw_system_sync_common_clock \
                    -canvas $board_canvas \
                    -src_x_offset 32 -dest_x_offset 182
            }
            "system_sync_different_clock" {
                draw_diagram::draw_system_sync_different_clock \
                    -canvas $board_canvas \
                    -src_x_offset 32 -dest_x_offset 182
            }
            "source_sync_source_clock" {
                draw_diagram::draw_source_sync_source_clock \
                    -canvas $board_canvas \
                    -src_x_offset 32 -dest_x_offset 182
            }
            "source_sync_dest_clock" {
                draw_diagram::draw_source_sync_dest_clock \
                    -canvas $board_canvas \
                    -src_x_offset 32 -dest_x_offset 182
            }
            default {
                return -code error "Unknown value for clock_configuration\
                    in board_info::prep_for_raise: $other_data(clock_configuration)"
            }
        }
        
        # Set the labels based on the direction
        switch -exact -- $other_data(direction) {
            "input" -
            "output" {
                draw_diagram::update_chip_diagram_labels -canvas $board_canvas \
                    -direction $other_data(direction)
            }
            default {
                return -code error "Unknown value for direction in\
                    board_info::prep_for_raise: $other_data(direction)"
            }
        }
        
        # Units array needs values if they're blank
        foreach d [array names delay_units] {
            if { [string equal "" $delay_units($d)] } { set delay_units($d) "ns" }
        }
        
        # Enable or disable based on the constraint target
        switch -exact -- $shared_data(constraint_target) {
            "fpga" { gray_ungray_board_tf -state "disabled" }
            "external" { gray_ungray_board_tf -state "normal" }
        }
        
        # Disable the trace propagation delay widget if appropriate
        on_delay_unit
        
    }
    
    ###############################################################
    # Set the highlights for the board diagram
    proc configure_trace_highlights { args } {
    
        set options {
            { "add_to_tag.arg" "" "Name of tag to highlight" }
            { "remove_from_tag.arg" "" "Name of tag to unhighlight" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable board_canvas
        
        # Set the width to 1 to make it normal
        if { ! [string equal "" $opts(remove_from_tag)] } {
            foreach item [$board_canvas find withtag $opts(remove_from_tag)] {
                $board_canvas itemconfigure $item -width 1
            }
        }
        
        # Set the width to 4 to make it bold
        if { ! [string equal "" $opts(add_to_tag)] } {
            foreach item [$board_canvas find withtag $opts(add_to_tag)] {
                $board_canvas itemconfigure $item -width 4
            }
        }
    }
    
    #############################################
    # Get the data to save it into the tree
    proc get_shared_data { args } {
    
        set options {
            { "keys.arg" "" "Variables to get" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        variable shared_data

        if { 0 == [llength $opts(keys)] } {
            return [array get shared_data]
        } else {
            set to_return [list]
            foreach key $opts(keys) {
                if { ! [info exists shared_data($key)] } {
                    post_message -type warning "Can't find value for $key \
                        in board_info namespace"
                    lappend to_return $key
                    lappend to_return {}
                } else {
                    lappend to_return $key $shared_data($key)
                }
            }
            return $to_return
        }
    }
    
    #################################################
    # Validate the board info data
    proc validate_board_info { args } {
    
        set options {
            { "data_var.arg" "" "Name of the variable to populate with results" }
            { "error_messages_var.arg" "" "Name of the variable to hold error messages" }
            { "pre_validation.arg" "" "What do we do for pre-validation" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data
        variable other_data
        variable delay_values
        variable delay_units
        
        # Things are valid or not. If anything is invalid, set to zero.
        set is_valid 1
        
        # We may want to get information back, particularly during the back/next
        # process. If there's no data variable specified, set up a dummy
        # array to hold the results. Else connect the results array to the
        # variable for the data.
        if { [string equal "" $opts(data_var)] } {
            array set results [list]
        } else {
            upvar $opts(data_var) results
        }
        
        # We may want to get error messages back. If we do, hook
        # up the error messages var to the specified variable.
        if { [string equal "" $opts(error_messages_var)] } {
            set error_messages [list]
        } else {
            upvar $opts(error_messages_var) error_messages
        }

        # Do prevalidation if necessary
        switch -exact -- $opts(pre_validation) {
            "skip" { }
            "run_and_return" -
            "return_on_invalid" {
                 # Make sure that there are data ports selected.
                if { [string equal "" $other_data(direction)] } {
                    lappend error_messages [list "You must choose data ports or a bus to\
                        constrain before you select the constraints target"]
                    set is_valid 0
                }
                if { [string equal "" $other_data(clock_configuration)] } {
                    lappend error_messages [list "You must select the interface clock\
                        configuration before you select the constraints target"]
                    set is_valid 0
                }
            }
            default {
                return -code error "Unknown option for -pre_validation in\
                    validate_board_info: $opts(pre_validation)"
            }
        }
        switch -exact -- $opts(pre_validation) {
            "skip" { }
            "run_and_return" { return $is_valid }
            "return_on_invalid" { if { ! $is_valid } { return $is_valid } }
        }
        # End of pre-validation
    
        
        # Validate the constraint target as well as board timing numbers
        # if you choose external device
        switch -exact -- $shared_data(constraint_target) {
            "fpga" { }
            "external" {
            
                # Validate data trace delay
                if { [string equal "" $delay_values(data_trace)] } {
                    set is_valid 0
                    lappend error_messages [list "You must enter a value for the\
                        data trace delay"]
                } elseif { ! [string is double $delay_values(data_trace)] } {
                        set is_valid 0
                    lappend error_messages [list "Specify a numeric value for the\
                        data trace delay"]
                } else {
                    set shared_data(data_trace_delay) "$delay_values(data_trace) $delay_units(data_trace)"
                }
                
                # Validate source clock trace delay
                if { [string equal "" $delay_values(src_clock_trace)] } {
                    set is_valid 0
                    lappend error_messages [list "You must enter a value for the\
                        source clock trace delay"]
                } elseif { ! [string is double $delay_values(src_clock_trace)] } {
                        set is_valid 0
                    lappend error_messages [list "Specify a numeric value for the\
                        source clock trace delay"]
                } else {
                    set shared_data(src_clock_trace_delay) "$delay_values(src_clock_trace) $delay_units(src_clock_trace)"
                }

                # Validate dest clock trace delay
                if { [string equal "" $delay_values(dest_clock_trace)] } {
                    set is_valid 0
                    lappend error_messages [list "You must enter a value for the\
                        destination clock trace delay"]
                } elseif { ! [string is double $delay_values(dest_clock_trace)] } {
                        set is_valid 0
                    lappend error_messages [list "Specify a numeric value for the\
                        destination clock trace delay"]
                } else {
                    set shared_data(dest_clock_trace_delay) "$delay_values(dest_clock_trace) $delay_units(dest_clock_trace)"
                }
                
                # If length units are used, ensure there's a trace propagation rate
                if { [delays_use_length_units] } {
                    if { [string equal "" $delay_values(trace_propagation)] } {
                        set is_valid 0
                        lappend error_messages [list "You must enter a value for the\
                            trace propagation rate"]
                    } elseif { ! [string is double $delay_values(trace_propagation)] } {
                        set is_valid 0
                        lappend error_messages [list "Specify a numeric value for the\
                            trace propagation rate"]
                    } else {
                        set shared_data(trace_propagation_rate) $delay_values(trace_propagation)
                    }
                }
                
            }
            default {
                lappend error_messages [list "No constraint target is selected.\
                    You must select FPGA or external device as the constraint target"]
                set is_valid 0
            }
        }
        
        if { $is_valid } {
            array set results [list \
                "constraint_target"         $shared_data(constraint_target) \
                "data_trace_delay"          $shared_data(data_trace_delay) \
                "src_clock_trace_delay"     $shared_data(src_clock_trace_delay) \
                "dest_clock_trace_delay"    $shared_data(dest_clock_trace_delay) \
                "trace_propagation_rate"    $shared_data(trace_propagation_rate) \
            ]
        }
        
        return $is_valid
    }
}

################################################################################
#
namespace eval requirements_info {

    # GUI elements
    variable io_timing_tf
#    variable board_timing_tf
#    variable src_clock_cb
#    variable dest_clock_cb
#    variable board_timing_buttons
    variable io_timing_buttons
    variable tsu_th_fr
    variable tco_min_tco_fr
    variable skew_fr
    variable valid_fr
    variable duration_buttons
    variable duration_widgets
    variable swd_button
    variable adjust_cycle_buttons
    variable show_text "Show waveform diagram"
    variable update_text "Update waveform diagram"

# was in data_list
#        "board_timing_method"   "" \
#        "max_clock_trace_delay" "" \
#        "min_clock_trace_delay" "" \
#        "max_data_trace_delay"  "" \
#        "min_data_trace_delay"  "" \
#        "clock_trace"           "" \
#        "clock_trace_tolerance" "" \
#        "data_trace"            "" \
#        "data_trace_tolerance"  "" \

    variable data_list [list \
        "io_timing_method"      "" \
        "adjust_cycles"         "" \
        "src_shift_cycles"      "" \
        "dest_shift_cycles"     "" \
        "src_transfer_cycles"   "" \
        "dest_transfer_cycles"  "" \
        "max_skew"              "" \
        "min_valid"             "" \
        "setup"                 "" \
        "hold"                  "" \
        "tco_max"               "" \
        "tco_min"               "" \
    ]
    variable other_data_list [list \
        "data_rate"             "" \
        "clock_configuration"   "" \
        "direction"             "" \
        "constraint_target"     "" \
    ]
    variable shared_data
    variable old_data
    variable other_data
    array set shared_data $data_list
    array set old_data $data_list
    array set other_data $other_data_list
    
    ########################################
    #
    proc assemble_timing_tab { args } {

        set options {
            { "frame.arg" "" "Frame to assemble the tab on" }
        }
        array set opts [::cmdline::getoptions args $options]

#        variable src_clock_cb
#        variable dest_clock_cb
        variable io_timing_tf
#        variable board_timing_tf
        variable duration_buttons
        variable swd_button
        variable show_text
        variable shared_data
        variable duration_widgets
        variable adjust_cycle_buttons
        
        set f $opts(frame)

        # Set up the nav frame
#        set nav_frame [frame $f.nav]
#        grid $nav_frame - - -sticky news

        # I/O Timing parameter values
        set io_timing_tf [TitleFrame $f.io_values -text "I/O timing requirements" \
            -ipad 8]
        assemble_io_timing_values_frame -frame [$io_timing_tf getframe]
        
        # Board trace delay values
#        set board_timing_tf [TitleFrame $f.board_values -text "Board trace delays" \
#            -ipad 8]
#        assemble_board_timing_values_frame -frame [$board_timing_tf getframe]
        
        
        # Make the unified data window adjustments titleframe
        set dwa_tf [TitleFrame $f.dwa_tf -text "Data window adjustments"]
        set sub_f [$dwa_tf getframe]
        pack [label $sub_f.l0 -text "Adjust the clock cycles per data transfer\
            \nor the clock cycle when the data transfer occurs\
            \nif it is necessary for your interface" -justify left] -side top -anchor nw
if { 0 } {
        pack [label $sub_f.l0 -text "Adjust the shift and duration of the data\
            window if the default shift and duration are not correct."] \
            -side top -anchor nw
        pack [label $sub_f.l1 -text "The appropriate shift and duration depend\
            on the specifications of your interface."] \
            -side top -anchor nw
}
        pack [Separator $sub_f.sep -relief groove] \
            -side top -anchor n -fill x -expand true -pady 5

        # Source/dest picker
        pack [label $sub_f.l2 -text "Adjust shift and duration based on"] \
            -side top -anchor nw
        pack [radiobutton $sub_f.rb0 -variable \
            [namespace which -variable shared_data](adjust_cycles) \
            -text "Source clock" -value "src"] \
            -side top -anchor nw
        pack [radiobutton $sub_f.rb1 -variable \
            [namespace which -variable shared_data](adjust_cycles) \
            -text "Destination clock" -value "dest"] \
            -side top -anchor nw
        array set adjust_cycle_buttons [list "src" $sub_f.rb0 "dest" $sub_f.rb1]
        
        # New frame for shift and duration so widgets can be gridded
        set ssub_f [frame $sub_f.shift_and_duration]

        # shift part
        grid [label $ssub_f.l_shift -text "Data window shift"] \
            [Entry $ssub_f.e_shift -width 3 -textvariable \
                [namespace which -variable shared_data](dest_shift_cycles)] \
            [label $ssub_f.l_shift_cycles -text "cycles"] \
            [ArrowButton $ssub_f.b_left -dir left -width 20 -height 20 -type button] \
            [ArrowButton $ssub_f.b_right -dir right -width 20 -height 20 -type button] \
            -sticky w
#            [Button $ssub_f.b_left -text "Earlier (left)" -width 10] \
#            [Button $ssub_f.b_right -text "Later (right)" -width 10] \

        #duration part
        grid [label $ssub_f.l_duration -text "Data window duration"] \
            [Entry $ssub_f.e_duration -width 3 -textvariable \
                [namespace which -variable shared_data](dest_transfer_cycles)] \
            [label $ssub_f.l_duration_cycles -text "cycles"] \
            [ArrowButton $ssub_f.b_decrease -dir bottom -width 20 -height 20 -type button] \
            [ArrowButton $ssub_f.b_increase -dir top -width 20 -height 20 -type button] \
            -sticky w
#            [Button $ssub_f.b_increase -text "Increase" -width 10] \
#            [Button $ssub_f.b_decrease -text "Decrease" -width 10] \

        # Configure the radio buttons to swap the textvariable associated with
        # the Entry widgets
        $sub_f.rb0 configure -command [namespace code [list swap_entry_textvariables \
            -entry_and_var_name [list \
            $ssub_f.e_shift [namespace which -variable shared_data](src_shift_cycles) \
            $ssub_f.e_duration [namespace which -variable shared_data](src_transfer_cycles)]]]
        $sub_f.rb1 configure -command [namespace code [list swap_entry_textvariables \
            -entry_and_var_name [list \
            $ssub_f.e_shift [namespace which -variable shared_data](dest_shift_cycles) \
            $ssub_f.e_duration [namespace which -variable shared_data](dest_transfer_cycles)]]]

        # Configure the shift and duration buttons to adjust the widget values
        $ssub_f.b_left configure -command [namespace code [list update_adjust \
            -widget $ssub_f.e_shift -value -1]]
        $ssub_f.b_right configure -command [namespace code [list update_adjust \
            -widget $ssub_f.e_shift -value 1]]
        $ssub_f.b_increase configure -command [namespace code [list update_adjust \
            -widget $ssub_f.e_duration -value 1 -handle_decrease]]
        $ssub_f.b_decrease configure -command [namespace code [list update_adjust \
            -widget $ssub_f.e_duration -value -1 -handle_decrease]]

        set duration_widgets [list \
            $ssub_f.l_duration $ssub_f.e_duration $ssub_f.l_duration_cycles \
            $ssub_f.b_increase $ssub_f.b_decrease]
        array set duration_buttons \
            [list "increase" $ssub_f.b_increase "decrease" $ssub_f.b_decrease]
        pack $ssub_f -side top -anchor nw
        
        # Reset button
        pack [Button $sub_f.reset -text "Reset shift and duration to default values" \
            -command [namespace code [list check_shift_and_duration -initialize force]]] \
            -side top -anchor nw -pady 8
        
        set diagram_tf [TitleFrame $f.di_tf -text "Waveform diagram"]
        set sub_f [$diagram_tf getframe]
        set swd_button [button $sub_f.draw_button -text $show_text -width 20 \
            -command "[namespace code show_waveform_diagram] -requirements"]
        pack $swd_button -side top -anchor nw
        clock_diagram::assemble_tab -frame [$diagram_tf getframe]
        
if { 0 } {
        # Grid in the I/O timing and trace delay titleframes with
        # a space between them
        grid $io_timing_tf x $board_timing_tf -sticky news -pady 8
#        grid $shift_tf x $transfer_cycles_tf -sticky news
        grid $dwa_tf - - -sticky news
        grid $swd_button x x
        grid columnconfigure $f 1 -minsize 8
        grid columnconfigure $f [list 0 2] -weight 1
        
        # Grid in an expanding frame at the bottom to force 
        # everything else to the top
        grid [frame $f.foo] - - -sticky news
        grid rowconfigure $f 3 -weight 1
}
        grid $io_timing_tf x $dwa_tf -sticky news
#        grid $swd_button - - -sticky w
        grid $diagram_tf - - -sticky news
        grid [frame $f.foo] - - -sticky news
        grid rowconfigure $f 2 -weight 1
        grid columnconfigure $f 1 -minsize 8
        grid columnconfigure $f [list 0 2] -weight 1
#        $f_boundary.rb0 configure -command "[namespace code process_timing_target]"
#        $f_boundary.rb1 configure -command "[namespace code process_timing_target]"
    
#        return $nav_frame
    }

    ################################################################################
    proc assemble_io_timing_values_frame { args } {
    
        set options {
            { "frame.arg" "" "Frame to use for the widgets" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable tsu_th_fr
        variable tco_min_tco_fr
        variable skew_fr
        variable valid_fr
        variable io_timing_buttons
        variable shared_data
        
        set f $opts(frame)
    
        set subf [frame $f.fsetup]
        set tsu_th_fr $subf
        set ssubf [frame $subf.0]
        pack [radiobutton $ssubf.rb -text "Setup and hold" \
            -variable [namespace which -variable shared_data](io_timing_method) \
            -value "setup_hold"] \
            -side left
        pack $ssubf -fill x -expand true -side top -anchor w
    
        set ssubf [frame $subf.1]
        pack [label $ssubf.l0 -text "Setup time (tSU)"] -ipadx 20 -side left
        pack [label $ssubf.l1 -text "ns"] -side right
        pack [entry $ssubf.e -textvariable [namespace which -variable shared_data](setup) \
            -width 8 -validate all \
            -validatecommand [list util::validate_float %P %V]] -side right
        pack $ssubf -fill x -expand true -side top -anchor w
    
        set ssubf [frame $subf.2]
        pack [label $ssubf.l0 -text "Hold time (tH)"] -ipadx 20 -side left
        pack [label $ssubf.l1 -text "ns"] -side right
        pack [entry $ssubf.e -textvariable [namespace which -variable shared_data](hold) \
            -width 8 -validate all \
            -validatecommand [list util::validate_float %P %V]] -side right
        pack $ssubf $subf -fill x -expand true -side top -anchor w
    
        set subf [frame $f.fclockout]
        set tco_min_tco_fr $subf
        set ssubf [frame $subf.0]
        pack [radiobutton $ssubf.rb -text "Clock to out" \
            -variable [namespace which -variable shared_data](io_timing_method) \
            -value "clock_to_out"] \
            -side left
        pack $ssubf -side top -anchor w
    
        set ssubf [frame $subf.1]
        pack [label $ssubf.l0 -text "Maximum clock to out (tCO)"] -ipadx 20 -side left
        pack [label $ssubf.l1 -text "ns"] -side right
        pack [entry $ssubf.e -textvariable [namespace which -variable shared_data](tco_max) \
            -width 8 -validate all \
            -validatecommand [list util::validate_float %P %V]] -side right
        pack $ssubf -fill x -expand true -side top -anchor w
    
        set ssubf [frame $subf.2]
        pack [label $ssubf.l0 -text "Minimum clock to out (tCOmin)"] -ipadx 20 -side left
        pack [label $ssubf.l1 -text "ns"] -side right
        pack [entry $ssubf.e -textvariable [namespace which -variable shared_data](tco_min) \
            -width 8 -validate all \
            -validatecommand [list util::validate_float %P %V]] -side right
        pack $ssubf $subf -fill x -expand true -side top -anchor w
    
        set subf [frame $f.fskew]
        set skew_fr $subf
        pack [radiobutton $subf.rb -text "Maximum data bus skew" \
            -variable [namespace which -variable shared_data](io_timing_method) \
            -value "max_skew"] \
            -side left
        label $subf.l0 -text "ns"
        entry $subf.e -textvariable [namespace which -variable shared_data](max_skew) \
            -width 8 -validate all \
            -validatecommand [list util::validate_float %P %V -positive]
        label $subf.l1 -text "+/-"
        pack $subf.l0 $subf.e $subf.l1 -side right
        pack $subf -fill x -expand true -side top -anchor w
    
        set subf [frame $f.fvalid]
        set valid_fr $subf
        pack [radiobutton $subf.rb -text "Minimum data valid time" \
            -variable [namespace which -variable shared_data](io_timing_method) \
            -value "min_valid"] \
            -side left
        label $subf.l0 -text "ns"
        entry $subf.e -textvariable [namespace which -variable shared_data](min_valid) \
            -width 8 -validate all \
            -validatecommand [list util::validate_float %P %V -positive]
        label $subf.l1 -text "+/-"
        pack $subf.l0 $subf.e $subf.l1 -side right
        pack $subf -fill x -expand true -side top -anchor w
    
        set io_value_entry_widgets [list $f.fskew.e $f.fvalid.e $f.fsetup.1.e \
            $f.fsetup.2.e $f.fclockout.1.e $f.fclockout.2.e]

        $f.fskew.rb configure -command "[namespace code on_io_timing_method] \
            -normal_pattern fskew -widgets [list $io_value_entry_widgets]"
        $f.fvalid.rb configure -command "[namespace code on_io_timing_method] \
            -normal_pattern fvalid -widgets [list $io_value_entry_widgets]"
        $f.fsetup.0.rb configure -command "[namespace code on_io_timing_method] \
            -normal_pattern fsetup -widgets [list $io_value_entry_widgets]"
        $f.fclockout.0.rb configure -command "[namespace code on_io_timing_method] \
            -normal_pattern fclockout -widgets [list $io_value_entry_widgets]"

        array set io_timing_buttons [list \
            "max_skew" $f.fskew.rb \
            "min_valid" $f.fvalid.rb \
            "setup_hold" $f.fsetup.0.rb \
            "clock_to_out" $f.fclockout.0.rb \
        ]        
    }

    ################################################################################
    proc assemble_board_timing_values_frame { args } {
    
        set options {
            { "frame.arg" "" "Frame to use for the widgets" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data
        variable board_timing_buttons
                
        set f $opts(frame)
        
        set subf [frame $f.maxmin]
        set ssubf [frame $subf.0]
        pack [radiobutton $ssubf.rb -text "Maximum and minimum" \
            -variable [namespace which -variable shared_data](board_timing_method) \
            -value "min_max"] -side left
        pack $ssubf -fill x -expand true -side top -anchor w
    
        set ssubf [frame $subf.1]
        pack [label $ssubf.l0 -text "Maximum clock trace"] -ipadx 20 -side left
        pack [label $ssubf.l1 -text "ns"] -side right
        pack [entry $ssubf.e -textvariable [namespace which -variable shared_data](max_clock_trace_delay) \
            -width 8 -validate all \
            -validatecommand [list util::validate_float %P %V -positive]] -side right
        pack $ssubf -fill x -expand true -side top -anchor w
    
        set ssubf [frame $subf.2]
        pack [label $ssubf.l0 -text "Minimum clock trace"] -ipadx 20 -side left
        pack [label $ssubf.l1 -text "ns"] -side right
        pack [entry $ssubf.e -textvariable [namespace which -variable shared_data](min_clock_trace_delay) \
            -width 8 -validate all \
            -validatecommand [list util::validate_float %P %V -positive]] -side right
        pack $ssubf $subf -fill x -expand true -side top -anchor w
    
        set ssubf [frame $subf.3]
        pack [label $ssubf.l0 -text "Maximum data trace"] -ipadx 20 -side left
        pack [label $ssubf.l1 -text "ns"] -side right
        pack [entry $ssubf.e -textvariable [namespace which -variable shared_data](max_data_trace_delay) \
            -width 8 -validate all \
            -validatecommand [list util::validate_float %P %V -positive]] -side right
        pack $ssubf -fill x -expand true -side top -anchor w
    
        set ssubf [frame $subf.4]
        pack [label $ssubf.l0 -text "Minimum data trace"] -ipadx 20 -side left
        pack [label $ssubf.l1 -text "ns"] -side right
        pack [entry $ssubf.e -textvariable [namespace which -variable shared_data](min_data_trace_delay) \
            -width 8 -validate all \
            -validatecommand [list util::validate_float %P %V -positive]] -side right
        pack $ssubf $subf -fill x -expand true -side top -anchor w
    
        set subf [frame $f.typtol]
        set ssubf [frame $subf.0]
        pack [radiobutton $ssubf.rb -text "Typical and tolerance" \
            -variable [namespace which -variable shared_data](board_timing_method) \
            -value "typ_tolerance"] -side left
        pack $ssubf -fill x -expand true -side top -anchor w
    
        set ssubf [frame $subf.1]
        pack [label $ssubf.l0 -text "Clock trace"] -ipadx 20 -side left
        pack [label $ssubf.l1 -text "ns"] -side right
        pack [entry $ssubf.e -textvariable [namespace which -variable shared_data](clock_trace) \
            -width 8 -validate all \
            -validatecommand [list util::validate_float %P %V -positive]] -side right
        pack $ssubf -fill x -expand true -side top -anchor w
    
        set ssubf [frame $subf.2]
        pack [label $ssubf.l0 -text "Tolerance"] -ipadx 40 -side left
        pack [label $ssubf.l1 -text "ns"] -side right
        pack [entry $ssubf.e -textvariable [namespace which -variable shared_data](clock_trace_tolerance) \
            -width 8 -validate all \
            -validatecommand [list util::validate_float %P %V -positive]] -side right
        pack [label $ssubf.l2 -text "+/-"] -side right
        pack $ssubf $subf -fill x -expand true -side top -anchor w
    
        set ssubf [frame $subf.3]
        pack [label $ssubf.l0 -text "Data trace"] -ipadx 20 -side left
        pack [label $ssubf.l1 -text "ns"] -side right
        pack [entry $ssubf.e -textvariable [namespace which -variable shared_data](data_trace) \
            -width 8 -validate all \
            -validatecommand [list util::validate_float %P %V -positive]] -side right
        pack $ssubf -fill x -expand true -side top -anchor w
    
        set ssubf [frame $subf.4]
        pack [label $ssubf.l0 -text "Tolerance"] -ipadx 40 -side left
        pack [label $ssubf.l1 -text "ns"] -side right
        pack [entry $ssubf.e -textvariable [namespace which -variable shared_data](data_trace_tolerance) \
            -width 8 -validate all \
            -validatecommand [list util::validate_float %P %V -positive]] -side right
        pack [label $ssubf.l2 -text "+/-"] -side right
        pack $ssubf $subf -fill x -expand true -side top -anchor w
    
        set max_min_widgets [list $f.maxmin.1.e $f.maxmin.2.e $f.maxmin.3.e $f.maxmin.4.e]
        set typ_tol_widgets [list $f.typtol.1.e $f.typtol.2.e $f.typtol.3.e $f.typtol.4.e]
    
        # Handle "board timing method" clicks
        $f.maxmin.0.rb configure -command "util::enable_disable_widgets \
            -normal_widgets [list $max_min_widgets] \
            -disabled_widgets [list $typ_tol_widgets]"
        $f.typtol.0.rb configure -command "util::enable_disable_widgets \
            -normal_widgets [list $typ_tol_widgets] \
            -disabled_widgets [list $max_min_widgets]"
        
        array set board_timing_buttons [list \
            "min_max" $f.maxmin.0.rb \
            "typ_tolerance" $f.typtol.0.rb \
        ]
#        set board_timing_buttons(min_max) $f.maxmin.0.rb
#        set board_timing_buttons(typ_tolerance) $f.typtol.0.rb
    }
    ###########################################
    proc configure_duration_widgets { args } {
    
        variable shared_data
        variable other_data
        variable duration_widgets
        
        switch -exact -- $other_data(data_rate) {
            "sdr" {
            
                switch -exact -- $shared_data(io_timing_method) {
                    "min_valid" -
                    "max_skew" {
                        # Disable the duration widgets for max skew
                        util::enable_disable_widgets -disabled_widgets $duration_widgets
                    }
                    "setup_hold" -
                    "clock_to_out" {
                        # enable the widgets
                        util::enable_disable_widgets -normal_widgets $duration_widgets
                        
                        # Enable the down button if duration is greater than 0
                        configure_decrease_button
                    }
                    default {
                        return -code error "Unknown value for io_timing_method\
                            in configure_duration_widgets: $shared_data(io_timing_method)"
                    }
                }
            }
            "ddr" {
                # Disable the duration widgets for any DDR configuration
                util::enable_disable_widgets -disabled_widgets $duration_widgets
                
            }
            default {
                return -code error "Unknown value for data_rate in\
                    configure_duration_widgets: $other_data(data_rate)"
            }
        }

    }
    
    ############################################
    proc swap_entry_textvariables { args } {
    
        set options {
            { "entry_and_var_name.arg" "" "List of widgets and associated variable names" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data
        
        foreach { widget varname } $opts(entry_and_var_name) {
            $widget configure -textvariable $varname
        }
    }
    
    ###########################################
    proc configure_decrease_button { args } {
    
        variable shared_data
        variable duration_buttons
        
        # Enable the down button if duration is greater than 0
        switch -exact -- $shared_data(adjust_cycles) {
            "src" { set duration_value $shared_data(src_transfer_cycles) }
            "dest" { set duration_value $shared_data(dest_transfer_cycles) }
            default {
                return -code error "Unknown value for adjust_cycles in\
                    configure_decrease_button: $shared_data(adjust_cycles)"
            }
        }
        if { 0 < $duration_value } {
            $duration_buttons(decrease) configure -state normal
        } else {
            $duration_buttons(decrease) configure -state disabled
        }
    
    }
    
    ##########################################
    # Update the value in the shift or transfer cycles entry widget when
    # the left/right or increase/decrease buttons are pressed.
    proc update_adjust { args } {
    
        set options {
            { "widget.arg" "" "src or dest" }
            { "value.arg" "" "1 or -1" }
            { "handle_decrease" "Enable or disable the decrease button" }
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable shared_data
        
        incr [$opts(widget) cget -textvariable] $opts(value)
        
        # If we handle the decrease button, see whether
        # it should be enabled or disabled.
        if { $opts(handle_decrease) } { configure_decrease_button }        
    }
    
    #######################################################
    proc check_shift_and_duration { args } {
    
        set options {
            { "initialize.arg" "none" "Initialize values?" }
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable shared_data
        variable other_data

        # If we're initializing, set the shift cycles to 0
        # Otherwise, leave it alone
        switch -exact -- $opts(initialize) {
            "force" {
                set shared_data(src_shift_cycles) 0
                set shared_data(dest_shift_cycles) 0
            }
            "if_blank" {
                if { [string equal "" $shared_data(src_shift_cycles)] } {
                    set shared_data(src_shift_cycles) 0
                }
                if { [string equal "" $shared_data(dest_shift_cycles)] } {
                    set shared_data(dest_shift_cycles) 0
                }
            }
            "none" { }
            default {
                return -code error "Unsupported value specified for\
                    -initialize in check_shift_and_duration: $opts(initialize)"
            }
        }

        # transfer cycles depends on the data rate
        # DDR forces transfer cycles, regardless of whether we're
        # initializing or not.
        # SDR forces transfer cycles only for skew method
        switch -exact -- $other_data(data_rate) {
            "sdr" {
                
                # When you're doing SDR, the transfer cycles
                # depend on what your IO timing method is.
                # skew forces it to zero for output, and 1 for input
                switch -exact -- $shared_data(io_timing_method) {
                    "max_skew" -
                    "min_valid" {
                        switch -exact -- $other_data(direction) {
                            "output" {
                                set shared_data(src_transfer_cycles) 0
                                set shared_data(dest_transfer_cycles) 0
                            }
                            "input" {
                                set shared_data(src_transfer_cycles) 1
                                set shared_data(dest_transfer_cycles) 1
                            }
                            default {
                                # Could be empty at the beginning
                            }
                        }
                    }
                    "setup_hold" -
                    "clock_to_out" {
                        switch -exact -- $opts(initialize) {
                            "force" {
                                set shared_data(src_transfer_cycles) 1
                                set shared_data(dest_transfer_cycles) 1
                            }
                            "if_blank" {
                                if { [string equal "" $shared_data(src_transfer_cycles)] } {
                                    set shared_data(src_transfer_cycles) 1
                                }
                                if { [string equal "" $shared_data(dest_transfer_cycles)] } {
                                    set shared_data(dest_transfer_cycles) 1
                                }
                            }
                            "none" { }
                            default {
                                return -code error "Unsupported value specified for\
                                    -initialize in check_shift_and_duration: $opts(initialize)"
                            }
                        }
                    }
                    default {
                        return -code error "Unknown value for io_timing_method in\
                            check_shift_and_duration: $shared_data(io_timing_method)"
                    }
                }
                
                # When you're doing SDR, the default transfer cycle is 1,
                # but you can change that. 
                configure_decrease_button
            }
            "ddr" {
                
                # For DDR, force the transfer cycles, regardless of whether
                # we're initializing or not.
                switch -exact -- $shared_data(io_timing_method) {
                    "max_skew" -
                    "min_valid" {
                        switch -exact -- $other_data(direction) {
                            "output" {
                                set shared_data(src_transfer_cycles) 0
                                set shared_data(dest_transfer_cycles) 0
                            }
                            "input" {
                                set shared_data(src_transfer_cycles) 1
                                set shared_data(dest_transfer_cycles) 1
                            }
                            default {
                                # Could be empty at the beginning
                            }
                        }
#                        set shared_data(src_transfer_cycles) 0
#                        set shared_data(dest_transfer_cycles) 0 
                    }
                    "setup_hold" -
                    "clock_to_out" {
                        set shared_data(src_transfer_cycles) 1
                        set shared_data(dest_transfer_cycles) 1
                    }
                    default {
                        return -code error "Unknown value for io_timing_method in\
                            check_shift_and_duration: $shared_data(io_timing_method)"
                    }
                }
                
                # When you're doing DDR, the transfer cycle is either zero or
                # one, but even when it's one, the decrease button is not
                # enabled.
            }
            "" {
                # If data rate is blank, it will be set later
            }
            default {
                return -code error "Unknown value for data_rate in\
                    check_shift_and_duration: $other_data(data_rate)"
            }
        }
        
    }
    
    ###########################################
    # If the button says "show", then draw the dialog and
    # configure the button to say "update"
    proc show_waveform_diagram { args } {
    
        set options {
            { "relationship" "On the relationship page when clicked" }
            { "requirements" "On the requirements page when clicked" }
        }
        array set opts [::cmdline::getoptions args $options]
        variable shared_data
        variable swd_button
        variable show_text
        variable update_text

        set error_messages [list]
        
        # Validate timing requirements before showing or updating the
        # waveform diagram
        if { [catch { requirements_info::validate_requirements \
            -pre_validation skip \
            -error_messages_var error_messages } is_valid ] } {
            
            # If there was actually an error running the validation,
            # that's bad.
            tk_messageBox -icon error -type ok -default ok \
                -title "Error" -parent [focus] -message \
                "There was an unexpected error running validate_requirements:\n$is_valid" 
            return
            
        } elseif { ! $is_valid } {
        
            # Some of the data is not valid
            # Inform the user and return
            tk_messageBox -icon error -type ok -default ok \
                -title "Requirements validation" -parent [focus] -message \
                [util::make_message_for_dialog -messages \
                [list "Correct the following errors to continue" $error_messages]]
            return
        }
        

        # The button can be to show or update. If it says show, then we
        # have to draw the dialog and switch the button to say update
        if { [string equal $show_text [$swd_button cget -text]] } {
#            clock_diagram::show_diagram_dialog
            $swd_button configure -text $update_text
        }


        # Display an hourglass cursor
        . configure -cursor "watch"
        update idletasks
        
        # What has to be drawn?
        # Clocks get redrawn if they changed.
        if { [clocks_info::clocks_info_changed -settings] } {
        
            # Erase what's there
            clock_diagram::erase_canvas -clocks -default_relationship \
                -actual_relationship -data
            
            # Draw the clocks. draw_clocks also draws relationship arrows
            # for the default setup and hold relationships
            clock_diagram::draw_clocks
            
            # Once you've drawn the clocks, they don't have to be redrawn
            # unless a clock setting changes.
            clocks_info::clock_settings_change_flag -reset
            
        }
        
        # Draw the data waveform only if we're coming from the requirements
        # page
        if { $opts(requirements) } {
            # update arrows and data windows
            clock_diagram::draw_data_waveforms \
                -data_var [namespace which -variable shared_data]
        }
        
        # And revert to a normal cursor
        . configure -cursor ""
    }
    
    ###########################################
    proc update_button { args } {
        variable swd_button
        variable show_text
        $swd_button configure -text $show_text
    }
    

    ################################################################################
    proc init_timing_req { args } {
    
        set options {
            { "data.arg" "" "Flat array of data" }
            { "data_rate.arg" "" "sdr or ddr" }
            { "clock_configuration.arg" "" "" }
            { "shorter.arg" "" "src or dest" }
            { "update_direction.arg" "" "input or output" }
            { "constraint_target.arg" "" "fpga or external" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data
        variable other_data
        variable old_data
        variable duration_widgets
        variable adjust_cycle_buttons
        
        # Init the data from the tree
        if { 0 < [llength $opts(data)] } {
        
            array set temp $opts(data)
            
            foreach k [array names shared_data] {
                set shared_data($k) $temp($k)
                unset temp($k)
            }
            foreach k [array names other_data] {
                set other_data($k) $temp($k)
                unset temp($k)
            }

            if { 0 < [array size temp] } {
                post_message -type warning "More data than expected when\
                    initializing requirements_info: [array names temp]"
            }
            
            # Copy data for tracking changes
            array unset old_data
            array set old_data [array get shared_data]

if { 0 } {
            # We have to have a board timing method set for the radio button
            switch -exact -- $shared_data(board_timing_method) {
                "min_max" -
                "typ_tolerance" { }
                "" { set shared_data(board_timing_method) "min_max" }
                default {
                    return -code error "Unknown value for\
                        board_timing_method in init_timing_req:\
                        $shared_data(board_timing_method)"
                }
            }

            # We need an io timing method set
            if { [string equal "" $shared_data(io_timing_method)] } {
                if { [regexp {sync} $other_data(clock_configuration)] } {
                    set shared_data(io_timing_method) "max_skew"
                } else {
                    set shared_data(io_timing_method) "setup_hold"
                }
            }
}            
            # TODO - set it to whichever one is a smaller period
            # We have to have an adjust_cycles value for the radio button
            switch -exact -- $shared_data(adjust_cycles) {
                "src" -
                "dest" { }
                "" { set shared_data(adjust_cycles) "dest" }
                default {
                    return -code error "Unknown value for adjust_cycles\
                        in init_timing_req: $shared_data(adjust_cycles)"
                }
            }
            # invoke the radio button to get the correct textvariable
            # connected to the entry widgets
            $adjust_cycle_buttons($shared_data(adjust_cycles)) invoke
        }

        # Take care of updates later
        if { ![string equal "" $opts(clock_configuration)] } {
            set other_data(clock_configuration) $opts(clock_configuration)            
        }

        if { ![string equal "" $opts(data_rate)] } {
            set other_data(data_rate) $opts(data_rate)
        }


        # Take care of updated direction
        switch -exact -- $opts(update_direction) {
            "input" -
            "output" {
                set other_data(direction) $opts(update_direction)
            }
            "" { }
            default {
                return -code error "Unknown value for direction in init_timing_req:\
                    $opts(update_direction)"
            }
        }

        # Take care of updated constraint target
        switch -exact -- $opts(constraint_target) {
            "fpga" -
            "external" {
                set other_data(constraint_target) $opts(constraint_target)
            }
            "" { }
            default {
                return -code error "Unknown value for constraint_target in init_timing_req:\
                    $opts(constraint_target)"
            }
        }
if { 0 } {
        if { [regexp {^system_} $other_data(clock_configuration)] } {
            switch -exact -- $shared_data(io_timing_method) {
                "max_skew" -
                "min_valid" {
                    set shared_data(io_timing_method) "setup_hold"
                }
            }
        }
}

#        check_shift_and_duration -initialize if_blank
    }

    #########################################
    # Save the state of the critical I/O
    # information. Later the old_ information
    # is used to tell whether anything on the
    # tab changed.
    proc copy_current_requirements_info_to_old { args } {
    
        set options {
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data
        variable old_data
        
        catch { array unset old_data }
        array set old_data [array get shared_data]
    }

    #############################################
    # Get the data to save it into the tree
    proc get_shared_data { args } {
    
        set options {
            { "keys.arg" "" "Variables to get" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        variable shared_data

        if { 0 == [llength $opts(keys)] } {
            return [array get shared_data]
        } else {
            set to_return [list]
            foreach key $opts(keys) {
                if { ! [info exists shared_data($key)] } {
                    post_message -type warning "Can't find value for $key \
                        in requirements_info namespace"
                    lappend to_return $key
                    lappend to_return {}
                } else {
                    lappend to_return $key $shared_data($key)
                }
            }
            return $to_return
        }
    }
    
    ##############################################
    proc prep_for_raise { args } {
    
        variable shared_data
        variable other_data
        variable io_timing_tf
        variable skew_fr
        variable valid_fr
        variable io_timing_buttons
        
        # We need an io timing method set
        if { [string equal "" $shared_data(io_timing_method)] } {
            if { [regexp {sync} $other_data(clock_configuration)] } {
                set shared_data(io_timing_method) "max_skew"
            } else {
                set shared_data(io_timing_method) "setup_hold"
            }
        }

        # label the timing requirements frame appropriately
        switch -exact -- $other_data(constraint_target) {
            "fpga" {
                $io_timing_tf configure -text "FPGA timing requirements"
            }
            "external" {
                $io_timing_tf configure -text "External device timing requirements"
            }
            default {
                return -code error "Unknown value for constraint_target in prep_for_raise:\
                    $other_data(constraint_target)"
            }
        }
        
        # If you're switching the clock configuration to a system centric
        # configuration, skew and valid timing methods are invalid.
        # If the IO timing method is either of those, force it to setup_hold 
        switch -exact -- $other_data(clock_configuration) {
            "system_sync_common_clock" -
            "system_sync_different_clock" {
                switch -exact -- $shared_data(io_timing_method) {
                    "max_skew" -
                    "min_valid" {
                        post_message -type warning "Skew timing is not a valid\
                            constraint for system synchronous interfaces.\
                            Defaulting to setup and hold."
                        set shared_data(io_timing_method) "setup_hold"
                    }
                    "setup_hold" -
                    "clock_to_out" { }
                    default {
                        return -code error "Unknown value for io_timing_method\
                            in init_timing_req: $shared_data(io_timing_method)"
                    }
                }
            }
            "source_sync_source_clock" -
            "source_sync_dest_clock" -
            "" { }
            default {
                return -code error "Unknown value for clock_configuration in\
                    init_timing_req: $other_data(clock_configuration)"
            }
        }
        # The skew and valid entries are valid only for source sync
        switch -exact -- $other_data(clock_configuration) {
            "system_sync_common_clock" -
            "system_sync_different_clock" {
                util::recursive_widget_state -widget $valid_fr -state "disabled"
                util::recursive_widget_state -widget $skew_fr -state "disabled"
            }
            "source_sync_source_clock" -
            "source_sync_dest_clock" {
                util::recursive_widget_state -widget $valid_fr -state "normal"
                util::recursive_widget_state -widget $skew_fr -state "normal"
            }
            default {
                return -code error "Unknown value for clock_configuration in prep_for_raise:\
                    $other_data(clock_configuration)"
            }
        }
        
        # Get the enabled and disabled widgets associated with each of
        # the sets of radio buttons in the appropriate state.
        # Invoke the appropriate button
        $io_timing_buttons($shared_data(io_timing_method)) invoke

        # Delete the data waveform and arrows
        clock_diagram::erase_canvas -clocks -default_relationship \
            -actual_relationship -data

        # Moved from init_timing_req
        check_shift_and_duration -initialize if_blank
    }
    
    ############################################
    # Check the value of io_timing_method against the clock_configuration
    # You can't have skew timing set for system sync stuff, for example
    # Should update io_timing_method to be a traced variable to update
    # the enabling/disabling if I do this check.
    # Setting the alue to setup_hold will require an on_io_timing_method
    # call otherwise
    proc check_io_timing_method { args } {
    
        variable shared_data
        variable other_data
        
        # If you're switching the clock configuration to a system centric
        # configuration, skew and valid timing methods are invalid.
        # If the IO timing method is either of those, force it to setup_hold 
        switch -exact -- $other_data(clock_configuration) {
            "system_sync_common_clock" -
            "system_sync_different_clock" {
                switch -exact -- $shared_data(io_timing_method) {
                    "max_skew" -
                    "min_valid" {
                        post_message -type warning "Skew timing is not a valid\
                            constraint for system synchronous interfaces.\
                            Defaulting to setup and hold."
                        set shared_data(io_timing_method) "setup_hold"
                    }
                    "setup_hold" -
                    "clock_to_out" { }
                    default {
                        return -code error "Unknown value for io_timing_method\
                            in init_timing_req: $shared_data(io_timing_method)"
                    }
                }
            }
            "source_sync_source_clock" -
            "source_sync_dest_clock" -
            "" { }
            default {
                return -code error "Unknown value for clock_configuration in\
                    init_timing_req: $other_data(clock_configuration)"
            }
        }
        
    
    }
    
    #######################################
    #
    proc on_io_timing_method { args } {

        set options {
            { "normal_pattern.arg" "" "Frame to use for the widgets" }
            { "widgets.arg" "" "Widgets to enable/disable" }
        }
        array set opts [::cmdline::getoptions args $options]

        foreach w $opts(widgets) {
            switch -regexp -- $w \
                $opts(normal_pattern) { $w configure -state "normal" } \
                default { $w configure -state "disabled" }
        }
        
        # Force transfer cycles to zero or one if necessary (skew method)
        check_shift_and_duration
        
        # Enable or disable the duration buttons
        configure_duration_widgets
    }

    ##############################################
    # Ensure that all necessary fields are filled
    # in on the timing requirements tab.
    # Return an error if there are problems.
    # If you use the -silent flag, don't return the error text, just 0 if the
    # fields aren't filled in, and 1 if they are
    proc validate_target { args } {
    
        set options {
            { "data_var.arg" "" "Name of the variable to populate with results" }
            { "error_messages_var.arg" "" "Name of the variable to hold error messages" }
            { "pre_validation.arg" "" "How to handle prevalidation" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data

        # Things are valid or not. If anything is invalid, set to zero.
        set is_valid 1
        
        # We may want to get information back, particularly during the back/next
        # process. If there's no data variable specified, set up a dummy
        # array to hold the results. Else connect the results array to the
        # variable for the data.
        if { [string equal "" $opts(data_var)] } {
            array set results [list]
        } else {
            upvar $opts(data_var) results
        }
        
        # We may want to get error messages back. If we do, hook
        # up the error messages var to the specified variable.
        if { [string equal "" $opts(error_messages_var)] } {
            set error_messages [list]
        } else {
            upvar $opts(error_messages_var) error_messages
        }

        # Do prevalidation if necessary
        # I'm not sure there's any to do for the target
        switch -exact -- $opts(pre_validation) {
            "skip" { }
            "run_and_return" -
            "return_on_invalid" {
            }
            default {
                return -code error "Unknown option for -pre_validation in\
                    validate_target: $opts(pre_validation)"
            }
        }
        switch -exact -- $opts(pre_validation) {
            "skip" { }
            "run_and_return" { return $is_valid }
            "return_on_invalid" { if { ! $is_valid } { return $is_valid } }
        }
        # End of pre-validation


        switch -exact -- $shared_data(constraint_target) {
            "fpga" -
            "external" {
                # Good
            }
            default {
                lappend error_messages [list "You must select a target for the\
                    timing requirements - FPGA or external device"]
                set is_valid 0
            }
        }
        
        return $is_valid
    }
    
    ##############################################
    # Ensure that all necessary fields are filled
    # in on the timing requirements tab.
    # Return an error if there are problems.
    # If you use the -silent flag, don't return the error text, just 0 if the
    # fields aren't filled in, and 1 if they are
    proc validate_requirements { args } {
    
        set options {
            { "data_var.arg" "" "Name of the variable to populate with results" }
            { "error_messages_var.arg" "" "Name of the variable to hold error messages" }
            { "pre_validation.arg" "" "How to handle prevalidation" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable shared_data
        variable other_data
        
        # Things are valid or not. If anything is invalid, set to zero.
        set is_valid 1
        
        # We may want to get information back, particularly during the back/next
        # process. If there's no data variable specified, set up a dummy
        # array to hold the results. Else connect the results array to the
        # variable for the data.
        if { [string equal "" $opts(data_var)] } {
            array set results [list]
        } else {
            upvar $opts(data_var) results
        }
        
        # We may want to get error messages back. If we do, hook
        # up the error messages var to the specified variable.
        if { [string equal "" $opts(error_messages_var)] } {
            set error_messages [list]
        } else {
            upvar $opts(error_messages_var) error_messages
        }

        
        # Do prevalidation if necessary
        # I'm not sure there's any to do for the target
        switch -exact -- $opts(pre_validation) {
            "skip" { }
            "run_and_return" -
            "return_on_invalid" {

                if { [string equal "" $other_data(constraint_target)] } {
                    lappend error_messages [list "You must select a target for the\
                        timing requirements - FPGA or external device"
                    set is_valid 0
                }
                if { [string equal "" $other_data(direction)] || [string equal "" $other_data(data_rate)] } {
                    lappend error_messages [list "You must choose data ports or a bus to\
                        constrain before you select the interface clock configuration"]
                    set is_valid 0
                }
                if { [string equal "" $other_data(clock_configuration)] } {
                    lappend error_messages [list "You must select the interface clock\
                        configuration before you enter timing requirements"]
                    set is_valid 0
                }
            }
            default {
                return -code error "Unknown option for -pre_validation in\
                    validate_target: $opts(pre_validation)"
            }
        }
        switch -exact -- $opts(pre_validation) {
            "skip" { }
            "run_and_return" { return $is_valid }
            "return_on_invalid" { if { ! $is_valid } { return $is_valid } }
        }
        # End of pre-validation


        # Check I/O timing values
        switch -exact -- $shared_data(io_timing_method) {
            "max_skew" {
                if { ![regexp {[0-9]} $shared_data(max_skew)] } {
                    lappend error_messages [list "You must enter a value for the maximum\
                        skew time"]
                    set is_valid 0
                }
            }
            "min_valid" {
                if { ![regexp {[0-9]} $shared_data(min_valid)] } {
                    lappend error_messages [list "You must enter a value for the minimum\
                        data valid time"]
                    set is_valid 0
                }
            }
            "setup_hold" {
                if { ![regexp {[0-9]} $shared_data(setup)] } {
                    lappend error_messages [list "You must enter a value for the setup\
                        time"]
                    set is_valid 0
                }
                if { ![regexp {[0-9]} $shared_data(hold)] } {
                    lappend error_messages [list "You must enter a value for the hold\
                        time"]
                    set is_valid 0
                }
            }
            "clock_to_out" {
                if { ![regexp {[0-9]} $shared_data(tco_max)] } {
                    lappend error_messages [list "You must enter a value for the maximum\
                        clock to out time"]
                    set is_valid 0
                }
                if { ![regexp {[0-9]} $shared_data(tco_min)] } {
                    lappend error_messages [list "You must enter a value for the minimum\
                        clock to out time"]
                    set is_valid 0
                }
            }
            default {
                lappend error_messages [list "You must select an IO timing method."]
                set is_valid 0
            }
        }
        
        # If appropriate, check board timing values
        switch -exact -- $other_data(constraint_target) {
        "fpga" { }
        "external" {
if { 0 } {        
            switch -exact -- $shared_data(board_timing_method) {
                "min_max" {
                if { ![regexp {[0-9]} $shared_data(max_clock_trace_delay)] } {
                    lappend error_messages [list "You must enter a value for the maximum\
                        clock trace delay"]
                    set is_valid 0
                }
                if { ![regexp {[0-9]} $shared_data(min_clock_trace_delay)] } {
                    lappend error_messages [list "You must enter a value for the minimum\
                        clock trace delay"]
                    set is_valid 0
                }
                if { ![regexp {[0-9]} $shared_data(max_data_trace_delay)] } {
                    lappend error_messages [list "You must enter a value for the maximum\
                        data trace delay"]
                    set is_valid 0
                }
                if { ![regexp {[0-9]} $shared_data(min_data_trace_delay)] } {
                    lappend error_messages [list "You must enter a value for the minimum\
                        data trace delay"]
                    set is_valid 0
                }
                }
                "typ_tolerance" {
                if { ![regexp {[0-9]} $shared_data(clock_trace)] } {
                    lappend error_messages [list "You must enter a value for the typical\
                        clock trace delay"]
                    set is_valid 0
                }
                if { ![regexp {[0-9]} $shared_data(clock_trace_tolerance)] } {
                    lappend error_messages [list "You must enter a value for the clock\
                        trace delay tolerance"]
                    set is_valid 0
                }
                if { ![regexp {[0-9]} $shared_data(data_trace)] } {
                    lappend error_messages [list "You must enter a value for the typical\
                        data trace delay"]
                    set is_valid 0
                }
                if { ![regexp {[0-9]} $shared_data(data_trace_tolerance)] } {
                    lappend error_messages [list "You must enter a value for the data\
                        trace delay tolerance."]
                    set is_valid 0
                }
                }
                default {
                    lappend error_messages [list "You must choose a board timing method"]
                    set is_valid 0
                }
            }
}
        }
        default {
            lappend error_messages [list "You must choose a constraint target"]
            set is_valid 0
        }
        }
    
        return $is_valid
    }

}

################################################################################
# General purpose dialog with a text frame. Use it to display SDC preview,
# reporting file preview, and known issues
namespace eval text_dialog {

    # GUI elements for the text display dialog
    variable text_dialog
    variable text_dialog_tf
    variable text_dialog_text_widget

    ##############################################
    # Assemble a dialog for the name finder
    proc assemble_dialog { args } {
    
        set options {
            { "parent.arg" "" "Parent widget of the dialog" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        variable text_dialog
        variable text_dialog_tf
        variable text_dialog_text_widget
        
        set text_dialog [Dialog .text_dialog -modal local -side bottom \
            -anchor e -parent $opts(parent) -title "" \
            -cancel 1 -transient no]
        $text_dialog add -text "Close" -width 10
        
        set f [$text_dialog getframe]

        # Titleframe for SDC constraints
        set text_dialog_tf [TitleFrame $f.tf -text "" -ipad 8]
        set sub_f [$text_dialog_tf getframe]
        
        # Scrolled text widget for constraints
        set sw [ScrolledWindow $sub_f.sw -auto both]
        set text_dialog_text_widget [text $sw.txt -relief sunken \
            -wrap "none" -height 40]
        $sw setwidget $text_dialog_text_widget
        pack $sw -side top -fill both -expand true

        pack $text_dialog_tf -side top -anchor nw -fill both -expand true
        
        # Configure a text tag
        $text_dialog_text_widget tag configure fixed -font "courier 8"

        wm protocol $text_dialog WM_DELETE_WINDOW [list $text_dialog withdraw]
    }
    
    #################################################
    # Handle the text dialog
    proc update_dialog { args } {
    
        set options {
            { "append.arg" "" "Text to put in" }
            { "show" "Draw the dialog" }
            { "withdraw" "Withdraw the dialog" }
            { "get_text" "Return the text in the dialog text widget" }
            { "erase" "Clean out the dialog text" }
            { "title.arg" "" "New title for the and title frame" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        variable text_dialog
        variable text_dialog_tf
        variable text_dialog_text_widget
        
        # If we want the text, just do that and return
        if { $opts(get_text) } {
            return [$text_dialog get 1.0 end]
        }
        
        # Do these separately so we can chain all the options together
        # in one command
        if { $opts(erase) } {
            $text_dialog_text_widget delete 1.0 end
        }
        
        if { ! [string equal "" $opts(append)] } {
            $text_dialog_text_widget insert end $opts(append) fixed
        }

        if { ! [string equal "" $opts(title)] } {
            $text_dialog configure -title $opts(title)
            $text_dialog_tf configure -text $opts(title)
        }

        if { $opts(show) } { $text_dialog draw }
        if { $opts(withdraw) } { $text_dialog withdraw }
    }
    
}

################################################################################
# include duplicates of clocks constrained in other SDC files
namespace eval sdc_info {

    # Variables that back GUI elements
    variable line_wrap          0
    variable sdc_output_file        ""
    variable reporting_output_file  ""
    variable gen_lb                 ""
    variable preview_buttons        [list]
    
    # Variables for advanced settings
    variable pt_compatible      0
    variable alignment_method   "period"
    variable duplicate_clocks "as_comments"

    variable images
    array set images [list]

    variable src_clock
    variable dest_clock
    variable direction
    
    # Internal state variables
    variable done_and_checked       0
    variable sdc_file_text          ""
    variable reporting_script_text  ""
    
    ############################################################################
    # Assembles an array of two images, one that is an empty square and one
    # that is a checked square.
    proc create_images { args } {
    
        variable images

        array unset icon_data
        set icon_data(unchecked) {
        #define unchecked_width 11
        #define unchecked_height 11
        static unsigned char unchecked_bits[] = {
           0xff, 0x07, 0x01, 0x04, 0x01, 0x04, 0x01, 0x04, 0x01, 0x04, 0x01, 0x04,
           0x01, 0x04, 0x01, 0x04, 0x01, 0x04, 0x01, 0x04, 0xff, 0x07};
        }
        set icon_data(checked) {
        #define checked_width 11
        #define checked_height 11
        static unsigned char checked_bits[] = {
           0xff, 0x07, 0x01, 0x04, 0x01, 0x05, 0x81, 0x05, 0xc5, 0x05, 0xed, 0x04,
           0x7d, 0x04, 0x39, 0x04, 0x11, 0x04, 0x01, 0x04, 0xff, 0x07};
        }
        foreach n [array names icon_data] {
            set images($n) [image create bitmap -data $icon_data($n)]
        }
        foreach n [array names icon_data] {
            set images(gray${n}) [image create bitmap -data $icon_data($n)]
        }
        foreach n [array names images gray*] {
            $images($n) configure -foreground "grey50"
        }
    }
    
    #########################################
    #
    proc assemble_tab { args } {
    
        set options {
            { "frame.arg" "" "Frame to assemble the tab on" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable line_wrap
        variable sdc_output_file
        variable reporting_output_file
        variable gen_lb
#        variable view_sdc_button
        variable preview_buttons
        
        set f $opts(frame)

        # Titleframe for interfaces to generate
        set gen_tf [TitleFrame $f.gentf -text "Generate SDC file for" -ipad 8]
        set sub_f [$gen_tf getframe]
        
        grid [label $sub_f.l0 -text "Select bus(es) to generate an SDC file\
            and optional reporting script for." -justify left] -sticky w
        grid [label $sub_f.l1 -text "If a bus name is grayed out,\
            you must finish configuring it before you can generate SDC for it." \
            -justify left] -sticky w
        grid [Separator $sub_f.sep -relief groove] -sticky ew -pady 5
        
        set gen_sw [ScrolledWindow $sub_f.sw -auto both]
        set gen_lb [ListBox $gen_sw.lb -bg white -deltay 16 -height 8]
        $gen_sw setwidget $gen_lb
        grid $gen_sw -sticky news
        
        # Make the scrolled window and listbox expand to fill the space
        grid columnconfigure $sub_f 0 -weight 1
        grid rowconfigure $sub_f 3 -weight 1
        grid $gen_tf -sticky news
        
        # Try putting the output files box here
        set of_tf [TitleFrame $f.files -text "Output files" -ipad 8]
        set sub_f [$of_tf getframe]
        
        pack [label $sub_f.l0 -text "Enter file names or browse to select files\
            for the SDC constraints and reporting script." -justify left] \
            -side top -anchor nw
        pack [label $sub_f.l1 -text "If a file name is blank, the file will not be\
            generated. Files are automatically saved when you click Finish" \
            -justify left] -side top -anchor nw
        pack [label $sub_f.l2 -text "You must add the generated SDC file to your\
            project files list for it to be used during fitting and timing analysis" \
            -justify left] -side top -anchor nw
        pack [Separator $sub_f.sep -relief groove] -side top -fill x -expand true -pady 5
        
        # Set up the stuff to save the SDC constraints out to a file
        set cf_lf [LabelFrame $sub_f.cf -text "SDC file" -side left]
        set ssub_f [$cf_lf getframe]
        set cf_en [entry $ssub_f.e \
            -textvariable [namespace which -variable sdc_output_file]]
        set cf_browse [button $ssub_f.bb -text "Browse..." -width 10]
        set cf_preview [button $ssub_f.bp -text "Preview" -width 10 -command \
            [namespace code show_sdc]]
        pack $cf_preview -side right
        pack $cf_browse -side right -padx 5
        pack $cf_en -side right -fill x -expand true
        pack $cf_lf -side top -anchor n -fill x -expand true
        
        # Set up the stuff for the reporting script
        set rs_lf [LabelFrame $sub_f.rs -text "Reporting script" -side left]
        set ssub_f [$rs_lf getframe]
        set rs_en [entry $ssub_f.e \
            -textvariable [namespace which -variable reporting_output_file]]
        set rs_browse [button $ssub_f.bb -text "Browse..." -width 10]
        set rs_preview [button $ssub_f.bp -text "Preview" -width 10 -command \
            [namespace code show_script]]
        pack $rs_preview -side right
        pack $rs_browse -side right -padx 5
        pack $rs_en -side right -fill x -expand true
        pack $rs_lf -side top -anchor n -fill x -expand true -pady 5
        
        # Save the preview buttons
        set preview_buttons [list $cf_preview $rs_preview]
        
        # Align the two label frame titles
        LabelFrame::align $cf_lf $rs_lf

        # Let the user save out the files
        pack [Button $sub_f.save -text "Save files" -width 10] -side top
        $sub_f.save configure -command [namespace code on_save_files]
        
#        pack $of_tf -side top -fill x -expand true
        grid [frame $f.foo] -sticky news  -pady 5
        grid $of_tf -sticky news

        
        grid [button $f.as -text "Advanced settings..." -state disabled \
            -command [namespace code on_advanced_settings] -width 20] -sticky w
        
        grid rowconfigure $f 0 -weight 1
        grid columnconfigure $f 0 -weight 1
        
        # Bind the checkboxes in the list
        $gen_lb bindImage <Button-1> "[namespace code on_generate_lb] \
            -sel"
            
        # Set up for browsing to save output files
        $cf_browse configure -command [namespace code [list show_save_dialog \
            -filetypes {{{SDC Files} {.sdc} }} -entry_widget $cf_en]]
        $rs_browse configure -command [namespace code [list show_save_dialog \
            -filetypes {{{Tcl Files} {.tcl} }} -entry_widget $rs_en]]
    
    }

    ###################################################
    # When we populate the listbox, we already know the checked
    # or unchecked state of all the interfaces, in the checked_interfaces
    # namespace. The (un)checked state got put in there when the
    # interfaces were first populated (read from the data file)
    # Therefore, there is no need to actually add them here.
    # However, it is only at the listbox population time that we calculate
    # how many done and checked interfaces there are.
    proc populate_generate_lb { args } {
    
        set options {
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable gen_lb
        variable images
        variable done_and_checked
        
        # Clean out the listbox first
        $gen_lb delete [$gen_lb items]
        
        # Track how many interfaces that are done
        set done_and_checked 0
        
        foreach interface [interfaces::get_interfaces -all_but_create] {
        
            # Insert the interface in the listbox, then choose its color
            # and image.
            set interface_name [interfaces::get_interface_info -interface $interface -name]
            $gen_lb insert end $interface -text $interface_name
            
            array unset t
            array set t [interfaces::get_interface_info -interface $interface \
                -keys [list "pages_to_see"]]
            set done [expr { 0 == [llength $t(pages_to_see)] }]
            
            # Display the interface name grayed out if it's not done
            if { ! $done } {
                $gen_lb itemconfigure $interface -foreground "grey50"
            }
            
            # Is the interface checked or not?
            if { ! [checked_interfaces::is_checked $interface] } {
                # Not checked
                if { $done } {
                    $gen_lb itemconfigure $interface -image $images(unchecked)
                } else {
                    $gen_lb itemconfigure $interface -image $images(grayunchecked)
                }
            } else {
                # Checked
                if { $done } {
                    $gen_lb itemconfigure $interface -image $images(checked)
                    incr done_and_checked
                } else {
                    $gen_lb itemconfigure $interface -image $images(graychecked)
                }
            }
        }

        # The preview button may have to be disabled if there are no
        # done and checked interfaces.
        enable_disable_preview_buttons -status $done_and_checked
    }
    
    ##############################################################
    # Erase the text currently in the textbox
    # Generate the SDC
    # Insert it in the textbox
    # Draw the dialog.
    proc show_sdc { args } {
    
        generate_sdc_constraints
        text_dialog::update_dialog -erase -append [update_sdc_text -get] \
            -title "SDC Constraints" -show
    }

    ##############################################################
    # Erase the text currently in the textbox
    # Generate the SDC
    # Insert it in the textbox
    # Draw the dialog.
    proc show_script { args } {
    
        generate_reporting_script
        text_dialog::update_dialog -erase -append [update_reporting_text -get] \
            -title "Reporting script" -show
    }

    ################################################
    # Configure the text widget to wrap lines or not
    proc toggle_line_wrap { widget wrap_var } {
    
        upvar $wrap_var wrap
    
        if { $wrap } {
            $widget configure -wrap "word"
        } else {
            $widget configure -wrap "none"
        }
    }

    ############################################
    #
    proc on_advanced_settings { args } {

        variable pt_compatible
        variable alignment_method
        variable duplicate_clocks
        
        if { [advanced_info::show_dialog -pt_compatible_var pt_compatible \
            -alignment_method_var alignment_method \
            -duplicate_clocks_var duplicate_clocks] } {
            # The user changed a setting
#            create_sdc
        } else {
            # The user didn't change settings
        }
    }

    ############################################################################
    # Handle the list of checked interfaces and handle drawing in the correct
    # checked or unchecked image.
    proc on_generate_lb { args } {
    
        set options {
            { "sel.arg" "" "Selection"}
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable gen_lb
        variable images
        variable done_and_checked
        
        # If there's no selection passed in, return
        if { [string equal "" $opts(sel)] } { return }
        
        set current_image [$gen_lb itemcget $opts(sel) -image]

        # If the image is gray, just return - can't generate SDC because it's
        # not done
        if { [string equal $images(graychecked) $current_image] || \
            [string equal $images(grayunchecked) $current_image] } { return }
        
        # Find out whether the interface has a checked box or an unchecked box
        if { [string equal $images(checked) $current_image] } {
            # The interface is checked. Remove it and change to unchecked
            checked_interfaces::remove $opts(sel)
            incr done_and_checked -1
            $gen_lb itemconfigure $opts(sel) -image $images(unchecked)
        
        } elseif { [string equal $images(unchecked) $current_image] } {
            # The interface is unchecked. Add it and change to checked
            checked_interfaces::add $opts(sel)
            incr done_and_checked
            $gen_lb itemconfigure $opts(sel) -image $images(checked)

        } else {
            return -code error "Unknown image in generate listbox"
        }

        enable_disable_preview_buttons -status $done_and_checked
    }
    
    #######################################################
    proc enable_disable_preview_buttons { args } {
    
        set options {
            { "status.arg" "" "Status - enable or disable them"}
        }
        array set opts [::cmdline::getoptions args $options]

        variable preview_buttons
        
        # If there are done interfaces that are checked, enable the button
        # Otherwise, if nothing done is checked, there's nothing to view
        if { 0 < $opts(status) } {
            foreach w $preview_buttons { $w configure -state normal }
        } elseif { 0 == $opts(status) } {
            foreach w $preview_buttons { $w configure -state disabled }
        } else {
            return -code error "Can not have fewer than zero done and checked\
                interfaces in enable_disable_preview_buttons"
        }
    }
    
    #######################################################
    # Show the save box for the SDC constraints or the Tcl reporting file
    proc show_save_dialog { args } {
    
        set options {
            { "filetypes.arg" "" "File types list" }
            { "entry_widget.arg" "" "Name of the entry widget for the textvariable"}
        }
        array set opts [::cmdline::getoptions args $options]
    
        upvar [$opts(entry_widget) cget -textvariable] output_file
        
        set dialog_result [tk_getSaveFile -filetypes $opts(filetypes) -initialfile $output_file]
        
        if { [string equal "" $dialog_result]} {
        } else {
            set output_file $dialog_result
            $opts(entry_widget) xview moveto 1.0
        }
    }
    
    ################################################################################
    # Attempt to write out the contents of the specified textbox to the
    # specified output file name. Return 1 if successful, 0 otherwise
    proc write_out_file { args } {
    
        set options {
            { "file_name.arg" "" "Output file name" }
            { "text.arg" "" "Text to write to the file" }
        }
        array set opts [::cmdline::getoptions args $options]
        
        # Attempt to open the file for writing
        if { [catch { open $opts(file_name) w } res] } {
            # If there was an error opening the file, display it and return
            tk_messageBox -icon error -type ok -default ok \
                -title "Error opening file" -parent [focus] -message $res 
            return 0
        } elseif { [catch { puts $res $opts(text) } err] } {
            # Used to come from [$sdc_constraints get 1.0 end]
            # Put the contents of the textbox into the file
            # If there's an error, display it, attempt to close the file,
            # and return
            tk_messageBox -icon error -type ok -default ok \
                -title "Error saving file" -parent [focus] -message $err
            catch { close $fh }
            return 0
        } else {
            # There was no error writing the file
            # Attempt to close the file and return
            if { [catch { close $res } err] } {
                tk_messageBox -icon error -type ok -default ok \
                    -title "Error saving file" -parent [focus] -message $err
                return 0
            } else {
                return 1
            }
        }
    }

    ################################################################################
    proc generate_clocks_sdc { args } {
    
        set options {
            { "index.arg" "end" "Insertion index" }
            { "existing_names.arg" "" "Names of clocks defined in SDC files" }
            { "new_names.arg" "" "Names of the new clocks created this session" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable duplicate_clocks

        set ret_str ""
        
        # Put the insertion cursor wherever we want
        set sdc_for_existing [project_info::get_clock_creation_sdc_commands \
            -clock_names $opts(existing_names)]
        set sdc_for_new [project_info::get_clock_creation_sdc_commands \
            -clock_names $opts(new_names)]
        
        append ret_str "# Clock constraints\n"
        
        # If there are existing clocks, we have something special to
        # do with them. If there are also some new clocks, some of the
        # clocks were already defined in SDC files. If there are no
        # new clocks, all of the clocks were already defined in SDC files.
        if { 0 < [llength $sdc_for_existing] } {
            if { 0 < [llength $sdc_for_new] } {
                set comment "\n# Some"
            } else {
                set comment "\n# All"
            }
            append ret_str "$comment clocks for your interface\
                are constrained in other SDC files in your project.\n"
            switch -exact -- $duplicate_clocks {
            "as_comments" {
                append ret_str "# Those clock constraints are\
                    included here as comments.\n"
                foreach clock_constraint $sdc_for_existing {
                    append ret_str "# $clock_constraint\n"
                }
            }
            "as_valid" {
                append ret_str "# Those clock constraints are\
                    duplicated here.\n"
                foreach clock_constraint $sdc_for_existing {
                    append ret_str "$clock_constraint\n"
                }
            }
            "dont_include" {
                append ret_str "# Those clock constraints are\
                    not included in this file.\n"
            }
            default {
                return -code error "Unknown value for duplicate_clocks in\
                    generate_clocks_sdc: $duplicate_clocks"
            }
            }
        }
        
        append ret_str "\n"
        
        if { 0 < [llength $sdc_for_new] } {
            if { [project_info::get_read_sdc_checkbutton_value] } {
                append ret_str "# The following new clock\
                    constraints do not exist in SDC files that were read.\n"
            }
            foreach clock_constraint $sdc_for_new {
                append ret_str "$clock_constraint\n"
            }
        }
        append ret_str "\n"

        return $ret_str
    }
    
    ################################################################################
    # Default setup relationship is always to a rising edge for SDR
    # This procedure is going to be a mess of all kinds of multi-level
    # cases - input/output, sdr/ddr, clock_configuration, etc, etc, etc
    proc new_sdc { args } {

        set options {
            { "data.arg" "" "Data for the interface" }
            { "dash_add_var.arg" "" "Name of array for tracking use of -add" }
        }
        array set opts [::cmdline::getoptions args $options]
        
#        variable sdc_constraints
        set ret_str ""
        
        array set data $opts(data)
        upvar 1 $opts(dash_add_var) port_and_dash_add
        
        # Strings with the {in,out}put max and min delays
        set max ""
        set min ""
        
        # Arrays with the terms that have to be adjusted if we shift by periods.
        # For example, if modified_max(setup) exists, the value for it is the
        # new symbolic expression to be substituted into the equation in place
        # of setup, that accounts for the period shift. 
        array set modified_max [list]
        array set modified_min [list]
        
        # Set setup/hold edge pairs to do constraints for
        set constraint_pairs [list]
        
        # for multicycles and false paths
        set multicycles [list]
        set exceptions [list]
        
        # Which pairs get cut for false paths?
        # Nothing gets cut (leave them blank) for SDR
        array set setup_cut_edges [list]
        array set hold_cut_edges [list]
        foreach e $data(extra_setup_cuts) { set setup_cut_edges($e) 1 }
        foreach e $data(extra_hold_cuts) { set hold_cut_edges($e) 1 }
#        array set setup_cut_edges $data(extra_setup_cuts)
#        array set hold_cut_edges $data(extra_hold_cuts)

        # put in defaults for multicycles
        set setup_dms 1
        set setup_dmh 0
        set setup_sms 1
        set setup_smh 0
        set hold_dms 1
        set hold_dmh 0
        set hold_sms 1
        set hold_smh 0

        # Hold the clock name to determine whether to use -add
        set clock_name ""
        
        # Do some sanity checking
        # 1. If we're doing skew method for the output, require zero transfer cycles
        if { [string equal "max_skew" $data(io_timing_method)] && \
            [string equal "output" $data(direction)]} {
            switch -exact -- $data(adjust_cycles) {
                "src" {
                    if { 0 != $data(src_transfer_cycles) } {
                        post_message -type warning "Skew alignment method\
                            requires 0 transfer cycles, but transfer cycles\
                            is set to $data(src_transfer_cycles).\
                            Using a value of 0."
                        set data(src_transfer_cycles) 0
                    }
                }
                "dest" {
                    if { 0 != $data(dest_transfer_cycles) } {
                        post_message -type warning "Skew alignment method\
                            requires 0 transfer cycles, but transfer cycles\
                            is set to $data(dest_transfer_cycles).\
                            Using a value to 0."
                        set data(dest_transfer_cycles) 0
                    }
                }
                default {
                    return -code error "Unknown value for adjust_cycles in\
                        new_sdc: $data(adjust_cycles)"
                }
            }
        } elseif { [string equal "ddr" $data(data_rate)] } {
            switch -exact -- $data(adjust_cycles) {
                "src" {
                    if { 1 != $data(src_transfer_cycles) } {
                        post_message -type warning "DDR interfaces\
                            require 1 transfer cycle, but transfer cycles\
                            is set to $data(src_transfer_cycles).\
                            Using a value of 1."
                        set data(src_transfer_cycles) 1
                    }
                }
                "dest" {
                    if { 1 != $data(dest_transfer_cycles) } {
                        post_message -type warning "DDR interfaces\
                            require 1 transfer cycle, but transfer cycles\
                            is set to $data(dest_transfer_cycles).\
                            Using a value to 1."
                        set data(dest_transfer_cycles) 1
                    }
                }
                default {
                    return -code error "Unknown value for adjust_cycles in\
                        new_sdc: $data(adjust_cycles)"
                }
            }
        
        }
        
        # Get the source and dest clock periods and phases
        set src_clock_id [util::get_clock_id -clock_name $data(src_clock_name)]
        set dest_clock_id [util::get_clock_id -clock_name $data(dest_clock_name)]
        set data(src_clock_period) [get_clock_info -period $src_clock_id]
        set data(dest_clock_period) [get_clock_info -period $dest_clock_id]
        foreach { data(dest_clock_phase) foo } [get_complete_phase_shift \
            -clock_id $dest_clock_id] { break }
        foreach { data(src_clock_phase) foo } [get_complete_phase_shift \
            -clock_id $src_clock_id] { break }
        
        # src_shift_cycles and dest_shift_cycles adjust setup multicycle
        # src_transfer_cycles and dest_transfer_cycles adjust hold multicycle
        log::log_message "\nLooking up delay equations\n-----------------"
        switch -exact -- $data(direction) {
        "output" {
        
            switch -exact -- $data(io_timing_method) {
            
                "setup_hold" {
                    # output max delay is setup
                    set max "setup"
                    # output min delay is -hold
                    set min "-1 * hold"
                    
                    switch -exact -- $data(alignment_method) {
                    "period" {
                        # Window to the right means decrease output delay max,
                        # which means make setup less.
                        # To push the setup earlier by a cycle (-1), add a period
                        # to the setup value. Do that by subtracting the negative
                        # To extend hold to the right, subtract from it.
                        # So if you're shifting right (positive number), the subtracted value
                        # will be getting larger, resulting in a more negative number.
                        set modified_max(setup) "setup - (%end%_shift_cycles * %end%_clock_period)"
                        set modified_max(hold) "hold - (%end%_shift_cycles * %end%_clock_period)"
                        
                        # To lengthen the transfer time, decrease output delay min
                        # Do that by increasing the hold value to make it a
                        # greater negative magnitude
                        set modified_min(hold) "hold +\
                            ((%end%_transfer_cycles - 1) * %end%_clock_period)"
                    }
                    "mc" { }
                    default {
                        return -code error "Unknown value for alignment_method in\
                            new_sdc: $data(alignment_method)"
                    }
                    }
                    # modified max and min setup and hold numbers are correct
                    # without parentheses around the whole thing
        
                }
                "clock_to_out" {
                    # output max delay is latch - launch - tcomax
                    set max "latch_time - launch_time - tco_max"
                    # output min delay is -tco_min
                    set min "-1 * tco_min"

                    switch -exact -- $data(alignment_method) {
                    "period" {
                        # Window -> right means decrease output delay max,
                        # which means make tco_max bigger.
                        # TODO - does tco_max need the cycles adjustment,
                        # because it already has latch - launch.
                        set modified_max(tco_max) "tco_max -\
                            (%end%_shift_cycles * %end%_clock_period)"
                        # Increasing duration means decreasing the ODmin
                        # tco_min is just like hold above.
                        set modified_max(tco_min) "tco_min - (%end%_shift_cycles * %end%_clock_period)"

                        set modified_min(tco_min) "tco_min +\
                            ((%end%_transfer_cycles - 1)* %end%_clock_period)"
                    }
                    "mc" { }
                    default {
                        return -code error "Unknown value for alignment_method in\
                            new_sdc: $data(alignment_method)"
                    }
                    }
                    # modified max and min tco_max and tco_min numbers are correct
                    # without parentheses around the whole thing
                }
                "max_skew" {
                    # output max delay is -skew
                    set max "-1 * max_skew"
                    # output min delay is skew
                    set min "max_skew"

if { 0 } {
                    set modified_max(max_skew) "max_skew -\
                        (%end%_clock_period * %end%shift_cycles)"
                    set modified_min(max_skew) "max_skew -\
                        (%end%_clock_period * (%end%_shift_cycles + 1))"
}
                    set modified_max(max_skew) "max_skew +\
                        ((degree_shift / 360.0) * %end%_clock_period) -\
                        (%end%_shift_cycles * %end%_clock_period)"
                    set modified_min(max_skew) "max_skew +\
                        ((degree_shift / 360.0) * %end%_clock_period) -\
                        ((%end%_shift_cycles + 1) * %end%_clock_period)"

                }
                "min_valid" {
                    # output max delay is
                    # output min delay is
                }
                default {
                    return -code error "Unknown value for io_timing_method in\
                        new_sdc: $data(io_timing_method)"
                }
            }
        }
        "input" {
            switch -exact -- $data(io_timing_method) {        
                "setup_hold" {
                    # input max delay is latch - launch - setup -
                    # clock period * phase difference/360
                    set max "latch_time - launch_time - setup"
                    # input min delay is hold -
                    # clock period * phase difference/360
                    set min "latch_time - launch_time + hold"
                    
                    switch -exact -- $data(alignment_method) {
                    "period" {
                        # TODO - I'm not sure these need the shift cycles
                        # to be added, because max and min already have
                        # latch and launch times in them
                        # Window to the right means increase input delay max,
                        # which means make setup less.
                        set modified_max(setup) "setup + (%end%_shift_cycles * %end%_clock_period)"
                        # To lengthen the transfer time, increase input delay min
                        # Do that by increasing the hold value
                        set modified_max(hold) "hold + (%end%_shift_cycles * %end%_clock_period)"

                        set modified_min(hold) "hold -\
                            ((%end%_transfer_cycles - 1) * %end%_clock_period)"
                    }
                    "mc" { }
                    default {
                        return -code error "Unknown value for alignment_method in\
                            new_sdc: $data(alignment_method)"
                    }
                    }
                    # modified max and min setup and hold numbers are correct
                    # without parentheses around the whole thing

                    # Additional adjustment:
                    # The correct setup/hold relationships should be based on the ideal
                    # degree_shift amount and the clock period. Doing latch - launch
                    # - setup works if the clocks are exactly "right", but if you
                    # shove a clock around to align stuff, then regenerate SDC,
                    # the setup relationship will be wrong unless we cancel out
                    # the shove amount.
                    # If you shove the clocks around, the launch/latch relationship
                    # can change, and you don't want that. So if the clocks have
                    # been moved, you have to introduce an adder to cancel out
                    # the effect.
#                    if { 0 != $data(degree_shift) || 0 != $data(dest_clock_phase) || \
#                        0 != $data(src_clock_phase) } { }
                    if { $data(degree_shift) != \
                        ($data(dest_clock_phase) - $data(src_clock_phase)) } {
                    
                        append max " - (dest_clock_period *\
                            (dest_clock_phase - src_clock_phase - degree_shift) / 360.0)"
                        append min " - (dest_clock_period *\
                            (dest_clock_phase - src_clock_phase - degree_shift) / 360.0)"
                    }
                }
                "clock_to_out" {
                    # output max delay is tcomax -
                    # clock period * phase difference/360
                    set max "tco_max"
                    # output min delay is tcomin -
                    # clock period * phase difference/360
                    set min "tco_min"

                    switch -exact -- $data(alignment_method) {
                    "period" {
                        # Window -> right means increase input delay max,
                        # which means make tco_max bigger.
                        set modified_max(tco_max) "tco_max + (%end%_shift_cycles * %end%_clock_period)"
                        # To lessen the transfer time, decrease input delay min.
                        set modified_max(tco_min) "tco_min + (%end%_shift_cycles * %end%_clock_period)"
                        
                        set modified_min(tco_min) "tco_min -\
                            ((%end%_transfer_cycles - 1) * %end%_clock_period)"
                    }
                    "mc" { }
                    default {
                        return -code error "Unknown value for alignment_method in\
                            new_sdc: $data(alignment_method)"
                    }
                    }
                    # modified max and min tco_max and tco_min numbers are correct
                    # without parentheses around the whole thing

if { 0 } {
                    # Additional adjustments:
                    # take clock phase difference into account when
                    # input data is not edge aligned
                    if { 0 != $data(degree_shift) } {
                        append max " - (src_clock_period *\
                            (dest_clock_phase - src_clock_phase) / 360.0)"
                        append min " - (src_clock_period *\
                            (dest_clock_phase - src_clock_phase) / 360.0)"
                    }
}

                }
                "max_skew" {
                    # input max delay is skew
                    set max "max_skew"
                    # input min delay is -skew
                    set min "-1 * max_skew"

                    set modified_max(max_skew) "max_skew +\
                        (latch_time - launch_time +\
                        ((%end%_shift_cycles + 1) * %end%_clock_period))"
                    set modified_min(max_skew) "max_skew -\
                        (latch_time - launch_time +\
                        ((%end%_shift_cycles + 1) * %end%_clock_period))"
                }
                "min_valid" {
                    # output max delay is
                    # output min delay is
                }
                default {
                    return -code error "Unknown value for io_timing_method in\
                        new_sdc: $data(io_timing_method)"
                }
            }
            
        }
        default {
            # Should never get here
            return -code error "Unknown value for direction in new_sdc:\
                $data(direction)"
        }
        }
        
        # When we get here, we have the max and min equations
        log::log_message "Basic equations for $data(io_timing_method) are:"
        log::log_message " max: $max"
        log::log_message " min: $min"

        util::get_transfer_edge_cuts \
            -register_name [lindex $data(data_register_names) 0] \
            -data_rate $data(data_rate) \
            -transfer_edge $data(transfer_edge) \
            -direction $data(direction) \
            -io_timing_method $data(io_timing_method) \
            -setup_cut_edges_var setup_cut_edges \
            -hold_cut_edges_var hold_cut_edges \
            -extra_setup_cuts $data(extra_setup_cuts) \
            -extra_hold_cuts $data(extra_hold_cuts) \
            -advanced_false_paths $data(advanced_false_paths)
        set constraint_pairs [list "rise" "rise" "rise" "fall" "fall" "rise" "fall" "fall"]
            
            
        # When we get here, we know the potential rise/fall transfers for the
        # setup and hold relationships. Also, setup_cut_edges and hold_cut_edges
        # have the rise/fall transfer pairs for the respective relationships
        # that will get false paths.
        # constraint_pairs gets used again when we're writing out the
        # I/O delays.
        log::log_message "Creating constraints for the following setup/hold edge combinations:"
        log::log_message " $constraint_pairs"
        log::log_message "Cutting the following setup edge combinations:"
        log::log_message " [array names setup_cut_edges]"
        log::log_message "Cutting the following hold edge combinations:"
        log::log_message " [array names hold_cut_edges]"
        
        # Is there any alignment to be done?
        # Come up with multicycle numbers to pass to find_clock_relationship
        # which returns launch and latch times
        # It seems sort of backwards, but if you're aligning with periods,
        # pass in these multicycle numbers to the call to 
        # find_clock_relationships. That's because period adjustment
        # is done in some cases by modifying launch and latch.
        # find_clock_relationship returns launch and latch times, given
        # clock periods and multicycles. 
        # If you're aligning with multicycles, use the values here from
        # get_cycle_shifts_2 for the set_multicycle_path exceptions,
        # then put them to the default values (setup=1, hold=0) after
        # exceptions are calculated. If you use multicycles, the launch
        # and latch are always the default.
        # was setup_multicycle_amount hold_multicycle_amount
        foreach { s_s h_s h_h } \
            [clock_diagram::get_cycle_shifts_2 \
            -direction $data(direction) \
            -adjust_cycles $data(adjust_cycles) \
            -src_shift_cycles $data(src_shift_cycles) \
            -dest_shift_cycles $data(dest_shift_cycles) \
            -src_transfer_cycles $data(src_transfer_cycles) \
            -dest_transfer_cycles $data(dest_transfer_cycles) \
            -transfer_edge $data(transfer_edge) \
            -data_rate $data(data_rate) \
            -dest_clock_phase $data(dest_clock_phase) \
            -src_clock_phase $data(src_clock_phase) \
            -io_timing_method $data(io_timing_method) \
            -multicycle] { break }

        log::log_message " get_cycle_shifts_2 returned the following"
        log::log_message "  setup rel setup mc = $s_s"
        log::log_message "  hold rel setup mc = $h_s"
        log::log_message "  hold rel hold mc = $h_h"

        # src_shift_cycles and dest_shift_cycles adjust setup multicycle
        # setup_multicycle_amount is one more than the number of cycle shifts.
        # Normally you have 0 cycle shifts. If you have +1, you're going out
        # to the next edge, for a multicycle of 2.
        switch -exact -- $data(adjust_cycles) {
            "src" {
                set setup_sms $s_s
                set hold_sms $h_s
                set hold_smh $h_h
            }
            "dest" {
                set setup_dms $s_s
                set hold_dms $h_s
                set hold_dmh $h_h
            }
            default {
                return -code error "Unknown value for adjust_cycles in\
                    new_sdc: $data(adjust_cycles)"
            }
        }
        
        # Now set up exceptions or additional periods
        log::log_message "\nDetermining additional alignment\n-----------------"
        switch -exact -- $data(io_timing_method) {
        "setup_hold" -
        "clock_to_out" {

            # We do different things if we're aligning by period or multicycle
            switch -exact -- $data(alignment_method) {
            "period" {
            
                set non_default_shift_cycles [expr {
                    ([string equal "src" $data(adjust_cycles)] && \
                    (0 != $data(src_shift_cycles))) || \
                    ([string equal "dest" $data(adjust_cycles)] && \
                    (0 != $data(dest_shift_cycles))) }]
                set non_default_transfer_cycles [expr {
                    ([string equal "src" $data(adjust_cycles)] && \
                    (1 != $data(src_transfer_cycles))) || \
                    ([string equal "dest" $data(adjust_cycles)] && \
                    (1 != $data(dest_transfer_cycles))) }]
                    
                # If we're changing period to shift cycles, we change
                # the max relationship
                if { $non_default_shift_cycles } {
    
                    # There's a non-default cycle shift
                    # Therefore, the setup or tco in the equation
                    # will be replaced with one that accounts for the shift.
                    # Cycle shifts can also affect hold
                    foreach term [array names modified_max] {
                        if { 0 != [regsub -- $term $max $modified_max($term) max] } {
                            # Good, we replaced something in max
                        } elseif { 0 != [regsub -- $term $min $modified_max($term) min] } {
                            # Good, we replaced something in min
                        } else {
                            post_message -type warning \
                                "Did not replace $term in $max or $min"
                        }
                    }
                    
                    # The regsub'ed string includes %end%, so that either
                    # src or dest can be substituted in.
                    if { 0 != [regsub -all -- {%end%} $max $data(adjust_cycles) max] } {
                        # Good, we regsub'ed the end in max
                    } elseif { 0 != [regsub -all -- {%end%} $min $data(adjust_cycles) min] } {
                        # Good, we regsub'ed the end in min
                    } else {
                        post_message -type warning \
                            "Could not substitute $data(adjust_cycles) in $max or $min"
                    }
                }
                
                # If we're changing period to change duration, we change
                # the min relationship
                if { $non_default_transfer_cycles } {
    
                    # There's a non-default cycle shift
                    # Therefore, the hold or tco_min in the equation
                    # will be replaced with one that accounts for the shift.
                    foreach term [array names modified_min] {
                        if { 0 == [regsub -- $term $min $modified_min($term) min] } {
                            post_message -type warning "Did not replace $term in $min"
                        }
                    }
                }

                # It number of transfer cycles has to be tracked relative to the
                # cycle shift. For example, if you change cycle shift, but not
                # transfer cycles, both the max and min values must change. 
                if { $non_default_shift_cycles || $non_default_transfer_cycles } {
    
                    # The regsub'ed string includes %end%, so that either
                    # src or dest can be substituted in.
                    if { 0 == [regsub -all -- {%end%} $min $data(adjust_cycles) min] } {
                        post_message -type warning "Could not substitute $data(adjust_cycles) in $min"
                    }
                }
            }
            "mc" {
                
                # src_shift_cycles and dest_shift_cycles adjust setup multicycle
                # setup_multicycle_amount is one more than the number of cycle shifts.
                # Normally you have 0 cycle shifts. If you have +1, you're going out
                # to the next edge, for a multicycle of 2.
                switch -exact -- $data(adjust_cycles) {
                    "src" { set setup_mc_type "start" }
                    "dest" { set setup_mc_type "end" }
                    default {
                        return -code error "Unknown value for adjust_cycles in\
                            new_sdc: $data(adjust_cycles)"
                    }
                }
                
                # The number of cycles it takes to transfer data affects the
                # hold value
                # Force the DDR values, but allow SDR values to be entered
                # by users
                switch -exact -- $data(data_rate) {
                    "sdr" {
                        # src_transfer_cycles and dest_transfer_cycles
                        # adjust hold multicycle
                        switch -exact -- $data(adjust_cycles) {
                            "src" { set hold_mc_type "start" }
                            "dest" { set hold_mc_type "end" }
                        }
                    }
                    "ddr" {
                        # Now that I know what the multicycle amount is,
                        # I have to put it in the correct source or dest.
                        switch -exact -- $data(adjust_cycles) {
                            "src" { set hold_mc_type "start" }
                            "dest" { set hold_mc_type "end" }
                        }
                    }
                    default {
                        return -code error "Unknown value for data_rate in\
                            new_sdc: $data(data_rate)"
                    }
                }
                
                # If there is a non-default amount to shift 
                if { 1 != $s_s } {
                
                    # Based on SDR or DDR, add one or two multicycle exceptions
                    switch -exact -- $data(data_rate) {
                    "sdr" {
                        lappend multicycles "set_multicycle_path\
                            -setup -${setup_mc_type}\
                            -from \[get_clocks $data(src_clock_name)\]\
                            -to \[get_clocks $data(dest_clock_name)\]\
                            $s_s"
                    }
                    "ddr" {
#                        foreach { setup_pair hold_pair } $constraint_pairs { }
                        foreach { setup_from setup_to } $constraint_pairs {
#                            foreach { setup_from setup_to } $setup_pair { break }
                            
#                            foreach { hold_from hold_to } $hold_pair { break }
                            # If we're putting a multicycle on a path that we've
                            # already decided will be cut, don't actually put on the mc.
                            # was if info exist setup cut edges
                            if { $setup_cut_edges($setup_from,$setup_to) } { continue }
                            
                            lappend multicycles "set_multicycle_path\
                                -setup -${setup_mc_type}\
                                -${setup_from}_from \[get_clocks $data(src_clock_name)\]\
                                -${setup_to}_to \[get_clocks $data(dest_clock_name)\]\
                                $s_s"
                        }
                    }
                    default {
                        return -code error "Unknown value for data_rate in\
                            new_sdc: $data(data_rate)"
                    }
                    }
                }
                # Done with applying any setup multicycles here
    
                # Handle any shifted edges with clock periods or multicycles.
                # If there is a non-default amount to shift
                if { 0 != $h_h } {
                
                    # Based on SDR or DDR, add one or two multicycle exceptions
                    switch -exact -- $data(data_rate) {
                    "sdr" {
                        lappend multicycles "set_multicycle_path\
                            -hold -${hold_mc_type}\
                            -from \[get_clocks $data(src_clock_name)\]\
                            -to \[get_clocks $data(dest_clock_name)\]\
                            $h_h"
                    }
                    "ddr" {
#                        foreach { setup_pair hold_pair } $constraint_pairs { }
                        foreach { hold_from hold_to } $constraint_pairs {
#                            foreach { setup_from setup_to } $setup_pair { break }

#                            foreach { hold_from hold_to } $hold_pair { break }
                            # If we're putting a multicycle on a path that we've
                            # already decided will be cut, don't do it.
                            if { $hold_cut_edges($hold_from,$hold_to) } { continue }

                            lappend multicycles "set_multicycle_path\
                                -hold -${hold_mc_type}\
                                -${hold_from}_from \[get_clocks $data(src_clock_name)\] \
                                -${hold_to}_to \[get_clocks $data(dest_clock_name)\]\
                                $h_h"
                        }
                    }
                    default {
                        return -code error "Unknown value for data_rate in\
                            new_sdc: $data(data_rate)"
                    }
                    }
                }
                # Done with applying any hold multicycles here

            }
            default {
                return -code error "Unknown value for alignment_method in\
                    new_sdc: $data(alignment_method)"
            }
            }
            # Done with system centric period/multicycles here
        
        }
        "max_skew" -
        "min_valid" {
        
            # skew always takes 0 cycles to transfer.
            # Do different things if we're aligning by period or multicycle
            switch -exact -- $data(alignment_method) {
            "period" {
            
                # I could default the shift_cycles to -1 if degree_shift <= 0
                # and to 0 if degree shift > 0
                # The max value is -skew only when degree_shift == 0 and
                # shift_cycles == 0
                # The min value is skew only when degree_shift == 0 and
                # shift_cycles == -1
                # If we're changing period to shift cycles, we change
                # the max relationship
                switch -exact -- $data(adjust_cycles) {
                "src" { set regsub_max [expr { 0 != $data(src_shift_cycles) }] }
                "dest" { set regsub_max [expr { 0 != $data(dest_shift_cycles) }] }
                default {
                    return -code error "Unknown value for adjust_cycles in\
                        new_sdc: $data(adjust_cycles)"
                }
                }
                
                if { $regsub_max || 0 != $data(degree_shift) } {
                    # The skew in the equation
                    # will be replaced with one that accounts for everything.
                    foreach term [array names modified_max] {
                        regsub -- $term $max $modified_max($term) max
                    }
                    # The regsub'ed string includes %end%, so that either
                    # src or dest can be substituted in.
                    regsub -all -- {%end%} $max $data(adjust_cycles) max 
                }
                
                # If we're changing period to change duration, we change
                # the min relationship
                switch -exact -- $data(adjust_cycles) {
                "src" { set regsub_min [expr { -1 != $data(src_shift_cycles) }] }
                "dest" { set regsub_min [expr { -1 != $data(dest_shift_cycles) }] }
                }
    
                if { $regsub_min || 0 != $data(degree_shift) } {
                    foreach term [array names modified_min] {
                        if { 0 == [regsub -- $term $min $modified_min($term) min] } {
                            post_message -type warning "Did not replace $term in $min"
                        }
                    }
                    # The regsub'ed string includes %end%, so that either
                    # src or dest can be substituted in.
                    if { 0 == [regsub -all -- {%end%} $min $data(adjust_cycles) min] } {
                        post_message -type warning "Could not substitute $data(adjust_cycles) in $min"
                    }
                }

            }
            "mc" {
            
                # Centering phase is data(degree_shift)
                # Actual phases are data(src_clock_phase) and data(dest_clock_phase)
                # You do this only for outputs.
                switch -exact -- $data(direction) {
                "output" {
                    
                    # If the centering phase is 0, there's no need to do
                    # the max and min delays
                    if { 0 == $data(degree_shift) } {
                    
                        # Handle cycle shifts, if there is a non-default amount
                        if { 1 != $s_s } {
                        
                            # src_shift_cycles and dest_shift_cycles adjust setup multicycle
                            # setup_multicycle_amount is one more than the number of cycle shifts.
                            # Normally you have 0 cycle shifts. If you have +1, you're going out
                            # to the next edge, for a multicycle of 2.
                            switch -exact -- $data(adjust_cycles) {
                                "src" { set setup_mc_type "start" }
                                "dest" { set setup_mc_type "end" }
                                default {
                                    return -code error "Unknown value for adjust_cycles in\
                                        new_sdc: $data(adjust_cycles)"
                                }
                            }
                            
                            # Based on SDR or DDR, add one or two multicycle exceptions
                            switch -exact -- $data(data_rate) {
                            "sdr" {
                                lappend multicycles "set_multicycle_path\
                                    -setup -${setup_mc_type}\
                                    -from \[get_clocks $data(src_clock_name)\]\
                                    -to \[get_clocks $data(dest_clock_name)\]\
                                    $s_s"
                            }
                            "ddr" {
#                                foreach { setup_pair hold_pair } $constraint_pairs { }
                                foreach { setup_from setup_to } $constraint_pairs {
#                                    foreach { setup_from setup_to } $setup_pair { break }
                                    
        #                            foreach { hold_from hold_to } $hold_pair { break }
                                    # If we're putting a multicycle on a path that we've
                                    # already decided will be cut, don't actually put on the mc.
                                    # was if info exist setup cut edges
                                    if { $setup_cut_edges($setup_from,$setup_to) } { continue }
                                    
                                    lappend multicycles "set_multicycle_path\
                                        -setup -${setup_mc_type}\
                                        -${setup_from}_from \[get_clocks $data(src_clock_name)\]\
                                        -${setup_to}_to \[get_clocks $data(dest_clock_name)\]\
                                        $s_s"
                                }
                            }
                            default {
                                return -code error "Unknown value for data_rate in\
                                    new_sdc: $data(data_rate)"
                            }
                            }
                        
                        }
                        
                        # Handle any shifted edges with clock periods or multicycles.
                        # If there is a non-default amount to shift
                        if { 0 != $h_h } {
                        
                            switch -exact -- $data(adjust_cycles) {
                                "src" { set hold_mc_type "start" }
                                "dest" { set hold_mc_type "end" }
                                default {
                                    return -code error "Unknown value for adjust_cycles in\
                                        new_sdc: $data(adjust_cycles)"
                                }
                            }

                            # Based on SDR or DDR, add one or two multicycle exceptions
                            switch -exact -- $data(data_rate) {
                            "sdr" {
                                lappend multicycles "set_multicycle_path\
                                    -hold -${hold_mc_type}\
                                    -from \[get_clocks $data(src_clock_name)\]\
                                    -to \[get_clocks $data(dest_clock_name)\]\
                                    $h_h"
                            }
                            "ddr" {
#                                foreach { setup_pair hold_pair } $constraint_pairs { }
                                    foreach { hold_from hold_to } $constraint_pairs {
#                                    foreach { setup_from setup_to } $setup_pair { break }
#                                    foreach { hold_from hold_to } $hold_pair { break }

                                    # If we're putting a multicycle on a path that we've
                                    # already decided will be cut, don't do it.
                                    # was if info exist hold cut edges
                                    if { $hold_cut_edges($hold_from,$hold_to) } { continue }
                                    lappend multicycles "set_multicycle_path\
                                        -hold -${hold_mc_type}\
                                        -${hold_from}_from \[get_clocks $data(src_clock_name)\]\
                                        -${hold_to}_to \[get_clocks $data(dest_clock_name)\]\
                                        $h_h"
                                }
                            }
                            default {
                                return -code error "Unknown value for data_rate in\
                                    new_sdc: $data(data_rate)"
                            }
                            }
                        }
                        # Done with applying any hold multicycles here
                    
                    } else {
                    
                        set delay_amount [expr { $data(src_clock_period) * \
                            (double($data(dest_clock_phase) - $data(src_clock_phase) -\
                            $data(degree_shift)) / 360.0) }]
                        set delay_amount [format "%.3f" $delay_amount]
                        
                        # Put together a symbolic -> numeric conversion for this for
                        # the SDC
                        lappend exceptions "# delay = src_clock_period *\
                            ((dest_clock_phase - src_clock_phase - degree_shift) / 360.0)"
                        lappend exceptions "# delay = $data(src_clock_period) *\
                            (($data(dest_clock_phase) - $data(src_clock_phase)\
                            - $data(degree_shift)) / 360.0)"
                        lappend exceptions "# delay = $delay_amount"
                        lappend exceptions "set_max_delay\
                            -from \[get_clocks $data(src_clock_name)\]\
                            -to \[get_clocks $data(dest_clock_name)\] $delay_amount"
                        lappend exceptions "set_min_delay\
                            -from \[get_clocks $data(src_clock_name)\]\
                            -to \[get_clocks $data(dest_clock_name)\] $delay_amount"
                    }
                    }
                    "input" {
                        # Handle cycle shifts, if there is a non-default amount
                        if { 1 != $s_s } {
                        
                            # src_shift_cycles and dest_shift_cycles adjust setup multicycle
                            # setup_multicycle_amount is one more than the number of cycle shifts.
                            # Normally you have 0 cycle shifts. If you have +1, you're going out
                            # to the next edge, for a multicycle of 2.
                            switch -exact -- $data(adjust_cycles) {
                                "src" { set setup_mc_type "start" }
                                "dest" { set setup_mc_type "end" }
                                default {
                                    return -code error "Unknown value for adjust_cycles in\
                                        new_sdc: $data(adjust_cycles)"
                                }
                            }
                            
                            # Based on SDR or DDR, add one or two multicycle exceptions
                            switch -exact -- $data(data_rate) {
                            "sdr" {
                                lappend multicycles "set_multicycle_path\
                                    -setup -${setup_mc_type}\
                                    -from \[get_clocks $data(src_clock_name)\]\
                                    -to \[get_clocks $data(dest_clock_name)\]\
                                    $s_s"
                            }
                            "ddr" {
#                                foreach { setup_pair hold_pair } $constraint_pairs { }
                                foreach { setup_from setup_to } $constraint_pairs {
#                                    foreach { setup_from setup_to } $setup_pair { break }
                                    
        #                            foreach { hold_from hold_to } $hold_pair { break }
                                    # If we're putting a multicycle on a path that we've
                                    # already decided will be cut, don't actually put on the mc.
                                    # was if info exist setup cut edges
                                    if { $setup_cut_edges($setup_from,$setup_to) } { continue }
                                    
                                    lappend multicycles "set_multicycle_path\
                                        -setup -${setup_mc_type}\
                                        -${setup_from}_from \[get_clocks $data(src_clock_name)\]\
                                        -${setup_to}_to \[get_clocks $data(dest_clock_name)\]\
                                        $s_s"
                                }
                            }
                            default {
                                return -code error "Unknown value for data_rate in\
                                    new_sdc: $data(data_rate)"
                            }
                            }
                        
                        }
                        
                        # Handle any shifted edges with clock periods or multicycles.
                        # If there is a non-default amount to shift
                        if { 0 != $h_h } {
                        
                            switch -exact -- $data(adjust_cycles) {
                                "src" { set hold_mc_type "start" }
                                "dest" { set hold_mc_type "end" }
                                default {
                                    return -code error "Unknown value for adjust_cycles in\
                                        new_sdc: $data(adjust_cycles)"
                                }
                            }

                            # Based on SDR or DDR, add one or two multicycle exceptions
                            switch -exact -- $data(data_rate) {
                            "sdr" {
                                lappend multicycles "set_multicycle_path\
                                    -hold -${hold_mc_type}\
                                    -from \[get_clocks $data(src_clock_name)\]\
                                    -to \[get_clocks $data(dest_clock_name)\]\
                                    $h_h"
                            }
                            "ddr" {
#                                foreach { setup_pair hold_pair } $constraint_pairs { }
                                    foreach { hold_from hold_to } $constraint_pairs {
#                                    foreach { setup_from setup_to } $setup_pair { break }
#                                    foreach { hold_from hold_to } $hold_pair { break }

                                    # If we're putting a multicycle on a path that we've
                                    # already decided will be cut, don't do it.
                                    # was if info exist hold cut edges
                                    if { $hold_cut_edges($hold_from,$hold_to) } { continue }
                                    lappend multicycles "set_multicycle_path\
                                        -hold -${hold_mc_type}\
                                        -${hold_from}_from \[get_clocks $data(src_clock_name)\]\
                                        -${hold_to}_to \[get_clocks $data(dest_clock_name)\]\
                                        $h_h"
                                }
                            }
                            default {
                                return -code error "Unknown value for data_rate in\
                                    new_sdc: $data(data_rate)"
                            }
                            }
                        }
                        # Done with applying any hold multicycles here
                    }
                    default {
                        return -code error "Unknown value for direction in\
                            new_sdc: $data(direction)"
                    }
                }
            }
            default {
                return -code error "Unknown value for alignment_method in\
                    new_sdc: $data(alignment_method)"
            }
            }
        }
        default {
            return -code error "Unknown value for io_timing_method in\
                new_sdc: $data(io_timing_method)"
        }
        }
        # End of period/mc alignment for system and skew centric methods
        
        # When we get here, we have the max and min equations with any adjustments
        # for alignment method
        log::log_message "Equations for $data(io_timing_method) after alignment are:"
        log::log_message " max: $max"
        log::log_message " min: $min"
        
        switch -exact -- $data(constraint_target) {
        "fpga" { }
        "external" {
        
            set delays_use_same_units 0
            
            # We need the data delay for everything
            # This call returns an array with max and min data trace delay values,
            # the variable names those max and min values get stored in,
            # and a conversion string to change whatever the values are into
            # nanoseconds.
            array set data_delay_info [board_info::get_delay_info \
                -string $data(data_trace_delay) -type "data"]
                
            # We have to put the values into the data array, because the
            # symbolic version of the max and min delay constraints get the
            # values subst'ed in from the data array.
            set data($data_delay_info(max_var_name)) $data_delay_info(max_value)
            set data($data_delay_info(min_var_name)) $data_delay_info(min_value)
            
            # The source clock trace delay has no effect on source synchronous
            # source clocks, where the source device provides the clock.
            # The source clock trace feeds only the source device, so it affects
            # both devices equally. 
            if { ! [string equal "source_sync_source_clock" $data(clock_configuration)] } {
                array set src_clock_delay_info [board_info::get_delay_info \
                    -string $data(src_clock_trace_delay) -type "src_clock"]
                set data($src_clock_delay_info(max_var_name)) $src_clock_delay_info(max_value)
                set data($src_clock_delay_info(min_var_name)) $src_clock_delay_info(min_value)
                set delays_use_same_units \
                    [string equal $data_delay_info(unit) $src_clock_delay_info(unit)]
            }
            
            # The dest clock trace delay has no effect on source synchronous
            # dest clocks, where the dest device provides the clock.
            # The dest clock trace feeds only the dest device, so it affects
            # both devices equally.
            if { ! [string equal "source_sync_dest_clock" $data(clock_configuration)] } {
                array set dest_clock_delay_info [board_info::get_delay_info \
                    -string $data(dest_clock_trace_delay) -type "dest_clock"]
                set data($dest_clock_delay_info(max_var_name)) $dest_clock_delay_info(max_value)
                set data($dest_clock_delay_info(min_var_name)) $dest_clock_delay_info(min_value)
                set delays_use_same_units [expr { $delays_use_same_units && \
                    [string equal $data_delay_info(unit) $dest_clock_delay_info(unit)] }]
            }
            
            # If all the delays use the same units, 
            switch -exact -- $data(clock_configuration) {
            "source_sync_source_clock" {
                # The source (at the left) clocks it
                # max is max data delay - min clock delay
                # min is min data delay - max clock delay
                set unconverted_max "($data_delay_info(max_var_name) - $dest_clock_delay_info(min_var_name))"
                set unconverted_min "($data_delay_info(min_var_name) - $dest_clock_delay_info(max_var_name))"
            }
            "source_sync_dest_clock" {
                # The destination (at the right) clocks it
                # max is max data delay + max clock delay
                # min is min_data_delay + min clock delay
                set unconverted_max "($data_delay_info(max_var_name) + $src_clock_delay_info(max_var_name))"
                set unconverted_min "($data_delay_info(min_var_name) + $src_clock_delay_info(min_var_name))"
            }
            "system_sync_common_clock" -
            "system_sync_different_clock" {
            
                # As far as board info goes, these two are the same, but they
                # differ for input and output
                switch -exact -- $data(direction) {
                "input" {
                    # input max is max data delay + min dest clock delay - max source clock delay
                    # input min is min data delay + max dest clock delay - min source clock delay
                    set unconverted_max "($data_delay_info(max_var_name) + $dest_clock_delay_info(min_var_name)\
                        - $src_clock_delay_info(max_var_name))"
                    set unconverted_min "($data_delay_info(min_var_name) + $dest_clock_delay_info(max_var_name)\
                        - $src_clock_delay_info(min_var_name))"
                }
                "output" {
                    # output max is max data delay - max dest clock delay + min source clock delay
                    # output min is min data delay - min dest clock delay + max source clock delay
                    set unconverted_max "($data_delay_info(max_var_name) - $dest_clock_delay_info(max_var_name)\
                        + $src_clock_delay_info(min_var_name))"
                    set unconverted_min "($data_delay_info(min_var_name) - $dest_clock_delay_info(min_var_name)\
                        + $src_clock_delay_info(max_var_name))"
                }
                }
            }
            }
            
            # We've put together text strings with numbers that add up to the board
            # delay part of the IO constraint.
            # For example, we could have "4.3 - 5.2" for single value delays or
            # min and max delays.
            # We could have (1000 + 50) - (800 - 10) for delays expressed as
            # nominal +/- varation.
            # The regsubs put these strings into the conversion expression
            # that goes from whatever units they're in to nanoseconds
            if { 0 == [regsub {%value%} $data_delay_info(conversion_expression) \
                $unconverted_max converted_max] } {
                return -code error "new_sdc error: Couldn't substitute value into\
                    conversion expression $data_delay_info(conversion_expression)"
            }
            if { 0 == [regsub {%value%} $data_delay_info(conversion_expression) \
                $unconverted_min converted_min] } {
                return -code error "new_sdc error: Couldn't substitute value into\
                    conversion expression $data_delay_info(conversion_expression)"
            }
            
            # And after all that, we just stick the string onto the end of
            # the max and min constraints we're putting together :-)
            append max " + $converted_max"
            append min " + $converted_min"
        }
        default {
            return -code error "Unknown value for constraint_target in new_sdc:\
                $data(constraint_target)"
        }
        }
        

        # Set up the beginning of the constraint based on whether it's input or output
        switch -exact -- $data(direction) {
        "input" {
            set delay_type "input delay"
            set constraint_string "set_input_delay -clock \[get_clocks $data(src_clock_name)\]"
            set clock_name $data(src_clock_name)
        }
        "output" {
            set delay_type "output delay"
            set constraint_string "set_output_delay -clock \[get_clocks $data(dest_clock_name)\]"
            set clock_name $data(dest_clock_name)
        }
        default {
            return -code error "Unknown value for direction in new_sdc:\
                $data(direction)"
        }
        }

        # What are the ports names that the data constraint applies to?
        set port_names [list [join [lsort -dictionary $data(data_port_names)]]]

        # It seems sort of backwards, but if you're aligning with periods,
        # pass in the multicycle numbers computed above to the call to 
        # find_clock_relationships. That's because period adjustment
        # is done in some cases by modifying launch and latch.
        # find_clock_relationship returns launch and latch times, given
        # clock periods and multicycles. 
        # If you're aligning with multicycles, use the default 
        # values (setup=1, hold=0). If you use multicycles, the launch
        # and latch are always the default.
        switch -exact -- $data(alignment_method) {
            "period" {
            }
            "mc" {
                # rewrite the defaults for multicycles
                set setup_dms 1
                set setup_dmh 0
                set setup_sms 1
                set setup_smh 0
                set hold_dms 1
                set hold_dmh 0
                set hold_sms 1
                set hold_smh 0
            }
            default {
                return -code error "Unknown alignment method in new_sdc:\
                    $data(alignment_method)"
            }
        }
        
        # Set up for the symbolic -> numeric conversions
        # Put the constraints into the text widget
        # add_option gets populated with the -add flag when appropriate
        set add_option ""
        array set clock_opt [list]
        
#        foreach { setup_pair hold_pair } $constraint_pairs { }
        foreach { from to } $constraint_pairs {
        
            set setup_from $from
            set setup_to $to
            set hold_from $from
            set hold_to $to
            
            # If either the setup relationship or the hold relationship
            # has been overridden with a false path, don't create
            # the corresponding max or min delay.
            # This case should happen only when the user adds a manual
            # false path override.
            set min_max_to_do [list]

#            foreach { setup_from setup_to } $setup_pair { break }
#            foreach { hold_from hold_to } $hold_pair { break }

            # If there's a setup relationship to calculate...
            # was if ! info exist setup cut edges
            if { ! $setup_cut_edges($setup_from,$setup_to) } {
            
                lappend min_max_to_do "max" $max

                # Determine whether we get the -clock_fall flag or not
                switch -exact -- $data(direction) {
                    "input" {
                        switch -exact -- $setup_from {
                        "fall" { set clock_opt(max) " -clock_fall" }
                        "rise" { set clock_opt(max) "" }
                        default {
                            return -code error "Unknown value for setup_from\
                                in new_sdc: $setup_from"
                        }
                        }
                    }
                    "output" {
                        switch -exact -- $setup_to {
                        "fall" { set clock_opt(max) " -clock_fall" }
                        "rise" { set clock_opt(max) "" }
                        default {
                            return -code error "Unknown value for setup_to\
                                in new_sdc: $setup_to"
                        }
                        }
                    }
                    default {
                        return -code error "Unknown value for direction in\
                            new_sdc: $data(direction)"
                    }
                }
                
                # Not all max delay values have launch or latch times
                # in them. Skip the calculation if appropriate
                if { [regexp {la(un|t)ch} $max] } {
                
                    log::log_message "\nGetting launch/latch times for max delay"
                    log::log_message "----------------------------------------"
                    foreach { setup_launch_time setup_latch_time } \
                        [clocks_info::find_clock_relationship_2 \
                        -src_clock_id $src_clock_id -dest_clock_id $dest_clock_id \
                        -launch_edge $setup_from -latch_edge $setup_to -setup \
                        -dms $setup_dms -dmh $setup_dmh \
                        -sms $setup_sms -smh $setup_smh] { break }
                } else {
                    set setup_launch_time ""
                    set setup_latch_time ""
                }
            }
            
            # If there's a hold relationship to calculate
            # was if ! info exist hold cut edges
            if { ! $hold_cut_edges($hold_from,$hold_to) } {
            
                lappend min_max_to_do "min" $min
                
                # Determine whether we get the -clock_fall flag or not
                switch -exact -- $data(direction) {
                    "input" {
                        switch -exact -- $hold_from {
                        "fall" { set clock_opt(min) " -clock_fall" }
                        "rise" { set clock_opt(min) "" }
                        default {
                            return -code error "Unknown value for hold_from\
                                in new_sdc: $hold_from"
                        }
                        }
                    }
                    "output" {
                        switch -exact -- $hold_to {
                        "fall" { set clock_opt(min) " -clock_fall" }
                        "rise" { set clock_opt(min) "" }
                        default {
                            return -code error "Unknown value for hold_to\
                                in new_sdc: $hold_to"
                        }
                        }
                    }
                    default {
                        return -code error "Unknown value for direction in\
                            new_sdc: $data(direction)"
                    }
                }

                # Not all min delay values have launch or latch times
                # in them. Skip the calculation if appropriate
                if { [regexp {la(un|t)ch} $min] } {

                    log::log_message "\nGetting launch/latch times for min delay"
                    log::log_message "----------------------------------------"
                    foreach { hold_launch_time hold_latch_time } \
                        [clocks_info::find_clock_relationship_2 \
                        -src_clock_id $src_clock_id -dest_clock_id $dest_clock_id \
                        -launch_edge $hold_from -latch_edge $hold_to -hold \
                        -dms $hold_dms -dmh $hold_dmh \
                        -sms $hold_sms -smh $hold_smh] { break }
                } else {
                    set hold_launch_time ""
                    set hold_latch_time ""
                }
            }
                
            # If we're doing a max calculation, get the launch and latch times
            # for the particular rise/fall combination that was calculated
            # earlier.
            # Same thing if we're doing a min calculation.
            # The launch and latch times have to be put into the data array
            # because the symbolic -> numeric substitution assumes all text
            # variables are keys in the data array.
            foreach { t equation } $min_max_to_do {
            
                switch -exact -- $t {
                "max" {
                    set data(launch_time) $setup_launch_time
                    set data(latch_time) $setup_latch_time
                }
                "min" {
                    set data(launch_time) $hold_launch_time
                    set data(latch_time) $hold_latch_time
                }
                default {
                    return -code error "Unknown value evaluating symbolic\
                        equations in new_sdc: $t"
                }
                }
                
                # The launch and latch time values in the data array
                # can be blank if launch or latch terms are not present
                # in the max or min values
                
                # Put the symbolic expression into the constraints box
#                $sdc_constraints insert end "# [string totitle $t] $delay_type = $equation\n" fixed
                append ret_str "# [string totitle $t] $delay_type = $equation\n"
                # Substitute in numbers and put that in
                regsub -all {([a-z_]+)} $equation {$data(\1)} equation
                set equation [subst $equation]
#                $sdc_constraints insert end "# \t= $equation\n" fixed
                append ret_str "# \t= $equation\n"
                # Eval the expression to compute the constraint value and put that in
                set evaled_equation [eval expr $equation]
                if { ! [string equal $equation $evaled_equation] } {
                    set equation $evaled_equation
#                    $sdc_constraints insert end "# \t= $equation\n" fixed
                    append ret_str "# \t= $equation\n"
                }
                
                # Figure out whether or not we use -add
                # Use -add when there's a different combination of -clock, -clock_fall
                # and -reference_pin. We never use the reference pin, so track
                # -clock and -clock_fall.
                # If there's no clock/clock_fall combination for this set of port
                # names, it's the first time they've been seen, so you never need
                # -add. If there is a clock/clock_fall combination for this set
                # of port names, they've been seen before. Get the particular
                # clock/clock_fall combination, and compare it to what we will
                # be writing out for this delay constraint. If it's different,
                # or there's more than one combination, it needs a -add.
                # Otherwise it doesn't.
                set combo [join [list $clock_name $clock_opt($t)] ","]

                if { ! [info exists port_and_dash_add($port_names)] } {
                    # If this one has not been done yet, we don't need -add.
                    set port_and_dash_add($port_names) [list $combo]
                    set add_option ""
                } else {
                    # We have constraints for these IOs.
                    # What clock and -clock_fall combinations have been done already?
                    set clock_and_fall_combos $port_and_dash_add($port_names)

                    # If there's more than 1 combination, we always need -add
                    # because without it, something will be removed.
                    # If there's only 1 combination, and it's the same as what
                    # we have now, we don't need -add.
                    # If there's only 1 combination, and it's different than 
                    # what we have now, we need -add
                    if { 1 < [llength $clock_and_fall_combos] } {
                        set add_option " -add"
                    } elseif { -1 != [util::lsearch_with_brackets $clock_and_fall_combos $combo] } {
                        set add_option ""
                    } else {
                        set add_option " -add"
                        lappend port_and_dash_add($port_names) $combo
                    }
                }
                append ret_str "${constraint_string}$clock_opt($t) -${t} $equation \[get_ports $port_names\]${add_option}\n\n"
                

            }

        }
        
        # We've gone through all the input or output delay constraints.
        # Now put in the multicycles
        if { 0 < [llength $multicycles] } {
            append ret_str "\n# Multicycle exceptions\n"
            foreach multicycle $multicycles {
                append ret_str "$multicycle\n"
            }
        }
        
        # and any other exceptions
        if { 0 < [llength $exceptions] } {
            append ret_str "\n# Other exceptions\n"
            foreach exception $exceptions {
                append ret_str "$exception\n"
            }
        }
        
        # Put in the false paths
        # don't put in false paths for SDR if it's not advanced
        if { [string equal "ddr" $data(data_rate)] || \
            ( [string equal "sdr" $data(data_rate)] && $data(advanced_false_paths) ) } {
            
            if { 0 < [array size setup_cut_edges] || 0 < [array size hold_cut_edges] } {
#                $sdc_constraints insert end "\n# False paths\n" fixed
                append ret_str "\n# False paths\n"
                foreach relationship [array names setup_cut_edges] {
                    if { ! $setup_cut_edges($relationship) } { continue }
                    regexp {^(.*),(.*)$} $relationship -> setup_from setup_to
                    append ret_str "set_false_path -setup\
                        -${setup_from}_from \[get_clocks $data(src_clock_name)\]\
                        -${setup_to}_to \[get_clocks $data(dest_clock_name)\]\n"
                }
                foreach relationship [array names hold_cut_edges] {
                    if { ! $hold_cut_edges($relationship) } { continue }
                    regexp {^(.*),(.*)$} $relationship -> hold_from hold_to
                    append ret_str "set_false_path -hold\
                        -${hold_from}_from \[get_clocks $data(src_clock_name)\]\
                        -${hold_to}_to \[get_clocks $data(dest_clock_name)\]\n"
                }
            }
        }

        # Write out a header with information about interface characteristics
        append ret_str "# Interface rate: [string toupper $data(data_rate)]\n"
        append ret_str "# Transfer edge: $data(transfer_edge)\n"
        append ret_str "\n"

        return $ret_str
    }
    
    ################################################################################
    # Return a list with the total phase shift on the specified clock,
    # and the phase shift on whatever input feeds it.
    proc get_complete_phase_shift { args } {
    
        set options {
            { "clock_id.arg" "" "ID of clock to work on" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        set clock_id $opts(clock_id)
        set complete_phase 0
        set done 0
        
        set num_inversions 0

        while { ! $done } {

            set master_clock_name [get_clock_info -master_clock $clock_id]
            if { [string equal "" $master_clock_name] } {
                # We're at a base or virtual clock if there's no master
                # Is there a phase shift on the master/virtual?
                foreach { rise fall } [get_clock_info -waveform $clock_id] { break }
                set period [get_clock_info -period $clock_id]
                # We could have a negative phase shift
                if { $fall >= $period } {
                    set rise [expr { $rise - $period }]
                }
                set partial_phase [expr { 360 * (double($rise) / $period) }]
                set input_phase $partial_phase
                set done 1
            } else {
                # We're on a generated clock.
                # For now, punt on a generated clock defined with edges and shifts
                if { 0 < [llength [get_clock_info -edges $clock_id]] } {
                    set partial_phase 0
                    post_message -type warning "Skipping phase calculation on $clock_id \
                        because it uses edge shifts for its generated clock"
                } else {
                    set partial_phase [get_clock_info -phase $clock_id]
                    if { [get_clock_info -is_inverted $clock_id] } {
                        incr num_inversions
                    }
                }
                set clock_id [util::get_clock_id -clock_name $master_clock_name]
            }
            set complete_phase [expr { $complete_phase + $partial_phase }]
        }
        
        # How many inversions did we get?
        # If it's an even number, they cancel each other out.
        if { 1 == ($num_inversions % 2) } {
            if { 180 <= $complete_phase } {
                set complete_phase [expr { $complete_phase - 180 }]
            } else {
                set complete_phase [expr { $complete_phase + 180 }]
            }
        }

        # Normalize to within +/- 360
        if { 360 <= $complete_phase } {
            set periods_away [expr { int(double($complete_phase) / 360.0) } ]
        } elseif { -360 >= $complete_phase} {
            set periods_away [expr { int(double($complete_phase) / 360.0) } ]
        } else {
            set periods_away 0
        }
        set complete_phase [expr { $complete_phase - ($periods_away * 360)} ]

        return [list $complete_phase $input_phase]
    }

    ####################################################
    # Main procedure to create SDC constraints.
    # It determines what interfaces to generate the constraints for,
    # and calls the procedures in sdc_info namespace to create
    # the constraints.
    proc generate_sdc_constraints { args } {
    
        set options {
        }
        array set opts [::cmdline::getoptions args $options]

        # Track what's encountered first for a particular port, in terms
        # of the -clock and -clock_fall options. Use that info to figure out
        # whether -add is required.
        array set port_and_dash_add [list]
        
        # Clear out the SDC text string
        update_sdc_text -reset
        
        # SDC constraints to put in for the interfaces
        set interfaces_sdc ""
        
        # Set up a list to accumulate names of clocks in the interfaces
        # that will get clock constraints generated for them
        set clocks_to_write [list] 
        
        # Walk through all the checked interfaces to write them
        foreach node [checked_interfaces::get] {
        
            set interface_name [interfaces::get_interface_info -interface $node -name]
            
            array unset interface_info
            set interface_data [interfaces::get_interface_info \
                -all_keys -interface $node]
            array set interface_info $interface_data
            
            # If there are pages to see, don't generate the SDC
            if { 0 < [llength $interface_info(pages_to_see)] } {
                append interfaces_sdc "# Skipping SDC generation for $interface_name\n"
                log::log_message "\nSkipping SDC generation for $interface_name"
                log::log_message "pages_to_see is $interface_info(pages_to_see)"
            } else {
                log::log_message "\nGenerating SDC\n-----------------"
                append interfaces_sdc "# Constraints for $interface_name\n"
                append interfaces_sdc [new_sdc -data $interface_data -dash_add_var port_and_dash_add]
                
                # Accumulate the clock names used in this interface
                foreach clk $interface_info(clock_tree_names) {
                    if { -1 == [lsearch $clocks_to_write $clk] } {
                        lappend clocks_to_write $clk
                    }
                }
            }
            
        }
        
        # Figure out which clocks existed in SDC files already
        # Figure out which clocks are new
        set existing_names [list]
        set new_names [list]
        foreach clock_name $clocks_to_write {
        
            if { [catch {project_info::is_clock_created_by -sdc_defined \
                -clock_name $clock_name} is_sdc_defined] } {
                # Clock doesn't exist
                return -code error "Clock $clock_name wasn't created so it cannot\
                    be written out in geneate_sdc_constraints"
            } elseif { $is_sdc_defined } {
                lappend existing_names $clock_name
            } else {
                lappend new_names $clock_name
            }
        
        }
        
        # Insert clock constraints at the top of the text widget, followed by any
        # clock groups
        update_sdc_text -append [generate_clocks_sdc -existing_names $existing_names \
            -new_names $new_names]
        update_sdc_text -append [project_info::generate_sdc_for_clock_groups -clock_names $clocks_to_write]
        update_sdc_text -append $interfaces_sdc
        
        global quartus
        global script_version
        update_sdc_text -append "\n# SDC file information\
            \n# Project directory: [pwd]\
            \n# Project and revision: $quartus(project) $quartus(settings)\
            \n# Date: [clock format [clock seconds]]\
            \n# Quartus II software: $quartus(version)\
            \n# Script: [info script] version $script_version\
            \n"

        
    }
        
    ####################################################
    # Main procedure to create a reporting script.
    # Include a calculation for how well the window is centered.
    # (worst case hold slack - worst case setup slack) / 2
    proc generate_reporting_script { args } {
    
        set options {
        }
        array set opts [::cmdline::getoptions args $options]

        # clear out the report text
        update_reporting_text -reset
        
        update_reporting_text -append "set cur_op_con \[get_operating_conditions\]\n"
        update_reporting_text -append "set worst_case_setup_slack \"\"\n"
        update_reporting_text -append "set worst_case_hold_slack \"\"\n"
        
        update_reporting_text -append "foreach_in_collection op_con \[get_available_operating_conditions\] {\n"
        update_reporting_text -append "\tset_operating_conditions \$op_con\n\tupdate_timing_netlist\n"
        update_reporting_text -append "\tset op_con_name \[get_operating_conditions_info -display_name \$op_con\]\n"

        foreach node [checked_interfaces::get] {
        
            set interface_name [interfaces::get_interface_info -interface $node -name]
            
            array unset interface_info
            set interface_data [interfaces::get_interface_info \
                -keys [list "src_clock_name" "dest_clock_name"] -interface $node]
            array set interface_info $interface_data
            
            update_reporting_text -append "\tset setup_info \[report_timing -setup\
                -from_clock \[get_clocks $interface_info(src_clock_name)\]\
                -to_clock \[get_clocks $interface_info(dest_clock_name)\]\
                -parent_folder \"$interface_name\" -panel_name \"Setup for\
                \$op_con_name\"\]\n"
            update_reporting_text -append "\tset hold_info \[report_timing -hold\
                -from_clock \[get_clocks $interface_info(src_clock_name)\]\
                -to_clock \[get_clocks $interface_info(dest_clock_name)\]\
                -parent_folder \"$interface_name\" -panel_name \"Hold for\
                \$op_con_name\"\]\n"
            update_reporting_text -append "\tset setup_slack \[lindex \$setup_info 1\]\n"
            update_reporting_text -append "\tset hold_slack \[lindex \$hold_info 1\]\n"
            update_reporting_text -append {
    if { [string equal "" $worst_case_setup_slack] } {
        set worst_case_setup_slack $setup_slack
    } elseif { $setup_slack < $worst_case_setup_slack } {
        set worst_case_setup_slack $setup_slack
    }
    if { [string equal "" $worst_case_hold_slack] } {
        set worst_case_hold_slack $hold_slack
    } elseif { $hold_slack < $worst_case_hold_slack } {
        set worst_case_hold_slack $hold_slack
    }
}
        }
        
        update_reporting_text -append "}\n"
        update_reporting_text -append "set_operating_conditions \$cur_op_con\nupdate_timing_netlist\n"
        update_reporting_text -append "post_message \"The worst case setup slack is \$worst_case_setup_slack\"\n"
        update_reporting_text -append "post_message \"The worst case hold slack is \$worst_case_hold_slack\"\n"
        update_reporting_text -append "post_message \"The I/O has the most timing margin when the slack values are equal\"\n"

        global quartus
        global script_version
        
        update_reporting_text -append "\n# Reporting script information\
            \n# Project directory: [pwd]\
            \n# Project and revision: $quartus(project) $quartus(settings)\
            \n# Date: [clock format [clock seconds]]\
            \n# Quartus II software: $quartus(version)\
            \n# Script: [info script] version $script_version\
            \n"

        # Make sure the reporting script is part of the project
        
    }

    ########################################################
    # Handle DOS backslashes? Ugh.
    proc on_save_files { args } {
    
        variable sdc_output_file
        variable reporting_output_file
        # Generate SDC constraints
        # Write to file
        # Generate reporting script
        # Write to file
        
        if { ! [string equal "" $sdc_output_file] } {
            generate_sdc_constraints
            write_out_file -file_name $sdc_output_file -text [update_sdc_text -get]
        }
        
        if { ! [string equal "" $reporting_output_file] } {
            generate_reporting_script
            write_out_file -file_name $reporting_output_file -text [update_reporting_text -get]
        }
    }
    
    ##########################################################
    proc set_file_info { args } {
    
        set options {
            { "sdc_output_file.arg" "" "Name of SDC output file" }
            { "reporting_output_file.arg" "" "Name of reporting file" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        variable sdc_output_file
        variable reporting_output_file
        
        set sdc_output_file $opts(sdc_output_file)
        set reporting_output_file $opts(reporting_output_file)
    }

    ##########################################################
    proc get_file_info { args } {
    
        set options {
            { "sdc_output_file_var_name.arg" "" "Name of SDC output file" }
            { "reporting_output_file_var_name.arg" "" "Name of reporting file" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        variable sdc_output_file
        variable reporting_output_file
        
        upvar $opts(sdc_output_file_var_name) out
        upvar $opts(reporting_output_file_var_name) rep
        
        set out $sdc_output_file
        set rep $reporting_output_file
    }
    
    ###########################################
    # Procedure to manage the text of the SDC file
    proc update_sdc_text { args } {
    
        set options {
            { "append.arg" "" "text to append" }
            { "get" "Return the current text" }
            { "reset" "Set to an empty string" }
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable sdc_file_text
        
        # If we just want the text, return it.
        if { $opts(get) } {
            return $sdc_file_text
        }
        
        if { $opts(reset) } {
            set sdc_file_text ""
        }
        
        append sdc_file_text $opts(append)
    }

    ###########################################
    # Procedure to manage the text of the SDC file
    proc update_reporting_text { args } {
    
        set options {
            { "append.arg" "" "text to append" }
            { "get" "Return the current text" }
            { "reset" "Set to an empty string" }
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable reporting_script_text
        
        if { $opts(reset) } {
            set reporting_script_text ""
        } elseif { $opts(get) } {
            return $reporting_script_text
        } else {
            append reporting_script_text $opts(append)
        }
    }
}

################################################################################
namespace eval advanced_info {

    variable advanced_dialog
    variable pt_compatible
    variable alignment_method
    variable duplicate_clocks
    
    ################################################################################
    proc assemble_dialog { args } {
    
        set options {
            { "parent.arg" "" "Parent frame of the widgets" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        variable advanced_dialog
        variable pt_compatible
        variable alignment_method
        variable duplicate_clocks
        
        set advanced_dialog [Dialog .as_dialog -modal local \
            -side bottom -anchor c -title "Advanced Settings" \
            -default 0 -cancel 1 -transient no]
        $advanced_dialog add -name ok -width 10
        $advanced_dialog add -name cancel -width 10

        set f [$advanced_dialog getframe]

        pack [checkbutton $f.pt_compatible -text \
            "Make constraints that are compatible with the PrimeTime software" \
            -variable [namespace which -variable pt_compatible] \
            -state "disabled"] \
            -side top -anchor nw -pady 5
        set ea_tf [TitleFrame $f.edge -text "Edge alignment method" -ipad 8]
        set sub_f [$ea_tf getframe]
        pack [radiobutton $sub_f.period -text "Add or subtract partial clock period" \
            -variable [namespace which -variable alignment_method] -value "period" \
            ] -side top -anchor nw
        pack [radiobutton $sub_f.multicycle -text \
            "Use multicycle or min/max delay exceptions" -variable \
            [namespace which -variable alignment_method] -value "multicycle" \
            ] -side top -anchor nw
        pack $ea_tf -side top -fill x -expand true
        set dc_tf [TitleFrame $f.duplicate -text "Duplicate clock constraints" \
            -ipad 8]
        set sub_f [$dc_tf getframe]
        pack [label $sub_f.l -text "When clock constraints for the interface\
            are read from existing SDC files,\nshould they be duplicated in\
            the new SDC file for the interface?" -justify left] \
            -side top -anchor nw
        pack [Separator $sub_f.sep -relief groove] \
            -side top -anchor n -fill x -expand true -pady 5
        pack [radiobutton $sub_f.as_comments \
            -text "Yes, but comment them out" \
            -variable [namespace which -variable duplicate_clocks] \
            -value "as_comments"] \
            -side top -anchor nw
        pack [radiobutton $sub_f.as_constraints \
            -text "Yes, include them as valid clock constraints" \
            -variable [namespace which -variable duplicate_clocks] \
            -value "as_valid"] \
            -side top -anchor nw
        pack [radiobutton $sub_f.dont_include \
            -text "No, don't include duplicate clock constraints" \
            -variable [namespace which -variable duplicate_clocks] \
            -value "dont_include"] \
            -side top -anchor nw
        pack $dc_tf -side top -fill x -expand true -pady 8
        
        # Withdraw the window when you click X instead of deleting it
        wm protocol $advanced_dialog WM_DELETE_WINDOW [list $advanced_dialog withdraw]
        

    }

    #############################################
    #
    proc show_dialog { args } {

        set options {
            { "pt_compatible_var.arg" "" "Primetime compatible initial value" }
            { "alignment_method_var.arg" "" "Initial value" }
            { "duplicate_clocks_var.arg" "" "Initial value" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable advanced_dialog
        variable pt_compatible
        variable alignment_method
        variable duplicate_clocks

        set has_changes 0

        upvar $opts(pt_compatible_var) cur_pt_compatible
        upvar $opts(alignment_method_var) cur_alignment_method
        upvar $opts(duplicate_clocks_var) cur_duplicate_clocks
        
        set pt_compatible $cur_pt_compatible
        set alignment_method $cur_alignment_method
        set duplicate_clocks $cur_duplicate_clocks
        
        set dialog_result [$advanced_dialog draw]

        # 0 is "OK" and 1 is "Cancel"
        if { 0 == $dialog_result } {

            # The user pressed OK
            if { $pt_compatible != $cur_pt_compatible } {
                set cur_pt_compatible $pt_compatible
                set has_changes 1
            }
            if { ! [string equal $alignment_method $cur_alignment_method] } {
                set cur_alignment_method $alignment_method
                set has_changes 1
            }
            if { ! [string equal $duplicate_clocks $cur_duplicate_clocks] } {
                set cur_duplicate_clocks $duplicate_clocks
                set has_changes 1
            }
        } else {
            # The user pressed cancel - nothing to do
        }
        return $has_changes    
    }
}

################################################################################
# Small namespace for a logging utility
namespace eval log {

    variable log_fh
    variable log_file_name "iowizard.log"
    
    ######################################
    # Open the log file
    proc open_log { args } {

        variable log_fh
        variable log_file_name
        global script_version

        if { [catch {open $log_file_name w} res] } {
            post_message -type warning "Couldn't create log file: $res"
            unset log_fh
        } else {
            set log_fh $res
            log_message "Log for [info script] version $script_version"
            log_message "[clock format [clock seconds]]"
        }
    }
    
    ######################################
    # Write messages to a log file
    proc log_message { m } {
    
        variable log_fh
        
        if { [info exists log_fh] } {
            catch { puts $log_fh $m }
        }
    }
    
    ######################################
    proc close_log { args } {
    
        variable log_fh
        variable log_file_name
        
        if { [info exists log_fh] } {
            if { [catch { close $log_fh } res] } {
            } else {
                post_message "Saved script log file named $log_file_name"
            }
        }
    }

}

################################################################################
# Various utility procedures
namespace eval util {

    ##################################################
    # Check the current software version against the
    # software version the specified project was last compiled in. 
    # 6.0 SP1.21 for example
    # set_global_assignment -name LAST_QUARTUS_VERSION "6.0 SP1"
    # Return 1 if the versions match, 0 if they don't, or
    # error if there was an error checking versions
    proc get_project_version { args } {
    
        set options {
            { "project.arg" "" "The project name" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        set rev [get_current_revision $opts(project)]
        
        if { [catch { open db/${rev}.db_info } fh] } {
            return -code error "Compile your project before using this script"
        }
    
        set project_version ""

        # Read through the file to find the version it was last opened in.
        while { [gets $fh line] >= 0 } {
    
            if { [regexp -nocase -- {\s*Quartus_Version = (.*?)\s*$} \
                $line -> project_version] } {
    
                # We found the version line
                break
            }
        }
        catch { close $fh }

        return $project_version
    }


    #############################################
    # Returns a string with the time duration 
    # of the last matched module run, which
    # was during the last compile
    proc get_module_elapsed_time { args } {

        set options {
            { "regexp_pattern.arg" "" "The project name" }
        }
        array set opts [::cmdline::getoptions args $options]

        set module_time ""

        # Fail gracefully if the report isn't accessible
        if { [catch {load_report} res] } {
            catch { unload_report }
            return -code error $res
        }
    
        # Return the default time if we can't find the elapsed time panel
        set elapsed_time_id [get_report_panel_id "Flow Elapsed Time"]
        if { -1 == $elapsed_time_id } {
            catch { unload_report }
            return -code error "Flow Elapsed Time panel not found"
        }
    
        # Get the time duration for the last TimeQuest run in the report
        set num_rows [get_number_of_rows -id $elapsed_time_id]
        for { set row_id 1 } { $row_id < $num_rows } { incr row_id } {
            set row_data [get_report_panel_row -id $elapsed_time_id -row $row_id]
            if { [regexp $opts(regexp_pattern) [lindex $row_data 0]] } {
                set module_time [lindex $row_data 1]
            }
        }
        catch { unload_report }
        return $module_time
    }

    ################################################################################
    # Return 1 if elements in two lists are the same
    proc check_lists_equal { a b } {

        if { [llength $a] != [llength $b] } { return 0 }

        # This is really expensive from a computational point of view
        # Walk through each element in lists
        # For each element in a, walk through all elements in b.
        # If the two are equal, break out of b
        # After the b loop, check if $i and $j are equal. You can
        # get here from the break, or if j was not in a
        # If i and j aren't equal, j was not in a, so a and b can't be
        # equal, so return 0.
        # After all of the elements in a have been checked,
        # return 1
        foreach i $a {
            foreach j $b {
                if { [string equal $i $j] } { break }
            }
            if { ! [string equal $i $j] } { return 0 }
        }
        return 1
    }

    ########################################
    # Figure out what items are in or not in
    # two lists
    proc get_list_elements { args } {

        set options {
            { "from.arg" "" "The list to check the elements of" }
            { "in" "Are they in this list?" }
            { "not_in" "Are they not in this list?" }
            { "list.arg" "" "In/not-in list"}
        }
        array set opts [::cmdline::getoptions args $options]
    
        if { ! $opts(in) && ! $opts(not_in) } {
            # Neither option is specified.
            return -code error "Must specify -in or -not_in for get_list_elements"
        }
         
        set to_return [list]
    
        # Walk through every element in the list to test
        foreach e $opts(from) {
        
            # Find the index of the element in the master list
            set index [lsearch_with_brackets $opts(list) $e]
            
            if { (-1 == $index) && $opts(not_in) } {
                # If the element is not found in the master list,
                # and we ask for elements not in the master list, this
                # element meets those criteria, so it will be returned. 
                lappend to_return $e
                
            } elseif { (-1 != $index) && $opts(in) } {
                # If the element is found in the master list, and we
                # ask for elements in the master list, this element
                # meets those criteria, so it will be returned
                lappend to_return $e
                
            } else {
                # Bah!
                # Either we asked for elements not in the master list, and
                # the current element is in the master list, or we asked
                # for elements in the master list, and the current element
                # is not in the master list.
            }
        }
        return $to_return
    }
    
    #########################################
    # Turn a collection into a list
    proc collection_to_list { col } {
        set to_return [list]
        foreach_in_collection i $col { lappend to_return $i }
        return $to_return
    }
    
    ################################################################################
    # Return 1 if the number is an integer, optionally depending on whether it
    # is positive.
    # Return 0 if the check fails.
    proc validate_int { number type args } {
    
        set options {
            { "positive" "Positive numbers only" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        if { [string equal "" $number] } {
            # An empty string is valid as an integer
            return 1
        } elseif { [string is integer $number] } {
            if { $opts(positive) } {
                # If the number must be positive, check that
                return [expr { $number >= 0 }]
            } else {
                # Otherwise return 1 because the number is an integer
                return 1
            }
        } else {
            # If it's not an empty string, and not an integer, return 0
            return 0
        }
    }

    ################################################################################
    # Return 1 if the number is a float, optionally depending on whether it
    # is positive.
    # Return 0 if the check fails.
    proc validate_float { number type args } {

        set options {
            { "positive" "Positive numbers only" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        # Disallow - in positive-only numbers
        if { $opts(positive) } {
            set decimal_pattern {^\.$}
        } else {
            set decimal_pattern {^(-|\.|-\.)}
        }
    
        if { [string equal "" $number] } {
            # An empty string is valid as a float
            return 1
        } elseif { [string is double $number] } {
            if { $opts(positive) } {
                return [expr { $number >= 0 }]
            } else {
                return 1
            }
        } elseif {[regexp $decimal_pattern -- $number]} {
    		return 1
    	} elseif { [string equal "." $number] } {
            return 1
    	} else {
#    	puts [regexp $decimal_pattern -- $number]
            post_message -type warning "validate_float in unknown state for $number"
    		return 0
    	}
    }
    
    ################################################################################
    # Recursively enable or disable a series of nested widgets.
    proc recursive_widget_state { args } {

        set options {
            { "widget.arg" "" "Path of widget" }
            { "state.arg" "" "State to set" }
            { "exclude.arg" "" "Widget to exclude"}
        }
        array set opts [::cmdline::getoptions args $options]
    
        # If it's called with what you're excluding, return immediately.
        if { [string match $opts(exclude) $opts(widget)] } { return }
    
        set children [winfo children $opts(widget)]
        if { 0 == [llength $children] } {
            if { [catch { $opts(widget) cget -state } cur_state] } {
                # It doesn't have a state attribute
                return
            } elseif { [string equal $cur_state $opts(state)] } {
                # It's already at the desired state
                return
            } else {
                catch { $opts(widget) configure -state $opts(state) }
                return
            }
        }
    
        foreach child $children {
            if { [string match $opts(exclude) $child] } { continue }
            recursive_widget_state -widget $child -state $opts(state) \
                -exclude $opts(exclude)
        }
    }

    ##########################################
    # Enable a set of widgets and disable another
    # set of widgets
    proc enable_disable_widgets { args } {

        set options {
            { "normal_widgets.arg" "" "Widgets to set normal state" }
            { "disabled_widgets.arg" "" "Widgets to set to disabled state"}
        }
        array set opts [::cmdline::getoptions args $options]

        foreach w $opts(normal_widgets) { $w configure -state "normal" }
        foreach w $opts(disabled_widgets) { $w configure -state "disabled" }
    }

    ################################################################################
    # Return the ID for the given clock name
    # Returns an error if there is not exactly one ID for the name
    proc get_clock_id { args } {
    
        set options {
            { "clock_name.arg" "" "Name of clock to find the ID for" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        if { [string equal "" $opts(clock_name)] } {
            return -code error "get_clock_id: No clock name is specified"
        }
        
        set clock_col [get_clocks $opts(clock_name)]
        set col_size [get_collection_size $clock_col]
        if { 1 != $col_size } {
            return -code error "Found $col_size clocks named $opts(clock_name)"
        } else {
            foreach_in_collection clock_id $clock_col { return $clock_id }
        }
    }

    ###########################################
    # return 1 if the two arrays are the same.
    # Same is defined as identical names, and identical values for
    # each name
    proc check_arrays_equal { a1 a2 } {

        upvar $a1 array_a
        upvar $a2 array_b
        
        # Array entries are different, so it has to be different
        if { ! [util::check_lists_equal [array names array_a] \
            [array names array_b] ] } {
            return 0
        }
        
        # Array entries are identical. How about values
        foreach n [array names array_a] {
            if { ! [string equal $array_a($n) $array_b($n)] } {
                return 0
            }
        }
        
        # All entry values matched. Nothing is different.
        return 1
    }

    ###################################
    proc puts_debug { args } {
        global script_options
        if { $script_options(debug) } {
            eval post_message -type extra_info $args
        }
    }

    ######################################
    # Find the greatest common divisor
    proc gcd { a b } {
    
        while { 0 != $b } {
            set temp $b
            set b [expr { $a % $b }]
            set a $temp        
        }
        return $a
    }

    ######################################
    # Find the least common multiple
    proc lcm { a b } {
        return [expr { ($a / [gcd $a $b]) * $b }]
    }
    
    ############################################
    # Returns 1 if all the port names specified
    # exist in the design.
    # Returns 0 if any of the names specified do not match something
    proc validate_port_names { args } {
    
        set options {
            { "names.arg" "" "Names to check" }
            { "type.arg" "data" "Clock or data" }
            { "one_port" "Name must match one port only" }
            { "error_var.arg" "Variable for list of errors" }
            { "valid_var.arg" "" "Variable to hold valid names" }
        }
        array set opts [::cmdline::getoptions args $options]

        # Connect the errors list if we pass in a var name
        if { [string equal "" $opts(error_var)] } {
            set errors [list]
        } else {
            upvar $opts(error_var) errors
        }

        # Connect the valid names list if we pass in a var name
        if { [string equal "" $opts(valid_var)] } {
            set valid_names [list]
        } else {
            upvar $opts(valid_var) valid_names
        }
        
        # Return 0 if there are no ports specified
        if { 0 == [llength $opts(names)] } {
            set msg "You must enter "
            if { ! $opts(one_port) } { append msg "at least " }
            append msg "one $opts(type) port name."
            lappend errors [list $msg]
            return 0
        }
        
        # What things you've entered do not match anything?
        set unmatched_names [list]
        
        # Assume things are good
        set is_valid 1
        
        # How many matches are there per name pattern?
        array set matches_per_name [list]
        
        # Walk through every name that is passed in and see whether it matches
        # ports in the design
        foreach name [lsort -dictionary $opts(names)] {
        
            set name_collection [get_ports [list $name]]
            if { [catch { get_collection_size $name_collection } collection_size] } {
                # Error getting the collection size.
                lappend unmatched_names $name
                set is_valid 0
                
            } else {
            
                if { 0 == $collection_size } {
                    lappend unmatched_names $name
                    set is_valid 0
                } else {
                    set matches_per_name($name) $collection_size
                    foreach_in_collection port_id $name_collection {
                        lappend valid_names [get_port_info -name $port_id]
                    }                
                }
            }
        }
        
        # If we're restricting to one port, check that and put together an error
        # if more than 1 matched
        if { $opts(one_port) } {
        
            set num_valid_names [llength $valid_names]
            if { 1 == $num_valid_names } {
                # That's good - we want one, and there is only one.
                # In that case, the valid name to the first index of the valid
                # names list.
                set valid_names [lindex $valid_names 0]
            } else {
                set is_valid 0
                set too_many_matches [list]
                foreach n [lsort -dictionary [array names matches_per_name]] {
                    lappend too_many_matches "$n matches $matches_per_name($n) port(s)"
                }
                lappend errors [list "There were $num_valid_names matching names\
                    in your design, but only 1 name can match." [list $too_many_matches]]
            }
        }

        # Put together the error about unmatched names, now that all the
        # unmatched names have been discovered
        if { 0 < [llength $unmatched_names] } {
            lappend errors [list "The following names you entered do not\
                match any $opts(type) ports in your design." \
                [list $unmatched_names] \
            ]
        }
        
        return $is_valid
    }
    
    ################################
    # Find the unateness of the register's clock
    proc get_clock_unateness { args } {
    
        set options {
            { "register_id.arg" "" ""}
        }
        array set opts [::cmdline::getoptions args $options]
    
        # Get the clock edges for the register
        if { [catch { get_register_info -clock_edges $opts(register_id) } res] } {
            return -code error "Error getting clock edges for $opts(register_id)\
                in get_clock_unateness:\n$res"
        } else {
            set clock_edges $res
        }
        
        # Get the name of the register in case there are errors to report
        if { [catch { get_register_info -name $opts(register_id) } res] } {
            return -code error "Error getting register name for $opts(register_id)\
                in get_clock_unateness: $res"
        } else {
            set register_name $res
        }
        
        # We should have just one clock edge
        switch -exact -- [llength $clock_edges] {
            "0" {
                return -code error "No clock edges found for $register_name in\
                    get_clock_unateness"
            }
            "1" {
                set clock_edge [lindex $clock_edges 0]
            }
            default {
                post_message -type warning "$register_name has multiple clock\
                    edges in get_clock_unatness. Arbitrarily picking the first one."
                set clock_edge [lindex $clock_edges 0]
            }
        }
        
        # Return the unateness
        if { [catch { get_edge_info -unateness $clock_edge} unateness] } {
            return "unknown"
        } else {
            return $unateness
        }
    }
    
    #######################################
    # Do a list search that handles names of
    # things in brackets like foo[0]
    # Regular lsearch doesn't seem happy with things in brackets
    proc lsearch_with_brackets { search_list search_term } {
    
        set found 0
        set on_element 0
        foreach i $search_list {
            if { [string equal $i $search_term] } {
                set found 1
                break
            }
            incr on_element
        }
        if { $found } {
            return $on_element
        } else {
            return -1
        }
    }
    
    ##########################################################
    # For equal, I want to knock sigma off the larger number, then test
    # For greater than, I want to knock sigma off the larger
    # I think I always want to knock sigma off the larger...
    # except for less than? Knock sigma off the smaller number.
    proc fuzzy_comparison { a operator b { sigma "2%" } } {
    
        if { $a < $b } {
            set max $b
        } else {
            set max $a
        }
        
        if { [regexp {^(\d+)\s*%$} $sigma -> percent] } {
            set extra [expr { double($percent)/100 * $max }]  
        } elseif { [string is float $sigma] } {
            set extra $sigma
        } else {
            return -code error "Unknown format for sigma value $sigma"
        }
        switch -exact -- $operator {
            "==" {
                if { $a > $b } {
                    # If a unmodified is greater than b, consider it equal
                    # if a with extra amount subtracted is less than b
                    return [expr { $a - $extra <= $b }]
                } elseif { $a < $b } {
                    # If a unmodified is less than b, consider it equal
                    # if a with extra amounted added is greater than b
                    return [expr { $a + $extra >= $b }]
                } else {
                    return 1
                }
            }
            ">" {
                if { $a == $b } {
                    return 0
                } elseif { $a > $b } {
                    # add sigma to a and evaluate
                    set b [expr { $b + $extra }]
                } else {
                    set a [expr { $a + $extra }]
                }
            }
            ">=" {
                if { $a == $b } {
                    return 1
                } elseif { $a >= $b } {
                    # add sigma to a and evaluate
                    set b [expr { $b + $extra }]
                } else {
                    set a [expr { $a + $extra }]
                }
            }
            "<" {
                if { $a == $b } {
                    return 0
                } elseif { $a < $b } {
                    # add sigma to b and evaluate
                    set a [expr { $a + $extra }]
                } else {
                    set b [expr { $b + $extra }]
                }
            }
            "<=" {
                if { $a == $b } {
                    return 1
                } elseif { $a <= $b } {
                    # add sigma to b and evaluate
                    set a [expr { $a + $extra }]
                } else {
                    set b [expr { $b + $extra }]
                }
            }
            default {
                return -code error "Unknown operator in fuzzy_comparison:\
                    $operator"
            }
        }

        return [eval expr { $a $operator $b }]
    }

    ######################################################################
    # Take two numbers and return the one with more zeros at the end
    proc closer_to_integer { a b } {
    
        set a_dp [format "%.3f" $a]
        set b_dp [format "%.3f" $b]
        
        # Count the number of zeros at the end of the number.
        # more zeros is better.
        set a_zeros ""
        set b_zeros ""
        regexp {(0+)$} $a_dp -> a_zeros
        regexp {(0+)$} $b_dp -> b_zeros
        set a_num_zeros [string length $a_zeros]
        set b_num_zeros [string length $b_zeros]
        
        if { 0 < $a_num_zeros || 0 < $b_num_zeros } {
        
            # If there are zeros at the end of either, and the number of zeros
            # is the same, return the greater value
            if { $a_num_zeros == $b_num_zeros } {
                if { $a > $b } { return $a } else { return $b }
            } elseif { $a_num_zeros > $b_num_zeros } {
                # Otherwise return whichever number has more zeros
                return $a
            } else {
                return $b
            }
        
        } else {
            # There are no zeros at the end, return the greater one
            if { $a > $b } { return $a } else { return $b }
        }

    }

    #########################################
    # Return a list of transfers to cut
    proc get_transfer_edge_cuts { args } {
    
        log::log_message "Calling get_transfer_edge_cuts $args"
        
        set options {
            { "register_name.arg" "" "" }
            { "data_rate.arg" "" "sdr or ddr" }
            { "transfer_edge.arg" "" "same or opposite" }
            { "direction.arg" "" "input or output" }
            { "io_timing_method.arg" "setup_hold, clock_to_out, max_skew, min_valid" }
            { "setup_cut_edges_var.arg" "" "Name of user-cut edges var" }
            { "hold_cut_edges_var.arg" "" "Name of user-cut edges var" }
            { "extra_setup_cuts.arg" "" "Extra setup cut list" }
            { "extra_hold_cuts.arg" "" "Extra hold cut list" }
            { "advanced_false_paths.arg" "" "Advanced cuts?" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        upvar 1 $opts(setup_cut_edges_var) setup_cut_edges
        upvar 1 $opts(hold_cut_edges_var) hold_cut_edges
    
        set combos [list "rise,rise" "rise,fall" "fall,rise" "fall,fall"]
        
        # Advanced is the easy part - just return whatever is set
        if { $opts(advanced_false_paths) } {
        
            foreach combo $combos {
                set setup_cut_edges($combo) \
                    [expr { -1 != [lsearch $opts(extra_setup_cuts) $combo] }]
                set hold_cut_edges($combo) \
                    [expr { -1 != [lsearch $opts(extra_hold_cuts) $combo] }]
            }
            # Wow! That was easy!
            # Do a little bit of sanity stuff - an SDR transfer should have
            # 3 cut edges.
            switch -exact -- $opts(data_rate) {
                "sdr" {
                    set num_setup_cuts [llength $opts(extra_setup_cuts)]
                    set num_hold_cuts [llength $opts(extra_hold_cuts)]
                    if { 3 != $num_setup_cuts } {
                        post_message -type warning "A single data rate interface\
                            should have one valid setup relationship for data transfer."
                        post_message -type warning "This interface has\
                            [expr { 4 - $num_setup_cuts }]"
                    }
                    if { 3 != $num_hold_cuts } {
                        post_message -type warning "A single data rate interface\
                            should have one valid hold relationship for data transfer."
                        post_message -type warning "This interface has\
                            [expr { 4 - $num_hold_cuts }]"
                    }
                }
                "ddr" { }
                default {
                    return -code error "Unknown value for data_rate in\
                        get_transfer_edge_cuts: $opts(data_rate)"
                }
            }
            # end of advanced
            return
        }
        
        # Now figure out for non-advanced transfer edges what gets false paths
        switch -exact -- $opts(data_rate) {
        "sdr" {
        
            # The chance of a setup or hold path in an SDR interface needing
            # a false path seems to be really tiny.
            # If the register is inverted, one end is a fall from or to.
            # Else it's a rise from or to
            foreach_in_collection register_id \
                [get_registers $opts(register_name)] { break } 
            set unateness [get_clock_unateness -register_id $register_id]
            switch -exact -- $unateness {
                "negative" { set one_end "fall" }
                "positive" { set one_end "rise" }
                "unknown" {
                    post_message -type warning "Can't determine unateness for\
                        ${register_id}. Assuming positive."
                    set one_end "rise"
                }
                default {
                    # Should never get here
                    return -code error "Unexpected unateness value of $unateness\
                        returned for id $register_id"
                }
            }
            
            # Figure out the other end based on the transfer edge polarity
            switch -exact -- $opts(transfer_edge) {
                "same" { set other_end $one_end }
                "opposite" {
                    switch -exact -- $one_end {
                        "fall" { set other_end "rise" }
                        "rise" { set other_end "fall" }
                        default {
                            # We should never get here
                            return -code error "Bad value for one_end\
                                in get_transfer_edge_cuts: $one_end"
                        }
                    }
                }
                default {
                    # We should never get here
                    return -code error "Bad value for transfer_edge\
                        in get_transfer_edge_cuts: $opts(transfer_edge)"
                }
            }
                
            # Choose which end is from and which is to, based on direction
            # constraint_pairs is a list of edge polarities with the following form
            # { { setup_from setup_to } { hold_from hold_to } }
            switch -exact -- $opts(direction) {
                "input" {
                    set s ${other_end},${one_end}
                    set h ${other_end},${one_end}
                }
                "output" {
                    set s ${one_end},${other_end}
                    set h ${one_end},${other_end}
                }
                default {
                    # We should never get here
                    return -code error "Bad value for direction\
                        in get_transfer_edge_cuts: $opts(direction)"
                }
            }
            
            # s and h are the valid edges. 
            foreach combo $combos {
                set setup_cut_edges($combo) [expr { ! [string equal $s $combo] }]
                set hold_cut_edges($combo) [expr { ! [string equal $h $combo] }]
            }
        }
        "ddr" {
        
            # Some of the setup and hold array values are going to be valid,
            # and others are going to be invalid, based on what the transfer
            # edge is and whether we're doing skew or system.
            # Figure out false path rise/fall and multicycle rise/fall
            # For system timing, false paths and multicycles are straight-
            # forward, based on transfer_edge
            # For skew timing, false paths are the same for setup and hold
            # 1 indicates cut, 0 indicates valid
            switch -exact -- $opts(transfer_edge) {
                "same" {
                    # We're doing same edge transfer, so cut opposite setups
                    set setup_cut_edges(rise,rise) 0
                    set setup_cut_edges(rise,fall) 1
                    set setup_cut_edges(fall,rise) 1
                    set setup_cut_edges(fall,fall) 0
                    
                    switch -exact -- $opts(io_timing_method) {
                        "max_skew" -
                        "min_valid" {
                            # Same edge skew requires cutting opposite edge for
                            # outputs
                            switch -exact -- $opts(direction) {
                            "output" {
                            set hold_cut_edges(rise,rise) 0
                            set hold_cut_edges(rise,fall) 1
                            set hold_cut_edges(fall,rise) 1
                            set hold_cut_edges(fall,fall) 0
                            }
                            "input" {
                            set hold_cut_edges(rise,rise) 1
                            set hold_cut_edges(rise,fall) 0
                            set hold_cut_edges(fall,rise) 0
                            set hold_cut_edges(fall,fall) 1
                            }
                            }
                        }
                        "setup_hold" -
                        "clock_to_out" {
                            # Same edge system requires valid opposite edge holds
                            set hold_cut_edges(rise,rise) 1
                            set hold_cut_edges(rise,fall) 0
                            set hold_cut_edges(fall,rise) 0
                            set hold_cut_edges(fall,fall) 1
                        }
                        default {
                            return -code error "Unknown io timing method in\
                                get_transfer_edge_cuts: $opts(io_timing_method)"
                        }
                    }
                }
                "opposite" {
                    # Doing opposite edge transfer, so cut same edge setups
                    set setup_cut_edges(rise,rise) 1
                    set setup_cut_edges(rise,fall) 0
                    set setup_cut_edges(fall,rise) 0
                    set setup_cut_edges(fall,fall) 1

                    switch -exact -- $opts(io_timing_method) {
                        "max_skew" -
                        "min_valid" {
                            # Opposite edge skew requires cutting same edge for
                            # output
                            switch -exact -- $opts(direction) {
                            "output" {
                            set hold_cut_edges(rise,rise) 1
                            set hold_cut_edges(rise,fall) 0
                            set hold_cut_edges(fall,rise) 0
                            set hold_cut_edges(fall,fall) 1
                            }
                            "input" {
                            set hold_cut_edges(rise,rise) 0
                            set hold_cut_edges(rise,fall) 1
                            set hold_cut_edges(fall,rise) 1
                            set hold_cut_edges(fall,fall) 0
                            }
                            }
                        }
                        "setup_hold" -
                        "clock_to_out" {
                            # Opposite edge system requires valid same edge holds
                            set hold_cut_edges(rise,rise) 0
                            set hold_cut_edges(rise,fall) 1
                            set hold_cut_edges(fall,rise) 1
                            set hold_cut_edges(fall,fall) 0
                        }
                        default {
                            return -code error "Unknown io timing method\
                                in get_transfer_edge_cuts: $opts(io_timing_method)"
                        }
                    }
                }
                default {
                    return -code error "Unknown value for transfer_edge in\
                        get_transfer_edge_cuts: $opts(transfer_edge)"
                }
            }
        }
        default {
            return -code error "Unknown value for data_rate in\
                get_transfer_edge_cuts: $opts(data_rate)"
        }
        }
    }
    
    #####################################
    proc make_message_for_dialog { args } {

        set options {
            { "messages.arg" "" "List of messages" }
            { "indent.arg" "0" "Levels of indent" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        set msg ""
        
        append msg [string repeat "    " $opts(indent)]
        append msg [lindex $opts(messages) 0]
        append msg "\n"
        
        if { 2 == [llength $opts(messages)] } {
            incr opts(indent)
            foreach sub [lindex $opts(messages) 1] {
                append msg [make_message_for_dialog \
                    -messages $sub \
                    -indent $opts(indent)]
            }
        }
        return $msg
    }
    
    ##########################################
    # See whether the specified file name is part of the project
    proc add_file_to_project { args } {
    
        set options {
            { "file_name.arg" "" "Name of file to add" }
            { "file_type.arg" "" "Type of the file, for the QSF variable" }
            { "comment.arg" "" "Comment for the assignment" }
        }
        array set opts [::cmdline::getoptions args $options]
        
        # Make sure the data file is part of the project
        set file_is_included 0
        
        foreach_in_collection asgn_id [get_all_assignments -type global -name $opts(file_type)] {
            if { [string equal $opts(file_name) \
                [get_assignment_info $asgn_id -value]] } {
                set file_is_included 1
            } 
        }
        
        if { ! $file_is_included } {
            # If the file is not part of the project, add it.
            set_global_assignment -name $opts(file_type) \
                -comment $opts(comment) $opts(file_name)
        }

    }

    ################################################################################
    # Pass in a list of data (a flattened array)
    # This strips out anything that is a default value
    proc remove_clock_default_values { args } {
    
        set options {
            { "clock_id.arg" "" "ID of clock to work on" }
            { "type.arg" "" "Base, virtual, or generated" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        array set clock_info [list]
    
        set clock_info(name) [get_clock_info -name $opts(clock_id)]
    
        # Do base and virtual clocks
        switch -exact -- $opts(type) {
        "base" -
        "virtual" {
    
            # Always get the period and rising/falling edges
            set clock_info(period) [get_clock_info -period $opts(clock_id)]
            foreach { clock_info(wer) clock_info(wef) } [get_clock_info -waveform $opts(clock_id)] { break }
    
            # If the rising and falling edges are 0 and period/2, clear them out,
            # because that's the default.
            if {( 0 == $clock_info(wer) ) && \
                ( 0.002 >= abs((double($clock_info(period)) / 2) - $clock_info(wef)) ) } {
                unset clock_info(wer)
                unset clock_info(wef)
            }
        }
        "generated" {
    
            # Set values based on the "Based-on" method
            if { 0 < [llength [get_clock_info -edges $opts(clock_id)]] } {
    
                set clock_info(based_on)    "waveform"
                foreach { clock_info(edge1) clock_info(edge2) clock_info(edge3) } \
                    [lrange [get_clock_info -edges $opts(clock_id)] 0 2] { break }
                foreach { clock_info(edgeshift1) clock_info(edgeshift2) clock_info(edgeshift3) } \
                    [lrange [get_clock_info -edge_shift $opts(clock_id)] 0 2] { break }
    
            } else {
    
                set clock_info(based_on)    "frequency"
                set clock_info(divide_by)   [get_clock_info -divide_by $opts(clock_id)]
                set clock_info(multiply_by) [get_clock_info -multiply_by $opts(clock_id)]
                set clock_info(duty_cycle)  [get_clock_info -duty_cycle $opts(clock_id)]
                set clock_info(phase)       [get_clock_info -phase $opts(clock_id)]
                set clock_info(offset)      [get_clock_info -offset $opts(clock_id)]
                if { 1 == $clock_info(divide_by) } { unset clock_info(divide_by) }
                if { 1 == $clock_info(multiply_by) } { unset clock_info(multiply_by) }
                if { 0 == $clock_info(phase) } { unset clock_info(phase) }
                if { 0 == $clock_info(offset) } { unset clock_info(offset) }
                if { 50 == $clock_info(duty_cycle) } {
                    unset clock_info(duty_cycle)
                } elseif { [string equal "" $clock_info(duty_cycle)] } {
                    unset clock_info(duty_cycle)
                }
    
            }
    
            if { [get_clock_info -is_inverted $opts(clock_id)] } {
                set clock_info(invert) 1
            } 
    #        set clock_info(source) [get_clock_info -master_clock_pin $opts(clock_id)]
        }
        default {
            return -code error "Unknown clock type $opts(type) in\
                remove_clock_default_values"
        }
        }
        
        # Handle target
        switch -exact -- $opts(type) {
            "base" -
            "generated" {
                set target_col [get_clock_info -targets $opts(clock_id)]
                set targets [list]
                foreach_in_collection target_id $target_col {
                    lappend targets [get_node_info -name $target_id]
                }
    #            set clock_info(targets) $targets
            }
            "virtual" { }
            default {
                return -code error "Unknown type in remove_clock_default_values:\
                    $opts(type)"
            }
        }
        return [array get clock_info]
    }

    #####################################
    # Figure out trace stuff
    proc validate_trace_delay { args } {
    
        set options {
            { "string.arg" "" "The string value of the delay" }
            { "max_var.arg" "" "Return the max value of the string in nanoseconds" }
            { "min_var.arg" "" "Return the min value of the string in nanoseconds" }
            { "error_messages_var.arg" "" "Name of the variable for error messages" }
            { "delay_name.arg" "" "What is the name of the delay" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        # We may want to get error messages back. If we do, hook
        # up the error messages var to the specified variable.
        if { [string equal "" $opts(error_messages_var)] } {
            set error_messages [list]
        } else {
            upvar $opts(error_messages_var) error_messages
        }

        if { [string equal "" $opts(max_var)] } {
            set max_value ""
        } else {
            upvar $opts(max_var) max_value
        }
        
        if { [string equal "" $opts(min_var)] } {
            set min_value ""
        } else {
            upvar $opts(min_var) min_value
        }
        
        set is_valid 0
        set valid_time_units [list "ps" "ns"]
        set valid_length_units [list "in" "inch" "inches" "mil" "mils" "cm" "mm"]
        
        # Basic pattern for a number with units
        # digits with decimal point, followed by 1 or more spaces, then letters
        set num_ptn {([\d\.]+)\s?([\w\.]+)}
        
        # Check various combinations of numbers and units
        # If it's blank, that's not good
        if { [string equal "" $opts(string)] } {

            lappend error_messages [list "You must enter a value for $opts(delay_name)"]
            set is_valid 0
            
        } elseif { [regexp -nocase -- {^$num_ptn$} $opts(string) -> number unit] } {
            # Is it just a number with a unit?
            
            puts "$opts(string) matches basic number"
            if {[validate_number_and_unit -number $number -unit $unit \
                -error_messages_var error_messages]} {
                # Good
            } else {
                set is_valid 0
            }

        } elseif { [regexp -nocase -- {^$num_ptn\s+\+/?-\s+$num_ptn$} $opts(string) -> \
            nominal nom_unit variation var_unit] } {

            # Is it a plus/minus thing?
            puts "$opts(string) plus minus"
            if {
                [validate_number_and_unit -number $nominal -unit $nom_unit \
                    -error_messages_var error_messages] && \
                [validate_number_and_unit -number $variation -unit $var_unit \
                    -error_messages_var error_messages] } {
                # Good
            } else {
                set is_valid 0
            }

        } elseif { [regexp -nocase -- {^$num_ptn\s+(to|-)\s+$num_ptn$} $opts(string) -> \
            min min_unit sep max max_unit] } {
            
            puts "$opts(string) min max"
            if {
                [validate_number_and_unit -number $min -unit $min_unit \
                    -error_messages_var error_messages] && \
                [validate_number_and_unit -number $max -unit $max_unit \
                    -error_messages_var error_messages] } {
                # Good
            } else {
                set is_valid 0
            }
            
        } else {
            lappend error_messages [list "$opts(string) is not recognized as a\
                valid trace delay value"]
            set is_valid 0
        }
        
        return $is_valid
    }
    
    ######################################################################
    # All trace delay values have to be turned into nanoseconds for the
    # input/output delay constraint values.
    # This procedure returns a string that can be subst'ed and eval'ed
    # for converting from the specified units to nanoseconds.
    # The string includes %value% which gets regsub'ed with the value to
    # convert to nanoseconds.
    proc get_conversion_expression { args } {
    
        set options {
            { "unit.arg" "" "The string of the unit" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        set conversion_expression ""
        
        switch -exact -- [string tolower $opts(unit)] {
            "ns" {
                # If the unit coming in is nanoseconds, you don't have to do
                # any conversion to get nanoseconds.
                set conversion_expression "%value%"
            }
            "ps" {
                # The unit coming in is picoseconds. Divide by 1000 to get
                # nanoseconds.
                set conversion_expression "(%value% / 1000.0)"
            }
            "in" -
            "inch" -
            "inches" {
                # For the length unit of inches, we have to use the trace
                # propagation rate to do the conversion. That rate is in ps/in,
                # so convert to ns/in by dividing by 1000, and multiply by
                # the trace length.
                set conversion_expression "(%value% * trace_propagation_rate / 1000.0)"
            }
            "mil" -
            "mill" -
            "mils" -
            "mills" {
                # Mils is thousandths of an inch, divide that value by 1000 to get
                # inches, then multiply by the trace propagation rate which
                # has been converted to ns/in
                set conversion_expression "(%value% / 1000.0) * (trace_propagation_rate / 1000.0)"
            }
            "cm" {
                # Centimeters has to be converted to inches first, so divide 
                # by 2.54
                set conversion_expression "(%value% / 2.54) * (trace_propagation_rate / 1000.0)"
            }
            "mm" {
                # And milimeters has to be converted to inches first, so divide
                # by 25.4
                set conversion_expression "(%value% / 25.4) * (trace_propagation_rate / 1000.0)"
            }
            default {
                # bad unit
                return -code error "get_conversion_expression error: $opts(unit)\
                    is not recognized as a valid trace delay unit."
            }
        }
        
        return $conversion_expression
    }
    
    ######################################################################
    proc validate_number_and_unit { args } {
    
        set options {
            { "number.arg" "" "The string value of the number" }
            { "unit.arg" "" "The string of the unit" }
            { "math_string_var.arg" "" "What's the expression to normalize it?" }
            { "error_messages_var.arg" "" "Variable name for error messages" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        # We may want to get a math string back
        if { [string equal "" $opts(math_string_var)] } {
            set math_string ""
        } else {
            upvar $opts(math_string_var) math_string
        }
        
        # We may want to get error messages back
        if { [string equal "" $opts(error_messages_var)] } {
            set error_messages [list]
        } else {
            upvar $opts(error_messages_var) error_messages
        }
        
        set is_valid 1
        
        # Check the number
        if { [string is double $opts(number)] } {
        
            # Good - check the units
            switch -exact -- [string tolower $opts(unit)] {
                "ns" {
                    set math_string $opts(number)
                }
                "ps" {
                    set math_string "($opts(number) / 1000.0)"
                }
                "in" -
                "inch" -
                "inches" {
                    set math_string "($opts(number) * propagation_delay / 1000.0)"
                }
                "mil" -
                "mill" -
                "mils" -
                "mills" {
                    set math_string "($opts(number) / 1000.0) * (propagation_delay / 1000.0)"
                }
                "cm" {
                    set math_string "($opts(number) / 2.54) * (propagation_delay / 1000.0)"
                }
                "mm" {
                    set math_string "($opts(number) / 25.4) * (propagation_delay / 1000.0)"
                }
                default {
                    # bad unit
                    lappend error_messages [list "$opts(unit) is not recognized as\
                        a valid trace delay unit."]
                    set is_valid 0
                }
            }
            
        } else {
            # Bad
            lappend error_messages [list "$opts(number) is not recognized as a numeric value"]
            set is_valid 0
        }
        
        return $is_valid
    }
}

################################################################################
# A couple of procedures to wrap up state for the interfaces listed on the
# SDC page of the main wizard
namespace eval checked_interfaces {

    variable checked_interfaces
    
    proc reset { args } {
        variable checked_interfaces
        set checked_interfaces [list]
    }
    
    proc get { args } {
        variable checked_interfaces
        return $checked_interfaces
    }
    
    proc is_checked { i } {
        variable checked_interfaces
        return [expr { -1 != [lsearch $checked_interfaces $i] }]
    }
    
    proc add { i } {
        variable checked_interfaces
        if { [is_checked $i] } {
            # That's bad - it's already there?
            return -code error "Inconsistent internal state in\
                checked_interfaces::add - adding $i to the list\
                of checked interfaces, but it is already in the list."
        } else {
            lappend checked_interfaces $i
        }
    }
    
    proc remove { i } {
        variable checked_interfaces
        set index [lsearch $checked_interfaces $i]
        if { -1 == $index } {
            # That's bad - it's not in the list?
            return -code error "Inconsistent internal state in\
                checked_interfaces::remove - Removing $i from the list\
                of checked interfaces, but it is not in the list."
        } else {
            set checked_interfaces [lreplace $checked_interfaces $index $index]
        }
    }
}

################################################################################
namespace eval draw_diagram {

    variable wave_dy 10
    variable wave_dx 6

    # Default height and width of DDR rectangle
    variable ddr_height 35 ddr_width 25

    # Default sizes for a clock source
    variable clock_source_diameter 16

    variable chip_height            80
    variable chip_width             90

    #################################################
    proc draw_register { args } {

        set options {
            { "canvas.arg" "" "" }
            { "tags.arg" "" "List of tags to apply" }
            { "x.arg" "" "X coordinate" }
            { "y.arg" "" "Y coordinate" }
            { "anchor.arg" "c" "Anchor" }
            { "is_ddr" "Put text saying DDR in the register"}
        }
        array set opts [::cmdline::getoptions args $options]
        variable ddr_height
        variable ddr_width
        
        if { [regexp {n} $opts(anchor)] } {
            # It's north by default
        } elseif { [regexp {s} $opts(anchor)] } {
            set opts(y) [expr { $opts(y) - $ddr_height } ]
        } else {
            set opts(y) [expr { $opts(y) - ($ddr_height / 2) } ]            
        }
        
        if { [regexp {w} $opts(anchor)] } {
            # It's west by default
        } elseif { [regexp {e} $opts(anchor)] } {
            set opts(x) [expr { $opts(x) - $ddr_width }]
        } else {
            set opts(x) [expr { $opts(x) - ($ddr_width / 2) }]
        }
        # Rectangle
        $opts(canvas) create rectangle $opts(x) $opts(y) \
            [expr { $ddr_width + $opts(x)}] [expr { $ddr_height + $opts(y)}] -tag $opts(tags)
            
        if { $opts(is_ddr) } {
            # DDR text
            $opts(canvas) create text [expr { 10 + $opts(x) }] [expr { 10 + $opts(y) }] \
                -text "DDR" -anchor nw -tag $opts(tags)
        }
        
        # Clock input >
        $opts(canvas) create line $opts(x) [expr { 20 + $opts(y) }] \
            [expr { 5 + $opts(x) }] [expr { 25 + $opts(y) }] \
            $opts(x) [expr { 30 + $opts(y) }] -tag $opts(tags)

        # Put together an array with the data_in, data_out, and
        # clock_in connection points
        return [list \
            "data_in"  [list $opts(x) [expr { 10 + $opts(y)}] ] \
            "data_out" [list [expr { $ddr_width + $opts(x)}] [expr { 10 + $opts(y)}] ] \
            "clock_in" [list $opts(x) [expr { 25 + $opts(y)}] ] \
            ]
    }
    
    #################################################
    proc draw_clock_source { args } {

        set options {
            { "canvas.arg" "" "" }
            { "tags.arg" "" "List of tags to apply" }
            { "x.arg" "" "X coordinate" }
            { "y.arg" "" "Y coordinate" }
            { "anchor.arg" "c" "Anchor" }
        }
        array set opts [::cmdline::getoptions args $options]
        variable clock_source_diameter
        
        if { [regexp {n} $opts(anchor)] } {
            # It's north by default
        } elseif { [regexp {s} $opts(anchor)] } {
            set opts(y) [expr { $opts(y) - $clock_source_diameter } ]
        } else {
            set opts(y) [expr { $opts(y) - ($clock_source_diameter / 2) } ]            
        }
        
        if { [regexp {w} $opts(anchor)] } {
            # It's west by default
        } elseif { [regexp {e} $opts(anchor)] } {
            set opts(x) [expr { $opts(x) - $clock_source_diameter }]
        } else {
            set opts(x) [expr { $opts(x) - ($clock_source_diameter / 2) }]
        }
        # Circle
        $opts(canvas) create oval $opts(x) $opts(y) \
            [expr { $clock_source_diameter + $opts(x)}] \
            [expr { $clock_source_diameter + $opts(y)}] -fill white -tag $opts(tags)

        # Clock waveform
        # __
        # | |__|
        set wave_left [expr { $opts(x) + 4 }]
        set wave_bottom [expr { $opts(y) + 11 }]
        set wave_top [expr { $opts(y) + 5 }]
        $opts(canvas) create line $wave_left $wave_bottom \
            $wave_left $wave_top \
            [expr { 4 + $wave_left }] $wave_top \
            [expr { 4 + $wave_left }] $wave_bottom \
            [expr { 8 + $wave_left }] $wave_bottom \
            [expr { 8 + $wave_left }] $wave_top
    }
    
    #################################################
    # I want a clock that looks like this:
    # _      ____      ____
    #  |____|    |____|    |_
    # It should be as wide as the canvas
    proc draw_clock { args } {

        log::log_message "Calling draw_clock $args"
        set options {
            { "canvas.arg" "" "" }
            { "tags.arg" "" "List of tags to apply" }
            { "x.arg" "" "X coordinate" }
            { "y.arg" "" "Y coordinate" }
            { "clock_id.arg" "" "ID of the clock being drawn" }
            { "left_bound.arg" "0" "Draw waveforms from this point" }
            { "right_bound.arg" "0" "Draw waveforms to this point" }
            { "mult.arg" "100" "Pixel multiplier for canvas" }
            
        }
        array set opts [::cmdline::getoptions args $options]

        variable wave_dy

        set mult $opts(mult)
        set period [get_clock_info -period $opts(clock_id)]
        set period [expr { $mult * $period }]
        foreach { rise_at fall_at } [get_clock_info -waveform $opts(clock_id)] { break }
        set rise_at [expr { $mult * $rise_at }]
        set fall_at [expr { $mult * $fall_at }]
        set high_time [expr { $fall_at - $rise_at }]
        set right_bound [expr { $mult * $opts(right_bound) }]
        set left_bound [expr { $mult * $opts(left_bound) }]
        
        set y1 $opts(y)
        set y2 [expr { $opts(y) + $wave_dy }]

        # Draw the waveform to the right of the rise at
        set coords [list]
        for { set i $rise_at } { $i <= $right_bound } { set i [expr { $i + $period }] } {
            lappend coords \
                $i $y2 \
                $i $y1 \
                [expr { $i + $high_time }] $y1 \
                [expr { $i + $high_time }] $y2 
        }
        
        # Draw the waveform to the left of the rise at
        for { set i $rise_at } { $i >= $left_bound } { set i [expr { $i - $period }] } {
            set coords [linsert $coords 0 \
                [expr { $i - $period }] $y2 \
                [expr { $i - $period }] $y1 \
                [expr { $i - $high_time }] $y1 \
                [expr { $i - $high_time }] $y2 ]
        }
        
        $opts(canvas) create line $coords -tag $opts(tags)
        
    }

    #############################333
    proc draw_data_window { args } {
    
        set options {
            { "canvas.arg" "" "" }
            { "tags.arg" "" "List of tags to apply" }
            { "x.arg" "" "X coordinate" }
            { "y.arg" "" "Y coordinate" }
            { "left.arg" "" "left point" }
            { "right.arg" "" "right point" }
            { "type.arg" "" "valid or invalid" }
            { "mult.arg" "20" "multiplier for time to pixel" }
            
        }
        array set opts [::cmdline::getoptions args $options]
        variable wave_dy
    
        switch -exact -- $opts(type) {
            "valid" { set create_options "-fill white" }
            "invalid" { set create_options "-stipple gray50" }
            default {
                return -code error "Unknown value for type in draw_data_window:\
                    $opts(type)"
            }
        }
        
        set top [expr { $opts(y) - ($wave_dy / 2) }]
        set bottom [expr { $opts(y) + ($wave_dy / 2) }]
        
        # There may be cases where windows are very small.
        # In that case, shrink the end width so lines don't
        # cross over each other.
        # med_left and med_right are the shoulders of the hexagon.
        set distance [expr { $opts(mult) * ($opts(right) - $opts(left)) }]
        if { $distance < 10 } {
            set end_width [expr { $distance / 2 }]
        } else {
            set end_width 5
        }
        set med_left [expr { $opts(left) * $opts(mult) + $end_width }]
        set med_right [expr { $opts(right) * $opts(mult) - $end_width }]
        
        eval $opts(canvas) create polygon \
            [expr { $opts(left) * $opts(mult) }] $opts(y) \
            $med_left $top \
            $med_right $top \
            [expr { $opts(right) * $opts(mult) }] $opts(y) \
            $med_right $bottom \
            $med_left $bottom \
            [expr { $opts(left) * $opts(mult) }] $opts(y) \
            -outline black -tags $opts(tags) $create_options
    }
    
    ################################################
    # Draw a box with a register inside it and lines
    # connecting the register's inputs and outputs to
    # the box boundary
    proc draw_chip { args } {
    
        set options {
            { "canvas.arg" "" "" }
            { "tags.arg" "" "List of tags to apply" }
            { "x.arg" "" "X coordinate" }
            { "y.arg" "" "Y coordinate" }
            { "anchor.arg" "c" "Anchor" }
            { "text.arg" "" "Text label for the chip" }
            { "direction.arg" "" "Output or input - tag for the text" }
            { "clock_out.arg" "" "Left or right - clock that drives out"}
        }
        array set opts [::cmdline::getoptions args $options]

        variable chip_height
        variable chip_width
        
        array set chip_connections [list]

        if { [regexp {n} $opts(anchor)] } {
            # It's north by default
        } elseif { [regexp {s} $opts(anchor)] } {
            set opts(y) [expr { $opts(y) - $chip_height } ]
        } else {
            set opts(y) [expr { $opts(y) - ($chip_height / 2) } ]            
        }
        
        if { [regexp {w} $opts(anchor)] } {
            # It's west by default
        } elseif { [regexp {e} $opts(anchor)] } {
            set opts(x) [expr { $opts(x) - $chip_width }]
        } else {
            set opts(x) [expr { $opts(x) - ($chip_width / 2) }]
        }
        
        # rectangle for FPGA or external device
        $opts(canvas) create rectangle \
            $opts(x) $opts(y) \
            [expr { $opts(x) + $chip_width }] [expr { $opts(y) + $chip_height }] \
            -fill white
        # Text label
        $opts(canvas) create text \
            [expr { $opts(x) + 8 }] [expr { $opts(y) + 4 }] \
            -anchor nw -text $opts(text) -tag $opts(direction)
        # Register
        array set reg [draw_register \
            -canvas $opts(canvas) -x [expr { $opts(x) + 40 }] \
            -y [expr { $opts(y) + 20 }] -anchor nw]

        # Draw lines from register to chip boundaries depending on direction
        switch -exact -- $opts(direction) {
            "input" {
                # Line from data input to chip boundary
                foreach { in_x in_y } $reg(data_in) { break }
                $opts(canvas) create line $in_x $in_y $opts(x) $in_y
                set chip_connections(data_in) [list $opts(x) $in_y]
            }
            "output" {
                # Line from data output to chip boundary
                foreach { out_x out_y } $reg(data_out) { break }
                $opts(canvas) create line $out_x $out_y \
                    [expr { $opts(x) + $chip_width }] $out_y
                set chip_connections(data_out) \
                    [list [expr { $opts(x) + $chip_width }] $out_y]
            }
            default {
                return -code error "Unknown value for direction in\
                    draw_chip: $opts(direction)"
            }
        }

        # Draw line for clock port to chip boundary
        foreach { clk_x clk_y } $reg(clock_in) { break }
        $opts(canvas) create line $clk_x $clk_y \
            [expr { $clk_x - 20 }] $clk_y \
            [expr { $clk_x - 20 }] [expr { $opts(y) + $chip_height }]
        set chip_connections(clock_in) \
            [list [expr { $clk_x - 20 }] [expr { $opts(y) + $chip_height }]]

        # There might be a clock out signal to draw
        switch -exact -- $opts(clock_out) {
            "left" {
                $opts(canvas) create line \
                    [expr { $clk_x - 20 }] [expr { $opts(y) + 65 }] \
                    $opts(x) [expr { $opts(y) + 65 }]
                set chip_connections(clock_out) \
                    [list $opts(x) [expr { $opts(y) + 65 }]]
            }
            "right" {
                $opts(canvas) create line \
                    [expr { $clk_x - 20 }] [expr { $opts(y) + 65 }] \
                    [expr { $opts(x) + $chip_width }] [expr { $opts(y) + 65 }]
                set chip_connections(clock_out) \
                    [list [expr { $opts(x) + $chip_width }] [expr { $opts(y) + 65 }]]
            }
            "" { }
            default {
                return -code error "Unknown value for clock_out in\
                    draw_chip: $opts(clock_out)"
            }
        }

        return [array get chip_connections]
    }
    
    #################################################
    proc draw_system_sync_common_clock { args } {
    
        set options {
            { "canvas.arg" "" "" }
            { "src_x_offset.arg" "" "X coordinate" }
            { "dest_x_offset.arg" "" "Y coordinate" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        array set left [draw_chip -canvas $opts(canvas) \
            -x $opts(src_x_offset) -y 2 -anchor nw -text "FPGA" -direction "output"]
        array set right [draw_chip -canvas $opts(canvas) \
            -x $opts(dest_x_offset) -y 2 -anchor nw -text "External device" -direction "input"]
        # Data connection - had two copies of $left(data_out)
        $opts(canvas) create line \
            [concat $left(data_out) $right(data_in)] -tags "data_connection"
        # dest reg clock port
        foreach { r_clk_x r_clk_y } $right(clock_in) { break }
        # source reg clock port
        foreach { l_clk_x l_clk_y } $left(clock_in) { break }
        # Dest clock connection
        $opts(canvas) create line \
            [concat $right(clock_in) $r_clk_x [expr { $r_clk_y + 10 }] \
                $l_clk_x [expr { $l_clk_y + 10 }] ] \
                -tags "dest_clock_connection"
        # Source clock connection
        $opts(canvas) create line \
            [concat $left(clock_in) $l_clk_x [expr { $l_clk_y + 10 }] \
                [expr { $l_clk_x - 50 }] [expr { $l_clk_y + 10 }]] \
                -tags "src_clock_connection"
        # Common clock source
        draw_clock_source \
            -canvas $opts(canvas) -anchor w \
            -x [expr { $l_clk_x - 50 }] -y [expr { $l_clk_y + 10 }]
    }
    
    ####################################################
    proc draw_system_sync_different_clock { args } {
    
        set options {
            { "canvas.arg" "" "" }
            { "src_x_offset.arg" "" "X coordinate" }
            { "dest_x_offset.arg" "" "Y coordinate" }
        }
        array set opts [::cmdline::getoptions args $options]

        array set left [draw_chip -canvas $opts(canvas) \
            -x $opts(src_x_offset) -y 2 -anchor nw -text "FPGA" -direction "output"]
        array set right [draw_chip -canvas $opts(canvas) \
            -x $opts(dest_x_offset) -y 2 -anchor nw -text "External device" -direction "input"]
        # data connection
        $opts(canvas) create line \
            [concat $left(data_out) $right(data_in)] -tags "data_connection"
        # dest reg clock
        foreach { clk_x clk_y } $right(clock_in) { break }
        $opts(canvas) create line \
            [concat $right(clock_in) $clk_x [expr { $clk_y + 10 }] \
                [expr { $clk_x - 50 }] [expr { $clk_y + 10 }]] \
                -tags "dest_clock_connection"
        # dest clock source
        draw_clock_source \
            -canvas $opts(canvas) -anchor w \
            -x [expr { $clk_x - 50 }] -y [expr { $clk_y + 10 }]
        # source reg
        foreach { clk_x clk_y } $left(clock_in) { break }
        $opts(canvas) create line \
            [concat $left(clock_in) $clk_x [expr { $clk_y + 10 }] \
                [expr { $clk_x - 50 }] [expr { $clk_y + 10 }]] \
                -tags "src_clock_connection"
        # source clock source
        draw_clock_source \
            -canvas $opts(canvas) -anchor w \
            -x [expr { $clk_x - 50 }] -y [expr { $clk_y + 10 }]
    }
    
    ##############################################
    proc draw_source_sync_source_clock { args } {
    
        set options {
            { "canvas.arg" "" "" }
            { "src_x_offset.arg" "" "X coordinate" }
            { "dest_x_offset.arg" "" "Y coordinate" }
        }
        array set opts [::cmdline::getoptions args $options]

        array set left [draw_chip -canvas $opts(canvas) \
            -x $opts(src_x_offset) -y 2 -anchor nw -text "FPGA" -direction "output" \
            -clock_out "right"]
        array set right [draw_chip -canvas $opts(canvas) \
            -x $opts(dest_x_offset) -y 2 -anchor nw -text "External device" -direction "input"]
        # data connection
        $opts(canvas) create line \
            [concat $left(data_out) $right(data_in)] -tags "data_connection"
        # source reg
        foreach { clk_x clk_y } $left(clock_in) { break }
        $opts(canvas) create line \
            [concat $left(clock_in) $clk_x [expr { $clk_y + 10 }] \
                [expr { $clk_x - 50 }] [expr { $clk_y + 10 }]] \
                -tags "src_clock_connection"
        # source clock source
        draw_clock_source \
            -canvas $opts(canvas) -anchor w \
            -x [expr { $clk_x - 50 }] -y [expr { $clk_y + 10 }]
        # dest reg clock in
        foreach { d_clk_x d_clk_y } $right(clock_in) { break }
        # source reg clock out
        foreach { s_clk_x s_clk_y } $left(clock_out) { break }
        $opts(canvas) create line \
            [concat $right(clock_in) $d_clk_x [expr { $d_clk_y + 10 }] \
                [expr { $d_clk_x - 50 }] [expr { $d_clk_y + 10 }] \
                [expr { $d_clk_x - 50 }] $s_clk_y \
                $left(clock_out)] \
                -tags "dest_clock_connection"
    }
    
    ###############################################
    proc draw_source_sync_dest_clock { args } {
    
        set options {
            { "canvas.arg" "" "" }
            { "src_x_offset.arg" "" "X coordinate" }
            { "dest_x_offset.arg" "" "Y coordinate" }
        }
        array set opts [::cmdline::getoptions args $options]

        array set left [draw_chip -canvas $opts(canvas) \
            -x $opts(src_x_offset) -y 2 -anchor nw -text "FPGA" -direction "output"]
        array set right [draw_chip -canvas $opts(canvas) \
            -x $opts(dest_x_offset) -y 2 -anchor nw -text "External device" -direction "input" \
            -clock_out "left"]
        # data connection
        $opts(canvas) create line \
            [concat $left(data_out) $right(data_in)] -tags "data_connection"
        # dest reg clock
        foreach { clk_x clk_y } $right(clock_in) { break }
        $opts(canvas) create line \
            [concat $right(clock_in) $clk_x [expr { $clk_y + 10 }] \
                [expr { $clk_x - 50 }] [expr { $clk_y + 10 }]] \
                -tags "src_clock_connection"
        # dest clock source
        draw_clock_source \
            -canvas $opts(canvas) -anchor w \
            -x [expr { $clk_x - 50 }] -y [expr { $clk_y + 10 }]
        # source reg clock in
        foreach { s_clk_x s_clk_y } $left(clock_in) { break }
        # dest reg clock out
        foreach { d_clk_x d_clk_y } $right(clock_out) { break }
        $opts(canvas) create line \
            [concat $left(clock_in) $s_clk_x [expr { $s_clk_y + 10 }] \
                [expr { $s_clk_x + 85 }] [expr { $s_clk_y + 10 }] \
                [expr { $s_clk_x + 85 }] $d_clk_y \
                $right(clock_out)] \
                -tags "dest_clock_connection"
    }

    ################################################
    # If we choose an output bus, we name the output
    # chip "FPGA" and the input chip "External device"
    # If we choose an input bus, we name the input
    # chip "FPGA" and the output chip "External device"
    proc update_chip_diagram_labels { args } {
    
        set options {
            { "direction.arg" "" "Interface direction - input or output" }
            { "canvas.arg" "" "Canvas to update labels on" }
        }
        array set opts [::cmdline::getoptions args $options]
        
        set input_widget [$opts(canvas) find withtag "input"]
        set output_widget [$opts(canvas) find withtag "output"]
        switch -exact -- $opts(direction) {
            "input" {
                $opts(canvas) itemconfigure $input_widget -text "FPGA"
                $opts(canvas) itemconfigure $output_widget -text "External device"
            }
            "output" {
                $opts(canvas) itemconfigure $output_widget -text "FPGA"
                $opts(canvas) itemconfigure $input_widget -text "External device"
            }
            default {
                return -code error "Unknown value for direction in\
                    update_chip_diagram_labels: $opts(direction)"
            }
        }
    }
    
    ###################################################
    # enable/disable items on a canvas by graying them out
    # Before graying out an item, save its color so it can be restored later
    proc enable_disable_canvas { args } {
    
        set options {
            { "state_variable_name.arg" "" "Variable to hold previous configuration" }
            { "disable" "Gray things out" }
            { "restore" "Put things back how they were" }
            { "canvas.arg" "" "Canvas to update labels on" }
        }
        array set opts [::cmdline::getoptions args $options]

        upvar $opts(state_variable_name) configuration
        
        foreach item [$opts(canvas) find withtag all] {
        
            if { $opts(restore) && [info exists configuration($item)] } {
                eval $opts(canvas) itemconfigure $item $configuration($item)
            } elseif { $opts(disable) } {
                set configuration($item) [list]
                switch -exact -- [$opts(canvas) type $item] {
                    "line" -
                    "text" {
                        lappend configuration($item) -fill \
                            [$opts(canvas) itemcget $item -fill]
                        $opts(canvas) itemconfigure $item -fill SystemDisabledText
                    }
                    "oval" -
                    "rect" -
                    "rectangle" -
                    "poly" -
                    "polygon" {
                        lappend configuration($item) \
                            -fill [$opts(canvas) itemcget $item -fill] \
                            -outline [$opts(canvas) itemcget $item -outline]
                        $opts(canvas) itemconfigure $item -outline SystemDisabledText \
                            -fill SystemButtonFace
                    }
                    default {
                        post_message -type warning "Unknown item type on canvas:\
                            [$opts(canvas) type $item]"
                    }
                }
                
            }
        }
    }
}

################################################################################
namespace eval wizard {

#        [list "target" { "clock_relationship" "target" "requirements" }] \
    variable wizard_pages [list \
        [list "data_ports" { } ] \
        [list "clocking_conf" { "clocking_conf" "src_clock" "dest_clock" } ] \
        [list "src_clock" { "clocking_conf" "src_clock" "dest_clock" } ] \
        [list "dest_clock" { "clocking_conf" "src_clock" "dest_clock" } ] \
        [list "clock_relationship" { "clock_relationship" "target" "requirements" } ] \
        [list "board" { } ] \
        [list "requirements" { "clock_relationship" "target" "requirements" } ] \
    ]
    variable page_names
#        "target" "Target" 
    array set page_names [list \
        "data_ports" "" \
        "clocking_conf" "Configuration" \
        "src_clock" "Source" \
        "dest_clock" "Destination" \
        "clock_relationship" "Relationship" \
        "board" "Board" \
        "requirements" "Requirements" \
    ]
#        "target" { "clock_relationship" "target" "requirements" } 
    variable wizard_pages_list [list \
        "data_ports" { } \
        "clocking_conf" { "clocking_conf" "src_clock" "dest_clock" } \
        "src_clock" { "clocking_conf" "src_clock" "dest_clock" } \
        "dest_clock" { "clocking_conf" "src_clock" "dest_clock" } \
        "clock_relationship" { "clock_relationship" "target" "requirements" } \
        "board" { } \
        "requirements" { "clock_relationship" "target" "requirements" } \
    ]
    variable common_pages
    array set common_pages $wizard_pages_list
    
    variable nav_buttons [list \
        "Data" { "data_ports" } \
        "Clock" { "clocking_conf" "src_clock" "dest_clock" } \
        "Requirements" { "clock_relationship" "board" "requirements" } \
    ]
    variable wizard_dialog
    variable wizard_nb
    variable dialog_title "I/O Timing Constrainer"
    variable nav_button_frame
    variable nav_pm
    variable nav_one_highlight  ""
    variable nav_two_highlight  ""
    variable bb
    variable pages_to_see       [list]

    
    ######################################
    # Put together the wizard steps in a dialog
    proc make_wizard_dialog { args } {
    
        set options {
            { "parent.arg" "Parent for the dialog" }
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable wizard_dialog
        variable wizard_nb
        variable dialog_title
        variable nav_button_frame
        variable wizard_pages_list
        variable common_pages
        variable bb
        
        set wizard_dialog [toplevel .wizard_dialog]
        set f $wizard_dialog
        
        # Put in the nav button frame
        set nav_button_frame [frame $f.nav_buttons]
        
        # Put in the wizard
        set wizard_nb [PagesManager $f.pm]
        foreach { page_name common } $wizard_pages_list {
            $wizard_nb add $page_name
        }
        
#        make_nav_buttons
#        pack $nav_button_frame -side top -anchor nw -fill x -expand true
        
        #################################################
        # Set up the data ports tab
        #################################################
        data_info::assemble_tab -frame \
            [$wizard_nb getframe "data_ports"]

        #################################################
        # Set up the tab to enter the clock configuration
        #################################################
        clocking_config::assemble_tab -frame \
            [$wizard_nb getframe "clocking_conf"]

        #################################################
        # Set up the source clocking tab
        #################################################
        clocks_info::assemble_src_tab -frame [$wizard_nb getframe "src_clock"]
        
        #################################################
        # Set up the destination clocking tab
        #################################################
        clocks_info::assemble_dest_tab -frame [$wizard_nb getframe "dest_clock"]

        #################################################
        # Set up the clock relationship tab
        #################################################
        clock_relationship::assemble_tab -frame \
            [$wizard_nb getframe "clock_relationship"]

        #################################################
        # Set up the board info tab
        #################################################
        board_info::assemble_tab -frame \
            [$wizard_nb getframe "board"]
        
        #################################################
        # Set up the I/O timing target tab
        #################################################
#        requirements_info::assemble_target_tab -frame \
#            [$wizard_nb getframe "target"]
        
        #################################################
        # Set up the timing requirements tab
        #################################################
        requirements_info::assemble_timing_tab -frame \
            [$wizard_nb getframe "requirements"]

        $wizard_nb compute_size
        pack $wizard_nb -fill both -expand true -anchor n -side top \
            -padx 8 -pady 8
        
        set bb [ButtonBox $f.bb] 
        
        $bb add -text "Cancel" -width 10 -command \
            [namespace code close_wizard]
        $bb add -text "< Back"  -width 10 -command \
            [namespace code handle_wizard_back]
        $bb add -text "Next >"  -width 10 -command \
            [namespace code handle_wizard_next]
        $bb add -text "Done"  -width 10 -command \
            [namespace code handle_wizard_finish]
        pack $bb -side top -anchor e -padx 13 -pady 8

        # Withdraw the window when you click X instead of deleting it
        wm protocol $wizard_dialog WM_DELETE_WINDOW [namespace code close_wizard]
        
#        pack $f
        $wizard_nb raise [$wizard_nb page 0]
        
        wm withdraw $f
        return $f
    }
    
    #########################################
    proc handle_nav_button { args } {
    
        set options {
            { "page.arg" "" "Highlighted page" }
            { "raise_sub.arg" "" "Level 2 nav to raise" }
            { "frame.arg" "" "Frame to change to white"}
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable nav_pm
        variable wizard_nb
        variable nav_two_highlight
        variable nav_one_highlight
        
        # Switch highlight on buttons
        
        # Raise level 2 nav
        if { ! [string equal "" $opts(raise_sub)] } {
            $nav_pm raise $opts(raise_sub)
        }
        
        # Unhighlight the old one
        if { ! [string equal "" $nav_two_highlight] } {
            $nav_two_highlight configure -bg #103C7B
        }
        
        if { ! [string equal "" $opts(frame)] } {
            # Highlight the new one
            set nav_two_highlight $opts(frame)
            $opts(frame) configure -bg white
        }
        
        # Raise the page in the wizard
        $wizard_nb raise $opts(page)
    }
    
    ##########################################
    proc make_nav_two { args } {
    
        set options {
            { "frame.arg" "" "Frame to make the nav 2 in" }
            { "common_pages.arg" "" "Other pages to go in" }
        }
        array set opts [::cmdline::getoptions args $options]
    
        variable wizard_nb
        variable page_names
        
        $opts(frame) configure -height 15 -bg #103C7B
        
        set btn 0
        foreach p $opts(common_pages) {
        
            set tf $opts(frame).f${btn}
            
            pack [frame $tf -bg #103C7B] -side left -anchor nw
            pack [Label $tf.l -text $page_names($p) \
                -foreground white -background #103C7B] \
                -side left -anchor nw -pady 1 -padx 1
            incr btn            
        }
    }
    
    #########################################
    proc make_nav_buttons { args } {
    
        set options {
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable nav_buttons
        variable nav_button_frame
        variable nav_pm
        variable page_names
        
        set f [frame $nav_button_frame.top -bg #8CB2CE]
        
        set nav_pm [PagesManager $nav_button_frame.nb]
        
        set btn 0
        foreach { button_title sub_pages } $nav_buttons {
        
            set temp $f.b{$btn}
            pack [Button $temp -text $button_title -height 2 -width 15 \
                -foreground white -background #8CB2CE -activebackground #8CB2CE \
                -activeforeground white -relief ridge -borderwidth 1] \
                -side left -anchor nw
            $nav_pm add $btn
            
            set sub [$nav_pm getframe $btn]
            $sub configure -bg #103C7B
            
            set sub_btn 0
            set first_frame ""
            foreach sub_page $sub_pages {
            
                # The first sub-button has the page associated with the
                # level one button
                if { 0 == $sub_btn } {
                    $temp configure -command [namespace code [list \
                        handle_nav_button -page $sub_page -raise_sub $btn]]
                }
                
                if { [string equal "" $page_names($sub_page)] } {
                
                } else {
                    set sub_f $sub.f${sub_btn}
                    pack [frame $sub_f -bg #103C7B] \
                        -side left -anchor nw -pady 3 -padx 3
                    if { 0 == $sub_btn } { set first_frame $sub_f } 
                    pack [Label $sub_f.b -text $page_names($sub_page) \
                        -foreground white -background #103C7B] \
                        -pady 1 -padx 1
                    incr sub_btn
                    bind $sub_f.b <1> [namespace code [list \
                        handle_nav_button -page $sub_page -frame $sub_f]]
                }
            }
            incr btn
        }
        
        $nav_pm compute_size
        pack $f -side top -anchor nw -fill x -expand true
        pack $nav_pm -side top -anchor nw -fill x -expand true
        $nav_pm raise 0

    }
    
    ###########################################
    # Withdraw the wizard dialog and show the main window
    proc close_wizard { args } {
        variable wizard_dialog
        grab release $wizard_dialog
        wm withdraw $wizard_dialog
        raise .
        focus -force .
    }
    
    ###########################################
    proc show_wizard { args } {
    
        set options {
            { "page.arg" "" "Page to show"}
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable wizard_dialog
        variable wizard_nb
        
        # Optionally raise a certain page
        if { ! [string equal "" $opts(page)] } {
            $wizard_nb raise $opts(page)
        }
        
        # Enable or disable any buttons appropriately
        update_nav_buttons_state -panel [$wizard_nb raise]

        # Draw it if it's withdrawn
        switch -exact -- [wm state $wizard_dialog] {
            "normal" { }
            "withdrawn" -
            "iconic" {
            
                # We're going to position the wizard over where the mainframe
                # was. Raise the wizard dialog so we can get its geometry
                # info, then get the geometry info of the mainframe
                wm deiconify $wizard_dialog
                tkwait visibility $wizard_dialog
                raise $wizard_dialog
                focus -force $wizard_dialog 
                grab $wizard_dialog

            }
            default {
                post_message -type warning "Value in show_wizard is\
                    [wm state $wizard_dialog]"
            }
        }
    }
    
    ############################################
    proc handle_wizard_next { args } {
    
        set options {
        }
        array set opts [::cmdline::getoptions args $options]

        variable wizard_nb
        
        # The page we're on that gets validated
        set current_page [$wizard_nb raise]
        
        set error_messages [list]
        
        # Validate the page before continuing
        if { [catch { wizard_validate_page -page $current_page } is_valid] } {
        
            # If there was actually an error running the validation, that's bad.
            tk_messageBox -icon error -type ok -default ok \
                -title "Error" -parent [focus] -message \
                "There was an unexpected error validating data on the\
                $current_page page:\n$is_valid"
            return
            
        } elseif { ! $is_valid } {
            # The page is not valid, so don't continue.
            return
        }
        
        switch -exact -- $current_page {
            "data_ports" {
            
                # The data was valid, and it has been forward annotated
                # We can continue
                clocking_config::prep_for_raise
                $wizard_nb raise "clocking_conf"
            }
            "clocking_conf" {
            
                # The data was valid and it has been forward annotated.
                # We can continue
                clocks_info::prep_src_for_raise
#                clocks_info::set_src_tree_instructions
                $wizard_nb raise "src_clock"
            }
            "src_clock" {
            
                # The data was valid and it has been forward annotated.
                # We can continue
                clocks_info::prep_dest_for_raise
#                clocks_info::set_dest_tree_instructions
                $wizard_nb raise "dest_clock"
            }
            "dest_clock" {
            
#                clock_relationship::enable_disable_advanced_false_paths
#                clock_relationship::set_advanced_transfer_edges
                clock_relationship::prep_for_raise
                $wizard_nb raise "clock_relationship"
                # If the src or dest clocks don't exist in the comboboxes,
                # the following proc displays a warning dialog telling them that.
                # That's why it has to be called after the raise.
                clock_relationship::fill_src_and_dest_clock_comboboxes
                
            }
            "clock_relationship" {
                board_info::prep_for_raise
                $wizard_nb raise "board"
            }
            "board" {
                requirements_info::prep_for_raise
                $wizard_nb raise "requirements"
#                requirements_info::check_io_timing_method
            }
            "requirements" {
                # You can't click Next when you're on the
                # requirements tab. It's disabled. Have to click Finish
            }
            default {
                return -code error "Unknown page name in wizard_back_next:\
                    $current_page"
            }
        }
        
        # Use wizard_nb raise here, because we update the buttons
        # based on the page we just switched to.
        update_nav_buttons_state -panel [$wizard_nb raise]
    }
       
    ##########################################
    proc handle_wizard_back { args } {
        
        variable wizard_nb
        
        switch -exact -- [$wizard_nb raise] {
            "data_ports" {
                # Nowhere to go
            }
            "clocking_conf" {
                data_info::copy_current_data_info_to_old
                $wizard_nb raise "data_ports"
            }
            "src_clock" {
                # Save the current state of the I/O tab variables before
                # raising it, so we can figure out whether things change
                clocking_config::copy_current_clocking_config_to_old
                $wizard_nb raise "clocking_conf"
            }
            "dest_clock" {
                clocks_info::set_src_tree_instructions
                $wizard_nb raise "src_clock"
            }
            "clock_relationship" {
                clocks_info::set_dest_tree_instructions
                $wizard_nb raise "dest_clock"
            }
            "board" {
                $wizard_nb raise "clock_relationship"
            }
            "requirements" {
                $wizard_nb raise "board"
            }
            default {
                return -code error "Unknown page name in wizard_back_next:\
                    [$wizard_nb raise]"
            }
        }
        update_nav_buttons_state -panel [$wizard_nb raise]
    }
    
    #######################################
    # Don't save any of the changes up to this point
    proc handle_cancel { args } {
    
        set options {
        }
        array set opts [::cmdline::getoptions args $options]
        
        set choice [tk_messageBox -icon warning -type yesno -default no \
            -title "Cancel warning" -parent [focus] -message \
            "Do you want to discard the information you\
            entered or changed for this interface?" 
        switch -exact -- $choice {
            "yes" {
                close_wizard
            }
            "no" {
                # do nothing
            }
            default {
                # should never get here
                return -code error "Invalid value for choice: $choice"
            }
        }
    }
    
    ######################################
    # If you click Finish, save the information
    # You want to save information on all the pages up to and
    # including the one you're on.
    # Use a switch to decide which information gets saved from
    # which page, and when page x data is saved, reset the page
    # name to page x-1, and go through the switch again,
    # while it's not done. It's done after saving the data ports page.
    proc handle_wizard_finish { args } {
    
        set options {
        }
        array set opts [::cmdline::getoptions args $options]

        variable wizard_nb
        
        set done 0
        set save_page [$wizard_nb raise]
        
        # Have to validate the page before the save loop.
        if { [catch { wizard_validate_page -page $save_page } is_valid] } {
        
            # If there was actually an error running the validation, that's bad.
            tk_messageBox -icon error -type ok -default ok \
                -title "Error" -parent [focus] -message \
                "There was an unexpected error validating data on the\
                $save_page page:\n$is_valid"
            return
            
        } elseif { ! $is_valid } {
            # The page is not valid, so don't continue.
            return
        }
        
        # The page validated OK, so save the data for this page and
        # all earlier pages
        while { ! $done } {
            log::log_message "saving data for $save_page"
            switch -exact -- $save_page {
                "data_ports" {
                    # Save the data port information back into the tree
                    interfaces::save_interface_info -data \
                        [data_info::get_shared_data -keys \
                            [list "data_port_names" "direction" \
                            "data_rate" "data_register_names" ] \
                        ]
                    set done 1
                }
                "clocking_conf" {
                    interfaces::save_interface_info -data \
                        [clocking_config::get_shared_data -keys \
                            [list "clock_port_name" "clock_configuration"] \
                        ]
                    set save_page "data_ports"
                }
                "src_clock" -
                "dest_clock" {
                    # Get the clock tree names out of the clock trees
                    # and into the shared_data variable
                    clocks_info::save_clock_tree_names
                    interfaces::save_interface_info -data \
                        [clocks_info::get_shared_data -keys \
                            [list "clock_tree_names"] \
                        ]
                    project_info::save_clock_trees_data
                    set save_page "clocking_conf"
                }
                "clock_relationship" {
                    interfaces::save_interface_info -data \
                        [clock_relationship::get_shared_data -keys \
                            [list "src_clock_name" "dest_clock_name" \
                            "transfer_edge" "degree_shift" \
                            "extra_setup_cuts" "extra_hold_cuts" \
                            "advanced_false_paths" ] \
                        ]
                    set save_page "dest_clock"
                }
                "board" {
                    interfaces::save_interface_info -data \
                        [board_info::get_shared_data -keys \
                            [list "constraint_target" \
                                "data_trace_delay" "src_clock_trace_delay" \
                                "dest_clock_trace_delay" "trace_propagation_rate"] \
                        ]
                    set save_page "clock_relationship"
                }
                "requirements" {
#"board_timing_method" "max_clock_trace_delay" \
#                            "min_clock_trace_delay" "max_data_trace_delay" \
#                            "min_data_trace_delay" "clock_trace" \
#                            "clock_trace_tolerance" "data_trace" \
#                            "data_trace_tolerance"
                    interfaces::save_interface_info -data \
                        [requirements_info::get_shared_data -keys \
                            [list "io_timing_method" \
                            "adjust_cycles" "src_shift_cycles" "dest_shift_cycles" \
                            "src_transfer_cycles" \
                            "dest_transfer_cycles" "max_skew" "min_valid" \
                            "setup" "hold" "tco_max" "tco_min" \
                            ] \
                        ]
                    set save_page "board"
                }
                default {
                    return -code error "Unknown page name in handle_wizard_finish:\
                        $save_page"
                }
            }
        }
        
        # Validate all the pages to see
        log::log_message "pages to see is [update_pages_to_see -get_pages]"        
        # If we have to see data_ports, validate it.
        if { [update_pages_to_see -query "data_ports"] } {
            if { [catch {validate_data_ports_page -display_errors_in interfaces_tree} is_valid] } {
                # There was an error during validation
            } elseif { $is_valid } {
                # The page validated OK, so it doesn't have to be visited
                update_pages_to_see -seen "data_ports"
            }
            # If it wasn't valid, that will have been reported by the validate_
            # procedure, and written out to to the interfaces tree
        }
        if { [update_pages_to_see -query "clocking_conf"] } {
            if { [catch {validate_clocking_conf_page -display_errors_in interfaces_tree \
                -pre_validation return_on_invalid } is_valid] } {
                # There was an error during validation
            } elseif { $is_valid } {
                # The page validated OK, so it doesn't have to be visited
                update_pages_to_see -seen "clocking_conf"
            }
        }
        if { [update_pages_to_see -query "src_clock"] } {
            if { [catch {validate_src_clock_tree_page -display_errors_in interfaces_tree \
                -pre_validation return_on_invalid } is_valid] } {
                # There was an error during validation
            } elseif { $is_valid } {
                # The page validated OK, so it doesn't have to be visited
                update_pages_to_see -seen "src_clock"
            }
        }
        if { [update_pages_to_see -query "dest_clock"] } {
            if { [catch {validate_dest_clock_tree_page -display_errors_in interfaces_tree \
                -pre_validation return_on_invalid } is_valid] } {
                # There was an error during validation
            } elseif { $is_valid } {
                # The page validated OK, so it doesn't have to be visited
                update_pages_to_see -seen "dest_clock"
            }
        }
        if { [update_pages_to_see -query "clock_relationship"] } {
            if { [catch {validate_clock_relationship_page -display_errors_in interfaces_tree \
                -pre_validation return_on_invalid } is_valid] } {
                # There was an error during validation
            } elseif { $is_valid } {
                # The page validated OK, so it doesn't have to be visited
                update_pages_to_see -seen "clock_relationship"
            }
        }
        if { [update_pages_to_see -query "board"] } {
            if { [catch {validate_board_info_page -display_errors_in interfaces_tree \
                -pre_validation return_on_invalid } is_valid] } {
                # There was an error during validation
            } elseif { $is_valid } {
                # The page validated OK, so it doesn't have to be visited
                update_pages_to_see -seen "board"
            }
        }
#        if { [update_pages_to_see -query "target"] } {
#            if { [catch {validate_target_page -display_errors_in interfaces_tree \
#                -pre_validation return_on_invalid } is_valid] } {
#                # There was an error during validation
#            } elseif { $is_valid } {
#                # The page validated OK, so it doesn't have to be visited
#                update_pages_to_see -seen "target"
#            }
#        }
        if { [update_pages_to_see -query "requirements"] } {
            if { [catch {validate_requirements_page -display_errors_in interfaces_tree \
                -pre_validation return_on_invalid } is_valid] } {
                # There was an error during validation
            } elseif { $is_valid } {
                # The page validated OK, so it doesn't have to be visited
                update_pages_to_see -seen "requirements"
            }
        }
        log::log_message "after validation, pages to see is [update_pages_to_see -get_pages]"        
        # Save the pages to see into the interface information
        interfaces::save_interface_info -data [list \
            "pages_to_see" [update_pages_to_see -get_pages]]
        interfaces::set_interface_image -num_pages_to_see [llength [update_pages_to_see -get_pages]]
        
        # We're done saving now, so close the dialog
        close_wizard
    }
    
    
    ################################################
    proc wizard_validate_page { args } {
    
        set options {
            { "page.arg" "" "Name of page to validate" }
        }
        array set opts [::cmdline::getoptions args $options]
        
        set is_valid 0
        set has_error 0
        set res ""
        
        switch -exact -- $opts(page) {
            "data_ports" {
            
                if { [catch {validate_data_ports_page \
                    -display_errors_in messagebox } res] } {
                    set has_error 1
                } else {
                    set is_valid $res
                }
            }
            "clocking_conf" {
            
                if { [catch {validate_clocking_conf_page -pre_validation skip \
                    -display_errors_in messagebox} res] } {
                    set has_error 1
                } else {
                    set is_valid $res
                }
            }
            "src_clock" {
                if { [catch { validate_src_clock_tree_page -pre_validation skip \
                    -display_errors_in messagebox} res ] } {
                    set has_error 1
                } else {
                    set is_valid $res
                }
            }
            "dest_clock" {
            
                if { [catch { validate_dest_clock_tree_page -pre_validation skip \
                    -display_errors_in messagebox} res ] } {
                    set has_error 1
                } else {
                    set is_valid $res
                }
            }
            "clock_relationship" {
            
                if { [catch { validate_clock_relationship_page -pre_validation skip \
                    -display_errors_in messagebox} res ] } {
                    set has_error 1
                } else {
                    set is_valid $res
                }
            }
            "board" {

                if { [catch { validate_board_info_page -pre_validation skip \
                    -display_errors_in messagebox} res ] } {
                    set has_error 1
                } else {
                    set is_valid $res
                }
            }
            "target" {
            
                if { [catch { validate_target_page -pre_validation skip \
                    -display_errors_in messagebox} res ] } {
                    set has_error 1
                } else {
                    set is_valid $res
                }
            }
            "requirements" {

                if { [catch { validate_requirements_page -pre_validation skip \
                    -display_errors_in messagebox} res ] } {
                    set has_error 1
                } else {
                    set is_valid $res
                }
            }
            default {
            
            }
        }
        
        # Return any errors
        if { $has_error } { return -code error $res }
        
        # Handle seen pages
        if { $is_valid } { update_pages_to_see -seen $opts(page) }
        
        return $is_valid
    }
    
    ##############################################3
    # validate data ports
    # Check changes
    proc validate_data_ports_page { args } {
    
        set options {
            { "display_errors_in.arg" "" "interfaces tree or message box" }
        }
        array set opts [::cmdline::getoptions args $options]

        set error_messages [list]
        array set temp [list]
        
        if { [catch {data_info::validate_data_ports \
            -error_messages_var error_messages \
            -data_var temp } is_valid] } {
            
            # If there was actually an error running the validation, that's bad.
            return -code error $is_valid
                        
        } elseif { ! $is_valid } {
        
            # Some of the data was not valid.
            # Inform the user and return
            switch -exact -- $opts(display_errors_in) {
                "interfaces_tree" {
                    post_message -type warning "Updates required"
                    post_message -type warning $error_messages
                }
                "messagebox" {
                    tk_messageBox -icon error -type ok -default ok \
                        -title "Data port validation" -parent [focus] -message \
                        [util::make_message_for_dialog -messages \
                        [list "Correct the following errors to continue" $error_messages]]
                }
                default {
                    return -code error "Unknown value for -display_errors_in\
                        in validate_data_ports_page: $opts(display_errors_in)"
                }
            }
            return 0

        } else {
        
            # If the direction changed, I have to update it in
            # the clocking_config namespace. it's used to label
            # the devices and to control when clock entry boxes
            # are enabled.
            # Also update it in the requirements_info namespace.
            # It's used to control when things like tsu/th and tco
            # entry boxes get enabled.
            # In clocks_info it's used to determine rise/fall order
            if { [data_info::data_info_changed -direction] } {
            
                clocking_config::init_clocking_config \
                    -update_direction $temp(direction)
                clocks_info::init_clocks_info -update_direction \
                    $temp(direction)
                clock_diagram::init_diagram_info \
                    -update_direction $temp(direction)
                board_info::init_board_info -update_direction \
                    $temp(direction)
                requirements_info::init_timing_req -update_direction \
                    $temp(direction)
                update_pages_to_see -add [list "clocking_conf" \
                    "src_clock" "dest_clock"]
            }
            
            # If the data rate changed -
            # The clock_diagram namespace draws arrows for DDR
            # and SDR.
            # clock_relationship gets it because SDR alignment
            # doesn't get all the +/-90 etc choices that DDR does
            if { [data_info::data_info_changed -data_rate] } {
                
                clock_diagram::init_diagram_info \
                    -data_rate $temp(data_rate)
                clock_relationship::init_relationship_info \
                    -data_rate $temp(data_rate)
#                            clock_relationship::configure_alignment_frame \
#                                -data_rate $temp(data_rate)
                requirements_info::init_timing_req \
                    -data_rate $temp(data_rate)
                update_pages_to_see -add [list "src_clock" \
                    "dest_clock" "clock_relationship" \
                    "requirements" ]
            }

            # If the data port names change, pass those into clocking conf
            # The data port names are used to verify that any clock port
            # in a source sync interface is not part of the data port list.
            if { [data_info::data_info_changed -data_port_names] } {
            
                clocking_config::init_clocking_config -data_port_names \
                    $temp(data_port_names)
            }
            
            # If the data register names change,
            # there might be a new clock path (clocks_info)
            if { [data_info::data_info_changed -data_register_names] } {
                
                clocks_info::init_clocks_info \
                    -data_register_names $temp(data_register_names)
#                clocks_info::init_clock_path_graphs_2 -data_graph
#                                -register_id $temp(register_id)
                clock_diagram::init_diagram_info \
                    -data_register_names $temp(data_register_names)
#                                -register_id $temp(register_id)
#                            clock_relationship::init_relationship_info \
#                                -register_id $temp(register_id)
                update_pages_to_see -add [list "src_clock" \
                    "dest_clock" "clock_relationship"]
            }

        }
        return $is_valid
    }
    
    ################################################
    proc validate_clocking_conf_page { args } {
    
        set options {
            { "display_errors_in.arg" "" "interfaces tree or message box" }
            { "pre_validation.arg" "" "What to do for prevalidation" }
        }
        array set opts [::cmdline::getoptions args $options]

        set error_messages [list]
        array set temp [list]
    
        if { [catch {clocking_config::validate_clock_port \
            -pre_validation $opts(pre_validation) \
            -error_messages_var error_messages \
            -data_var temp} is_valid] } {
            
            # If there was actually an error running the validation, that's bad.
            return -code error $is_valid
            
        } elseif { ! $is_valid } {
        
            # Some of the data is not valid
            # Inform the user and return
            switch -exact -- $opts(display_errors_in) {
                "interfaces_tree" {
                    post_message -type warning "Updates required"
                    post_message -type warning $error_messages
                }
                "messagebox" {
                    tk_messageBox -icon error -type ok -default ok \
                        -title "Clock port validation" -parent [focus] -message \
                        [util::make_message_for_dialog -messages \
                        [list "Correct the following errors to continue" $error_messages]]
                }
                default {
                    return -code error "Unknown value for -display_errors_in\
                        in validate_clocking_conf_page: $opts(display_errors_in)"
                }
            }
            return 0
            
        } else {

            # validate_clock_port returns clock_port_name
            # and clock_configuration

            # If the clock port name changed, we definitely have to
            # update clocks_info with the new port ID
            if { [clocking_config::clocking_config_changed -clock_port_name] } {
            
                clocks_info::init_clocks_info -update_clock_port_name \
                    -clock_port_name $temp(clock_port_name)
#                clocks_info::init_clock_path_graphs_2 -clock_graph
                update_pages_to_see -add [list "src_clock" \
                    "dest_clock" ]
            }
            
            # If the clock configuration changed, that has to be
            # passed into clocks_info so it puts the right set of
            # clocks into the src and dest trees
            # Also, configure the alignment frame to be enabled
            # only when it's a source sync interface.
            if { [clocking_config::clocking_config_changed -clock_configuration] } {
            
                clocks_info::init_clocks_info \
                    -clock_configuration  $temp(clock_configuration)
#                            clock_relationship::configure_alignment_frame \
#                                -is_source_sync \
#                                [regexp {source_sync} $temp(clock_configuration)]
                clock_relationship::init_relationship_info \
                    -clock_configuration $temp(clock_configuration)
                board_info::init_board_info -clock_configuration \
                    $temp(clock_configuration)
                requirements_info::init_timing_req \
                    -clock_configuration $temp(clock_configuration)
                update_pages_to_see -add [list "src_clock" \
                    "dest_clock" "clock_relationship" ]
            }

            # If the root for either graph changed, the graphs
            # must be reinitialized. For the data clock graph,
            # the root is the source register ID for output,
            # and the destination register ID for input.
            # For the output clock graph, the root is usually
            # blank (for virtual clocks) except for two
            # combinations for source sync.
            if { [clocks_info::clocks_info_changed -root_nodes] } {

                log::log_message "root node info changed, initing clock path graphs"
                clocks_info::init_clock_path_graphs
            }
            # No need to refill if clocks have not changed.
            if { [clocks_info::clocks_info_changed -src] } {
                log::log_message "\nFilling source clock tree"
                log::log_message "------------------------"
                clocks_info::fill_src_tree
                clocks_info::save_current_clocks_info
                update_pages_to_see -add [list "src_clock" ]
            }

        }
        return $is_valid
    }
    
    ##########################################################3
    #
    proc validate_src_clock_tree_page { args } {
    
        set options {
            { "display_errors_in.arg" "" "interfaces tree or message box" }
            { "pre_validation.arg" "" "How to deal with prevalidation" }
        }
        array set opts [::cmdline::getoptions args $options]

        set error_messages [list]
        array set temp [list]

        if { [catch { clocks_info::validate_src_tree_clocks \
            -pre_validation $opts(pre_validation) \
            -error_messages_var error_messages \
            -data_var temp} is_valid ] } {
            
            # If there was actually an error running the validation, that's bad.
            return -code error "Error running validate_src_tree_clocks: $is_valid"
            
        } elseif { ! $is_valid } {
        
            # Some of the data was not valid.
            # Inform the user and return
            switch -exact -- $opts(display_errors_in) {
                "interfaces_tree" {
                    post_message -type warning "Updates required"
                    post_message -type warning $error_messages
                }
                "messagebox" {
                    tk_messageBox -icon error -type ok -default ok \
                        -title "Source clock validation" -parent [focus] -message \
                        [util::make_message_for_dialog -messages \
                        [list "Correct the following errors to continue" $error_messages]]
                }
                default {
                    return -code error "Unknown value for -display_errors_in\
                        in validate_src_clock_tree_page: $opts(display_errors_in)"
                }
            }
            return 0
                                
        } else {
        
            # If it's validated, pass on the source clock tree names
            clock_relationship::init_relationship_info -src_clocks \
                $temp(src_clocks)
                
            
            if { [clocks_info::clocks_info_changed -dest] } {
                # No need to refill if clocks have not changed
                log::log_message "\nFilling dest clock tree"
                log::log_message "------------------------"
                clocks_info::fill_dest_tree
                clocks_info::save_current_clocks_info
                update_pages_to_see -add [list "dest_clock" ]
            }
        }
        return $is_valid
    }
    
    ####################################################
    proc validate_dest_clock_tree_page { args } {
    
        set options {
            { "display_errors_in.arg" "" "interfaces tree or message box" }
            { "pre_validation.arg" "" "How to deal with prevalidation" }
        }
        array set opts [::cmdline::getoptions args $options]

        set error_messages [list]
        array set temp [list]

        if { [catch { clocks_info::validate_dest_tree_clocks \
            -pre_validation $opts(pre_validation) \
            -error_messages_var error_messages \
            -data_var temp} is_valid ] } {
            
            # If there was actually an error running the validation, that's bad.
            return -code error $is_valid
            
        } elseif { ! $is_valid } {
        
            # Some of the data was not valid.
            # Inform the user and return
            switch -exact -- $opts(display_errors_in) {
                "interfaces_tree" {
                    post_message -type warning "Updates required"
                    post_message -type warning $error_messages
                }
                "messagebox" {
                    tk_messageBox -icon error -type ok -default ok \
                        -title "Destination clock validation" -parent [focus] -message \
                        [util::make_message_for_dialog -messages \
                        [list "Correct the following errors to continue" $error_messages]]
                }
                default {
                    return -code error "Unknown value for -display_errors_in\
                        in validate_dest_clock_tree_page: $opts(display_errors_in)"
                }
            }
            return 0
                                
        } else {

            # If it's validated, pass on the dest clock tree names
            clock_relationship::init_relationship_info -dest_clocks \
                $temp(dest_clocks)
                
        }
        return $is_valid
    }
    
    ##############################################
    proc validate_clock_relationship_page { args } {
    
        set options {
            { "display_errors_in.arg" "" "interfaces tree or message box" }
            { "pre_validation.arg" "" "What to do for prevalidation" }
        }
        array set opts [::cmdline::getoptions args $options]

        set error_messages [list]
        array set temp [list]

        if { [catch { clock_relationship::validate_relationship_info \
            -pre_validation $opts(pre_validation) \
            -error_messages_var error_messages \
            -data_var temp} is_valid ] } {
            
            # If there was actually an error running the validation, that's bad.
            return -code error $is_valid
                        
        } elseif { ! $is_valid } {
        
            # Some of the data was not valid.
            # Inform the user and return
            switch -exact -- $opts(display_errors_in) {
                "interfaces_tree" {
                    post_message -type warning "Updates required"
                    post_message -type warning $error_messages
                }
                "messagebox" {
                    tk_messageBox -icon error -type ok -default ok \
                        -title "Clock relationship validation" -parent [focus] -message \
                        [util::make_message_for_dialog -messages \
                        [list "Correct the following errors to continue" $error_messages]]
                }
                default {
                    return -code error "Unknown value for -display_errors_in\
                        in validate_clock_relationship_page: $opts(display_errors_in)"
                }
            }
            return 0
                                
        } else {
        
            # what can change in clock_relationship?
            # source clock name, dest clock name, transfer edge,
            # degree shift
            # Dependencies: clock_configuration value,
            # handled in clocking_conf processing
            # Source and dest clock comboboxes, handled in
            # dest_clock
            # data_rate, handled in ... 
            
            # Pass along the shorter clock period
            requirements_info::init_timing_req -shorter $temp(shorter)
            
            # If anything changes, stuff has to be updated.
            # Transfer edge, source or dest clock name, or alignment
            if { [clock_relationship::relationship_info_changed -degree_shift] } {
                clock_diagram::init_diagram_info -degree_shift $temp(degree_shift)
            }
            if { [clock_relationship::relationship_info_changed -transfer_edge] } {
                clock_diagram::init_diagram_info -transfer_edge $temp(transfer_edge) \
            }
            if { [clock_relationship::relationship_info_changed -advanced_false_paths] } {
                clock_diagram::init_diagram_info \
                    -advanced_false_paths $temp(advanced_false_paths) \
                    -extra_setup_cuts $temp(extra_setup_cuts) \
                    -extra_hold_cuts $temp(extra_hold_cuts)
            }
            if { [clock_relationship::relationship_info_changed -clock_names] } {
                clock_diagram::init_diagram_info -src_clock_name $temp(src_clock_name) \
                    -dest_clock_name $temp(dest_clock_name)
            }

        }
        return $is_valid
    }
    
    ###############################################
    # Validate board info page
    proc validate_board_info_page { args } {
    
        set options {
            { "display_errors_in.arg" "" "interfaces tree or message box" }
            { "pre_validation.arg" "" "How to handle prevalidation" }
        }
        array set opts [::cmdline::getoptions args $options]

        set error_messages [list]
        array set temp [list]

        if { [catch { board_info::validate_board_info \
            -pre_validation $opts(pre_validation) \
            -error_messages_var error_messages \
            -data_var temp} is_valid ] } {
            
            # If there was actually an error running the validation, that's bad.
            return -code error $is_valid
                        
        } elseif { ! $is_valid } {
        
            # Some of the data was not valid.
            # Inform the user and return
            switch -exact -- $opts(display_errors_in) {
                "interfaces_tree" {
                    post_message -type warning "Updates required"
                    post_message -type warning $error_messages
                }
                "messagebox" {
                    tk_messageBox -icon error -type ok -default ok \
                        -title "Board info validation" -parent [focus] -message \
                        [util::make_message_for_dialog -messages \
                        [list "Correct the following errors to continue" $error_messages]]
                }
                default {
                    return -code error "Unknown value for -display_errors_in\
                        in validate_board_info_page: $opts(display_errors_in)"
                }
            }
            return 0
                                
        } else {
            # If the target changed, we have to go to requirements
            if { [board_info::board_info_changed -constraint_target] } {
                requirements_info::init_timing_req \
                    -constraint_target $temp(constraint_target)
                update_pages_to_see -add "requirements"
            }
            
            # If the board numbers changed, we have to go to clock_diagram
            if { [board_info::board_info_changed -trace_delays] } {
                
            }
        }
        return $is_valid
    }
    
    ###############################################
    # Validate requirements page
    proc validate_requirements_page { args } {
    
        set options {
            { "display_errors_in.arg" "" "interfaces tree or message box" }
            { "pre_validation.arg" "" "How to deal with prevalidation" }
        }
        array set opts [::cmdline::getoptions args $options]

        set error_messages [list]
        array set temp [list]

        if { [catch { requirements_info::validate_requirements \
            -pre_validation $opts(pre_validation) \
            -error_messages_var error_messages } is_valid] } {
            
            # If there was actually an error running the validation, that's bad.
            return -code error $is_valid
            
        } elseif { ! $is_valid } {
        
            # Some of the information didn't validate.
            switch -exact -- $opts(display_errors_in) {
                "interfaces_tree" {
                    post_message -type warning "Updates required"
                    post_message -type warning $error_messages
                }
                "messagebox" {
                    tk_messageBox -icon error -type ok -default ok \
                        -title "Timing requirements validation" -parent [focus] -message \
                        [util::make_message_for_dialog -messages \
                        [list "Correct the following errors to continue" $error_messages]]
                }
                default {
                    return -code error "Unknown value for -display_errors_in\
                        in validate_requirements_page: $opts(display_errors_in)"
                }
            }
            return 0
        } else {
            # Nothing to forward annotate - things just get saved later.
        }
        return $is_valid
    }
    
    #######################################
    proc update_nav_buttons_state { args } {

        set options {
            { "panel.arg" "" "Name of the currently raised panel" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable wizard_dialog
        variable wizard_nb
        variable dialog_title
        variable bb
        
        # Handle enabling and disabling the back and next buttons
        # Do the back button
        switch -exact -- $opts(panel) {
            "data_ports" { $bb itemconfigure 1 -state disabled }
            default { $bb itemconfigure 1 -state normal }
        }
        
        # Do the next button
        switch -exact -- $opts(panel) {
            "requirements" { $bb itemconfigure 2 -state disabled }
            default { $bb itemconfigure 2 -state normal }
        }
        
        # Configure the title
        set wizard_pages [$wizard_nb pages]
        set num_wizard_pages [llength $wizard_pages]
        set page_index [lsearch $wizard_pages $opts(panel)]
        incr page_index
        wm title $wizard_dialog "$dialog_title \[page $page_index of $num_wizard_pages\]"
        
    }
    
    ############################################################
    proc update_pages_to_see { args } {
    
        set options {
            { "seen.arg" "" "List of pages seen" }
            { "add.arg" "" "List of pages to see" }
            { "get_pages" "Get the list of pages to see" }
            { "reset" "Clean out list of pages to see" }
            { "query.arg" "" "Test to see whether this page is in the list" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable pages_to_see
        variable wizard_nb
        
        set wizard_pages [$wizard_nb pages]
        
        # Provide a way to clear it out
        if { $opts(reset) } { set pages_to_see [list] }
        
        # Take off any pages before putting any on
        foreach seen $opts(seen) {
            # Error if the one you say you've seen doesn't exist in the pages manager
            if { -1 == [lsearch $wizard_pages $seen] } {
                return -code error "$seen is not a valid page name in update_pages_to_see"
            }
            set index [lsearch $pages_to_see $seen]
            if { -1 != $index } {
                set pages_to_see [lreplace $pages_to_see $index $index]
            }
        }

        # Put on any new pages
        foreach to_see $opts(add) {
            # Error if the one you say you've seen doesn't exist in the pages manager
            if { -1 == [lsearch $wizard_pages $to_see] } {
                return -code error "$to_see is not a valid page name in update_pages_to_see"
            }
            set index [lsearch $pages_to_see $to_see]
            if { -1 == $index } {
                lappend pages_to_see $to_see
            }
        }
    
#puts "pages_to_see is $pages_to_see"
        if { $opts(get_pages) } { return $pages_to_see }
        
        # Check whether a page is in the list
        if { ! [string equal "" $opts(query)] } {
            # Error if the one you say you've seen doesn't exist in the pages manager
            if { -1 == [lsearch $wizard_pages $opts(query)] } {
                return -code error "$opts(query) is not a valid page name in update_pages_to_see"
            }
            return [expr { -1 != [lsearch $pages_to_see $opts(query)] }]
        }
    }
}

################################################################################
namespace eval gui {

    variable nb
    variable quitting 0
    variable mainframe ""
    variable v_wm
    variable nav_buttonbox
    
    global script_options

    #################################################
    # Window manager variables
    array set v_wm [list \
        title   "I/O Timing Constrainer" \
        nb_width    "" \
        nb_height   "" \
        wm_width    "" \
        wm_height   "" \
    ]

    ##############################################################
    proc show_ki_dialog { args } {
    
        # Erase whatever is there and title the window
        text_dialog::update_dialog -erase -title "Known issues and improvements"
        
        # Fill the text window
        if { [catch { open [info script] } fh] } {
            post_message -type info $fh
        } else {
            while { 0 <= [gets $fh line] } {
                if { [regexp {^#[ #]?(.*?)$} $line -> no_comment] } {
                    text_dialog::update_dialog -append $no_comment
                    text_dialog::update_dialog -append "\n"
                } else {
                    break
                }
            }
            catch { close $fh }
        }
        
        text_dialog::update_dialog -show
    }
    
    ################################################################################
    # Resizes the pagesmanager when the top-level window changes size
    proc update_pm_size { mf } {
    
        variable nb
        variable v_wm
    
        # Clear out the configure binding on the mainframe to make sure
        # it doesn't fire while we're doing the resize
        bind $mf <Configure> { }
    
        # Get the geometry at the end of the resize
        set end_geom [wm geometry .]
        regexp {^(\d+)x(\d+)} $end_geom -> new_width new_height
        #util::puts_debug "Window resized, updating size to $end_geom"
    
        # Calculate height and width change
        set width_diff [expr { $new_width - $v_wm(width) }]
        set height_diff [expr { $new_height - $v_wm(height) }]
        #util::puts_debug " difference is $width_diff in width and $height_diff in height"
    
        # Calculate the new size for the pagesmanager and configure it
        set v_wm(nb_width) [expr { $v_wm(nb_width) + $width_diff }]
        set v_wm(nb_height) [expr { $v_wm(nb_height) + $height_diff }]
        $nb configure -width $v_wm(nb_width) -height $v_wm(nb_height)
    
        # Store the now-current width and height of the top-level window
        set v_wm(width) $new_width
        set v_wm(height) $new_height
        
        # Reenable the configure binding
        bind $mf <Configure> "[namespace code update_pm_size] $mf"
    }

    ################################################################################
    # Quit the script, and close the project if necessary
    proc ExitApp { args } {
    
        set options {
            { "dont_save_file" "Skip writing the file" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable mainframe
        variable quitting

        # If we hit cancel in the main GUI manager, don't save the file.
        if { ! $opts(dont_save_file) } {
        
            # Attempt to save the data file
            set new_file_name [format %X [clock seconds]]
            
            if { [catch { project_info::save_data_file -file_name $new_file_name} res] } {
                post_message -type error "There was an error saving your updates.\
                    They have not been saved."
                post_message -type error $res
                catch { file delete $new_file_name }
            } else {
                if { [catch { file rename -force $new_file_name [project_info::data_file_name] } res] } {
                    post_message -type error "Could not update the data file automatically.\
                        Rename $new_file_name to [project_info::data_file_name]."
                }
            }
        }
        
        if { [is_project_open] } {
            project_close
        }
        
        log::close_log
        
        destroy $mainframe
        set quitting 1
        exit
    }

    ####################################
    # about
    proc ShowAbout { args } {
    
        global script_version
        variable v_wm
        
        tk_messageBox -icon info -type ok -default ok \
            -title "About" -parent [focus] -message \
            "$v_wm(title)\nversion $script_version"
    }
    
    ############################################################################
    # Start the wizard
    proc start_wizard { args } {
    
        set options {
            { "page.arg" "" "Page to raise" }
        }
        array set opts [::cmdline::getoptions args $options]

        # Get the list of pages to see
        wizard::update_pages_to_see -reset
        array unset temp
        array set temp [interfaces::get_interface_info -keys \
            [list "pages_to_see"]]
        wizard::update_pages_to_see -add $temp(pages_to_see)
        
        # Load in the data
        data_info::init_data_info -data \
            [interfaces::get_interface_info -keys \
                [list "data_port_names" "direction" \
                "data_rate" "data_register_names" ] \
            ]
        clocking_config::init_clocking_config -data \
            [interfaces::get_interface_info -keys \
                [list "data_port_names" "clock_port_name" \
                "direction" "clock_configuration" ] \
            ]
        clocks_info::init_clocks_info -data \
            [interfaces::get_interface_info -keys \
                [list "direction" "data_register_names" \
                "clock_configuration" \
                "clock_port_name" \
                "clock_tree_names"] \
            ]
        # when we initialize the data, we have to build the graphs
        # for the clock paths, because those get used to build the
        # source and dest clock trees, and those get used during
        # validation of other pages.
#        clocks_info::init_clock_path_graphs_2 -data_graph -clock_graph
#        clocks_info::fill_src_tree -ignore_incomplete_data
#        clocks_info::fill_dest_tree -ignore_incomplete_data
        
        clock_relationship::init_relationship_info -data \
            [interfaces::get_interface_info -keys \
                [list "clock_configuration" \
                "src_clock_name" "dest_clock_name" \
                "transfer_edge" "degree_shift" \
                "data_rate" "extra_setup_cuts" \
                "extra_hold_cuts" "advanced_false_paths"] \
            ]
        clock_diagram::init_diagram_info -data \
            [interfaces::get_interface_info -keys \
                [list "data_register_names" \
                "src_clock_name" "dest_clock_name" \
                "direction" "transfer_edge" "data_rate" \
                "extra_setup_cuts" "extra_hold_cuts" \
                "alignment_method" "degree_shift" \
                "advanced_false_paths" ] \
            ]
        board_info::init_board_info -data \
            [interfaces::get_interface_info -keys \
                [list "constraint_target" "clock_configuration" \
                "direction" "data_trace_delay" \
                "src_clock_trace_delay" \
                "dest_clock_trace_delay" \
                "trace_propagation_rate"] \
            ]
#                "board_timing_method" "max_clock_trace_delay" \
#                "min_clock_trace_delay" "max_data_trace_delay" \
#                "min_data_trace_delay" "clock_trace" \
#                "clock_trace_tolerance" "data_trace" \
#                "data_trace_tolerance"
        requirements_info::init_timing_req -data \
            [interfaces::get_interface_info -keys \
                [list "clock_configuration" "direction" \
                "data_rate" "io_timing_method" \
                "constraint_target" "adjust_cycles" \
                "src_shift_cycles" "dest_shift_cycles" \
                "src_transfer_cycles" \
                "dest_transfer_cycles" \
                "max_skew" "min_valid" \
                "setup" "hold" "tco_max" "tco_min" \
                ] \
            ]
            
        if { [string equal "" $opts(page)] } {
            return -code error "Specify a page to raise for start_wizard"
        } else {
        
            set is_valid 1
            set error_messages [list]
            
            # Do prevalidation to ensure we can raise the page.
            switch -exact -- $opts(page) {
                "data_ports" {
                    # We can always raise data_ports
                    # There's no prevalidation to do for it.
                }
                "clocking_conf" {
                    # Validate stuff before we raise clocking conf
                    if { [catch { clocking_config::validate_clock_port \
                        -pre_validation run_and_return \
                        -error_messages_var error_messages } res ] } {
                        # BAD - an error performing the validation
                        return -code error "Unknown error performing pre-\
                            validation for clocking_conf in start_wizard:\
                            \n$res"
                    } else {
                        set is_valid $res
                    }
                }
                "src_clock" {
                    # Validate stuff before we raise the source clock tree
                    if { [catch { clocks_info::validate_src_tree_clocks \
                        -pre_validation run_and_return \
                        -error_messages_var error_messages } res ] } {
                        # BAD - an error performing the validation
                        return -code error "Unknown error performing pre-\
                            validation for src_clocks in start_wizard:\
                            \n$res"
                    } else {
                        set is_valid $res
                    }
                }
                "dest_clock" {
                    # Validate stuff before we raise the dest clock tree
                    if { [catch { clocks_info::validate_dest_tree_clocks \
                        -pre_validation run_and_return \
                        -error_messages_var error_messages } res ] } {
                        # BAD - an error performing the validation
                        return -code error "Unknown error performing pre-\
                            validation for dest_clocks in start_wizard:\
                            \n$res"
                    } else {
                        set is_valid $res
                    }
                    
                }
            }
            
            if { $is_valid } {
                wizard::show_wizard -page $opts(page)
            } else {
                # Show the error messages in a messagebox
                return
            }
        }
#        wm withdraw .

    }
    
    ################################################################################
    # Go to the appropriate page when the user clicks next
    proc handle_next { args } {
    
        set options {
        }
        array set opts [::cmdline::getoptions args $options]

        variable mainframe
        variable nb
        variable wizard_dialog
        
        global script_options
 
        switch -exact -- [$nb raise] {
            "project" {
                if { $script_options(browse) } {
                    # Raise the tab outside the if clauses
                } elseif { ! [timing_netlist_exist] } {
                    tk_messageBox -icon error -type ok -default ok \
                        -title "Timing netlist does not exist" -parent [focus] \
                        -message "You must create/update the timing netlist first"
                    return
                } else {
#                        data_info::copy_current_data_info_to_old
                    if { [project_info::project_info_changed] } {
                        # TODO - if project info changed,
                        # reload file? clean out tree?
                        #data_info::init_data_info
                    }
                }
                $nb raise "interfaces"

            }
            "interfaces" {
            
                if { $script_options(browse) } {
                    # Raise the tab outside the if clauses
                } elseif { [catch {interfaces::ensure_selected} res] } {
                    tk_messageBox -icon error -type ok -default ok \
                        -title "Error validating interfaces" -parent [focus] \
                        -message $res 
                    return
                } else {
                    start_wizard -page "data_ports"
                }
            }
            "sdc" {
                # Can't go next from here
            }
            default {
                return -code error "Unknown notebook page name in\
                    handle_back_next: [$nb raise]"
            }
        }
        
        update_nav_buttons_state -based_on_page
    }

    ################################################################################
    # Go to the appropriate page when the user clicks back
    proc handle_back { args } {
    
        set options {
        }
        array set opts [::cmdline::getoptions args $options]

        variable nb

        switch -exact -- [$nb raise] {
            "project" {
                # Can't go back here
            }
            "interfaces" {
                $nb raise "project"
            }
            "sdc" {
                $nb raise "interfaces"
            }
            default {
                return -code error "Unknown notebook page name in\
                    handle_back: [$nb raise]"
            }
        }

        update_nav_buttons_state -based_on_page
    }

    ##########################################
    # Programatically invoke a nav button
    proc click_nav_button { btn } {
    puts "click_nav_button $btn"
        variable nav_buttonbox
        
        switch -exact -- $btn {
            "cancel" { $nav_buttonbox invoke 0 }
            "back" { $nav_buttonbox invoke 1 }
            "next" { $nav_buttonbox invoke 2 }
            "finish" { $nav_buttonbox invoke 3 }
            default {
                return -code error "Invalid button name for\
                    click_nav_button: $btn"
            }
        }
    }
    
    #######################################
    proc update_nav_buttons_state { args } {
    
        set options {
            { "enable.arg" "" "Name of button to enable" }
            { "disable.arg" "" "Name of button to disable" }
            { "based_on_page" "Update the buttons based on what page we're on" }
        }
        array set opts [::cmdline::getoptions args $options]

        variable nb
        variable nav_buttonbox
        
        if { ! [string equal "" $opts(enable)] } {
            # We can pass in a specific button "name" to enable
            # If so, return right away
            switch -exact -- $opts(enable) {
                "cancel" { $nav_buttonbox itemconfigure 0 -state normal }
                "back" { $nav_buttonbox itemconfigure 1 -state normal }
                "next" { $nav_buttonbox itemconfigure 2 -state normal }
                "finish" { $nav_buttonbox itemconfigure 3 -state normal }
                default {
                    return -code error "Invalid button name for\
                        update_nav_buttons_state -enable"
                }
            }
            return
            
        } elseif { ! [string equal "" $opts(disable)] } {
            # We can pass in a specific button "name" to disable
            # If so, return right away.
            switch -exact -- $opts(disable) {
                "cancel" { $nav_buttonbox itemconfigure 0 -state disabled }
                "back" { $nav_buttonbox itemconfigure 1 -state disabled }
                "next" { $nav_buttonbox itemconfigure 2 -state disabled }
                "finish" { $nav_buttonbox itemconfigure 3 -state disabled }
                default {
                    return -code error "Invalid button name for\
                        update_nav_buttons_state -disable"
                }
            }
            return
            
        } elseif { $opts(based_on_page) } {
        # Handle enabling and disabling buttons based on what page is raised
            set page [$nb raise]
            
            # Do the back button
            switch -exact -- $page {
                "project" {
                    $nav_buttonbox itemconfigure 1 -state disabled
                }
                default {
                    $nav_buttonbox itemconfigure 1 -state normal
                }
            }
            
            # Do the next button
            switch -exact -- $page {
                "sdc" {
                    $nav_buttonbox itemconfigure 2 -state disabled
                }
                "interfaces" {
                    if { [string equal "" [interfaces::get_interfaces -selected]] } {
                        $nav_buttonbox itemconfigure 2 -state disabled
                    } else {
                        $nav_buttonbox itemconfigure 2 -state normal
                    }
                }
                default {
                    $nav_buttonbox itemconfigure 2 -state normal
                }
            }
            
            # Do the Finish button
            switch -exact -- $page {
                "project" {
                    $nav_buttonbox itemconfigure 3 -state disabled
                }
                "interfaces" -
                "sdc" -
                default {
                    $nav_buttonbox itemconfigure 3 -state normal
                }
            }
        
        }
    }
    
    ###########################################3
    proc handle_finish { args } {
    
        # Generate SDC
        # Write out SDC and reporting script files
        # ExitApp (save iowizard file)
    
        variable nb
        switch -exact -- [$nb raise] {
            "interfaces" {
                sdc_info::populate_generate_lb
                $nb raise "sdc"
                update_nav_buttons_state -based_on_page
            }
            default {
                sdc_info::on_save_files
                ExitApp
            }
        }
    }
    
    
    ####################################
    #
    proc main { args } {
    
        set options {
            { "browse" "Browse pages without a project open" }
            { "debug" "Print debugging messages" }
            { "ssc" "This script" }
        }
        array set opts [::cmdline::getoptions args $options]
        
        variable nb
        variable mainframe
        variable quitting
        variable v_wm
        variable nav_buttonbox
        
        global script_options
        global script_version
        global quartus
        
        init_tk

        set script_version "26 beta"
        log::open_log
        
        array set script_options [array get opts]
        set script_options(debug) 1

        # Menu for the GUI
        set descmenu [list \
            "&File" all file 0 [list \
                {separator} \
                [list command "E&xit" {} "Exit" {} -command [namespace code ExitApp] ] \
            ] \
            "&Help" all help 0 [list \
                [list command "&Known issues" {} "Known issues" "" -command gui::show_ki_dialog] \
                [list command "&About" {} "About..." {} -command [namespace code ShowAbout] ] \
            ] \
        ]
        
        # Main tabs in the notebook
        set notebook_pages [list \
            [list "project" {-text "Project"} ] \
            [list "interfaces" {-text "Interfaces" } ] \
            [list "sdc" {-text "SDC Constraints"} ]
        ]

#            [list "target" {-text "I/O Timing Target" }]
#            [list "clock_diagram" {-text "Clock Diagram"} ] 

# Trying in wizard notebook
#            [list "data_ports" {-text "I/O Ports" } ] \
#            [list "clocking_conf" { -text "Interface Diagram" } ] \
#            [list "src_clock" {-text "Source Clocking"} ] \
#            [list "dest_clock" {-text "Destination Clocking"} ] \
#            [list "clock_relationship" {-text "Clock Relationship"} ] \
#            [list "target" {-text "I/O Timing Target" }] \
#            [list "requirements"  {-text "Timing Requirements"} ] \
        
        ######################################
        # Create the main application window
        set mainframe [MainFrame .mainframe -menu $descmenu ]
        $mainframe addindicator -text "Quartus II $quartus(version)"
        $mainframe addindicator -text "Script version $script_version"

        # Add the main notebook and its pages
        set nb [PagesManager [$mainframe getframe].pm]

        foreach page $notebook_pages {
            foreach { page_name config_options } $page { break }
        #    eval $nb insert end $page_name $config_options
            $nb add $page_name
        }
        #set messages_sw [ScrolledWindow [$mainframe getframe].sw -auto both]
        #set messages_tr [Tree $messages_sw.tr -showlines true -deltay 16 -deltax 5 \
        #	-padx 24 -linestipple gray50]
        #$messages_sw setwidget $messages_tr

        # Create the question and check marks
        q_messages::init_message_images
        interfaces::create_images
        project_info::create_images
        clocks_info::create_images
        sdc_info::create_images
        
        set wizard_frame [wizard::make_wizard_dialog -parent $mainframe]
        
        #################################################
        # Set up the project tab
        #################################################
        project_info::assemble_tab -frame [$nb getframe "project"]
        
        #################################################
        # Set up the project tab
        #################################################
        interfaces::assemble_tab -frame [$nb getframe "interfaces"]
        
        #################################################
        # Set up the name finder dialog
        #################################################
        name_finder::assemble_dialog -parent $wizard_frame
        
        #################################################
        # Set up the base clock dialog
        #################################################
        clock_entry::assemble_base_clock_dialog -parent $wizard_frame
        
        #################################################
        # Set up the generated clock dialog
        #################################################
        clock_entry::assemble_generated_clock_dialog -parent $wizard_frame
        
        #################################################
        # Set up the generated output-only clock dialog
        #################################################
        clock_entry::assemble_output_clock_dialog -parent $wizard_frame
        
        #################################################
        # Set up the clock diagram tab
        #################################################
#        clock_diagram::assemble_tab -frame [$nb getframe "clock_diagram"]
#        clock_diagram::assemble_diagram_dialog -parent $wizard_frame
        
        #################################################
        # Set up the advanced settings dialog
        #################################################
        advanced_info::assemble_dialog -parent $wizard_frame
        
        #################################################
        # Set up the constraints tab
        #################################################
        sdc_info::assemble_tab -frame [$nb getframe "sdc"]
#        sdc_info::assemble_dialog -parent $mainframe
        
        #################################################
        # Set up the known issues dialog
        #################################################
#        gui::assemble_known_issues_dialog -parent $mainframe
        
        #################################################
        # Set up the text dialog
        text_dialog::assemble_dialog -parent $mainframe
        
        #################################################
        # Step X of Y, Back and Next buttons
        #################################################
        set nav_buttonbox [ButtonBox [$mainframe getframe].bb]

        $nav_buttonbox add -text "Cancel" -width 10 -command \
            [namespace code [list ExitApp -dont_save_file]]
        $nav_buttonbox add -text "< Back" -width 10 -command \
            [namespace code handle_back]
        $nav_buttonbox add -text "Next >" -width 10 -command \
            [namespace code handle_next]
        $nav_buttonbox add -text "Finish" -width 10 -command \
            [namespace code handle_finish]
        pack $nav_buttonbox -side bottom -anchor se -padx 10 -pady 10
                    
        #########################################################
        # Compute the size of the main notebook, pack its frames,
        # itself, and the main window.
        $nb compute_size
        pack $nb -fill both -expand true -anchor n -side top -padx 8 -pady 8

        project_info::copy_current_project_info_to_old
        $nb raise [$nb page 0]
        update_nav_buttons_state -based_on_page
        
        # Save the size of the pagesmanager
        set v_wm(nb_width) [$nb cget -width]
        set v_wm(nb_height) [$nb cget -height]

        pack $mainframe -fill both -expand true -anchor n -side top
        
        # Quit the script. Used to include -dont_save_file
        wm protocol . WM_DELETE_WINDOW [namespace code [list ExitApp ]]

set run_gui 1
if { $run_gui } {
        ###################################
        # Display the GUI and wait to quit
        ###################################
        wm deiconify .
        wm title . $v_wm(title)
        raise .
        focus -force .
        
        # After the GUI becomes visible, save its dimensions and bind
        # the Configure event to update the pagesmanager size
        tkwait visibility .
        update idletasks
        set v_wm(height) [winfo height .]
        set v_wm(width) [winfo width .]
        bind $mainframe <Configure> "[namespace code update_pm_size] $mainframe"

        project_info::on_script_run
#run_gui
        vwait quitting
}
    }

}

proc run_test { args } {

    # Have to create the timing netlist
    # Click Next
    # Click Finish
    # Click Finish
    
    project_info::on_create_timing_netlist_button
    gui::click_nav_button "next"
    gui::click_nav_button "finish"
    gui::click_nav_button "finish"
}

################################################################################

#eval gui::main $quartus(args)
