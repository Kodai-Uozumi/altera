#############################################################################
##  sim_lib_info_pkg.tcl - v2.0
##
##  This Tcl/Tk library provides access to the simulation library information
##
##  To use these functions in your own Tcl/Tk scripts just add:
##
##      package require ::quartus::sim_lib_info
##
##  to the top of your scripts. 
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
#############################################################################


package provide ::quartus::sim_lib_info 1.0

#############################################################################
## Export Functions & Declare Global Namespace Variables
namespace eval ::quartus::sim_lib_info {

	#exported functions
	namespace export get_sim_models_for_family
	namespace export get_family_specific_sim_models
	namespace export get_family_independent_sim_models
	namespace export get_sim_models_for_library
	namespace export is_family_supported
	namespace export get_supported_family_list

	#various array defintions
	set lib_src_list(altera) {{<LIBPATH>/altera_syn_attributes.vhd VHDL93} {<LIBPATH>/altera_primitives_components.vhd VHDL93} {<LIBPATH>/altera_primitives.vhd VHDL93} }
	set lib_src_list(altera_mf) {{<LIBPATH>/altera_mf_components.vhd VHDL93} {<LIBPATH>/altera_mf.vhd VHDL93} }
	set lib_src_list(altera_mf_ver) {{<LIBPATH>/altera_mf.v Verilog_2001} }
	set lib_src_list(altera_ver) {{<LIBPATH>/altera_primitives.v Verilog_2001} }
	set lib_src_list(altgxb) {{<LIBPATH>/stratixgx_mf.vhd VHDL93} {<LIBPATH>/stratixgx_mf_components.vhd VHDL93} }
	set lib_src_list(altgxb_ver) {{<LIBPATH>/stratixgx_mf.v Verilog_2001} }
	set lib_src_list(apex20ke) {{<LIBPATH>/apex20ke_atoms.vhd VHDL93} {<LIBPATH>/apex20ke_components.vhd VHDL93} }
	set lib_src_list(apex20ke_ver) {{<LIBPATH>/apex20ke_atoms.v Verilog_2001} }
	set lib_src_list(apexii) {{<LIBPATH>/apexii_atoms.vhd VHDL93} {<LIBPATH>/apexii_components.vhd VHDL93} }
	set lib_src_list(apexii_ver) {{<LIBPATH>/apexii_atoms.v Verilog_2001} }
	set lib_src_list(arriagx) {{<LIBPATH>/arriagx_atoms.vhd VHDL93} {<LIBPATH>/arriagx_components.vhd VHDL93} }
	set lib_src_list(arriagx_hssi) {{<LIBPATH>/arriagx_hssi_components.vhd VHDL93} {<LIBPATH>/arriagx_hssi_atoms.vhd VHDL93} }
	set lib_src_list(arriagx_hssi_ver) {{<LIBPATH>/arriagx_hssi_atoms.v Verilog_2001} }
	set lib_src_list(arriagx_ver) {{<LIBPATH>/arriagx_atoms.v Verilog_2001} }
	set lib_src_list(arriaii) {{<LIBPATH>/arriaii_atoms.vhd VHDL93} {<LIBPATH>/arriaii_components.vhd VHDL93} }
	set lib_src_list(arriaii_hssi) {{<LIBPATH>/arriaii_hssi_components.vhd VHDL93} {<LIBPATH>/arriaii_hssi_atoms.vhd VHDL93} }
	set lib_src_list(arriaii_hssi_ver) {{<LIBPATH>/arriaii_hssi_atoms.v Verilog_2001} }
	set lib_src_list(arriaii_pcie_hip) {{<LIBPATH>/arriaii_pcie_hip_components.vhd VHDL93} {<LIBPATH>/arriaii_pcie_hip_atoms.vhd VHDL93} }
	set lib_src_list(arriaii_pcie_hip_ver) {{<LIBPATH>/arriaii_pcie_hip_atoms.v Verilog_2001} }
	set lib_src_list(arriaii_ver) {{<LIBPATH>/arriaii_atoms.v Verilog_2001} }
	set lib_src_list(cyclone) {{<LIBPATH>/cyclone_atoms.vhd VHDL93} {<LIBPATH>/cyclone_components.vhd VHDL93} }
	set lib_src_list(cycloneii) {{<LIBPATH>/cycloneii_atoms.vhd VHDL93} {<LIBPATH>/cycloneii_components.vhd VHDL93} }
	set lib_src_list(cycloneiii) {{<LIBPATH>/cycloneiii_atoms.vhd VHDL93} {<LIBPATH>/cycloneiii_components.vhd VHDL93} }
	set lib_src_list(cycloneiii_ver) {{<LIBPATH>/cycloneiii_atoms.v Verilog_2001} }
	set lib_src_list(cycloneii_ver) {{<LIBPATH>/cycloneii_atoms.v Verilog_2001} }
	set lib_src_list(cyclone_ver) {{<LIBPATH>/cyclone_atoms.v Verilog_2001} }
	set lib_src_list(flex10ke) {{<LIBPATH>/flex10ke_atoms.vhd VHDL93} {<LIBPATH>/flex10ke_components.vhd VHDL93} }
	set lib_src_list(flex10ke_ver) {{<LIBPATH>/flex10ke_atoms.v Verilog_2001} }
	set lib_src_list(flex6000) {{<LIBPATH>/flex6000_atoms.vhd VHDL93} {<LIBPATH>/flex6000_components.vhd VHDL93} }
	set lib_src_list(flex6000_ver) {{<LIBPATH>/flex6000_atoms.v Verilog_2001} }
	set lib_src_list(hardcopyii) {{<LIBPATH>/hardcopyii_atoms.vhd VHDL93} {<LIBPATH>/hardcopyii_components.vhd VHDL93} }
	set lib_src_list(hardcopyiii) {{<LIBPATH>/hardcopyiii_atoms.vhd VHDL93} {<LIBPATH>/hardcopyiii_components.vhd VHDL93} }
	set lib_src_list(hardcopyiii_ver) {{<LIBPATH>/hardcopyiii_atoms.v Verilog_2001} }
	set lib_src_list(hardcopyii_ver) {{<LIBPATH>/hardcopyii_atoms.v Verilog_2001} }
	set lib_src_list(hardcopyiv) {{<LIBPATH>/hardcopyiv_atoms.vhd VHDL93} {<LIBPATH>/hardcopyiv_components.vhd VHDL93} }
	set lib_src_list(hardcopyiv_ver) {{<LIBPATH>/hardcopyiv_atoms.v Verilog_2001} }
	set lib_src_list(lpm) {{<LIBPATH>/220pack.vhd VHDL93} {<LIBPATH>/220model.vhd VHDL93} }
	set lib_src_list(lpm_ver) {{<LIBPATH>/220model.v Verilog_2001} }
	set lib_src_list(max) {{<LIBPATH>/max_atoms.vhd VHDL93} {<LIBPATH>/max_components.vhd VHDL93} }
	set lib_src_list(maxii) {{<LIBPATH>/maxii_atoms.vhd VHDL93} {<LIBPATH>/maxii_components.vhd VHDL93} }
	set lib_src_list(maxii_ver) {{<LIBPATH>/maxii_atoms.v Verilog_2001} }
	set lib_src_list(max_ver) {{<LIBPATH>/max_atoms.v Verilog_2001} }
	set lib_src_list(sgate) {{<LIBPATH>/sgate_pack.vhd VHDL93} {<LIBPATH>/sgate.vhd VHDL93} }
	set lib_src_list(sgate_ver) {{<LIBPATH>/sgate.v Verilog_2001} }
	set lib_src_list(stratix) {{<LIBPATH>/stratix_atoms.vhd VHDL93} {<LIBPATH>/stratix_components.vhd VHDL93} }
	set lib_src_list(stratixgx) {{<LIBPATH>/stratixgx_atoms.vhd VHDL93} {<LIBPATH>/stratixgx_components.vhd VHDL93} }
	set lib_src_list(stratixgx_gxb) {{<LIBPATH>/stratixgx_hssi_atoms.vhd VHDL93} {<LIBPATH>/stratixgx_hssi_components.vhd VHDL93} }
	set lib_src_list(stratixgx_gxb_ver) {{<LIBPATH>/stratixgx_hssi_atoms.v Verilog_2001} }
	set lib_src_list(stratixgx_ver) {{<LIBPATH>/stratixgx_atoms.v Verilog_2001} }
	set lib_src_list(stratixii) {{<LIBPATH>/stratixii_atoms.vhd VHDL93} {<LIBPATH>/stratixii_components.vhd VHDL93} }
	set lib_src_list(stratixiigx) {{<LIBPATH>/stratixiigx_atoms.vhd VHDL93} {<LIBPATH>/stratixiigx_components.vhd VHDL93} }
	set lib_src_list(stratixiigx_hssi) {{<LIBPATH>/stratixiigx_hssi_components.vhd VHDL93} {<LIBPATH>/stratixiigx_hssi_atoms.vhd VHDL93} }
	set lib_src_list(stratixiigx_hssi_ver) {{<LIBPATH>/stratixiigx_hssi_atoms.v Verilog_2001} }
	set lib_src_list(stratixiigx_ver) {{<LIBPATH>/stratixiigx_atoms.v Verilog_2001} }
	set lib_src_list(stratixiii) {{<LIBPATH>/stratixiii_atoms.vhd VHDL93} {<LIBPATH>/stratixiii_components.vhd VHDL93} }
	set lib_src_list(stratixiii_ver) {{<LIBPATH>/stratixiii_atoms.v Verilog_2001} }
	set lib_src_list(stratixii_ver) {{<LIBPATH>/stratixii_atoms.v Verilog_2001} }
	set lib_src_list(stratixiv) {{<LIBPATH>/stratixiv_atoms.vhd VHDL93} {<LIBPATH>/stratixiv_components.vhd VHDL93} }
	set lib_src_list(stratixiv_hssi) {{<LIBPATH>/stratixiv_hssi_components.vhd VHDL93} {<LIBPATH>/stratixiv_hssi_atoms.vhd VHDL93} }
	set lib_src_list(stratixiv_hssi_ver) {{<LIBPATH>/stratixiv_hssi_atoms.v Verilog_2001} }
	set lib_src_list(stratixiv_pcie_hip) {{<LIBPATH>/stratixiv_pcie_hip_components.vhd VHDL93} {<LIBPATH>/stratixiv_pcie_hip_atoms.vhd VHDL93} }
	set lib_src_list(stratixiv_pcie_hip_ver) {{<LIBPATH>/stratixiv_pcie_hip_atoms.v Verilog_2001} }
	set lib_src_list(stratixiv_ver) {{<LIBPATH>/stratixiv_atoms.v Verilog_2001} }
	set lib_src_list(stratix_ver) {{<LIBPATH>/stratix_atoms.v Verilog_2001} }
	set lib_src_list(cycloneiiils) {{<LIBPATH>/cycloneiiils_atoms.vhd VHDL93} {<LIBPATH>/cycloneiiils_components.vhd VHDL93} }
	set lib_src_list(cycloneiiils_ver) {{<LIBPATH>/cycloneiiils_atoms.v Verilog_2001} }

	set lib_list(altera) { altera}
	set lib_list(altera_mf) { altera_mf}
	set lib_list(altera_mf_ver) { altera_mf_ver}
	set lib_list(altera_ver) { altera_ver}
	set lib_list(altgxb) { lpm sgate altgxb}
	set lib_list(altgxb_ver) { lpm_ver sgate_ver altgxb_ver}
	set lib_list(apex20ke) { apex20ke}
	set lib_list(apex20ke_ver) { apex20ke_ver}
	set lib_list(apexii) { apexii}
	set lib_list(apexii_ver) { apexii_ver}
	set lib_list(arriagx) { arriagx}
	set lib_list(arriagx_hssi) { lpm sgate arriagx_hssi}
	set lib_list(arriagx_hssi_ver) { lpm_ver sgate_ver arriagx_hssi_ver}
	set lib_list(arriagx_ver) { arriagx_ver}
	set lib_list(arriaii) { altera arriaii}
	set lib_list(arriaii_hssi) { altera lpm sgate arriaii_hssi}
	set lib_list(arriaii_hssi_ver) { altera_ver lpm_ver sgate_ver arriaii_hssi_ver}
	set lib_list(arriaii_pcie_hip) { altera lpm sgate altera_mf arriaii_pcie_hip}
	set lib_list(arriaii_pcie_hip_ver) { altera_ver lpm_ver sgate_ver altera_mf_ver arriaii_pcie_hip_ver}
	set lib_list(arriaii_ver) { altera_ver arriaii_ver}
	set lib_list(cyclone) { cyclone}
	set lib_list(cycloneii) { cycloneii}
	set lib_list(cycloneiii) { altera cycloneiii}
	set lib_list(cycloneiii_ver) { altera_ver cycloneiii_ver}
	set lib_list(cycloneii_ver) { cycloneii_ver}
	set lib_list(cyclone_ver) { cyclone_ver}
	set lib_list(flex10ke) { flex10ke}
	set lib_list(flex10ke_ver) { flex10ke_ver}
	set lib_list(flex6000) { flex6000}
	set lib_list(flex6000_ver) { flex6000_ver}
	set lib_list(hardcopyii) { hardcopyii}
	set lib_list(hardcopyiii) { altera hardcopyiii}
	set lib_list(hardcopyiii_ver) { altera_ver hardcopyiii_ver}
	set lib_list(hardcopyii_ver) { hardcopyii_ver}
	set lib_list(hardcopyiv) { altera hardcopyiv}
	set lib_list(hardcopyiv_ver) { altera_ver hardcopyiv_ver}
	set lib_list(lpm) { lpm}
	set lib_list(lpm_ver) { lpm_ver}
	set lib_list(max) { max}
	set lib_list(maxii) { maxii}
	set lib_list(maxii_ver) { maxii_ver}
	set lib_list(max_ver) { max_ver}
	set lib_list(sgate) { lpm sgate}
	set lib_list(sgate_ver) { lpm_ver sgate_ver}
	set lib_list(stratix) { stratix}
	set lib_list(stratixgx) { stratixgx}
	set lib_list(stratixgx_gxb) { lpm sgate stratixgx_gxb}
	set lib_list(stratixgx_gxb_ver) { lpm_ver sgate_ver stratixgx_gxb_ver}
	set lib_list(stratixgx_ver) { stratixgx_ver}
	set lib_list(stratixii) { stratixii}
	set lib_list(stratixiigx) { stratixiigx}
	set lib_list(stratixiigx_hssi) { lpm sgate stratixiigx_hssi}
	set lib_list(stratixiigx_hssi_ver) { lpm_ver sgate_ver stratixiigx_hssi_ver}
	set lib_list(stratixiigx_ver) { stratixiigx_ver}
	set lib_list(stratixiii) { altera stratixiii}
	set lib_list(stratixiii_ver) { altera_ver stratixiii_ver}
	set lib_list(stratixii_ver) { stratixii_ver}
	set lib_list(stratixiv) { altera stratixiv}
	set lib_list(stratixiv_hssi) { altera lpm sgate stratixiv_hssi}
	set lib_list(stratixiv_hssi_ver) { altera_ver lpm_ver sgate_ver stratixiv_hssi_ver}
	set lib_list(stratixiv_pcie_hip) { altera lpm sgate altera_mf stratixiv_pcie_hip}
	set lib_list(stratixiv_pcie_hip_ver) { altera_ver lpm_ver sgate_ver altera_mf_ver stratixiv_pcie_hip_ver}
	set lib_list(stratixiv_ver) { altera_ver stratixiv_ver}
	set lib_list(stratix_ver) { stratix_ver}
	set lib_list(cycloneiiils) { altera cycloneiiils}
	set lib_list(cycloneiiils_ver) { altera_ver cycloneiiils_ver}
	set family_gate_lib_list(acex1k,verilog) { flex10ke_ver}
	set family_all_lib_list(acex1k,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver flex10ke_ver}
	set family_specific_lib_list(acex1k,verilog) { flex10ke_ver}
	set family_gate_lib_list(acex1k,vhdl) { flex10ke}
	set family_all_lib_list(acex1k,vhdl) { altera lpm sgate altera_mf flex10ke}
	set family_specific_lib_list(acex1k,vhdl) { flex10ke}
	set family_gate_lib_list(apex20kc,verilog) { apex20ke_ver}
	set family_all_lib_list(apex20kc,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver apex20ke_ver}
	set family_specific_lib_list(apex20kc,verilog) { apex20ke_ver}
	set family_gate_lib_list(apex20kc,vhdl) { apex20ke}
	set family_all_lib_list(apex20kc,vhdl) { altera lpm sgate altera_mf apex20ke}
	set family_specific_lib_list(apex20kc,vhdl) { apex20ke}
	set family_gate_lib_list(apex20ke,verilog) { apex20ke_ver}
	set family_all_lib_list(apex20ke,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver apex20ke_ver}
	set family_specific_lib_list(apex20ke,verilog) { apex20ke_ver}
	set family_gate_lib_list(apex20ke,vhdl) { apex20ke}
	set family_all_lib_list(apex20ke,vhdl) { altera lpm sgate altera_mf apex20ke}
	set family_specific_lib_list(apex20ke,vhdl) { apex20ke}
	set family_gate_lib_list(apexii,verilog) { apexii_ver}
	set family_all_lib_list(apexii,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver apexii_ver}
	set family_specific_lib_list(apexii,verilog) { apexii_ver}
	set family_gate_lib_list(apexii,vhdl) { apexii}
	set family_all_lib_list(apexii,vhdl) { altera lpm sgate altera_mf apexii}
	set family_specific_lib_list(apexii,vhdl) { apexii}
	set family_gate_lib_list(arriagx,verilog) { arriagx_ver lpm_ver sgate_ver altgxb_ver arriagx_hssi_ver}
	set family_all_lib_list(arriagx,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver arriagx_ver altgxb_ver arriagx_hssi_ver}
	set family_specific_lib_list(arriagx,verilog) { arriagx_ver altgxb_ver arriagx_hssi_ver}
	set family_gate_lib_list(arriagx,vhdl) { arriagx lpm sgate altgxb arriagx_hssi}
	set family_all_lib_list(arriagx,vhdl) { altera lpm sgate altera_mf arriagx altgxb arriagx_hssi}
	set family_specific_lib_list(arriagx,vhdl) { arriagx altgxb arriagx_hssi}
	set family_gate_lib_list(arriaiigx,verilog) { altera_mf_ver altera_ver lpm_ver sgate_ver arriaii_hssi_ver altera_mf_ver arriaii_pcie_hip_ver altera_ver arriaii_ver}
	set family_all_lib_list(arriaiigx,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver arriaii_hssi_ver arriaii_pcie_hip_ver arriaii_ver}
	set family_specific_lib_list(arriaiigx,verilog) { arriaii_hssi_ver arriaii_pcie_hip_ver arriaii_ver}
	set family_gate_lib_list(arriaiigx,vhdl) { altera_mf altera lpm sgate arriaii_hssi altera_mf arriaii_pcie_hip altera arriaii}
	set family_all_lib_list(arriaiigx,vhdl) { altera lpm sgate altera_mf arriaii_hssi arriaii_pcie_hip arriaii}
	set family_specific_lib_list(arriaiigx,vhdl) { arriaii_hssi arriaii_pcie_hip arriaii}
	set family_gate_lib_list(cyclone,verilog) { cyclone_ver}
	set family_all_lib_list(cyclone,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver cyclone_ver}
	set family_specific_lib_list(cyclone,verilog) { cyclone_ver}
	set family_gate_lib_list(cyclone,vhdl) { cyclone}
	set family_all_lib_list(cyclone,vhdl) { altera lpm sgate altera_mf cyclone}
	set family_specific_lib_list(cyclone,vhdl) { cyclone}
	set family_gate_lib_list(cycloneii,verilog) { cycloneii_ver}
	set family_all_lib_list(cycloneii,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver cycloneii_ver}
	set family_specific_lib_list(cycloneii,verilog) { cycloneii_ver}
	set family_gate_lib_list(cycloneii,vhdl) { cycloneii}
	set family_all_lib_list(cycloneii,vhdl) { altera lpm sgate altera_mf cycloneii}
	set family_specific_lib_list(cycloneii,vhdl) { cycloneii}
	set family_gate_lib_list(cycloneiii,verilog) { altera_ver cycloneiii_ver}
	set family_all_lib_list(cycloneiii,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver cycloneiii_ver}
	set family_specific_lib_list(cycloneiii,verilog) { cycloneiii_ver}
	set family_gate_lib_list(cycloneiii,vhdl) { altera cycloneiii}
	set family_all_lib_list(cycloneiii,vhdl) { altera lpm sgate altera_mf cycloneiii}
	set family_specific_lib_list(cycloneiii,vhdl) { cycloneiii}
	set family_gate_lib_list(flex10k,verilog) { flex10ke_ver}
	set family_all_lib_list(flex10k,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver flex10ke_ver}
	set family_specific_lib_list(flex10k,verilog) { flex10ke_ver}
	set family_gate_lib_list(flex10k,vhdl) { flex10ke}
	set family_all_lib_list(flex10k,vhdl) { altera lpm sgate altera_mf flex10ke}
	set family_specific_lib_list(flex10k,vhdl) { flex10ke}
	set family_gate_lib_list(flex10ka,verilog) { flex10ke_ver}
	set family_all_lib_list(flex10ka,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver flex10ke_ver}
	set family_specific_lib_list(flex10ka,verilog) { flex10ke_ver}
	set family_gate_lib_list(flex10ka,vhdl) { flex10ke}
	set family_all_lib_list(flex10ka,vhdl) { altera lpm sgate altera_mf flex10ke}
	set family_specific_lib_list(flex10ka,vhdl) { flex10ke}
	set family_gate_lib_list(flex10ke,verilog) { flex10ke_ver}
	set family_all_lib_list(flex10ke,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver flex10ke_ver}
	set family_specific_lib_list(flex10ke,verilog) { flex10ke_ver}
	set family_gate_lib_list(flex10ke,vhdl) { flex10ke}
	set family_all_lib_list(flex10ke,vhdl) { altera lpm sgate altera_mf flex10ke}
	set family_specific_lib_list(flex10ke,vhdl) { flex10ke}
	set family_gate_lib_list(flex6000,verilog) { flex6000_ver}
	set family_all_lib_list(flex6000,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver flex6000_ver}
	set family_specific_lib_list(flex6000,verilog) { flex6000_ver}
	set family_gate_lib_list(flex6000,vhdl) { flex6000}
	set family_all_lib_list(flex6000,vhdl) { altera lpm sgate altera_mf flex6000}
	set family_specific_lib_list(flex6000,vhdl) { flex6000}
	set family_gate_lib_list(hardcopyii,verilog) { hardcopyii_ver}
	set family_all_lib_list(hardcopyii,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver hardcopyii_ver}
	set family_specific_lib_list(hardcopyii,verilog) { hardcopyii_ver}
	set family_gate_lib_list(hardcopyii,vhdl) { hardcopyii}
	set family_all_lib_list(hardcopyii,vhdl) { altera lpm sgate altera_mf hardcopyii}
	set family_specific_lib_list(hardcopyii,vhdl) { hardcopyii}
	set family_gate_lib_list(hardcopyiii,verilog) { altera_ver hardcopyiii_ver}
	set family_all_lib_list(hardcopyiii,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver hardcopyiii_ver}
	set family_specific_lib_list(hardcopyiii,verilog) { hardcopyiii_ver}
	set family_gate_lib_list(hardcopyiii,vhdl) { altera hardcopyiii}
	set family_all_lib_list(hardcopyiii,vhdl) { altera lpm sgate altera_mf hardcopyiii}
	set family_specific_lib_list(hardcopyiii,vhdl) { hardcopyiii}
	set family_gate_lib_list(hardcopyiv,verilog) { altera_ver hardcopyiv_ver}
	set family_all_lib_list(hardcopyiv,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver hardcopyiv_ver}
	set family_specific_lib_list(hardcopyiv,verilog) { hardcopyiv_ver}
	set family_gate_lib_list(hardcopyiv,vhdl) { altera hardcopyiv}
	set family_all_lib_list(hardcopyiv,vhdl) { altera lpm sgate altera_mf hardcopyiv}
	set family_specific_lib_list(hardcopyiv,vhdl) { hardcopyiv}
	set family_gate_lib_list(max3000a,verilog) { max_ver}
	set family_all_lib_list(max3000a,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver max_ver}
	set family_specific_lib_list(max3000a,verilog) { max_ver}
	set family_gate_lib_list(max3000a,vhdl) { max}
	set family_all_lib_list(max3000a,vhdl) { altera lpm sgate altera_mf max}
	set family_specific_lib_list(max3000a,vhdl) { max}
	set family_gate_lib_list(max7000ae,verilog) { max_ver}
	set family_all_lib_list(max7000ae,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver max_ver}
	set family_specific_lib_list(max7000ae,verilog) { max_ver}
	set family_gate_lib_list(max7000ae,vhdl) { max}
	set family_all_lib_list(max7000ae,vhdl) { altera lpm sgate altera_mf max}
	set family_specific_lib_list(max7000ae,vhdl) { max}
	set family_gate_lib_list(max7000b,verilog) { max_ver}
	set family_all_lib_list(max7000b,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver max_ver}
	set family_specific_lib_list(max7000b,verilog) { max_ver}
	set family_gate_lib_list(max7000b,vhdl) { max}
	set family_all_lib_list(max7000b,vhdl) { altera lpm sgate altera_mf max}
	set family_specific_lib_list(max7000b,vhdl) { max}
	set family_gate_lib_list(max7000s,verilog) { max_ver}
	set family_all_lib_list(max7000s,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver max_ver}
	set family_specific_lib_list(max7000s,verilog) { max_ver}
	set family_gate_lib_list(max7000s,vhdl) { max}
	set family_all_lib_list(max7000s,vhdl) { altera lpm sgate altera_mf max}
	set family_specific_lib_list(max7000s,vhdl) { max}
	set family_gate_lib_list(maxii,verilog) { maxii_ver}
	set family_all_lib_list(maxii,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver maxii_ver}
	set family_specific_lib_list(maxii,verilog) { maxii_ver}
	set family_gate_lib_list(maxii,vhdl) { maxii}
	set family_all_lib_list(maxii,vhdl) { altera lpm sgate altera_mf maxii}
	set family_specific_lib_list(maxii,vhdl) { maxii}
	set family_gate_lib_list(stratix,verilog) { stratix_ver}
	set family_all_lib_list(stratix,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver stratix_ver}
	set family_specific_lib_list(stratix,verilog) { stratix_ver}
	set family_gate_lib_list(stratix,vhdl) { stratix}
	set family_all_lib_list(stratix,vhdl) { altera lpm sgate altera_mf stratix}
	set family_specific_lib_list(stratix,vhdl) { stratix}
	set family_gate_lib_list(stratixgx,verilog) { stratixgx_ver lpm_ver sgate_ver altgxb_ver stratixgx_gxb_ver}
	set family_all_lib_list(stratixgx,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver stratixgx_ver altgxb_ver stratixgx_gxb_ver}
	set family_specific_lib_list(stratixgx,verilog) { stratixgx_ver altgxb_ver stratixgx_gxb_ver}
	set family_gate_lib_list(stratixgx,vhdl) { stratixgx lpm sgate altgxb stratixgx_gxb}
	set family_all_lib_list(stratixgx,vhdl) { altera lpm sgate altera_mf stratixgx altgxb stratixgx_gxb}
	set family_specific_lib_list(stratixgx,vhdl) { stratixgx altgxb stratixgx_gxb}
	set family_gate_lib_list(stratixii,verilog) { stratixii_ver}
	set family_all_lib_list(stratixii,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver stratixii_ver}
	set family_specific_lib_list(stratixii,verilog) { stratixii_ver}
	set family_gate_lib_list(stratixii,vhdl) { stratixii}
	set family_all_lib_list(stratixii,vhdl) { altera lpm sgate altera_mf stratixii}
	set family_specific_lib_list(stratixii,vhdl) { stratixii}
	set family_gate_lib_list(stratixiigx,verilog) { lpm_ver sgate_ver stratixiigx_hssi_ver stratixiigx_ver}
	set family_all_lib_list(stratixiigx,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver stratixiigx_hssi_ver stratixiigx_ver}
	set family_specific_lib_list(stratixiigx,verilog) { stratixiigx_hssi_ver stratixiigx_ver}
	set family_gate_lib_list(stratixiigx,vhdl) { lpm sgate stratixiigx_hssi stratixiigx}
	set family_all_lib_list(stratixiigx,vhdl) { altera lpm sgate altera_mf stratixiigx_hssi stratixiigx}
	set family_specific_lib_list(stratixiigx,vhdl) { stratixiigx_hssi stratixiigx}
	set family_gate_lib_list(stratixiii,verilog) { altera_ver stratixiii_ver}
	set family_all_lib_list(stratixiii,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver stratixiii_ver}
	set family_specific_lib_list(stratixiii,verilog) { stratixiii_ver}
	set family_gate_lib_list(stratixiii,vhdl) { altera stratixiii}
	set family_all_lib_list(stratixiii,vhdl) { altera lpm sgate altera_mf stratixiii}
	set family_specific_lib_list(stratixiii,vhdl) { stratixiii}
	set family_gate_lib_list(stratixiv,verilog) { altera_mf_ver altera_ver lpm_ver sgate_ver stratixiv_hssi_ver altera_mf_ver stratixiv_pcie_hip_ver altera_ver stratixiv_ver}
	set family_all_lib_list(stratixiv,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver stratixiv_hssi_ver stratixiv_pcie_hip_ver stratixiv_ver}
	set family_specific_lib_list(stratixiv,verilog) { stratixiv_hssi_ver stratixiv_pcie_hip_ver stratixiv_ver}
	set family_gate_lib_list(stratixiv,vhdl) { altera_mf altera lpm sgate stratixiv_hssi altera_mf stratixiv_pcie_hip altera stratixiv}
	set family_all_lib_list(stratixiv,vhdl) { altera lpm sgate altera_mf stratixiv_hssi stratixiv_pcie_hip stratixiv}
	set family_specific_lib_list(stratixiv,vhdl) { stratixiv_hssi stratixiv_pcie_hip stratixiv}
	set family_gate_lib_list(cycloneiiils,verilog) { altera_ver cycloneiiils_ver}
	set family_all_lib_list(cycloneiiils,verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver cycloneiiils_ver}
	set family_specific_lib_list(cycloneiiils,verilog) { cycloneiiils_ver}
	set family_gate_lib_list(cycloneiiils,vhdl) { altera cycloneiiils}
	set family_all_lib_list(cycloneiiils,vhdl) { altera lpm sgate altera_mf cycloneiiils}
	set family_specific_lib_list(cycloneiiils,vhdl) { cycloneiiils}
	set family_independent_lib_list(verilog) { altera_ver lpm_ver sgate_ver altera_mf_ver}
	set family_independent_lib_list(vhdl) { altera lpm sgate altera_mf}

	

	set family_list(acex1k,family)	"[get_dstr_string -family acex1k]"
	set family_list(apex20kc,family)	"[get_dstr_string -family apex20kc]"
	set family_list(apex20ke,family)	"[get_dstr_string -family apex20ke]"
	set family_list(apexii,family)	"[get_dstr_string -family apexii]"
	set family_list(arriagx,family)	"[get_dstr_string -family arriagx]"
	set family_list(arriaiigx,family)	"[get_dstr_string -family arriaii]"
	set family_list(cyclone,family)	"[get_dstr_string -family cyclone]"
	set family_list(cycloneii,family)	"[get_dstr_string -family cycloneii]"
	set family_list(cycloneiii,family)	"[get_dstr_string -family cycloneiii]"
	set family_list(flex10k,family)	"[get_dstr_string -family flex10k]"
	set family_list(flex10ka,family)	"[get_dstr_string -family flex10ka]"
	set family_list(flex10ke,family)	"[get_dstr_string -family flex10ke]"
	set family_list(flex6000,family)	"[get_dstr_string -family flex6000]"
	set family_list(hardcopyii,family)	"[get_dstr_string -family hardcopyii]"
	set family_list(hardcopyiii,family)	"[get_dstr_string -family hardcopyiii]"
	set family_list(hardcopyiv,family)	"[get_dstr_string -family hardcopyiv]"
	set family_list(max3000a,family)	"[get_dstr_string -family max3000a]"
	set family_list(max7000ae,family)	"[get_dstr_string -family max7000ae]"
	set family_list(max7000b,family)	"[get_dstr_string -family max7000b]"
	set family_list(max7000s,family)	"[get_dstr_string -family max7000s]"
	set family_list(maxii,family)	"[get_dstr_string -family maxii]"
	set family_list(stratix,family)	"[get_dstr_string -family stratix]"
	set family_list(stratixgx,family)	"[get_dstr_string -family stratixgx]"
	set family_list(stratixii,family)	"[get_dstr_string -family stratixii]"
	set family_list(stratixiigx,family)	"[get_dstr_string -family stratixiigx]"
	set family_list(stratixiii,family)	"[get_dstr_string -family stratixiii]"
	set family_list(stratixiv,family)	"[get_dstr_string -family stratixiv]"
	set family_list(cycloneiiils,family)	"[get_dstr_string -family tarpon]"

}


proc ::quartus::sim_lib_info::get_sim_models { lib_list_name hdl_version} {
	variable lib_src_list
	upvar $lib_list_name my_lib_list
	set my_file_list ""
	set sim_lib_path $::quartus(eda_libpath)sim_lib
	foreach lib $my_lib_list  {
		set src_list $lib_src_list($lib)
		set lib_name $lib

		set new_src_list ""

		foreach src_pair $src_list {
			set file_name [lindex $src_pair 0]

			regsub {<LIBPATH>} $file_name $sim_lib_path new_file_name
			
			if { $hdl_version != "" } {
				set new_hdl_version $hdl_version
			} else {
				set new_hdl_version [lindex $src_pair 1]
			}

			set new_src_pair [list $new_file_name $new_hdl_version]

			lappend new_src_list $new_src_pair
		}

		set src_list $lib_name
		lappend src_list $new_src_list

		lappend my_file_list $src_list	
	}

	return $my_file_list
}

proc ::quartus::sim_lib_info::get_sim_models_for_family {family language rtl_sim { hdl_version ""} } {
	variable family_all_lib_list
	variable family_gate_lib_list

	set my_lib_list ""

	if { $rtl_sim == 0 } {
		set my_lib_list $family_gate_lib_list($family,$language)
	} else {
		set my_lib_list $family_all_lib_list($family,$language)
	}

	set my_file_list [get_sim_models my_lib_list $hdl_version]

	return $my_file_list

}

proc ::quartus::sim_lib_info::get_family_independent_sim_models {language { hdl_version ""} } {
	variable family_independent_lib_list

	set my_lib_list ""

	set my_lib_list $family_independent_lib_list($language)

	set my_file_list [get_sim_models my_lib_list $hdl_version]

	return $my_file_list

}

proc ::quartus::sim_lib_info::get_family_specific_sim_models { family language { hdl_version ""} } {
	variable family_specific_lib_list

	set my_lib_list ""

	set my_lib_list $family_specific_lib_list($family,$language)

	set my_file_list [get_sim_models my_lib_list $hdl_version]

	return $my_file_list

}

proc ::quartus::sim_lib_info::get_sim_models_for_library { library { hdl_version ""} } {
	variable lib_list

	set my_lib_list $lib_list($library)

	set my_file_list [get_sim_models my_lib_list $hdl_version]

	return $my_file_list
}

proc ::quartus::sim_lib_info::is_family_supported { family } {
	variable family_all_lib_list

	set status 0

	set language "verilog"

	if { [info exists family_all_lib_list($family,$language) ] } {
		set status 1
	} else {
		set status 0
	}

	return $status

}

proc ::quartus::sim_lib_info::get_supported_family_list {} {
	variable family_list
	
	return [array get family_list]
	
}

