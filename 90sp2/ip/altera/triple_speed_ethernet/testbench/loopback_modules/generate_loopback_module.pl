###################################################################################################
#
# Author:
# ttchong
# Script: 
# generate_loopback_module.pl
# Description:
# Generate the loopback module on the Ethernet side interface.
# Depending on the TSE variation, 
# 1. it generates etither MII/GMII/RGMII/TBI/SERIAL loopback connection.
# 2. it pulls  output signals that control the operation of TSE to either high or low.
# 3. it leaves some informational/unimportant input signals dangling on the dummy port
###################################################################################################
###################################################################################################
#
# Command Line Argument 
# Command Format:
# --VARIATION_NAME= --IS_VERILOG= --NUMBER_OF_CHANNEL= --IS_FIFOLESS= --IS_MAC= --IS_PCS= --IS_PMA= --IS_GMII= --IS_POWERDOWN= --IS_SMALLMAC= --IS_SMALLMAC_GIGE= --IS_HALFDUPLEX= --IS_GXB= --IS_ALT_RECONFIG= --OUTPUT_DIRECTORY=
#
###################################################################################################
my %command_hash;
my $key;
my $value;
foreach my $command (@ARGV)
{
    print ("Command : $command \n");
    next unless ($command =~ /\-\-(\w+)\=(.*)/);
    
    $key = $1;
    $value = $2;
    
    $value =~ s/\\|\/$//; # crush directory structures which end with
    print (  $0 . ":" .  "Info: module processing argument \"$key=$value\"\n");
    $command_hash{$key} = $value;
};
$VARIATION_NAME = $command_hash{"VARIATION_NAME"};
$IS_VERILOG = $command_hash{"IS_VERILOG"}; 
$NUMBER_OF_CHANNEL = $command_hash{"NUMBER_OF_CHANNEL"}; 
$IS_FIFOLESS = $command_hash{"IS_FIFOLESS"}; 
$IS_MAC = $command_hash{"IS_MAC"}; 
$IS_PCS = $command_hash{"IS_PCS"}; 
$IS_PMA = $command_hash{"IS_PMA"}; 
$IS_GMII = $command_hash{"IS_GMII"}; 
$IS_POWERDOWN = $command_hash{"IS_POWERDOWN"}; 
$IS_SMALLMAC = $command_hash{"IS_SMALLMAC"}; 
$IS_SMALLMAC_GIGE = $command_hash{"IS_SMALLMAC_GIGE"}; 
$OUTPUT_DIRECTORY = $command_hash{"OUTPUT_DIRECTORY"};
$IS_HALFDUPLEX = $command_hash{"IS_HALFDUPLEX"};
$IS_GXB = $command_hash{"IS_GXB"};
$IS_ALT_RECONFIG = $command_hash{"IS_ALT_RECONFIG"};
###################################################################################################
#
# Parameter Validation
#
###################################################################################################
if($VARIATION_NAME eq "" || $IS_VERILOG eq "" || $NUMBER_OF_CHANNEL eq "" || $IS_FIFOLESS eq "" || $IS_MAC eq "" || $IS_PCS eq "" || $IS_PMA eq "" || $IS_GMII eq "" || $IS_POWERDOWN eq "" || $IS_SMALLMAC eq "" || $IS_SMALLMAC_GIGE eq "" || $IS_HALFDUPLEX eq ""){
	printf STDERR "Error: TSE loopback module generation failed on undefined parameter\n";
	exit -1;
}
if($IS_MAC == 0 && $IS_PCS == 0){
	printf STDERR "Error: TSE loopback module generation failed on invalid parameter, must be a MAC or a PCS\n";
	exit -1;
}
if($IS_FIFOLESS == 1 && $IS_MAC == 0 && $IS_PCS == 1 ){
	printf STDERR "Error: TSE loopback module generation failed on invalid parameter, PCS only core can not be fifoless\n";
	exit -1;
}
if($NUMBER_OF_CHANNEL == 0  && $IS_FIFOLESS == 0 ){
    #LEGACY/non-FIFOLESS MAC may have NUMBER_OF_CHANNEL=0 or 1, both of them is the same
	$NUMBER_OF_CHANNEL = 1;
}
if($NUMBER_OF_CHANNEL == 0  && $IS_FIFOLESS == 1 ){
	printf STDERR "Error: TSE loopback module generation failed on invalid parameter, fifoles variation should have 1 or more channels but not 0 channel\n";
	exit -1;
}
if($NUMBER_OF_CHANNEL > 1  && $IS_FIFOLESS == 0 ){
	printf STDERR "Error: TSE loopback module generation failed on invalid parameter, non-fifoles variation can not be multi-channel\n";
	exit -1;
}
if($IS_FIFOLESS == 1 && !($NUMBER_OF_CHANNEL == 1 || $NUMBER_OF_CHANNEL == 4 || $NUMBER_OF_CHANNEL == 8 || $NUMBER_OF_CHANNEL == 12 || $NUMBER_OF_CHANNEL == 16 || $NUMBER_OF_CHANNEL == 20 || $NUMBER_OF_CHANNEL == 24)){
	printf STDERR "Error: TSE loopback module generation failed on invalid parameter, number of channel supported is only 1, 4, 8, 12, 16, 20, 24\n";
	exit -1;
}
if($IS_PCS == 0 && $IS_PMA == 1){
	printf STDERR "Error: TSE loopback module generation failed on invalid parameter, only PCS variation can have PMA\n";
	exit -1;
}
if($IS_PMA == 0 && $IS_GXB != 0){
	printf STDERR "Error: TSE loopback module generation failed on invalid parameter, only PMA variation can have GXB\n";
	exit -1;
}
if($IS_GXB == 0 && $IS_ALT_RECONFIG == 1){
	printf STDERR "Error: TSE loopback module generation failed on invalid parameter, only PMA with GXB variation can have ALT_RECONFIG support\n";
	exit -1;
}
if($IS_PMA == 0 && $IS_POWERDOWN  == 1 ){
	printf STDERR "Error: TSE loopback module generation failed on invalid parameter, only PMA variation can have Powerdown signal exported\n";
	exit -1;
}
if($IS_SMALLMAC == 1 && $IS_MAC == 0){
	printf STDERR "Error: TSE loopback module generation failed on invalid parameter, SMALL MAC variation must be a MAC\n";
	exit -1;	
}
if($IS_SMALLMAC == 1 && $IS_MAC == 1 && $IS_PCS == 1 ){
	printf STDERR "Error: TSE loopback module generation failed on invalid parameter, only SMALL MAC variation can not be a PCS\n";
	exit -1;	
}
if($IS_SMALLMAC == 1 && $IS_MAC == 1 && $IS_FIFOLESS == 1 ){
	printf STDERR "Error: TSE loopback module generation failed on invalid parameter, only SMALL MAC variation can not be a fifoless\n";
	exit -1;	
}
if($IS_MAC == 0 && $IS_PCS == 1 ){
	exit 0;
}
###################################################################################################
#
# Parameter Derivation
#
###################################################################################################
if ($OUTPUT_DIRECTORY eq ""){
        $OUTPUT_DIRECTORY = `pwd`;
	chomp($OUTPUT_DIRECTORY);
}
$SEPARATOR = ""; 
if ($IS_FIFOLESS == 1){
	$SEPARATOR = "_"; 
}
$END_PORT_SEPARATOR = "";
if ($IS_VERILOG == 1){
	$END_PORT_SEPARATOR = ","; 
}else{
	$END_PORT_SEPARATOR = ";"; 
}
$COMMENT_MART = "";
if ($IS_VERILOG == 1){
	$COMMENT_MARK = "//";
}else{
	$COMMENT_MARK = "--";
}
$DATE_TIME = localtime();                 
###################################################################################################
#
# FILE OPEN
#
###################################################################################################
$FILE = "";
if ($IS_VERILOG == 1){
   open(MYOUTFILE, ">" . $OUTPUT_DIRECTORY . "/" . $VARIATION_NAME . "_loopback.v" ); #open for write, overwrite 
}else{
   open(MYOUTFILE, ">" . $OUTPUT_DIRECTORY . "/" . $VARIATION_NAME . "_loopback.vhd"); # open for write, overwrite
}
$FILE = MYOUTFILE;
###################################################################################################
#
# GENERATION START 
#
###################################################################################################
printf $FILE $COMMENT_MARK . " #####################################################################################\n";
printf $FILE $COMMENT_MARK . " # Copyright (C) 1991-2008 Altera Corporation\n";
printf $FILE $COMMENT_MARK . " # Any  megafunction  design,  and related netlist (encrypted  or  decrypted),\n";
printf $FILE $COMMENT_MARK . " # support information,  device programming or simulation file,  and any other\n";
printf $FILE $COMMENT_MARK . " # associated  documentation or information  provided by  Altera  or a partner\n";
printf $FILE $COMMENT_MARK . " # under  Altera's   Megafunction   Partnership   Program  may  be  used  only\n";
printf $FILE $COMMENT_MARK . " # to program  PLD  devices (but not masked  PLD  devices) from  Altera.   Any\n";
printf $FILE $COMMENT_MARK . " # other  use  of such  megafunction  design,  netlist,  support  information,\n";
printf $FILE $COMMENT_MARK . " # device programming or simulation file,  or any other  related documentation\n";
printf $FILE $COMMENT_MARK . " # or information  is prohibited  for  any  other purpose,  including, but not\n";
printf $FILE $COMMENT_MARK . " # limited to  modification,  reverse engineering,  de-compiling, or use  with\n";
printf $FILE $COMMENT_MARK . " # any other  silicon devices,  unless such use is  explicitly  licensed under\n";
printf $FILE $COMMENT_MARK . " # a separate agreement with  Altera  or a megafunction partner.  Title to the\n";
printf $FILE $COMMENT_MARK . " # intellectual property,  including patents,  copyrights,  trademarks,  trade\n";
printf $FILE $COMMENT_MARK . " # secrets,  or maskworks,  embodied in any such megafunction design, netlist,\n";
printf $FILE $COMMENT_MARK . " # support  information,  device programming or simulation file,  or any other\n";
printf $FILE $COMMENT_MARK . " # related documentation or information provided by  Altera  or a megafunction\n";
printf $FILE $COMMENT_MARK . " # partner, remains with Altera, the megafunction partner, or their respective\n";
printf $FILE $COMMENT_MARK . " # licensors. No other licenses, including any licenses needed under any third\n";
printf $FILE $COMMENT_MARK . " # party's intellectual property, are provided herein.\n";
printf $FILE $COMMENT_MARK . " #####################################################################################\n";
printf $FILE "\n";
printf $FILE $COMMENT_MARK . " #####################################################################################\n";
printf $FILE $COMMENT_MARK . " # Loopback module for SOPC system simulation with\n";
printf $FILE $COMMENT_MARK . " # Altera Triple Speed Ethernet (TSE) Megacore\n";
printf $FILE $COMMENT_MARK . " #\n";
printf $FILE $COMMENT_MARK . " # Generated at " . $DATE_TIME . " as a SOPC Builder component\n";
printf $FILE $COMMENT_MARK . " #\n";
printf $FILE $COMMENT_MARK . " #####################################################################################\n";
printf $FILE $COMMENT_MARK . " # This is a module used to provide external loopback on the TSE megacore by supplying\n";
printf $FILE $COMMENT_MARK . " # necessary clocks and default signal values on the network side interface \n";
printf $FILE $COMMENT_MARK . " # (GMII/MII/TBI/Serial)\n";
printf $FILE $COMMENT_MARK . " #\n";
printf $FILE $COMMENT_MARK . " #   - by default this module generate clocks for operation in Gigabit mode that is\n";
printf $FILE $COMMENT_MARK . " #     of 8 ns clock period\n";
printf $FILE $COMMENT_MARK . " #   - no support for forcing collision detection and carrier sense in MII mode\n";
printf $FILE $COMMENT_MARK . " #     the mii_col and mii_crs signal always pulled to zero\n";
printf $FILE $COMMENT_MARK . " #   - you are recomment to set the the MAC operation mode using register access \n";
printf $FILE $COMMENT_MARK . " #     rather than directly pulling the control signals\n";
printf $FILE $COMMENT_MARK . " #\n";
printf $FILE $COMMENT_MARK . " #####################################################################################\n";
if($IS_VERILOG == 1){
	###################################################################################################
	#
	#Verilog
	#
	###################################################################################################
	###################################################################################################
	#
	# Verilog Configuration and Definition
	#
	###################################################################################################
	printf $FILE "`timescale 1ns / 1ps\n";
	printf $FILE "\n";
	###################################################################################################
	#
	# Module start
	#
	###################################################################################################
	printf $FILE "module " . $VARIATION_NAME . "_loopback (\n";
		###################################################################################################
		#
		# Port Generation(Once)
		#
		###################################################################################################
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 1){
			#printf $FILE "\n";	
		}	
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0){
			#printf $FILE "\n";
		}	
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 0 && $IS_POWERDOWN == 0){
			#printf $FILE "\n";
		}	
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 1 && $IS_POWERDOWN == 0){
			printf $FILE "  ref_clk,\n"; 
			printf $FILE "\n";
		}	
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 1 && $IS_POWERDOWN == 1){
			printf $FILE "  ref_clk,\n"; 
			printf $FILE "\n";
		}
		if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 1 && $IS_SMALLMAC_GIGE == 1){
			#printf $FILE "\n";	
		}	
		if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0 && $IS_SMALLMAC_GIGE == 1){
			#printf $FILE "\n";
		}
		if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0 && $IS_SMALLMAC_GIGE == 0){
			#printf $FILE "\n";
		}			
		printf $FILE "\n";
		###################################################################################################
		#
		# Port Generation(Per Channel)
		#
		###################################################################################################
		$i = 0;
		$TEMP_END_PORT_SEPARATOR = "";
		$TEMP_I = "";
		for($i; $i < $NUMBER_OF_CHANNEL; $i++){
			if($i == $NUMBER_OF_CHANNEL-1){
				$TEMP_END_PORT_SEPARATOR = "";
			}else{
				$TEMP_END_PORT_SEPARATOR = $END_PORT_SEPARATOR;
			}
			if($IS_FIFOLESS == 0 && $NUMBER_OF_CHANNEL == 1){
				$TEMP_I = "";
			}else{
				$TEMP_I = $i;
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 1){
				printf $FILE "  rx_clk" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  tx_clk" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  m_tx_d" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  m_tx_en" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  m_tx_err" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  m_rx_d" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  m_rx_en" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  m_rx_err" . $SEPARATOR . $TEMP_I . ",\n";
				if ($IS_HALFDUPLEX == 1) {
					printf $FILE "  m_rx_col" . $SEPARATOR . $TEMP_I . ",\n";
					printf $FILE "  m_rx_crs" . $SEPARATOR . $TEMP_I . ",\n";
				}
				printf $FILE "  gm_tx_d" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  gm_tx_en" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  gm_tx_err" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  gm_rx_d" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  gm_rx_dv" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  gm_rx_err" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  set_1000" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  set_10" . $SEPARATOR . $TEMP_I . $TEMP_END_PORT_SEPARATOR . "\n";
				printf $FILE "\n";	
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0){
				printf $FILE "  rx_clk" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  tx_clk" . $SEPARATOR . $TEMP_I . ",\n";
				#printf $FILE "  m_tx_d" . $SEPARATOR . $TEMP_I . ",\n";
				#printf $FILE "  m_tx_en" . $SEPARATOR . $TEMP_I . ",\n";
				#printf $FILE "  m_tx_err" . $SEPARATOR . $TEMP_I . ",\n";
				#printf $FILE "  m_rx_d" . $SEPARATOR . $TEMP_I . ",\n";
				#printf $FILE "  m_rx_en" . $SEPARATOR . $TEMP_I . ",\n";
				#printf $FILE "  m_rx_err" . $SEPARATOR . $TEMP_I . ",\n";
				#printf $FILE "  m_rx_col" . $SEPARATOR . $TEMP_I . ",\n";
				#printf $FILE "  m_rx_crs" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  rgmii_out" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  tx_control" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  rgmii_in" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  rx_control" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  set_1000" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  set_10" . $SEPARATOR . $TEMP_I . $TEMP_END_PORT_SEPARATOR . "\n";
				printf $FILE "\n";
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 0 ){
				if($IS_FIFOLESS == 1 && $i == 0){
					printf $FILE "  ref_clk" . ",\n";
				}
				printf $FILE "  tbi_rx_clk" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  tbi_tx_clk" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  tbi_tx_d" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  tbi_rx_d" . $SEPARATOR . $TEMP_I . $TEMP_END_PORT_SEPARATOR . "\n";
				printf $FILE "\n";
			}		
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 1 && $IS_POWERDOWN == 0){
				if(($IS_GXB != 0) && ($IS_ALT_RECONFIG == 1)){
					printf $FILE "  reconfig_clk" . $SEPARATOR . $TEMP_I . ",\n";
					printf $FILE "  reconfig_togxb" . $SEPARATOR . $TEMP_I . ",\n";
					printf $FILE "  reconfig_fromgxb" . $SEPARATOR . $TEMP_I . ",\n";
				}
				printf $FILE "  txp" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  rxp" . $SEPARATOR . $TEMP_I . $TEMP_END_PORT_SEPARATOR . "\n";
				printf $FILE "\n";
			}	
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 1 && $IS_POWERDOWN == 1){
				if(($IS_GXB != 0) && ($IS_ALT_RECONFIG == 1)){
					printf $FILE "  reconfig_clk" . $SEPARATOR . $TEMP_I . ",\n";
					printf $FILE "  reconfig_togxb" . $SEPARATOR . $TEMP_I . ",\n";
					printf $FILE "  reconfig_fromgxb" . $SEPARATOR . $TEMP_I . ",\n";
				}
				printf $FILE "  txp" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  rxp" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  pcs_pwrdn_out" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  gxb_pwrdn_in" . $SEPARATOR . $TEMP_I . $TEMP_END_PORT_SEPARATOR . "\n";
				printf $FILE "\n";
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 1 && $IS_SMALLMAC_GIGE == 1){
				printf $FILE "  rx_clk" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  tx_clk" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  gm_tx_d" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  gm_tx_en" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  gm_tx_err" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  gm_rx_d" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  gm_rx_dv" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  gm_rx_err" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  set_1000" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  set_10" . $SEPARATOR . $TEMP_I . $TEMP_END_PORT_SEPARATOR . "\n";				
				printf $FILE "\n";	
			}	
			if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0 && $IS_SMALLMAC_GIGE == 1){
				printf $FILE "  rx_clk" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  tx_clk" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  rgmii_out" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  tx_control" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  rgmii_in" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  rx_control" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  set_1000" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  set_10" . $SEPARATOR . $TEMP_I . $TEMP_END_PORT_SEPARATOR . "\n";
				printf $FILE "\n";
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0 && $IS_SMALLMAC_GIGE == 0){
				printf $FILE "  rx_clk" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  tx_clk" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  m_tx_d" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  m_tx_en" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  m_tx_err" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  m_rx_d" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  m_rx_en" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  m_rx_err" . $SEPARATOR . $TEMP_I . ",\n";
				if ($IS_HALFDUPLEX == 1) {
					printf $FILE "  m_rx_col" . $SEPARATOR . $TEMP_I . ",\n";
					printf $FILE "  m_rx_crs" . $SEPARATOR . $TEMP_I . ",\n";
				}
				printf $FILE "  set_1000" . $SEPARATOR . $TEMP_I . ",\n";
				printf $FILE "  set_10" . $SEPARATOR . $TEMP_I . $TEMP_END_PORT_SEPARATOR . "\n";
				printf $FILE "\n";
			}	
		}
		printf $FILE "\n";
	###################################################################################################
	#
	# Module Port List Declaration end
	#
	###################################################################################################	
	printf $FILE ");\n";
	printf $FILE "\n";
	###################################################################################################
	#
	# Port In/Out Declaration
	#
	###################################################################################################	
    	###################################################################################################
		#
		# Port In/OutGeneration(Once)
		#
		###################################################################################################
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 1){
			#printf $FILE "\n";	
		}	
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0){
			#printf $FILE "\n";
		}
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 0){
			#printf $FILE "\n";
		}	
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 1 && $IS_POWERDOWN == 0){
			printf $FILE "  output ref_clk;\n";
			printf $FILE "\n";
		}	
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 1 && $IS_POWERDOWN == 1){
			printf $FILE "  output ref_clk;\n";
			printf $FILE "\n";
		}
		if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 1 && $IS_SMALLMAC_GIGE == 1){
			#printf $FILE "\n";	
		}	
		if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0 && $IS_SMALLMAC_GIGE == 1){
			#printf $FILE "\n";
		}
		if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0 && $IS_SMALLMAC_GIGE == 0){
			#printf $FILE "\n";
		}	
		printf $FILE "\n";
		###################################################################################################
		#
		# Port In/Out Generation(Per Channel)
		#
		###################################################################################################
		$i = 0;
		$TEMP_I = "";
		for($i; $i < $NUMBER_OF_CHANNEL; $i++){
			if($IS_FIFOLESS == 0 && $NUMBER_OF_CHANNEL == 1){
				$TEMP_I = "";
			}else{
				$TEMP_I = $i;
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 1){
				printf $FILE "  output rx_clk" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output tx_clk" . $SEPARATOR . $TEMP_I . ";\n";  
				printf $FILE "  input [3:0] m_tx_d" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  input m_tx_en" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  input m_tx_err" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output [3:0] m_rx_d" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output m_rx_en" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output m_rx_err" . $SEPARATOR . $TEMP_I . ";\n";
				if ($IS_HALFDUPLEX == 1) {
					printf $FILE "  output m_rx_col" . $SEPARATOR . $TEMP_I . ";\n";
					printf $FILE "  output m_rx_crs" . $SEPARATOR . $TEMP_I . ";\n";
				}
				printf $FILE "  input [7:0] gm_tx_d" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  input gm_tx_en" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  input gm_tx_err" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output [7:0] gm_rx_d" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output gm_rx_dv" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output gm_rx_err" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output set_10" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output set_1000" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "\n";	
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0){
				printf $FILE "  output rx_clk" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output tx_clk" . $SEPARATOR . $TEMP_I . ";\n";
				#printf $FILE "  input [3:0] m_tx_d" . $SEPARATOR . $TEMP_I . ";\n";
				#printf $FILE "  input m_tx_en" . $SEPARATOR . $TEMP_I . ";\n";
				#printf $FILE "  input m_tx_err" . $SEPARATOR . $TEMP_I . ";\n";
				#printf $FILE "  output [3:0] m_rx_d" . $SEPARATOR . $TEMP_I . ";\n";
				#printf $FILE "  output m_rx_en" . $SEPARATOR . $TEMP_I . ";\n";
				#printf $FILE "  output m_rx_err" . $SEPARATOR . $TEMP_I . ";\n";
				#printf $FILE "  output m_rx_col" . $SEPARATOR . $TEMP_I . ";\n";
				#printf $FILE "  output m_rx_crs" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  input [3:0] rgmii_out" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  input tx_control" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output [3:0] rgmii_in" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output rx_control" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output set_1000" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output set_10" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "\n";
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 0){
				if($IS_FIFOLESS == 1 && $i == 0){
					printf $FILE "  output ref_clk" . ";\n";
				}
				printf $FILE "  output tbi_rx_clk" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output tbi_tx_clk" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  input [9:0] tbi_tx_d" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output [9:0] tbi_rx_d" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "\n";
			}		
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 1 && $IS_POWERDOWN == 0){
				if(($IS_GXB == 2) && ($IS_ALT_RECONFIG == 1)){
					printf $FILE "  output reconfig_clk" . $SEPARATOR . $TEMP_I . ";\n";
					printf $FILE "  output [2:0] reconfig_togxb" . $SEPARATOR . $TEMP_I . ";\n";
					printf $FILE "  input reconfig_fromgxb" . $SEPARATOR . $TEMP_I . ";\n";
				}
				if(($IS_GXB == 4) && ($IS_ALT_RECONFIG == 1)){
					printf $FILE "  output reconfig_clk" . $SEPARATOR . $TEMP_I . ";\n";
					printf $FILE "  output [3:0] reconfig_togxb" . $SEPARATOR . $TEMP_I . ";\n";
					printf $FILE "  input [16:0] reconfig_fromgxb" . $SEPARATOR . $TEMP_I . ";\n";
				}
				printf $FILE "  input txp" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output rxp" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "\n";
			}	
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 1 && $IS_POWERDOWN == 1){
				if(($IS_GXB == 2) && ($IS_ALT_RECONFIG == 1)){
					printf $FILE "  output reconfig_clk" . $SEPARATOR . $TEMP_I . ";\n";
					printf $FILE "  output [2:0] reconfig_togxb" . $SEPARATOR . $TEMP_I . ";\n";
					printf $FILE "  input reconfig_fromgxb" . $SEPARATOR . $TEMP_I . ";\n";
				}
				if(($IS_GXB == 4) && ($IS_ALT_RECONFIG == 1)){
					printf $FILE "  output reconfig_clk" . $SEPARATOR . $TEMP_I . ";\n";
					printf $FILE "  output [3:0] reconfig_togxb" . $SEPARATOR . $TEMP_I . ";\n";
					printf $FILE "  input [16:0] reconfig_fromgxb" . $SEPARATOR . $TEMP_I . ";\n";
				}
				printf $FILE "  input txp" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output rxp" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  input pcs_pwrdn_out" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output gxb_pwrdn_in" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "\n";
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 1 && $IS_SMALLMAC_GIGE == 1){
				printf $FILE "  output rx_clk" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output tx_clk" . $SEPARATOR . $TEMP_I . ";\n";  
				printf $FILE "  input [7:0] gm_tx_d" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  input gm_tx_en" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  input gm_tx_err" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output [7:0] gm_rx_d" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output gm_rx_dv" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output gm_rx_err" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output set_10" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output set_1000" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "\n";	
			}	
			if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0 && $IS_SMALLMAC_GIGE == 1){
				printf $FILE "  output rx_clk" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output tx_clk" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  input [3:0] rgmii_out" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  input tx_control" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output [3:0] rgmii_in" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output rx_control" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output set_1000" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output set_10" . $SEPARATOR . $TEMP_I . ";\n";			
				printf $FILE "\n";
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0 && $IS_SMALLMAC_GIGE == 0){
				printf $FILE "  output rx_clk" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output tx_clk" . $SEPARATOR . $TEMP_I . ";\n";  
				printf $FILE "  input [3:0] m_tx_d" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  input m_tx_en" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  input m_tx_err" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output [3:0] m_rx_d" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output m_rx_en" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output m_rx_err" . $SEPARATOR . $TEMP_I . ";\n";
				if ($IS_HALFDUPLEX == 1) {
					printf $FILE "  output m_rx_col" . $SEPARATOR . $TEMP_I . ";\n";
					printf $FILE "  output m_rx_crs" . $SEPARATOR . $TEMP_I . ";\n";
				}
				printf $FILE "  output set_10" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  output set_1000" . $SEPARATOR . $TEMP_I . ";\n";			
				printf $FILE "\n";
			}	
		}
		printf $FILE "\n";
	###################################################################################################
	#
	# Clock Generation
	#
	###################################################################################################
	printf $FILE "  reg clk_tmp;\n";
	printf $FILE "  initial\n";
	printf $FILE "     clk_tmp <= 1'b0;\n";
	printf $FILE "  always\n";
	printf $FILE "     #4 clk_tmp <= ~clk_tmp;\n";
	
	if($IS_MAC == 1 && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0){
		if($IS_SMALLMAC == 1 && $IS_SMALLMAC_GIGE == 0){
		
		} else {
			printf $FILE "  reg clk_shift;\n";
			printf $FILE "  reg start = 1'b0;\n";
			printf $FILE "  always\n";
			printf $FILE "     begin\n";
			printf $FILE "     if(start == 1'b0)\n";
			printf $FILE "        begin\n";
			printf $FILE "        clk_shift <= 1'b0;\n";
			printf $FILE "        #1 start <= 1'b1;\n";
			printf $FILE "        end\n";
			printf $FILE "     else\n";
			printf $FILE "        begin\n";
			printf $FILE "        #4 clk_shift <= ~clk_shift;\n";
			printf $FILE "     end\n";
			printf $FILE "  end\n";
		}
	}


		###################################################################################################
		#
		# Logic Generation(Once)
		#
		###################################################################################################
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 1){
			#printf $FILE "\n";	
		}	
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0){
			#printf $FILE "\n";
		}
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 0){
			#printf $FILE "\n";
		}	
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 1 && $IS_POWERDOWN == 0){
			printf $FILE "  assign ref_clk = clk_tmp;\n";
			printf $FILE "\n";
		}	
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 1 && $IS_POWERDOWN == 1){
			printf $FILE "  assign ref_clk = clk_tmp;\n";
			printf $FILE "\n";
		}
		if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 1 && $IS_SMALLMAC_GIGE == 1){
			#printf $FILE "\n";	
		}	
		if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0 && $IS_SMALLMAC_GIGE == 1){
			#printf $FILE "\n";
		}
		if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0 && $IS_SMALLMAC_GIGE == 0){
			#printf $FILE "\n";
		}	
		printf $FILE "\n";
		###################################################################################################
		#
		# Logic Generation(Per Channel)
		#
		###################################################################################################
		$i = 0;
		$TEMP_I = "";
		for($i; $i < $NUMBER_OF_CHANNEL; $i++){
			if($IS_FIFOLESS == 0 && $NUMBER_OF_CHANNEL == 1){
				$TEMP_I = "";
			}else{
				$TEMP_I = $i;
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 1){
				printf $FILE "  assign rx_clk" . $SEPARATOR . $TEMP_I . " = clk_tmp;\n";
				printf $FILE "  assign tx_clk" . $SEPARATOR . $TEMP_I . " = clk_tmp;\n";
				printf $FILE "  assign m_rx_d" . $SEPARATOR . $TEMP_I . "=m_tx_d" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  assign m_rx_en" . $SEPARATOR . $TEMP_I . "=m_tx_en" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  assign m_rx_err" . $SEPARATOR . $TEMP_I . "=m_tx_err" . $SEPARATOR . $TEMP_I . ";\n";
				if ($IS_HALFDUPLEX == 1) {
					printf $FILE "  assign m_rx_col" . $SEPARATOR . $TEMP_I . "=0;\n";
					printf $FILE "  assign m_rx_crs" . $SEPARATOR . $TEMP_I . "=0;\n";
				}
				printf $FILE "  assign gm_rx_d" . $SEPARATOR . $TEMP_I . "=gm_tx_d" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  assign gm_rx_dv" . $SEPARATOR . $TEMP_I . "=gm_tx_en" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  assign gm_rx_err" . $SEPARATOR . $TEMP_I . "=gm_tx_err" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  assign set_1000" . $SEPARATOR . $TEMP_I . "=0;\n";
				printf $FILE "  assign set_10" . $SEPARATOR . $TEMP_I . "=0;\n";
				printf $FILE "\n";	
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0){
				printf $FILE "  assign rx_clk" . $SEPARATOR . $TEMP_I . " = clk_shift;\n";
				printf $FILE "  assign tx_clk" . $SEPARATOR . $TEMP_I . " = clk_tmp;\n";
				# printf $FILE "  assign m_rx_d" . $SEPARATOR . $TEMP_I . "=m_tx_d" . $SEPARATOR . $TEMP_I . ";\n";
				# printf $FILE "  assign m_rx_en" . $SEPARATOR . $TEMP_I . "=m_tx_en" . $SEPARATOR . $TEMP_I . ";\n";
				# printf $FILE "  assign m_rx_err" . $SEPARATOR . $TEMP_I . "=m_tx_err" . $SEPARATOR . $TEMP_I . ";\n";
				# printf $FILE "  assign m_rx_col" . $SEPARATOR . $TEMP_I . "=0;\n";
				# printf $FILE "  assign m_rx_crs" . $SEPARATOR . $TEMP_I . "=0;\n";
				printf $FILE "  assign rgmii_in" . $SEPARATOR . $TEMP_I . "=rgmii_out" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  assign rx_control" . $SEPARATOR . $TEMP_I . "=tx_control" . $SEPARATOR . $TEMP_I . ";\n";				
				printf $FILE "  assign set_1000" . $SEPARATOR . $TEMP_I . "=0;\n";
				printf $FILE "  assign set_10" . $SEPARATOR . $TEMP_I . "=0;\n";
				printf $FILE "\n";
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 0){
				if($IS_FIFOLESS == 1 && $i == 0){
					printf $FILE "  assign ref_clk = clk_tmp;\n";
				}
				printf $FILE "  assign tbi_rx_clk" . $SEPARATOR . $TEMP_I . " = clk_tmp;\n";
				printf $FILE "  assign tbi_tx_clk" . $SEPARATOR . $TEMP_I . " = clk_tmp;\n";
				printf $FILE "  assign tbi_rx_d" . $SEPARATOR . $TEMP_I . "=tbi_tx_d" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "\n";
			}		
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 1 && $IS_POWERDOWN == 0){
				if(($IS_GXB == 2) && ($IS_ALT_RECONFIG == 1)){
					printf $FILE "  assign reconfig_clk" . $SEPARATOR . $TEMP_I . "= 0;\n";
					printf $FILE "  assign reconfig_togxb" . $SEPARATOR . $TEMP_I . "= 3'b010;\n";					
				}
				if(($IS_GXB == 4) && ($IS_ALT_RECONFIG == 1)){
					printf $FILE "  assign reconfig_clk" . $SEPARATOR . $TEMP_I . "= 0;\n";
					printf $FILE "  assign reconfig_togxb" . $SEPARATOR . $TEMP_I . "= 4'b0010;\n";					
				}
				printf $FILE "  assign rxp" . $SEPARATOR . $TEMP_I . "=txp" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "\n";
			}	
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 1 && $IS_POWERDOWN == 1){
				if(($IS_GXB == 2) && ($IS_ALT_RECONFIG == 1)){
					printf $FILE "  assign reconfig_clk" . $SEPARATOR . $TEMP_I . "= 0;\n";
					printf $FILE "  assign reconfig_togxb" . $SEPARATOR . $TEMP_I . "= 3'b010;\n";
				}
				if(($IS_GXB == 4) && ($IS_ALT_RECONFIG == 1)){
					printf $FILE "  assign reconfig_clk" . $SEPARATOR . $TEMP_I . "= 0;\n";
					printf $FILE "  assign reconfig_togxb" . $SEPARATOR . $TEMP_I . "= 4'b0010;\n";					
				}
				printf $FILE "  assign rxp" . $SEPARATOR . $TEMP_I . "=txp" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  assign gxb_pwrdn_in" . $SEPARATOR . $TEMP_I . "=1'b0;\n";
				printf $FILE "\n";
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 1 && $IS_SMALLMAC_GIGE == 1){
				printf $FILE "  assign rx_clk" . $SEPARATOR . $TEMP_I . " = clk_tmp;\n";
				printf $FILE "  assign tx_clk" . $SEPARATOR . $TEMP_I . " = clk_tmp;\n";
				printf $FILE "  assign gm_rx_d" . $SEPARATOR . $TEMP_I . "=gm_tx_d" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  assign gm_rx_dv" . $SEPARATOR . $TEMP_I . "=gm_tx_en" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  assign gm_rx_err" . $SEPARATOR . $TEMP_I . "=gm_tx_err" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  assign set_1000" . $SEPARATOR . $TEMP_I . "=0;\n";
				printf $FILE "  assign set_10" . $SEPARATOR . $TEMP_I . "=0;\n";
				printf $FILE "\n";	
			}	
			if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0 && $IS_SMALLMAC_GIGE == 1){
				printf $FILE "  assign rx_clk" . $SEPARATOR . $TEMP_I . " = clk_shift;\n";
				printf $FILE "  assign tx_clk" . $SEPARATOR . $TEMP_I . " = clk_tmp;\n";
				printf $FILE "  assign rgmii_in" . $SEPARATOR . $TEMP_I . "=rgmii_out" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  assign rx_control" . $SEPARATOR . $TEMP_I . "=tx_control" . $SEPARATOR . $TEMP_I . ";\n";					
				printf $FILE "  assign set_1000" . $SEPARATOR . $TEMP_I . "=0;\n";
				printf $FILE "  assign set_10" . $SEPARATOR . $TEMP_I . "=0;\n";		
				printf $FILE "\n";
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0 && $IS_SMALLMAC_GIGE == 0){
				printf $FILE "  assign rx_clk" . $SEPARATOR . $TEMP_I . " = clk_tmp;\n";
				printf $FILE "  assign tx_clk" . $SEPARATOR . $TEMP_I . " = clk_tmp;\n";
				printf $FILE "  assign m_rx_d" . $SEPARATOR . $TEMP_I . "=m_tx_d" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  assign m_rx_en" . $SEPARATOR . $TEMP_I . "=m_tx_en" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "  assign m_rx_err" . $SEPARATOR . $TEMP_I . "=m_tx_err" . $SEPARATOR . $TEMP_I . ";\n";
				if ($IS_HALFDUPLEX == 1) {
					printf $FILE "  assign m_rx_col" . $SEPARATOR . $TEMP_I . "=0;\n";
					printf $FILE "  assign m_rx_crs" . $SEPARATOR . $TEMP_I . "=0;\n";
				}
				printf $FILE "  assign set_1000" . $SEPARATOR . $TEMP_I . "=0;\n";
				printf $FILE "  assign set_10" . $SEPARATOR . $TEMP_I . "=0;\n";
				printf $FILE "\n";
			}	
		}
		printf $FILE "\n";
	###################################################################################################
	#
	# Module start
	#
	###################################################################################################
	printf $FILE "endmodule\n";
}else{
	###################################################################################################
	#
	# VHDL
	#
	###################################################################################################
	###################################################################################################
	#
	# VHDL Library Header start
	#
	###################################################################################################
	printf $FILE "library ieee;\n";
	printf $FILE "use ieee.std_logic_1164.all;\n";
	printf $FILE "use ieee.std_logic_arith.all;\n";
	printf $FILE "use ieee.std_logic_unsigned.all;\n";
	printf $FILE "\n";
	###################################################################################################
	#
	# Entity Header start
	#
	###################################################################################################
	printf $FILE "ENTITY " . $VARIATION_NAME . "_loopback IS\n";
	###################################################################################################
	#
	# Port Section start
	#
	###################################################################################################
	printf $FILE "PORT (\n";
		###################################################################################################
		#
		# Port Generation(Once)
		#
		###################################################################################################
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 1){
				#printf $FILE "\n";			
		}
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0){
				#printf $FILE "\n";		
		}
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 0){
				#printf $FILE "\n";		
		}		
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 1 && $IS_POWERDOWN == 0){
				printf $FILE "   ref_clk : OUT STD_LOGIC;\n";
				printf $FILE "\n";		
		}	
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 1 && $IS_POWERDOWN == 1){
				printf $FILE "   ref_clk : OUT STD_LOGIC;\n";	
				printf $FILE "\n";		
		}
		if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 1 && $IS_SMALLMAC_GIGE == 1){
			#printf $FILE "\n";	
		}	
		if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0 && $IS_SMALLMAC_GIGE == 1){
			#printf $FILE "\n";
		}
		if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0 && $IS_SMALLMAC_GIGE == 0){
			#printf $FILE "\n";
		}	
		printf $FILE "\n";
		###################################################################################################
		#
		# Port Generation(Per Channel)
		#
		###################################################################################################
		$i = 0;
		$TEMP_END_PORT_SEPARATOR = "";
		$TEMP_I = "";
		for($i; $i < $NUMBER_OF_CHANNEL; $i++){
			if($i == $NUMBER_OF_CHANNEL-1){
				$TEMP_END_PORT_SEPARATOR = "";
			}else{
				$TEMP_END_PORT_SEPARATOR = $END_PORT_SEPARATOR;
			}
			if($IS_FIFOLESS == 0 && $NUMBER_OF_CHANNEL == 1){
				$TEMP_I = "";
			}else{
				$TEMP_I = $i;
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 1){
				printf $FILE "   rx_clk" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   tx_clk" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   m_tx_d" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC_VECTOR (3 DOWNTO 0);\n";
				printf $FILE "   m_tx_en" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC;\n";
				printf $FILE "   m_tx_err" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC;\n";
				printf $FILE "   m_rx_d" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);\n";
				printf $FILE "   m_rx_en" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   m_rx_err" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				if ($IS_HALFDUPLEX == 1) {
					printf $FILE "   m_rx_col" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
					printf $FILE "   m_rx_crs" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				}
				printf $FILE "   gm_tx_d" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC_VECTOR (7 DOWNTO 0);\n";
				printf $FILE "   gm_tx_en" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC;\n";
				printf $FILE "   gm_tx_err" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC;\n";
				printf $FILE "   gm_rx_d" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);\n";
				printf $FILE "   gm_rx_dv" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   gm_rx_err" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   set_1000" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   set_10" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC" . $TEMP_END_PORT_SEPARATOR . "\n";	
				printf $FILE "\n";			
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0){
				printf $FILE "   rx_clk" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   tx_clk" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				# printf $FILE "   m_tx_d" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC_VECTOR (3 DOWNTO 0);\n";
				# printf $FILE "   m_tx_en" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC;\n";
				# printf $FILE "   m_tx_err" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC;\n";
				# printf $FILE "   m_rx_d" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);\n";
				# printf $FILE "   m_rx_en" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				# printf $FILE "   m_rx_err" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				# printf $FILE "   m_rx_col" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				# printf $FILE "   m_rx_crs" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   rgmii_out" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC_VECTOR (3 DOWNTO 0);\n";
				printf $FILE "   tx_control" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC;\n";
				printf $FILE "   rgmii_in" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);\n";
				printf $FILE "   rx_control" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   set_1000" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   set_10" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC" . $TEMP_END_PORT_SEPARATOR . "\n";	
				printf $FILE "\n";	
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 0){
				if($IS_FIFOLESS == 1 && $i == 0){
					printf $FILE "   ref_clk" . " : OUT STD_LOGIC;\n";
				}
				printf $FILE "   tbi_tx_d" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC_VECTOR (9 DOWNTO 0);\n";
				printf $FILE "   tbi_rx_d" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);\n";
	 			printf $FILE "   tbi_rx_clk" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
	 			printf $FILE "   tbi_tx_clk" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC" . $TEMP_END_PORT_SEPARATOR . "\n";	
				printf $FILE "\n";
			}		
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 1 && $IS_POWERDOWN == 0){
				if(($IS_GXB == 2) && ($IS_ALT_RECONFIG == 1)){
					printf $FILE "   reconfig_clk" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
					printf $FILE "   reconfig_togxb" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);\n";
					printf $FILE "   reconfig_fromgxb" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC;\n";
				}
				if(($IS_GXB == 4) && ($IS_ALT_RECONFIG == 1)){
					printf $FILE "   reconfig_clk" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
					printf $FILE "   reconfig_togxb" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);\n";
					printf $FILE "   reconfig_fromgxb" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC_VECTOR (16 DOWNTO 0);\n";
				}
	 			printf $FILE "   txp" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC;\n";
	 			printf $FILE "   rxp" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC" . $TEMP_END_PORT_SEPARATOR . "\n";		
				printf $FILE "\n";
			}	
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 1 && $IS_POWERDOWN == 1){
	 			if(($IS_GXB == 2) && ($IS_ALT_RECONFIG == 1)){
					printf $FILE "   reconfig_clk" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
					printf $FILE "   reconfig_togxb" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);\n";
					printf $FILE "   reconfig_fromgxb" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC;\n";
				}
				if(($IS_GXB == 4) && ($IS_ALT_RECONFIG == 1)){
					printf $FILE "   reconfig_clk" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
					printf $FILE "   reconfig_togxb" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);\n";
					printf $FILE "   reconfig_fromgxb" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC_VECTOR (16 DOWNTO 0);\n";
				}
	 			printf $FILE "   txp" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC;\n";
	 			printf $FILE "   rxp" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
	 			printf $FILE "   pcs_pwrdn_out" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC;\n";
	 			printf $FILE "   gxb_pwrdn_in" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC" . $TEMP_END_PORT_SEPARATOR . "\n";					
				printf $FILE "\n";
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 1 && $IS_SMALLMAC_GIGE == 1){
				printf $FILE "   rx_clk" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   tx_clk" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   gm_tx_d" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC_VECTOR (7 DOWNTO 0);\n";
				printf $FILE "   gm_tx_en" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC;\n";
				printf $FILE "   gm_tx_err" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC;\n";
				printf $FILE "   gm_rx_d" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);\n";
				printf $FILE "   gm_rx_dv" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   gm_rx_err" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   set_1000" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   set_10" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC" . $TEMP_END_PORT_SEPARATOR . "\n";		
				printf $FILE "\n";	
			}	
			if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0 && $IS_SMALLMAC_GIGE == 1){
				printf $FILE "   rx_clk" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   tx_clk" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   rgmii_out" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC_VECTOR (3 DOWNTO 0);\n";
				printf $FILE "   tx_control" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC;\n";
				printf $FILE "   rgmii_in" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);\n";
				printf $FILE "   rx_control" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   set_1000" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   set_10" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC" . $TEMP_END_PORT_SEPARATOR . "\n";
				printf $FILE "\n";
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0 && $IS_SMALLMAC_GIGE == 0){
				printf $FILE "   rx_clk" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   tx_clk" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";			
				printf $FILE "   m_tx_d" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC_VECTOR (3 DOWNTO 0);\n";
				printf $FILE "   m_tx_en" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC;\n";
				printf $FILE "   m_tx_err" . $SEPARATOR . $TEMP_I . " : IN STD_LOGIC;\n";
				printf $FILE "   m_rx_d" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);\n";
				printf $FILE "   m_rx_en" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   m_rx_err" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				if ($IS_HALFDUPLEX == 1) {
					printf $FILE "   m_rx_col" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
					printf $FILE "   m_rx_crs" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				}
				printf $FILE "   set_1000" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC;\n";
				printf $FILE "   set_10" . $SEPARATOR . $TEMP_I . " : OUT STD_LOGIC" . $TEMP_END_PORT_SEPARATOR . "\n";				
				printf $FILE "\n";
			}	
		}
		printf $FILE "\n";
	###################################################################################################
	#
	# Port Section end
	#
	###################################################################################################
	printf $FILE ");\n";
	###################################################################################################
	#
	# VHDL Entity Header end
	#
	###################################################################################################
	printf $FILE "END " . $VARIATION_NAME . "_loopback;\n";
	printf $FILE "\n";
	###################################################################################################
	#
	# VHDL Architecture Header start
	#
	###################################################################################################
	printf $FILE "architecture dummy of " . $VARIATION_NAME . "_loopback is\n";
	###################################################################################################
	#
	# Signal and Component Section  start
	#
	###################################################################################################
	printf $FILE "   signal clk_tmp :  STD_LOGIC;\n";
	
	if($IS_MAC == 1 && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0){
		if($IS_SMALLMAC == 1 && $IS_SMALLMAC_GIGE == 0){
		
		} else {
			printf $FILE "   signal clk_shift :  STD_LOGIC;\n";
			printf $FILE "   signal start : STD_LOGIC := STD_LOGIC'('0');\n";
		}
	}
	
	printf $FILE "\n";
	###################################################################################################
	#
	# Body Section  start
	#
	###################################################################################################
	printf $FILE "begin\n";
	printf $FILE "\n";
	###################################################################################################
	#
	# Clock Generation
	#
	###################################################################################################
	printf $FILE "   -- clock generation logic\n";
	printf $FILE "   process\n";
	printf $FILE "      begin\n";
	printf $FILE "         clk_tmp <= '0' ;\n";
	printf $FILE "         wait for 4 ns ;\n";
	printf $FILE "         clk_tmp <= '1' ;\n";
	printf $FILE "         wait for 4 ns ;\n";
	printf $FILE "      end process ;\n";
	printf $FILE "\n";
	if($IS_MAC == 1 && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0){
		if($IS_SMALLMAC == 1 && $IS_SMALLMAC_GIGE == 0){
		
		} else {
			printf $FILE "   process\n";
			printf $FILE "      begin\n";
			printf $FILE "         if (start = '0') then\n";
			printf $FILE "            clk_shift <= '0';\n";
			printf $FILE "            start <= '1';\n";
			printf $FILE "            wait for 2 ns;\n";
			printf $FILE "         else\n";
			printf $FILE "            clk_shift <= '0';\n";
			printf $FILE "            wait for 4 ns;\n";
			printf $FILE "            clk_shift <= '1';\n";
			printf $FILE "            wait for 4 ns;\n";
			printf $FILE "         end if;\n";
			printf $FILE "      end process;\n";
		}
	}

		###################################################################################################
		#
		# Logic Generation(Once)
		#
		###################################################################################################
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 1){
			#printf $FILE "\n";	
		}	
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0){
			#printf $FILE "\n";
		}
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 0){
			#printf $FILE "\n";
		}	
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 1 && $IS_POWERDOWN == 0){
			printf $FILE "   ref_clk <= clk_tmp;\n";
			printf $FILE "\n";
		}	
		if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 1 && $IS_POWERDOWN == 1){
	 		printf $FILE "   ref_clk <= clk_tmp;\n";
			printf $FILE "\n";
		}
		if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 1 && $IS_SMALLMAC_GIGE == 1){
			#printf $FILE "\n";	
		}	
		if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0 && $IS_SMALLMAC_GIGE == 1){
			#printf $FILE "\n";
		}
		if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0 && $IS_SMALLMAC_GIGE == 0){
			#printf $FILE "\n";
		}	
		printf $FILE "\n";
		###################################################################################################
		#
		# Logic Generation(Per Channel)
		#
		###################################################################################################
		$i = 0;
		$TEMP_I = "";
		for($i; $i < $NUMBER_OF_CHANNEL; $i++){
			if($IS_FIFOLESS == 0 && $NUMBER_OF_CHANNEL == 1){
				$TEMP_I = "";
			}else{
				$TEMP_I = $i;
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 1){
				printf $FILE "   rx_clk" . $SEPARATOR . $TEMP_I . " <= clk_tmp;\n";
				printf $FILE "   tx_clk" . $SEPARATOR . $TEMP_I . " <= clk_tmp;\n";
				printf $FILE "   m_rx_d" . $SEPARATOR . $TEMP_I . "<=m_tx_d" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "   m_rx_en" . $SEPARATOR . $TEMP_I . "<=m_tx_en" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "   m_rx_err" . $SEPARATOR . $TEMP_I . "<=m_tx_err" . $SEPARATOR . $TEMP_I . ";\n";
				if ($IS_HALFDUPLEX == 1) {
					printf $FILE "   m_rx_col" . $SEPARATOR . $TEMP_I . "<='0';\n";
					printf $FILE "   m_rx_crs" . $SEPARATOR . $TEMP_I . "<='0';\n";
				}
				printf $FILE "   gm_rx_d" . $SEPARATOR . $TEMP_I . "<=gm_tx_d" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "   gm_rx_dv" . $SEPARATOR . $TEMP_I . "<=gm_tx_en" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "   gm_rx_err" . $SEPARATOR . $TEMP_I . "<=gm_tx_err" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "   set_1000" . $SEPARATOR . $TEMP_I . "<='0';\n";
				printf $FILE "   set_10" . $SEPARATOR . $TEMP_I . "<='0';\n";
				printf $FILE "\n";	
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0){
				printf $FILE "   rx_clk" . $SEPARATOR . $TEMP_I . " <= clk_shift;\n";
				printf $FILE "   tx_clk" . $SEPARATOR . $TEMP_I . " <= clk_tmp;\n";
				# printf $FILE "   m_rx_d" . $SEPARATOR . $TEMP_I . " <=m_tx_d" . $SEPARATOR . $TEMP_I . ";\n";
				# printf $FILE "   m_rx_en" . $SEPARATOR . $TEMP_I . " <=m_tx_en" . $SEPARATOR . $TEMP_I . ";\n";
				# printf $FILE "   m_rx_err" . $SEPARATOR . $TEMP_I . " <=m_tx_err" . $SEPARATOR . $TEMP_I . ";\n";
				# printf $FILE "   m_rx_col" . $SEPARATOR . $TEMP_I . " <='0';\n";
				# printf $FILE "   m_rx_crs" . $SEPARATOR . $TEMP_I . " <='0';\n";
				printf $FILE "   rgmii_in" . $SEPARATOR . $TEMP_I . " <=rgmii_out" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "   rx_control" . $SEPARATOR . $TEMP_I . " <=tx_control" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "   set_1000" . $SEPARATOR . $TEMP_I . " <='0';\n";
				printf $FILE "   set_10" . $SEPARATOR . $TEMP_I . " <='0';\n";				
				printf $FILE "\n";
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 0){				
				if($IS_FIFOLESS == 1 && $i == 0){
					printf $FILE "   ref_clk" . " <= clk_tmp;\n";
				}
				printf $FILE "   tbi_rx_clk" . $SEPARATOR . $TEMP_I . " <= clk_tmp;\n";
				printf $FILE "   tbi_tx_clk" . $SEPARATOR . $TEMP_I . " <= clk_tmp;\n";
				printf $FILE "   tbi_rx_d" . $SEPARATOR . $TEMP_I . " <=tbi_tx_d" . $SEPARATOR . $TEMP_I . ";\n";
			
				printf $FILE "\n";
			}		
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 1 && $IS_POWERDOWN == 0){
				if(($IS_GXB == 2) && ($IS_ALT_RECONFIG == 1)){
					printf $FILE "   reconfig_clk" . $SEPARATOR . $TEMP_I . " <= '0';\n";
					printf $FILE "   reconfig_togxb" . $SEPARATOR . $TEMP_I . " <= \"010\";\n";
				}
				if(($IS_GXB == 4) && ($IS_ALT_RECONFIG == 1)){
					printf $FILE "   reconfig_clk" . $SEPARATOR . $TEMP_I . " <= '0';\n";
					printf $FILE "   reconfig_togxb" . $SEPARATOR . $TEMP_I . " <= \"0010\";\n";
				}
				printf $FILE "   rxp" . $SEPARATOR . $TEMP_I . " <=txp" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "\n";
			}	
			if($IS_MAC == 1 && $IS_SMALLMAC == 0  && $IS_PCS == 1 && $IS_PMA == 1 && $IS_POWERDOWN == 1){
				if(($IS_GXB == 2) && ($IS_ALT_RECONFIG == 1)){
					printf $FILE "   reconfig_clk" . $SEPARATOR . $TEMP_I . " <= '0';\n";
					printf $FILE "   reconfig_togxb" . $SEPARATOR . $TEMP_I . " <= \"010\";\n";
				}
				if(($IS_GXB == 4) && ($IS_ALT_RECONFIG == 1)){
					printf $FILE "   reconfig_clk" . $SEPARATOR . $TEMP_I . " <= '0';\n";
					printf $FILE "   reconfig_togxb" . $SEPARATOR . $TEMP_I . " <= \"0010\";\n";
				}
				printf $FILE "   rxp" . $SEPARATOR . $TEMP_I . " <=txp" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "   gxb_pwrdn_in" . $SEPARATOR . $TEMP_I . " <='0';\n";
				printf $FILE "\n";
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 1 && $IS_SMALLMAC_GIGE == 1){
				printf $FILE "   rx_clk" . $SEPARATOR . $TEMP_I . " <= clk_tmp;\n";
				printf $FILE "   tx_clk" . $SEPARATOR . $TEMP_I . " <= clk_tmp;\n";
				printf $FILE "   gm_rx_d" . $SEPARATOR . $TEMP_I . "<=gm_tx_d" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "   gm_rx_dv" . $SEPARATOR . $TEMP_I . "<=gm_tx_en" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "   gm_rx_err" . $SEPARATOR . $TEMP_I . "<=gm_tx_err" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "   set_1000" . $SEPARATOR . $TEMP_I . "<='0';\n";
				printf $FILE "   set_10" . $SEPARATOR . $TEMP_I . "<='0';\n";
				printf $FILE "\n";	
			}	
			if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0 && $IS_SMALLMAC_GIGE == 1){
				printf $FILE "   rx_clk" . $SEPARATOR . $TEMP_I . " <= clk_shift;\n";
				printf $FILE "   tx_clk" . $SEPARATOR . $TEMP_I . " <= clk_tmp;\n";
				printf $FILE "   rgmii_in" . $SEPARATOR . $TEMP_I . " <=rgmii_out" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "   rx_control" . $SEPARATOR . $TEMP_I . " <=tx_control" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "   set_1000" . $SEPARATOR . $TEMP_I . " <='0';\n";
				printf $FILE "   set_10" . $SEPARATOR . $TEMP_I . " <='0';\n";				
				printf $FILE "\n";
			}
			if($IS_MAC == 1 && $IS_SMALLMAC == 1  && $IS_PCS == 0 && $IS_PMA == 0 && $IS_GMII == 0 && $IS_SMALLMAC_GIGE == 0){
				printf $FILE "   rx_clk" . $SEPARATOR . $TEMP_I . " <= clk_tmp;\n";
				printf $FILE "   tx_clk" . $SEPARATOR . $TEMP_I . " <= clk_tmp;\n";
				printf $FILE "   m_rx_d" . $SEPARATOR . $TEMP_I . "<=m_tx_d" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "   m_rx_en" . $SEPARATOR . $TEMP_I . "<=m_tx_en" . $SEPARATOR . $TEMP_I . ";\n";
				printf $FILE "   m_rx_err" . $SEPARATOR . $TEMP_I . "<=m_tx_err" . $SEPARATOR . $TEMP_I . ";\n";
				if ($IS_HALFDUPLEX == 1) {
					printf $FILE "   m_rx_col" . $SEPARATOR . $TEMP_I . "<='0';\n";
					printf $FILE "   m_rx_crs" . $SEPARATOR . $TEMP_I . "<='0';\n";
				}
				printf $FILE "   set_1000" . $SEPARATOR . $TEMP_I . "<='0';\n";
				printf $FILE "   set_10" . $SEPARATOR . $TEMP_I . "<='0';\n";			
				printf $FILE "\n";
			}	
		}
		printf $FILE "\n";
	###################################################################################################
	#
	# Body Section  end
	#
	###################################################################################################
	###################################################################################################
	#
	# VHDL Architecture Header end
	#
	###################################################################################################
	printf $FILE "end dummy;\n";
}
			
exit 0;


