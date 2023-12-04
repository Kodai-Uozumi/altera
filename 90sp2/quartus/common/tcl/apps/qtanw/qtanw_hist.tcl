###################################################################################
#                                                                                 #
# File Name:    qtanw_hist.tcl                                					  #
#                                                                                 #
# Summary:       Given a list of numerical values, the qhist script will select   #
#				 the appropriate bin size based on user argument and draw a 	  #
#				 histogram using the BLT package								  #
#				 To be sourced in qtanw_script.tcl								  #
#                                                        						  #
# Author:		Diwei Zhang														  #
#                                                                                 #
# Licensing:    This script is  pursuant to the following license agreement       #
#               (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE               #
#               FOLLOWING): Copyright (c) 2004 Altera Corporation, San Jose,      #
#               California, USA.  Permission is hereby granted, free of           #
#               charge, to any person obtaining a copy of this software and       #
#               associated documentation files (the "Software"), to deal in       #
#               the Software without restriction, including without limitation    #
#               the rights to use, copy, modify, merge, publish, distribute,      #
#               sublicense, and/or sell copies of the Software, and to permit     #
#               persons to whom the Software is furnished to do so, subject to    #
#               the following conditions:                                         #
#                                                                                 #
#               The above copyright notice and this permission notice shall be    #
#               included in all copies or substantial portions of the Software.   #
#                                                                                 #
#               THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,   #
#               EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES   #
#               OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND          #
#               NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT       #
#               HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,      #
#               WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING      #
#               FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR     #
#               OTHER DEALINGS IN THE SOFTWARE.                                   #
#                                                                                 #
#               This agreement shall be governed in all respects by the laws of   #
#               the State of California and by the laws of the United States of   #
#               America.                                                          #
#                                                                                 #
###################################################################################

###################################################################################
#  README
#
#	This script is used in QTANW to display a histogram.
#	This script essentially functions as a wrapper to the advanced tcl graphing 
#	fucntions that the BLT package provides.
#
#	The histogram needs to first be initialized with the data in a list format,
#	titles, labels and various other options.  The initialization is done with the
#	qtanw::qhist::initHist function.  And then, the histogram can be drawn with the
#	qtanw::qhist::drawHist function.
#
#	Options include:
#		-num_bins <int>		this is the number of bars the histogram will have
#							default is 30
#
#		-linemarker	<int>	draws a vertical line at x-value specified by <int>
#							colors everything to the left of the marker red
#							colors everything to the right of the marker green
#	
#		-title <string>		title
#		-xlabel <string>	x-axis label
#		-ylabel <string>	y-axis label
#
#	Sample usage:
#
#	set values [list -0.5 -0.6 -1 0 1]
#	qtanw::qhist::initHist $values  -linemarker 0 -title "Negative Slack Histogram" \
#									-xlabel "Slack (ns)" -ylabel "Number of Edges" \
#									-num_bins 20
#	qtanw::qhist::drawHist
#
###################################################################################


# Only qtanw exes can interpret this script
if [info exist quartus] {
	if { ![string equal $quartus(nameofexecutable) quartus_tan] } {
		set msg "QTANW should be invoked from the command line.\nUsage: quartus_tan -g \[<project_name>\]"
		puts $msg
		catch { tk_messageBox -type ok -message $msg -icon error }
		return
	}
} else {
	set msg "QTANW should be invoked using the Quartus II Shell.\nUsage: quartus_tan -g \[<project_name>\]"
	puts $msg
	catch { tk_messageBox -type ok -message $msg -icon error }
	exit -1
}

#### Requires BLT Package ####
init_tk
package require BLT
package require math::statistics

###  Export Functions and Global Namespace Variables  ###
#########################################################
#  The datapoints for the qhist package is stored in an
#  array.  The index is the x-value and each array element
#  contains the y-value (the number of occurances)
#########################################################
namespace eval qtanw::qhist {
	variable bin_size
	# An array to store user-defined options
	# Indices include: -linemarker, -num_bins
	variable opt_array		
	# An array to store the upper and lower bounds
	#    of the x and y axis
	# Indices include: x_min, x_max, y_min, y_max
	variable bounds	
	# An array to store the statistics of the data
	variable stats	
	# An array to store the all the bins
	# Indices are the values of the bins
	variable bin_array
}

########################################################
# proc qtanw::qhist::initHist { my_list -num_bins -border -linemarker -title -xlabel -ylabel}
#
# Argument: 1. a list of numerical values
#			2. an optional value of a border value
#				where the data will be divided
#
# Description:  Initializes the histogram but DOES NOT
#				  draw it
########################################################
proc qtanw::qhist::initHist { data_list args } {
	variable bin_size
	
	variable bounds
	variable bin_array
	variable opt_array
	variable stats
	# some variables need to be reset each time
	#   the histogram is re-initialized
	array unset bounds
	array unset bin_array
	array unset opt_array
	array unset stats
	
	# the list of available arguments
	set avail_args {-num_bins -linemarker -title -xlabel -ylabel}
	
	# set the options to defaults
	set opt_array(-num_bins) 30
	set opt_array(-title) ""
	set opt_array(-xlabel) ""
	set opt_array(-ylabel) ""
	
	# set the user defined options to the options array
	set index 0
	foreach cur $args {
		if {[lsearch $avail_args $cur] != -1} {
			set opt_array($cur) [lindex $args [expr $index+1]]
		}
		incr index
	}
	# check if options are valid
	if { ![string is integer $opt_array(-num_bins)]} {
		return -code error "Invalid qhist::initHist option -num_bins take integer values"
	} elseif {$opt_array(-num_bins) <= 0} {
		return -code error "Invalid qhist::initHist option; -num_bins has to be > 0"
	} elseif {[array names opt_array -exact -linemarker] != ""} {
		if {![string is integer $opt_array(-linemarker)]} {
			return -code error "Invalid qhist::initHist option -linemarker take integer values"
		}
	}
	
	set stats(num) 0
	# determine the max and min values in the data_list
	foreach cur $data_list {
		incr stats(num)
		## If x min/max values don't exist, set them
		if {![info exists bounds(x_min)]} {
			set bounds(x_min) $cur
			set bounds(x_max) $cur
		} else {
			if {$cur > $bounds(x_max)} {
				set bounds(x_max) $cur
			} elseif {$cur < $bounds(x_min)} {
				set bounds(x_min) $cur
			}
		}
	}

	set stats(x_min) $bounds(x_min)
	set stats(x_max) $bounds(x_max)

	if { $bounds(x_max) == $bounds(x_min) }	{
		set tmp [expr {abs($bounds(x_max))}]
		set bounds(x_min) [expr $bounds(x_max) - $tmp]
		set bounds(x_max) [expr $bounds(x_max) + $tmp]
	}

	# determine bin_size according to max and min values
	#   and number of bins
	set bin_size [expr ($bounds(x_max) - $bounds(x_min)) / double($opt_array(-num_bins))]

	# if -linemarker was set, need to shift bins
	# -linemarker is the vertical (red) line to separate + and - slack bars.
	# What the following is doning is to make this line not passing through
	# any bar. It should sit at the boundary of 2 adjacent bars.
	# The x_min and x_max are also adjusted accordingly.
	if {[array names opt_array -exact -linemarker] != ""} {
		incr opt_array(-num_bins)
		set offset [expr {fmod(($opt_array(-linemarker) - $bounds(x_min)), $bin_size)}]
		set bounds(x_min) [expr {$bounds(x_min) - $bin_size + $offset}]
		set bounds(x_max) [expr {$bounds(x_min) + $bin_size * $opt_array(-num_bins)}]
	}

	# add values from data_list to the bins
	foreach cur $data_list {
		# determin which bin the current value belongs to
		# i.e. the 0th, 1st or 2nd bin
		set bin_index [expr {floor (($cur - $bounds(x_min)) / double ($bin_size))}]
		if {$bin_index >= $opt_array(-num_bins)} {
			set bin_index [expr {$opt_array(-num_bins)-1}]
		}
		
		# determine the average bin value (the mid-value of the bin)
		set x_Value [expr {$bounds(x_min) + ($bin_index * $bin_size) + ($bin_size / 2)}]
		
		# add the current value to the bin_array
		if {![info exists bin_array($x_Value)]} {
			set bin_array($x_Value) 1
		} else {
			incr bin_array($x_Value)
		}
	}

	# get the maximum y values so that the linemarker could be properly drawn
	foreach x_Value [array names bin_array] {
		## If y min/max values don't exist, set them
		if {![info exists bounds(y_min)]} {
			set bounds(y_min) $bin_array($x_Value)
			set bounds(y_max) $bin_array($x_Value)
		} else {
			if {$bin_array($x_Value) > $bounds(y_max)} {
				set bounds(y_max) $bin_array($x_Value)
			} elseif {$bin_array($x_Value) < $bounds(y_min)} {
				set bounds(y_min) $bin_array($x_Value)
			}
		}
	}
}


#########################################################
# proc qtanw::qhist::drawHist {}
#
# Description:  Draws the histogram after initHist has
#				been executed
#
#########################################################
proc qtanw::qhist::drawHist {} {
	variable bin_array
	variable bounds
	variable bin_size
	variable opt_array
	variable stats
	set color ""

	# Prepare the rectanglar plotting box.
	toplevel .chart
	blt::barchart .chart.plot
	frame .chart.textbox -borderwidth 1 -relief groove
	blt::htext .chart.textbox.textmsg -text " Total: $stats(num)   Min: $stats(x_min)   Max: $stats(x_max)"\
									  -height 15
	.chart.plot configure -title $opt_array(-title)
	.chart.plot xaxis configure	-title $opt_array(-xlabel)\
								-min $bounds(x_min)\
								-max $bounds(x_max)
	.chart.plot yaxis configure -title $opt_array(-ylabel)

	# Plot virtical bars.
	set bin_index 0
	foreach x_Value [array names bin_array] {
		if {[array names opt_array -exact -linemarker] != ""} {
			if {$x_Value < $opt_array(-linemarker)} {
				set color red
			} else {
				set color green
			}
		}
		
		.chart.plot element create 	$bin_index \
								-xdata $x_Value \
								-ydata $bin_array($x_Value) \
								-foreground $color \
								-label ""
		
		#.chart.plot element bind all <Enter> {
		#	qtanw::print_msg [.chart.plot element closest %x %y coord]
		#	set width [.chart.plot cget -barwidth]
		#	set lower_bound [expr {$coord(x) - 0.5*$width}]
		#	set upper_bound [expr {$coord(x) + 0.5*$width}]
		#	
			# Round the bounds to 3 decimal points
		#	set lower_bound [expr {int($lower_bound * 1000) / double (1000)}]
		#	set upper_bound [expr {int($upper_bound * 1000) / double (1000)}]
		#	
		#	.chart.textbox.textmsg configure -text "There are [expr int($coord(y))] data points in the ranges \
		#			between $lower_bound and $upper_bound"
		#}
		
		#.chart.plot element bind all <Leave> {
		#	.chart.textbox.textmsg configure -text "Total: $qtanw::qhist::stats(num) \
		#											Min: $qtanw::qhist::stats(x_min) \
		#											Max: $qtanw::qhist::stats(x_max)"
		#}
		
		incr bin_index
	}

	
	.chart.plot configure -barwidth $bin_size

	# Add the vertical (red) separate line.
	if {[array names opt_array -exact -linemarker] != ""} {
		set min -100
		set max [expr {$bounds(y_max) + abs($bounds(y_max)*.5)}]
		.chart.plot marker create line -outline red \
									   -coords {$opt_array(-linemarker) $min $opt_array(-linemarker) $max} \
									   -linewidth 2
	}
	pack .chart.plot
	pack .chart.textbox.textmsg
	pack .chart.textbox -side bottom
	tkwait window .chart
	catch {destroy .histogram}
}
