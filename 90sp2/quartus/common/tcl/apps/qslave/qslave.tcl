
#############################################################################
##  qslave.tcl - v0.0
##
##  The Quartus Slave TCL script
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

package require ::quartus::qSlave

global qSlaveGUIMode
#############################################################################
## Proc:  qSlavePutsGUI
##
## Arguments: Text
##
## Description: Post text to the qSlave GUI
##
#############################################################################
proc qSlavePutsGUI {text} {
    global qSlaveGUIMode
    if {[string equal $qSlaveGUIMode 1]} {
        .top.console config -state normal
        append text "\n"
        .top.console insert end $text
        .top.console see end
        if {[string equal [.top.console index end] 2000.0]} {
           .top.console delete 1.0 1000.0
        }
        .top.console config -state disabled

    }
    return
}

#############################################################################
## Proc:  qSlaveOutputCallback
##
## Arguments: Severity and message
##
## Description: Output callback
##
#############################################################################
proc qSlaveOutputCallback {severity msg} {
    set outputText "$severity: $msg"
    puts $outputText
    qSlavePutsGUI $outputText
    return
}

#############################################################################
## Proc:  qSlaveStatusCallback
##
## Arguments: NetworkID and status callback
##
## Description: Status callback
##              HostName    RemoteCommand   NetworkID
##
#############################################################################
proc qSlaveStatusCallback {networkID hostName remoteCmd args} {
    set statusText "$networkID $hostName $remoteCmd $args [clock format [clock seconds] -format "%a %x %X"]"
    puts $statusText
    qSlavePutsGUI $statusText
    return
}

#############################################################################
## Proc:  qSlaveMain
##
## Arguments: None.
##
## Description: Main procedure.
##
#############################################################################
proc qSlaveMain {} {
    # Process arguments.
    # Quartus will send all arguments through the predefined global variable: q_args
    global q_args
    global qSlaveGUIMode
    set argc [llength $q_args]
    set port {}
    set jobsLimit {}
    set workDir {}
    set qSlaveGUIMode 1
    set temp {}

    if {$argc > 6} {
        return -code error "Wrong number of command line arguments."
    } elseif {$argc > 0} {
        foreach arg $q_args {
            if {[regexp -nocase -- {(\S+)=(.*)} $arg => key val]} {
                switch $key {
                    "port" {
                        set port $val
                    }
                    "jobslimit" {
                        set jobsLimit $val
                    }
                    "workdir" {
                        set workDir $val
                    }
                    "nogui" {
                        set temp [string tolower $val]
                        if {[string equal $temp 1]} {
                            set qSlaveGUIMode 0
                        }
                    }
                    "debug" {
                        set temp [string tolower $val]
                        if {[string equal $temp 1]} {
                            qSlaveObj setDebug
                        }
                    }
                    "nocleanup" {
                        set temp [string tolower $val]
                        if {[string equal $temp 1]} {
                            qSlaveObj setNoCleanUp
                        }
                    }
                }
            }
        }
    }

    if {[string equal $qSlaveGUIMode 1]} {

        if {[catch {init_tk} errMsg]} {
            set qSlaveGUIMode 0
            puts "Warning: Unable to initialize Tk. Defaulting to command-line mode."
        } else {
            if { [ catch { wm withdraw .} ] } {
                set qSlaveGUIMode 0
                puts "Warning: Unable to initialize the UI. Defaulting to command-line mode."
            } else {

                namespace inscope :: package require BWidget

                wm title . "Quartus II QSlave - [info hostname]"

                # wm protocol . WM_DELETE_WINDOW { tk_messageBox -icon info -parent .top -message "You must not close this window while the server is running." }
                # replace with emtpy command so that the user cannot close this button.
                wm protocol . WM_DELETE_WINDOW {
                    set answer [tk_messageBox -icon warning -message "Altera recommends that you make sure no job is running before you quit. \nAre you sure you want to quit?" -type yesno -title "Quartus II QSlave"]
                    switch -- $answer {
                        yes {
                            qSlaveObj killMe
                            exit
                        }
                    }
                }
    
                frame .top
                pack .top -fill both -expand true
    
                text .top.console \
                    -relief raised \
                    -state disabled \
                    -wrap none \
                    -xscrollcommand {.top.x_scroll set} \
                    -yscrollcommand {.top.y_scroll set}
    
                scrollbar .top.y_scroll \
                    -command {.top.console yview} \
                    -orient vertical
    
                scrollbar .top.x_scroll \
                    -command {.top.console xview} \
                    -orient horizontal
    
                # Using grid geometry manager
                grid .top.console .top.y_scroll -sticky news
                grid .top.x_scroll -sticky news
                grid rowconfigure .top 0 -weight 1
                grid columnconfigure .top 0 -weight 1
    
                BWidget::place . 0 0 center
    
                wm deiconify .
                raise .
                focus -force .
    
                # Wait for the main window to close
                # Note that even in quartus GUI mode,
                # we still need to wait for main window to close
                # tkwait window .
                # Do not have to because the vwait in startDaemon, keep one vwait for easy manage
            }
        }
    }

    qSlaveObj config -listenPort $port -jobsLimit $jobsLimit -workDir $workDir
    qSlaveObj startDaemon -outputCallback [namespace code qSlaveOutputCallback] -statusCallback [namespace code qSlaveStatusCallback]
}

#############################################################################
#############################################################################
qSlaveMain
