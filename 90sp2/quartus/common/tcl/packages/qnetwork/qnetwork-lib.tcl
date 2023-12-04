
#############################################################################
##  qnetwork-lib.tcl - v1.0
##
##  Quartus Network Library Package
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

package provide ::quartus::qNetwork 1.0

package require comm 4.0.1
package require Itcl 3.2

#############################################################################
## Class:   ::quartus::qNetwork
##
## Description: qNetwork base class for qSlave and qMaster classes.
##
#############################################################################
itcl::class ::quartus::qNetwork {
    constructor {{debugMode 0}} {
        set m_debugMode $debugMode
        set m_noCleanUp 0

        # Every comm default has its own listen port
        set m_listenPort [comm::comm config -port]
        # Default slave and ftp listen port
        set m_slaveListenPort 1977
        set m_ftpListenPort 1978
        set m_ftpTimeout 3600
        set m_scriptDir {}
        set m_currentDir {}
        # TODO: Please use more secure password and User Name.
        set m_ftpUserName Please
        set m_ftpPassword LetMeIn
        set m_commPassword pleaseLetMeIn
        set m_tempVar 0
        set m_outputCallback {}
        set m_statusCallback {}

        putsDebug "qNetwork constructor is called."
    }
    destructor {
        putsDebug "qNetwork destructor is called."
    }
    ###########################
    ## Public APIs
    ###########################
    # Debug purpose
    public method promptDebugTest {}
    # set the object to debug mode
    public method setDebug {{mode 1}} {set m_debugMode $mode}
    public method setNoCleanUp {{mode 1}} {set m_noCleanUp $mode}

    # Any debug command API
    public method debugCmd {arg}
    public method getCommPassword {} {return $m_commPassword}

    ##########################
    ## Protected APIs
    ##########################
    protected method start {} {return code -error "qNetwork ERROR: proc start is not implemented."}
    protected method putsInfo {arg}
    protected method putsError {arg}
    protected method putsWarning {arg}
    protected method putsDebug {arg}
    # Set the script directory and current directory.
    protected method updateDir {}
    protected method getFullDirFileName {fileName}
    protected method renameBgerrorTo {bgerrorProcName}
    protected method restoreBgerrorFrom {bgerrorProcName}

    ##########################
    ## Data Members
    ##########################
    protected variable m_debugMode
    protected variable m_noCleanUp

    # Comm listen port
    protected variable m_listenPort
    protected variable m_slaveListenPort
    protected variable m_ftpListenPort
    protected variable m_ftpTimeout
    protected variable m_scriptDir
    protected variable m_currentDir
    protected variable m_ftpPassword
    protected variable m_ftpUserName
    # Temporary variable used for debugging purpose.
    protected variable m_tempVar
    protected variable m_outputCallback
    protected variable m_statusCallback
    protected variable m_commPassword
}

#############################################################################
## Method:  ::quartus::qNetwork::renameBgerrorTo
##
## Arguments: Background error procedure name
##
## Description: Rename the bgerror procedure.
##
#############################################################################
itcl::body ::quartus::qNetwork::renameBgerrorTo {bgerrorProcName} {
    # Overwrite bgerror proc command
    if {[string equal [info commands bgerror] bgerror]} {
        rename ::bgerror orgBgerror
    }
    rename ::$bgerrorProcName ::bgerror
    return
}

#############################################################################
## Method:  ::quartus::qNetwork::restoreBgerrorFrom
##
## Arguments: Background error procedure name
##
## Description: Restore the bgerror procedure.
##
#############################################################################
itcl::body ::quartus::qNetwork::restoreBgerrorFrom {bgerrorProcName} {
    # Restore bgerror proc command
    rename ::bgerror ::$bgerrorProcName

    if {[string equal [info commands orgBgerror] orgBgerror]} {
        rename orgBgerror ::bgerror
    }
    return
}

#############################################################################
## Method:  ::quartus::qNetwork::getFullDirFileName
##
## Arguments: File name
##
## Description: Get full directory file name from relative or full path.
##
#############################################################################
itcl::body ::quartus::qNetwork::getFullDirFileName {fileName} {
    set fileNameDir [file dirname $fileName]
    set currentDir [pwd]
    cd $fileNameDir
    set fileNameDir [pwd]
    cd $currentDir
    return [file join $fileNameDir [file tail $fileName]]
}

#############################################################################
## Method:  ::quartus::qNetwork::updateDir
##
## Arguments: None.
##
## Description: Set the current script directory and current directory.
##
#############################################################################
itcl::body ::quartus::qNetwork::updateDir {} {
    putsDebug "*****Calling qNetwork::updateDir.*****"
    set scriptDir [file dirname [info script]]
    set m_currentDir [pwd]
    cd $scriptDir
    set m_scriptDir [pwd]
    cd $m_currentDir
    putsDebug "Script directory is $m_scriptDir."
    putsDebug "Current directory is $m_currentDir."
}

#############################################################################
## Method:  ::quartus::qNetwork::putsDebug
##
## Arguments: String
##
## Description: Enable this function only in debug mode.
##
#############################################################################
itcl::body ::quartus::qNetwork::putsDebug {arg} {
    if {[string equal $m_debugMode 1]} {
        puts "\[DEBUG\]: $arg"
    }
}
#############################################################################
## Method:  ::quartus::qNetwork::putsError
##
## Arguments: String
##
## Description: Error message.
##
#############################################################################
itcl::body ::quartus::qNetwork::putsError {arg} {
    if {![string equal $m_outputCallback {}]} {
        eval "$m_outputCallback Error [list $arg]"
    }
}

#############################################################################
## Method:  ::quartus::qNetwork::putsWarning
##
## Arguments: String
##
## Description: Warning message.
##
#############################################################################
itcl::body ::quartus::qNetwork::putsWarning {arg} {
    if {![string equal $m_outputCallback {}]} {
        eval "$m_outputCallback Warning [list $arg]"
    }
}

#############################################################################
## Method:  ::quartus::qNetwork::putsInfo
##
## Arguments: String
##
## Description: Info message.
##
#############################################################################
itcl::body ::quartus::qNetwork::putsInfo {arg} {
    if {![string equal $m_outputCallback {}]} {
        eval "$m_outputCallback Info [list $arg]"
    }
}


#############################################################################
## Method:  ::quartus::qNetwork::debugCmd
##
## Arguments: Command.
##
## Description: Enable this function only in debug mode.
##
#############################################################################
itcl::body ::quartus::qNetwork::debugCmd {arg} {
    if {[string equal $m_debugMode 1]} {
        uplevel 1 $arg
    }
}

#############################################################################
## Method:  ::quartus::qNetwork::prompDebugTest
##
## Arguments: None.
##
## Description: This is for testing purpose.
##
#############################################################################
itcl::body ::quartus::qNetwork::promptDebugTest {} {
    if {[string equal $m_debugMode 1]} {
        puts "<------------This is for testing purpose ------------>"
    } else {
        return -code error "qNetwork ERROR: qNetwork is not in debug mode."
    }
    return
}

#############################################################################
##  Global Objects  and procedures
#############################################################################

proc qNetworkBgerror {args} {
    # Skip Ftp background error. This is a bug in tcllib::ftp.
    # if {[string match *ftp(Wait)* $args]} {
        # TODO: remove the puts command
        # puts "++++++++++++++ ftp background error ++++++++++++++++++++++"
        # puts $args
    # } else {
    puts "There is a background error. The return error message is $args."
    # }
}

