
#############################################################################
##  qmaster-lib.tcl - v1.0
##
##  Quartus Master Library Package
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

package provide ::quartus::qMaster 2.0

package require ::quartus::qNetwork 1.0
package require ftp 2.4
package require cksum 1.0.1
package require log 1.0.2

package require ::quartus::qTransfer 1.0

#############################################################################
## Class:   ::qNetwork::qMaster
##
## Description: qMaster Class.
##
#############################################################################
itcl::class ::quartus::qMaster {
    inherit qNetwork
    constructor {{debugMode 0}} {qNetwork::constructor $debugMode} {
        putsDebug "qMaster constructor is called."
        array set m_JobOrders {}
        array set m_slavesInfo {}
        array set m_uniqueSlavesInfo {}

        set m_slavesList {}
        set m_useFTP 0
        set m_totalJobs 0
        set m_totalSlaves 0
        set m_networkCompile notDone
        set m_stopJobs 0
        set m_poolEventID {}
        set m_resultDir {}
        set m_enableSubResultDir 0
        set m_LSFMode 0
        set m_LSFQueue {}
        set m_LSFCluster LSFCluster

        set m_returnStatus 1
        set m_failsLimit 2
        set m_quartusPath {}
        set m_skipDuplicateSlave 1
        set m_verCheck 1
    }
    destructor {
        putsDebug "qMaster destructor is called."
    }
    ###########################
    ## Public APIs
    ###########################

    public method submitJobs {{args {}}}
    public method stopJobs {}
    public method setResultDir {dir}
    public method setTotalJobs {total} {puts "******* Warning: qMasterObj setTotalJobs is obsolete *******"}
    public method setLSFMode {mode} {set m_LSFMode $mode}
    public method setLSFQueue {queueName} {set m_LSFQueue $queueName}
    public method getLSFMode {} {return $m_LSFMode}
    public method setFailsLimit {limit} {set m_failsLimit $limit}

    public method addUploadFile {jobID fileName}
    public method addJobCommand {jobID command}
    public method addDownloadFile {jobID fileName}
    public method addSlaveID {hostName args}
    public method pingSlaveID {hostName}

    public method clearSlavesID {}
    public method clearJobsID {}

    public method startNetworkJobs {}
    public method startNetworkCompile {networkID}
    public method networkCompileComplete {networkID status args}
    public method genericRemoteCallback {networkID status args}

    # LSF
    public method LSFStartNetworkJobs {{submitOneJob {0}}}
    public method LSFStartNetworkCompile {networkID}
    public method LSFNetworkCompileComplete {networkID status args}
    public method spawnProcessCallback {pipe networkID}

    public method ftpCommandCallback {networkID args}
    public method ftpProgressCallback {networkID args}
    public method sendFileCommandCallback {networkID status details}

    public method checkSlavesStatus {}
    public method getSlaveQuartusVer {hostName}
    public method jobToSlave {jobID hostName}
    public method disableVerCheck {} {set m_verCheck 0}
    public method enableVerCheck {} {set m_verCheck 1}
    
    # Called by qMaster UI so far
    public method disableSubResultDir {} {set m_enableSubResultDir 0}
    public method enableSubResultDir {} {set m_enableSubResultDir 1}

    public method getSlaveJobsLimit {hostName}

    ###########################
    ## Protected APIs
    ###########################
    protected method getPendingJob {}
    protected method isLSFRunning {}
    protected method getjobID {networkID}
    protected method generateNetworkID {slaveID jobID}
    protected method setupEnvironment {}
    protected method isAllJobsDone {}
    protected method initJobsOrder {jobID}
    protected method initSlavesInfo {slaveID}
    protected method initNetworkFlow {}
    protected method spawnProcess {cmd networkID}

    ###########################
    ## Data Members
    ###########################
    # Jobs order array, slaves array, network Flow array
    protected variable m_jobOrders
    protected variable m_totalJobs
    # Slave can be repeated in this array
    protected variable m_slavesInfo
    # Slave cannot be repeated in this array
    protected variable m_uniqueSlavesInfo
    protected variable m_totalSlaves
    protected variable m_networkFlow
    protected variable m_skipDuplicateSlave

    # List of slaves hosts
    protected variable m_slavesList

    # Exit Script to call when all the jobs complete
    protected variable m_exitScript
    protected variable m_stopJobs
    # Pool Event ID is used to check the slaves status(alive or down)
    protected variable m_poolEventID
    protected variable m_resultDir
    protected variable m_enableSubResultDir

    protected variable m_returnStatus
    protected variable m_failsLimit
    protected variable m_useFTP
    protected variable m_LSFMode
    protected variable m_LSFQueue
    protected variable m_LSFCluster
    protected variable m_quartusPath

    protected variable m_verCheck
}

#############################################################################
## Method:  ::quartus::qMaster::jobToSlave
##
## Arguments: Job ID, Host name
##
## Description: Assign a job to a specific slave.
##
#############################################################################
itcl::body ::quartus::qMaster::jobToSlave {jobID hostName} {
    putsDebug "*****Calling qMaster::jobToSlave $jobID $hostName.*****"

    set splitResult [split $hostName :]
    set slave [lindex $splitResult 0]
    set listenPort [lindex $splitResult 1]

    if {[string equal $listenPort {}]} {
        set listenPort $m_slaveListenPort
    }

    set "m_jobOrders($jobID hostAssignment)" $slave:$listenPort

    return
}


#############################################################################
## Method:  ::quartus::qMaster::getSlaveQuartusVer
##
## Arguments: Host name
##
## Description: Return Quartus version for this slave.
##
#############################################################################
itcl::body ::quartus::qMaster::getSlaveQuartusVer {hostName} {
    putsDebug "*****Calling qMaster::getSlaveQuartusVer $hostName.*****"

    set splitResult [split $hostName :]
    set slave [lindex $splitResult 0]
    set listenPort [lindex $splitResult 1]

    if {[string equal $listenPort {}]} {
        set listenPort $m_slaveListenPort
    }
    # Synchronous comm send
    if {[catch {set result [comm::comm send "$listenPort $slave" "qSlaveObj getQuartusVersion $m_commPassword"]} errMsg]} {
        set result 0
    }
   
    return $result
}

#############################################################################
## Method:  ::quartus::qMaster::getSlaveJobsLimit
##
## Arguments: Host name
##
## Description: Return Jobs Limit for this slave.
##
#############################################################################
itcl::body ::quartus::qMaster::getSlaveJobsLimit {hostName} {
    putsDebug "*****Calling qMaster::getSlaveJobsLimit $hostName.*****"

    set splitResult [split $hostName :]
    set slave [lindex $splitResult 0]
    set listenPort [lindex $splitResult 1]

    if {[string equal $listenPort {}]} {
        set listenPort $m_slaveListenPort
    }
    # Synchronous comm send
    if {[catch {set result [comm::comm send "$listenPort $slave" "qSlaveObj getJobsLimit $m_commPassword"]} errMsg]} {
        set result 0
    }
    return $result
}

#############################################################################
## Method:  ::quartus::qMaster::setupEnvironment
##
## Arguments: None
##
## Description: 1) Setup the uniqueSlaveInfo array.
##              2) Initialize jobs array
##
#############################################################################
itcl::body ::quartus::qMaster::setupEnvironment {} {
    putsDebug "*****Calling qMaster::setupEnvironment.*****"
    # global tcl_platform
    # global env

	# if {![string equal $tcl_platform(platform) windows] && [string equal $m_LSFMode 1]} {
    #    if {[info exist "env(QUARTUS_ORIG_PATH)"]} {
    #        set m_quartusPath $env(PATH)
    #        set env(PATH) $env(QUARTUS_ORIG_PATH)
    #    }
    # }
    set slaveID 0
    # go through each slavelist and initialize the array
    foreach slaveFullAddr $m_slavesList {
        # how many ftp process on this slave ?
        set "m_uniqueSlavesInfo($slaveFullAddr ftpGetPutCount)" 0
        # is Jobs Limit setup already been performed ?
        # We only need to initialize this first time. Setup Jobs limit will add slave into the
        # m_slavesList.
        if {![info exist "m_uniqueSlavesInfo($slaveFullAddr setupJobsLimit)"]} {
            set "m_uniqueSlavesInfo($slaveFullAddr setupJobsLimit)" notDone
        }

        # Do not call this also never mind, we can actually used the previous status
        initSlavesInfo $slaveID

        incr slaveID
    }

    # Remember that the add jobID API will not initialize this.
    # for {set jobID 0} {$jobID < $m_totalJobs} {incr jobID} {
    # }

    set m_totalJobs 0
    # Remember that the add jobID API will not initialize this.
    foreach index [array names m_jobOrders *commands] {
        set jobID [lindex $index 0]

        incr m_totalJobs
        set "m_jobOrders($jobID numFails)" 0

        # decare these variable if not exist
        # commands
        if {![info exist "m_jobOrders($jobID commands)"]} {
            set "m_jobOrders($jobID commands)" ""
        }
        if {![info exist "m_jobOrders($jobID totalRemoteCmds)"]} {
            set "m_jobOrders($jobID totalRemoteCmds)" 0
        }
        # Upload files
        if {![info exist "m_jobOrders($jobID uploadFiles)"]} {
            set "m_jobOrders($jobID uploadFiles)" ""
        }
        if {![info exist "m_jobOrders($jobID totalUploadFiles)"]} {
            set "m_jobOrders($jobID totalUploadFiles)" 0
        }
        # download files
        if {![info exist "m_jobOrders($jobID downloadFiles)"]} {
            set "m_jobOrders($jobID downloadFiles)" ""
        }
        if {![info exist "m_jobOrders($jobID totalDownloadFiles)"]} {
            set "m_jobOrders($jobID totalDownloadFiles)" 0
        }
        if {![info exist "m_jobOrders($jobID hostAssignment)"]} {
            set "m_jobOrders($jobID hostAssignment)" 0
        }


        initJobsOrder $jobID
    }

    initNetworkFlow

    # puts [array get m_uniqueSlavesInfo]
    return
}

#############################################################################
## Method:  ::quartus::qMaster::addJobCommand
##
## Arguments: Job ID and command
##
## Description: Add remote command to this Job ID.
##
#############################################################################
itcl::body ::quartus::qMaster::addJobCommand {jobID command} {
    putsDebug "*****Calling qMaster::addJobCommand $jobID $command.*****"
    # TODO: multiple commands is not tested
    lappend "m_jobOrders($jobID commands)" $command
    set "m_jobOrders($jobID totalRemoteCmds)" [llength $m_jobOrders($jobID commands)]
    return
}
#############################################################################
## Method:  ::quartus::qMaster::addDownloadFile
##
## Arguments: Job ID and file name
##
## Description: File to download from slave.
##              (1) Set total number of files to download
##
#############################################################################
itcl::body ::quartus::qMaster::addDownloadFile {jobID fileName} {
    putsDebug "*****Calling qMaster::addDownloadFile $jobID $fileName.*****"

    # The fileName cannot have directory
    set fileNameD [file tail $fileName]

    lappend "m_jobOrders($jobID downloadFiles)" $fileName
    set "m_jobOrders($jobID totalDownloadFiles)" [llength $m_jobOrders($jobID downloadFiles)]

    # Debugging purpose:
    # putsDebug "Job orders:[array get m_jobOrders]."
    # putsDebug "Total Jobs:$m_totalJobs."
    # vwait forever
    return
}

#############################################################################
## Method:  ::quartus::qMaster::addUploadFile
##
## Arguments: Job ID and File Name
##
## Description: File to upload to slave.
##              (1) Set total number of files to upload
##
#############################################################################

itcl::body ::quartus::qMaster::addUploadFile {jobID fileName} {

    putsDebug "*****Calling qMaster::addUploadFile $jobID $fileName.*****"
    # Support relative path
    set fileNameD [getFullDirFileName $fileName]

    # Support wildcard
    if {[file exist $fileNameD] && [file isfile $fileNameD]} {
        foreach fileList [glob -nocomplain $fileNameD] {
            set eachFileNameD $fileList
            lappend "m_jobOrders($jobID uploadFiles)" $eachFileNameD
            set "m_jobOrders($jobID totalUploadFiles)" [llength $m_jobOrders($jobID uploadFiles)]
        }
    } else {
        return -code error "qMaster::addUploadFile has invalid file name: $fileName as argument."
    }
    # Debugging purpose:
    # putsDebug "Job orders:[array get m_jobOrders]."
    # putsDebug "Total Jobs:$m_totalJobs."
    return
}



#############################################################################
## Method:  ::quartus::qMaster::setResultDir
##
## Arguments: None
##
## Description: All the results will be stored in this directory.
##
#############################################################################

itcl::body ::quartus::qMaster::setResultDir {dir} {
    putsDebug "*****Calling qMaster::setResultDir $dir.*****"

    if {![file exists $dir]} {
        # TODO: Unable to create the directory ?
        file mkdir $dir
	}

	if {[file isdirectory $dir]} {
	   set dir [getFullDirFileName $dir]
	   set m_resultDir $dir
	} else {
	   set m_resultDir {}
	}
    return
}

#############################################################################
## Method:  ::quartus::qMaster::checkSlavesStatus
##
## Arguments: None
##
## Description: Check the slaves status.
##              (1) Update the current slave status.
##              (2) If the slave is running a job and the slave is down,
##                  restart the job.
##
#############################################################################

itcl::body ::quartus::qMaster::checkSlavesStatus {} {
    putsDebug "*****Calling qMaster::checkSlavesStatus.*****"

    for {set slaveID 0} {$slaveID < $m_totalSlaves} {incr slaveID} {
        # TODO: replace this by calling pingSlaveID
        if {[catch {comm::comm send -async "$m_slavesInfo($slaveID listenPort) $m_slavesInfo($slaveID host)" "return"} errMsg]} {
            putsDebug "Master failed to connect $m_slavesInfo($slaveID host). The error message is $errMsg."
            # If the slave come alive again, the callbackproc from the slave will be invalid because
            # the networkID is unidentified.

            set "m_slavesInfo($slaveID status)" down
            set jobID $m_slavesInfo($slaveID jobID)
            # This slave is running a job.
            if {![string equal $jobID -1]} {
                set networkID $m_jobOrders($jobID networkID)
                set networkFlowID $m_jobOrders($jobID networkFlowID)
                set networkFlowCmd $m_networkFlow($networkFlowID)

                # Restart the job
                if {![string equal $networkFlowCmd invalidFlow]} {
                    networkCompileComplete $networkID fail slaveDown
                }
            }
        } else {
            set "m_slavesInfo($slaveID status)" alive
        }
    }
    # pool every 5 minutes
    set m_poolEventID [after 300000 {qMasterObj checkSlavesStatus}]

    return
}

#############################################################################
## Method:  ::quartus::qMaster::stopJobs
##
## Arguments: None
##
## Description: Stop all the jobs. The jobs will wait until all the current
##              jobs finish on all the slaves.
##
#############################################################################

itcl::body ::quartus::qMaster::stopJobs {} {
    putsDebug "*****Calling qMaster::stopJobs.*****"
    set m_stopJobs 1
    if {[string equal $m_LSFMode 1]} {
        global env
        set killCmd [file join $env(LSF_BINDIR) bkill]
        # Go through each job Id and search for the pending job
        # for {set jobID 0} {$jobID < $m_totalJobs} {incr jobID} {
        # }
        foreach index [array names m_jobOrders *commands] {
            set jobID [lindex $index 0]
            
            if {[string equal $m_jobOrders($jobID status) $m_LSFCluster]} {
                catch {[exec $killCmd -J $m_jobOrders($jobID networkID)]}
            }
        }
    } else {
        for {set slaveID 0} {$slaveID < $m_totalSlaves} {incr slaveID} {
            set jobID $m_slavesInfo($slaveID jobID)
            if {![string equal $jobID -1]} {
                set networkID $m_jobOrders($jobID networkID)
                set networkFlowID $m_jobOrders($jobID networkFlowID)

                set networkFlowCmd $m_networkFlow($networkFlowID)
                if {[string equal $networkFlowCmd compileFlow]} {
                    if {[catch {comm::comm send -async "$m_slavesInfo($slaveID listenPort) $m_slavesInfo($slaveID host)" "qSlaveObj remoteCmd {stopRemoteJob} genericRemoteCallback $networkID $m_commPassword"} errMsg]} {
                        putsError "Master failed to connect $m_slavesInfo($slaveID host). The error message is $errMsg."
                        set "m_slavesInfo($slaveID status)" down
                        networkCompileComplete $networkID fail slaveDown
                    }
                }
            }
        }
    }
    return
}


#############################################################################
## Method:  ::quartus::qMaster::clearSlaveID
##
## Arguments: None
##
## Description: Clean up all the slaves information.
##              This procedure has to be called by the caller of addSlaveID.
##
#############################################################################

itcl::body ::quartus::qMaster::clearSlavesID {} {

    putsDebug "*****Calling qMaster::clearSlavesID.*****"
    # set slaveID 0
    # foreach slave $m_slavesList {
    #    unset "m_slavesInfo($m_totalSlaves host)"
    #    unset "m_slavesInfo($m_totalSlaves listenPort)"
    #    unset "m_slavesInfo($m_totalSlaves ftpListenPort)"
    #    unset "m_slavesInfo($m_totalSlaves status)"
    #    unset "m_slavesInfo($m_totalSlaves jobID)"
    #    unset "m_slavesInfo($m_totalSlaves ftpStatus)"
    #    incr slaveID
    # }
    catch {unset m_slavesInfo}
    catch {unset m_uniqueSlavesInfo}

    array set m_slavesInfo {}
    array set m_uniqueSlavesInfo {}
    set m_slavesList {}
    set m_totalSlaves 0

    return
}

#############################################################################
## Method:  ::quartus::qMaster::addSlaveID
##
## Arguments: hostName:listenPort
##
## Description: Args specifies one or more slaves. If listenPort is not
##              specified, use the default slave listen port.
##
#############################################################################

itcl::body ::quartus::qMaster::addSlaveID {hostName args} {

    putsDebug "*****Calling qMaster::addSlaveID $hostName $args.*****"

    set hostNames [concat $hostName $args]

    foreach slaveFullAddr $hostNames {
        # split the inet adresss from address:port address port
        set splitResult [split $slaveFullAddr :]
        set slave [lindex $splitResult 0]
        set listenPort [lindex $splitResult 1]

        # Set to default listen port if not specified
        if {[string equal $listenPort {}]} {
            set listenPort $m_slaveListenPort
        }
        set slaveFullAddr $slave:$listenPort
        putsDebug "$slaveFullAddr -> $slave $listenPort"

        # extra checking make sure the no duplicate host name
        # if m_skipDuplicateSlave == 1, skip the duplicated slave.
        # m_skipDuplicateSlave is used internally and user should not add duplicate slaves.
        if {[string equal [lsearch -exact $m_slavesList $slaveFullAddr] -1] || [string equal $m_skipDuplicateSlave 0]} {
            set m_slavesList [concat $m_slavesList $slaveFullAddr]

            set "m_slavesInfo($m_totalSlaves host)" $slave
            set "m_slavesInfo($m_totalSlaves listenPort)" $listenPort
            # Important Notes: Do not remove this even though
            # All the initialization work will be done by setupEnvironment
            # addSlaveID will be called in the halftway of the flow to add more slaves in order to support the jobs limit stuff.
            initSlavesInfo $m_totalSlaves
            # set "m_slavesInfo($m_totalSlaves ftpListenPort)" -1
            # set "m_slavesInfo($m_totalSlaves status)" alive
            # set "m_slavesInfo($m_totalSlaves jobID)" -1
            # set "m_slavesInfo($m_totalSlaves ftpStatus)" none
            incr m_totalSlaves
         } else {
            # or should I siliently ignore ?
            puts "Warning: Slave $slaveFullAddr already exists. Skip adding this slave."
         }
    }

    # Debugging Purpose
    # puts "Slaves list: $m_slavesList."
    # puts "Total slaves: $m_totalSlaves."
    # clearSlavesID
    # puts [array get m_slavesInfo]
    return
}

#############################################################################
## Method:  ::quartus::qMaster::pingSlaveID
##
## Arguments: hostName:listenPort
##
## Description: Return 0 if the host is unreachable.
##              Return 1 if the host is reachable.
##
#############################################################################

itcl::body ::quartus::qMaster::pingSlaveID {hostName} {

    putsDebug "*****Calling qMaster::pingSlaveID $hostName *****"
    set status 0
    set slaveFullAddr $hostName
    # split the inet adresss from address:port address port
    set splitResult [split $slaveFullAddr :]
    set slave [lindex $splitResult 0]
    set listenPort [lindex $splitResult 1]

    # Set to default listen port if not specified
    if {[string equal $listenPort {}]} {
        set listenPort $m_slaveListenPort
    }
    set slaveFullAddr $slave:$listenPort
    putsDebug "$slaveFullAddr -> $slave $listenPort"

    if {[catch {comm::comm send -async "$listenPort $slave" "return"} errMsg]} {
        putsDebug "Master failed to connect $slave. The error message is $errMsg."
        set status 0
    } else {
        set status 1
    }
    return $status
}

#############################################################################
## Method:  ::quartus::qMaster::clearJobsID
##
## Arguments: None
##
## Description: Do clean up before exit.
##
#############################################################################

itcl::body ::quartus::qMaster::clearJobsID {} {
    putsDebug "*****Calling qMaster::clearJobsID.*****"

    # for {set jobID 0} {$jobID < $m_totalJobs} {incr jobID} {
    #    unset "m_jobOrders($jobID uploadFiles)"
    #    unset "m_jobOrders($jobID totalUploadFiles)"
    #    unset "m_jobOrders($jobID downloadFiles)"
    #    unset "m_jobOrders($jobID totalDownloadFiles)"
    #
    #    unset "m_jobOrders($jobID status)"
    #    unset "m_jobOrders($jobID networkID)"
    #    unset "m_jobOrders($jobID slaveID)"
    #    unset "m_jobOrders($jobID networkFlowID)"
    #    unset "m_jobOrders($jobID ftpHandle)"
    #    unset "m_jobOrders($jobID ftpStatus)"
    #    unset "m_jobOrders($jobID resultFileSize)"
    #    unset "m_jobOrders($jobID numUploadFiles)"
    #    unset "m_jobOrders($jobID numDownloadFiles)"
    #
    #    unset "m_jobOrders($jobID numRemoteCmds)"
    #    unset "m_jobOrders($jobID totalRemoteCmds)"
    # }
    catch {unset m_jobOrders}

    array set m_jobOrders {}
    set m_totalJobs 0

    return
}


#############################################################################
## Method:  ::quartus::qMaster::generateNetworkID
##
## Arguments: Slave ID and Job ID
##
## Description: Generate network ID from slave ID and job ID.
##              Network ID is unique anywhere across the network.
##              All the communication is based on this network ID.
##              Network ID is generated from:
##              (1) Slave's host & comm/ftp listen port(for non-LSF)
##              (2) Master host & listen port
##              (3) Upload files name
##              (4) Current time
##
#############################################################################

itcl::body ::quartus::qMaster::generateNetworkID {slaveID jobID} {
    putsDebug "*****Calling qMaster::generateNetworkID $slaveID $jobID.*****"

    if {![string equal $slaveID $m_LSFCluster]} {
        # set networkID "$m_slavesInfo($slaveID host)$m_slavesInfo($slaveID listenPort)$m_slavesInfo($slaveID ftpListenPort)[info hostname]$m_listenPort$jobID$slaveID"
        set networkID "$m_slavesInfo($slaveID host)$m_slavesInfo($slaveID listenPort)[info hostname]$m_listenPort$jobID$slaveID"
    } else {
        # put initial v to avoid network id that start with - (e.g. -1232343) it will error out by crc::cksum
        set networkID v
    }

    putsDebug "First network ID is $networkID."
    # Too expensive
    # set fileCksum [crc::cksum -file $m_jobOrders($jobID qarFileName)]
    # set fileCksum [file size $m_jobOrders($jobID qarFileName)]$m_jobOrders($jobID qarFileName)
    set fileCksum $m_jobOrders($jobID uploadFiles)
    append networkID $fileCksum
    append networkID [clock clicks]
    putsDebug "Final network ID is $networkID."
    # How good is CRC algorithm ?
    set networkID [crc::cksum $networkID]
    putsDebug "Final checksum network ID is $networkID."
    return $networkID
}

#############################################################################
## Method:  ::quartus::qMaster::submitJobs
##
## Arguments: Callback procedure.
##            (1) Status callback - Slaves status
##            (2) Output callback - Info, error and warning messages
##
## Description: Main API to sumbit all the jobs to slaves.
##              Caller need to run setup before call to this procedure.
##              Setup jobs:
##              (1) Assign which file(s) to upload/download at a particular job.
##              (2) Assign command(s) to this job.
##              (3) Set the total jobs.
##              (4) Set the results directory.
##
#############################################################################
itcl::body ::quartus::qMaster::submitJobs {{args {}}} {
    putsDebug "*****Calling qMaster::submitJobs $args.*****"
    # TODO:
    # (1) How to rid of setTotalJobs from user?
    # (2) Should we support each job with different result dir?

    global tcl_platform
    global env

    set m_stopJobs 0
    set commStartOk 0

    # Update current directory and script directory
    # Current directory will where you call this API.
    # Script directory is (i.e quartus/bin/tcl_scripts)
    updateDir

    # process callback options
    set options {-statusCallback -outputCallback}
    set m_statusCallback {}
    set m_outputCallback {}

    foreach {option value} $args {
        if {[lsearch -exact $options $option] != "-1" } {
            putsDebug "$option = $value"
            if {![string equal $value {}]} {
                regexp -- {^-(.*)} $option all var
                set m_$var $value
            }
        }
    }

    # Any setup before we really kick of the jobs.
    setupEnvironment

    # Suppress "error     error | E: Error getting file size!" from FTP
    log::lvSuppress error

    # Renamne bgerror proc command
    renameBgerrorTo qNetworkBgerror

    ###########################
    ## Normal Mode
    ###########################
    if {[string equal $m_LSFMode 0]} {

        # Try 3 times in case comm::comm has error open the socket
        set i 0
        while {$i < 4} {
            # For Debugging purpose only, comments out and fix the port to 8888
            # set m_listenPort 8888
            if {[catch {comm::comm config -port $m_listenPort -local 0 -port $m_listenPort} errMsg]} {

                if {[string equal $i 3]} {
                    return -code error "Master fails to start up. The reason is $errMsg."
                } else {
                    incr m_listenPort
                }
            } else {
                set commStartOk 1
                break
            }
        }

        if {[string equal commStartOk 1]} {
            putsDebug "qMaster starts successfully. Listen port is $m_listenPort."
            comm::comm hook eval {
                set password [lindex [lindex $buffer end] end]
                set commPassword [qMasterObj getCommPassword]
                if {![string equal $password $commPassword]} {
                    set buffer return
                }
                    # Debuging Purpose:
                    # qSlaveObj debugCmd {puts "Socket     :$fid"}
                    # qSlaveObj debugCmd {puts "Buffer     :$buffer"}
                    # qSlaveObj debugCmd {puts "Command    :$cmd"}
                    # qSlaveObj debugCmd {puts "Channel    :$chan"}
                    # qSlaveObj debugCmd {puts "ID         :$id"}
                    # qSlaveObj debugCmd {puts "[fconfigure $fid -peername]"}
                    # qSlaveObj debugCmd {puts "Network ID  :$networkID"}
            }
        }

        # Exit Script - will called by internal proc to exit
        set m_exitScript [namespace code {set networkJobs done}]

        if {[catch {set networkJobStatus [startNetworkJobs]} err_msg]} {
            putsInfo "Master is unable to start network jobs. The reason is $err_msg."
            set networkJobStatus done
    	}

    	# Wait only if compilation is not done yet
    	if {[string equal $networkJobStatus notDone]} {
    	    putsDebug "Entering event loop until the exit script is called."
    	    set m_poolEventID [after 300000 qMasterObj checkSlavesStatus]
    	    set networkJobs notDone
            # The only one vwait is used here.
            # Beware of using multiple vwait because the most current vwait commands will block
            # other's vwait command.
            vwait networkJobs
            catch {[after cancel $m_poolEventID]}
        }

    ###########################
    ## Third Party Mode - LSF
    ###########################

    } else {
        # Exit Script - will called by internal proc to exit
        set m_exitScript [namespace code {set networkJobs done}]

        if {[catch {set networkJobStatus [LSFStartNetworkJobs]} err_msg]} {
            putsInfo "Master is unable to start network jobs. The reason is $err_msg."
            set networkJobStatus done
    	}

    	# Wait only if compilation is not done yet
    	if {[string equal $networkJobStatus notDone]} {
    	    putsDebug "Entering event loop until the exit script is called."
    	    set networkJobs notDone
            # The only one vwait is used here.
            # Beware of using multiple vwait because the most current vwait commands will block
            # other's vwait command.
            vwait networkJobs
        }
    }

    # reset the environment
 	# if {![string equal $tcl_platform(platform) windows] && [string equal $m_LSFMode 1]} {
    #    if {[info exist "env(QUARTUS_ORIG_PATH)"]} {
    #        set env(PATH) $m_quartusPath
    #    }
    # }
    # Restore bgerror proc command
    restoreBgerrorFrom qNetworkBgerror

    return $m_returnStatus
}

#############################################################################
## Method:  ::quartus::qMaster::startNetworkJobs
##
## Arguments: None.
##
## Description: Start network Jobs. Find the available slaves and submit
##              the jobs.
##
#############################################################################
itcl::body ::quartus::qMaster::startNetworkJobs {} {

    putsDebug "*****Calling qMaster::startNetworkJobs.*****"

    foreach index [array names m_jobOrders *commands] {
        set jobID [lindex $index 0]
        set slaveID -1

        if {[string equal $m_jobOrders($jobID status) pending]} {
            if { [info exists "m_jobOrders($jobID hostAssignment)"] && $m_jobOrders($jobID hostAssignment) != 0  } {
                # This section for specific assignment
                putsDebug "Slave assignment for $jobID --> $m_jobOrders($jobID hostAssignment)"

                for {set slaveID 0} {$slaveID < $m_totalSlaves} {incr slaveID} {
                    if { [ string equal "$m_slavesInfo($slaveID host):$m_slavesInfo($slaveID listenPort)" $m_jobOrders($jobID hostAssignment) ] } {
                        break
                    }
                }

                if { $slaveID == $m_totalSlaves } {
                    putsError "Slave $m_jobOrders($jobID hostAssignment) is not declared for job assignment (jobID: $jobID) "
                    set slaveID -1
                } elseif { ![string equal $m_slavesInfo($slaveID jobID) -1] || ![string equal $m_slavesInfo($slaveID status) alive] } {
                    if { [string equal $m_slavesInfo($slaveID status) down] } {
                        eval "$m_statusCallback $jobID {} $m_jobOrders($jobID hostAssignment) {$m_jobOrders($jobID commands)} Fail slaveDown"
                    }

                    set slaveID -1
                }

            } else {
                # This section for specific assignment
                for {set slaveID 0} {$slaveID < $m_totalSlaves} {incr slaveID} {
                    if { [string equal $m_slavesInfo($slaveID jobID) -1] && [string equal $m_slavesInfo($slaveID status) alive] } {
                        break
                    }
                }

                if { $slaveID == $m_totalSlaves } {
                    # There is no free slave left
                    set slaveID -1
                    break
                }
            }

            if { $slaveID != -1 } {
                putsDebug "Slave $slaveID is available to run job $jobID."
                set networkID [generateNetworkID $slaveID $jobID]
                set "m_jobOrders($jobID networkID)" $networkID

                # Notify this slave is running this job id.
                set "m_slavesInfo($slaveID jobID)" $jobID
                # Notify this job is runned by this slave.
                set "m_jobOrders($jobID status)" $slaveID

                # extra checking to make sure the network flow now should be invalid
                if {![string equal $m_jobOrders($jobID networkFlowID) -1]} {
                    putsError "================ Unexpected behavior - should not reach here. ================"
                    # recover
                    set "m_jobOrders($jobID networkFlowID)" -1
                }

                if {[string equal $m_stopJobs 1]} {
                    after 0 qMasterObj networkCompileComplete [subst $networkID] stop
                } else {
                    # go to next flow from invalid flow
                    incr "m_jobOrders($jobID networkFlowID)"

                    # Evaluate callback script for each job starts
                    if {![string equal $m_statusCallback {}]} {
                        eval "$m_statusCallback $jobID $networkID $m_slavesInfo($slaveID host) {$m_jobOrders($jobID commands)} Start"
                    }
                    # file event to kick off the job
                    after 0 qMasterObj startNetworkCompile [subst $networkID]
                }
            }
        }
    }

    # Any slave is running ?
    set atLeastOneSlaveActive no
    for {set slaveID 0} {$slaveID < $m_totalSlaves} {incr slaveID} {
        if {![string equal $m_slavesInfo($slaveID jobID) -1]} {
            set atLeastOneSlaveActive yes
            break;
        }
    }

    # Any pending job ?
    set atLeastOneJobWaiting yes
    if {[string equal [getPendingJob] "-1"]} {
        set atLeastOneJobWaiting no
    }

    # If slave is still running, network compilation is not done.
    if {[string equal $atLeastOneSlaveActive yes]} {
        putsDebug "Network compilation is not done yet."
        return notDone
    } else {
        # If no more slave is running and  no more pending job, the compilation is done.
        if {[string equal $atLeastOneJobWaiting no]} {
	    # Avoid to post "All jobs have completed" more than once in case of the events are fired not in a sequence
            if {![string equal $m_exitScript {}]} {
                putsInfo "All jobs have completed."
                return done
            }
        # if no more slave is running and got pending job, all slaves must be down.
        } else {

                # for {set jobID 0} {$jobID < $m_totalJobs} {incr jobID} {
                # }
                foreach index [array names m_jobOrders *commands] {
                    set jobID [lindex $index 0]

                    if {[string equal $m_jobOrders($jobID status) pending]} {
                        if {![string equal $m_statusCallback {}]} {
                            if { [info exists "m_jobOrders($jobID hostAssignment)"] && $m_jobOrders($jobID hostAssignment) != 0 } {
                                eval "$m_statusCallback $jobID {} $m_jobOrders($jobID hostAssignment) {$m_jobOrders($jobID commands)} Fail noAvailSlaves"
                            } else {
                                eval "$m_statusCallback $jobID {} {} {$m_jobOrders($jobID commands)} Fail noAvailSlaves"
                            }
                        }
                    }
                }

                # putsInfo "All slaves are down or no slaves are available."
                putsInfo "There are job(s) that failed to be submitted to available slave(s)."
                return slavesDown
		}
	}
    return
}

#############################################################################
## Method:  ::quartus::qMaster::LSFStartNetworkJobs
##
## Arguments: None.
##
## Description: Start network jobs. Submit the jobs to LSF cluster.
##
#############################################################################
itcl::body ::quartus::qMaster::LSFStartNetworkJobs {{submitOneJob {0}}} {

    putsDebug "*****Calling qMaster::LSFStartNetworkJobs.*****"

    # Go through each free slave and run the pending jobs.
    for {set jobIDCnt 0} {$jobIDCnt < $m_totalJobs} {incr jobIDCnt} {
        set jobID [getPendingJob]
        # Any pending Job?
        if {[string equal $jobID -1]} {
            putsDebug "No more pending jobs."
            break
        }

        set networkID [generateNetworkID $m_LSFCluster $jobID]
        set "m_jobOrders($jobID networkID)" $networkID

        # Notify this job is runned by LSF cluster
        set "m_jobOrders($jobID status)" $m_LSFCluster

        # extra checking to make sure the network flow now should be invalid
        if {![string equal $m_jobOrders($jobID networkFlowID) -1]} {
            putsError "================ Unexpected behavior - should not reach here. ================"
            # recover
            set "m_jobOrders($jobID networkFlowID)" -1
        }

        if {[string equal $m_stopJobs 1]} {
            after 0 qMasterObj LSFNetworkCompileComplete [subst $networkID] stop
        } else {
            # go to next flow from invalid flow
            incr "m_jobOrders($jobID networkFlowID)"
            # Evaluate callback script for each job starts
            if {![string equal $m_statusCallback {}]} {
                eval "$m_statusCallback $jobID $networkID $m_LSFCluster {$m_jobOrders($jobID commands)} Start"
            }
            # file event to kick off the job
            after 0 qMasterObj LSFStartNetworkCompile [subst $networkID]
        }
        if {[string equal $submitOneJob 1]} {
            break;
        }
    }

    # Any pending job ?
    set atLeastOneJobWaiting yes
    if {[string equal [getPendingJob] "-1"]} {
        set atLeastOneJobWaiting no
    }

    # If LSF is still running, the Job is not done.
    if {[string equal [isLSFRunning] 1]} {
        putsDebug "Job is not done yet."
        return notDone
	} else {
            # If LSF is not running and  no more pending job, the jobs are done.
	    if {[string equal $atLeastOneJobWaiting no]} {
                # Avoid to post "All jobs have completed" more than once in case of the events are fired not in a sequence
                if {![string equal $m_exitScript {}]} {
                    putsInfo "All jobs have completed."
                    return done
                }
            # if LSF is not running and got pending job, the LSF must be down.
            } else {
                putsInfo "LSF is unavailable to perform jobs."
                return LSFClusterDown
            }
	}
    return
}
#############################################################################
## Method:  ::quartus::qMaster::startNetworkCompile
##
## Arguments: Network ID
##
## Description: Start network compile for this particular Network ID.
##              This procedure is called by startNetworkJobs.
##
## Notes: networkCompileComplete will be called when the job is done.
##
#############################################################################
itcl::body ::quartus::qMaster::startNetworkCompile {networkID} {

    putsDebug "*****Calling qMaster::startNetworkCompile $networkID*****"
    set jobID [getjobID $networkID]
    set slaveID $m_jobOrders($jobID status)

    putsDebug "The Job ID is $jobID and slave ID is $slaveID."
    putsDebug "Network flow ID is $m_jobOrders($jobID networkFlowID)."

    set h -1
    set networkFlowCmd $m_networkFlow($m_jobOrders($jobID networkFlowID))
    putsDebug "Network flow command is $networkFlowCmd."

    # Debugging purpose:
    # set ::ftp::VERBOSE 1
    # set ::ftp::DEBUG 1

    # If previous operation is ftp, reset back the status to none so that it won't block others ftp operation
    # tcllib ftp seems to have bug that on parallel get/put operation especially many large files.
    # TODO: 1) fix the tcllib ftp or
    #       2) Rewrite my own file copy utility based on socket
    if {[string equal $m_slavesInfo($slaveID ftpStatus) getPuting]} {
        set "m_slavesInfo($slaveID ftpStatus)" none
        # Perform extra checking
        if {![string equal $m_uniqueSlavesInfo($m_slavesInfo($slaveID host):$m_slavesInfo($slaveID listenPort) ftpGetPutCount) 1]} {
            putsError "================ Unexpected behavior - ftpGetPutCount should be equal to 1. ================"
        }
        set "m_uniqueSlavesInfo($m_slavesInfo($slaveID host):$m_slavesInfo($slaveID listenPort) ftpGetPutCount)" 0
        # Below command is reserved for future use, just in case.
        # set "m_uniqueSlavesInfo($m_slavesInfo($slaveID host) ftpGetPutCount)" [expr $m_uniqueSlavesInfo($m_slavesInfo($slaveID host) ftpGetPutCount) - 1]
    }

    #######################
    ## Pre-process Command
    #######################
    if {[string equal $networkFlowCmd preProcessFlow]} {
        # Notes: If m_stopJobs == 1, Slave will be stopped only if the current operation on that slave has finished
        #        The master will only exit if all the running slaves have finished their current operation.
        if {[string equal $m_stopJobs 1]} {
            networkCompileComplete $networkID stop
        } else {
            if {[string equal $m_verCheck 1]} {
                set quartusVer $::quartus(version)
            } else {
                set quartusVer ignoreQuartusVerCheck
            }

            if {[catch {comm::comm send -async "$m_slavesInfo($slaveID listenPort) $m_slavesInfo($slaveID host)" "qSlaveObj remoteCmd {preProcess [list $quartusVer]} genericRemoteCallback $networkID $m_commPassword"} errMsg]} {
                putsError "Master failed to connect $m_slavesInfo($slaveID host). The error message is $errMsg."
                set "m_slavesInfo($slaveID status)" down
                networkCompileComplete $networkID fail slaveDown
                return
            }
        }
    # Mawardi: Ftp replace
    #################################
    ## Upload/Download command
    #################################
    } elseif {[string equal $networkFlowCmd uploadFlow] || [string equal $networkFlowCmd downloadFlow]} {

        if {[string equal $m_stopJobs 1] && [string equal $networkFlowCmd uploadFlow]} {
          comm::comm send -async "$m_slavesInfo($slaveID listenPort) $m_slavesInfo($slaveID host)" "qSlaveObj remoteCmd {postProcess {stop}} networkCompileComplete $networkID $m_commPassword"
        } else {
            if {[string equal $networkFlowCmd uploadFlow] && [string equal $m_jobOrders($jobID totalUploadFiles) 0]} {
                incr "m_jobOrders($jobID networkFlowID)"
                startNetworkCompile $networkID
            } elseif {[string equal $networkFlowCmd downloadConnFlow] && [string equal $m_jobOrders($jobID downloadFiles) 0]} {
                incr "m_jobOrders($jobID networkFlowID)"
                startNetworkCompile $networkID
            } else {

                # By now, I'm ready to perform ftp operation on this slave.
                if {![string equal $m_statusCallback {}]} {
                    # TODO: Any better way without hardcode the network ID
                    if {[string equal $m_jobOrders($jobID networkFlowID) 1]} {
                            eval "$m_statusCallback $jobID $networkID $m_slavesInfo($slaveID host) {$m_jobOrders($jobID commands)} Upload"
                    } else {
                            eval "$m_statusCallback $jobID $networkID $m_slavesInfo($slaveID host) {$m_jobOrders($jobID commands)} Download"
                    }
                }

                # Mawardi: This will establish connection and send files.
                if {[string equal $networkFlowCmd uploadFlow] } {
                    if { $m_jobOrders($jobID totalUploadFiles) > 0 } {
                        set callback "qMasterObj sendFileCommandCallback"
                        catch {set stat [qTransferObj TH_ChannelHandler type=client host=$m_slavesInfo($slaveID host) port=$m_jobOrders($jobID ftpListenPort) tohostdir=$networkID-dir ID=$networkID callback=$callback files=$m_jobOrders($jobID uploadFiles) timeout=$m_ftpTimeout]}

                        if {[string equal $stat 0]} {
                            putsInfo "Unable to send files to $m_slavesInfo($slaveID host)."
                            networkCompileComplete $networkID fail transferConnectError
                            return
                        }
                    } else {
                        set "m_jobOrders($jobID ftpStatus)" closed
                        incr "m_jobOrders($jobID networkFlowID)"
                        startNetworkCompile $networkID
                    }
                } elseif { [string equal $networkFlowCmd downloadFlow] } {
                    if { $m_jobOrders($jobID totalDownloadFiles) > 0 } {
                        set resultFileDir $m_resultDir
                        if {[string equal $m_enableSubResultDir 1]} {
                            set resultFileDir [file join $m_resultDir job-$jobID]
                        }

                        set callback "qMasterObj sendFileCommandCallback"
                        catch {set stat [qTransferObj TH_GetFile host=$m_slavesInfo($slaveID host) port=$m_jobOrders($jobID ftpListenPort) ID=$networkID fromhostdir=$networkID-dir tolocaldir=$resultFileDir callback=$callback files=$m_jobOrders($jobID downloadFiles)]}

                        if {[string equal $stat 0]} {
                            putsInfo "Unable to get files to $m_slavesInfo($slaveID host)."
                            networkCompileComplete $networkID fail transferConnectError
                            return
                        }
                    } else {
                        set "m_jobOrders($jobID ftpStatus)" closed
                        incr "m_jobOrders($jobID networkFlowID)"
                        startNetworkCompile $networkID
                    }
                } else {
                    putsDebug "Unknown flow: $networkFlowCmd"
                }
            }
        }
    #################################
    ## Ftp Command - Upload/Download
    #################################
    } elseif {[string equal $networkFlowCmd ftpUploadConnFlow] || [string equal $networkFlowCmd ftpDownloadConnFlow]} {
        if {[string equal $m_stopJobs 1] && [string equal $networkFlowCmd ftpUploadConnFlow]} {
          comm::comm send -async "$m_slavesInfo($slaveID listenPort) $m_slavesInfo($slaveID host)" "qSlaveObj remoteCmd {postProcess {stop}} networkCompileComplete $networkID $m_commPassword"
        } else {
            if {[string equal $networkFlowCmd ftpUploadConnFlow] && [string equal $m_jobOrders($jobID totalUploadFiles) 0]} {
                incr "m_jobOrders($jobID networkFlowID)"
                incr "m_jobOrders($jobID networkFlowID)"
                startNetworkCompile $networkID
            } elseif {[string equal $networkFlowCmd ftpDownloadConnFlow] && [string equal $m_jobOrders($jobID totalDownloadFiles) 0]} {
                incr "m_jobOrders($jobID networkFlowID)"
                incr "m_jobOrders($jobID networkFlowID)"
                startNetworkCompile $networkID
            } else {
    
                # Hello, if the slave is running the ftp operatoin, don't force him to run another ftp operation
                # because he will hang unexpectly. So file the event after 5 minutes to check it out of the ftp operation has completed
                if {![string equal $m_uniqueSlavesInfo($m_slavesInfo($slaveID host):$m_slavesInfo($slaveID listenPort) ftpGetPutCount) 0]} {
                    after 5000 qMasterObj startNetworkCompile [subst $networkID]
                    return
                }
    
                # By now, I'm ready to perform ftp operation on this slave.
    
                if {![string equal $m_statusCallback {}]} {
                    # TODO: Any better way without hardcode the network ID
                    if {[string equal $m_jobOrders($jobID networkFlowID) 1]} {
                            eval "$m_statusCallback $jobID $networkID $m_slavesInfo($slaveID host) {$m_jobOrders($jobID commands)} Upload"
                    } else {
                            eval "$m_statusCallback $jobID $networkID $m_slavesInfo($slaveID host) {$m_jobOrders($jobID commands)} Download"
                    }
                }
                # TODO: how many ftp handle can be created ?
                # Even after I call ftpClose and create another FTP channel, the ftp always keep increasing
                # Need to verify this in future and make sure the ftp doesn't screw up.

                catch {set h [::ftp::Open $m_slavesInfo($slaveID host) $m_ftpUserName $m_ftpPassword -port $m_jobOrders($jobID ftpListenPort) -timeout $m_ftpTimeout -command "qMasterObj ftpCommandCallback $networkID" -progress "qMasterObj ftpProgressCallback $networkID"]}
                if {[string equal $h -1]} {
                    putsInfo "Unable to open an FTP connection to $m_slavesInfo($slaveID host)."
                    networkCompileComplete $networkID fail ftpConnect
                    return
                } else {
                    set "m_jobOrders($jobID ftpHandle)" $h
                    set "m_slavesInfo($slaveID ftpStatus)" getPuting
                    incr "m_uniqueSlavesInfo($m_slavesInfo($slaveID host):$m_slavesInfo($slaveID listenPort) ftpGetPutCount)"
                    # TODO: Implement timeout in future.
                    # after 1000 qMasterObj ftpCommandCallback hahahhaa
                }
            }
        }
    #####################
    ## Compile Command
    #####################
    } elseif {[string equal $networkFlowCmd compileFlow]} {

        if {[string equal $m_stopJobs 1]} {
            comm::comm send -async "$m_slavesInfo($slaveID listenPort) $m_slavesInfo($slaveID host)" "qSlaveObj remoteCmd {postProcess {stop}} networkCompileComplete $networkID $m_commPassword"
        } else {
            # Check if all the commands have been run or not ?
            if {$m_jobOrders($jobID numRemoteCmds) < $m_jobOrders($jobID totalRemoteCmds)} {

                set cmdList $m_jobOrders($jobID commands)
                set cmd [lindex $cmdList $m_jobOrders($jobID numRemoteCmds)]

                if {![string equal $m_statusCallback {}]} {
                    eval "$m_statusCallback $jobID $networkID $m_slavesInfo($slaveID host) {[list $cmd]} Run"
                }
                comm::comm send -async "$m_slavesInfo($slaveID listenPort) $m_slavesInfo($slaveID host)" "qSlaveObj remoteCmd {startRemoteCommand {$cmd}} genericRemoteCallback $networkID $m_commPassword"
            }
        }

    #######################
    ## Post-process Command
    #######################
    } elseif {[string equal $networkFlowCmd postProcessFlow]} {
        comm::comm send -async "$m_slavesInfo($slaveID listenPort) $m_slavesInfo($slaveID host)" "qSlaveObj remoteCmd {postProcess 0} genericRemoteCallback $networkID $m_commPassword"

    #######################
    ## Exit Command
    #######################
    } elseif {[string equal $networkFlowCmd exitFlow]} {
        networkCompileComplete $networkID success
    }

    return
}

#############################################################################
## Method:  ::quartus::qMaster::LSFStartNetworkCompile
##
## Arguments: Network ID
##
## Description: Start network compile for this particular network ID.
##              This procedure is called by LSFStartNetworkJobs.
##
## Notes: LSFNetworkCompileComplete will be called when the job is done.
##
#############################################################################
itcl::body ::quartus::qMaster::LSFStartNetworkCompile {networkID} {

    putsDebug "*****Calling qMaster::LSFStartNetworkCompile $networkID*****"

    global env
    set jobID [getjobID $networkID]
    set slaveID $m_jobOrders($jobID status)

    putsDebug "The Job ID is $jobID and slave id is $slaveID."
    putsDebug "Network flow ID is $m_jobOrders($jobID networkFlowID)."

    set h -1
    set networkFlowCmd $m_networkFlow($m_jobOrders($jobID networkFlowID))
    putsDebug "Network flow command is $networkFlowCmd."

    ###########################
    ## LSF pre-process Command
    ###########################
    if {[string equal $networkFlowCmd LSFPreProcessFlow]} {

        if {[string equal $m_stopJobs 1]} {
            LSFNetworkCompileComplete $networkID stop
        } else {
            set workingDir $networkID-dir

            # create the directory
            if {[file exists $workingDir]} {
        		putsWarning "The working directory $workingDir exists in pre-processing flow."
                if {[catch {file delete -force $workingDir} err_msg]} {
                    putsWarning "Unable to delete $workingDir directory."
                }
            }

            file mkdir $workingDir

            if {![string equal $m_statusCallback {}]} {
                if {![string equal $m_jobOrders($jobID totalUploadFiles) "0"]} {
                    eval "$m_statusCallback $jobID $networkID $m_LSFCluster {$m_jobOrders($jobID commands)} Upload"
                }
            }

            # copy all the files required to run the job
            while {$m_jobOrders($jobID numUploadFiles) < $m_jobOrders($jobID totalUploadFiles)} {
                set fileList $m_jobOrders($jobID uploadFiles)
                set fileName [lindex $fileList $m_jobOrders($jobID numUploadFiles)]
                # set fileNameD [file tail $fileName]
                # set fileNameD [file join $networkID-dir $fileNameD]
                set fileNameD [file join $m_currentDir $networkID-dir]

                file copy -force $fileName $fileNameD

                incr "m_jobOrders($jobID numUploadFiles)"
            }

            incr "m_jobOrders($jobID networkFlowID)"
            LSFStartNetworkCompile $networkID
        }
    ######################
    ## LSF Compile Command
    ######################
    } elseif {[string equal $networkFlowCmd LSFCompileFlow]} {
        # Check if all the commands have been run or not ?
        if {$m_jobOrders($jobID numRemoteCmds) < $m_jobOrders($jobID totalRemoteCmds)} {

            set cmdList $m_jobOrders($jobID commands)
            set cmd [lindex $cmdList $m_jobOrders($jobID numRemoteCmds)]


            if {![string equal $m_statusCallback {}]} {
                eval "$m_statusCallback $jobID $networkID $m_LSFCluster {[list $cmd]} Run"
            }

            set bsubOpts {}

            set fileDirName [file join $m_currentDir $networkID-dir]
            cd $fileDirName
            # TODO: Error Spawning error ?
            # TODO: ../bsub is for testing purpose.
            # spawnProcess "[file join $env(LSF_BINDIR)
            # assumption: One job fail because of noAvailLSF, all jobs will be fail with noAvailLSF

            if {[string equal $m_LSFQueue {}]} {
                set bsubOpts  [subst {-K -J $networkID -o $networkID.log $cmd}]
            } else {
                set bsubOpts  [subst {-K -q "$m_LSFQueue" -J $networkID -o $networkID.log $cmd}]
            }
            # $env(LSF_BINDIR) not exist will be catch by this block don't move it away from this catch block
            if {[catch {spawnProcess "[file join $env(LSF_BINDIR) bsub] $bsubOpts" $networkID} errMsg]} {
                 cd $m_currentDir
                 putsError "Master failed to run bsub command. The error message is $errMsg."
                 LSFNetworkCompileComplete $networkID fail noAvailLSF
                 return
            }


            # if {[catch {spawnProcess "[file join $env(LSF_BINDIR) bsub] -K -J $networkID -o $networkID.log $cmd" $networkID} errMsg]} {
            #     cd $m_currentDir
            #     putsDebug "Master failed to spawn process. The error message is $errMsg."
            #     LSFNetworkCompileComplete $networkID fail noAvailLSF
            #     return
            # }
            cd $m_currentDir

            incr "m_jobOrders($jobID numRemoteCmds)"

        } else {
            incr "m_jobOrders($jobID networkFlowID)"
            LSFStartNetworkCompile $networkID
        }

    ###########################
    ## LSF Post-process Command
    ###########################
    } elseif {[string equal $networkFlowCmd LSFPostProcessFlow]} {

        if {![string equal $m_statusCallback {}]} {
            if {![string equal $m_jobOrders($jobID totalDownloadFiles) "0"]} {
                eval "$m_statusCallback $jobID $networkID $m_LSFCluster {$m_jobOrders($jobID commands)} Download"
            }
        }

        while {$m_jobOrders($jobID numDownloadFiles) < $m_jobOrders($jobID totalDownloadFiles)} {
            set fileList $m_jobOrders($jobID downloadFiles)
            set fileName [lindex $fileList $m_jobOrders($jobID numDownloadFiles)]
            set fileNameD [file join $networkID-dir $fileName]
            set fileNameD [file join $m_currentDir $fileNameD]
            

            if {[file exist $fileNameD] && [file isfile $fileNameD]} {

                set resultFileDir $m_resultDir
                if {[string equal $m_enableSubResultDir 1]} {
                    set resultFileDir [file join $m_resultDir job-$jobID]
                    if {![file exists $resultFileDir]} {
                        file mkdir $resultFileDir
                    }

                }
                incr "m_jobOrders($jobID numSuccessfulDownloadFiles)"
                file copy -force $fileNameD $resultFileDir

            } else {
                # Do not clean up but just ignore it
                # TODO: perform clean up
                # LSFNetworkCompileComplete $networkID fail noResultFile
                # return
            }

            incr "m_jobOrders($jobID numDownloadFiles)"
        }

        if {![string equal $m_jobOrders($jobID totalDownloadFiles) "0"]} {
            if {[string equal $m_jobOrders($jobID numSuccessfulDownloadFiles) "0"]} {
                # TODO: perform clean up
                LSFNetworkCompileComplete $networkID fail noResultFile
                return
            }
        }

        incr "m_jobOrders($jobID networkFlowID)"
        LSFStartNetworkCompile $networkID

        # comm::comm send -async "$m_slavesInfo($slaveID listenPort) $m_slavesInfo($slaveID host)" "qSlaveObj remoteCmd {postProcess 0} genericRemoteCallback $networkID $m_commPassword"

    #######################
    ## LSF Exit Command
    #######################
    } elseif {[string equal $networkFlowCmd LSFExitFlow]} {
        LSFNetworkCompileComplete $networkID success
    }

    return
}

#############################################################################
## Method:  ::quartus::qMaster::LSFNetworkCompileComplete
##
## Arguments: Network ID and status
##
## Description: This method is called when a job is done. The status:
##              (1) success
##              (2) fail reason
##              (3) stop
##
#############################################################################

itcl::body ::quartus::qMaster::LSFNetworkCompileComplete {networkID status args} {

    putsDebug "*****Calling qMaster::LSFNetworkCompileComplete $networkID $status $args."

    if {[string equal $m_stopJobs 1] && [string equal $status fail]} {
        set status stop
    }

    set boolFailLimit 0

    # Get job id that correspond to network Id
    set jobID [getjobID $networkID]
    # Get slave Id that run this job
    set slaveID $m_jobOrders($jobID status)
    set reason [lindex $args 0]

    putsDebug "Slave Id:$slaveID finished compile job Id:$jobID."

    if {[string equal $m_noCleanUp 0]} {
        # Clean up the directory
        if {[catch {file delete -force [file join $m_currentDir $networkID-dir]} err_msg]} {
            # Delete twice to double confirm because sometimes LSF lock the directory
            if {[catch {file delete -force [file join $m_currentDir $networkID-dir]} err_msg]} {
                putsWarning "Unable to delete $networkID-dir directory."
            }
        }
    }

    initJobsOrder $jobID

    # update the job's status
    if {[string equal $status success]} {
        set "m_jobOrders($jobID status)" done
        set jobStatus Done
    } elseif {[string equal $status fail]} {

        # Do not increment when the LSF is down
        if {![string equal $reason noAvailLSF]} {
            incr "m_jobOrders($jobID numFails)"
        }

        if {$m_jobOrders($jobID numFails) < $m_failsLimit} {
            if {[string equal $reason noAvailLSF]} {
                set "m_jobOrders($jobID status)" fail
            } else {
                set "m_jobOrders($jobID status)" pending
            }
        } else {
             set "m_jobOrders($jobID status)" fail
             set boolFailLimit 1
        }

        set jobStatus Fail
    } elseif {[string equal $status stop]} {
        set "m_jobOrders($jobID status)" stop
        set jobStatus Stop
    } else {
        putsError "================ Undefined return status: $status. ================ "
    }

    set boolLSFAlive [isLSFRunning]

    # Evaluate callback script for each job completes
    if {![string equal $m_statusCallback {}]} {
        eval "$m_statusCallback $jobID $networkID $m_LSFCluster {$m_jobOrders($jobID commands)} $jobStatus $reason"
    }

    # Callback the failLimit
    if {[string equal $boolFailLimit 1 ]} {
        set reason failLimit
        if {![string equal $m_statusCallback {}]} {
            eval "$m_statusCallback $jobID $networkID $m_LSFCluster {$m_jobOrders($jobID commands)} $jobStatus $reason"
        }
    }

    # Start a new network Job when the following condtion is true
    # job is success || (!job fails with failLimit && !job is stop && !no available LSF)
    # Note: The following fail reason or stuatus will determine not to resubmit the job
    #   - failLimit
    #   - stop
    #   - noAvailLSF
     if {[string equal $status success] || (![string equal $reason failLimit] && ![string equal $status stop] && ![string equal $reason noAvailLSF])} {
        if {[catch {set status [LSFStartNetworkJobs 1]} err_msg]} {
            putsInfo "Master is unable to perform new network job. The reason is $err_msg"
            set status done
    	}
    } elseif {![string equal $boolLSFAlive 1] && ([string equal [getPendingJob] -1]) } {
        # Avoid to post "All jobs have completed" more than once in case of the events are fired not in a sequence
        if {![string equal $m_exitScript {}]} {
            putsInfo "All jobs have completed."
            set status done
        } else {
            return
        }
    }

    # If the return status is done, call the exit script
    if {[string equal $status done] || [string equal $status LSFClusterDown]} {

        if {[string equal [isAllJobsDone] 1]} {
            set m_returnStatus 1
        } else {
            set m_returnStatus 0
	    }

        clearJobsID
        putsDebug "Calling the exit script to exit the event loop."
        eval $m_exitScript
        # to prevent other events evaluate the exit script more than once
        set m_exitScript {}
    }
    return
}

#############################################################################
## Method:  ::quartus::qMaster::spawnProcess
##
## Arguments:: Command name and network ID
##
## Description: Spaw a process with a given command.
##
#############################################################################
itcl::body ::quartus::qMaster::spawnProcess {cmd networkID} {

    putsDebug "*****Calling qMaster::spawnProcess $cmd $networkID.*****"
    set processPipe [open [concat | $cmd] r]
    fconfigure $processPipe -buffering none

    set processPid [pid $processPipe]
    putsDebug "The process Pipe is $processPipe."
    putsDebug "The process PID is $processPid."

    set processCallback [list spawnProcessCallback $processPipe $networkID]
    fileevent $processPipe readable "qMasterObj $processCallback"
    return notDone
}

#############################################################################
## Method:  ::quartus::qMaster::spawnProcessCallback
##
## Arguments:: Pipe and network ID
##
## Description: Spawn process callback.
##
#############################################################################
itcl::body ::quartus::qMaster::spawnProcessCallback {pipe networkID} {

    # This will be call many times as long as the pipe is readable, so disable debug message.
    # putsDebug "*****Calling qSlave::spawnProcessCallback $pipe $networkID.*****"

    if {[eof $pipe]} {
        catch {fileevent $pipe readable {}}

        # catch {close $pipe}
        if {[catch {close $pipe} errMsg]} {
            # Newton sot sot and got error to run any command
            # bsub bug that will return errMsg everytime
            if {[string match -nocase "*No such queue*" $errMsg]} {
                putsError "Master failed to run bsub command. The error message is $errMsg."
                LSFNetworkCompileComplete $networkID fail noAvailLSF
            } else {
                 LSFStartNetworkCompile $networkID
            }

        } else {
            LSFStartNetworkCompile $networkID
        }
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
## Method:  ::quartus::qMaster::ftpProgressCallback
##
## Arguments: Network ID and args
##
## Description: File transfer callback. Determine whether the file transfer
##              has completed. This is only for download operation.
##
#############################################################################

itcl::body ::quartus::qMaster::ftpProgressCallback {networkID args} {
    putsDebug "*****Calling qMaster::ftpProgressCallback $networkID $args.*****"
    set jobID [getjobID $networkID]
    set networkFlowCmd $m_networkFlow($m_jobOrders($jobID networkFlowID))
    set h $m_jobOrders($jobID ftpHandle)

    if {[string equal $networkFlowCmd ftpDownloadFlow]} {
        # file download complete ?
        if {[string equal $m_jobOrders($jobID resultFileSize) $args]} {
            incr "m_jobOrders($jobID numDownloadFiles)"
            incr "m_jobOrders($jobID numSuccessfulDownloadFiles)"

            # check any others file to download ?
            if {$m_jobOrders($jobID numDownloadFiles) < $m_jobOrders($jobID totalDownloadFiles)} {
                set fileList $m_jobOrders($jobID downloadFiles)
                set fileName [lindex $fileList $m_jobOrders($jobID numDownloadFiles)]
                set fileNameD [file join $networkID-dir $fileName]
                # It will return the get file transfer complete to ftpCommandCallback.
                # If we call ::ftp::FileSzie immediately, it will cause size and get ftpCommandCallback together
                after 5000 [subst {::ftp::FileSize $h $fileNameD}]
            } else {        
                # TODO here only if the numSuccessfulDownloadFiles that allow is not equal to 1

                # upvar ::ftp::ftp$h ftp
                set "m_jobOrders($jobID ftpStatus)" closed
                # catch {after cancel $ftp(Wait)}
                # ftp bugs again :( I have to file the event to close the ftp or else the file will be locked by ftp forever.
                # One disadvantage of doing this if the slave dies during file transfer of the next job,
                # terminated callbacked will be evaluate for this job. However this job is already been release and therefore
                # you will get a background error that cannot get job id from the network ID.
                # The background error will not harm, so it's okay to ignore it in this case.
                # in short, we're making assumption that within this 5 seconds, no ftp error.
                after 5000 [subst {::ftp::Close $h}]

                incr "m_jobOrders($jobID networkFlowID)"
                startNetworkCompile $networkID
            }
        }
   }
   # update
   return
}


# Mawardi: Callback on the file trasmission.
#############################################################################
## Method:  ::quartus::qMaster::sendFileCommandCallback
##
## Arguments: Network ID and callback command argument.
##
## Description: Send file callback function
##
#############################################################################
itcl::body ::quartus::qMaster::sendFileCommandCallback {networkID status details} {
    putsDebug "*****Calling qMaster::sendFileCommandCallback $networkID $status $details.*****"

    # In download mode, it is possible that the get commandCallback will be called after the job is done.
    # Therefore, the networkID will be invalid.
    if {[catch {set jobID [getjobID $networkID]} errMsg]} {
        putsDebug $errMsg
        return
    }

    set networkFlowCmd $m_networkFlow($m_jobOrders($jobID networkFlowID))
    set operation $status
    set operationStatus $details

    set slaveID $m_jobOrders($jobID status)

    putsDebug "Network flow command is $networkFlowCmd."
    putsDebug "The operation is $operation."
    putsDebug "The details of the operation is: $details"

    #######################
    ## Timeout Operation
    #######################
    if {[string equal $operation timeout]} {
            set "m_jobOrders($jobID ftpStatus)" closed
            networkCompileComplete $networkID fail transferTimeout
    #######################
    ## Terminate Operation
    #######################
    } elseif {[string equal $operation terminated]} {
        set "m_jobOrders($jobID ftpStatus)" closed
        networkCompileComplete $networkID fail transferTerminated
    ######################
    ## Error Operation
    ######################
    } elseif {[string equal $operation error]} {

        set "m_jobOrders($jobID ftpStatus)" closed

        if {[string equal $networkFlowCmd downloadFlow]} {
            set ftpStatus "fail noResultFile"
        } else {
            set ftpStatus "fail transferError"
        }

        catch {comm::comm send -async "$m_slavesInfo($slaveID listenPort) $m_slavesInfo($slaveID host)" "qSlaveObj remoteCmd {postProcess {$ftpStatus}} networkCompileComplete $networkID $m_commPassword"}

     } elseif { [string equal $operation success] } {
        if { [string equal $networkFlowCmd uploadFlow] } {
           set "m_jobOrders($jobID numUploadFiles)" $m_jobOrders($jobID totalUploadFiles)
           set "m_jobOrders($jobID ftpStatus)" closed
           incr "m_jobOrders($jobID networkFlowID)"
           startNetworkCompile $networkID

        } elseif { [string equal $networkFlowCmd downloadFlow] } {

                # Mawardi: After the modification, check whether these 2 variables are needed or not.
                set "m_jobOrders($jobID numDownloadFiles)" $m_jobOrders($jobID totalDownloadFiles)
                set  "m_jobOrders($jobID numSuccessfulDownloadFiles)" $m_jobOrders($jobID totalDownloadFiles)

                set "m_jobOrders($jobID ftpStatus)" closed
                incr "m_jobOrders($jobID networkFlowID)"
                startNetworkCompile $networkID
        }
    } else {
        set "m_jobOrders($jobID ftpStatus)" closed
        set ftpStatus "fail transferTerminated"

        catch {comm::comm send -async "$m_slavesInfo($slaveID listenPort) $m_slavesInfo($slaveID host)" "qSlaveObj remoteCmd {postProcess {$ftpStatus}} networkCompileComplete $networkID $m_commPassword"}
    }

    return

}



#############################################################################
## Method:  ::quartus::qMaster::ftpCommandCallback
##
## Arguments: Network ID and callback command argument.
##
## Description: Ftp command callback.
##
#############################################################################

itcl::body ::quartus::qMaster::ftpCommandCallback {networkID args} {
    putsDebug "*****Calling qMaster::ftpCommandCallback $networkID $args.*****"

    # In download mode, it is possible that the get commandCallback will be called after the job is done.
    # Therefore, the networkID will be invalid.
    if {[catch {set jobID [getjobID $networkID]} errMsg]} {
        putsDebug $errMsg
        return
    }

    set h $m_jobOrders($jobID ftpHandle)
    set networkFlowCmd $m_networkFlow($m_jobOrders($jobID networkFlowID))
    set operation [lindex $args 0]
    set operationStatus [lindex $args 1]

    set slaveID $m_jobOrders($jobID status)

    putsDebug "The job id is $jobID and ftp Handle is $h."
    putsDebug "Network flow command is $networkFlowCmd."
    putsDebug "The operation is $operation."
    # putsDebug "Network flow id is $m_jobOrders($jobID networkFlowID)"

    #######################
    ## Timeout Operation
    #######################
    if {[string equal $operation timeout]} {
            # TODO: timeout flow not really tested
            set "m_jobOrders($jobID ftpStatus)" closed
            ::ftp::Close $h
            networkCompileComplete $networkID fail ftpTimeout
    #######################
    ## Terminate Operation
    #######################
    } elseif {[string equal $operation terminated]} {
        # putsError "Master failed to run ftp command:$networkFlowCmd."
        set "m_jobOrders($jobID ftpStatus)" closed
        # ::ftp::WaitComplete $h 0
        catch {::ftp::Close $h}
        networkCompileComplete $networkID fail ftpTerminated
    ######################
    ## Error Operation
    ######################
    } elseif {[string equal $operation error]} {

        if {[string equal $networkFlowCmd ftpDownloadFlow] && [string equal $operationStatus "Error getting file size!"]} {
            incr "m_jobOrders($jobID numDownloadFiles)"

             # check any others file to download ?
            if {$m_jobOrders($jobID numDownloadFiles) < $m_jobOrders($jobID totalDownloadFiles)} {
                set fileList $m_jobOrders($jobID downloadFiles)
                set fileName [lindex $fileList $m_jobOrders($jobID numDownloadFiles)]
                set fileNameD [file join $networkID-dir $fileName]
                after 0 [subst {::ftp::FileSize $h $fileNameD}]
            } else {
                set "m_jobOrders($jobID ftpStatus)" closed

                putsDebug "Number of successful downloaded files: $m_jobOrders($jobID numSuccessfulDownloadFiles)"
                putsDebug "Number of downloaded files: $m_jobOrders($jobID numDownloadFiles)"
                putsDebug "Total downloaded files: $m_jobOrders($jobID totalDownloadFiles)"

                # change this number will affect the ftpProgressCallback
                if {[string equal $m_jobOrders($jobID numSuccessfulDownloadFiles) "0"]} {
                    set ftpStatus "fail noResultFile"
                    catch {::ftp::Close $h}

                    comm::comm send -async "$m_slavesInfo($slaveID listenPort) $m_slavesInfo($slaveID host)" "qSlaveObj remoteCmd {postProcess {$ftpStatus}} networkCompileComplete $networkID $m_commPassword"

                } else {
                    # after 5000 [subst {::ftp::Close $h}]
                    catch {::ftp::Close $h}
                    incr "m_jobOrders($jobID networkFlowID)"
                    startNetworkCompile $networkID
                }

            }

        } else {
            # putsError "Master failed to run ftp command:$networkFlowCmd."
            set "m_jobOrders($jobID ftpStatus)" closed
            # ::ftp::WaitComplete $h 0
            catch {::ftp::Close $h}
            # networkCompileComplete $networkID fail ftpError
            set ftpStatus "fail ftpError"

            comm::comm send -async "$m_slavesInfo($slaveID listenPort) $m_slavesInfo($slaveID host)" "qSlaveObj remoteCmd {postProcess {$ftpStatus}} networkCompileComplete $networkID $m_commPassword"
        }


    ######################
    ## Connect Operation
    ######################
    } elseif {[string equal $networkFlowCmd ftpUploadConnFlow] || [string equal $networkFlowCmd ftpDownloadConnFlow]} {
        # Connect return
        if {[string equal $operation connect]} {
            set "m_jobOrders($jobID ftpStatus)" connected
            catch {::ftp::Type $h binary}
        # Type return and make sure the ftp status is connected
        } elseif {[string equal $operation type] && [string equal $m_jobOrders($jobID ftpStatus) connected]} {
            incr "m_jobOrders($jobID networkFlowID)"
            # Check if the flow is upload or download flow.
            # If upload flow, perform put operation.
            # If download flow, perform get operation.
            if {[string equal $m_networkFlow($m_jobOrders($jobID networkFlowID)) ftpUploadFlow]} {
                set fileList $m_jobOrders($jobID uploadFiles)
                set fileName [lindex $fileList $m_jobOrders($jobID numUploadFiles)]
                set fileNameD [file tail $fileName]
                set fileNameD [file join $networkID-dir $fileNameD]
                catch {::ftp::Put $h $fileName $fileNameD}
            } elseif {[string equal $m_networkFlow($m_jobOrders($jobID networkFlowID)) ftpDownloadFlow]} {
                set fileList $m_jobOrders($jobID downloadFiles)
                set fileName [lindex $fileList $m_jobOrders($jobID numDownloadFiles)]
                set fileNameD [file join $networkID-dir $fileName]
                ::ftp::FileSize $h $fileNameD
            } else {
                putsError "================ Unexpected FTP flow. ================"
                set "m_jobOrders($jobID ftpStatus)" closed
                catch {::ftp::Close $h}
                networkCompileComplete $networkID fail ftpUnexpected
            }
        }

    ############################
    ## Upload/Download Operation
    ############################
    } elseif {[string equal $networkFlowCmd ftpUploadFlow] || [string equal $networkFlowCmd ftpDownloadFlow]} {
        if {[string equal $operation put]} {
            # check if I need to put another files
           incr "m_jobOrders($jobID numUploadFiles)"
           if {$m_jobOrders($jobID numUploadFiles) < $m_jobOrders($jobID totalUploadFiles)} {
                set fileList $m_jobOrders($jobID uploadFiles)
                set fileName [lindex $fileList $m_jobOrders($jobID numUploadFiles)]
                set fileNameD [file tail $fileName]
                set fileNameD [file join $networkID-dir $fileNameD]
                catch {::ftp::Put $h $fileName $fileNameD}

           } else {
                # upvar ::ftp::ftp$h ftp
                set "m_jobOrders($jobID ftpStatus)" closed
                # catch {after cancel $ftp(Wait)}
                ::ftp::Close $h
                incr "m_jobOrders($jobID networkFlowID)"
                startNetworkCompile $networkID
            }

        } elseif {[string equal $operation get]} {
            # Get operation complete seems to be a false alarm.
            # Fcopy is still performing at the background.
            # Let's the ftp progress callback to handle this
        } elseif {[string equal $operation size]} {
            set "m_jobOrders($jobID resultFileSize)" [lindex $args 2]
            set fileList $m_jobOrders($jobID downloadFiles)
            set fileName [lindex $fileList $m_jobOrders($jobID numDownloadFiles)]
            set fileNameD [file join $networkID-dir $fileName]

            if {[string equal $m_enableSubResultDir 1]} {
                set resultFileDir [file join $m_resultDir job-$jobID]
                if {![file exists $resultFileDir]} {
                    file mkdir $resultFileDir
                }
                set resultFile [file join $resultFileDir $fileName]

            } else {
                set resultFile [file join $m_resultDir $fileName]
            }
            catch {::ftp::Get $h $fileNameD $resultFile}

        } else {
            putsError "================ Unexpected FTP flow. ================"
            set "m_jobOrders($jobID ftpStatus)" closed
            # I'm the biggest hacker of the world.
            # Something is still processing in the background, is this a FTP bug ?
            # However, call ftp::Waitomplete will eliminate the background process.
            # ::ftp::WaitComplete $h 1
            ::ftp::Close $h
            networkCompileComplete $networkID fail ftpUnexpected
        }
    }
    return
}

#############################################################################
## Method:  ::quartus::qMaster::genericRemoteCallback
##
## Arguments: Network ID and Status
##
## Description: This procedure will be called by slave when each job is done.
##              The return status are:
##              (1) Success
##              (2) Fail
##              (3) Timout
##              (4) stop
## Notes: (1) Call this procedure when we need to decide whether we should
##            continue to next flow.
##        (2) Call networkCompileComplete when we don't need to continue to next
##            flow.
##
#############################################################################
itcl::body ::quartus::qMaster::genericRemoteCallback {networkID status args} {
    putsDebug "*****Calling qMaster::genericRemoteCallback $networkID $status $args.*****"

    set jobID [getjobID $networkID]
    set networkFlowID $m_jobOrders($jobID networkFlowID)
    set networkFlowCmd $m_networkFlow($m_jobOrders($jobID networkFlowID))
    set slaveID $m_jobOrders($jobID status)
    set slaveHost $m_slavesInfo($slaveID host)
    putsDebug "Job ID is $jobID."

    if {[string equal $status success]} {

        # if the flow is preProcessFlow, we need to
        # 1) Get the ftp listen port
        # 2) Get the jobs limit and add it to the slave list. File an event to kick of the job.
        if {[string equal $networkFlowCmd preProcessFlow]} {

            set "m_jobOrders($jobID ftpListenPort)" [lindex $args 0]
            set jobLimit [lindex $args 1]

            if {![string equal $m_uniqueSlavesInfo($slaveHost:$m_slavesInfo($slaveID listenPort) setupJobsLimit) done] && $jobLimit > 1} {
                # depends on how many jobs limit this slave can accept and add them in to the slave list
                set tmp 1
                while {$tmp < $jobLimit} {
                    set m_skipDuplicateSlave 0
                    addSlaveID $slaveHost:$m_slavesInfo($slaveID listenPort)
                    set m_skipDuplicateSlave 1

                    # file the event after 30 seconds
                    after 30000 qMasterObj startNetworkJobs
                    incr tmp
                }
            }
            # this flag tells everybody that setupJobsLimit is already been performed, so
            # we no need to perform again for this slave.
            set "m_uniqueSlavesInfo($slaveHost:$m_slavesInfo($slaveID listenPort) setupJobsLimit)" done

        # if the flow is compileFlow, we need to check for any other remote commands
        } elseif {[string equal $networkFlowCmd compileFlow]} {
            incr "m_jobOrders($jobID numRemoteCmds)"
            if {$m_jobOrders($jobID numRemoteCmds) < $m_jobOrders($jobID totalRemoteCmds)} {
                startNetworkCompile $networkID
                # return here so that it won't jump to the next flow
                return
            }
        }
        incr "m_jobOrders($jobID networkFlowID)"
        startNetworkCompile $networkID
    } elseif {[string equal $status fail]} {
        set failStatus [lindex $args 0]
        # Set slave down if slave is busy, it will enable back during slave pooling
        # If fail for other reason (e.g. remoteCmd), do not need to set slave down
        if {[string equal $failStatus slaveBusy]} {
            set "m_slavesInfo($slaveID status)" down
        }
        networkCompileComplete $networkID fail $failStatus

    # TODO: timout & stop are not implemented yet
    } elseif {[string equal $status timeout]} {
        # incr "m_jobOrders($jobID networkFlowID)"
        # startNetworkCompile $networkID
    } elseif {[string equal $status stop]} {
        # incr "m_jobOrders($jobID networkFlowID)"
        # startNetworkCompile $networkID
    } else {
        putsError "================ Undefined return status: $status. ================"
    }
    return
}

#############################################################################
## Method:  ::quartus::qMaster::networkCompileComplete
##
## Arguments: Network ID and status
##
## Description: This method is called when a job is done. The status:
##              (1) success
##              (2) fail reason
##              (3) stop
##
#############################################################################

itcl::body ::quartus::qMaster::networkCompileComplete {networkID status args} {

    putsDebug "*****Calling qMaster::networkCompileComplete $networkID $status $args."
    set boolFailLimit 0
    # Get job id that correspond to network Id
    set jobID [getjobID $networkID]
    # Get slave Id that run this job
    set slaveID $m_jobOrders($jobID status)
    set reason [lindex $args 0]

    putsDebug "Slave Id:$slaveID finished compile job Id:$jobID."

    initJobsOrder $jobID

    # Free this slave
    set "m_slavesInfo($slaveID jobID)" -1

    # reset the ftpGetPutCount if getPuting operation is fail
    if {[string equal $m_slavesInfo($slaveID ftpStatus) getPuting]} {
        set "m_slavesInfo($slaveID ftpStatus)" none
        if {![string equal $m_uniqueSlavesInfo($m_slavesInfo($slaveID host):$m_slavesInfo($slaveID listenPort) ftpGetPutCount) 0]} {
            set "m_uniqueSlavesInfo($m_slavesInfo($slaveID host):$m_slavesInfo($slaveID listenPort) ftpGetPutCount)" [expr $m_uniqueSlavesInfo($m_slavesInfo($slaveID host):$m_slavesInfo($slaveID listenPort) ftpGetPutCount) - 1]
        }
    }

    if {[string equal $m_stopJobs 1] && [string equal $status fail]} {
        set status stop
        set reason {}
    }

    # update the job's status
    if {[string equal $status success]} {
        set "m_jobOrders($jobID status)" done
        set jobStatus Done
    } elseif {[string equal $status fail]} {
        # Do not increment when the slave down
        if {![string equal $reason slaveDown]} {
            incr "m_jobOrders($jobID numFails)"
        }

        if {$m_jobOrders($jobID numFails) < $m_failsLimit} {
             set "m_jobOrders($jobID status)" pending
        } else {
             set "m_jobOrders($jobID status)" fail
             set boolFailLimit 1
        }
        set jobStatus Fail
    } elseif {[string equal $status stop]} {
        set "m_jobOrders($jobID status)" stop
        set jobStatus Stop
    } else {
        putsError "================ Undefined return status: $status. ================ "
    }

    # Evaluate callback script for each job completes
    if {![string equal $m_statusCallback {}]} {
        eval "$m_statusCallback $jobID $networkID $m_slavesInfo($slaveID host) {$m_jobOrders($jobID commands)} $jobStatus $reason"
    }

    # Callback the failLimit
    if {[string equal $boolFailLimit 1 ]} {
        set reason failLimit
        if {![string equal $m_statusCallback {}]} {
            eval "$m_statusCallback $jobID $networkID $m_slavesInfo($slaveID host) {$m_jobOrders($jobID commands)} $jobStatus $reason"
        }
    }

    # Start a new network Job.
    if {[catch {set status [startNetworkJobs]} err_msg]} {
        putsInfo "Master is unable to perform new network job. The reason is $err_msg"
        set status done
	}

    # If the return status is done, call the exit script
	if {[string equal $status done] || [string equal $status slavesDown]} {

        if {[string equal [isAllJobsDone] 1]} {
            set m_returnStatus 1
        } else {
            set m_returnStatus 0
	    }

        clearJobsID
        putsDebug "Calling the exit script to exit the event loop."
        eval $m_exitScript
        # to prevent other events evaluate the exit script more than once
        set m_exitScript {}
	}
    return
}

#############################################################################
## Method:  ::quartus::qMaster::getjobID
##
## Arguments: Network ID
##
## Description: Get Job ID from network ID.
##
#############################################################################
itcl::body ::quartus::qMaster::getjobID {networkID} {
    # Go through each job id to look for the network ID
    # If found, return the network id, else return -code error
    foreach index [array names m_jobOrders *networkID] {
        if {[string equal $m_jobOrders($index) $networkID]} {
            return [lindex $index 0]
        }
    }
    return -code error "qMaster is unable to get Job ID from network ID $networkID."
}

#############################################################################
## Method:  ::quartus::qMaster::getPendingJob
##
## Arguments: None.
##
## Description: Look for any pending job.
##
#############################################################################
itcl::body ::quartus::qMaster::getPendingJob {} {
    # Go through each job Id and search for the pending job
    # for {set jobID 0} {$jobID < $m_totalJobs} {incr jobID} {
    # }
    
    foreach index [array names m_jobOrders *commands] {
        set jobID [lindex $index 0]

        if {[string equal $m_jobOrders($jobID status) pending]} {
            return $jobID
        }
    }
    return -1
}

#############################################################################
## Method:  ::quartus::qMaster::isAllJobsDone
##
## Arguments: None.
##
## Description: Return 1 for true 0 for false.
##
#############################################################################
itcl::body ::quartus::qMaster::isAllJobsDone {} {
    # Go through each job Id and search for the pending job
    # for {set jobID 0} {$jobID < $m_totalJobs} {incr jobID} {
    # }
    
    foreach index [array names m_jobOrders *commands] {
        set jobID [lindex $index 0]

        if {![string equal $m_jobOrders($jobID status) done]} {
            return 0
        }
    }
    return 1
}

#############################################################################
## Method:  ::quartus::qMaster::isLSFRunning
##
## Arguments: None.
##
## Description: Return 1 for true 0 for false.
##
#############################################################################
itcl::body ::quartus::qMaster::isLSFRunning {} {
    # Go through each job Id and search for the pending job
    # for {set jobID 0} {$jobID < $m_totalJobs} {incr jobID} {
    # }
    foreach index [array names m_jobOrders *commands] {
        set jobID [lindex $index 0]
        if {[string equal $m_jobOrders($jobID status) $m_LSFCluster]} {
            return 1
        }
    }
    return 0
}

#############################################################################
## Method:  ::quartus::qMaster::initJobsOrder
##
## Arguments: Job ID
##
## Description: Initialize the jobs order array.
##
## Note:
##      (1) This procedure is called by setupEnvironment and
##          networkCompileComplete.
##      (2) We should not initialize m_jobOrders($jobID numFails).
##
#############################################################################
itcl::body ::quartus::qMaster::initJobsOrder {jobID} {

    set "m_jobOrders($jobID status)" pending
    set "m_jobOrders($jobID networkID)" -1
    set "m_jobOrders($jobID slaveID)" -1
    set "m_jobOrders($jobID networkFlowID)" -1
    set "m_jobOrders($jobID ftpHandle)" -1
    set "m_jobOrders($jobID ftpStatus)" closed
    set "m_jobOrders($jobID resultFileSize)" 0
    set "m_jobOrders($jobID numUploadFiles)" 0
    set "m_jobOrders($jobID numDownloadFiles)" 0
    set "m_jobOrders($jobID numSuccessfulDownloadFiles)" 0
    set "m_jobOrders($jobID numRemoteCmds)" 0

    return
}
#############################################################################
## Method:  ::quartus::qMaster::initSlavesInfo
##
## Arguments: Slave ID
##
## Description: Initialize the slaves array.
##              This procedure must be called by setupEnvironment to clean up the
##              previous slave status.
##
#############################################################################
itcl::body ::quartus::qMaster::initSlavesInfo {slaveID} {
    set "m_slavesInfo($slaveID ftpListenPort)" -1
    set "m_slavesInfo($slaveID status)" alive
    set "m_slavesInfo($slaveID jobID)" -1
    set "m_slavesInfo($slaveID ftpStatus)" none
    return
}

#############################################################################
## Method:  ::quartus::qMaster::initNetworkFlow
##
## Arguments: None
##
## Description: Initialize network flow.
##
#############################################################################
itcl::body ::quartus::qMaster::initNetworkFlow {} {

    if {[info exist m_networkFlow]} {
        unset m_networkFlow
    }

    set useFTP [get_ini_var -name dq_use_ftp]

    if { ![string equal $useFTP ""] } {
        set useFTP [string tolower $useFTP]
        if { [string equal $useFTP on] || [string equal $useFTP true] } {
            set m_useFTP 1
        }
    }

    if {[string equal $m_LSFMode 0]} {
        if {[string equal $m_useFTP 0]} {
            set m_networkFlow(-1) invalidFlow
            set m_networkFlow(0) preProcessFlow
            set m_networkFlow(1) uploadFlow
            set m_networkFlow(2) compileFlow
            set m_networkFlow(3) downloadFlow
            set m_networkFlow(4) postProcessFlow
            set m_networkFlow(5) exitFlow
        } else {
            set m_networkFlow(-1) invalidFlow
            set m_networkFlow(0) preProcessFlow
            set m_networkFlow(1) ftpUploadConnFlow
            set m_networkFlow(2) ftpUploadFlow
            set m_networkFlow(3) compileFlow
            set m_networkFlow(4) ftpDownloadConnFlow
            set m_networkFlow(5) ftpDownloadFlow
            set m_networkFlow(6) postProcessFlow
            set m_networkFlow(7) exitFlow
        }
    } else {
        set m_networkFlow(-1) LSFInvalidFlow
        set m_networkFlow(0) LSFPreProcessFlow
        set m_networkFlow(1) LSFCompileFlow
        set m_networkFlow(2) LSFPostProcessFlow
        set m_networkFlow(3) LSFExitFlow
    }
    return
}

#############################################################################
##  Global Procedures and Objects
#############################################################################
::quartus::qMaster qMasterObj


