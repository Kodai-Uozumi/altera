::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_memory_presets.tcl
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

	# Each memory preset is a list of the following format
	# memory_name <memory_name> CAS <CL> mem_tCK {<min tCK> <time_units>} mem_tDQSCK {<max tDQSCK> <time_units>} ...
	set s_CUSTOM {memory_name "<Custom>" \
			mem_CL {"" cycles} \
			mem_tCK {"" ns} \
			mem_tAC {"" ns} \
			mem_tDQSCK {"" ns} \
			mem_tDH {"" ns} \
			mem_tDS {"" ns} \
			mem_tDQSQ {"" ns} \
			mem_tQHS {"" ns} \
			mem_tIH {"" ns} \
			mem_tIS {"" ns} \
			mem_min_tDQSS {"" ns} \
			mem_max_tDQSS {"" ns} \
			mem_tHP {0.45 tCK} \
			mem_tRPST {0.4 tCK}} \

	set s_JEDEC_DDR200 {memory_name "JEDEC DDR200" \
			mem_CL {2 cycles} \
			mem_tCK {10 ns} \
			mem_tAC {0.8 ns} \
			mem_tDQSCK {0.8 ns} \
			mem_tDH {0.6 ns} \
			mem_tDS {0.6 ns} \
			mem_tDQSQ {0.6 ns} \
			mem_tQHS {1.0 ns} \
			mem_tIH {1.1 ns} \
			mem_tIS {1.1 ns} \
			mem_min_tDQSS {0.75 tCK} \
			mem_max_tDQSS {1.25 tCK} \
			mem_tHP {0.45 tCK} \
			mem_tRPST {0.4 tCK}}

	set s_JEDEC_DDR266 {memory_name "JEDEC DDR266" \
			mem_CL {2 cycles} \
			mem_tCK {7.5 ns} \
			mem_tAC {0.75 ns} \
			mem_tDQSCK {0.75 ns} \
			mem_tDH {0.5 ns} \
			mem_tDS {0.5 ns} \
			mem_tDQSQ {0.5 ns} \
			mem_tQHS {0.75 ns} \
			mem_tIH {1.0 ns} \
			mem_tIS {1.0 ns} \
			mem_min_tDQSS {0.75 tCK} \
			mem_max_tDQSS {1.25 tCK} \
			mem_tHP {0.45 tCK} \
			mem_tRPST {0.4 tCK}}

	set s_JEDEC_DDR333_CL2 {memory_name "JEDEC DDR333 CL=2" \
			mem_CL {2 cycles} \
			mem_tCK {7.5 ns} \
			mem_tAC {0.70 ns} \
			mem_tDQSCK {0.60 ns} \
			mem_tDH {0.45 ns} \
			mem_tDS {0.45 ns} \
			mem_tDQSQ {0.45 ns} \
			mem_tQHS {0.55 ns} \
			mem_tIH {0.80 ns} \
			mem_tIS {0.80 ns} \
			mem_min_tDQSS {0.75 tCK} \
			mem_max_tDQSS {1.25 tCK} \
			mem_tHP {0.45 tCK} \
			mem_tRPST {0.4 tCK}}

	set s_JEDEC_DDR333_CL2_5 {memory_name "JEDEC DDR333 CL=2.5" \
			mem_CL {2.5 cycles} \
			mem_tCK {6 ns} \
			mem_tAC {0.70 ns} \
			mem_tDQSCK {0.60 ns} \
			mem_tDH {0.45 ns} \
			mem_tDS {0.45 ns} \
			mem_tDQSQ {0.45 ns} \
			mem_tQHS {0.55 ns} \
			mem_tIH {0.80 ns} \
			mem_tIS {0.80 ns} \
			mem_min_tDQSS {0.75 tCK} \
			mem_max_tDQSS {1.25 tCK} \
			mem_tHP {0.45 tCK} \
			mem_tRPST {0.4 tCK}}

	set s_JEDEC_DDR400_CL2 {memory_name "JEDEC DDR400 CL=2" \
			mem_CL {2 cycles} \
			mem_tCK {7.5 ns} \
			mem_tAC {0.70 ns} \
			mem_tDQSCK {0.60 ns} \
			mem_tDH {0.40 ns} \
			mem_tDS {0.40 ns} \
			mem_tDQSQ {0.40 ns} \
			mem_tQHS {0.50 ns} \
			mem_tIH {0.70 ns} \
			mem_tIS {0.70 ns} \
			mem_min_tDQSS {0.72 tCK} \
			mem_max_tDQSS {1.25 tCK} \
			mem_tHP {0.45 tCK} \
			mem_tRPST {0.4 tCK}}

	set s_JEDEC_DDR400A_CL2_5 {memory_name "JEDEC DDR400A CL=2.5" \
			mem_CL {2.5 cycles} \
			mem_tCK {5 ns} \
			mem_tAC {0.70 ns} \
			mem_tDQSCK {0.60 ns} \
			mem_tDH {0.40 ns} \
			mem_tDS {0.40 ns} \
			mem_tDQSQ {0.40 ns} \
			mem_tQHS {0.50 ns} \
			mem_tIH {0.70 ns} \
			mem_tIS {0.70 ns} \
			mem_min_tDQSS {0.72 tCK} \
			mem_max_tDQSS {1.25 tCK} \
			mem_tHP {0.45 tCK} \
			mem_tRPST {0.4 tCK}}

	set s_JEDEC_DDR400BC_CL2_5 {memory_name "JEDEC DDR400B/DDR400C CL=2.5" \
			mem_CL {2.5 cycles} \
			mem_tCK {6 ns} \
			mem_tAC {0.70 ns} \
			mem_tDQSCK {0.60 ns} \
			mem_tDH {0.40 ns} \
			mem_tDS {0.40 ns} \
			mem_tDQSQ {0.40 ns} \
			mem_tQHS {0.50 ns} \
			mem_tIH {0.70 ns} \
			mem_tIS {0.70 ns} \
			mem_min_tDQSS {0.72 tCK} \
			mem_max_tDQSS {1.25 tCK} \
			mem_tHP {0.45 tCK} \
			mem_tRPST {0.4 tCK}}

	set s_JEDEC_DDR400_CL3 {memory_name "JEDEC DDR400 CL=3.0" \
			mem_CL {3 cycles} \
			mem_tCK {5 ns} \
			mem_tAC {0.70 ns} \
			mem_tDQSCK {0.60 ns} \
			mem_tDH {0.40 ns} \
			mem_tDS {0.40 ns} \
			mem_tDQSQ {0.40 ns} \
			mem_tQHS {0.50 ns} \
			mem_tIH {0.70 ns} \
			mem_tIS {0.70 ns} \
			mem_min_tDQSS {0.72 tCK} \
			mem_max_tDQSS {1.25 tCK} \
			mem_tHP {0.45 tCK} \
			mem_tRPST {0.4 tCK}}

	set s_JEDEC_DDR2_400_CL3 {memory_name "JEDEC DDR2-400 CL=3.0" \
			mem_CL {3 cycles} \
			mem_tCK {5 ns} \
			mem_tAC {0.60 ns} \
			mem_tDQSCK {0.50 ns} \
			mem_tDH {0.40 ns} \
			mem_tDS {0.40 ns} \
			mem_tDQSQ {0.35 ns} \
			mem_tQHS {0.45 ns} \
			mem_tIH {0.60 ns} \
			mem_tIS {0.60 ns} \
			mem_min_tDQSS {-0.25 tCK} \
			mem_max_tDQSS {0.25 tCK} \
			mem_tHP {0.45 tCK} \
			mem_tRPST {0.4 tCK}}

	set s_JEDEC_DDR2_400_CL4 {memory_name "JEDEC DDR2-400 CL=4.0" \
			mem_CL {4 cycles} \
			mem_tCK {5 ns} \
			mem_tAC {0.60 ns} \
			mem_tDQSCK {0.50 ns} \
			mem_tDH {0.40 ns} \
			mem_tDS {0.40 ns} \
			mem_tDQSQ {0.35 ns} \
			mem_tQHS {0.45 ns} \
			mem_tIH {0.60 ns} \
			mem_tIS {0.60 ns} \
			mem_min_tDQSS {-0.25 tCK} \
			mem_max_tDQSS {0.25 tCK} \
			mem_tHP {0.45 tCK} \
			mem_tRPST {0.4 tCK}}

	set s_JEDEC_DDR2_400_CL5 {memory_name "JEDEC DDR2-400 CL=5.0" \
			mem_CL {5 cycles} \
			mem_tCK {5 ns} \
			mem_tAC {0.60 ns} \
			mem_tDQSCK {0.50 ns} \
			mem_tDH {0.40 ns} \
			mem_tDS {0.40 ns} \
			mem_tDQSQ {0.35 ns} \
			mem_tQHS {0.45 ns} \
			mem_tIH {0.60 ns} \
			mem_tIS {0.60 ns} \
			mem_min_tDQSS {-0.25 tCK} \
			mem_max_tDQSS {0.25 tCK} \
			mem_tHP {0.45 tCK} \
			mem_tRPST {0.4 tCK}}

	set s_JEDEC_DDR2_533_CL4 {memory_name "JEDEC DDR2-533 CL=4.0" \
			mem_CL {4 cycles} \
			mem_tCK {3.75 ns} \
			mem_tAC {0.50 ns} \
			mem_tDQSCK {0.45 ns} \
			mem_tDH {0.35 ns} \
			mem_tDS {0.35 ns} \
			mem_tDQSQ {0.30 ns} \
			mem_tQHS {0.40 ns} \
			mem_tIH {0.50 ns} \
			mem_tIS {0.50 ns} \
			mem_min_tDQSS {-0.25 tCK} \
			mem_max_tDQSS {0.25 tCK} \
			mem_tHP {0.45 tCK} \
			mem_tRPST {0.4 tCK}}

	set s_JEDEC_DDR2_533_CL5 {memory_name "JEDEC DDR2-533 CL=5.0" \
			mem_CL {5 cycles} \
			mem_tCK {3.75 ns} \
			mem_tAC {0.50 ns} \
			mem_tDQSCK {0.45 ns} \
			mem_tDH {0.35 ns} \
			mem_tDS {0.35 ns} \
			mem_tDQSQ {0.30 ns} \
			mem_tQHS {0.40 ns} \
			mem_tIH {0.50 ns} \
			mem_tIS {0.50 ns} \
			mem_min_tDQSS {-0.25 tCK} \
			mem_max_tDQSS {0.25 tCK} \
			mem_tHP {0.45 tCK} \
			mem_tRPST {0.4 tCK}}

	set s_JEDEC_DDR2_667_CL4 {memory_name "JEDEC DDR2-667 CL=4.0" \
			mem_CL {4 cycles} \
			mem_tCK {3.00 ns} \
			mem_tAC {0.45 ns} \
			mem_tDQSCK {0.40 ns} \
			mem_tDH {0.30 ns} \
			mem_tDS {0.35 ns} \
			mem_tDQSQ {0.24 ns} \
			mem_tQHS {0.34 ns} \
			mem_tIH {0.475 ns} \
			mem_tIS {0.40 ns} \
			mem_min_tDQSS {-0.25 tCK} \
			mem_max_tDQSS {0.25 tCK} \
			mem_tHP {0.45 tCK} \
			mem_tRPST {0.4 tCK}}

	set s_JEDEC_DDR2_800_CL4 {memory_name "JEDEC DDR2-800 CL=4.0" \
			mem_CL {4 cycles} \
			mem_tCK {2.50 ns} \
			mem_tAC {0.40 ns} \
			mem_tDQSCK {0.35 ns} \
			mem_tDH {0.25 ns} \
			mem_tDS {0.30 ns} \
			mem_tDQSQ {0.20 ns} \
			mem_tQHS {0.30 ns} \
			mem_tIH {0.45 ns} \
			mem_tIS {0.375 ns} \
			mem_min_tDQSS {-0.25 tCK} \
			mem_max_tDQSS {0.25 tCK} \
			mem_tHP {0.45 tCK} \
			mem_tRPST {0.4 tCK}}

	# Presets displayed in the main combobox
	set s_ddr_ddr2_memory_presets_list [list \
			$s_CUSTOM \
			$s_JEDEC_DDR200 \
			$s_JEDEC_DDR266 \
			$s_JEDEC_DDR333_CL2 \
			$s_JEDEC_DDR333_CL2_5 \
			$s_JEDEC_DDR400_CL2 \
			$s_JEDEC_DDR400A_CL2_5 \
			$s_JEDEC_DDR400BC_CL2_5 \
			$s_JEDEC_DDR400_CL3 \
			$s_JEDEC_DDR2_400_CL3 \
			$s_JEDEC_DDR2_400_CL4 \
			$s_JEDEC_DDR2_400_CL5 \
			$s_JEDEC_DDR2_533_CL4 \
			$s_JEDEC_DDR2_533_CL5 \
			$s_JEDEC_DDR2_667_CL4 \
			$s_JEDEC_DDR2_800_CL4 \
			]

	set s_CUSTOM_QDR2 {memory_name "<Custom>" \
			q2_tKHKH {"" ns} \
			q2_tKHKnH {"" ns} \
			q2_tCHQV {"" ns} \
			q2_tCHQX {"" ns} \
			q2_tCHCQV {"" ns} \
			q2_tCHCQX {"" ns} \
			q2_tCQHQV {"" ns} \
			q2_tCQHQX {"" ns} \
			q2_tSA {"" ns} \
			q2_tSC {"" ns} \
			q2_tSD {"" ns} \
			q2_tHA {"" ns} \
			q2_tHC {"" ns} \
			q2_tHD {"" ns}}

	set s_GENERIC_QDR2_300 {memory_name "Generic 300Mhz" \
			q2_tKHKH {3.3 ns} \
			q2_tKHKnH {1.49 ns} \
			q2_tCHQV {0.45 ns} \
			q2_tCHQX {-0.45 ns} \
			q2_tCHCQV {0.45 ns} \
			q2_tCHCQX {-0.45 ns} \
			q2_tCQHQV {0.27 ns} \
			q2_tCQHQX {-0.27 ns} \
			q2_tSA {0.40 ns} \
			q2_tSC {0.40 ns} \
			q2_tSD {0.30 ns} \
			q2_tHA {0.40 ns} \
			q2_tHC {0.40 ns} \
			q2_tHD {0.30 ns}}

	set s_GENERIC_QDR2_250 {memory_name "Generic 250Mhz" \
			memory_list {K7R64[0-9][0-9]84M K7R32[0-9][0-9]84M} \
			q2_tKHKH {4 ns} \
			q2_tKHKnH {1.8 ns} \
			q2_tCHQV {0.45 ns} \
			q2_tCHQX {-0.45 ns} \
			q2_tCHCQV {0.45 ns} \
			q2_tCHCQX {-0.45 ns} \
			q2_tCQHQV {0.30 ns} \
			q2_tCQHQX {-0.30 ns} \
			q2_tSA {0.50 ns} \
			q2_tSC {0.50 ns} \
			q2_tSD {0.35 ns} \
			q2_tHA {0.50 ns} \
			q2_tHC {0.50 ns} \
			q2_tHD {0.35 ns}}

	set s_GENERIC_QDR2_200 {memory_name "Generic 200Mhz" \
			memory_list {K7R64[0-9][0-9]84M K7R32[0-9][0-9]84M} \
			q2_tKHKH {5 ns} \
			q2_tKHKnH {2.2 ns} \
			q2_tCHQV {0.45 ns} \
			q2_tCHQX {-0.45 ns} \
			q2_tCHCQV {0.45 ns} \
			q2_tCHCQX {-0.45 ns} \
			q2_tCQHQV {0.35 ns} \
			q2_tCQHQX {-0.35 ns} \
			q2_tSA {0.60 ns} \
			q2_tSC {0.60 ns} \
			q2_tSD {0.40 ns} \
			q2_tHA {0.60 ns} \
			q2_tHC {0.60 ns} \
			q2_tHD {0.40 ns}}

	set s_GENERIC_QDR2_167 {memory_name "Generic 167Mhz" \
			memory_list {K7R64[0-9][0-9]84M K7R32[0-9][0-9]84M} \
			q2_tKHKH {6 ns} \
			q2_tKHKnH {2.7 ns} \
			q2_tCHQV {0.50 ns} \
			q2_tCHQX {-0.50 ns} \
			q2_tCHCQV {0.50 ns} \
			q2_tCHCQX {-0.50 ns} \
			q2_tCQHQV {0.40 ns} \
			q2_tCQHQX {-0.40 ns} \
			q2_tSA {0.70 ns} \
			q2_tSC {0.70 ns} \
			q2_tSD {0.50 ns} \
			q2_tHA {0.70 ns} \
			q2_tHC {0.70 ns} \
			q2_tHD {0.50 ns}}

	set s_CYC1315BV18_250 {memory_name "CYC1311BV18/CYC1911BV18/CYC1313BV18/CYC1315BV18 250Mhz" \
			q2_tKHKH {4 ns} \
			q2_tKHKnH {1.8 ns} \
			q2_tCQHQV {0.30 ns} \
			q2_tCQHQX {-0.30 ns} \
			q2_tSA {0.50 ns} \
			q2_tSC {0.50 ns} \
			q2_tSD {0.35 ns} \
			q2_tHA {0.50 ns} \
			q2_tHC {0.50 ns} \
			q2_tHD {0.35 ns}}

	set s_CYC1315BV18_200 {memory_name "CYC1311BV18/CYC1911BV18/CYC1313BV18/CYC1315BV18 200MHz" \
			q2_tKHKH {5 ns} \
			q2_tKHKnH {2.2 ns} \
			q2_tCQHQV {0.35 ns} \
			q2_tCQHQX {-0.35 ns} \
			q2_tSA {0.60 ns} \
			q2_tSC {0.60 ns} \
			q2_tSD {0.40 ns} \
			q2_tHA {0.60 ns} \
			q2_tHC {0.60 ns} \
			q2_tHD {0.40 ns}}

	set s_CYC1315BV18_167 {memory_name "CYC1311BV18/CYC1911BV18/CYC1313BV18/CYC1315BV18 167MHz" \
			q2_tKHKH {6 ns} \
			q2_tKHKnH {2.7 ns} \
			q2_tCQHQV {0.40 ns} \
			q2_tCQHQX {-0.40 ns} \
			q2_tSA {0.70 ns} \
			q2_tSC {0.70 ns} \
			q2_tSD {0.50 ns} \
			q2_tHA {0.70 ns} \
			q2_tHC {0.70 ns} \
			q2_tHD {0.50 ns}}

	set s_qdr2_memory_presets_list [list \
			$s_CUSTOM_QDR2 \
			$s_GENERIC_QDR2_300 \
			$s_GENERIC_QDR2_250 \
			$s_GENERIC_QDR2_200 \
			$s_GENERIC_QDR2_167 \
			]

	set s_CUSTOM_RLDRAM2 {memory_name "<Custom>" \
			rl2_is_cio {1} \
			rl2_tRL {"" cycles} \
			rl2_tCK {"" ns} \
			rl2_tQKH {"" ns} \
			rl2_tCKQK {"" ns} \
			rl2_tQKQ0_tQKQ1 {"" ns} \
			rl2_tQKQ {"" ns} \
			rl2_tAS {"" ns} \
			rl2_tAH {"" ns} \
			rl2_tCS {"" ns} \
			rl2_tCH {"" ns} \
			rl2_tDS {"" ns} \
			rl2_tDH {"" ns}}

	set s_MT49H8M36_5 {memory_name "MT49H8M36/MT49H16M18/MT49H32M9-5" \
			rl2_is_cio {1} \
			rl2_tRL {5 cycles} \
			rl2_tCK {5.0 ns} \
			rl2_tQKH {2.025 ns} \
			rl2_tCKQK {0.50 ns} \
			rl2_tQKQ0_tQKQ1 {0.30 ns} \
			rl2_tQKQ {0.40 ns} \
			rl2_tAS {0.80 ns} \
			rl2_tAH {0.80 ns} \
			rl2_tCS {0.80 ns} \
			rl2_tCH {0.80 ns} \
			rl2_tDS {0.40 ns} \
			rl2_tDH {0.40 ns}}

	set s_GENERIC_RLDRAM2_CIO_400 {memory_name "Generic CIO -25 400Mhz" \
			rl2_is_cio {1} \
			rl2_tRL {8 cycles} \
			rl2_tCK {2.5 ns} \
			rl2_tQKH {1.012 ns} \
			rl2_tCKQK {0.25 ns} \
			rl2_tQKQ0_tQKQ1 {0.20 ns} \
			rl2_tQKQ {0.30 ns} \
			rl2_tAS {0.40 ns} \
			rl2_tAH {0.40 ns} \
			rl2_tCS {0.40 ns} \
			rl2_tCH {0.40 ns} \
			rl2_tDS {0.25 ns} \
			rl2_tDH {0.25 ns}}

	set s_GENERIC_RLDRAM2_CIO_300 {memory_name "Generic CIO -33 300Mhz" \
			rl2_is_cio {1} \
			rl2_tRL {8 cycles} \
			rl2_tCK {3.3 ns} \
			rl2_tQKH {1.336 ns} \
			rl2_tCKQK {0.30 ns} \
			rl2_tQKQ0_tQKQ1 {0.25 ns} \
			rl2_tQKQ {0.35 ns} \
			rl2_tAS {0.50 ns} \
			rl2_tAH {0.50 ns} \
			rl2_tCS {0.50 ns} \
			rl2_tCH {0.50 ns} \
			rl2_tDS {0.30 ns} \
			rl2_tDH {0.30 ns}}

	set s_GENERIC_RLDRAM2_CIO_200 {memory_name "Generic CIO -5 200Mhz" \
			rl2_is_cio {1} \
			rl2_tRL {8 cycles} \
			rl2_tCK {5.0 ns} \
			rl2_tQKH {2.025 ns} \
			rl2_tCKQK {0.50 ns} \
			rl2_tQKQ0_tQKQ1 {0.30 ns} \
			rl2_tQKQ {0.40 ns} \
			rl2_tAS {0.80 ns} \
			rl2_tAH {0.80 ns} \
			rl2_tCS {0.80 ns} \
			rl2_tCH {0.80 ns} \
			rl2_tDS {0.40 ns} \
			rl2_tDH {0.40 ns}}

	set s_GENERIC_RLDRAM2_SIO_400 {memory_name "Generic SIO -25 400Mhz" \
			rl2_is_cio {0} \
			rl2_tRL {8 cycles} \
			rl2_tCK {2.5 ns} \
			rl2_tQKH {1.012 ns} \
			rl2_tCKQK {0.25 ns} \
			rl2_tQKQ0_tQKQ1 {0.20 ns} \
			rl2_tQKQ {0.30 ns} \
			rl2_tAS {0.40 ns} \
			rl2_tAH {0.40 ns} \
			rl2_tCS {0.40 ns} \
			rl2_tCH {0.40 ns} \
			rl2_tDS {0.25 ns} \
			rl2_tDH {0.25 ns}}

	set s_GENERIC_RLDRAM2_SIO_300 {memory_name "Generic SIO -33 300Mhz" \
			rl2_is_cio {0} \
			rl2_tRL {8 cycles} \
			rl2_tCK {3.3 ns} \
			rl2_tQKH {1.336 ns} \
			rl2_tCKQK {0.30 ns} \
			rl2_tQKQ0_tQKQ1 {0.25 ns} \
			rl2_tQKQ {0.35 ns} \
			rl2_tAS {0.50 ns} \
			rl2_tAH {0.50 ns} \
			rl2_tCS {0.50 ns} \
			rl2_tCH {0.50 ns} \
			rl2_tDS {0.30 ns} \
			rl2_tDH {0.30 ns}}

	set s_GENERIC_RLDRAM2_SIO_200 {memory_name "Generic SIO -5 200Mhz" \
			rl2_is_cio {0} \
			rl2_tRL {8 cycles} \
			rl2_tCK {5.0 ns} \
			rl2_tQKH {2.025 ns} \
			rl2_tCKQK {0.50 ns} \
			rl2_tQKQ0_tQKQ1 {0.30 ns} \
			rl2_tQKQ {0.40 ns} \
			rl2_tAS {0.80 ns} \
			rl2_tAH {0.80 ns} \
			rl2_tCS {0.80 ns} \
			rl2_tCH {0.80 ns} \
			rl2_tDS {0.40 ns} \
			rl2_tDH {0.40 ns}}

	set s_rldram2_memory_presets_list [list \
			$s_CUSTOM_RLDRAM2 \
			$s_GENERIC_RLDRAM2_CIO_400 \
			$s_GENERIC_RLDRAM2_CIO_300 \
			$s_GENERIC_RLDRAM2_CIO_200 \
			$s_GENERIC_RLDRAM2_SIO_400 \
			$s_GENERIC_RLDRAM2_SIO_300 \
			$s_GENERIC_RLDRAM2_SIO_200 \
			]

	set s_ddr_info [list \
			type "ddr" \
			type_name "DDR/DDR2 SDRAM" \
			presets $s_ddr_ddr2_memory_presets_list \
			]
			
	set s_qdr2_info [list \
			type "qdr2" \
			type_name "QDRII/QDRII+ SRAM" \
			presets $s_qdr2_memory_presets_list \
			]

	set s_rldram2_info [list \
			type "rldram2" \
			type_name "RLDRAM II" \
			presets $s_rldram2_memory_presets_list \
			]
			
	set s_memory_types_list [list \
			$s_ddr_info \
			$s_qdr2_info \
			$s_rldram2_info \
			]
