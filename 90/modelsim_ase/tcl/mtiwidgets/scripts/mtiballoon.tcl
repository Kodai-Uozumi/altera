##
## General purpose balloon help system.
## Places balloon help on any widget.
##
##
## usage: mtiBalloon <widget> <message>
##
## global configure options:
## 
##    -font <font>
##    -background <background color>
##    -foreground <foreground color>
##
## usage: mtiBalloon::configure <option> ?<value>? ...
##

namespace eval mtiBalloon {
	variable mtiBalloonBindingsDone 0
	variable mtiBalloonWidgets
	variable Defaults

	if {$::tcl_platform(platform) eq "windows"} {
		set Defaults(balloonForeground) SystemInfoText
		set Defaults(balloonBackground) SystemInfoBackground
		set Defaults(menuFont) ""
	} else {
		set Defaults(balloonForeground) black
		set Defaults(balloonBackground) {light yellow}
		set Defaults(menuFont) ""
	}
}

proc mtiBalloon::configure {args} {
	variable Defaults
	for {set i 0} {$i < [llength $args]} {incr i} {
		set arg [lindex $args $i]
		if {$arg  eq "-foreground"} {
			incr i
			if {$i >= [llength $args]} {
				return [list -foreground $Defaults(balloonForeground)]
			}
			set Defaults(balloonForeground) [lindex $args $i]
		} elseif {$args eq "-background"} {
			incr i
			if {$i >= [llength $args]} {
				return [list -background $Defaults(balloonBackground)]
			}
			set Defaults(balloonBackground) [lindex $args $i]
		} elseif {$args eq "-font"} {
			incr i
			if {$i >= [llength $args]} {
				return [list -font $Defaults(menuFont)]
			}
			set Defaults(menuFont) [lindex $args $i]
		}
	}
}

proc mtiBalloon::InitBindings {} {
	variable mtiBalloonBindingsDone
	if {![info exists mtiBalloonBindingsDone] ||
		$mtiBalloonBindingsDone==0} {
		set mtiBalloonBindingsDone 1
		bind mtiBalloonTags <Enter> {mtiBalloon::Enter %W}
		bind mtiBalloonTags <Leave> {mtiBalloon::Leave %W}
		bind mtiBalloonTags <Motion> {mtiBalloon::Motion %W}
	}
	return ""
}
	
proc mtiBalloon::mtiBalloon {w msg} {
	variable mtiBalloonWidgets
	InitBindings
	set bt [bindtags $w]
	lappend bt mtiBalloonTags
	bindtags $w $bt
	set mtiBalloonWidgets($w) $msg
}

proc mtiBalloon::Enter {w} {
	variable mtiBalloonWidgets
	set mtiBalloonWidgets(wndw) $w
	set x [winfo rootx $w]
	set y [winfo rooty $w]
	set mtiBalloonWidgets(aftr) [after 500 "mtiBalloon::PopUp $w $x $y"]
}

proc mtiBalloon::Leave {w} {
	variable mtiBalloonWidgets
	after cancel $mtiBalloonWidgets(aftr)
	set mtiBalloonWidgets(aftr) ""
	if {[winfo exists .mtiBalloon]} {
		destroy .mtiBalloon
	}
}

proc mtiBalloon::Motion {w} {
	variable mtiBalloonWidgets
	if {$w ne $mtiBalloonWidgets(wndw)} {
		Leave $mtiBalloonWidgets(wndw)
	}
}

proc mtiBalloon::PopUp {w x y} {
	variable Defaults
	variable mtiBalloonWidgets
	if {[winfo exists .mtiBalloon]} {
		destroy .mtiBalloon
	}
	if {![winfo exists $w]} {
		return
	}
	set in_w [winfo containing [winfo pointerx $w] [winfo pointery $w]]
	if {$in_w ne $w} { return }
	set msg $mtiBalloonWidgets($w)
	toplevel .mtiBalloon
	wm withdraw .mtiBalloon
	wm overrideredirect .mtiBalloon 1
	label .mtiBalloon.msg -text $msg \
		-bg $Defaults(balloonBackground) \
		-fg $Defaults(balloonForeground) \
		-bd 1 -relief solid

	if {$Defaults(menuFont) ne ""} {
		.mtiBalloon.msg configure -font $Defaults(menuFont)
	}

    set font [.mtiBalloon.msg cget -font]
    set bd   [.mtiBalloon.msg cget -borderwidth]
	set right [lindex [wm maxsize .] 0]
	set width [expr {[font measure $font $msg] + (2 * $bd) + 10}]

	pack .mtiBalloon.msg -side top -fill both -expand 1
	wm deiconify .mtiBalloon
	incr x 25 
	incr y 25 
    if {[expr {$x + $width}] > $right} {
		set x [expr {$right - $width}]
	}

	wm geometry .mtiBalloon +$x+$y
	set mtiBalloonWidgets(aftr) [after 5000 "mtiBalloon::Leave $w"]
}

proc mtiBalloon {w msg} {
	uplevel [list mtiBalloon::mtiBalloon $w $msg]
}
