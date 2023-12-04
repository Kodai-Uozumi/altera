      QUARTUS II DISTRIBUTED MASTER/SLAVE TOOLKIT README

This toolkit provides users with the facility to start
Quartus II compilations on computers across a network. This 
toolkit provides ::quartus::qMaster and ::quartus::qSlave Tcl
packages.

-----------------------------------------------------------------

------------------------
Tcl Package and Version:
------------------------

    ::quartus::qMaster 2.0

------------
Description:
------------

    This package contains the set of Tcl functions for
    submitting any jobs to the slave hosts (computers).


---------
Synopsis:
---------

    Usage: qMasterObj commandName [parameters]

    Note: Depending on the command, the [parameters] can be 
    required or optional.

-------------
Tcl Commands:
-------------

qMasterObj setResultDir resultDir
    Specifies the directory where the results from the slaves 
    will be stored. The directory name can be a relative or full 
    path name.

qMasterObj addUploadFile jobID fileName
    Specifies a file to be copied to the slave for this
    particular job ID.

    jobID
        The jobID is a unique name used to identify a job. The jobID
        can be an integer or string.
    fileName
        The file name can have a relative or full path name.

qMasterObj addDownloadFile jobID fileName
    Specifies a file to be copied from the slave for this
    particular job ID.

    jobID
        The jobID is a unique name used to identify a job. The jobID
        can be an integer or string.
    fileName
        The file name should not include a directory path.

qMasterObj addJobCommand jobID commandName
    Specifies a remote command to be run on the slave for this
    particular job ID.

    jobID
        The jobID is a unique name used to identify a job. The jobID
        can be an integer or string.
    commandName
        Specifies the command string that is to be run.
        Example: qMasterObj addJobCommand 0 "quartus_sh -t test.tcl"

qMasterObj addSlaveID hostName [hostName1 hostName2...]
    Specifies the slave hosts that the master will connect to.

    hostName
        Example: qMasterObj addSlaveID pg-sw23 172.23.12.24:1977
        If the port is omitted, the master will use the default
        port which is 1977.

qMasterObj pingSlaveID hostName
    Ping the slave host. Return 0 if the slave host is invalid or
    unavailable. Return 1 if the slave host is valid or available.

    hostName
        Example: qMasterObj pingSlaveID pg-sw23:1977
        If the port is omitted, the master will use the default
        port which is 1977.

qMasterObj clearSlavesID
    Clears all the slave IDs that have been added by the
    qMasterObj addSlaveID command.

qMasterObj clearJobsID
    Clears all the job IDs that have been added by the
    qMasterObj addUploadFile, qMasterObj addDownloadFile, and
    qMasterObj addJobCommand commands.

qMasterObj setLSFMode mode
    Specifies whether to send the jobs to an LSF cluster. If the
    mode is 1, all jobs will be sent to an LSF cluster. If the
    mode is 0, all jobs will be sent to the slave hosts that
    are started with the quartus_sh -qslave command. The default
    mode is set to 0. The LSF cluster must be configured by an
    LSF administrator to make sure the LSF_BINDIR environment
    variable is set to the LSF bin directory. Also, make sure that
    all the hosts in a LSF cluster are using the same version of
    the Quartus II software. Because the LSF software is designed
    to work on networks where all the hosts have access to shared
    file space on the network, files are not copied to the hosts
    before running the jobs, nor are results files copied back
    from those machines after the jobs complete. These tasks are
    performed by the LSF software automatically. Please see the
    documentation for your LSF software for more details.

qMasterObj setLSFQueue queueName
    Specifies the LSF's queue that is used for jobs submission. If
    not specified, the jobs will be submitted to LSF's default queue.

    queueName
        Example: qMasterObj setLSFQueue priority
        Specifies the LSF's "priority" queue for jobs submission.

qMasterObj stopJobs
    Stops the master from submitting additional jobs to the
    slaves and stops the jobs that are currently running on the
    slaves. If the job that is running on a slave fails to
    stop for some reason, it waits until that job has finished
    running.

 qMasterObj submitJobs [-statusCallback procName] [-outputCallback procName]
    Launches all the jobs to the slave computers in the cluster.
    This command does not return until all the jobs are finished.
    Returns 1 if all jobs ran successfully. Returns 0 otherwise.
    After all the jobs are complete, the qMasterObj clearJobID
    command will be called automatically.

    [-statusCallback procName]
        If the -statusCallback option is specified, the callback
        procedure is evaluated to report the current job
        status. When evaluating the callback procedure, the
        arguments below are appended to the callback script.

            jobID       - The job ID.
            networkID	- The unique network ID to uniquely
                          identify each job in the network.
            hostName    - The of the slave host that is running
                          this job ID.
            remoteCmd	- The remote command(s) that run on slave
                          host.
            status      - Start, Download, Run, Upload, Done,
                          Fail, or Stop.
            args        - Failure reason. This argument will be
                          empty if there is no failure reason.
                          The failure reasons are slaveDown,
                          slaveBusy etc. See below for more
                          details.

        In LSF mode, the hostName is "LSFCluster".

        Description of status:
            Start       -  Master starts submitting the job to
                           the slave.
            Upload      -  Master starts copying files to slave.
                           In LSF mode, the master performs
                           initialization without copying files
                           to the slave.
            Download    -  Master starts copying results files
                           from the slave. In LSF mode, the
                           master copies the results files to the
                           shared results directory.
            Run         -  Slave is running the job. In LSF mode,
                           the job has been submitted to the LSF
                           cluster using the "bsub" command.
            Done        -  The job has finished running.
            Fail        -  The job has failed to run.
            Stop        -  The job was stopped by user.

        Description of args status:
            slaveDown    - The slave host is down.
            ftpTimeout   - These are errors that occur during
            ftpTerminated  file transfer between master and
            ftpUnexpected  slave.
            ftpError
            ftpConnect

            slaveBusy    - The slave is busy and unable to
                           perform any jobs.
            invalidVer   - The slave is using the different
                           version of the Quartus II software
                           than the master.
            remoteCmd    - The slave failed to execute the remote
                           command that was submitted by master.
            noResultFile - The master was unable to find the
                           results file(s) after job completion.
            failLimit    - The number of failures of this job has
                           exceeded the failure limit. The
                           failure limit is set to 2.
            noAvailSlaves- The master is unable to find any
                           available slaves.
            noAvailLSF   - The master is unable to find any
                           available LSF or failed to issue the
                           "bsub" command in LSF mode.

    [-outputCallback procName]
        If the -outputCallback option is specified, the callback
        procedure will be evaluated for all the messages. Two
        arguments are appended to the callback script:

            Severity     - Info, Warning or Error.
            Message      - The text message body.

qMasterObj setFailsLimit limit
    Specifies failure limit for a job. The default value is 2.

qMasterObj getSlaveQuartusVer hostName
    Return the Quartus II software version that the slave host is
    currently running. Return 0 if the slave host is invalid or
    unavailable.

    hostName
        Example: qMasterObj getSlaveQuartusVer pg-sw23:1977
        If the port is omitted, the master will use the default
        port which is 1977.

qMasterObj disableVerCheck
    Disable the Quartus II sofware version checking in non-LSF
    mode. By default, the master will check to make sure all
    the slaves are running the same version of the Quartus II
    software as the master.

qMasterObj enableVerCheck
    Enable the Quartus II software version checking in non-LSF
    mode. By default, this checking is enabled.


--------------
Example Usage:
--------------

This is a simple example of how to use the master API:

# load the ::quartus::qMaster package
package require ::quartus::qMaster

# output callback proc for the qMaster package
proc outputCallback {severity msg} {
    puts "$severity: $msg"
    return
}

# status callback proc for the qMaster package
proc statusCallback {jobID networkID hostName remoteCmd status args} {
    puts "$jobID $networkID $hostName {$remoteCmd} $status $args"
    return
}

# Setup the slave hosts
qMasterObj addSlaveID pg-sw23:1977

# Set the results directory
qMasterObj setResultDir "f:/research/designs/results"

#Add files to upload
qMasterObj addUploadFile 0 "f:/research/designs/one_wire0.qar"
qMasterObj addUploadFile 0 "f:/research/designs/qcluster.tcl"


# Add file to download
qMasterObj addDownloadFile 0 "one_wire0-result.qar"

# Add job command
qMasterObj addJobCommand 0 "quartus_sh -t qcluster.tcl 0"

# Submit the job
qMasterObj submitJobs -statusCallback [namespace code statusCallback]  \
-outputCallback [namespace code outputCallback]

-----------------------------------------------------------------


------------------------
Tcl Package and Version:
------------------------

    ::quartus::qSlave 1.0

------------
Description:
------------

    This package contains the set of Tcl functions for
    starting the slave daemon on the slave hosts.


---------
Synopsis:
---------

    Usage: qSlaveObj commandName [parameters]

    Note: Depending on the command, the [parameters] may be
    optional or required.

-------------
Tcl Commands:
-------------

qSlaveObj startDaemon [-statusCallback procName] [-outputCallback procName]
    This command starts the slave and enters the event loop.

    [-statusCallback procName]
        If the -statusCallback option is specified, the callback
        procedure will be evaluated to report the current job
        status. When evaluating the callback procedure, the
        arguments below are appended to the callback script.
            networkID   - The unique network ID.
            hostName    - The master host's name.
            status      - preProcess, startRemoteCommand,
                          postProcess, or jobReleased.

        Description of status:
            preProcess         - Slave begins initialization
                                 before running the job.
            StartRemoteCommand - Slave starts running the job.
            postProcess        - Slave starts cleaning up before
                                 it releases the job.
            jobReleased        - This indicates the slave has
                                 released the job.

    [-outputCallback procName]
        If the -outputCallback option is specified, the callback
        procedure will be evaluated for all the messages. Two
        arguments are appended to the callback script:

            Severity	    - Info, Warning or Error.
            Message	    - The text message body.

qSlaveObj config [-listenPort port] [-jobsLimit value]
    [-listenPort port]
        This command specifies the listening port on the slave. 
        If the port is not specified, the default listening port 
        1977 will be used.

    [-jobsLimit value]
    	This command specifies the maximum number of jobs the slave 
    	can accept. If not specified, the default job limit 1 will 
    	be used.

--------------
Example Usage:
--------------

This is a simple example to use the slave API:

# load the ::quartus::qSlave package
package require ::quartus::qSlave

# output callback proc for the qSlave package
proc outputCallback {severity msg} {
    puts "$severity: $msg"
    return
}

# output status  proc for the qSlave package
proc statusCallback {networkID hostName remoteCmd args} {
    puts "$networkID $hostName $remoteCmd $args"
    return
}

# configure the slave
qSlaveObj config -listenPort 1977 -jobsLimit 1

# start the slave's daemon
qSlaveObj startDaemon -outputCallback [namespace code outputCallback]    \
-statusCallback [namespace code statusCallback]

-----------------------------------------------------------------

---------------------------
Frequently asked questions:
---------------------------

1.  Can one slave run more than a job at a time?
    
    Yes. For example, the Tcl command "qSlaveObj config -jobsLimit 2"
    configures the slave to run a maximum of two jobs at a time.
    Alternatively, you can also use the quartus_sh command 
    directly - "quartus_sh --qslave jobslimit=2".

2.  Can the slave and the master use a different version of
    the Quartus II software?

    Yes, by calling the "qMasterObj disableVerCheck"
    command to disable the Quartus II software version checking.
    However, depending on the job you run, undesired results can
    occur if the slaves have a different version of the Quartus II
    software from the master. To turn on the Quartus II software 
    version checking, you must call the 
    "qMasterObj enableVerCheck" command.

3.  Does distributed master/slave toolkit support multiple
    platforms?

    Yes. The toolkit has been tested on Windows and UNIX
    platforms.

4.  Can I start the slave and run the master from different
    platforms? For example, I start a slave in a UNIX machine
    and use the Windows machine as a master to submit the jobs
    to that UNIX machine.

    Yes. You can, as long as you can handle the different file
    formats that are generated from the different platforms.

5.  Can I start slave and master at the same machine?
    
    Yes, you can.

6.  Why did I get the following error message "error writing
    file35d1b00: no space left on device" on the master?
    
    This is because the master and slave do not check hard disk 
    space availability. Make sure that there is enough hard disk 
    space on both slave and master before you submit any jobs.
