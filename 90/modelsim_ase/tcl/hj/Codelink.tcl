# If not in batch mode, and if the CODELINK_HOME environment variable is set,
# then load the product's userware and install the menu.

if {![batch_mode]} {
    if {[info exists ::env(CODELINK_HOME)]} {
        set fileName [file join $::env(CODELINK_HOME) modelsim.tcl]
        if {[file exists $fileName]} {
            if {[catch {source $fileName} errorMessage]} {
               puts "#"
               puts "# ERROR:"
               puts "#    A problem occurred loading the Codelink customization file at $fileName"
               puts "#    The error was: $errorMessage"
               puts "#"
               puts "#    If the problem persists please contact Mentor Graphics support."
               puts "#"
            }
        }
    }
}
