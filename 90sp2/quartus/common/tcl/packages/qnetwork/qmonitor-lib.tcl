
#############################################################################
##  qmonitor-lib.tcl - v1.0
##
##  Quartus Monitor Library Package
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
# $Revision: #1 $

package provide ::quartus::qMonitor 1.0

package require Itcl 3.2
# Tktable requires init_tk to be call first
package require Tktable 2.8
package require cmdline 1.2.1

#############################################################################
## Class:   ::quartus::qMonitor
##
## Description: qMonitor class.
##
#############################################################################
itcl::class ::quartus::qMonitor {
    constructor {{debugMode 0}} {
        set m_debugMode $debugMode
        # Assign allowStopJob to 1 if we want to enable stop jobs button
        set ::quartus::qMonitor::gui::allowStopJob 0
    }
    destructor {
    }
    ###########################
    ## Public APIs
    ###########################

    public method setDebug {{mode 1}} {set m_debugMode $mode}

    # Proxy to ::quartus::qMonitor::gui namespace public API
    public method initialize {window} {
        putsDebug $window
        ::quartus::qMonitor::gui::init $window
    }
    public method show {} {
        ::quartus::qMonitor::gui::showQMonitor
    }
    public method hide {} {
        ::quartus::qMonitor::gui::hideQMonitor
    }

    public method clearJobsStatus {} {
        ::quartus::qMonitor::gui::qmon_clearTable
    }

    public method updateJobStatus {jobID args}

    ##########################
    ## Protected APIs
    ##########################
    protected method putsDebug {arg}

    ##########################
    ## Data Members
    ##########################
    protected variable m_debugMode
}

#############################################################################
## Method:  ::quartus::qMonitor::putsDebug
##
## Arguments: String
##
## Description: Enable this function only in debug mode.
##
#############################################################################
itcl::body ::quartus::qMonitor::putsDebug {arg} {
    if {[string equal $m_debugMode 1]} {
        puts "\[DEBUG\]: $arg"
    }
}

#############################################################################
## Method:  ::quartus::qMonitor::updateJobStatus
##
## Arguments: JobID Args
##
## Description: Update the slave status in the qMonitor table
##
#############################################################################
itcl::body ::quartus::qMonitor::updateJobStatus {jobID args} {

    set         tlist       "hostName.arg"
    lappend     tlist       "#_default_#"
    lappend     tlist       "Slave host name"
    lappend functionOpts $tlist

    set         tlist       "remoteCmd.arg"
    lappend     tlist       "#_default_#"
    lappend     tlist       "Remote job command"
    lappend functionOpts $tlist

    set         tlist       "status.arg"
    lappend     tlist       "#_default_#"
    lappend     tlist       "Job status"
    lappend functionOpts $tlist

    set         tlist       "failReason.arg"
    lappend     tlist       "#_default_#"
    lappend     tist       "Job fail reason"
    lappend functionOpts $tlist

    array set optsHash [cmdline::getFunctionOptions args $functionOpts]

    set constructArgs {}

    if {![string equal $optsHash(hostName) "#_default_#"]} {
        set constructArgs [concat $constructArgs {Slave_ID=$optsHash(hostName)}]
    }
    if {![string equal $optsHash(remoteCmd) "#_default_#"]} {
        set constructArgs [concat $constructArgs {Job_Command=$optsHash(remoteCmd)}]
    }
    if {![string equal $optsHash(status) "#_default_#"]} {
        set constructArgs [concat $constructArgs {Status=$optsHash(status)}]
    }
    if {![string equal $optsHash(failReason) "#_default_#"]} {
        set constructArgs [concat $constructArgs {Status_Cause=$optsHash(failReason)}]
    }

    set cmd "::quartus::qMonitor::gui::updateStatusTable $jobID $constructArgs"
    eval $cmd
}

#############################################################################
## Namespace:   ::quartus::qMonitor::gui
##
## Description: qMonitor::gui namespace
##
#############################################################################
namespace eval ::quartus::qMonitor::gui {
    array set qmonTable {
        rows	      1
        cols	      4
        name          slaveStatus
        data          tableData
        rowID         tableRowID
        colID         tableColID
        tooltip       tableTooltip
        tooltipMsg    tableTooltipMsgs
        failureMsg    tableFailureMsg
        selected      selectedID
        colName       {"Job ID" "Slave ID" "Job Command" "Status"}
    }
    variable window
    variable embedded
    variable allowStopJob 1
    variable stopJobCallback
    variable $qmonTable(data)
    variable $qmonTable(rowID)
    variable $qmonTable(tooltip)
    variable $qmonTable(selected)
    array set $qmonTable(colID) {
        "Job_ID"            0
        "Slave_ID"          1
        "Job_Command"       2
        "Status"            3
        "Status_Cause"      4
        "Date"              5
    }
    array set $qmonTable(tooltipMsg) {
        Start       "Master starts submitting the job to the slave."
        Upload      "Master starts copying files to slave."
        Download    "Master starts copying results files from the slave."
        Run         "Slave is running the job."
        Done        "The job has finished running."
        Fail        "The job has failed to run."
        Stop        "The job was stopped by user."
    }
    array set $qmonTable(failureMsg) {
        slaveDown               "The slave host is down."
        ftpTimeout              "Ftp timeout."
        ftpTerminated           "Ftp terminated."
        ftpUnexpected           "Ftp unexpected."
        ftpError                "Ftp error."
        ftpConnect              "Ftp connect."
        transferTimeout         "File transfer timeout."
        transferTerminated      "File transfer terminated."
        transferError           "File transfer error."
        transferUnexpected      "File transfer unexpected behavior."
        transferConnectError    "File transfer connection error."
        slaveBusy               "The slave is busy."
        invalidVer              "The slave is using different Quartus II version."
        remoteCmd               "The slave failed to execute command(s) submitted by the master."
        noResultFile            "Missing results file(s) after job completion."
        failLimit               "The number of failures of this job \nhas exceeded the failure limit. \nThe failure limit is set to 2."
        noAvailSlaves           "No available slaves."
        noAvailLSF              "No available LSF or fail to issue \nthe \"bsub\" command in LSF mode."
    }

}

#############################################################################
## Method:  ::quartus::qMonitor::gui::changeColor
##
## Arguments: Row ColorCode
##
## Description: Change row color based on color code given
##
#############################################################################
proc ::quartus::qMonitor::gui::changeColor { row code } {
    set tableName [::quartus::qMonitor::gui::qmon_getProperty name]
    set numcol [$tableName cget -cols]

    for { set col 0 } { $col < $numcol } { incr col } {
        $tableName tag celltag $code $row,$col
    }

    return
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::checkColorCode
##
## Arguments: FlashingEnabler, Row, Column
##
## Description: Check color display on update
##
#############################################################################
proc ::quartus::qMonitor::gui::checkColorCode { UPDFLASH row col } {
    set tableName [::quartus::qMonitor::gui::qmon_getProperty name]
    set statuscol [::quartus::qMonitor::gui::qmon_getColumn "Status"]
    set msg [$tableName get $row,$statuscol]
    set jobID [::quartus::qMonitor::gui::qmon_getContent $row "Job_ID"]
    set selectedID [::quartus::qMonitor::gui::qmon_getProperty selected]
    set colorCode ORIGINALCOLOR

    if { [string equal $msg "Fail"] || [string equal $msg "Stopped"] } {
        set colorCode FAILED
        if { [info exists ::quartus::qMonitor::gui::$selectedID\($jobID)] } {
            unset ::quartus::qMonitor::gui::$selectedID\($jobID)
        }
    } elseif { [string equal $msg "Done"] } {
        set colorCode DONE

        if { [info exists ::quartus::qMonitor::gui::$selectedID\($jobID)] } {
            unset ::quartus::qMonitor::gui::$selectedID\($jobID)
        }
    }

    if { $UPDFLASH } {
        $tableName tag celltag CHANGEFLASH $row,$col
        after 100 ::quartus::qMonitor::gui::changeColor $row $colorCode
    } else {
        ::quartus::qMonitor::gui::changeColor $row $colorCode
    }

    return
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::qmon_initNewStatus
##
## Arguments: ID(Unique Id to identify a row)
##
## Description: Crete a new row to add monitoring
##
#############################################################################
proc ::quartus::qMonitor::gui::qmon_initNewStatus { ID } {
    set rowID [::quartus::qMonitor::gui::qmon_getProperty rowID]
    set tableName [::quartus::qMonitor::gui::qmon_getProperty name]
    set numrow [$tableName cget -rows]

    incr numrow
    $tableName configure -rows $numrow
    set numrow [expr ($numrow - 2)]
    if { $::quartus::qMonitor::gui::allowStopJob == 1} {
        $tableName tag celltag NOTSELECTED $numrow,0
    }

    set ::quartus::qMonitor::gui::$rowID\($ID) $numrow
    return $numrow
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::qmon_getRow
##
## Arguments: ID(Unique Id that identify a row)
##
## Description: Return a row number on ID
##
#############################################################################
proc ::quartus::qMonitor::gui::qmon_getRow { ID } {
    set rowID [::quartus::qMonitor::gui::qmon_getProperty rowID]

    if {[info exists ::quartus::qMonitor::gui::$rowID\($ID)] } {
        set cmd ::quartus::qMonitor::gui::$rowID\($ID)
        return [expr $$cmd]
    }
    return -1
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::qmon_getColumn
##
## Arguments: ColoumnName
##
## Description: Return a column number on column name
##
#############################################################################
proc ::quartus::qMonitor::gui::qmon_getColumn { name } {
    set colID [::quartus::qMonitor::gui::qmon_getProperty colID]

    if {[info exists ::quartus::qMonitor::gui::$colID\($name)] } {
        set cmd ::quartus::qMonitor::gui::$colID\($name)
        return [expr $$cmd]
    }
    return -1
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::qmon_setData
##
## Arguments: Row, Column, Data
##
## Description: Set data into specific table cell
##
#############################################################################
proc ::quartus::qMonitor::gui::qmon_setData { row col data } {
    set dataArray [::quartus::qMonitor::gui::qmon_getProperty data]

    set ::quartus::qMonitor::gui::$dataArray\($row,$col) $data
    return
}


#############################################################################
## Method:  ::quartus::qMonitor::gui::qmon_getData
##
## Arguments: Row, Column
##
## Description: Retrieve data in a specific table cell
##
#############################################################################
proc ::quartus::qMonitor::gui::qmon_getData { row col } {
    set dataArray [::quartus::qMonitor::gui::qmon_getProperty data]

    if { [info exists ::quartus::qMonitor::gui::$dataArray\($row,$col)] } {
        set cmd ::quartus::qMonitor::gui::$dataArray\($row,$col)
        return [expr $$cmd]
    }

    return
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::qmon_getProperty
##
## Arguments: PropertyName
##
## Description: Retrieve property value set in qmonTable
##
#############################################################################
proc ::quartus::qMonitor::gui::qmon_getProperty { property } {
    if {[info exists ::quartus::qMonitor::gui::qmonTable($property)] } {
        return $::quartus::qMonitor::gui::qmonTable($property)
    }
    return
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::qmon_setProperty
##
## Arguments: PropertyName, Data
##
## Description: Set property value set in qmonTable
##
#############################################################################
proc ::quartus::qMonitor::gui::qmon_setProperty { property data } {
    if {[info exists ::quartus::qMonitor::gui::qmonTable($property)] } {
        set ::quartus::qMonitor::gui::qmonTable($property) $data
    }
    return
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::qmon_getContent
##
## Arguments: Row, ColumnName
##
## Description: Get data in specific table cell indicated by colomnName
##
#############################################################################
proc ::quartus::qMonitor::gui::qmon_getContent { row colName } {
    set col [::quartus::qMonitor::gui::qmon_getColumn $colName]
    if { $col != -1 } {
        return [::quartus::qMonitor::gui::qmon_getData $row $col]
    }
    return
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::create_tooltip
##
## Arguments: TargetWidget, TooltipMsg, x_root, y_root
##
## Description: Create a tool tip / balloon
##
#############################################################################
proc ::quartus::qMonitor::gui::create_tooltip {target message {cx 0} {cy 0} } {

    if { $cx == 0 && $cy == 0 } {
        set x [expr [winfo rootx $target] + ([winfo width $target]/2)]
        set y [expr [winfo rooty $target] + [winfo height $target] + 4]
    } else {
    	set x [expr $cx + 4]
        set y [expr $cy + 4]
    }

    toplevel .balloon -bg black -screen [winfo screen $target]
    wm overrideredirect .balloon 1
    label .balloon.l \
        -text $message -relief flat \
        -bg #ffffaa -fg black -padx 2 -pady 0 -anchor w
    pack .balloon.l -side left -padx 1 -pady 1
    wm geometry .balloon +${x}+${y}

    return
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::show_tooltip
##
## Arguments: x, y, x_root, y_root, TooltipShowDelay
##
## Description: Show created tool tip
##
#############################################################################
proc ::quartus::qMonitor::gui::show_tooltip { x y X Y delay } {
    set tooltipMsgs [::quartus::qMonitor::gui::qmon_getProperty tooltipMsg]

    set tableName [::quartus::qMonitor::gui::qmon_getProperty name]
    set row [$tableName index @$x,$y row]
    set col [$tableName index @$x,$y col]

    set tooltip [::quartus::qMonitor::gui::qmon_getProperty tooltip]
    ::quartus::qMonitor::gui::kill_tooltip
    if { $col == 3 } {
        if { [info exists ::quartus::qMonitor::gui::$tooltipMsgs\([$tableName get @$x,$y])] } {
            set cmd ::quartus::qMonitor::gui::$tooltipMsgs\([$tableName get $row,$col])
            set tipMsg [expr $$cmd]

            set status [::quartus::qMonitor::gui::qmon_getContent $row "Status"]
            set statusCause ""
            if { [string equal $status "Fail"] } {
                set statusCause [::quartus::qMonitor::gui::qmon_getContent $row "Status_Cause"]
                if { ![string equal $statusCause ""] } {
                    set failureMsg [::quartus::qMonitor::gui::qmon_getProperty failureMsg]
                    if { [info exists ::quartus::qMonitor::gui::$failureMsg\($statusCause)] } {
                        set cmd ::quartus::qMonitor::gui::$failureMsg\($statusCause)
                        set failureStr [expr $$cmd]
                        set statusCause "Failure Reason: $failureStr\n"
                    }
                }
            }
            set updateDate [::quartus::qMonitor::gui::qmon_getContent $row "Date"]
            set tipMsg "$tipMsg \n$statusCause \nUpdated on: $updateDate"
            set cmd [list ::quartus::qMonitor::gui::create_tooltip $tableName $tipMsg $X $Y]
            set ::quartus::qMonitor::gui::$tooltip\(id) [after $delay $cmd]
        }
    }

    return
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::kill_tooltip
##
## Arguments: NONE
##
## Description: Kill created tool tip
##
#############################################################################
proc ::quartus::qMonitor::gui::kill_tooltip {} {
    set tooltip [::quartus::qMonitor::gui::qmon_getProperty tooltip]

    if { [info exists ::quartus::qMonitor::gui::$tooltip\(id)] } {
        set cmd ::quartus::qMonitor::gui::$tooltip\(id)
        after cancel [expr $$cmd]
    }
    if {[winfo exists .balloon] == 1} {
        destroy .balloon
    }

    return
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::onMouseWheel
##
## Arguments: Delta(up or down)
##
## Description: Mouse wheel event handler procedure
##
#############################################################################
proc ::quartus::qMonitor::gui::onMouseWheel { delta } {
    set tableName [::quartus::qMonitor::gui::qmon_getProperty name]

    if { $delta >= 0 } {
        set delta  1
    } else {
        set delta -1
    }

    set xy [$tableName yview]
    set factor [expr [lindex $xy 1]-[lindex $xy 0]]

    set window $::quartus::qMonitor::gui::window
    if { $window == "." } {
        set window ""
    }

    set cmd "[$window.sy cget -command] scroll [expr -int($delta/$factor)] units"
    eval $cmd

    return
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::onSelection
##
## Arguments: row, col
##
## Description: Mouse left click event handler procedure
##
#############################################################################
proc ::quartus::qMonitor::gui::onSelection { row col } {
    set tableName [::quartus::qMonitor::gui::qmon_getProperty name]
    set selectedID [::quartus::qMonitor::gui::qmon_getProperty selected]
    set jobID [::quartus::qMonitor::gui::qmon_getContent $row "Job_ID"]

    if { $col == 0 } {
        if { [$tableName tag includes NOTSELECTED $row,$col] } {
            $tableName tag celltag SELECTED $row,$col
            set ::quartus::qMonitor::gui::$selectedID\($jobID) $row
        } elseif { [$tableName tag includes SELECTED $row,$col] } {
            $tableName tag celltag NOTSELECTED $row,$col
            if { [info exists ::quartus::qMonitor::gui::$selectedID\($jobID)] } {
                unset ::quartus::qMonitor::gui::$selectedID\($jobID)
            }
        }
    }
    after 0 $tableName selection clear all

    return
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::unsetData
##
## Arguments: DataString
##
## Description: Unset variable or array in the namespace
##
#############################################################################
proc ::quartus::qMonitor::gui::unsetData { data } {
    set currentData [::quartus::qMonitor::gui::qmon_getProperty $data]
    if { [info exists ::quartus::qMonitor::gui::$currentData]  } {
        unset ::quartus::qMonitor::gui::$currentData
        namespace eval qMonitor "variable $currentData"
    }

    return
}


#############################################################################
## Method:  ::quartus::qMonitor::gui::dataCleanUp
##
## Arguments: NONE
##
## Description: Clean all previous data accumulation
##
#############################################################################
proc ::quartus::qMonitor::gui::dataCleanUp { } {

   ::quartus::qMonitor::gui::unsetData rowID
   ::quartus::qMonitor::gui::unsetData data
   ::quartus::qMonitor::gui::unsetData tooltip
   ::quartus::qMonitor::gui::unsetData selected

   return
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::setBinds
##
## Arguments: NONE
##
## Description: Set all binds (Event Handling)
##
#############################################################################
proc ::quartus::qMonitor::gui::setBinds { } {
    # all binds procedures must be in proc to avoid declaring global variable
    bind $::quartus::qMonitor::gui::window <MouseWheel> {
        ::quartus::qMonitor::gui::onMouseWheel %D
    }

    if { $::quartus::qMonitor::gui::allowStopJob == 1} {
        bind [::quartus::qMonitor::gui::qmon_getProperty name] <1> {
            ::quartus::qMonitor::gui::onSelection [%W index @%x,%y row] [%W index @%x,%y col]
        }
    
        bind [::quartus::qMonitor::gui::qmon_getProperty name] <Key-Return> {
            ::quartus::qMonitor::gui::onSelection [lindex [split [%W cursel] ","] 0] [lindex [split [%W cursel] ","] 1]
        }   
    }

    bind [::quartus::qMonitor::gui::qmon_getProperty name] <ButtonPress-3> {
        ::quartus::qMonitor::gui::show_tooltip %x %y %X %Y 0
    }

    bind [::quartus::qMonitor::gui::qmon_getProperty name] <Motion> {
        ::quartus::qMonitor::gui::show_tooltip %x %y %X %Y 500
        # "break" prevents the call to tkTableCheckBorder
        break
    }

    bind [::quartus::qMonitor::gui::qmon_getProperty name] <Any-Leave> {
        ::quartus::qMonitor::gui::kill_tooltip
    }

    bind [::quartus::qMonitor::gui::qmon_getProperty name] <Destroy> {
        ::quartus::qMonitor::gui::dataCleanUp
        ::quartus::qMonitor::gui::qmon_setProperty name [lindex [split [::quartus::qMonitor::gui::qmon_getProperty name] "."] end]
    }

    return
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::_bt_closeWindow_command
##
## Arguments: NONE
##
## Description: Procedure on close button
##
#############################################################################
proc ::quartus::qMonitor::gui::_bt_closeWindow_command args {
    ::quartus::qMonitor::gui::hideQMonitor
    return
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::_bt_StopJob_command
##
## Arguments: NONE
##
## Description: Procedure on stop jobs button
##
#############################################################################
proc ::quartus::qMonitor::gui::_bt_StopJob_command args {
    set selectedID [::quartus::qMonitor::gui::qmon_getProperty selected]
    set stopJobIDList [array names ::quartus::qMonitor::gui::$selectedID]

    if { [info exists ::quartus::qMonitor::gui::stopJobCallback] && ![string equal $::quartus::qMonitor::gui::stopJobCallback ""]  } {
        $::quartus::qMonitor::gui::stopJobCallback $stopJobIDList
    }

    return
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::addTableTitle
##
## Arguments: NONE
##
## Description: Initialize table title
##
#############################################################################
proc ::quartus::qMonitor::gui::addTableTitle {} {

    set titleList [::quartus::qMonitor::gui::qmon_getProperty colName]
    set currentCol 0
    foreach title $titleList {
        ::quartus::qMonitor::gui::qmon_setData -1 $currentCol $title
        incr currentCol
    }

    return
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::ui
##
## Arguments: WindowName
##
## Description: Create the qMonitor UI
##
#############################################################################
proc ::quartus::qMonitor::gui::ui {root args} {
    set base [expr {($root == ".") ? "" : $root}]
    variable ROOT $root
    variable BASE $base

    set tableName [::quartus::qMonitor::gui::qmon_getProperty name]
    ::quartus::qMonitor::gui::qmon_setProperty name $base.$tableName
    set ::quartus::qMonitor::gui::window $root

    set dataArray [::quartus::qMonitor::gui::qmon_getProperty data]
    set tableName [::quartus::qMonitor::gui::qmon_getProperty name]
    set initalNumRows  [::quartus::qMonitor::gui::qmon_getProperty rows]
    set initalNumCols  [::quartus::qMonitor::gui::qmon_getProperty cols]

    # Get SystemButtonFace equivalence (to avoid problem in unix systems)
    button .myButton
    set SystemButtonFace [.myButton cget -background]
    destroy .myButton

   # Widget Initialization
    label $base.help -bd 1 -fg black -bg lightyellow -font fixed -text "default help"
    button $base._bt_closeWindow \
	    -command [namespace code [list _bt_closeWindow_command]] \
	    -text "Close Window"
    button $base._bt_StopJob \
	    -command [namespace code [list _bt_StopJob_command]] \
	    -text "Stop Job"
    table $tableName \
        -rows $initalNumRows \
        -cols $initalNumCols \
        -height 6 \
        -variable ::quartus::qMonitor::gui::$dataArray \
    	-titlerows 1 -titlecols 0 \
    	-roworigin -1 -colorigin 0 \
    	-xscrollcommand "$base.sx set"\
    	-yscrollcommand "$base.sy set"\
    	-selectmode extended -sparsearray 0 \
        -cursor top_left_arrow \
        -colstretch all \
        -resizeborders none \
        -state disabled

        ::quartus::qMonitor::gui::addTableTitle

        $tableName width 0 6 1 15 2 30
        $tableName tag configure NOTSELECTED -relief raised
        $tableName tag configure SELECTED  -bg NavajoWhite3 -relief sunken
        $tableName tag configure FAILED  -bg firebrick2 -relief sunken
        $tableName tag configure CHANGEFLASH -bg tan1 -relief flat
        $tableName tag configure ORIGINALCOLOR -bg $SystemButtonFace -relief sunken
        $tableName tag configure DONE -bg SeaGreen1 -relief sunken
    scrollbar $base.sx \
        -command [list $tableName xview] -orient h
    scrollbar $base.sy \
        -command [list $tableName yview] -orient v


    # Geometry Management
    grid $tableName -in $root -row 1 -column 1 \
	    -columnspan 3 \
	    -ipadx 0 \
	    -ipady 0 \
	    -padx 0 \
	    -pady 0 \
	    -rowspan 1 \
	    -sticky news
    grid $base.sx -in $root -row 2 -column 1 \
        -columnspan 3 \
        -sticky news
    grid $base.sy -in $root -row 1 -column 4 \
        -sticky news

    if { $::quartus::qMonitor::gui::allowStopJob == 1} {
        grid $base._bt_StopJob -in $root -row 3 -column 1 \
    	    -columnspan 1 \
    	    -ipadx 0 \
    	    -ipady 0 \
    	    -padx 0 \
    	    -pady 0 \
    	    -rowspan 1 \
    	    -sticky w
    }
    if { $::quartus::qMonitor::gui::embedded == 0 } {
        grid $base._bt_closeWindow -in $root -row 3 -column 3 \
	       -columnspan 2 \
	       -ipadx 0 \
	       -ipady 0 \
	       -padx 0 \
	       -pady 0 \
	       -rowspan 1 \
	       -sticky e
    }

    # Resize Behavior
    grid rowconfigure $root 1 -weight 1 -minsize 100 -pad 0
    grid columnconfigure $root 1 -weight 1 -minsize 175 -pad 0
    setBinds

    return
}

#############################################################################
## PUBLIC APIs START HERE
#############################################################################

#############################################################################
## Method:  ::quartus::qMonitor::gui::updateStatusTable
##
## Arguments: JobID, Arguments (ColumnName=<data>)
##
## Description: Update specific cell on arguments
##
#############################################################################
proc ::quartus::qMonitor::gui::updateStatusTable {rowID args} {
    set UPDFLASH 1
    set row [::quartus::qMonitor::gui::qmon_getRow $rowID]

    if { $row == -1 } {
        set row [::quartus::qMonitor::gui::qmon_initNewStatus $rowID]
        set col [::quartus::qMonitor::gui::qmon_getColumn Job_ID]
        ::quartus::qMonitor::gui::qmon_setData $row $col $rowID
        set UPDFLASH 0
    }

    foreach arg $args {
        set updateCol [lindex [split $arg "="] 0]
        set data [lindex [split $arg "="] 1]
        if { [string length $data] == 0 || [string equal $data "\"\""] || [string equal $data "{}"] } {
            set data ""
        }

        if { ![string equal $updateCol UPDFLASH] } {
            set col [::quartus::qMonitor::gui::qmon_getColumn $updateCol]

            if { $col != -1 } {
                if { ![string equal $data [::quartus::qMonitor::gui::qmon_getData $row $col]] } {
                    ::quartus::qMonitor::gui::qmon_setData $row $col $data
                    ::quartus::qMonitor::gui::checkColorCode $UPDFLASH $row $col
    
                    set updateTime [clock format [clock seconds] -format {%a %D %r}]
                    set col [::quartus::qMonitor::gui::qmon_getColumn "Date"]
                    if { $col != -1 } {::quartus::qMonitor::gui::qmon_setData $row $col $updateTime}
                }
            } else {
                qMonitorObj putsDebug "Warning: Unrecognize coloum name : $updateCol"
            }
        } else {
            set UPDFLASH $data
        }
    }

    return
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::addNewSlaveStatus
##
## Arguments: RowID, SlaveID, JobID, JobCommand, InitialStatus, InitialStatusCause(If any)
##
## Description: Create new row and initialize it
##
#############################################################################
proc ::quartus::qMonitor::gui::addNewSlaveStatus { rowID slave_id job_id job_command status args} {
    set newrow [::quartus::qMonitor::gui::qmon_initNewStatus $rowID]

    updateStatusTable $rowID UPDFLASH=0 Slave_ID=$slave_id Job_ID=$job_id Job_Command=$job_command Status=$status Status_Cause=$args
    return $newrow
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::showQMonitor
##
## Arguments: NONE
##
## Description: Show UI if hidden
##
#############################################################################
proc ::quartus::qMonitor::gui::showQMonitor { } {
    if { $::quartus::qMonitor::gui::embedded == 0 } {
        wm deiconify $::quartus::qMonitor::gui::window
    }
    return
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::hideQMonitor
##
## Arguments: NONE
##
## Description: Hide the UI
##
#############################################################################
proc ::quartus::qMonitor::gui::hideQMonitor { } {
    if { $::quartus::qMonitor::gui::embedded == 0 } {
        wm withdraw $::quartus::qMonitor::gui::window
    }
    return
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::qmon_clearTable
##
## Arguments: NONE
##
## Description: Clear the qMonitor table
##
#############################################################################
proc ::quartus::qMonitor::gui::qmon_clearTable { } {
    set tableName [::quartus::qMonitor::gui::qmon_getProperty name]

    # Delete command only work when the -state is normal ...
    set numrows [expr ([$tableName cget -rows] - 1)]
    $tableName configure -state normal
    $tableName delete rows -holddimensions -- 0 $numrows
    $tableName configure -rows 1
    $tableName configure -state disabled

    ::quartus::qMonitor::gui::dataCleanUp
    ::quartus::qMonitor::gui::addTableTitle

    return
}

#############################################################################
## Method:  ::quartus::qMonitor::gui::init
##
## Arguments: WindowName
##
## Description: Initialize(and create) the UI, initially the UI is hidden
##
#############################################################################
proc ::quartus::qMonitor::gui::init {root} {

    # another option is to use embed_args
    if {[$root cget -use] != ""} {
        set ::quartus::qMonitor::gui::embedded 1
        ::quartus::qMonitor::gui::ui $root

    } else {
        set ::quartus::qMonitor::gui::embedded 0
    	wm title $root "Job Monitoring"
        wm protocol $root WM_DELETE_WINDOW {
            ::quartus::qMonitor::gui::hideQMonitor
        }

        if {[catch {::quartus::qMonitor::gui::ui $root} err]} {
	       bgerror $err ; exit 1
        }
        ::quartus::qMonitor::gui::hideQMonitor
    }

    return
}

#############################################################################
##  Global Procedures and Objects
#############################################################################
::quartus::qMonitor qMonitorObj

