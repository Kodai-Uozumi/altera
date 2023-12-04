
#############################################################################
##  qslave-lib.tcl - v1.0
##
##  Quartus Slave Library Package
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

package provide ::quartus::qSlave 1.0
package require ::quartus::qNetwork 1.0
package require ftpd 1.1.3

package require ::quartus::qTransfer 1.0

#############################################################################
## Class:   ::quartus::qSlave
##
## Description: qSlave Class. Slave has 2 open ports
##              (1) COMM port
##                      This port is used for internal communication protocol.
##                      This port can be specified by user.
##              (2) FTP port
##                      This port is used for file transfer.
##
#############################################################################
itcl::class ::quartus::qSlave {
    inherit qNetwork
    constructor {{debugMode 0}} {qNetwork::constructor $debugMode} {
        putsDebug "qSlave constructor is called."
        array set m_masterInfo {}
        array set m_pipeJobsInfo {}
        set m_listenPort $m_slaveListenPort
        # Jobs limit is maximum number of masters can be connect to this slave
        set m_jobsLimit 1
        set m_useFTP 0
        set m_currentJobsCount 0
        set m_workDir {}
        array set undeletedTempDir {}
    }
    destructor {
        putsDebug "qSlave destructor is called."
    }

    ###########################
    ## Public APIs
    ###########################
    public method startDaemon {args}
    public method reduceCurrentJobsCount {}
    public method resetCurrentJobsCount {} {set m_currentJobsCount 0}

    # asynchrnous remote command which called by the master.
    public method remoteCmd {procCmd callbackCmd networkID args}
    public method initMasterInfo {networkID sock masterID}
    public method spawnProcessCallback {pipe networkID}

    # Ftp callbacks user command
    public method authUsrCmd {userName password}
    public method authFileCmd {args} {return 1}
    public method ftpLogCmd {args} {putsDebug $args}

    # Configuration
    public method config {{args {}}}

    # obsolete procedures
    public method getFtpListenPort {networkID} {return -code error "qSlave::getFtpListenPort has been obsoleted."}

    # Called by qMaster
    public method getQuartusVersion {args}
    public method getJobsLimit {args}
    public method killMe {}
    
    # Called when there is a callback from client
    public method serverCallback

    ###########################
    ## Protected APIs
    ###########################
    # clean up master information after master leave the slave.
    protected method preProcess {qVersion networkID}
    protected method postProcess {forceReturnStatus networkID}
    protected method cleanUpMasterInfo {networkID}
    protected method startRemoteCommand {commandName networkID}

    protected method spawnProcess {cmd networkID}
    protected method stopRemoteJob {newtorkID}

    # obsolete procedures
    protected method restoreProject {fileName networkID}
    protected method startRemoteJob {scriptName networkID}
    protected method archiveProject {fileName projName networkID}

    ###########################
    ## Data Members
    ###########################
    protected variable m_masterInfo
    protected variable m_pipeJobsInfo
    protected variable m_jobsLimit
    protected variable m_currentJobsCount
    protected variable m_workDir
    protected variable m_useFTP
    protected variable undeletedTempDir
}

#############################################################################
## Method:  ::quartus::qSlave::serverCallback
##
## Arguments: Network ID and callback command arguments.
##
## Description: Callback for server handler
##
#############################################################################
itcl::body ::quartus::qSlave::serverCallback {networkID status details} {
    putsDebug "*****Calling qSlave::serverCallback $networkID $status $details*****"

    if { ![string equal $status success] } {
        postProcess 0 $networkID
    }

    return
}

#############################################################################
## Method:  ::quartus::qSlave::killMe
##
## Arguments: None
##
## Description: Stop all current jobs and exit.
##
#############################################################################
itcl::body ::quartus::qSlave::killMe {} {
    putsDebug "*****Calling qSlave::killMe.*****"
    set networkID {}
    foreach index [array names m_pipeJobsInfo *pipe] {
        set networkID [lindex $index 0]
        # stopRemoteJob will check whether there is any current job running
        stopRemoteJob $networkID

    }
    if {![string equal $m_currentJobsCount 0]} {
        putsWarning "At least one temporary directory in $m_workDir was not deleted."
    }
    return
}

#############################################################################
## Method:  ::quartus::qSlave::getQuartusVersion
##
## Arguments:  args is for master/slave communication.
##
## Description: Return the current Quartus version.
##
#############################################################################
itcl::body ::quartus::qSlave::getQuartusVersion {args} {
    putsDebug "*****Calling qSlave::getQuartusVersion $args.*****"
    return $::quartus(version)
}


#############################################################################
## Method:  ::quartus::qSlave::getJobsLimit
##
## Arguments:  args is for master/slave communication.
##
## Description: Return the jobs limit.
##
#############################################################################
itcl::body ::quartus::qSlave::getJobsLimit {args} {
    putsDebug "*****Calling qSlave::getJobsLimit $args.*****"
    return $m_jobsLimit
}


#############################################################################
## Method:  ::quartus::qSlave::reduceCurrentJobsCount
##
## Arguments:  None
##
## Description: Reduce the current number of jobs in this slave.
##
#############################################################################
itcl::body ::quartus::qSlave::reduceCurrentJobsCount {} {
    putsDebug "*****Calling qSlave::reduceCurrentJobsCount.*****"
    # Important note: When we reach here, something wrong is happen
    # I don't know how to recover this kind of problem
    # I try to do my best my reducing the current jobs count
    # However, this is not the best of doing things.
    if {![string equal $m_currentJobsCount 0]} {
        set m_currentJobsCount [expr $m_currentJobsCount -1]
    }
    return
}


#############################################################################
## Method:  ::quartus::qSlave::config
##
## Arguments: Options
##
## Description: Configure
##              (1) Slave listen port
##              (2) Jobs limit
##
#############################################################################
itcl::body ::quartus::qSlave::config {{args {}}} {
    putsDebug "*****Calling qSlave::config $args.*****"

    # Process arguments
    set options {-listenPort -jobsLimit -workDir}

    # If no agruments, print out all options value.
    if {[string equal $args {}]} {
        foreach {option} $options {
            # Output example: all = -listenPort var = listenPort
            regexp -- {^-(.*)} $option all var
            set tmpVar m_$var
            # TODO: construct a string in a line.
            # For now, it still works with one option
            return "$option [subst $[subst $tmpVar]]"
        }
    } else {
        foreach {option value} $args {
            if {[lsearch -exact $options $option] != "-1" } {
                putsDebug "$option = $value"
                # Output example: all = -listenPort var = listenPort
                regexp -- {^-(.*)} $option all var
                # Construct the member dynamically. Therefore, options
                # name must be consistent with internal member variable.
    
                # TODO: Display value if not specify
                if {[string equal $value {}]} {
                    # set tmpVar m_$var
                    # return "[subst $[subst $tmpVar]]"
                } else {
                    set m_$var $value
                }
            }
        }
        # Set working directory
        if {![string equal $m_workDir {}]} {
    
            if {![file exists $m_workDir]} {
                file mkdir $m_workDir
        	}
    
        	if {[file isdirectory $m_workDir]} {
        	   set dir [getFullDirFileName $m_workDir]
        	   set m_workDir $dir
        	} else {
        	   set m_workDir {}
        	}
        }
    }
    return
}

#############################################################################
## Method:  ::quartus::qSlave::postProcess
##
## Arguments: Force return status and network ID
##
## Description: Clean up after the one job is complete.
##              (1) Delete the working directory
##              (2) Clean Up masterinfo data structure
##              Caller:
##              (1) Master host
##              (2) Slave itself if the slave detects any failure
##
#############################################################################
itcl::body ::quartus::qSlave::postProcess {forceReturnStatus networkID} {
    putsDebug "*****Calling qSlave::postProces $networkID.*****"

    set workingDir $networkID-dir
    set status success

    if {[string equal $m_noCleanUp 0]} {
        # TODO: Put this into asynchronous mode if the deleting process takes long time.
        if {[file exists $workingDir]} {
            putsDebug "Deleting $workingDir."
            if {[catch {file delete -force $workingDir} err_msg]} {

                if {[file exists $workingDir]} {
                    if { ![info exists undeletedTempDir("$workingDir")] } {
                        set undeletedTempDir("$workingDir") 0
                    }
                    incr undeletedTempDir("$workingDir")
                    
                    if { $undeletedTempDir("$workingDir") <= 10 } {
                        putsDebug "Wait 5 second and retry to delete $workingDir ( $undeletedTempDir($workingDir) )"
                        after 5000 postProcess $forceReturnStatus $networkID
                    } else {
                        putsWarning "Unable to delete $workingDir directory."
                        unset undeletedTempDir("$workingDir")
                    }
                }
                # return -code error $err_msg
            }
        } else {
    	   # something is wrong.
            putsDebug "The working directory $workingDir doest not exist in post processing flow."
        }
    }
	cleanUpMasterInfo $networkID

    if {![string equal $forceReturnStatus 0]} {
        set status $forceReturnStatus
    }
    return $status
}

#############################################################################
## Method:  ::quartus::qSlave::preProcess
##
## Arguments: Network ID
##
## Description: (1) Create directory
##                 If directory exist, delete the directory.
##              (2) Check Quartus version
##              (3) Return FTP port
##              Caller:
##              (1) Master host
##
#############################################################################
itcl::body ::quartus::qSlave::preProcess {qVersion networkID} {
    putsDebug "*****Calling qSlave::preProcess $networkID $qVersion.*****"

    set workingDir $networkID-dir
    set status success

    # The directory should not exist is normal flow. If the directory exist,
    # something is wrong and it means the clean up job has not been done properly
    # in previous job.
    if {[file exists $workingDir]} {
        putsWarning "The working directory $workingDir exists in pre-processing flow."
        if {[catch {file delete -force $workingDir} err_msg]} {
            if {[file exists $workingDir]} {
                putsWarning "Unable to delete $workingDir directory."
            }
            # return -code error $err_msg
        }
	}
    # TODO: What if fail ?
	file mkdir [file join $m_workDir $workingDir]

    if {[string equal $qVersion ignoreQuartusVerCheck] || [string equal $qVersion $::quartus(version)]} {
        set status "$status $m_ftpListenPort $m_jobsLimit"
    } else {
        putsWarning "Slave is running a different version of Quartus II.\nSlave: $::quartus(version)\nMaster: $qVersion"
        set status "fail invalidVer"
    }
    return $status
}

#############################################################################
## Method:  ::quartus::qSlave::authUsrCmd
##
## Arguments: User name and password
##
## Description: Check user name and password.
##
#############################################################################
itcl::body ::quartus::qSlave::authUsrCmd {userName password} {
    putsDebug "*****Calling qSlave::authUsrCmd $userName $password.*****"
    if {[string equal $userName $m_ftpUserName] && [string equal $password $m_ftpPassword]} {
        return 1
    }
    return 0
}

#############################################################################
## Method:  ::quartus::qSlave::startDaemon
##
## Arguments: None.
##
## Description: Main API - Start the slave daemon.
##              (1) COMM port
##              (2) FTP port
##
#############################################################################

itcl::body ::quartus::qSlave::startDaemon {args} {

    putsDebug "*****Calling qSlave::start.*****"

    # update current directory the script directory.
    updateDir
    if {[string equal $m_workDir {}]} {
        set m_workDir $m_currentDir
    }

    # TODO: move this to base classs
    # Process arguments
    set options {-outputCallback -statusCallback}
    foreach {option value} $args {
        if {[lsearch -exact $options $option] != "-1" } {
            putsDebug "$option = $value"
            # Output example: all = -listenPort var = listenPort
            regexp -- {^-(.*)} $option all var
            # Construct the member dynamically. Therefore, options
            # name must be consistent with internal member variable.

            # Display value if not specify
            if {[string equal $value {}]} {
                set tmpVar m_$var
                return "[subst $[subst $tmpVar]]"
            } else {
                set m_$var $value
            }
        }
    }

    # Do not need to restore back since this is daemon
    renameBgerrorTo qSlaveBgerror

    cd $m_workDir
    putsInfo "$m_workDir is the working directory."

    # Tell me a little more in the command window
    putsInfo "Slave can run $m_jobsLimit job(s) concurrently"

    # Start slave daemon through comm.
    if {[catch {comm::comm config -port $m_listenPort -local 0} errMsg]} {
        return -code error "qSlave fails to listen on port $m_listenPort. Reason is $errMsg"
    } else {
        putsDebug "qSlave starts daemon successfully. Listen port is $m_listenPort."
    }

    # TODO: remove
    # comm::comm hook incoming {
    #    qSlaveObj debugCmd {puts "Channel     :$chan"}
    #    qSlaveObj debugCmd {puts "Socket      :$fid"}
    #    qSlaveObj debugCmd {puts "Address     :$addr"}
    #    qSlaveObj debugCmd {puts "Remode port :$remport"}
    # }
    comm::comm hook eval {

        set password [lindex [lindex $buffer end] end]
        set commPassword [qSlaveObj getCommPassword]

        if {![string equal $password $commPassword]} {
            # overwrite the command with return so that it won't do anything
            set buffer return
        }
        # skip return command
        if {![string equal $buffer return]} {

            if {[string equal $cmd async]} {

                # Debuging Purpose:
                # qSlaveObj debugCmd {puts "Socket     :$fid"}
                # qSlaveObj debugCmd {puts "Buffer     :$buffer"}
                # qSlaveObj debugCmd {puts "Command    :$cmd"}
                # qSlaveObj debugCmd {puts "Channel    :$chan"}
                # qSlaveObj debugCmd {puts "ID         :$id"}
                # qSlaveObj debugCmd {puts "[fconfigure $fid -peername]"}
                # set networkID [lindex [lindex $buffer end] end]
                # qSlaveObj debugCmd {puts "Network ID  :$networkID"}
                set networkID [lindex [lindex $buffer end] end-1]

                # Initialize all the incoming master info
                # networkID is unique across the network and among all the jobs
                # Fid is socket Id from Master
                # Id is Master Id contains port and IP information
                qSlaveObj initMasterInfo $networkID $fid $id
            }
        }
    }

    set useFTP [get_ini_var -name dq_use_ftp]

    if { ![string equal $useFTP ""] } {
        set useFTP [string tolower $useFTP]
        if { [string equal $useFTP on] || [string equal $useFTP true] } {
            set m_useFTP 1
        }
    }

    # Mawardi: qTransfer setup
    ##########################
    ## Setup sendFile server
    ##########################
    if {[string equal $m_useFTP 0]} {
        set i 0
        set stat 0
        set callback "qSlaveObj serverCallback"
        while {$i < 11 && $stat == 0} {
            set stat [qTransferObj TH_ChannelHandler type=server port=$m_ftpListenPort workingDirectory=$m_workDir callback=$callback]

            if { $stat } {
                putsDebug "qSlave starts sendFile daemon successfully. Listen port is $m_ftpListenPort."
                break
            }

            incr i
            incr m_ftpListenPort
        }
        if { $stat == 0} {
           return -code error "Slave fails to listen on port $m_ftpListenPort!"
        }
    } else {
        ###################
        ## Setup FTP server
        ###################
        set ::ftpd::port $m_ftpListenPort
        # set the current ftp directory
        set ::ftpd::cwd $m_workDir

        # Configure ftp server
        ::ftpd::config -authUsrCmd {qSlaveObj authUsrCmd} -authFileCmd {qSlaveObj authFileCmd} -logCmd {qSlaveObj ftpLogCmd}

        # Try 10 times incase the port has been used by someone else.
        set i 0
        while {$i < 11} {
            # Start ftp daemon
            if {[catch {::ftpd::server} errMsg]} {
                if {[string equal $i 10]} {
                    return -code error "Slave fails to listen on port $m_ftpListenPort. Reason is $errMsg"
                } else {
                    incr i
                    incr m_ftpListenPort
                    set ::ftpd::port $m_ftpListenPort
                }
            } else {
                putsDebug "qSlave starts ftp daemon successfully. Listen port is $m_ftpListenPort."
                break
            }
        }
    }

    putsInfo "Slave starts daemon successfully in [info hostname]. Listen port is $m_listenPort."
    # Go into event loop
    vwait forever
    return
}

#############################################################################
## Method:  ::quartus::qSlave::initMasterInfo
##
## Arguments: Network ID, socket and master ID
##
## Description: Initialize master information when master is connecting to
##              slave.
##
#############################################################################
itcl::body ::quartus::qSlave::initMasterInfo {networkID sock masterID} {

    # get the master socket
    putsDebug "*****Calling qSlave::initMasterInfo $networkID $sock $masterID.*****"

    # Skip if the master has connected at least once to this slave.
    if {[info exist "m_masterInfo($networkID listenPort)"] &&       \
        [info exist "m_masterInfo($networkID ip)"] &&               \
        [info exist "m_masterInfo($networkID host)"]} {
        putsDebug "-------------networkID:$networkID exists in masterInfo.----------------"
    } else {
        # Master Host Name and IP address
        set peerName [fconfigure $sock -peername]
        set ip [lindex $peerName 0]
        set host [lindex $peerName 1]
        # Master Listen port
        set listenPort [lindex $masterID 0]

        # set "m_masterInfo($networkID sock)" $sock
        set "m_masterInfo($networkID listenPort)" $listenPort
        set "m_masterInfo($networkID ip)" $ip
        set "m_masterInfo($networkID host)" $host

        putsDebug "Receive Job ID $networkID from master host $m_masterInfo($networkID host)."

        incr m_currentJobsCount
    }
    putsDebug "Network ID          : $networkID"
    # putsDebug "Master socket       : $m_masterInfo($networkID sock)"
    putsDebug "Master listen port  : $m_masterInfo($networkID listenPort)"
    putsDebug "Master IP address   : $m_masterInfo($networkID ip)"
    putsDebug "Master host Name    : $m_masterInfo($networkID host)"

    return
}
#############################################################################
## Method:  ::quartus::qSlave::cleanUpMasterInfo
##
## Arguments:: Network ID
##
## Description: Release all the variables.
##
#############################################################################
itcl::body ::quartus::qSlave::cleanUpMasterInfo {networkID} {
    putsDebug "*****Calling qSlave::cleanUpMasterInfo $networkID.*****"
    set hostName $m_masterInfo($networkID host)

    # Remove the catch statement to catch any unexpected error
    catch {unset "m_masterInfo($networkID listenPort)"}
    catch {unset "m_masterInfo($networkID ip)"}
    catch {unset "m_masterInfo($networkID host)"}
    catch {unset "m_masterInfo($networkID callbackCmd)"}
    catch {unset "m_masterInfo($networkID remoteCmd)"}

    reduceCurrentJobsCount
    # Bugs becareful man to use unset m_masterInfo
     if {![string equal $m_statusCallback {}]} {
        eval "$m_statusCallback $networkID $hostName jobReleased"
    }
    putsDebug "Job ID $networkID is released."
    return
}

#############################################################################
## Method:  ::quartus::qSlave::remoteCmd
##
## Arguments:: Method name, callback method to master and network ID
##
## Description: Remote command from master.
##
#############################################################################
itcl::body ::quartus::qSlave::remoteCmd {procCmd callbackCmd networkID args} {
    putsDebug "*****Calling qSlave::remoteCmd $procCmd $callbackCmd $networkID $args.*****"

    set status "fail remoteCmd"
    set masterListenPort $m_masterInfo($networkID listenPort)
    set masterIpAddr $m_masterInfo($networkID ip)
    # This callbacked command is needed when the $procCmd is running in async mode.
    # Example: Spawning a process.
    set "m_masterInfo($networkID callbackCmd)" $callbackCmd
    set "m_masterInfo($networkID remoteCmd)" $procCmd

    # if if over jobs Limit ?
    if {$m_currentJobsCount <= $m_jobsLimit} {
        putsDebug "Receive command:$procCmd from master host $m_masterInfo($networkID host)."

        if {![string equal $m_statusCallback {}]} {
            eval "$m_statusCallback $networkID $m_masterInfo($networkID host) [lindex $procCmd 0]"
        }

        # The $procCmd will return success or fail.
        if {[catch {set status [eval $procCmd $networkID]} errMsg]} {
            putsDebug "$networkID Slave failed to execute remote command:$procCmd. The error message is $errMsg."
            set status "fail remoteCmd"
        }
        putsDebug "The return status of $procCmd is $status."
    } else {
        putsInfo "Unable to perform Job $networkID. This jobs limit is set to $m_jobsLimit."
        set status "fail slaveBusy"
    }

    # If status is fail, do clean up.
    if {[string equal [lindex $status 0] fail] && ![string equal [lindex $procCmd 0] postProcess]} {
        postProcess 0 $networkID
    }

    # If status is notDone, the procedure will run the callback automatically after completion.
    if {![string equal [lindex $status 0] notDone]} {
        putsDebug "Running callback command:$callbackCmd $networkID $status."
        comm::comm send -async "$masterListenPort $masterIpAddr" "qMasterObj $callbackCmd $networkID $status $m_commPassword"
    }
    # Because the protocol is asynchronously, the return result is not important.
    return
}


#############################################################################
## Method:  ::quartus::qSlave::spawnProcess
##
## Arguments:: Command to spawn and network ID
##
## Description: Spawn a process with a given command.
##
#############################################################################
itcl::body ::quartus::qSlave::spawnProcess {cmd networkID} {

    putsDebug "*****Calling qSlave::spawnProcess $cmd $networkID.*****"
    set processPipe [open [concat | $cmd] r]
    fconfigure $processPipe -buffering none -blocking 0
   
    set processPid [pid $processPipe]
    set "m_pipeJobsInfo($networkID pipe)" $processPipe

    putsDebug "The process Pipe is $processPipe."
    putsDebug "The process PID is $processPid."

    set processCallback [list spawnProcessCallback $processPipe $networkID]
    fileevent $processPipe readable "qSlaveObj $processCallback"

    return notDone
}
#############################################################################
## Method:  ::quartus::qSlave::spawnProcessCallback
##
## Arguments:: Pipe and Network ID
##
## Description: Spawn process callback.
##
#############################################################################
itcl::body ::quartus::qSlave::spawnProcessCallback {pipe networkID} {

    # This will be call many times as long as the pipe is readable, so disable debug message.
    # putsDebug "*****Calling qSlave::spawnProcessCallback $pipe $networkID.*****"
    if {[eof $pipe]} {

        # Prepare to run callback
        set masterListenPort $m_masterInfo($networkID listenPort)
        set masterIpAddr $m_masterInfo($networkID ip)
        set callbackCmd $m_masterInfo($networkID callbackCmd)
        set remoteCmd $m_masterInfo($networkID remoteCmd)
        set result success

        catch {fileevent $pipe readable {}}
        # Check to determine whether the process has been run successfully.
        if {[catch {close $pipe} errMsg]} {
             putsDebug "$networkID Slave failed to execute remote command:$remoteCmd. The error message is $errMsg."
             set result "fail remoteCmd"
            if {![string equal [lindex $remoteCmd 0] postProcess]} {
                postProcess 0 $networkID
            }
        }

        unset "m_pipeJobsInfo($networkID pipe)"
        # Bugs becareful man - please don't do this -> unset m_pipeJobsInfo

        putsDebug "Running callback command:$callbackCmd $networkID $result."
        comm::comm send -async "$masterListenPort $masterIpAddr" "qMasterObj $callbackCmd $networkID $result $m_commPassword"
        return
    }

    # Read out unnesessary data.
    if {[catch {gets $pipe output} errMsg]} {
        catch {fileevent $pipe readable {}}
        catch {close $pipe}
        return -code error errMsg
    } else {
        # TODO: Unless we want the output of the spawning process.
        # puts $output
    }
    return
}

#############################################################################
## Method:  ::quartus::qSlave::startRemoteCommand
##
## Arguments: Command name and network ID
##
## Description: Start the remote command.
##
#############################################################################
itcl::body ::quartus::qSlave::startRemoteCommand {commandName networkID} {
    putsDebug "*****Calling qSlave::startRemoteJob $commandName networkID.*****"

    set fileDirName [file join $m_workDir $networkID-dir]
    cd $fileDirName
    spawnProcess $commandName $networkID
    cd $m_workDir
    return notDone
}

#############################################################################
## Method:  ::quartus::qSlave::startRemoteJob
##
## Arguments: Script name and network ID
##
## Description: Spawn a process to kick off the job. When the process is done,
##              it will notify the master automatically.
##
#############################################################################
itcl::body ::quartus::qSlave::startRemoteJob {scriptName networkID} {

    return code -error "qSlave::startRemoteJob is obsolete"
    putsDebug "*****Calling qSlave::startRemoteJob $scriptName networkID.*****"

    set fileDirName [file join $m_workDir $networkID-dir]
    cd $fileDirName
    spawnProcess [list quartus_sh -t $scriptName] $networkID
    cd $m_workDir
    return notDone
}

#############################################################################
## Method:  ::quartus::qSlave::archiveProject
##
## Arguments:: File name with no path, project name and network ID
##
## Description: Archive the project.
##              (1) Create a tcl file.
##              (2) Spawn a process to run the tcl file.
##
#############################################################################
itcl::body ::quartus::qSlave::archiveProject {fileName projName networkID} {

    return code -error "qSlave::archiveProject is obsolete"

    putsDebug "*****Calling qSlave::archiveProject $projName $networkID.*****"

    set fileDirName [file join $m_workDir $networkID-dir]
    # cd to the networkID directory.
    cd $fileDirName
    putsDebug "Tcl file name is $m_archiveTclFileName"

    set tclFile [open $m_archiveTclFileName w]
    puts $tclFile "package require ::quartus::project"
    puts $tclFile "project_open $projName"
    puts $tclFile "project_archive $fileName -include_outputs"
    puts $tclFile "project_close"

    close $tclFile
    # The reason spawning a process is to make sure everything in asychronous mode.
    spawnProcess [list quartus_sh -t $m_archiveTclFileName] $networkID
    cd $m_workDir
    return notDone
}

#############################################################################
## Method:  ::quartus::qSlave::stopRemoteJob
##
## Arguments: Network ID
##
## Description: Stop the all jobs that are running on slave.
##
#############################################################################
itcl::body ::quartus::qSlave::stopRemoteJob {networkID} {
    putsDebug "*****Calling qSlave::stopRemoteJob $networkID.*****"

    global tcl_platform

    if {[info exist "m_pipeJobsInfo($networkID pipe)"]} {

        set pipePid [pid $m_pipeJobsInfo($networkID pipe)]
		# Some notes:
        # To call MKS kill:
		#     kill -SIGKILL $q_server_quartus_pid
		# To call future native TCL API:
		#     pid termiate $q_server_quartus_pid
        # Do not use exec as it blocks other master connects to this slave
        if {[string equal $tcl_platform(platform) windows]} {
            set killqPath [file join $quartus(binpath) "killq.exe"]
            if {[file exists $killqPath]} {
                catch {exec $killqPath -t $pipePid}
            }
            # set commandName "killq -t $pipePid"
        } else {
            catch {exec kill $pipePid}
            # set commandName "kill $pipePid"
        }
        # spawnProcess $commandName -1
        # callback will be handle by spawnProcessCallback
        # pipe variable will be unset by spawnProcessCallback
        
        postprocess 0 $networkID
    } else {
        putsDebug "Nothing to stop."
    }
    return notDone
}

#############################################################################
## Method:  ::quartus::qSlave::restoreProject
##
## Arguments:: File name with no path and network ID
##
## Description: Restore the project. 
##              (1) Create a tcl file.
##              (2) Spawn a process to run the tcl file.
##
#############################################################################
itcl::body ::quartus::qSlave::restoreProject {fileName networkID} {

    return code -error "qSlave::restoreProject is obsolete"

    putsDebug "*****Calling qSlave::restoreProject $fileName $networkID.*****"

    set fileDirName [file join $m_workDir $networkID-dir]
    putsDebug "File to restore to is $fileName"

    cd $fileDirName
    putsDebug "Tcl file name is $m_restoreTclFileName"

    set tclFile [open $m_restoreTclFileName w]
    puts $tclFile "package require ::quartus::project"
    puts $tclFile "project_restore $fileName -destination . -overwrite"
    close $tclFile
    # The reason spawning a process is to make sure everything in asychronous mode.
    spawnProcess [list quartus_sh -t $m_restoreTclFileName] $networkID
    cd $m_workDir
    return notDone
}

#############################################################################
##  Global Static Objects
#############################################################################

proc qSlaveBgerror {args} {
    puts "There is a background error. The return error message is $args."
    qSlaveObj resetCurrentJobsCount
}

::quartus::qSlave qSlaveObj

