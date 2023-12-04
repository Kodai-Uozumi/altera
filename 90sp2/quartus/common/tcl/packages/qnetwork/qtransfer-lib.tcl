
#############################################################################
##  qtransfer-lib.tcl - v1.0
##
##  Quartus qTransfer Library Package
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

package provide ::quartus::qTransfer 1.0
package require ::quartus::qNetwork 1.0
package require Itcl
package require Thread

itcl::class ::quartus::qTransfer {

    inherit qNetwork
    constructor {{debugMode 0}} {qNetwork::constructor $debugMode} {
        putsDebug "qTransfer: Constructor is called."
    }

    destructor {
        putsDebug "qTransfer: Destructor is called."
    }


    ###########################
    ## Protected APIs
    ###########################
    protected method TH_CreateChannelHandler { }
    protected method TH_CreateClientHandler {host port}
    protected method TH_SendJob {threadID filePathStr}
    protected method TH_SetRemoteSettings {threadID args}
    protected method TH_CreateServerHandler {port}
    protected method TH_SetServerLocalSettings { args }
    protected method TH_SendMeStatus { threadID timeout }
    protected method TH_InitiateGetFile { threadID filePathStr}
    protected method genKey { }

    ###########################
    ## Public APIs
    ###########################
    public method TH_SendChannelToThread {threadID sock}
    public method TH_SetChildThreadSetting {threadID var value}
    public method TH_ReceivedNewConnection {sock host port}

    public method TH_ChannelHandler { args }
    public method TH_GetFile { args }


}


#############################################################################
    itcl::body ::quartus::qTransfer::TH_CreateChannelHandler { } {

        set threadID [thread::create -joinable {

            set _sock 0
            set _workingStatus "idle"
            set _workingStatusDetails "no_activity"
            set _workingDirectory ""

            #############################################################################
            ## Method: _TH_SendSockFile
            ##
            ## Arguments: Out channel, File Path
            ##
            ## Description: Transfer file data to output socket.
            ##
            #############################################################################

            proc _TH_SendSockFile {outChannel sendFilePath} {

                set size [file size $sendFilePath]

                set inChannel [open $sendFilePath]

                fconfigure $inChannel -translation binary

                set sendFileName [file tail $sendFilePath]

                puts $outChannel [list "file" $sendFileName $size]

                if { [catch {fcopy $inChannel $outChannel} errMsg] } {
                    close $inChannel
                    error $errMsg
                }

                close $inChannel

                return
            }

            #############################################################################
            ## Method: _TH_SetRemoteSettings
            ##
            ## Arguments: Variable name, Value
            ##
            ## Description: Set variable to the remote thread connecting to this thread.
            ##
            #############################################################################

            proc _TH_SetRemoteSettings {varName value} {
                global _sock

                catch {puts $_sock [list "settings" $varName $value]}

                return
            }

            #############################################################################
            ## Method: _TH_SendMeStatus
            ##
            ## Arguments: Timeout
            ##
            ## Description: Ask the remote thread to send current status.
            ##
            #############################################################################

            proc _TH_SendMeStatus { timeout } {
                global _sock

                catch {puts $_sock "sendmestatus"}

                if { $timeout > 0 } {
                    after $timeout [list _TH_ExecuteCallback "error" "timeout"]
                }

                return
            }

            #############################################################################
            ## Method: _TH_CheckAllFilesExistence
            ##
            ## Arguments: File Paths
            ##
            ## Description: Check all files existance.
            ##
            #############################################################################

            proc _TH_CheckAllFilesExistence {filePathStr} {

                foreach filePath $filePathStr {
                    if { ![file exists $filePath] } {
                        return $filePath
                    }
                }

                return 1
            }

            #############################################################################
            ## Method: _TH_InitiateSendingJobs
            ##
            ## Arguments: File Paths
            ##
            ## Description: Interate to all files to be transfered and put a send request.
            ##
            #############################################################################

            proc _TH_InitiateSendingJobs {filePathStr} {
                global _sock

                set checkFiles [_TH_CheckAllFilesExistence $filePathStr]
                if { $checkFiles != 1 } {
                    _TH_ExecuteCallback "error" "file_missing-->$checkFiles"
                    return 0
                }

                foreach filePath $filePathStr {
                    if { [catch {_TH_SendSockFile $_sock $filePath} errMsg] } {
                        error $errMsg
                    }
                }

                return 1
            }

            #############################################################################
            ## Method: _TH_DemolishChannelHandler
            ##
            ## Arguments: NONE
            ##
            ## Description: Destroy current thread.
            ##
            #############################################################################

            proc _TH_DemolishChannelHandler { } {
                global _sock

                catch {close $_sock}
                catch {thread::release}
                return
            }

            #############################################################################
            ## Method: _TH_DeleteFilesOnError
            ##
            ## Arguments: NONE
            ##
            ## Description: Delete received file(s) that has error.
            ##
            #############################################################################

            proc _TH_DeleteFilesOnError { } {

                global _path
                global _receivedFiles
                global _workingDirectory

                # putsDebug "qTransfer: Deleting failed transfer"

                set workingDirectory $_workingDirectory

                 if { [info exists _path] } {
                    set deletePath [ file join $workingDirectory [lindex [ file split $_path] 0] ]
                    if { [file exists $deletePath] } {
                        catch {file delete -force $deletePath}
                    }
                } else {
                    if { [info exists _receivedFiles] } {
                        foreach {receiveFileName fileSize} $_receivedFiles {
                            set fullPath [file join $workingDirectory $receiveFileName]
                            if { [file exists $fullPath] } {
                                catch {file delete $fullPath}
                            }
                        }
                    }
                }
                
                return

            }

            #############################################################################
            ## Method: _TH_InitiateGetFile
            ##
            ## Arguments: File Paths
            ##
            ## Description: Send request to retrieve files from remote machine.
            ##
            #############################################################################

            proc _TH_InitiateGetFile { filePathStr } {
                global _sock

                catch {puts $_sock [list "sendmefiles" $filePathStr]}
                return
            }


            #############################################################################
            ## Method: _TH_WriteWorkingStatus
            ##
            ## Arguments: Status, Error messege
            ##
            ## Description: Update status of the transfer.
            ##
            #############################################################################

            proc _TH_WriteWorkingStatus {status errMsg} {
                global _workingStatus
                global _workingStatusDetails

                if { ![info exists _workingStatus] || ![string equal $_workingStatus "error"]} {
                    set _workingStatus $status
                    set _workingStatusDetails $errMsg
                }

                return
            }

            #############################################################################
            ## Method: _TH_InitializeReadableSockEvents
            ##
            ## Arguments: NONE
            ##
            ## Description: Set socket events.
            ##
            #############################################################################

            proc _TH_InitializeReadableSockEvents {} {
                global _sock

                fconfigure $_sock -buffering line -blocking 0
                fileevent $_sock readable _TH_ReadableSocketEvent
                return
            }

            #############################################################################
            ## Method: _TH_ReadableSocketEvent
            ##
            ## Arguments: NONE
            ##
            ## Description: Called when socket is readable. 
            ##              If no error put request to read it, else do error handling.
            ##
            #############################################################################

            proc _TH_ReadableSocketEvent {} {
                global _sock
                global _workingStatus
                global _workingStatusDetails
                global _receivedFiles
                global _callback
                
                set ID [_TH_GetThreadID]
                set markedForTermination 0

               if {[catch {gets $_sock line} len] || [eof $_sock]} {
                    # putsDebug "qTransfer: Thread [thread::id] lost connection to $_sock "
                    # putsDebug "qTransfer: Thread [thread::id] managing socket $_sock will be release ..."

                    if { [string equal $_workingStatus "error"] && [info exists _receivedFiles] } {
                        if { [info exists _callback] } {
                            _TH_ExecuteCallback $_workingStatus $_workingStatusDetails
                            set markedForTermination 1
                        }
                        _TH_DeleteFilesOnError
                    }
                    if { !$markedForTermination } {
                        _TH_DemolishChannelHandler
                    }

                } else {
                    _TH_ProcessIncomingSocketData $line
                }

                return
            }

            #############################################################################
            ## Method: _TH_ExecuteCallback
            ##
            ## Arguments: Status, Details
            ##
            ## Description: Ask man thread to execute the callback set by the user.
            ##
            #############################################################################

            proc _TH_ExecuteCallback {status details} {
                global _callback
                global _manThreadID

                set ID [_TH_GetThreadID]

                if { [info exists _callback] } {

                    if { [thread::exists $_manThreadID] } {
                        thread::send -async $_manThreadID [list eval "$_callback $ID $status {$details}" ]
                    }
               }

                _TH_DemolishChannelHandler
                return
            }

            #############################################################################
            ## Method: _TH_SendCurrentStatus
            ##
            ## Arguments: NONE
            ##
            ## Description: Send current status to the remote thread.
            ##
            #############################################################################

            proc _TH_SendCurrentStatus { }  {
                global _sock
                global _workingStatus
                global _workingStatusDetails

                catch {puts $_sock [list "status" $_workingStatus $_workingStatusDetails]}
                return
            }

            #############################################################################
            ## Method: _TH_SendFilesFromGet
            ##
            ## Arguments: File Paths
            ##
            ## Description: Process files retrieaval request, send it if valid.
            ##
            #############################################################################

            proc _TH_SendFilesFromGet {filePathStr} {
                global _sock
                global _path
                global _workingDirectory
                global _callback

                set workingDirectory $_workingDirectory
                set fullFilePathStr {}

                if { [info exists _path] } {
                    set workingDirectory [file join $workingDirectory $_path]
                }

                # START - SPR 197500, Solution: Ignore missing file(s). Don't throw error

                foreach filePath $filePathStr {
                    set filePath [file join $workingDirectory $filePath]

                    if { [file exists $filePath] } {
                        lappend fullFilePathStr $filePath
                    }
                }

                # set checkFiles [_TH_CheckAllFilesExistence $fullFilePathStr]
                # if { $checkFiles != 1 } {
                #    _TH_WriteWorkingStatus "error" "file_missing-->$checkFiles"
                #    _TH_SendCurrentStatus
                #    return 0
                # }

                # END - SPR 197500

                foreach filePath $fullFilePathStr {
                    if { [catch {_TH_SendSockFile $_sock $filePath}] } {
                        # putsDebug "qTransfer: Thread [thread::id] lost connection to $_sock "
                        # putsDebug "qTransfer: Thread [thread::id] managing socket $_sock will be release ..."

                        if { [info exists _callback] } {
                            _TH_ExecuteCallback "error" "connection_reset"
                        } else {
                            _TH_DemolishChannelHandler
                        }

                        return 0
                    } else {
                        _TH_WriteWorkingStatus "success" [file tail $filePath]
                    }
                }

                _TH_SendCurrentStatus
                return 1
            }

            #############################################################################
            ## Method: _TH_ProcessIncomingSocketData
            ##
            ## Arguments: Line
            ##
            ## Description: Process data type received from the socket.
            ##
            #############################################################################

            proc _TH_ProcessIncomingSocketData {line} {
                global _sock

                array set arguments {}
                set i 0
                foreach arg $line {
                    set arguments($i) $arg
                    incr i
                }

                set type $arguments(0)

                if { [string equal -nocase $type "file"] } {
                    _TH_ReceivedSocketFile $arguments(1) $arguments(2)
                } elseif {[string equal -nocase $type "settings"] } {
                    _TH_CreateSettings $arguments(1) $arguments(2)
                } elseif {[string equal -nocase $type "status"] } {
                    _TH_ExecuteCallback $arguments(1) $arguments(2)
                } elseif {[string equal -nocase $type "sendmestatus"] } {
                    _TH_SendCurrentStatus
                } elseif {[string equal -nocase $type "sendmefiles"] } {
                    _TH_SendFilesFromGet $arguments(1)
                } else {
                    puts "Error: Unknown command received from $_sock : $type !";
                }

                array unset arguments
                return
            }


            #############################################################################
            ## Method: _TH_CreateSettings
            ##
            ## Arguments: Variable name, Value
            ##
            ## Description: Create sent variable from the remote thread.
            ##
            #############################################################################

            proc _TH_CreateSettings { varName value } {
                global _host

                if { [string equal $varName _path] } {
                    global _path
                    set _path $value
                } elseif { [string equal $varName _ID] } {
                    global _ID
                    set _ID $value
                } else {
                    puts "Warning: Received unknown variable setting $varName from $_host !"

                    _TH_WriteWorkingStatus "error" "unknown_variable_setting-->$varName"
                    _TH_DeleteFilesOnError
                    _TH_SendCurrentStatus
                }

                return
            }

            #############################################################################
            ## Method: _TH_ReceivedSocketFile
            ##
            ## Arguments: File Name, Size
            ##
            ## Description: Save incoming data to a file. Read only with specifed size.
            ##
            #############################################################################

            proc _TH_ReceivedSocketFile {name size} {
                global _sock
                global _path
                global _receivedFiles
                global _workingDirectory

                lappend _receivedFiles $name $size

                set workingDirectory $_workingDirectory

                if { [info exists _path] } {
                    set workingDirectory [file join $workingDirectory $_path]
                }

                if {![file exists $workingDirectory]} {
                    if { [catch {file mkdir $workingDirectory}] } {
                        _TH_WriteWorkingStatus "error" "failed_to_create_path"
                        _TH_DeleteFilesOnError
                        set flushed [read $_sock $size]
                        unset flushed
                        return 0
                    }
                }

                set fileFullPath [file join $workingDirectory $name]

                if { [ catch {set outputFile [open $fileFullPath w]} ] } {
                    _TH_WriteWorkingStatus "error" "cannot_write_file-->$name"
                    _TH_DeleteFilesOnError
                    set flushed [read $_sock $size]
                    unset flushed
                    return 0
                }

                fconfigure $outputFile -translation binary

                if { [catch {fcopy $_sock $outputFile -size $size}] } {
                    _TH_WriteWorkingStatus "error" "cannot_read_channel-->$name"
                    close $outputFile
                    _TH_DeleteFilesOnError
                    return 0
                } else {
                    close $outputFile

                    if { ![file exists $fileFullPath] } {
                        _TH_WriteWorkingStatus "error" "multiple_thread_file_write-->$fileFullPath"
                    } elseif { [file size $fileFullPath] == $size } {
                        _TH_WriteWorkingStatus "success" $name
                    } else {
                        _TH_WriteWorkingStatus "error" "file_corrupted-->$name"
                    }

                }

                return 1

            }

            #############################################################################
            ## Method: _TH_GetThreadID
            ##
            ## Arguments: NONE
            ##
            ## Description: Set and return the ID of current thread.
            ##
            #############################################################################

            proc _TH_GetThreadID { } {
                global _ID
                if { ![info exists _ID] } {
                    set _ID [thread::id]
                }
                
                return $_ID
            }
            #############################################################################

         thread::wait
        }]

        putsDebug "qTransfer: Thread $threadID has been created .."
        return $threadID
    }

#############################################################################
## Method: TH_SendChannelToThread
##
## Arguments: Thread ID, Sock
##
## Description: Transfer socket to child thread.
##
#############################################################################

    itcl::body ::quartus::qTransfer::TH_SendChannelToThread {threadID sock} {

        thread::detach $sock

        TH_SetChildThreadSetting $threadID _sock $sock
        TH_SetChildThreadSetting $threadID _manThreadID [thread::id]

        thread::send -async $threadID {
            thread::attach $_sock
            _TH_InitializeReadableSockEvents
            fconfigure $_sock -translation binary
        }

        return
    }

#############################################################################
## Method: TH_SetChildThreadSetting
##
## Arguments: Thread ID, Variable name, Value
##
## Description: Set a variable in child thread.
##
#############################################################################

    itcl::body ::quartus::qTransfer::TH_SetChildThreadSetting {threadID var value} {

        if {[thread::exists $threadID]} {
            thread::send -async $threadID [list set $var $value]
        } else {
            return 0
        }

        return 1
    }

#############################################################################
## Method: TH_CreateClientHandler
##
## Arguments: Host address, Host Port
##
## Description: Create thread to handle client channel handling.
##
#############################################################################

    itcl::body ::quartus::qTransfer::TH_CreateClientHandler {host port} {

        if { [catch {set sock [socket $host $port]} errMsg] } {
            error $errMsg
        } else {
            putsDebug "qTransfer: Connected to $host on socket $sock"

            set threadID [TH_CreateChannelHandler]
            if { [catch {TH_SendChannelToThread $threadID $sock} errMsg] } {
                error $errMsg
            }

            return $threadID
        }
    }

#############################################################################
## Method: TH_SendJob
##
## Arguments: ThreadID, File Path
##
## Description: Initiate the child thread to send specified files
##
#############################################################################

    itcl::body ::quartus::qTransfer::TH_SendJob {threadID filePathStr} {

        if { ![thread::exists $threadID] } {
            return 0
        }

        set script {
            if { [catch {_TH_InitiateSendingJobs $filePathStr} errMsg] } {
                _TH_ExecuteCallback "error" "connection_reset"
            }
        }

        TH_SetChildThreadSetting $threadID filePathStr $filePathStr

        thread::send -async $threadID $script

        return 1
    }

#############################################################################
## Method: TH_SetRemoteSettings
##
## Arguments: ThreadID, args
##
## Description: Ask the child thread to send command to create settings on
##              the host.
##
#############################################################################


    itcl::body ::quartus::qTransfer::TH_SetRemoteSettings {threadID args} {

        if { ![thread::exists $threadID] } {
            return 0
        }

        foreach arg $args {
            switch -glob "_$arg" {
                "_path=*" {
                    set path [lindex [split $arg "="] 1]
                    thread::send -async $threadID [list _TH_SetRemoteSettings _path $path]
                }
                "_ID=*" {
                    set ID [lindex [split $arg "="] 1]
                    thread::send -async $threadID [list _TH_SetRemoteSettings _ID $ID]
                    TH_SetChildThreadSetting $threadID _ID $ID
                }
            }
        }
        return 1
    }

#############################################################################
## Method: TH_ReceivedNewConnection
##
## Arguments: sock host port
##
## Description: Procedure to be caried out when a connection is establish 
##              on server side
##
#############################################################################

    itcl::body ::quartus::qTransfer::TH_ReceivedNewConnection {sock host port} {

        putsDebug  "qTransfer: Accept $sock from $host port $port"
        
        set threadID [TH_CreateChannelHandler]
        after 0 [list qTransferObj TH_SendChannelToThread $threadID $sock]
        after 0 [list qTransferObj TH_SetChildThreadSetting $threadID _host $host]

        if {[tsv::exists serverLocalSettings workingDirectory]} {
            set workingDirectory [tsv::get serverLocalSettings workingDirectory]
            TH_SetChildThreadSetting $threadID _workingDirectory $workingDirectory
        }
        if { [tsv::exists serverLocalSettings callback] } {
            set callback [tsv::get serverLocalSettings callback]
            TH_SetChildThreadSetting $threadID _callback $callback
        }

        return
    }


#############################################################################
## Method: TH_CreateServerHandler
##
## Arguments: port
##
## Description: Create a server handle.
##
#############################################################################

    itcl::body ::quartus::qTransfer::TH_CreateServerHandler {port} {
        set sock [socket -server [list qTransferObj TH_ReceivedNewConnection] $port]
        
        return $sock
    }



#############################################################################
## Method: TH_SetServerLocalSettings
##
## Arguments: args (<identifier>=<value>)
##
## Description: Set local setting at server side.
##
#############################################################################

    itcl::body ::quartus::qTransfer::TH_SetServerLocalSettings { args } {

        foreach arg $args {
            switch -glob "_$arg" {
                "_workingDirectory=*" {
                    set workingDirectory [lindex [split $arg "="] 1]
                    if { ![file exists $workingDirectory] } {
                        if { [catch {file mkdir $workingDirectory}] } {
                            puts "Error: Cannot create working directory : $workingDirectory"

                            return 0
                        }
                    }

                    tsv::set serverLocalSettings workingDirectory $workingDirectory
                }
                "_callback=*" {
                    set callback [lindex [split $arg "="] 1]
                    tsv::set serverLocalSettings callback $callback
                }
            }
        }

        return 1
    }

#############################################################################
## Method: TH_SendMeStatus
##
## Arguments: ThreadID, Timeout
##
## Description: Ask the child thread to retrieve status from host.
##
#############################################################################

    itcl::body ::quartus::qTransfer::TH_SendMeStatus { threadID timeout } {

        if { [thread::exists $threadID] } {
            thread::send -async $threadID [list _TH_SendMeStatus $timeout]
            return 1
        } else {
            return 0
        }
    }

#############################################################################
## Method: TH_InitiateGetFile
##
## Arguments: ThreadID, File Paths
##
## Description: Send a command to child thread to get specified files .
##
#############################################################################

    itcl::body ::quartus::qTransfer::TH_InitiateGetFile { threadID filePathStr} {
        thread::send -async $threadID [list _TH_InitiateGetFile $filePathStr]
        return 1
    }

#############################################################################
## Method: genKey
##
## Arguments: NONE
##
## Description: Return a unique key. Use to give ID to threads.
##
#############################################################################

    itcl::body ::quartus::qTransfer::genKey { } {
        set key   [ expr { pow(2,31)+[clock clicks] } ]
        set begin [ expr { [ string length $key ] -8 } ]
        set end   [ expr { [ string length $key ] -3 } ]
        set key   [ string range $key $begin $end ]
        regsub -all -- {-} $key {} key
        ;## leapSecs calls getCurlUrl, which calls key::time
        if { [ info exists ::leapdates ] } {
            set key [ gpsTime ]$key
        } else {
            set key [ clock seconds ]$key
        }
        return $key
    }

#############################################################################
######################## THE PUBLIC API IS BELOW ############################
#############################################################################



#############################################################################
## Method: TH_ChannelHandler
##
## Arguments: args (<identifier>=<value>)
##              i)    type (server or client)
##              ii)   host (Host name)
##              iii)  port (Host port)
##              iv)   workingdirectory (Base directory for files storing)
##              v)    files (File list containing all the file names)
##              vi)   tohostdir (Directory path where the file will be put it in host)
##              vii)  callback (callback function on reveceive complete)
##              viii) timeout
##              ix)   id (Attached ID get file procedure instance)
##
## Description: Create server or client thread for file transmission.
##
#############################################################################
    itcl::body ::quartus::qTransfer::TH_ChannelHandler { args } {

        set timeout 0
        # may have to change when use under quartus to global q_args
        set  q_args $args
        set argc [llength $q_args]

        if {$argc > 9} {
            return -code error "Wrong number of command line arguments."
        } elseif {$argc > 0} {
            foreach arg $q_args {
                set argLower [string tolower $arg]
                if {![string match -* $argLower]} {
                    switch -glob $argLower {
                        "type=*" {
                            set type [string tolower [lindex [split $arg "="] 1]]
                        }
                        "host=*" {
                            set host [lindex [split $arg "="] 1]
                        }
                        "port=*" {
                            set port [lindex [split $arg "="] 1]
                        }
                        "workingdirectory=*" {
                            set workingDirectory [lindex [split $arg "="] 1]
                        }
                        "files=*" {
                            set filePath [lindex [split $arg "="] 1]
                        }
                        "tohostdir=*" {
                            set storepath [lindex [split $arg "="] 1]
                        }
                        "callback=*" {
                            set callback [lindex [split $arg "="] 1]
                        }
                        "timeout=*" {
                            set timeout [lindex [split $arg "="] 1]
                        }
                        "id=*" {
                            set ID [lindex [split $arg "="] 1]
                        }
                    }
                }
            }
        }

        if { ![string equal $type "server"] && ![string equal $type "client"] } {
            puts "Error: Please select type as \"server\" or a \"client\""
            return 0
        }
        if { [string equal $type "client"] && ![info exists filePath] } {
            puts "Error: No files had been specified for transfer."
            return 0
        }
        if { [string equal $type "client"] && ![info exists host] && ![info exists port] } {
            puts "Error: Please specify the host and the port."
            return 0
        }
        if { [string equal $type "server"] && ![info exists port] } {
            puts "Error: Please specify the listening port of the server"
            return 0
        }
        if { ![info exists ID] } {
            set ID [genKey]
        }

        set willContinue 1

        if { [string equal $type "client"] } {

            if { $willContinue && ![catch {set currentThreadId [TH_CreateClientHandler $host $port]} errMsg] } {

                if { $willContinue && [info exists callback]} {
                    set willContinue [TH_SetChildThreadSetting $currentThreadId _callback $callback]
                }
                if { $willContinue && [info exists ID]} {
                    set willContinue [TH_SetRemoteSettings $currentThreadId ID=$ID]
                }
                if { $willContinue && [info exists storepath]} {
                    set willContinue [TH_SetRemoteSettings $currentThreadId path=$storepath]
                }
                if { $willContinue && [info exists filePath]} {
                    set willContinue [TH_SendJob $currentThreadId $filePath]
                }
                if { $willContinue } {
                    set willContinue [TH_SendMeStatus $currentThreadId $timeout]
                }

            } else {
                puts "Error: Cannot connect to host."
                set willContinue 0
            }

        } elseif { [string equal $type "server"] } {
            tsv::set serverLocalSettings workingDirectory ""
            tsv::set serverLocalSettings callback ""
            
            if { $willContinue && [info exists workingDirectory]} {
                set willContinue [TH_SetServerLocalSettings workingDirectory=$workingDirectory]
            }
            if { $willContinue && [info exists callback]} {
                set willContinue [TH_SetServerLocalSettings callback=$callback]
            }
            if { $willContinue && [catch {TH_CreateServerHandler $port} errMsg] } {
                puts "Error: Cannot open port for listening."
                set willContinue 0
            }

        }
        
        return $willContinue
    }


#############################################################################
## Method: TH_GetFile
##
## Arguments: args (<identifier>=<value>)
##              i)   host (Host name)
##              ii)  port (Host port)
##              iii) tolocaldir (Directory which the file will be stored when received)
##              iv)  files (File list containing all the file names)
##              v)   fromhostdir (Directory path where the file exists in host)
##              vi)  callback (callback function on reveceive complete)
##              vii) id (Attached ID get file procedure instance)
##
## Description: Get files based on the passed arguments from host.
##
#############################################################################
    itcl::body ::quartus::qTransfer::TH_GetFile { args } {

        set  q_args $args
        set argc [llength $q_args]

        if {$argc > 7} {
            return -code error "Wrong number of command line arguments."
        } elseif {$argc > 0} {
            foreach arg $q_args {
                set argLower [string tolower $arg]
                if {![string match -* $argLower]} {
                    switch -glob $argLower {
                        "host=*" {
                            set host [lindex [split $arg "="] 1]
                        }
                        "port=*" {
                            set port [lindex [split $arg "="] 1]
                        }
                        "tolocaldir=*" {
                            set workingDirectory [lindex [split $arg "="] 1]
                        }
                        "files=*" {
                            set filePath [lindex [split $arg "="] 1]
                        }
                        "fromhostdir=*" {
                            set fromhostdir [lindex [split $arg "="] 1]
                        }
                        "callback=*" {
                            set callback [lindex [split $arg "="] 1]
                        }
                        "id=*" {
                            set ID [lindex [split $arg "="] 1]
                        }
                    }
                }
            }
        }


        if {![info exists host] && ![info exists port] } {
            puts "Error: Please specify the host and the port."
            return 0
        }
        if { ![info exists filePath] } {
            puts "Error: No files had been specified for transfer."
            return 0
        }
        if { ![info exists ID] } {
            set ID [genKey]
        }


        set willContinue 1

        if { $willContinue && [info exists workingDirectory]} {
            if { ![file exists $workingDirectory] } {
                if { [catch {file mkdir $workingDirectory}] } {
                    puts "Error: Cannot create working directory : $workingDirectory"
                    return 0
                }
            }
        }

        if { $willContinue && ![catch {set currentThreadId [TH_CreateClientHandler $host $port]} errMsg] } {

            if { $willContinue && [info exists workingDirectory]} {
                set willContinue [TH_SetChildThreadSetting $currentThreadId _workingDirectory $workingDirectory]
            }
            if { $willContinue && [info exists callback]} {
                set willContinue [TH_SetChildThreadSetting $currentThreadId _callback $callback]
            }
            if { $willContinue && [info exists ID]} {
                set willContinue [TH_SetRemoteSettings $currentThreadId ID=$ID]
            }
            if { $willContinue && [info exists fromhostdir]} {
                set willContinue [TH_SetRemoteSettings $currentThreadId path=$fromhostdir]
            }
            if { $willContinue && [info exists filePath] } {
                set willContinue [TH_InitiateGetFile $currentThreadId $filePath]
            }

        } else {
            puts "Error: Cannot connect to host"
            set willContinue 0
        }

        return $willContinue
    }
#############################################################################


::quartus::qTransfer qTransferObj
