::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_circuit.tcl
#
# Summary:      This TK script is a simple Graphical User Interface to
#               generate timing requirements for DDR memory interfaces
#
# Licencing:
#               ALTERA LEGAL NOTICE
#               
#               This script is  pursuant to the following license agreement
#               (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE
#               FOLLOWING): Copyright (c) 2009-2010 Altera Corporation, San Jose,
#               California, USA.  Permission is hereby granted, free of
#               charge, to any person obtaining a copy of this software and
#               associated documentation files (the "Software"), to deal in
#               the Software without restriction, including without limitation
#               the rights to use, copy, modify, merge, publish, distribute,
#               sublicense, and/or sell copies of the Software, and to permit
#               persons to whom the Software is furnished to do so, subject to
#               the following conditions:
#               
#               The above copyright notice and this permission notice shall be
#               included in all copies or substantial portions of the Software.
#               
#               THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#               EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#               OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#               NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#               HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#               WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#               FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#               OTHER DEALINGS IN THE SOFTWARE.
#               
#               This agreement shall be governed in all respects by the laws of
#               the State of California and by the laws of the United States of
#               America.
#
#               
#
# Usage:
#
#               You can run this script from a command line by typing:
#                     quartus_sh --dtw
#
###############################################################################

# ----------------------------------------------------------------
#
namespace eval dtw_circuit {
#
# Description: Namespace to encapsulate the Memory Data panel
#
# ----------------------------------------------------------------
	variable pll_cx 50
	variable pll_cy 40
	variable dff_cx 45
	variable dff_cy 50
	variable pin_cx 75
	variable pin_cy 14
	variable vcc_cy 9
	variable gate_cy 22
	variable gate_cx 33
	variable mux_cx 15
	variable mux_cy 60

	variable s_tag_count 0
}

# ----------------------------------------------------------------
#
proc dtw_circuit::create_tag {{default_tag ""}} {
#
# Description: Creates a tag for a canvas item
#
# ----------------------------------------------------------------
	variable s_tag_count
	if {$default_tag == ""} {
		set result "i$s_tag_count"
		incr s_tag_count
	} else {
		set result "$default_tag"
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_circuit::canvas_pll { canvas_window x y text args} {
#
# Description: Creates a PLL on the specified canvas at (x,y)
#
# ----------------------------------------------------------------
	array set options [list "-outlabels" "" "-outputs" "c0 c1" "-tag" ""]
	foreach {option value} $args {
		if {[array names options -exact "$option"] != ""} {
			set options($option) $value
		} else {
			error "ERROR: Unknown option $option (with value $value)"
		}
	}

	variable pll_cx
	variable pll_cy
	set pll_tag [canvas_logic $canvas_window $x $y $text -out_side r -inputs "inclk" -outputs $options(-outputs) -cx $pll_cx -cy $pll_cy -tag $options(-tag)]

	# Draw inclk arrow
	set arrow_size 6
	set clk_pos [get_port_position $canvas_window $pll_tag "inclk"]
	set clk_x [lindex $clk_pos 0]
	set clk_y [lindex $clk_pos 1]
	$canvas_window create line $clk_x [expr $clk_y - $arrow_size] [expr $clk_x + $arrow_size] $clk_y $clk_x [expr $clk_y + $arrow_size] -tags $pll_tag

	# Draw outclk labels
	set symbol_size 8
	set symbol_offset 4
	set arrow_margin 3
	foreach {port out_label} $options(-outlabels) {
		set out_pos [get_port_position $canvas_window $pll_tag "$port"]
		if {$out_label == "adjustable"} {
			set out_x [expr [lindex $out_pos 0] - $symbol_offset]
			set out_y [lindex $out_pos 1]
			$canvas_window create oval [expr $out_x - $symbol_size] [expr $out_y - $symbol_size / 2] $out_x [expr $out_y + $symbol_size / 2] -tags $pll_tag
			$canvas_window create line [expr $out_x - $symbol_size] [expr $out_y + $symbol_size / 2] [expr $out_x + $arrow_margin] [expr $out_y - $symbol_size / 2 - $arrow_margin] -tags $pll_tag -arrow last -arrowshape {3 4 2}
		} else {
			$canvas_window create text [expr [lindex $out_pos 0] - 1] [lindex $out_pos 1] -text $out_label -anchor e -tags $pll_tag
		}
	}

	return $pll_tag
}

# ----------------------------------------------------------------
#
proc dtw_circuit::canvas_fpga { canvas_window x fpga_label} {
#
# Description: Draws an FPGA border on the specified canvas at x
#
# ----------------------------------------------------------------
	set color LightBlue

	$canvas_window create rectangle $x 0 2000 2000 -outline $color -fill $color
	$canvas_window create text [expr $x + 10] 1 -text $fpga_label -anchor nw -justify left
}

# ----------------------------------------------------------------
#
proc dtw_circuit::canvas_memory { canvas_window x ck_y ck_string dqs_y dqs_string args} {
#
# Description: Creates a memory at x
#
# ----------------------------------------------------------------
	array set options [list "-tag" ""]
	foreach {option value} $args {
		if {[array names options -exact "$option"] != ""} {
			set options($option) $value
		} else {
			error "ERROR: Unknown option $option (with value $value)"
		}
	}
	set memory_tag [create_tag $options(-tag)]
	set color gray60

	$canvas_window create rectangle 0 0 $x 2000 -fill $color -tags [list $memory_tag [list "ports" {} [list "${dqs_string}%y$dqs_y" "${ck_string}%y$ck_y"]]]
	$canvas_window create text [expr $x - 10] 1 -text "Memory" -anchor ne -justify right
	label_port $canvas_window $memory_tag $dqs_string -anchor e
	label_port $canvas_window $memory_tag $ck_string -anchor e

	return $memory_tag
}

# ----------------------------------------------------------------
#
proc dtw_circuit::canvas_block { canvas_window widget_list args} {
#
# Description: Denotes a block
#
# ----------------------------------------------------------------
	array set options [list "-color" gray60 "-outline" "" "-label" "" "-margin" 15]
	foreach {option value} $args {
		if {[array names options -exact "$option"] != ""} {
			set options($option) $value
		} else {
			error "ERROR: Unknown option $option (with value $value)"
		}
	}
	set bbox_left -1
	set bbox_top -1
	set bbox_right -1
	set bbox_bottom -1
	foreach widget $widget_list {
		set widget_bbox [$canvas_window bbox [lindex $widget 0]]
		if {[lindex $widget_bbox 0] < $bbox_left || $bbox_left == -1} {
			set bbox_left [lindex $widget_bbox 0]
		}
		if {[lindex $widget_bbox 1] < $bbox_top || $bbox_top == -1} {
			set bbox_top [lindex $widget_bbox 1]
		}
		if {[lindex $widget_bbox 2] > $bbox_right || $bbox_right == -1} {
			set bbox_right [lindex $widget_bbox 2]
		}
		if {[lindex $widget_bbox 3] > $bbox_bottom || $bbox_bottom == -1} {
			set bbox_bottom [lindex $widget_bbox 3]
		}
	}
	incr bbox_left -$options(-margin)
	incr bbox_top -$options(-margin)
	incr bbox_right $options(-margin)
	incr bbox_bottom $options(-margin)
	set block [$canvas_window create rectangle $bbox_left $bbox_top $bbox_right $bbox_bottom -outline $options(-outline) -fill $options(-color)]
	$canvas_window lower $block
	$canvas_window create text [expr $bbox_left + 10] [expr $bbox_top + 5] -text $options(-label) -anchor nw -justify left
}

# ----------------------------------------------------------------
#
proc dtw_circuit::canvas_dff { canvas_window x y label args} {
#
# Description: Creates a DFF on the specified canvas at (x,y)
#
# ----------------------------------------------------------------
	variable dff_cx
	variable dff_cy
	array set options [list "-out_side" r "-inputs" "d clk" "-tag" "" "-cx" $dff_cx "-cy" $dff_cy]
	foreach {option value} $args {
		if {[array names options -exact "$option"] != ""} {
			set options($option) $value
		} else {
			error "ERROR: Unknown option $option (with value $value)"
		}
	}
	set dff_tag [canvas_logic $canvas_window $x $y $label -out_side $options(-out_side) -inputs $options(-inputs) -outputs "q" -bottom_ports "clr" -cx $options(-cx) -cy $options(-cy) -tag $options(-tag)]

	# Draw clk arrow or label latch en port
	set arrow_size 6
	set port_pattern [get_port_pattern "clk"]
	set port_index [lsearch -regexp $options(-inputs) $port_pattern]
	if {$port_index != -1} {
		set clk_pos [get_port_position $canvas_window $dff_tag "clk"]
		set clk_x [lindex $clk_pos 0]
		set clk_y [lindex $clk_pos 1]
		if {$options(-out_side) == "r"} {
			$canvas_window create line $clk_x [expr $clk_y - $arrow_size] [expr $clk_x + $arrow_size] $clk_y $clk_x [expr $clk_y + $arrow_size] -tags $dff_tag
		} elseif {$options(-out_side) == "l"} {
			$canvas_window create line $clk_x [expr $clk_y - $arrow_size] [expr $clk_x - $arrow_size] $clk_y $clk_x [expr $clk_y + $arrow_size] -tags $dff_tag
		}
	} else {
		set port_pattern [get_port_pattern "en"]
		set port_index [lsearch -regexp $options(-inputs) $port_pattern]
		if {$port_index != -1} {
			if {$options(-out_side) == "r"} {
				label_port $canvas_window $dff_tag "clk" -text "en" -anchor w
			} elseif {$options(-out_side) == "l"} {
				label_port $canvas_window $dff_tag "clk" -text "en" -anchor e
			}
		}
	}

	return $dff_tag
}

# ----------------------------------------------------------------
#
proc dtw_circuit::canvas_logic { canvas_window x y label args} {
#
# Description: Creates random logic on the specified canvas at (x,y)
#
# ----------------------------------------------------------------
	variable dff_cx
	variable dff_cy
	array set options [list "-out_side" r "-inputs" "in0 in1" "-outputs" "out" "-top_ports" "" "-bottom_ports" "" "-cx" $dff_cx "-cy" $dff_cy "-tag" ""]
	foreach {option value} $args {
		if {[array names options -exact "$option"] != ""} {
			set options($option) $value
		} else {
			error "ERROR: Unknown option $option (with value $value)"
		}
	}

	set cx $options(-cx)
	set cy $options(-cy)
	set right [expr $x + $cx]
	set bottom [expr $y + $cy]

	set tag [create_tag $options(-tag)]
	if {$options(-out_side) == "r"} {
		set ports_list [list ports $options(-inputs) $options(-outputs) $options(-top_ports) $options(-bottom_ports)]
	} else {
		set ports_list [list ports $options(-outputs) $options(-inputs) $options(-top_ports) $options(-bottom_ports)]
	}
	$canvas_window create rectangle $x $y $right $bottom -outline black -fill white -tags [list $tag $ports_list]
	$canvas_window create text [expr $x + $cx / 2] [expr $y + $cy / 2] -text "$label" -anchor center -justify center -tags $tag

	return $tag
}

# ----------------------------------------------------------------
#
proc dtw_circuit::canvas_and { canvas_window x y args} {
#
# Description: Creates AND-gate on the specified canvas at (x,y)
#
# ----------------------------------------------------------------
	array set options [list "-out_side" l "-inputs" "in0 in1" "-tag" ""]
	foreach {option value} $args {
		if {[array names options -exact "$option"] != ""} {
			set options($option) $value
		} else {
			error "ERROR: Unknown option $option (with value $value)"
		}
	}
	variable gate_cx
	variable gate_cy

	set cx $gate_cx
	set cy $gate_cy
	set right [expr $x + $cx]
	set bottom [expr $y + $cy]

	set tag [create_tag $options(-tag)]
	if {$options(-out_side) == "l"} {
		set ports_list [list ports {"out%x2"} $options(-inputs)]
		$canvas_window create polygon [expr $x + $cy / 2] $y $right $y $right $y $right $bottom $right $bottom [expr $x + $cy / 2] $bottom $x [expr $y + $cy / 2] -smooth 1 -splinesteps 20 -outline black -fill white -tags [list $tag $ports_list]
	} else {
		set ports_list [list ports $options(-inputs) {"out%x-2"}]
		$canvas_window create polygon [expr $right - $cy / 2] $y $x $y $x $y $x $bottom $x $bottom [expr $right - $cy / 2] $bottom $right [expr $y + $cy / 2] -smooth 1 -splinesteps 20 -outline black -fill white -tags [list $tag $ports_list]
	}

	return $tag
}

# ----------------------------------------------------------------
#
proc dtw_circuit::canvas_fifo { canvas_window x y label args} {
#
# Description: Creates a FIFO on the specified canvas at (x,y)
#
# ----------------------------------------------------------------
	array set options [list "-tag" ""]
	foreach {option value} $args {
		if {[array names options -exact "$option"] != ""} {
			set options($option) $value
		} else {
			error "ERROR: Unknown option $option (with value $value)"
		}
	}
	variable dff_cx
	variable dff_cy

	set cx $dff_cx
	set cy $dff_cy
	set arrow_size 6
	set right [expr $x+$cx]
	set bottom [expr $y+$cy]

	set dff_tag [create_tag $options(-tag)]
	$canvas_window create rectangle $x $y $right $bottom -outline black -fill white -tags [list $dff_tag {ports {"d" "inclk"} {"q" "outclk"}}]
	set clk_pos [get_port_position $canvas_window $dff_tag "inclk"]
	set clk_x [lindex $clk_pos 0]
	set clk_y [lindex $clk_pos 1]
	$canvas_window create line $clk_x [expr $clk_y - $arrow_size] [expr $clk_x + $arrow_size] $clk_y $clk_x [expr $clk_y + $arrow_size] -tags $dff_tag
	set clk_pos [get_port_position $canvas_window $dff_tag "outclk"]
	set clk_x [lindex $clk_pos 0]
	set clk_y [lindex $clk_pos 1]
	$canvas_window create line $clk_x [expr $clk_y - $arrow_size] [expr $clk_x - $arrow_size] $clk_y $clk_x [expr $clk_y + $arrow_size] -tags $dff_tag

	$canvas_window create text [expr $x + $cx / 2] [expr $y + $cy / 2] -text "$label" -anchor center -justify center -tags $dff_tag
	return $dff_tag
}

# ----------------------------------------------------------------
#
proc dtw_circuit::canvas_tri { canvas_window x y args} {
#
# Description: Creates a tri-state buffer on the specified canvas at (x,y)
#
# ----------------------------------------------------------------
	array set options [list "-out_side" l "-tag" ""]
	foreach {option value} $args {
		if {[array names options -exact "$option"] != ""} {
			set options($option) $value
		} else {
			error "ERROR: Unknown option $option (with value $value)"
		}
	}
	variable pin_cy
	set cx [expr $pin_cy * 2]
	set cy [expr $pin_cy * 2]
	set bottom [expr $y + $cy / 2]
	set top [expr $y - $cy / 2]
	set oe_y_offset [expr $cy / 4]
	if {$options(-out_side) == "l"} {
		set other_x [expr $x + $cx]
		set ports [list ports {"out"} {"in"} [list "oe%y${oe_y_offset}"]]
	} elseif {$options(-out_side) == "r"} {
		set other_x [expr $x - $cx]
		set ports [list ports {"in"} {"out"} [list "oe%y${oe_y_offset}"]]
	} else {
		error "Unknown anchor $options(-anchor) for tri item"
	}

	set tri_tag [create_tag $options(-tag)]
	$canvas_window create polygon $x $y $other_x $bottom $other_x $top -fill white -outline black -tags [list $tri_tag $ports]

	return $tri_tag
}

# ----------------------------------------------------------------
#
proc dtw_circuit::canvas_vcc { canvas_window x y args} {
#
# Description: Creates a VCC on the specified canvas at (x,y)
#
# ----------------------------------------------------------------
	array set options [list "-tag" ""]
	foreach {option value} $args {
		if {[array names options -exact "$option"] != ""} {
			set options($option) $value
		} else {
			error "ERROR: Unknown option $option (with value $value)"
		}
	}
	variable vcc_cy
	set cx [expr $vcc_cy * 3/2]
	set cy [expr $vcc_cy]
	set top [expr $y - $cy]
	set left [expr $x - $cx / 2]
	set right [expr $x + $cx / 2]
	set ports [list ports {} {} {} {"out"}]

	set vcc_tag [create_tag $options(-tag)]
	$canvas_window create polygon $x $top $right $y $left $y -fill white -outline black -tags [list $vcc_tag $ports]

	return $vcc_tag
}

# ----------------------------------------------------------------
#
proc dtw_circuit::canvas_mux { canvas_window x y args } {
#
# Description: Creates a mux on the specified canvas at (x,y)
#
# ----------------------------------------------------------------
	array set options [list "-out_side" l "-inputs" "in0 in1" "-tag" ""]
	foreach {option value} $args {
		if {[array names options -exact "$option"] != ""} {
			set options($option) $value
		} else {
			error "ERROR: Unknown option $option (with value $value)"
		}
	}
	variable mux_cx
	variable mux_cy
	set cx [expr $mux_cx]
	set cy [expr $mux_cy]
	set bottom [expr $y + $cy / 2]
	set top [expr $y - $cy / 2]
	set selt_y_offset [expr $cx / 2]
	set selb_y_offset [expr -$cx / 2 - 2]
	set half_cy [expr $cy / 2]
	if {$options(-out_side) == "l"} {
		set other_x [expr $x + $cx]
		set ports [list ports {"out"} {"in0" "in1"} [list "selt%y${selt_y_offset}"] [list "selb%y${selb_y_offset}"]]
	} elseif {$options(-out_side) == "r"} {
		set other_x [expr $x - $cx]
		set ports [list ports {"in0" "in1"} {"out"} [list "selt%y${selt_y_offset}"] [list "selb%y${selb_y_offset}"]]
	} else {
		error "Unknown anchor $options(-anchor) for tri item"
	}

	set tag [create_tag $options(-tag)]
	$canvas_window create polygon $other_x $top $x [expr $top + $cx] $x [expr $bottom - $cx] $other_x $bottom -fill white -outline black -tags [list $tag $ports]
	label_port $canvas_window $tag "in0" -text "0" -anchor e
	label_port $canvas_window $tag "in1" -text "1" -anchor e

	return $tag
}

# ----------------------------------------------------------------
#
proc dtw_circuit::canvas_input_pin { canvas_window x y label args } {
#
# Description: Creates an input pin on the specified canvas at (x,y)
#
# ----------------------------------------------------------------
	array set options [list "-tag" ""]
	foreach {option value} $args {
		if {[array names options -exact "$option"] != ""} {
			set options($option) $value
		} else {
			error "ERROR: Unknown option $option (with value $value)"
		}
	}
	variable pin_cx
	variable pin_cy
	set cx $pin_cx
	set cy $pin_cy
	set midx [expr $x - $cy / 2]
	set midy [expr $y + $cy / 2]
	set left [expr $x - $cx]
	set bottom [expr $y + $cy / 2]
	set top [expr $y - $cy / 2]

	set io_tag [create_tag $options(-tag)]
	$canvas_window create polygon $x $y $midx $midy $left $bottom $left $top $midx $top -fill white -outline black -tags [list $io_tag {ports {"in"} {"out"}}]
	$canvas_window create text [expr $x - $cx / 2] $y -text "$label" -anchor center -tags $io_tag

	return $io_tag
}

# ----------------------------------------------------------------
#
proc dtw_circuit::canvas_output_pin { canvas_window x y label args } {
#
# Description: Creates an output pin on the specified canvas at (x,y)
#
# ----------------------------------------------------------------
	array set options [list "-tag" ""]
	foreach {option value} $args {
		if {[array names options -exact "$option"] != ""} {
			set options($option) $value
		} else {
			error "ERROR: Unknown option $option (with value $value)"
		}
	}
	variable pin_cx
	variable pin_cy
	set cx $pin_cx
	set cy $pin_cy
	set left [expr $x - $cx]
	set midx [expr $left + $cy / 2]
	set right [expr $x]
	set top [expr $y - $cy / 2]
	set midy [expr $y]
	set bottom [expr $y + $cy / 2]

	set io_tag [create_tag $options(-tag)]
	$canvas_window create polygon $right $top $right $bottom $midx $bottom $left $midy $midx $top -fill white -outline black -tags [list $io_tag {ports {"out"} {"in"}}]
	$canvas_window create text [expr $x - $cx / 2] $y -text "$label" -anchor center -tags $io_tag

	return $io_tag
}

# ----------------------------------------------------------------
#
proc dtw_circuit::get_item_bounding_box { thecanvas widget_tag_or_id } {
#
# Description: Gets the widget's bounding box rectangle
#
# Returns: List of result [list left top right bottom]
#
# ----------------------------------------------------------------
	set items [$thecanvas find withtag $widget_tag_or_id]
	set found 0
	foreach item_id $items {
		set item_type [$thecanvas type $item_id]
		if {$item_type == "rectangle"} {
			set bbox [$thecanvas coords $item_id]
			set found 1
		} elseif {$item_type == "polygon"} {
			set coords [$thecanvas coords $item_id]
			set top -1
			set left -1
			set right -1
			set bottom -1
			foreach {x y} $coords {
				if {$y < $top || $top == -1} {
					set top $y
				}
				if {$y > $bottom || $bottom == -1} {
					set bottom $y
				}
				if {$x < $left || $left == -1} {
					set left $x
				}
				if {$x > $right || $right == -1} {
					set right $x
				}
			}
			set bbox [list $left $top $right $bottom]
			set found 1
		}
		if {$found == 1} {
			break
		}
	}
	if {$found == 0} {
		error "Unknown canvas item type for get_item_bounding_box of $widget_tag_or_id"
	}
	return $bbox
}

# ----------------------------------------------------------------
#
proc dtw_circuit::get_port_pattern { port } {
#
# Description: Each port in the list is designated as:
#                  <port name>[%x<x offset>][%y<y offset>]
#              The optional parts specifies a custom location offset from
#                  an edge
#
# Returns: The regexp search pattern for the given port
#
# ----------------------------------------------------------------
	set port_pattern "^${port}(?:%x(-?\[0-9\]+))?(?:%y(-?\[0-9\]+))?$"
	return $port_pattern
}

# ----------------------------------------------------------------
#
proc dtw_circuit::get_port_position { thecanvas widget_tag_or_id port } {
#
# Description: Gets the widget's port x,y position
#              Ports are tagged on a canvas item as a list:
#                  ports <left_ports_list> <right_ports_list> <top_ports_list>  <bottom_ports_list>
#              Each port is designated as:
#                  <port name>[%x<x offset>][%y<y offset>]
#              The optional parts specifies a custom location offset from
#                  an edge
#
# Returns: List of result [list x y]
#
# ----------------------------------------------------------------
	set tag_list [$thecanvas gettags $widget_tag_or_id]
	set ports_list {}
	foreach tag $tag_list {
		if {[string range $tag 0 4] == "ports"} {
			set ports_list $tag
			break
		}
	}
	set pos [list 0 0]
	if {$ports_list != [list]} {
		set left_ports [lindex $ports_list 1]
		set right_ports [lindex $ports_list 2]
		set top_ports [lindex $ports_list 3]
		set bottom_ports [lindex $ports_list 4]
		set bbox [get_item_bounding_box $thecanvas $widget_tag_or_id]

		set port_pattern [get_port_pattern $port]
		set port_index [lsearch -regexp $left_ports $port_pattern]
		if {$port_index != -1} {
			# Port is on left edge
			set port_list $left_ports
			set port_x [lindex $bbox 0]
		} else {
			set port_index [lsearch -regexp $right_ports $port_pattern]
			if {$port_index != -1} {
				# Port is on right edge
				set port_list $right_ports
				set port_x [lindex $bbox 2]
			}
		}
		if {$port_index != -1} {
			# Port is on left/right edge
			set port [lindex $port_list $port_index]
			regexp -- $port_pattern $port -> x_offset y_offset
			if {$x_offset != ""} {
				set port_x [expr "$port_x + $x_offset"]
			}
			if {$y_offset != ""} {
				set port_y [expr "[lindex $bbox 1] + $y_offset"]
			} else {
				set inputs_p_1 [expr [llength $port_list] + 1]
				set height [expr [lindex $bbox 3] - [lindex $bbox 1]]
				set port_y [expr "[lindex $bbox 1] + $height * ($port_index + 1) / $inputs_p_1"]
			}
			set pos [list $port_x $port_y]
		} else {
			set port_index [lsearch -regexp $top_ports $port_pattern]
			if {$port_index != -1} {
				# Port is on top edge
				set port_list $top_ports
				set port_y [lindex $bbox 1]
			} else {
				set port_index [lsearch -regexp $bottom_ports $port_pattern]
				if {$port_index != -1} {
					# Port is on bottom edge
					set port_list $bottom_ports
					set port_y [lindex $bbox 3]
				}
			}
			if {$port_index != -1} {
				set port [lindex $port_list $port_index]
				regexp -- $port_pattern $port -> x_offset y_offset
				if {$y_offset != ""} {
					set port_y [expr "$port_y + $y_offset"]
				}
				if {$x_offset != ""} {
					set port_x [expr "[lindex $bbox 0] + $x_offset"]
				} else {
					set inputs_p_1 [expr [llength $port_list] + 1]
					set width [expr [lindex $bbox 2] - [lindex $bbox 0]]
					set port_x [expr "[lindex $bbox 0] + $width * ($port_index + 1) / $inputs_p_1"]
				}
				set pos [list $port_x $port_y]
			} else {
				error "Cannot find port $port on widget $widget_tag_or_id (left $left_ports; right $right_ports; top $top_ports; bottom $bottom_ports)"
			}
		}
	} else {
		error "No ports on widget $widget_tag_or_id (looking for port $port)"
	}
	return $pos
}

# ----------------------------------------------------------------
#
proc dtw_circuit::canvas_wire { canvas_window src_widget out_port dest_widget in_port args } {
#
# Description: Connects the two ports with a wire line
#
# ----------------------------------------------------------------
	# Set default options
	# -format: value is the wire's trace
	#    "[{f|p}n]x" denotes a horizontal wire.
	#         If the f-prefix is specified, then the wire traces the n fraction of the horizontal Manhattan distance.
    #         If the p-prefix is specified, then the wire traces that number of horizontal pixels.
	#         If no prefix is specified, the wire traces the remaining x distance to the destination
	#    "[{f|p}n]y" denotes a vertical wire.
	#         If the f-prefix is specified, then the wire traces the n fraction of the vertical Manhattan distance.
	#         If the p-prefix is specified, then the wire traces that number of vertical pixels.
    #         If no prefix is is specified, the wire traces the remaining x distance to the destination
	#    "o" denotes a connection dot in the wire
	# -arrow: adds an arrow to the endpoint
	# -tag: selectable tag
	array set options [list "-bubble" 0 "-bus" 0 "-format" "f.5xyx" "-label" "" "-arrow" 0 "-tag" ""]
	foreach {option value} $args {
		if {[array names options -exact "$option"] != ""} {
			set options($option) $value
		} else {
			error "ERROR: Unknown option $option (with value $value)"
		}
	}

	set wire_tag [create_tag $options(-tag)]
	if {$src_widget != ""} {
		set src_pos [get_port_position $canvas_window $src_widget $out_port]
	}
	if {$dest_widget != ""} {
		set dest_pos [get_port_position $canvas_window $dest_widget $in_port]
	} else {
		set dest_pos [list [expr [lindex $src_pos 0] + $in_port] [lindex $src_pos 1]]
	}
	if {$src_widget == ""} {
		set src_pos [list [expr [lindex $dest_pos 0] - $out_port] [lindex $dest_pos 1]]
	}
	set src_x [lindex $src_pos 0]
	set src_y [lindex $src_pos 1]
	set dest_x [lindex $dest_pos 0]
	set dest_y [lindex $dest_pos 1]
	set x_distance [expr "abs($dest_x - $src_x)"]
	if {$x_distance < 10} {
		set x_distance 10
	}
	set y_distance [expr "abs($dest_y - $src_y)"]
	if {$y_distance < 10} {
		set y_distance 10
	}
	if {$options(-label) != ""} {
		$canvas_window create text [expr $src_x + 2] $src_y -text $options(-label) -anchor sw
	}

	if {$options(-bubble) == 1} {
		set bubble_size 6
		set bubble_left [expr "$dest_x - $bubble_size"]
		set bubble_top [expr "$dest_y - $bubble_size / 2"]
		set bubble_right $dest_x
		set bubble_bottom [expr "$dest_y + $bubble_size / 2"]
		$canvas_window create oval $bubble_left $bubble_top $bubble_right $bubble_bottom
		set dest_x $bubble_left
	} elseif {$options(-bubble) == -1} {
		set bubble_size 6
		set bubble_left [expr "$dest_x"]
		set bubble_top [expr "$dest_y - $bubble_size / 2"]
		set bubble_right [expr $dest_x + $bubble_size]
		set bubble_bottom [expr "$dest_y + $bubble_size / 2"]
		$canvas_window create oval $bubble_left $bubble_top $bubble_right $bubble_bottom
		set dest_x $bubble_right
	}


	set format_str $options(-format)
	set coord_list [list $src_x $src_y]
	while {$format_str != ""} {
		set current_x [lindex $coord_list end-1]
		set current_y [lindex $coord_list end]
		if {[string index $format_str 0] == "f"} {
			set format_str [string range $format_str 1 end]
			if {[string is double -strict -failindex i $format_str] == 0 && $i > 0} {
				set ratio [string range $format_str 0 [expr $i - 1]]
				set spec [string index $format_str $i]
				if {$spec == "x"} {
					set to_x [expr "$current_x + $x_distance * $ratio"]
					set to_y $current_y
				} elseif {$spec == "y"} {
					set to_x $current_x
					set to_y [expr "$current_y + $y_distance * $ratio"]
				} else {
					error "Unknown format specification $spec in -format $options(-format)"
				}
				lappend coord_list $to_x $to_y
				set format_str [string range $format_str [expr $i + 1] end]
			} else {
				error "Unknown ratio specification $format_str in -format $options(-format)"
			}
		} elseif {[string index $format_str 0] == "p"} {
			set format_str [string range $format_str 1 end]
			if {[string is integer -strict -failindex i $format_str] == 0 && $i > 0} {
				set pixels [string range $format_str 0 [expr $i - 1]]
				set spec [string index $format_str $i]
				if {$spec == "x"} {
					set to_x [expr "$current_x + $pixels"]
					set to_y $current_y
				} elseif {$spec == "y"} {
					set to_x $current_x
					set to_y [expr "$current_y + $pixels"]
				} else {
					error "Unknown format specification $spec in -format $options(-format)"
				}
				lappend coord_list $to_x $to_y
				set format_str [string range $format_str [expr $i + 1] end]
			} else {
				error "Unknown pixel specification $format_str in -format $options(-format)"
			}
		} elseif {[string index $format_str 0] == "x"} {
			set to_x $dest_x
			set to_y $current_y
			lappend coord_list $to_x $to_y
			set format_str [string range $format_str 1 end]
		} elseif {[string index $format_str 0] == "y"} {
			set to_x $current_x
			set to_y $dest_y
			lappend coord_list $to_x $to_y
			set format_str [string range $format_str 1 end]
		} elseif {[string index $format_str 0] == "o"} {
			set dot_size 6
			set dot_left [expr "$current_x - $dot_size / 2"]
			set dot_top [expr "$current_y - $dot_size / 2"]
			set dot_right [expr "$current_x + $dot_size / 2"]
			set dot_bottom [expr "$current_y + $dot_size / 2"]
			$canvas_window create oval $dot_left $dot_top $dot_right $dot_bottom -fill black
			set format_str [string range $format_str 1 end]
		} elseif {[string index $format_str 0] == "a"} {
		} else {
			error "Unknown spec [string index $format_str 0] in -format $options(-format)"
		}
	}
	if {$options(-bus)} {
		set width 2
	} else {
		set width 1
	}
	if {$options(-arrow)} {
		set arrow_opt "last"
	} else {
		set arrow_opt "none"
	}
	return [$canvas_window create line $coord_list -width $width -arrow $arrow_opt -tags $wire_tag]
}

# ----------------------------------------------------------------
#
proc dtw_circuit::see { canvas_window widget_tag_or_id_list} {
#
# Description: Scrolls the canvas to make the given widget visible
#
# ----------------------------------------------------------------
	set bbox [eval $canvas_window bbox $widget_tag_or_id_list]
	set scrollregion [$canvas_window cget -scrollregion]

	set xview [$canvas_window xview]
	set xview_width [expr "[lindex $xview 1] - [lindex $xview 0]"]
	if {$xview_width < 1} {
		set centerx [expr "([lindex $bbox 0] + [lindex $bbox 2]) / 2"]
		set new_xview [expr "$centerx * 1.0 / [lindex $scrollregion 2] - $xview_width / 2.0"]
		if {$new_xview < 0} {
			set new_xview 0
		}
		if {$new_xview > 1} {
			set new_xview 1
		}
		$canvas_window xview moveto $new_xview
	}

	set yview [$canvas_window yview]
	set yview_height [expr "[lindex $yview 1] - [lindex $yview 0]"]
	if {$yview_height < 1} {
		set centery [expr "([lindex $bbox 1] + [lindex $bbox 3]) / 2"]
		set new_yview [expr "$centery * 1.0 / [lindex $scrollregion 3] - $yview_height / 2.0"]
		if {$new_yview < 0} {
			set new_yview 0
		}
		if {$new_yview > 1} {
			set new_yview 1
		}
		$canvas_window yview moveto $new_yview
	}
}
# ----------------------------------------------------------------
#
proc dtw_circuit::select_item { canvas_frame widget_tag_or_id_list} {
#
# Description: Highlights the given widgets
#
# ----------------------------------------------------------------
	foreach tag_or_id $widget_tag_or_id_list {
		set selected_items [$canvas_frame.canvas find withtag $tag_or_id]
		set item_selected 0
		foreach selected_id $selected_items {
			set type [$canvas_frame.canvas type $selected_id]
			if {$type == "polygon" || $type == "rectangle"} {
				# Select polygon
				$canvas_frame.canvas itemconfigure $selected_id -outline blue -width 3
				set item_selected 1
				break
			}
		}
		if {$item_selected == 0} {
			foreach selected_id $selected_items {
				set type [$canvas_frame.canvas type $selected_id]
				if {$type == "line"} {
					# Select line
					$canvas_frame.canvas itemconfigure $selected_id -fill blue -width 3
					set item_selected 1
				}
			}
		}
	}
	if {$item_selected == 1} {
		see $canvas_frame.canvas $widget_tag_or_id_list
	}
}

# ----------------------------------------------------------------
#
proc dtw_circuit::deselect_item { canvas_frame widget_tag_or_id_list} {
#
# Description: Unhighlights the given widgets
#
# ----------------------------------------------------------------
	foreach tag_or_id $widget_tag_or_id_list {
		set selected_items [$canvas_frame.canvas find withtag $tag_or_id]
		set item_deselected 0
		foreach selected_id $selected_items {
			set type [$canvas_frame.canvas type $selected_id]
			if {$type == "polygon" || $type == "rectangle"} {
				# Deselect polygon
				$canvas_frame.canvas itemconfigure $selected_id -outline black -width 1
				set item_deselected 1
				break
			}
		}
		if {$item_deselected == 0} {
			foreach selected_id $selected_items {
				set type [$canvas_frame.canvas type $selected_id]
				if {$type == "line"} {
					# Deselect line
					$canvas_frame.canvas itemconfigure $selected_id -fill black -width 1
				}
			}
		}
	}
}

# ----------------------------------------------------------------
#
proc dtw_circuit::create_canvas { canvas_frame args} {
#
# Description: Creates the circuit drawing canvas
#
# ----------------------------------------------------------------
	array set options [list "-color" gray80]
	foreach {option value} $args {
		if {[array names options -exact "$option"] != ""} {
			set options($option) $value
		} else {
			error "ERROR: Unknown option $option (with value $value)"
		}
	}

	# Make sure there's no previous canvas
	pack forget $canvas_frame
	destroy $canvas_frame

	frame $canvas_frame
	canvas ${canvas_frame}.canvas -background $options(-color) -yscrollcommand "[namespace code smart_yscroll] ${canvas_frame}.yscrollbar" -xscrollcommand  "[namespace code smart_xscroll] ${canvas_frame}.xscrollbar"
	scrollbar ${canvas_frame}.yscrollbar -orient vertical -command "${canvas_frame}.canvas yview"
	scrollbar ${canvas_frame}.xscrollbar -orient horizontal -command "${canvas_frame}.canvas xview"
	grid columnconfigure ${canvas_frame} 0 -weight 1
	grid columnconfigure ${canvas_frame} 1 -weight 0
	grid rowconfigure ${canvas_frame} 0 -weight 1
	grid rowconfigure ${canvas_frame} 1 -weight 0
	grid configure ${canvas_frame}.canvas -row 0 -sticky nsew
	# Note that the scrollbars are only visible when necessary

	pack $canvas_frame -side top -fill both -expand 1

	return ${canvas_frame}.canvas
}

# ----------------------------------------------------------------
#
proc dtw_circuit::smart_xscroll { xscrollbar scroll_fraction_begin scroll_fraction_end } {
#
# Description: Configures the X scrollbar
#
# ----------------------------------------------------------------
	if {$scroll_fraction_begin > 0 || $scroll_fraction_end < 1} {
		grid configure $xscrollbar -row 1 -column 0 -sticky ew
		$xscrollbar set $scroll_fraction_begin $scroll_fraction_end
	} else {
		grid forget $xscrollbar
	}
}

# ----------------------------------------------------------------
#
proc dtw_circuit::smart_yscroll { yscrollbar scroll_fraction_begin scroll_fraction_end } {
#
# Description: Configures the Y scrollbar
#
# ----------------------------------------------------------------
	if {$scroll_fraction_begin > 0 || $scroll_fraction_end < 1} {
		grid configure $yscrollbar -row 0 -column 1 -sticky ns
		$yscrollbar set $scroll_fraction_begin $scroll_fraction_end
	} else {
		grid forget $yscrollbar
	}
}

# ----------------------------------------------------------------
#
proc dtw_circuit::label_port { canvas_window widget port args } {
#
# Description: Labels the port on the widget
#
# ----------------------------------------------------------------
	array set options [list "-anchor" "e" "-text" $port]
	foreach {option value} $args {
		if {[array names options -exact "$option"] != ""} {
			set options($option) $value
		} else {
			error "ERROR: Unknown option $option (with value $value)"
		}
	}
	set port_pos [get_port_position $canvas_window $widget $port]
	set port_x [lindex $port_pos 0]
	set port_y [lindex $port_pos 1]
	if {$options(-anchor) == "e"} {
		set port_x [expr "$port_x - 1"]
	} elseif {$options(-anchor) == "w"} {
		set port_x [expr "$port_x + 1"]
	} elseif {$options(-anchor) == "n"} {
		set port_y [expr "$port_y + 1"]
	}  elseif {$options(-anchor) == "s"} {
		set port_y [expr "$port_y - 1"]
	}
	$canvas_window create text $port_x $port_y -text $options(-text) -anchor $options(-anchor) -tags $widget
}

# ----------------------------------------------------------------
#
proc dtw_circuit::draw_resync_circuit { canvas_frame memory_type use_hardware_dqs use_feedback use_source_synchronous_pll use_dcfifo } {
#
# Description: Draws the read resync circuit in $canvas_window
#
# ----------------------------------------------------------------
	set canvas_window [create_canvas $canvas_frame]

	# Get memory-specific parameters
	::dtw::dtw_device_get_family_parameter "_default" ${memory_type}_user_terms mem_user_term_list
	array set mem_user_term $mem_user_term_list

	set ck_string $mem_user_term(ck)   
	set dqs_string $mem_user_term(read_dqs)
	set dq_string $mem_user_term(read_dq)
	set is_inverted_capture $mem_user_term(inverted_capture)

	variable pll_cx
	variable pll_cy
	variable dff_cx
	variable dff_cy
	variable pin_cy

	set margin 20
	set pin_x 200
	set memory_x 80
	set capture_x [expr "$pin_x + 30"]
	set capture_y $margin
	set dqs_y [expr "$capture_y + $dff_cy * 2 / 3"]
	set feedback_pll_x [expr "$pin_x + 30"]
	set feedback_pll_y [expr "$capture_y + $dff_cy + 5"]
	set system_pll_x $feedback_pll_x
	set system_pll_y [expr "$feedback_pll_y + $pll_cy + 2 * $pin_cy + 5"]
	set resync_x [expr "$capture_x + $dff_cx + 50"]
	set resync_y $capture_y
	set resync2_x [expr "$resync_x + $dff_cx + 50"]
	set resync2_y $capture_y
	set sys_clk_pin_y [expr "$system_pll_y - $pin_cy/2"]
	set feedback_out_pin_y [expr "$sys_clk_pin_y - $pin_cy - 5"]
	if {$use_dcfifo == 1} {
		set resync_string "Dual-\nClock\nFIFO"
	} else {
		set resync_string "Resync\nDFF"
	}


	canvas_fpga $canvas_window [expr "$pin_x - 40"] "FPGA (Read Data Resynchronization Circuitry)"

	canvas_memory $canvas_window $memory_x $sys_clk_pin_y $ck_string $dqs_y $dqs_string -tag "memory_widget"

	canvas_pll $canvas_window $system_pll_x $system_pll_y "System\nPLL" -outputs "c0 c1 c2" -tag "sys_pll_widget"
	canvas_input_pin $canvas_window $pin_x [expr $system_pll_y + $pll_cy / 2] "clk" -tag "pll_inclk_pin_widget"
	canvas_wire $canvas_window "pll_inclk_pin_widget" "out" "sys_pll_widget" "inclk" -format f0.5xyx -tag "pll_inclk_wire_widget"

	if {$use_hardware_dqs || $use_source_synchronous_pll} {
		canvas_input_pin $canvas_window $pin_x $dqs_y $dqs_string -tag "dqs_pin_widget"
		canvas_wire $canvas_window "memory_widget" $dqs_string "dqs_pin_widget" "in"
	}
	if {$use_hardware_dqs} {
		canvas_dff $canvas_window $capture_x $capture_y "$dq_string read\ncapture" -tag "capture_dff_widget"
		if {$use_feedback} {
			canvas_dff $canvas_window $resync_x $resync_y "$resync_string 1" -tag "resync_dff_widget"
			canvas_dff $canvas_window $resync2_x $resync2_y "$resync_string 2" -tag "resync2_dff_widget"
			canvas_wire $canvas_window "resync_dff_widget" "q" "resync2_dff_widget" "d" -bus 1 -arrow 1
		} else {
			canvas_dff $canvas_window $resync_x $resync_y $resync_string -tag "resync_dff_widget"
		}
		canvas_wire $canvas_window "dqs_pin_widget" "out" "capture_dff_widget" "clk" -bubble $is_inverted_capture
		canvas_wire $canvas_window "capture_dff_widget" "q" "resync_dff_widget" "d" -bus 1 -arrow 1
	} else {
		# non-DQS mode
		if {$use_feedback || $use_source_synchronous_pll} {
			canvas_dff $canvas_window $resync_x $resync_y "$dq_string read\ncapture" -tag "resync_dff_widget"
			canvas_dff $canvas_window $resync2_x $resync2_y $resync_string -tag "resync2_dff_widget"
			canvas_wire $canvas_window "resync_dff_widget" "q" "resync2_dff_widget" "d" -bus 1 -arrow 1
		} else {
			canvas_dff $canvas_window $resync_x $resync_y "$dq_string read\ncapture" -tag "resync_dff_widget"
		}
	}

	if {$use_feedback || ($use_hardware_dqs == 0 && $use_source_synchronous_pll)} {
		canvas_pll $canvas_window $feedback_pll_x $feedback_pll_y "Fedback\nPLL" -tag "resync_pll_widget"
		if {$use_feedback} {
			canvas_output_pin $canvas_window $pin_x $feedback_out_pin_y "feedback_out" -tag "feedback_output_pin_widget"
			canvas_input_pin $canvas_window $pin_x [expr $feedback_pll_y + $pll_cy / 2] "fedback_in" -tag "fedback_clk_pin_widget"
			canvas_wire $canvas_window "sys_pll_widget" "c1" "feedback_output_pin_widget" "in" -format f.2xyx -tag "pll_2_feedback_output_wire_widget"
			canvas_wire $canvas_window "feedback_output_pin_widget" "out" "fedback_clk_pin_widget" "in" -format f-2.0xyx -tag "feedback_wire_widget"
			canvas_wire $canvas_window "fedback_clk_pin_widget" "out" "resync_pll_widget" "inclk" -tag "fedback_in_2_pll_wire_widget"
		} elseif {$use_source_synchronous_pll} {
			canvas_wire $canvas_window "dqs_pin_widget" "out" "resync_pll_widget" "inclk"
		}

		canvas_wire $canvas_window "resync_pll_widget" "c0" "resync_dff_widget" "clk" -format f0.5xyx -tag "pll_2_resync_wire_widget"
		if {$use_dcfifo} {
			canvas_wire $canvas_window "resync_pll_widget" "c0" "resync2_dff_widget" "clk" -format f0.8xyx -tag "pll_2_fifo_clk_wire_widget"
		} else {
			canvas_wire $canvas_window "sys_pll_widget" "c2" "resync2_dff_widget" "clk" -format f0.8xyx -tag "pll_2_resync2_clk_wire_widget"
		}
	} else {
		if {$use_hardware_dqs && $use_dcfifo} {
			canvas_wire $canvas_window "dqs_pin_widget" "out" "resync_dff_widget" "clk" -format f0.1xop25yf0.8xyx -tag "pll_2_fifo_wire_widget"
		} else {
			canvas_wire $canvas_window "sys_pll_widget" "c2" "resync_dff_widget" "clk" -format f0.5xyx -tag "pll_2_resync_wire_widget"
		}
	}

	canvas_output_pin $canvas_window $pin_x $sys_clk_pin_y "sys_clk" -tag "sys_output_pin_widget"
	canvas_wire $canvas_window "sys_pll_widget" "c0" "sys_output_pin_widget" "in" -format f0.1xyx -tag "pll_2_sys_output_wire_widget"
	canvas_wire $canvas_window "memory_widget" $ck_string "sys_output_pin_widget" "out" -format f0.1xyx

	set canvas_height [expr $system_pll_y + $pll_cy + $margin]
	set canvas_width [expr $resync2_x + $dff_cx + $margin]
	$canvas_window configure -scrollregion [list 0 0 $canvas_width $canvas_height]
	#set widgets_bounding_box [$canvas_window bbox all]
	#$canvas_window configure -scrollregion $widgets_bounding_box
}


# ----------------------------------------------------------------
#
proc dtw_circuit::draw_postamble_circuit { canvas_frame memory_type use_feedback use_hardware_postamble } {
#
# Description: Draws the read resync circuit in $canvas_window
#
# ----------------------------------------------------------------
	set canvas_window [create_canvas $canvas_frame]

	# Get memory-specific parameters
	::dtw::dtw_device_get_family_parameter "_default" ${memory_type}_user_terms mem_user_term_list
	array set mem_user_term $mem_user_term_list

	set ck_string $mem_user_term(ck)   
	set dqs_string $mem_user_term(read_dqs)
	set dq_string $mem_user_term(read_dq)
	set is_inverted_capture $mem_user_term(inverted_capture)

	variable pll_cx
	variable pll_cy
	variable dff_cx
	variable dff_cy
	variable pin_cy
	variable gate_cy
	variable vcc_cy

	set margin 20
	set pin_x 200
	set memory_x 80
	set feedback_pll_x [expr "$pin_x + 30"]
	set feedback_pll_y [expr "$margin + $dff_cy + 10"]
	set system_pll_x $feedback_pll_x
	set system_pll_y [expr "$feedback_pll_y + $pll_cy + 2 * $pin_cy + 5"]
	set sys_clk_pin_y [expr "$system_pll_y - $pin_cy/2"]
	set feedback_out_pin_y [expr "$sys_clk_pin_y - $pin_cy - 5"]
	set postamble_sys_x [expr "$system_pll_x + $pll_cx + 30"]
	set postamble_ctrl_x [expr "$postamble_sys_x + $dff_cx + 30"]
	set postamble_x [expr "$postamble_ctrl_x + $dff_cx + 30"]
	set capture_x [expr "$postamble_x + $dff_cx + 30"]
	set capture_y $margin
	set dqs_y [expr "$capture_y + $dff_cy * 3 / 4"]
	set and_gate_y [expr "$dqs_y - $gate_cy / 3"]
	set postamble_y [expr "$capture_y + $dff_cy + 20"]
	set postamble_ctrl_y $sys_clk_pin_y
	set postamble_sys_y $sys_clk_pin_y
	set and_gate_x $postamble_x

	canvas_fpga $canvas_window [expr "$pin_x - 40"] "FPGA (Read Data Resynchronization Circuitry)"

	canvas_memory $canvas_window $memory_x $sys_clk_pin_y $ck_string $dqs_y $dqs_string -tag "memory_widget"

	canvas_pll $canvas_window $system_pll_x $system_pll_y "System\nPLL" -outputs "c0 c1 c2" -tag "sys_pll_widget"
	canvas_input_pin $canvas_window $pin_x [expr $system_pll_y + $pll_cy / 2] "clk" -tag "pll_inclk_pin_widget"
	canvas_wire $canvas_window "pll_inclk_pin_widget" "out" "sys_pll_widget" "inclk" -format f0.5xyx -tag "pll_inclk_wire_widget"

	canvas_input_pin $canvas_window $pin_x $dqs_y $dqs_string -tag "dqs_pin_widget"
	canvas_wire $canvas_window "memory_widget" $dqs_string "dqs_pin_widget" "in"

	canvas_dff $canvas_window $capture_x $capture_y "$dq_string read\ncapture" -tag "capture_dff_widget" -inputs "d ce clk"
	canvas_dff $canvas_window $postamble_x $postamble_y "Postamble\nEnable" -tag "postamble_dff_widget" -inputs "d sclr clk" -cx [expr $dff_cx + 15] -cy [expr $dff_cy + 10]
	label_port $canvas_window "postamble_dff_widget" "clr" -anchor s -text "pre"
	canvas_vcc $canvas_window [expr "$postamble_x - 10"] [expr "$postamble_y + $vcc_cy"] -tag "postamble_vcc_widget"
	label_port $canvas_window "postamble_dff_widget" "sclr" -anchor w
	canvas_wire $canvas_window "postamble_vcc_widget" "out" "postamble_dff_widget" "sclr" -format yx -bus 1

	if {$use_hardware_postamble} {
		canvas_and $canvas_window $and_gate_x $and_gate_y -out_side r -tag "dqs_and_gate_widget"
		canvas_wire $canvas_window "dqs_pin_widget" "out" "dqs_and_gate_widget" "in0" -bus 1 -arrow 1
		canvas_wire $canvas_window "dqs_and_gate_widget" "out" "capture_dff_widget" "clk" -bubble $is_inverted_capture -bus 1
		canvas_wire $canvas_window "dqs_and_gate_widget" "out" "postamble_dff_widget" "clk" -format f0.3xof0.2yf-2.0xyx -bubble 1 -bus 1
		canvas_wire $canvas_window "postamble_dff_widget" "q" "dqs_and_gate_widget" "in1" -format f0.3xf-0.7yf-1.5xyx -bus 1 -arrow 1
	} else {
		canvas_wire $canvas_window "dqs_pin_widget" "out" "capture_dff_widget" "clk" -format x -bus 1
		label_port $canvas_window "capture_dff_widget" "ce" -anchor w -text "ce"
		canvas_wire $canvas_window "postamble_dff_widget" "q" "capture_dff_widget" "ce" -format f0.5xyx
		canvas_wire $canvas_window "dqs_pin_widget" "out" "postamble_dff_widget" "clk" -bubble 1 -format f0.9xoyx
	}

	canvas_dff $canvas_window $postamble_ctrl_x $postamble_ctrl_y "Postamble\nCtrl" -tag "postamble_ctrl_dff_widget" -cx [expr $dff_cx + 5]
	if {$use_feedback} {
		canvas_dff $canvas_window $postamble_sys_x $postamble_sys_y "Postamble\nSys Ctrl" -cx [expr $dff_cx + 5] -tag "postamble_sys_dff_widget"
		canvas_wire $canvas_window "postamble_sys_dff_widget" "q" "postamble_ctrl_dff_widget" "d" -format f0.3xyx -bus 1 -arrow 1
	}
	canvas_wire $canvas_window "postamble_ctrl_dff_widget" "q" "postamble_dff_widget" "clr" -format xy -bus 1 -arrow 1

	if {$use_feedback} {
		canvas_pll $canvas_window $feedback_pll_x $feedback_pll_y "Fedback\nPLL" -tag "resync_pll_widget"
		canvas_output_pin $canvas_window $pin_x $feedback_out_pin_y "feedback_out" -tag "feedback_output_pin_widget"
		canvas_input_pin $canvas_window $pin_x [expr $feedback_pll_y + $pll_cy / 2] "fedback_in" -tag "fedback_clk_pin_widget"
		canvas_wire $canvas_window "fedback_clk_pin_widget" "out" "resync_pll_widget" "inclk" -tag "fedback_in_2_pll_wire_widget"
		canvas_wire $canvas_window "feedback_output_pin_widget" "out" "fedback_clk_pin_widget" "in" -format f-2.0xyx -tag "feedback_wire_widget"
		canvas_wire $canvas_window "sys_pll_widget" "c1" "feedback_output_pin_widget" "in" -format f0.2xyx -tag "pll_2_feedback_output_wire_widget"

		canvas_wire $canvas_window "resync_pll_widget" "c1" "postamble_ctrl_dff_widget" "clk" -format f0.9xyx -tag "pll_2_postamble_ctrl_wire_widget"
		canvas_wire $canvas_window "sys_pll_widget" "c2" "postamble_sys_dff_widget" "clk" -format f0.8xyx -tag "pll_2_postamble_sys_wire_widget"
	} else {
		canvas_wire $canvas_window "sys_pll_widget" "c2" "postamble_ctrl_dff_widget" "clk" -format f0.5xyx -tag "pll_2_postamble_ctrl_wire_widget"
	}

	canvas_output_pin $canvas_window $pin_x $sys_clk_pin_y "sys_clk" -tag "sys_output_pin_widget"
	canvas_wire $canvas_window "sys_pll_widget" "c0" "sys_output_pin_widget" "in" -format f0.1xyx -tag "pll_2_sys_output_wire_widget"
	canvas_wire $canvas_window "memory_widget" $ck_string "sys_output_pin_widget" "out" -format f0.1xyx

	set canvas_height [expr $system_pll_y + $pll_cy + $margin]
	set canvas_width [expr $capture_x + $dff_cx + $margin]
	$canvas_window configure -scrollregion [list 0 0 $canvas_width $canvas_height]
	#set widgets_bounding_box [$canvas_window bbox all]
	#$canvas_window configure -scrollregion $widgets_bounding_box
}
