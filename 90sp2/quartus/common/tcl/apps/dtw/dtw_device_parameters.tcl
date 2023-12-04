if {[namespace exists ::dtw]} {
	::dtw::add_version_date {$Date: 2009/04/01 $}
}

##############################################################################
#
# File Name:    dtw_device_parameters.tcl
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

# Timing parameters
# Each data set is a map of the following format
# <field> <value>
set s_stratixii_m {family {stratix ii} \
		speed_grade {m} \
		sys_clk_min_tco {0.800 ns} \
		fb_clk_min_tco {0.800 ns}}

set s_stratixii_3 {family {stratix ii} \
		speed_grade {3} \
		sys_clk_max_tco {2.050 ns} \
		fb_clk_max_tco {2.050 ns} \
		pll_dc_distortion {0.170 ns} \
		pll_dc_distortion_rldram2 {0.160 ns} \
		pll_dc_distortion_qdr2 {0.160 ns} \
		fpga_tSHIFT_ERROR {0.038 ns} \
		fpga_tSHIFT_ERROR_bypass {0.000 ns} \
		fpga_tSHIFT_ERROR_delay_chain1 {0.013 ns} \
		fpga_tSHIFT_ERROR_delay_chain2 {0.025 ns} \
		fpga_tSHIFT_ERROR_delay_chain3 {0.038 ns} \
		fpga_tSHIFT_ERROR_delay_chain4 {0.050 ns} \
		PLL_compensation_error {0.100 ns}}

set s_stratixii_4 {family {stratix ii} \
		speed_grade {4} \
		sys_clk_max_tco {2.350 ns} \
		fb_clk_max_tco {2.350 ns} \
		pll_dc_distortion {0.180 ns} \
		pll_dc_distortion_rldram2 {0.170 ns} \
		pll_dc_distortion_qdr2 {0.170 ns} \
		fpga_tSHIFT_ERROR {0.045 ns} \
		fpga_tSHIFT_ERROR_bypass {0.000 ns} \
		fpga_tSHIFT_ERROR_delay_chain1 {0.015 ns} \
		fpga_tSHIFT_ERROR_delay_chain2 {0.030 ns} \
		fpga_tSHIFT_ERROR_delay_chain3 {0.045 ns} \
		fpga_tSHIFT_ERROR_delay_chain4 {0.060 ns} \
		PLL_compensation_error {0.100 ns}}

set s_stratixii_5 {family {stratix ii} \
		speed_grade {5} \
		sys_clk_max_tco {2.500 ns} \
		fb_clk_max_tco {2.500 ns} \
		pll_dc_distortion {0.180 ns} \
		pll_dc_distortion_rldram2 {0.170 ns} \
		pll_dc_distortion_qdr2 {0.170 ns} \
		fpga_tSHIFT_ERROR {0.053 ns} \
		fpga_tSHIFT_ERROR_bypass {0.000 ns} \
		fpga_tSHIFT_ERROR_delay_chain1 {0.018 ns} \
		fpga_tSHIFT_ERROR_delay_chain2 {0.035 ns} \
		fpga_tSHIFT_ERROR_delay_chain3 {0.053 ns} \
		fpga_tSHIFT_ERROR_delay_chain4 {0.070 ns} \
		PLL_compensation_error {0.100 ns}}

set s_stratixii_6 {family {stratix ii} \
		speed_grade {6} \
		sys_clk_max_tco {2.700 ns} \
		fb_clk_max_tco {2.700 ns} \
		pll_dc_distortion {0.180 ns} \
		pll_dc_distortion_rldram2 {0.170 ns} \
		pll_dc_distortion_qdr2 {0.170 ns} \
		fpga_tSHIFT_ERROR {0.053 ns} \
		fpga_tSHIFT_ERROR_bypass {0.000 ns} \
		fpga_tSHIFT_ERROR_delay_chain1 {0.018 ns} \
		fpga_tSHIFT_ERROR_delay_chain2 {0.035 ns} \
		fpga_tSHIFT_ERROR_delay_chain3 {0.053 ns} \
		fpga_tSHIFT_ERROR_delay_chain4 {0.070 ns} \
		PLL_compensation_error {0.100 ns}}

set s_stratixiii_m {family {stratix iii} \
		speed_grade {m} \
		sys_clk_min_tco {0.800 ns} \
		fb_clk_min_tco {0.800 ns}}

set s_stratixiii_2 {family {stratix iii} \
		speed_grade {2} \
		sys_clk_max_tco {2.050 ns} \
		fb_clk_max_tco {2.050 ns} \
		fpga_tSHIFT_ERROR {0.036 ns} \
		fpga_tSHIFT_ERROR_bypass {0.000 ns} \
		fpga_tSHIFT_ERROR_delay_chain1 {0.012 ns} \
		fpga_tSHIFT_ERROR_delay_chain2 {0.024 ns} \
		fpga_tSHIFT_ERROR_delay_chain3 {0.036 ns} \
		fpga_tSHIFT_ERROR_delay_chain4 {0.048 ns} \
		PLL_compensation_error {0.100 ns}}

set s_stratixiii_3 {family {stratix iii} \
		speed_grade {3} \
		sys_clk_max_tco {2.350 ns} \
		fb_clk_max_tco {2.350 ns} \
		fpga_tSHIFT_ERROR {0.041 ns} \
		fpga_tSHIFT_ERROR_bypass {0.000 ns} \
		fpga_tSHIFT_ERROR_delay_chain1 {0.014 ns} \
		fpga_tSHIFT_ERROR_delay_chain2 {0.028 ns} \
		fpga_tSHIFT_ERROR_delay_chain3 {0.041 ns} \
		fpga_tSHIFT_ERROR_delay_chain4 {0.055 ns} \
		PLL_compensation_error {0.100 ns}}

set s_stratixiii_4 {family {stratix iii} \
		speed_grade {4} \
		sys_clk_max_tco {2.500 ns} \
		fb_clk_max_tco {2.500 ns} \
		fpga_tSHIFT_ERROR {0.053 ns} \
		fpga_tSHIFT_ERROR_bypass {0.000 ns} \
		fpga_tSHIFT_ERROR_delay_chain1 {0.016 ns} \
		fpga_tSHIFT_ERROR_delay_chain2 {0.031 ns} \
		fpga_tSHIFT_ERROR_delay_chain3 {0.047 ns} \
		fpga_tSHIFT_ERROR_delay_chain4 {0.062 ns} \
		PLL_compensation_error {0.100 ns}}

set s_stratixiv_m {family {stratix iv} \
		speed_grade {m} \
		sys_clk_min_tco {0.800 ns} \
		fb_clk_min_tco {0.800 ns}}

set s_stratixiv_2 {family {stratix iv} \
		speed_grade {2} \
		sys_clk_max_tco {2.050 ns} \
		fb_clk_max_tco {2.050 ns} \
		fpga_tSHIFT_ERROR {0.036 ns} \
		fpga_tSHIFT_ERROR_bypass {0.000 ns} \
		fpga_tSHIFT_ERROR_delay_chain1 {0.012 ns} \
		fpga_tSHIFT_ERROR_delay_chain2 {0.024 ns} \
		fpga_tSHIFT_ERROR_delay_chain3 {0.036 ns} \
		fpga_tSHIFT_ERROR_delay_chain4 {0.048 ns} \
		PLL_compensation_error {0.100 ns}}

set s_stratixiv_3 {family {stratix iv} \
		speed_grade {3} \
		sys_clk_max_tco {2.350 ns} \
		fb_clk_max_tco {2.350 ns} \
		fpga_tSHIFT_ERROR {0.041 ns} \
		fpga_tSHIFT_ERROR_bypass {0.000 ns} \
		fpga_tSHIFT_ERROR_delay_chain1 {0.014 ns} \
		fpga_tSHIFT_ERROR_delay_chain2 {0.028 ns} \
		fpga_tSHIFT_ERROR_delay_chain3 {0.041 ns} \
		fpga_tSHIFT_ERROR_delay_chain4 {0.055 ns} \
		PLL_compensation_error {0.100 ns}}

set s_stratixiv_4 {family {stratix iv} \
		speed_grade {4} \
		sys_clk_max_tco {2.500 ns} \
		fb_clk_max_tco {2.500 ns} \
		fpga_tSHIFT_ERROR {0.053 ns} \
		fpga_tSHIFT_ERROR_bypass {0.000 ns} \
		fpga_tSHIFT_ERROR_delay_chain1 {0.016 ns} \
		fpga_tSHIFT_ERROR_delay_chain2 {0.031 ns} \
		fpga_tSHIFT_ERROR_delay_chain3 {0.047 ns} \
		fpga_tSHIFT_ERROR_delay_chain4 {0.062 ns} \
		PLL_compensation_error {0.100 ns}}

set s_hardcopyii_m {family {hardcopy ii} \
		speed_grade {m} \
		sys_clk_min_tco {0.800 ns} \
		fb_clk_min_tco {0.800 ns}}

set s_hardcopyii_4 {family {hardcopy ii} \
		speed_grade {4} \
		sys_clk_max_tco {2.350 ns} \
		fb_clk_max_tco {2.350 ns} \
		pll_dc_distortion {0.180 ns} \
		pll_dc_distortion_rldram2 {0.170 ns} \
		pll_dc_distortion_qdr2 {0.170 ns} \
		fpga_tSHIFT_ERROR {0.045 ns} \
		fpga_tSHIFT_ERROR_bypass {0.000 ns} \
		fpga_tSHIFT_ERROR_delay_chain1 {0.015 ns} \
		fpga_tSHIFT_ERROR_delay_chain2 {0.030 ns} \
		fpga_tSHIFT_ERROR_delay_chain3 {0.045 ns} \
		fpga_tSHIFT_ERROR_delay_chain4 {0.060 ns} \
		PLL_compensation_error {0.100 ns}}

set s_cycloneii_m {family {cyclone ii} \
		speed_grade {m} \
		sys_clk_min_tco {1.850 ns} \
		fb_clk_min_tco {1.850 ns}}

set s_cycloneii_6 {family {cyclone ii} \
		speed_grade {6} \
		sys_clk_max_tco {4.200 ns} \
		fb_clk_max_tco {4.200 ns}}

set s_cycloneii_7 {family {cyclone ii} \
		speed_grade {7} \
		sys_clk_max_tco {4.600 ns} \
		fb_clk_max_tco {4.600 ns}}

set s_cycloneii_8 {family {cyclone ii} \
		speed_grade {8} \
		sys_clk_max_tco {5.150 ns} \
		fb_clk_max_tco {5.150 ns}}

set s_cycloneiii_m {family {cyclone iii} \
		speed_grade {m} \
		sys_clk_min_tco {1.850 ns} \
		fb_clk_min_tco {1.850 ns}}

set s_cycloneiii_6 {family {cyclone iii} \
		speed_grade {6} \
		sys_clk_max_tco {4.200 ns} \
		fb_clk_max_tco {4.200 ns}}

set s_cycloneiii_7 {family {cyclone iii} \
		speed_grade {7} \
		sys_clk_max_tco {4.600 ns} \
		fb_clk_max_tco {4.600 ns}}

set s_cycloneiii_8 {family {cyclone iii} \
		speed_grade {8} \
		sys_clk_max_tco {5.150 ns} \
		fb_clk_max_tco {5.150 ns}}

set s_device_timing_parameters_list [list \
		$s_stratixii_m \
		$s_stratixii_3 \
		$s_stratixii_4 \
		$s_stratixii_5 \
		$s_stratixii_6 \
		$s_stratixiii_m \
		$s_stratixiii_2 \
		$s_stratixiii_3 \
		$s_stratixiii_4 \
		$s_stratixiv_m \
		$s_stratixiv_2 \
		$s_stratixiv_3 \
		$s_stratixiv_4 \
		$s_hardcopyii_m \
		$s_hardcopyii_4 \
		$s_cycloneii_m \
		$s_cycloneii_6 \
		$s_cycloneii_7 \
		$s_cycloneii_8 \
		$s_cycloneiii_m \
		$s_cycloneiii_6 \
		$s_cycloneiii_7 \
		$s_cycloneiii_8 \
		]

# Family-specific parameters
set s_stratixii {family {"stratixii"} timing_model {stratix ii} \
		hardcopy_timing_model {hardcopy ii}
		speed_grade_regexp {ep2s[0-9]+[a-z]+[0-9]+[a-z]+([0-9]+)} \
		default_speed_grade {3} \
		density_regexp {ep2s([0-9]+)[a-z]+[0-9]+[a-z]+[0-9]+} \
		default_density {60} \
		temp_grade_regexp {ep2s[0-9]+[a-z]+[0-9]+([a-z]+)[0-9]+} \
		default_temp_grade {c} \
		user_terms {\
		  pll_dc_distortion {(PLL_DCD + fpga_tOUTHALFJITTER)}} \
	    const_terms {\
		  fpga_tMINMAX_VARIATION {0.200 ns}} \
		fpga_tOUTJITTER {0.125 ns} \
		fpga_tPLL_COMP_ERROR {0.100 ns} \
		fpga_tPLL_PSERR {0.030 ns} \
		fpga_tJITTER {0.060 ns} \
		fpga_tJITTER_c_bypass {0.000 ns} \
		fpga_tJITTER_c_delay_chain1 {0.015 ns} \
		fpga_tJITTER_c_delay_chain2 {0.030 ns} \
		fpga_tJITTER_c_delay_chain3 {0.045 ns} \
		fpga_tJITTER_c_delay_chain4 {0.060 ns} \
		fpga_tJITTER_i_bypass {0.000 ns} \
		fpga_tJITTER_i_delay_chain1 {0.015 ns} \
		fpga_tJITTER_i_delay_chain2 {0.030 ns} \
		fpga_tJITTER_i_delay_chain3 {0.045 ns} \
		fpga_tJITTER_i_delay_chain4 {0.060 ns} \
		fpga_tSKEW {0.035 ns} \
		fpga_tSKEW_4 {0.020 ns} \
		fpga_tSKEW_9 {0.035 ns} \
		fpga_tSKEW_18 {0.038 ns} \
		fpga_tSKEW_36 {0.048 ns} \
		fpga_tCLOCK_SKEW_ADDER {0.050 ns} \
		fpga_tCLOCK_SKEW_ADDER_15 {0.050 ns} \
		fpga_tCLOCK_SKEW_ADDER_30 {0.050 ns} \
		fpga_tCLOCK_SKEW_ADDER_60 {0.050 ns} \
		fpga_tCLOCK_SKEW_ADDER_90 {0.055 ns} \
		fpga_tCLOCK_SKEW_ADDER_130 {0.063 ns} \
		fpga_tCLOCK_SKEW_ADDER_180 {0.075 ns} \
		has_hardware_postamble_enable {1} \
		has_hardware_clock_enable_for_postamble {1} \
		is_supported {1}}

set s_hardcopyii {family {"hardcopyii"} \
		timing_model {hardcopy ii} \
		speed_grade_regexp {} \
		default_speed_grade {4} \
		density_regexp {hc2([0-9]+)[a-z]+[0-9]+[a-z]+} \
		default_density {30} \
		temp_grade_regexp {hc2[0-9]+[a-z]+[0-9]+([a-z]+)} \
		default_temp_grade {c} \
		circuit_struct {stratix ii} \
		fpga_tOUTJITTER {0.125 ns} \
		user_terms {\
		  pll_dc_distortion {(PLL_DCD + fpga_tOUTHALFJITTER)} \
		  fpga_tOUTJITTER {fpga_tPLL_ERROR} \
		  fpga_tPLL_COMP_ERROR {0} \
		  fpga_tPLL_PSERR {0} \
		  fpga_tCLOCK_SKEW_ADDER {0}} \
	    const_terms {\
		  fpga_tMINMAX_VARIATION {0.200 ns} \
		  fpga_tCLOCK_SKEW_ADDER {0.000 ns} \
		  fpga_tPLL_COMP_ERROR {0.000 ns} \
		  fpga_tPLL_PSERR {0.000 ns}} \
		fpga_tJITTER {0.060 ns} \
		fpga_tJITTER_c_bypass {0.000 ns} \
		fpga_tJITTER_c_delay_chain1 {0.015 ns} \
		fpga_tJITTER_c_delay_chain2 {0.030 ns} \
		fpga_tJITTER_c_delay_chain3 {0.045 ns} \
		fpga_tJITTER_c_delay_chain4 {0.060 ns} \
		fpga_tJITTER_i_bypass {0.000 ns} \
		fpga_tJITTER_i_delay_chain1 {0.015 ns} \
		fpga_tJITTER_i_delay_chain2 {0.030 ns} \
		fpga_tJITTER_i_delay_chain3 {0.045 ns} \
		fpga_tJITTER_i_delay_chain4 {0.060 ns} \
		fpga_tSKEW {0.035 ns} \
		fpga_tSKEW_4 {0.020 ns} \
		fpga_tSKEW_9 {0.035 ns} \
		fpga_tSKEW_18 {0.038 ns} \
		fpga_tSKEW_36 {0.048 ns} \
		fpga_tCLOCK_SKEW_ADDER {0.050 ns} \
		fpga_tCLOCK_SKEW_ADDER_15 {0.050 ns} \
		fpga_tCLOCK_SKEW_ADDER_30 {0.050 ns} \
		fpga_tCLOCK_SKEW_ADDER_60 {0.050 ns} \
		fpga_tCLOCK_SKEW_ADDER_90 {0.055 ns} \
		fpga_tCLOCK_SKEW_ADDER_130 {0.063 ns} \
		fpga_tCLOCK_SKEW_ADDER_180 {0.075 ns} \
		has_hardware_postamble_enable {1} \
		has_hardware_clock_enable_for_postamble {1} \
		is_supported {1}}

set s_stratixiigx {family {"stratixiigx"} \
		timing_model {stratix ii} \
		speed_grade_regexp {ep2sgx[0-9]+[a-z]+[0-9]+[a-z]+([0-9]+)} \
		default_speed_grade {3} \
		density_regexp {ep2sgx([0-9]+)[a-z]+[0-9]+[a-z]+[0-9]+} \
		default_density {60} \
		temp_grade_regexp {ep2sgx[0-9]+[a-z]+[0-9]+([a-z]+)[0-9]+} \
		default_temp_grade {c} \
		has_hardware_postamble_enable {1} \
		has_hardware_clock_enable_for_postamble {1} \
		user_terms {\
		  pll_dc_distortion {(PLL_DCD + fpga_tOUTHALFJITTER)}} \
		is_supported {1}}

set s_arriagx {family {"arriagx"} \
		timing_model {stratix ii} \
		speed_grade_regexp {ep1agx[0-9]+[a-z]+[0-9]+[a-z]+([0-9]+)} \
		default_speed_grade {6} \
		density_regexp {ep1agx([0-9]+)[a-z]+[0-9]+[a-z]+[0-9]+} \
		default_density {30} \
		temp_grade_regexp {ep1agx[0-9]+[a-z]+[0-9]+([a-z]+)[0-9]+} \
		default_temp_grade {c} \
		has_hardware_postamble_enable {1} \
		has_hardware_clock_enable_for_postamble {1} \
		user_terms {\
		  pll_dc_distortion {(PLL_DCD + fpga_tOUTHALFJITTER)}} \
		is_supported {1}}

set s_stratixiii {family {"stratixiii"} \
		timing_model {stratix iii} \
		circuit_struct {stratix ii} \
		speed_grade_regexp {ep3s[el][0-9]+[a-z]+[0-9]+[a-z]+([0-9]+)} \
		default_speed_grade {2} \
		density_regexp {ep3s([el][0-9]+)[a-z]+[0-9]+[a-z]+[0-9]+} \
		default_density {l200} \
		temp_grade_regexp {ep3s[el][0-9]+[a-z]+[0-9]+([a-z]+)[0-9]+} \
		default_temp_grade {c} \
		user_terms {\
		  fpga_tCLOCK_SKEW_ADDER {0} \
		  fpga_tSKEW {0} \
		  pll_dc_distortion {0}} \
	    const_terms {\
		  fpga_tMINMAX_VARIATION {0 ns} \
		  fpga_tCLOCK_SKEW_ADDER {0 ns} \
		  fpga_tSKEW {0 ns}
		  pll_dc_distortion {0 %}} \
		fpga_tOUTJITTER {0.125 ns} \
		fpga_tPLL_COMP_ERROR {0.100 ns} \
		fpga_tPLL_PSERR {0.030 ns} \
		fpga_tJITTER {0.060 ns} \
		fpga_tJITTER_c_bypass {0.000 ns} \
		fpga_tJITTER_c_delay_chain1 {0.015 ns} \
		fpga_tJITTER_c_delay_chain2 {0.030 ns} \
		fpga_tJITTER_c_delay_chain3 {0.045 ns} \
		fpga_tJITTER_c_delay_chain4 {0.060 ns} \
		fpga_tJITTER_i_bypass {0.000 ns} \
		fpga_tJITTER_i_delay_chain1 {0.015 ns} \
		fpga_tJITTER_i_delay_chain2 {0.030 ns} \
		fpga_tJITTER_i_delay_chain3 {0.045 ns} \
		fpga_tJITTER_i_delay_chain4 {0.060 ns} \
		has_hardware_postamble_enable {1} \
		has_hardware_clock_enable_for_postamble {1} \
		use_timequest_by_default {1} \
		is_supported {1}}

set s_stratixiv {family {"stratixiv"} \
		timing_model {stratix iv} \
		circuit_struct {stratix ii} \
		speed_grade_regexp {ep4s[a-z]+[0-9]+[a-z]+[0-9]+[a-z]+([0-9]+)} \
		default_speed_grade {2} \
		density_regexp {ep4s([a-z]+[0-9]+)[a-z]+[0-9]+[a-z]+[0-9]+} \
		default_density {gx230} \
		temp_grade_regexp {ep4s[a-z]+[0-9]+[a-z]+[0-9]+([a-z]+)[0-9]+} \
		default_temp_grade {c} \
		user_terms {\
		  fpga_tCLOCK_SKEW_ADDER {0} \
		  fpga_tSKEW {0} \
		  pll_dc_distortion {0}} \
	    const_terms {\
		  fpga_tMINMAX_VARIATION {0 ns} \
		  fpga_tCLOCK_SKEW_ADDER {0 ns} \
		  fpga_tSKEW {0 ns}
		  pll_dc_distortion {0 %}} \
		fpga_tOUTJITTER {0.125 ns} \
		fpga_tPLL_COMP_ERROR {0.100 ns} \
		fpga_tPLL_PSERR {0.030 ns} \
		fpga_tJITTER {0.060 ns} \
		fpga_tJITTER_c_bypass {0.000 ns} \
		fpga_tJITTER_c_delay_chain1 {0.015 ns} \
		fpga_tJITTER_c_delay_chain2 {0.030 ns} \
		fpga_tJITTER_c_delay_chain3 {0.045 ns} \
		fpga_tJITTER_c_delay_chain4 {0.060 ns} \
		fpga_tJITTER_i_bypass {0.000 ns} \
		fpga_tJITTER_i_delay_chain1 {0.015 ns} \
		fpga_tJITTER_i_delay_chain2 {0.030 ns} \
		fpga_tJITTER_i_delay_chain3 {0.045 ns} \
		fpga_tJITTER_i_delay_chain4 {0.060 ns} \
		has_hardware_postamble_enable {1} \
		has_hardware_clock_enable_for_postamble {1} \
		use_timequest_by_default {1} \
		is_supported {1}}

set s_cycloneii {family {"cycloneii"} timing_model {cyclone ii} \
		speed_grade_regexp {ep2c[0-9]+[a-z]+[0-9]+[a-z]+([0-9]+)} \
		default_speed_grade {6} \
		density_regexp {ep2c([0-9]+)[a-z]+[0-9]+[a-z]+[0-9]+} \
		default_density {35} \
		temp_grade_regexp {ep2c[0-9]+[a-z]+[0-9]+([a-z]+)[0-9]+} \
		default_temp_grade {c} \
		user_terms {\
		  pll_dc_distortion {tDCD} \
		  fpga_tSHIFT_ERROR {0} \
		  fpga_tJITTER {0} \
		  fpga_tSKEW {fpga_tDQS_SKEW_ADDER}} \
	    const_terms {\
		  fpga_tMINMAX_VARIATION {0.200 ns} \
		  fpga_tSHIFT_ERROR {0 ns} \
		  fpga_tJITTER {0 ns}} \
		pll_dc_distortion {5 %} \
		fpga_tOUTJITTER {0.125 ns} \
		fpga_tPLL_COMP_ERROR {0.100 ns} \
		fpga_tPLL_PSERR {0.030 ns} \
		fpga_tCLOCK_SKEW_ADDER {0.050 ns} \
		fpga_tSKEW {0.055 ns} \
		has_dqs_mode {1} \
		has_non_dqs_mode {0} \
		has_hardware_clock_enable_for_postamble {0} \
		is_supported {1}}

set s_cycloneiii {family {"cycloneiii"} \
		timing_model {cyclone iii} \
		circuit_struct {cyclone ii} \
		speed_grade_regexp {ep3c[0-9]+[a-z]+[0-9]+[a-z]+([0-9]+)} \
		default_speed_grade {6} \
		density_regexp {ep3c([0-9]+)[a-z]+[0-9]+[a-z]+[0-9]+} \
		default_density {40} \
		temp_grade_regexp {ep3c[0-9]+[a-z]+[0-9]+([a-z]+)[0-9]+} \
		default_temp_grade {c} \
		user_terms {\
		  fpga_tCLOCK_SKEW_ADDER {0} \
		  pll_dc_distortion {0} \
		  fpga_tSHIFT_ERROR {0} \
		  fpga_tJITTER {0} \
		  fpga_tSKEW {0}} \
	    const_terms {\
		  fpga_tMINMAX_VARIATION {0 ns} \
		  fpga_tCLOCK_SKEW_ADDER {0 ns} \
		  fpga_tSHIFT_ERROR {0 ns} \
		  fpga_tJITTER {0 ns} \
		  fpga_tSKEW {0 ns}
		  pll_dc_distortion {0 %}} \
		fpga_tOUTJITTER {0.125 ns} \
		fpga_tPLL_COMP_ERROR {0.100 ns} \
		fpga_tPLL_PSERR {0.030 ns} \
		has_dqs_mode {1} \
		has_non_dqs_mode {0} \
		has_hardware_clock_enable_for_postamble {0} \
		use_timequest_by_default {1} \
		is_supported {1}}

set s_default_family {family {"_default"} \
		has_dqs_mode {1} \
		has_non_dqs_mode {1} \
		has_hardware_postamble_enable {0} \
		has_hardware_clock_enable_for_postamble {0} \
		dqs_2_pll_mode_misc_parameters {\
		  sys_clk_max_tco \
		  sys_clk_slow_min_tco \
		  sys_clk_fast_max_tco \
 		  sys_clk_min_tco \
		  fb_clk_max_tco \
		  fb_clk_slow_min_tco \
		  fb_clk_fast_max_tco \
		  fb_clk_min_tco \
		  pll_dc_distortion \
		  fpga_tOUTJITTER \
		  fpga_tPLL_COMP_ERROR \
		  fpga_tPLL_PSERR \
		  fpga_tCK_ADDR_CTRL_SETUP_ERROR \
		  fpga_tCK_ADDR_CTRL_HOLD_ERROR \
		  fpga_tCK_WRDQS_SETUP_ERROR \
		  fpga_tCK_WRDQS_HOLD_ERROR \
		  fpga_tD_WRDQS_SETUP_ERROR \
		  fpga_tD_WRDQS_HOLD_ERROR \
		  fpga_tREAD_CAPTURE_SETUP_ERROR \
		  fpga_tREAD_CAPTURE_HOLD_ERROR \
		  fpga_tRDDQS_FBPLL_SETUP_ERROR \
		  fpga_tRDDQS_FBPLL_HOLD_ERROR \
		  fpga_tFBPLL_SYSPLL_SETUP_ERROR \
		  fpga_tFBPLL_SYSPLL_HOLD_ERROR \
		  fpga_tCLOCK_SKEW_ADDER \
		  fpga_tSHIFT_ERROR \
		  fpga_tJITTER  \
		  fpga_tSKEW} \
		dqs_1_pll_mode_misc_parameters {\
		  sys_clk_max_tco \
		  sys_clk_slow_min_tco \
		  sys_clk_fast_max_tco \
 		  sys_clk_min_tco \
		  pll_dc_distortion \
		  fpga_tOUTJITTER \
		  fpga_tPLL_PSERR \
		  fpga_tCK_ADDR_CTRL_SETUP_ERROR \
		  fpga_tCK_ADDR_CTRL_HOLD_ERROR \
		  fpga_tCK_WRDQS_SETUP_ERROR \
		  fpga_tCK_WRDQS_HOLD_ERROR \
		  fpga_tD_WRDQS_SETUP_ERROR \
		  fpga_tD_WRDQS_HOLD_ERROR \
		  fpga_tREAD_CAPTURE_SETUP_ERROR \
		  fpga_tREAD_CAPTURE_HOLD_ERROR \
		  fpga_tRDDQS_SYSPLL_SETUP_ERROR \
		  fpga_tRDDQS_SYSPLL_HOLD_ERROR \
		  fpga_tCLOCK_SKEW_ADDER \
		  fpga_tSHIFT_ERROR \
		  fpga_tJITTER \
		  fpga_tSKEW} \
		non_dqs_2_pll_mode_misc_parameters {\
		  sys_clk_max_tco \
		  sys_clk_slow_min_tco \
		  sys_clk_fast_max_tco \
 		  sys_clk_min_tco \
		  fb_clk_max_tco \
		  fb_clk_slow_min_tco \
		  fb_clk_fast_max_tco \
		  fb_clk_min_tco \
		  pll_dc_distortion \
		  fpga_tOUTJITTER \
		  fpga_tPLL_COMP_ERROR \
		  fpga_tPLL_PSERR \
		  fpga_tCK_ADDR_CTRL_SETUP_ERROR \
		  fpga_tCK_ADDR_CTRL_HOLD_ERROR \
		  fpga_tCK_WRDQS_SETUP_ERROR \
		  fpga_tCK_WRDQS_HOLD_ERROR \
		  fpga_tD_WRDQS_SETUP_ERROR \
		  fpga_tD_WRDQS_HOLD_ERROR \
		  fpga_tQ_FBPLL_SETUP_ERROR \
		  fpga_tQ_FBPLL_HOLD_ERROR \
		  fpga_tFBPLL_SYSPLL_SETUP_ERROR \
		  fpga_tFBPLL_SYSPLL_HOLD_ERROR \
		  fpga_tCLOCK_SKEW_ADDER} \
		non_dqs_1_pll_mode_misc_parameters {\
		  sys_clk_max_tco \
		  sys_clk_slow_min_tco \
		  sys_clk_fast_max_tco \
		  sys_clk_min_tco \
		  pll_dc_distortion \
		  fpga_tOUTJITTER \
		  fpga_tPLL_PSERR \
		  fpga_tCK_ADDR_CTRL_SETUP_ERROR \
		  fpga_tCK_ADDR_CTRL_HOLD_ERROR \
		  fpga_tCK_WRDQS_SETUP_ERROR \
		  fpga_tCK_WRDQS_HOLD_ERROR \
		  fpga_tD_WRDQS_SETUP_ERROR \
		  fpga_tD_WRDQS_HOLD_ERROR \
		  fpga_tQ_SYSPLL_SETUP_ERROR \
		  fpga_tQ_SYSPLL_HOLD_ERROR \
		  fpga_tCLOCK_SKEW_ADDER} \
		dqs_dcfifo_mode_misc_parameters {\
		  pll_dc_distortion \
		  fpga_tOUTJITTER \
		  fpga_tPLL_PSERR \
		  fpga_tCK_ADDR_CTRL_SETUP_ERROR \
		  fpga_tCK_ADDR_CTRL_HOLD_ERROR \
		  fpga_tD_WRDQS_SETUP_ERROR \
		  fpga_tD_WRDQS_HOLD_ERROR \
		  fpga_tREAD_CAPTURE_SETUP_ERROR \
		  fpga_tREAD_CAPTURE_HOLD_ERROR \
		  fpga_tCLOCK_SKEW_ADDER \
		  fpga_tSHIFT_ERROR \
		  fpga_tJITTER \
		  fpga_tSKEW \
		  fpga_tMINMAX_VARIATION} \
		sspll_mode_misc_parameters {\
		  sys_clk_max_tco \
		  sys_clk_slow_min_tco \
		  sys_clk_fast_max_tco \
		  sys_clk_min_tco \
		  pll_dc_distortion \
		  fpga_tOUTJITTER \
		  fpga_tPLL_COMP_ERROR \
		  fpga_tPLL_PSERR \
		  fpga_tCK_ADDR_CTRL_SETUP_ERROR \
		  fpga_tCK_ADDR_CTRL_HOLD_ERROR \
		  fpga_tD_WRDQS_SETUP_ERROR \
		  fpga_tD_WRDQS_HOLD_ERROR \
		  fpga_tQ_FBPLL_SETUP_ERROR \
		  fpga_tQ_FBPLL_HOLD_ERROR \
		  fpga_tFBPLL_SYSPLL_SETUP_ERROR \
		  fpga_tFBPLL_SYSPLL_HOLD_ERROR \
		  fpga_tCLOCK_SKEW_ADDER} \
		sspll_dcfifo_mode_misc_parameters {\
		  pll_dc_distortion \
		  fpga_tOUTJITTER \
		  fpga_tPLL_COMP_ERROR \
		  fpga_tPLL_PSERR \
		  fpga_tCK_ADDR_CTRL_SETUP_ERROR \
		  fpga_tCK_ADDR_CTRL_HOLD_ERROR \
		  fpga_tD_WRDQS_SETUP_ERROR \
		  fpga_tD_WRDQS_HOLD_ERROR \
		  fpga_tQ_FBPLL_SETUP_ERROR \
		  fpga_tQ_FBPLL_HOLD_ERROR \
		  fpga_tCLOCK_SKEW_ADDER} \
		non_dqs_dcfifo_mode_misc_parameters {\
		  pll_dc_distortion \
		  fpga_tOUTJITTER \
		  fpga_tPLL_PSERR \
		  fpga_tCK_ADDR_CTRL_SETUP_ERROR \
		  fpga_tCK_ADDR_CTRL_HOLD_ERROR \
		  fpga_tD_WRDQS_SETUP_ERROR \
		  fpga_tD_WRDQS_HOLD_ERROR \
		  fpga_tCLOCK_SKEW_ADDER} \
		user_terms {\
		  sys_clk_max_tco {slow_max_tco(sys_clk)} \
		  sys_clk_slow_min_tco {slow_min_tco(sys_clk)} \
 		  sys_clk_fast_max_tco {fast_max_tco(sys_clk)} \
 		  sys_clk_min_tco {fast_min_tco(sys_clk)} \
		  fb_clk_max_tco {slow_max_tco(fb_clk)} \
		  fb_clk_slow_min_tco {slow_min_tco(fb_clk)} \
		  fb_clk_fast_max_tco {fast_max_tco(fb_clk)} \
		  fb_clk_min_tco {fast_min_tco(fb_clk)} \
		  pll_dc_distortion {PLL_DCD} \
		  fpga_tOUTJITTER {fpga_tPLL_JITTER} \
		  fpga_tPLL_COMP_ERROR {fpga_tPLL_COMP_ERROR} \
		  fpga_tPLL_PSERR {fpga_tPLL_PSERR} \
		  fpga_tCK_ADDR_CTRL_SETUP_ERROR {fpga_tCK_ADDR_CTRL_SETUP_ERROR} \
		  fpga_tCK_ADDR_CTRL_HOLD_ERROR {fpga_tCK_ADDR_CTRL_HOLD_ERROR} \
		  fpga_tCK_WRDQS_SETUP_ERROR {fpga_tCK_WRDQS_SETUP_ERROR} \
		  fpga_tCK_WRDQS_HOLD_ERROR {fpga_tCK_WRDQS_HOLD_ERROR} \
		  fpga_tD_WRDQS_SETUP_ERROR {fpga_tD_WRDQS_SETUP_ERROR} \
		  fpga_tD_WRDQS_HOLD_ERROR {fpga_tD_WRDQS_HOLD_ERROR} \
		  fpga_tREAD_CAPTURE_SETUP_ERROR {fpga_tREAD_CAPTURE_SETUP_ERROR} \
		  fpga_tREAD_CAPTURE_HOLD_ERROR {fpga_tREAD_CAPTURE_HOLD_ERROR} \
		  fpga_tRDDQS_FBPLL_SETUP_ERROR {fpga_tRDDQS_FBPLL_SETUP_ERROR} \
		  fpga_tRDDQS_FBPLL_HOLD_ERROR {fpga_tRDDQS_FBPLL_HOLD_ERROR} \
		  fpga_tFBPLL_SYSPLL_SETUP_ERROR {fpga_tFBPLL_SYSPLL_SETUP_ERROR} \
		  fpga_tFBPLL_SYSPLL_HOLD_ERROR {fpga_tFBPLL_SYSPLL_HOLD_ERROR} \
		  fpga_tRDDQS_SYSPLL_SETUP_ERROR {fpga_tRDDQS_SYSPLL_SETUP_ERROR} \
		  fpga_tRDDQS_SYSPLL_HOLD_ERROR {fpga_tRDDQS_SYSPLL_HOLD_ERROR} \
		  fpga_tQ_FBPLL_SETUP_ERROR {fpga_tQ_FBPLL_SETUP_ERROR} \
		  fpga_tQ_FBPLL_HOLD_ERROR {fpga_tQ_FBPLL_HOLD_ERROR} \
		  fpga_tQ_SYSPLL_SETUP_ERROR {fpga_tQ_SYSPLL_SETUP_ERROR} \
		  fpga_tQ_SYSPLL_HOLD_ERROR {fpga_tQ_SYSPLL_HOLD_ERROR} \
		  fpga_tCLOCK_SKEW_ADDER {fpga_tCLOCK_SKEW_ADDER} \
		  fpga_tSHIFT_ERROR {fpga_tDQS_PSERR} \
		  fpga_tJITTER {fpga_tDQS_PHASE_JITTER} \
		  fpga_tSKEW {fpga_tDQS_CLOCK_SKEW_ADDER} \
		  fpga_tMINMAX_VARIATION {fpga_tMINMAX_VARIATION}} \
		ddr_user_terms {\
		  tCK_var {mem_tCK} \
		  inverted_capture 1 \
		  has_read_postamble 1 \
		  has_common_dataio 1 \
		  has_free_running_read_clock 0 \
		  remove_dqs_cut_ip_asg 1 \
		  remove_pre_flow_script_file {auto_add_ddr_constraints.tcl} \
		  remove_post_flow_script_file {auto_verify_ddr_timing.tcl} \
		  ck "CK" \
		  ckn "CK#" \
		  ck_ckn "CK/CK#" \
		  read_dqs "DQS" \
		  read_dqsn {} \
		  read_dq "DQ" \
		  write_dqs "DQS" \
		  write_dqsn {} \
		  write_dq "DQ" \
		  write_mask "DM"} \
		qdr2_user_terms {\
		  tCK_var {q2_tKHKH} \
		  inverted_capture 0 \
		  has_read_postamble 0 \
		  has_common_dataio 0 \
		  has_free_running_read_clock 1 \
		  remove_dqs_cut_ip_asg 0 \
		  remove_pre_flow_script_file {auto_add_qdrii_constraints.tcl} \
		  ck "K" \
		  ckn "K#" \
		  ck_ckn "K/K#" \
		  read_dqs "CQ" \
		  read_dqsn "CQ#" \
		  read_dq "Q" \
		  write_dqs "K" \
		  write_dqsn "K#" \
		  write_dq "D" \
		  write_mask "BWSN"} \
		rldram2_user_terms {\
		  tCK_var {rl2_tCK} \
		  inverted_capture 1 \
		  has_common_dataio 1 \
		  has_read_postamble 0 \
		  has_free_running_read_clock 1 \
		  remove_dqs_cut_ip_asg 0 \
		  remove_pre_flow_script_file {auto_add_rldramii_constraints.tcl} \
		  ck "CK" \
		  ckn "CK#" \
		  ck_ckn "CK/CK#" \
		  read_dqs "QK" \
		  read_dqsn {} \
		  read_dq "DQ" \
		  write_dqs "DK" \
		  write_dqsn "DK#" \
		  write_dq "DQ" \
		  write_mask "DM"} \
		ddr_terms {\
		  mem_CL {CL} \
		  mem_tCK {tCK} \
		  mem_tAC {tAC} \
		  mem_tDQSCK {tDQSCK} \
		  mem_tDH {tDH} \
		  mem_tDS {tDS} \
		  mem_tDQSQ {tDQSQ} \
		  mem_min_tDQSS {min_tDQSS} \
		  mem_max_tDQSS {max_tDQSS} \
		  mem_tQHS {tQHS} \
		  mem_tIH {tIH} \
		  mem_tIS {tIS} \
		  mem_tHP {tHP} \
		  mem_tRPST {tRPST}} \
		qdr2_terms {\
		  q2_tKHKH {tKHKH} \
		  q2_tKHKnH {tKHKnH} \
		  q2_tCHQV {tCHQV} \
		  q2_tCHQX {tCHQX} \
		  q2_tCHCQV {tCHCQV} \
		  q2_tCHCQX {tCHCQX} \
		  q2_tCQHQV {tCQHQV} \
		  q2_tCQHQX {tCQHQX} \
		  q2_tSA {tSA} \
		  q2_tSC {tSC} \
		  q2_tSD {tSD} \
		  q2_tHA {tHA} \
		  q2_tHC {tHC} \
		  q2_tHD {tHD}} \
		rldram2_terms {\
		  rl2_is_cio {CIO} \
		  rl2_tRL {tRL} \
		  rl2_tCK {tCK} \
		  rl2_tQKH {tQKH} \
		  rl2_tCKQK {tCKQK} \
		  rl2_tQKQ0_tQKQ1 {tQKQ0_tQKQ1} \
		  rl2_tQKQ {tQKQ} \
		  rl2_tAS {tAS} \
		  rl2_tAH {tAH} \
		  rl2_tCS {tCS} \
		  rl2_tCH {tCH} \
		  rl2_tDS {tDS} \
		  rl2_tDH {tDH}} \
		board_terms {\
		  board_mem_2_fpga {nominal_tpd(memory_to_FPGA)} \
		  board_fpga_2_mem {nominal_tpd(FPGA_to_memory)} \
		  board_feedback {nominal_tpd(feedback_trace)} \
		  board_tolerance {board_tolerance} \
		  board_skew {board_skew} \
		  board_addr_ctrl_skew {board_addr_ctrl_skew} \
		  board_dqs_ck_skew {board_dqs_ck_skew}} \
		clock_terms {\
		  pll_input_freq {pll_input_freq} \
		  resync_cycle {resync_cycle} \
		  resync_phase {resync_phase} \
		  resync_sys_cycle {resync_sys_cycle} \
		  resync_sys_phase {resync_sys_phase} \
		  postamble_cycle {postamble_cycle} \
		  postamble_phase {postamble_phase} \
		  inter_postamble_cycle {postamble_sys_cycle} \
		  inter_postamble_phase {postamble_sys_phase}} \
		  \
		ddr_ck_output_max_delay_equation {mem_tCK - sys_clk_max_tco} \
		qdr2_ck_output_max_delay_equation {q2_tKHKH - sys_clk_max_tco} \
		rldram2_ck_output_max_delay_equation {rl2_tCK - sys_clk_max_tco} \
		ck_output_min_delay_equation {-sys_clk_min_tco} \
		\
		fb_output_max_delay_equation {mem_tCK - fb_clk_max_tco} \
		fb_output_min_delay_equation {-fb_clk_min_tco} \
		\
		ddr_max_addr_ctrl_output_skew_equation {(mem_tCK - mem_tIS - mem_tIH - 2 * board_addr_ctrl_skew - fpga_tCK_ADDR_CTRL_SETUP_ERROR - fpga_tCK_ADDR_CTRL_HOLD_ERROR)/2} \
		qdr2_max_addr_output_skew_equation {(q2_tKHKH - q2_tSA - q2_tHA - 2 * board_addr_ctrl_skew - fpga_tCK_ADDR_CTRL_SETUP_ERROR - fpga_tCK_ADDR_CTRL_HOLD_ERROR)/2} \
		qdr2_max_ctrl_output_skew_equation {(q2_tKHKH - q2_tSC - q2_tHC - 2 * board_addr_ctrl_skew - fpga_tCK_ADDR_CTRL_SETUP_ERROR - fpga_tCK_ADDR_CTRL_HOLD_ERROR)/2} \
		rldram2_max_addr_output_skew_equation {(rl2_tCK - rl2_tAS - rl2_tAH - 2 * board_addr_ctrl_skew - fpga_tCK_ADDR_CTRL_SETUP_ERROR - fpga_tCK_ADDR_CTRL_HOLD_ERROR)/2} \
		rldram2_max_ctrl_output_skew_equation {(rl2_tCK - rl2_tCS - rl2_tCH - 2 * board_addr_ctrl_skew - fpga_tCK_ADDR_CTRL_SETUP_ERROR - fpga_tCK_ADDR_CTRL_HOLD_ERROR)/2} \
		\
		same_outclk_min_tco_difference_adder_equation { + pll_dc_distortion} \
		same_outclk_max_tco_difference_adder_equation { - pll_dc_distortion} \
		diff_outclk_min_tco_difference_adder_equation {} \
		diff_outclk_max_tco_difference_adder_equation {} \
		ddr_min_ck_addr_ctrl_tco_difference_equation {fpga_tCK_ADDR_CTRL_SETUP_ERROR + mem_tIS + board_addr_ctrl_skew} \
		ddr_max_ck_addr_ctrl_tco_difference_equation {-fpga_tCK_ADDR_CTRL_HOLD_ERROR - mem_tIH - board_addr_ctrl_skew} \
		qdr2_min_ck_addr_tco_difference_equation {fpga_tCK_ADDR_CTRL_SETUP_ERROR + q2_tSA + board_addr_ctrl_skew} \
		qdr2_max_ck_addr_tco_difference_equation {-fpga_tCK_ADDR_CTRL_HOLD_ERROR - q2_tHA - board_addr_ctrl_skew} \
		qdr2_min_ck_ctrl_tco_difference_equation {fpga_tCK_ADDR_CTRL_SETUP_ERROR + q2_tSC + board_addr_ctrl_skew} \
		qdr2_max_ck_ctrl_tco_difference_equation {-fpga_tCK_ADDR_CTRL_HOLD_ERROR - q2_tHC - board_addr_ctrl_skew} \
		rldram2_min_ck_addr_tco_difference_equation {fpga_tCK_ADDR_CTRL_SETUP_ERROR + rl2_tAS + board_addr_ctrl_skew} \
		rldram2_max_ck_addr_tco_difference_equation {-fpga_tCK_ADDR_CTRL_HOLD_ERROR - rl2_tAH - board_addr_ctrl_skew} \
		rldram2_min_ck_ctrl_tco_difference_equation {fpga_tCK_ADDR_CTRL_SETUP_ERROR + rl2_tCS + board_addr_ctrl_skew} \
		rldram2_max_ck_ctrl_tco_difference_equation {-fpga_tCK_ADDR_CTRL_HOLD_ERROR - rl2_tCH - board_addr_ctrl_skew} \
		\
		ddr_max_dqs_ck_output_skew_equation {((mem_tCK - mem_min_tDQSS < mem_max_tDQSS - mem_tCK) ? mem_tCK - mem_min_tDQSS : mem_max_tDQSS - mem_tCK) - board_dqs_ck_skew - abs(board_mem_2_fpga - board_fpga_2_mem) - fpga_tCK_WRDQS_SETUP_ERROR - fpga_tCK_WRDQS_HOLD_ERROR} \
		ddr2_max_dqs_ck_output_skew_equation {((-mem_min_tDQSS < mem_max_tDQSS) ? -mem_min_tDQSS : mem_max_tDQSS) - board_dqs_ck_skew - abs(board_mem_2_fpga - board_fpga_2_mem) - fpga_tCK_WRDQS_SETUP_ERROR - fpga_tCK_WRDQS_HOLD_ERROR} \
		ddr_dqs_ck_same_clk_output_min_delay_equation {mem_max_tDQSS - mem_tCK - fpga_tCK_WRDQS_SETUP_ERROR - board_dqs_ck_skew + (board_mem_2_fpga - board_fpga_2_mem)} \
		ddr_dqs_ck_diff_clk_output_min_delay_equation {-mem_tCK + mem_max_tDQSS - mem_tCK - fpga_tCK_WRDQS_SETUP_ERROR - board_dqs_ck_skew + (board_mem_2_fpga - board_fpga_2_mem)} \
		ddr_dqs_ck_same_clk_output_max_delay_equation {mem_tCK + mem_min_tDQSS - mem_tCK + fpga_tCK_WRDQS_HOLD_ERROR + board_dqs_ck_skew + (board_mem_2_fpga - board_fpga_2_mem)} \
		ddr_dqs_ck_diff_clk_output_max_delay_equation {mem_min_tDQSS - mem_tCK + fpga_tCK_WRDQS_HOLD_ERROR + board_dqs_ck_skew + (board_mem_2_fpga - board_fpga_2_mem)} \
		ddr2_dqs_ck_same_clk_output_min_delay_equation {mem_max_tDQSS - fpga_tCK_WRDQS_SETUP_ERROR - board_dqs_ck_skew + (board_mem_2_fpga - board_fpga_2_mem)} \
		ddr2_dqs_ck_diff_clk_output_min_delay_equation {-mem_tCK + mem_max_tDQSS - fpga_tCK_WRDQS_SETUP_ERROR - board_dqs_ck_skew + (board_mem_2_fpga - board_fpga_2_mem)} \
		ddr2_dqs_ck_same_clk_output_max_delay_equation {mem_tCK + mem_min_tDQSS + fpga_tCK_WRDQS_HOLD_ERROR + board_dqs_ck_skew + (board_mem_2_fpga - board_fpga_2_mem)} \
		ddr2_dqs_ck_diff_clk_output_max_delay_equation {mem_min_tDQSS + fpga_tCK_WRDQS_HOLD_ERROR + board_dqs_ck_skew + (board_mem_2_fpga - board_fpga_2_mem)} \
		\
		ddr_max_dq_dqs_output_skew_equation {(mem_tCK/2 - pll_dc_distortion - mem_tDS - mem_tDH - fpga_tD_WRDQS_SETUP_ERROR - fpga_tD_WRDQS_HOLD_ERROR - 2 * board_skew)/2} \
		qdr2_max_dq_dqs_output_skew_equation {(q2_tKHKH/2 - pll_dc_distortion - q2_tSD - q2_tHD - fpga_tD_WRDQS_SETUP_ERROR - fpga_tD_WRDQS_HOLD_ERROR - 2 * board_skew)/2} \
		rldram2_max_dq_dqs_output_skew_equation {(rl2_tCK/2 - pll_dc_distortion - rl2_tDS - rl2_tDH - fpga_tD_WRDQS_SETUP_ERROR - fpga_tD_WRDQS_HOLD_ERROR - 2 * board_skew)/2} \
		ddr_min_dqs_dq_tco_difference_equation {mem_tDS + board_skew + fpga_tD_WRDQS_SETUP_ERROR}
		ddr_max_dqs_dq_tco_difference_equation {-pll_dc_distortion - mem_tDH - board_skew - fpga_tD_WRDQS_HOLD_ERROR} \
		qdr2_min_dqs_dq_tco_difference_equation {q2_tSD + board_skew + fpga_tD_WRDQS_SETUP_ERROR} \
		qdr2_max_dqs_dq_tco_difference_equation {-pll_dc_distortion - q2_tHD - board_skew - fpga_tD_WRDQS_HOLD_ERROR} \
		rldram2_min_dqs_dq_tco_difference_equation {rl2_tDS + board_skew + fpga_tD_WRDQS_SETUP_ERROR} \
		rldram2_max_dqs_dq_tco_difference_equation {-pll_dc_distortion - rl2_tDH - board_skew - fpga_tD_WRDQS_HOLD_ERROR} \
		\
		qdr2_dqsn_dqs_setup_relationship_equation {q2_tKHKnH} \
		qdr2_dqsn_dqs_hold_relationship_equation {-q2_tKHKnH} \
		\
		ddr_dq_input_max_delay_equation {mem_tDQSQ + board_skew + fpga_tSKEW + fpga_tJITTER + fpga_tSHIFT_ERROR + fpga_tREAD_CAPTURE_SETUP_ERROR} \
		qdr2_dq_input_max_delay_equation {q2_tCQHQV + board_skew + fpga_tSKEW + fpga_tJITTER + fpga_tSHIFT_ERROR + fpga_tREAD_CAPTURE_SETUP_ERROR} \
		rldram2_dq_input_max_delay_equation {rl2_tQKQ0_tQKQ1 + board_skew + fpga_tSKEW + fpga_tJITTER + fpga_tSHIFT_ERROR + fpga_tREAD_CAPTURE_SETUP_ERROR} \
		ddr_dq_input_min_delay_equation {-mem_tQHS - board_skew - fpga_tSKEW - fpga_tJITTER - fpga_tSHIFT_ERROR - fpga_tREAD_CAPTURE_HOLD_ERROR} \
		qdr2_dq_input_min_delay_equation {q2_tCQHQX - board_skew - fpga_tSKEW - fpga_tJITTER - fpga_tSHIFT_ERROR - fpga_tREAD_CAPTURE_HOLD_ERROR} \
		rldram2_dq_input_min_delay_equation {-rl2_tQKQ0_tQKQ1 - board_skew - fpga_tSKEW - fpga_tJITTER - fpga_tSHIFT_ERROR - fpga_tREAD_CAPTURE_HOLD_ERROR} \
		\
		qdr2_dq_input_to_sspll_max_delay_equation {q2_tCQHQV + board_skew + fpga_tQ_FBPLL_SETUP_ERROR} \
		qdr2_dq_input_to_sspll_min_delay_equation {q2_tCQHQX - board_skew - fpga_tQ_FBPLL_HOLD_ERROR} \
		rldram2_dq_input_to_sspll_max_delay_equation {rl2_tQKQ + board_skew + fpga_tQ_FBPLL_SETUP_ERROR} \
		rldram2_dq_input_to_sspll_min_delay_equation {-rl2_tQKQ - board_skew - fpga_tQ_FBPLL_HOLD_ERROR} \
		\
		ddr_dqs_clock_latency_2_pll_equation {(sys_clk_max_tco + sys_clk_min_tco)/2 + board_mem_2_fpga + board_fpga_2_mem + mem_CL * mem_tCK} \
		ddr_dqs_clock_latency_2_pll_with_postamble_equation {(sys_clk_max_tco + sys_clk_min_tco)/2 + board_mem_2_fpga + board_fpga_2_mem + (mem_CL - (3 + postamble_cycle) - floor(postamble_phase/360.0 - 0.5) + fedback_cycle_latency_offset) * mem_tCK} \
		\
		fedback_cycle_latency_offset_equation {postamble_cycle - inter_postamble_cycle - 1 - int(floor(inter_postamble_phase/360.0 - postamble_phase/360.0))} \
		fedback_clock_latency_2_pll_equation {(fb_clk_max_tco + fb_clk_min_tco)/2 + board_feedback + fedback_cycle_latency_offset * mem_tCK} \
		\
		ddr_dqs_clock_latency_1_pll_equation {(sys_clk_max_tco + sys_clk_min_tco)/2 + board_mem_2_fpga + board_fpga_2_mem + (mem_CL - 3.0) * mem_tCK} \
		\
		qdr2_dqs_early_clock_latency_equation {sys_clk_min_tco + (board_mem_2_fpga + board_fpga_2_mem) * (1 - board_tolerance) + q2_tCHCQX} \
		qdr2_dqs_late_clock_latency_equation {sys_clk_max_tco + (board_mem_2_fpga + board_fpga_2_mem) * (1 + board_tolerance) + q2_tCHCQV} \
		\
		rldram2_dqs_early_clock_latency_equation {sys_clk_min_tco + (board_mem_2_fpga + board_fpga_2_mem) * (1 - board_tolerance) - rl2_tCKQK + rl2_tRL * rl2_tCK} \
		rldram2_dqs_late_clock_latency_equation {sys_clk_max_tco + (board_mem_2_fpga + board_fpga_2_mem) * (1 + board_tolerance) + rl2_tCKQK + rl2_tRL * rl2_tCK} \
		\
		ddr_dqs_clock_latency_1_pll_with_postamble_equation {(sys_clk_max_tco + sys_clk_min_tco)/2 + board_mem_2_fpga + board_fpga_2_mem + (mem_CL - 3.0 - postamble_cycle - floor(postamble_phase/360.0 - 0.5)) * mem_tCK} \
		\
		dqs_to_2_pll_resync_setup_uncertainty_equation {sys_clk_max_tco_diff/2 + fb_clk_max_tco_diff/2 + board_mem_2_fpga * board_tolerance + board_fpga_2_mem * board_tolerance + fpga_tJITTER + fpga_tSHIFT_ERROR + fpga_tSKEW + mem_tDQSCK + fpga_tRDDQS_FBPLL_SETUP_ERROR + pll_dc_distortion} \
		dqs_to_2_pll_resync_hold_uncertainty_equation {sys_clk_max_tco_diff/2 + fb_clk_max_tco_diff/2 + board_mem_2_fpga * board_tolerance + board_fpga_2_mem * board_tolerance + fpga_tJITTER + fpga_tSHIFT_ERROR + fpga_tSKEW + mem_tDQSCK + fpga_tRDDQS_FBPLL_HOLD_ERROR + pll_dc_distortion} \
		dqs_resync1_to_resync2_2_pll_setup_uncertainty_equation {abs(fb_clk_max_tco - fb_clk_min_tco) / 2 + board_feedback * board_tolerance + fpga_tFBPLL_SYSPLL_SETUP_ERROR} \
		dqs_resync1_to_resync2_2_pll_hold_uncertainty_equation {abs(fb_clk_max_tco - fb_clk_min_tco) / 2 + board_feedback * board_tolerance + fpga_tFBPLL_SYSPLL_HOLD_ERROR} \
		ddr_dqs_to_1_pll_resync_setup_uncertainty_equation {abs(sys_clk_max_tco - sys_clk_min_tco) / 2 + board_mem_2_fpga * board_tolerance + board_fpga_2_mem * board_tolerance + fpga_tJITTER + fpga_tSHIFT_ERROR + fpga_tSKEW + mem_tDQSCK + fpga_tRDDQS_SYSPLL_SETUP_ERROR + pll_dc_distortion} \
		ddr_dqs_to_1_pll_resync_hold_uncertainty_equation {abs(sys_clk_max_tco - sys_clk_min_tco) / 2 + board_mem_2_fpga * board_tolerance + board_fpga_2_mem * board_tolerance + fpga_tJITTER + fpga_tSHIFT_ERROR + fpga_tSKEW + mem_tDQSCK + fpga_tRDDQS_SYSPLL_HOLD_ERROR + pll_dc_distortion} \
		\
		sspll_to_sys_pll_resync_setup_uncertainty_equation {fpga_tFBPLL_SYSPLL_SETUP_ERROR} \
		sspll_to_sys_pll_resync_hold_uncertainty_equation {fpga_tFBPLL_SYSPLL_HOLD_ERROR} \
		qdr2_dqs_to_1_pll_resync_setup_uncertainty_equation {fpga_tJITTER + fpga_tSHIFT_ERROR + fpga_tSKEW + fpga_tRDDQS_SYSPLL_SETUP_ERROR} \
		qdr2_dqs_to_1_pll_resync_hold_uncertainty_equation {fpga_tJITTER + fpga_tSHIFT_ERROR + fpga_tSKEW + fpga_tRDDQS_SYSPLL_HOLD_ERROR} \
		rldram2_dqs_to_1_pll_resync_setup_uncertainty_equation {fpga_tJITTER + fpga_tSHIFT_ERROR + fpga_tSKEW + fpga_tRDDQS_SYSPLL_SETUP_ERROR} \
		rldram2_dqs_to_1_pll_resync_hold_uncertainty_equation {fpga_tJITTER + fpga_tSHIFT_ERROR + fpga_tSKEW + fpga_tRDDQS_SYSPLL_HOLD_ERROR} \
		\
		rldram2_dqs_to_dqs_uncertainty_equation {board_skew + sqrt(2 * (rl2_tCKQK * rl2_tCKQK))} \
		rldram2_same_dqs_to_dqs_setup_uncertainty_equation {0.1 * rl2_tCK + fpga_tMINMAX_VARIATION + fpga_tJITTER + fpga_tSHIFT_ERROR} \
		rldram2_same_dqs_to_dqs_hold_uncertainty_equation {fpga_tMINMAX_VARIATION + fpga_tJITTER + fpga_tSHIFT_ERROR} \
		\
		dqs_1_pll_resync_multicycle_equation {resync_cycle - int(floor(0.5 - resync_phase/360.0))} \
		dqs_1_pll_resync_with_postamble_multicycle_equation {resync_cycle - int(floor(0.5 - resync_phase/360.0)) - postamble_cycle - int(floor(postamble_phase/360.0 - 0.5))} \
		dqs_2_pll_resync_multicycle_equation {3 + resync_cycle - int(floor(0.5 - resync_phase/360.0))} \
		dqs_2_pll_resync_with_postamble_multicycle_equation {resync_cycle - int(floor(0.5 - resync_phase/360.0)) - postamble_cycle - int(floor(postamble_phase/360.0 - 0.5))} \
		dqs_2_pll_resync2_multicycle_equation {resync_sys_cycle - resync_cycle - int(floor(resync_phase/360.0 - resync_sys_phase/360.0)) + fedback_cycle_latency_offset} \
		non_dqs_2_pll_resync2_multicycle_equation {resync_sys_cycle - resync_cycle - int(floor((resync_phase+180)/360.0 - resync_sys_phase/360.0)) + fedback_cycle_latency_offset} \
		\
		non_dqs_fedback_clock_early_latency_equation {(fb_clk_max_tco + fb_clk_min_tco)/2 + board_feedback - fpga_tQ_FBPLL_SETUP_ERROR} \
		non_dqs_fedback_clock_late_latency_equation {(fb_clk_max_tco + fb_clk_min_tco)/2 + board_feedback + fpga_tQ_FBPLL_HOLD_ERROR} \
		non_dqs_resync1_to_resync2_2_pll_setup_uncertainty_equation {abs(fb_clk_max_tco - fb_clk_min_tco) / 2 + board_feedback * board_tolerance + fpga_tFBPLL_SYSPLL_SETUP_ERROR} \
		non_dqs_resync1_to_resync2_2_pll_hold_uncertainty_equation {abs(fb_clk_max_tco - fb_clk_min_tco) / 2 + board_feedback * board_tolerance + fpga_tFBPLL_SYSPLL_HOLD_ERROR} \
		\
		ddr_non_dqs_2_pll_dq_input_max_delay_equation {sys_clk_max_tco + board_fpga_2_mem + board_mem_2_fpga + board_skew + mem_tAC + pll_dc_distortion + (mem_CL - 3.0) * mem_tCK} \
		ddr_non_dqs_2_pll_dq_input_min_delay_equation {sys_clk_min_tco + board_fpga_2_mem + board_mem_2_fpga - board_skew - mem_tAC - pll_dc_distortion + (mem_CL - 3.0) * mem_tCK} \
		\
		ddr_dq_to_dqs_setup_relationship_equation {0} \
		qdr2_dq_to_dqs_setup_relationship_equation {0} \
		rldram2_dq_to_dqs_setup_relationship_equation {0} \
		ddr_dq_to_dqs_hold_relationship_equation {-(mem_tCK/2.0 - pll_dc_distortion)} \
		qdr2_dq_to_dqs_hold_relationship_equation {-q2_tKHKnH} \
		rldram2_dq_to_dqs_hold_relationship_equation {-rl2_tQKH} \
		\
		ddr_non_dqs_dq_setup_relationship_equation {mem_tCK * (resync_cycle + resync_phase/360.0)} \
		qdr2_non_dqs_dq_setup_relationship_equation {q2_tKHKH * (resync_cycle + resync_phase/360.0)} \
		rldram2_non_dqs_dq_setup_relationship_equation {rl2_tCK * (resync_cycle + resync_phase/360.0)} \
		ddr_non_dqs_dq_hold_relationship_equation {mem_tCK * (resync_cycle + resync_phase/360.0 - 0.5)} \
		qdr2_non_dqs_dq_hold_relationship_equation {q2_tKHKH * (resync_cycle + resync_phase/360.0) - q2_tKHKnH} \
		rldram2_non_dqs_dq_hold_relationship_equation {rl2_tCK * (resync_cycle + resync_phase/360.0 - 0.5) - rl2_tQKH} \
		\
		qdr2_dq_to_sspll_setup_relationship_equation {q2_tKHKH * (resync_phase/360.0)} \
		rldram2_dq_to_sspll_setup_relationship_equation {rl2_tCK * (resync_phase/360.0)} \
		qdr2_dq_to_sspll_hold_relationship_equation {q2_tKHKH * (resync_phase/360.0) - q2_tKHKnH} \
		rldram2_dq_to_sspll_hold_relationship_equation {rl2_tCK * (resync_phase/360.0) - rl2_tQKH} \
		\
		ddr_non_dqs_1_pll_dq_input_max_delay_equation {sys_clk_max_tco + (board_fpga_2_mem + board_mem_2_fpga) * (1 + board_tolerance) + mem_tAC + pll_dc_distortion + (mem_CL - 3.0) * mem_tCK + fpga_tQ_SYSPLL_SETUP_ERROR} \
		ddr_non_dqs_1_pll_dq_input_min_delay_equation {sys_clk_min_tco + (board_fpga_2_mem + board_mem_2_fpga) * (1 - board_tolerance) - mem_tAC - pll_dc_distortion + (mem_CL - 3.0) * mem_tCK + fpga_tQ_SYSPLL_HOLD_ERROR} \
		qdr2_non_dqs_1_pll_dq_input_max_delay_equation {sys_clk_max_tco + (board_fpga_2_mem + board_mem_2_fpga) * (1 + board_tolerance) + q2_tCHQV + pll_dc_distortion + fpga_tQ_SYSPLL_SETUP_ERROR} \
		qdr2_non_dqs_1_pll_dq_input_min_delay_equation {sys_clk_max_tco + (board_fpga_2_mem + board_mem_2_fpga) * (1 - board_tolerance) + q2_tCHQX - pll_dc_distortion + fpga_tQ_SYSPLL_HOLD_ERROR} \
		rldram2_non_dqs_1_pll_dq_input_max_delay_equation {sys_clk_max_tco + (board_fpga_2_mem + board_mem_2_fpga) * (1 + board_tolerance) + rl2_tQKQ + pll_dc_distortion + rl2_RL * rl2_tCK + fpga_tQ_SYSPLL_SETUP_ERROR} \
		rldram2_non_dqs_1_pll_dq_input_min_delay_equation {sys_clk_max_tco + (board_fpga_2_mem + board_mem_2_fpga) * (1 - board_tolerance) - rl2_tQKQ - pll_dc_distortion + rl2_RL * rl2_tCK + fpga_tQ_SYSPLL_HOLD_ERROR} \
		\
		ddr_soft_postamble_enable_setup_relationship_equation {mem_tRPST} \
		\
		use_timequest_by_default {0} \
		is_supported {0}}

set s_family_parameters_list [list \
		$s_stratixii \
		$s_hardcopyii \
		$s_stratixiigx \
		$s_arriagx \
		$s_stratixiii \
		$s_stratixiv \
		$s_cycloneii \
		$s_cycloneiii \
		$s_default_family \
		]
