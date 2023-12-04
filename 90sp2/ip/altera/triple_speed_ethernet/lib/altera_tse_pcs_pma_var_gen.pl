use europa_all;
use strict;

sub make_mac_pcs_pma
{
  
  
  my $module_name = shift;
  my $instance_name = shift;
  my $language = shift;
  my $pcs_only = shift;
  my $GIGE_MODE = shift;
  my $ENABLE_ENA = shift;
  my $USE_SYNC_RESET = shift;
  my $RESET_LEVEL = shift;
  my $ENABLE_MDIO = shift;
  my $ENABLE_MAC_FLOW_CTRL = shift;  
  my $ENABLE_MAGIC_DETECT = shift;
  my $ENABLE_SGMII = shift;
  my $EXPORT_PWRDN = shift;
  my $EXPORT_CALBLKCLK = shift;

  # added lvds support
  my $use_lvds = shift;
  
  my $top_pcs_name;
  my $top_geth_name;

  # added lvds support
  my $top_lvds_rx_name;
  my $top_lvds_tx_name;
  
  my $in_port_map_pcs;
  my $out_port_map_pcs;
  my $in_port_map_geth;
  my $out_port_map_geth;
  
  my $in_port_map_rmfix;
  my $out_port_map_rmfix;

  # added lvds support
  my $in_port_map_lvds_rx;
  my $in_port_map_lvds_tx;
  my $out_port_map_lvds_rx;
  my $out_port_map_lvds_tx;
  
  my $mod =  e_module->new ({name => $module_name});
  my $marker = e_default_module_marker->new ($mod);


  # Output ports
  e_port->adds(
    ["txp", 1, "output"],
    ["waitrequest", 1, "output"],
    ["led_an", 1, "output"],
    ["led_link", 1, "output"],        
    ["led_char_err", 1, "output"],  
    ["led_disp_err", 1, "output"],   
  );
  
  # Input ports
  e_port->adds(
    ["clk", 1, "input"],
    ["read", 1, "input"],
    ["write", 1, "input"],
    ["reset", 1, "input"],
    ["ref_clk", 1, "input"],
    ["rxp", 1, "input"],   
  );


  # Signals declaration
  e_signal->add(["waitrequest",1]);
  e_signal->add(["led_an",1]);  
  e_signal->add(["led_disp_err",1]);   
  e_signal->add(["txp",1]);
  e_signal->add(["link_status",1]);
  
  if ($use_lvds == 0) {
      e_signal->add(["sd_loopback",1]);
      e_signal->add(["powerdown",1]);
      e_signal->add(["pma_digital_rst0",1]);
      e_signal->add(["pma_digital_rst1",1]);
      e_signal->add(["pma_digital_rst2",1]);
   }      
  

# Ports, signals and wire generations based on parameters
# -------------------------------------------------------
  if (($pcs_only == 1) && ($use_lvds == 0)) {

      $in_port_map_geth     -> {"rx_analogreset"} = "reset_rx_clk";
      $in_port_map_rmfix    -> {"reset_rx_clk"} = "reset_rx_clk";
      $in_port_map_geth     -> {"tx_digitalreset"} = "pma_digital_rst2";

  }
    

  if (($pcs_only == 0) && ($use_lvds == 0)) {
      $in_port_map_geth     -> {"rx_analogreset"} = "reset_rx_clk_int";   
      $in_port_map_rmfix    -> {"reset_rx_clk"} = "reset_rx_clk_int";   
      $in_port_map_geth     -> {"tx_digitalreset"} = "pma_digital_rst2";

  }


  if ($pcs_only == 1) {
  
      e_port->adds(
          ["readdata", 16, "output"],        
          ["rx_clk", 1, "output"],                 
          ["tx_clk", 1, "output"],                 
          ["gmii_rx_dv", 1, "output"],             
          ["gmii_rx_d", 8, "output"],      
          ["gmii_rx_err", 1, "output"],  
          ["reset_rx_clk", 1, "input"],
          ["reset_tx_clk", 1, "input"],           
          ["gmii_tx_en", 1, "input"],
          ["gmii_tx_d", 8, "input"],
          ["gmii_tx_err", 1, "input"],
          ["address", 5, "input"],
          ["writedata", 16, "input"],             
      );
           
      e_signal->add(["readdata",16]);
      e_signal->add(["rx_clk",1]);
      e_signal->add(["gmii_rx_dv",1]);
      e_signal->add(["gmii_rx_d",8]);
      e_signal->add(["gmii_rx_err",1]);
      e_signal->add(["led_link",1]);
      e_signal->add(["led_char_err",1]);
      e_signal->add(["PCS_rx_reset",1]);
      e_signal->add(["PCS_tx_reset",1]);

#      if ($use_lvds == 0) {
      e_assign->add (["PCS_rx_reset" => "pma_digital_rst2"]);
      e_assign->add (["PCS_tx_reset" => "reset_tx_clk | pma_digital_rst2"]);

      $in_port_map_pcs -> {"reset_rx_clk"} = "PCS_rx_reset";
      $in_port_map_pcs -> {"reset_tx_clk"} = "PCS_tx_reset";
#      }
#      else {
#      $in_port_map_pcs -> {"reset_rx_clk"} = "reset_rx_clk";
#      $in_port_map_pcs -> {"reset_tx_clk"} = "reset_tx_clk";      
#      }
      
      $in_port_map_pcs -> {"reset_reg_clk"} = "reset";
      $in_port_map_pcs -> {"gmii_tx_en"} = "gmii_tx_en";
      $in_port_map_pcs -> {"gmii_tx_d"} = "gmii_tx_d";
      $in_port_map_pcs -> {"gmii_tx_err"} = "gmii_tx_err";
      $in_port_map_pcs -> {"reg_clk"} = "clk";
      $in_port_map_pcs -> {"reg_rd"} = "read";
      $in_port_map_pcs -> {"reg_wr"} = "write";
      $in_port_map_pcs -> {"reg_addr"} = "address";
      $in_port_map_pcs -> {"reg_data_in"} = "writedata";
      
      $out_port_map_pcs -> {"rx_clk"} = "rx_clk";
      $out_port_map_pcs -> {"tx_clk"} = "tx_clk";
      $out_port_map_pcs -> {"gmii_rx_dv"} = "gmii_rx_dv";
      $out_port_map_pcs -> {"gmii_rx_d"} = "gmii_rx_d";
      $out_port_map_pcs -> {"gmii_rx_err"} = "gmii_rx_err";
      $out_port_map_pcs -> {"reg_data_out"} = "readdata";
      $out_port_map_pcs -> {"reg_busy"} = "waitrequest";
      
  }
  else {
  
      e_port->adds(
          ["readdata", 32, "output"],
          ["ff_rx_data", $ENABLE_ENA, "output"],
          ["ff_rx_sop", 1, "output"],
          ["ff_rx_eop", 1, "output"],
          ["rx_err", 6, "output"],
          ["rx_err_stat", 18, "output"],
          ["rx_frm_type", 4, "output"],
          ["ff_rx_dval", 1, "output"],
          ["ff_rx_dsav", 1, "output"],
          ["ff_tx_rdy", 1, "output"],
          ["ff_tx_septy", 1, "output"],
          ["tx_ff_uflow", 1, "output"],
          ["address", 8, "input"],
          ["writedata", 32, "input"],
          ["ff_rx_clk", 1, "input"],    
          ["ff_rx_rdy", 1, "input"],
          ["ff_tx_clk", 1, "input"],
          ["ff_tx_data", $ENABLE_ENA, "input"],
          ["ff_tx_sop", 1, "input"],
          ["ff_tx_eop", 1, "input"],
          ["ff_tx_err", 1, "input"],
          ["ff_tx_crc_fwd", 1, "input"],
          ["ff_tx_wren", 1, "input"],
          ["ff_rx_a_full", 1, "output"],
          ["ff_rx_a_empty", 1, "output"],
          ["ff_tx_a_full", 1, "output"],
          ["ff_tx_a_empty", 1, "output"],
      );
            
      e_signal->add(["readdata",32]);
      e_signal->add(["ff_rx_data",($ENABLE_ENA-1)]);
      e_signal->add(["ff_rx_sop",1]);
      e_signal->add(["ff_rx_eop",1]);
      e_signal->add(["rx_err",6]);
      e_signal->add(["rx_err_stat",18]);
      e_signal->add(["rx_frm_type",4]);
      e_signal->add(["ff_rx_dval",1]);
      e_signal->add(["ff_rx_dsav",1]);
      e_signal->add(["ff_rx_rdy",1]);
      e_signal->add(["ff_tx_septy",1]);
      e_signal->add(["tx_ff_uflow",1]);
      
 #     if ($use_lvds == 0) {
      e_signal->add(["reset_rx_clk_int",1]);
      e_assign->add (["MAC_PCS_reset" => "pma_digital_rst2"]);
      
      $in_port_map_pcs -> {"reset"} = "MAC_PCS_reset";
 #     }
 #     else {
 #     $in_port_map_pcs -> {"reset"} = "reset";           
 #     }
      
      e_signal->add(["ff_rx_a_full",1]);
      e_signal->add(["ff_rx_a_empty",1]);
      e_signal->add(["ff_tx_a_full",1]);
      e_signal->add(["ff_tx_a_empty",1]);
      e_signal->add(["MAC_PCS_reset",1]);
      

      
      $in_port_map_pcs -> {"ff_rx_clk"} = "ff_rx_clk";
      $in_port_map_pcs -> {"ff_rx_rdy"} = "ff_rx_rdy";
      $in_port_map_pcs -> {"ff_tx_clk"} = "ff_tx_clk";
      $in_port_map_pcs -> {"ff_tx_data"} = "ff_tx_data";
      $in_port_map_pcs -> {"ff_tx_sop"} = "ff_tx_sop";
      $in_port_map_pcs -> {"ff_tx_eop"} = "ff_tx_eop";
      $in_port_map_pcs -> {"ff_tx_err"} = "ff_tx_err";
      $in_port_map_pcs -> {"ff_tx_crc_fwd"} = "ff_tx_crc_fwd";
      $in_port_map_pcs -> {"ff_tx_wren"} = "ff_tx_wren";
      $in_port_map_pcs -> {"clk"} = "clk";
      $in_port_map_pcs -> {"read"} = "read";
      $in_port_map_pcs -> {"write"} = "write";
      $in_port_map_pcs -> {"address"} = "address";
      $in_port_map_pcs -> {"writedata"} = "writedata";

      
      $out_port_map_pcs -> {"ff_rx_data"} = "ff_rx_data";
      $out_port_map_pcs -> {"ff_rx_sop"} = "ff_rx_sop";
      $out_port_map_pcs -> {"ff_rx_eop"} = "ff_rx_eop";
      $out_port_map_pcs -> {"rx_err"} = "rx_err";
      $out_port_map_pcs -> {"rx_err_stat"} = "rx_err_stat";
      $out_port_map_pcs -> {"rx_frm_type"} = "rx_frm_type";
      $out_port_map_pcs -> {"ff_rx_dval"} = "ff_rx_dval";
      $out_port_map_pcs -> {"ff_rx_dsav"} = "ff_rx_dsav";
      $out_port_map_pcs -> {"ff_tx_rdy"} = "ff_tx_rdy";
      $out_port_map_pcs -> {"ff_tx_septy"} = "ff_tx_septy";
      $out_port_map_pcs -> {"tx_ff_uflow"} = "tx_ff_uflow";
      $out_port_map_pcs -> {"readdata"} = "readdata";
      $out_port_map_pcs -> {"waitrequest"} = "waitrequest";
      $out_port_map_pcs -> {"ff_rx_a_full"} = "ff_rx_a_full";
      $out_port_map_pcs -> {"ff_rx_a_empty"} = "ff_rx_a_empty";
      $out_port_map_pcs -> {"ff_tx_a_full"} = "ff_tx_a_full";
      $out_port_map_pcs -> {"ff_tx_a_empty"} = "ff_tx_a_empty";


      if ($ENABLE_MAGIC_DETECT == 1) {
          e_port->adds(  
              ["magic_sleep_n", 1, "input"],
              ["magic_wakeup", 1, "output"],
          );
      
          e_signal->add(["magic_wakeup",1]);
          
          $in_port_map_pcs -> {"magic_sleep_n"} = "magic_sleep_n";
          $out_port_map_pcs -> {"magic_wakeup"} = "magic_wakeup";
      }


      if ($ENABLE_MAC_FLOW_CTRL == 1) {
          e_port->adds(  
              ["xoff_gen", 1, "input"],
              ["xon_gen", 1, "input"],
          );
          
          $in_port_map_pcs -> {"xoff_gen"} = "xoff_gen";
          $in_port_map_pcs -> {"xon_gen"} = "xon_gen";
      }

  }
  

  if ($pcs_only == 1) {
#    if ($use_lvds == 0) {
      e_process->add(
          {
              reset => "reset_rx_clk",
              reset_level => "1",
              clock => "clk",
              clock_level => "1",
              asynchronous_contents => [
                e_assign->new (["pma_digital_rst0" => "reset_rx_clk"]),
                e_assign->new (["pma_digital_rst1" => "reset_rx_clk"]),
                e_assign->new (["pma_digital_rst2" => "reset_rx_clk"])],
                           
              contents => [ 
                e_assign->new (["pma_digital_rst0" => "reset_rx_clk"]),
                e_assign->new (["pma_digital_rst1" => "pma_digital_rst0"]),
                e_assign->new (["pma_digital_rst2" => "pma_digital_rst1"])], 
          }
      );
#    }
  }
  else {
#    if ($use_lvds == 0) {
      e_process->add(
          {
              reset => "reset_rx_clk_int",
              reset_level => "1",
              clock => "clk",
              clock_level => "1",
              asynchronous_contents => [
                e_assign->new (["pma_digital_rst0" => "reset_rx_clk_int"]),
                e_assign->new (["pma_digital_rst1" => "reset_rx_clk_int"]),
                e_assign->new (["pma_digital_rst2" => "reset_rx_clk_int"])],
                           
              contents => [ 
                e_assign->new (["pma_digital_rst0" => "reset_rx_clk_int"]),
                e_assign->new (["pma_digital_rst1" => "pma_digital_rst0"]),
                e_assign->new (["pma_digital_rst2" => "pma_digital_rst1"])], 
          }
      );
#    }  
  }
  
  
  if ($pcs_only == 0) {
  
#      if ($use_lvds == 0) {
          if (($USE_SYNC_RESET == 0) && ($RESET_LEVEL == 0)) {
              e_assign->add (["reset_rx_clk_int" => "!reset"]);
          }
          elsif (($USE_SYNC_RESET == 0) && ($RESET_LEVEL == 1)) {
              e_assign->add (["reset_rx_clk_int" => "reset"]);
          }
          elsif (($USE_SYNC_RESET == 1) && ($RESET_LEVEL == 0)) {
              e_assign->add (["reset_rx_clk_int" => "!reset_rx_clk"]);
          }
          else {
              e_assign->add (["reset_rx_clk_int" => "reset_rx_clk"]);
          }
#      }
      if ($ENABLE_ENA == 32) {
      
          e_signal->add(["ff_rx_mod",2]);
          
          e_port->adds(
              ["ff_rx_mod", 2, "output"],
              ["ff_tx_mod", 2, "input"],
          );
          
          $in_port_map_pcs -> {"ff_tx_mod"} = "ff_tx_mod";
          $out_port_map_pcs -> {"ff_rx_mod"} = "ff_rx_mod";
      }
    
      if ($ENABLE_MDIO == 1) {
      
          e_signal->add(["mdc",1]);
          e_signal->add(["mdio_out",1]);
          e_signal->add(["mdio_oen",1]);
          
          e_port->adds(
              ["mdio_in", 1, "input"],
              ["mdc", 1, "output"],  
              ["mdio_out", 1, "output"], 
              ["mdio_oen", 1, "output"],
          );
          
          $in_port_map_pcs -> {"mdio_in"} = "mdio_in";
          $out_port_map_pcs -> {"mdc"} = "mdc";
          $out_port_map_pcs -> {"mdio_out"} = "mdio_out";
          $out_port_map_pcs -> {"mdio_oen"} = "mdio_oen";
          
      }
      
      if ($USE_SYNC_RESET == 1) {
          e_port->adds(
              ["reset_ff_rx_clk", 1, "input"],
              ["reset_ff_tx_clk", 1, "input"],  
              ["reset_rx_clk", 1, "input"],
              ["reset_tx_clk", 1, "input"],
          );
          
          $in_port_map_pcs -> {"reset_rx_clk"} = "reset_rx_clk";
          $in_port_map_pcs -> {"reset_tx_clk"} = "reset_tx_clk";
          $in_port_map_pcs -> {"reset_ff_rx_clk"} = "reset_ff_rx_clk";
          $in_port_map_pcs -> {"reset_ff_tx_clk"} = "reset_ff_tx_clk";
      }    
      
      if ($ENABLE_SGMII == 1) {
          e_port->adds(
              ["led_col", 1, "output"], 
              ["led_crs", 1, "output"],
          );
          
          e_signal->add(["led_col",1]);
          e_signal->add(["led_crs",1]);
          
          $out_port_map_pcs -> {"led_col"} = "led_col"; 
          $out_port_map_pcs -> {"led_crs"} = "led_crs";
          
      } 
  } 
  else {
  
      if ($ENABLE_SGMII == 1) {
          e_port->adds(
              ["led_col", 1, "output"], 
              ["led_crs", 1, "output"],
              ["mii_rx_dv", 1, "output"],
              ["mii_rx_d", 4, "output"],  
              ["mii_rx_err", 1, "output"],  
              ["mii_col", 1, "output"],  
              ["mii_crs", 1, "output"], 
              ["mii_tx_en", 1, "input"],
              ["mii_tx_err", 1, "input"],
              ["mii_tx_d", 4, "input"], 
              ["hd_ena", 1, "output"],  
              ["set_10", 1, "output"],
              ["set_100", 1, "output"],
              ["set_1000", 1, "output"],
          );
          
          e_signal->add(["led_col",1]);
          e_signal->add(["led_crs",1]);
          e_signal->add(["mii_rx_dv",1]);
          e_signal->add(["mii_rx_d",4]);
          e_signal->add(["mii_rx_err",1]);
          e_signal->add(["mii_col",1]);
          e_signal->add(["mii_crs",1]);
          e_signal->add(["hd_ena",1]);
          e_signal->add(["set_10",1]);
          e_signal->add(["set_100",1]);
          e_signal->add(["set_1000",1]);
          
          
          $in_port_map_pcs -> {"mii_tx_en"} = "mii_tx_en";
          $in_port_map_pcs -> {"mii_tx_d"} = "mii_tx_d";
          $in_port_map_pcs -> {"mii_tx_err"} = "mii_tx_err";
          
          $out_port_map_pcs -> {"mii_rx_dv"} = "mii_rx_dv";
          $out_port_map_pcs -> {"mii_rx_d"} = "mii_rx_d";
          $out_port_map_pcs -> {"mii_rx_err"} = "mii_rx_err";
          $out_port_map_pcs -> {"mii_col"} = "mii_col";
          $out_port_map_pcs -> {"mii_crs"} = "mii_crs";
          $out_port_map_pcs -> {"hd_ena"} = "hd_ena";
          $out_port_map_pcs -> {"led_col"} = "led_col";
          $out_port_map_pcs -> {"led_crs"} = "led_crs"; 
          $out_port_map_pcs -> {"set_10"} = "set_10";
          $out_port_map_pcs -> {"set_100"} = "set_100";
          $out_port_map_pcs -> {"set_1000"} = "set_1000";
      }
  }
  
  
  if (($GIGE_MODE == 1) && ($use_lvds == 0)) {
      e_signal->add(["pcs_clk",1]);  
      e_signal->add(["tx_kchar",1]);
      e_signal->add(["tx_frame",8]);
      e_signal->add(["rx_kchar",1]);
      e_signal->add(["rx_frame",8]);
      e_signal->add(["led_char_err_gx",1]);
      e_signal->add(["link_status",1]);
  
      e_assign->add (["led_char_err" => "led_char_err_gx"]);  
      e_assign->add (["led_link" => "link_status"]);

      $in_port_map_pcs -> {"tx_clkout"} = "pcs_clk";
      $in_port_map_pcs -> {"rx_clkout"} = "pcs_clk";
      $in_port_map_pcs -> {"rx_kchar"} = "pcs_rx_kchar";
      $in_port_map_pcs -> {"rx_frame"} = "pcs_rx_frame";
      $in_port_map_pcs -> {"led_link"} = "link_status";
      $in_port_map_pcs -> {"led_char_err"} = "led_char_err_gx";
      $out_port_map_pcs -> {"tx_kchar"} = "tx_kchar";
      $out_port_map_pcs -> {"tx_frame"} = "tx_frame";
      
      $out_port_map_geth -> {"tx_clkout"} = "pcs_clk";
      $in_port_map_geth -> {"tx_ctrlenable"} = "tx_kchar";
      $in_port_map_geth -> {"tx_datain"} = "tx_frame";
      $in_port_map_geth -> {"rx_digitalreset"} = "gige_pma_reset";
      $out_port_map_geth -> {"rx_ctrldetect"} = "rx_kchar";
      $out_port_map_geth -> {"rx_dataout"} = "rx_frame";
      $out_port_map_geth -> {"rx_disperr"} = "rx_disp_err";
      $out_port_map_geth -> {"rx_errdetect"} = "rx_char_err_gx";
      $out_port_map_geth -> {"rx_syncstatus"} = "link_status";
      
      if ($language eq "verilog") {
          $out_port_map_geth -> {"rx_rlv"} = "";
      }
      else {
          $out_port_map_geth -> {"rx_rlv"} = "open";
      }
      
      $top_geth_name = 'altera_tse_alt2gxb_gige';
           
      
      # Instantiation of the tse_gige_reset_ctrl module that resets the 
      # GXB module when the rate matching FIFO overflows/underflows
      # -------------------------------------------------------------- 

      e_signal->add(["gige_pma_reset",1]);
      e_signal->add(["data_select",1]);
      e_signal->add(["pcs_rx_frame",8]);
      e_signal->add(["pcs_rx_kchar",1]);

      e_signal->add(["led_disp_err",1]);
      e_signal->add(["led_char_err_gx",1]);


      $in_port_map_rmfix -> {"pcs_clk"} = "pcs_clk";
      $in_port_map_rmfix -> {"rx_ctrldetect"} = "rx_kchar";
      $in_port_map_rmfix -> {"rx_dataout"} = "rx_frame";
      $in_port_map_rmfix -> {"pma_digreset_in"} = "pma_digital_rst2";
      
      
      $in_port_map_rmfix -> {"rx_sync"} = "link_status";
      $in_port_map_rmfix -> {"rx_disperr"} = "rx_disp_err";
      $in_port_map_rmfix -> {"rx_errdetect"} = "rx_char_err_gx";
       
      $out_port_map_rmfix -> {"pma_digreset_out"} = "gige_pma_reset";
      $out_port_map_rmfix -> {"tx_ctrldetect"} = "pcs_rx_kchar";
      $out_port_map_rmfix -> {"tx_dataout"} = "pcs_rx_frame";
      
      
      $out_port_map_rmfix -> {"tx_disperr"} = "led_disp_err";
      $out_port_map_rmfix -> {"tx_errdetect"} = "led_char_err_gx";
      
      
      e_blind_instance->add({
          module => "tse_gige_reset_ctrl",                 
          in_port_map => $in_port_map_rmfix,                 
          out_port_map => $out_port_map_rmfix,
      });
      
  }
  else {

   if ($use_lvds == 0) {
      e_signal->add(["tbi_tx_d",10]);
      e_signal->add(["tbi_rx_d",10]);
      e_signal->add(["tbi_tx_clk",1]);
      e_signal->add(["tbi_rx_clk",1]);
      
      $in_port_map_pcs -> {"tbi_rx_d"} = "tbi_rx_d";
      $out_port_map_pcs -> {"tbi_tx_d"} = "tbi_tx_d";
      $in_port_map_pcs -> {"tbi_tx_clk"} = "tbi_tx_clk";
      $in_port_map_pcs -> {"tbi_rx_clk"} = "tbi_rx_clk";
      $out_port_map_pcs -> {"led_link"} = "led_link";
      $out_port_map_pcs -> {"led_char_err"} = "led_char_err";   
      $out_port_map_pcs -> {"led_disp_err"} = "led_disp_err";
            
      $in_port_map_geth -> {"rx_digitalreset"} = "pma_digital_rst2";
      $in_port_map_geth -> {"tx_datain"} = "tbi_tx_d";
      $out_port_map_geth -> {"rx_dataout"} = "tbi_rx_d";
      $out_port_map_geth -> {"tx_clkout"} = "tbi_tx_clk";
      $out_port_map_geth -> {"rx_clkout"} = "tbi_rx_clk";
 
      
      $top_geth_name = 'altera_tse_alt2gxb_basic';
   }
   else {

      e_signal->add(["tbi_tx_d",10]);
      e_signal->add(["tbi_rx_d",10]);
      e_signal->add(["tbi_tx_d_flip",10]);
      e_signal->add(["tbi_rx_d_flip",10]);
      e_signal->add(["tbi_rx_clk",1]);
      e_signal->add(["tbi_tx_clk",1]);
      
      $in_port_map_pcs -> {"tbi_rx_d"} = "tbi_rx_d_flip";
      $out_port_map_pcs -> {"tbi_tx_d"} = "tbi_tx_d";
      $in_port_map_pcs -> {"tbi_tx_clk"} = "ref_clk";
#      $in_port_map_pcs -> {"tbi_tx_clk"} = "tbi_tx_clk";
      $in_port_map_pcs -> {"tbi_rx_clk"} = "tbi_rx_clk";
      $out_port_map_pcs -> {"led_link"} = "led_link";
      $out_port_map_pcs -> {"led_char_err"} = "led_char_err";   
      $out_port_map_pcs -> {"led_disp_err"} = "led_disp_err";
            
  # added lvds support
      if ($pcs_only == 1) {
          $in_port_map_lvds_rx  -> {"rx_reset"}     = "reset_rx_clk";
      }
      else {
          $in_port_map_lvds_rx  -> {"rx_reset"}     = "reset_rx_clk_int";
      }
      $in_port_map_lvds_rx  -> {"rx_in"}        = "rxp";
      $in_port_map_lvds_rx  -> {"rx_inclock"}   = "ref_clk";
      $out_port_map_lvds_rx -> {"rx_out"}       = "tbi_rx_d";
      $out_port_map_lvds_rx -> {"rx_divfwdclk"} = "tbi_rx_clk";

      if ($language eq "verilog") {
        $out_port_map_lvds_rx -> {"rx_outclock"}  = "";
      }
      else {
        $out_port_map_lvds_rx -> {"rx_outclock"}  = "open";
      }   


      $in_port_map_lvds_tx  -> {"tx_in"}        = "tbi_tx_d_flip";
      $in_port_map_lvds_tx  -> {"tx_inclock"}   = "ref_clk";
      $out_port_map_lvds_tx -> {"tx_out"}       = "txp";


      if ($pcs_only ==1) {
          e_process->add(
              {
                  reset => "reset_rx_clk",
                  reset_level => "1",
                  clock => "tbi_rx_clk",
                  clock_level => "1",
                  asynchronous_contents => [
                     e_assign->new (["tbi_rx_d_flip" => "0"])],
                  contents => [ 
                    e_assign->new (["tbi_rx_d_flip[0]" => "tbi_rx_d[9]"]),
                    e_assign->new (["tbi_rx_d_flip[1]" => "tbi_rx_d[8]"]),
                    e_assign->new (["tbi_rx_d_flip[2]" => "tbi_rx_d[7]"]),
                    e_assign->new (["tbi_rx_d_flip[3]" => "tbi_rx_d[6]"]),
                    e_assign->new (["tbi_rx_d_flip[4]" => "tbi_rx_d[5]"]),
                    e_assign->new (["tbi_rx_d_flip[5]" => "tbi_rx_d[4]"]),
                    e_assign->new (["tbi_rx_d_flip[6]" => "tbi_rx_d[3]"]),
                    e_assign->new (["tbi_rx_d_flip[7]" => "tbi_rx_d[2]"]),
                    e_assign->new (["tbi_rx_d_flip[8]" => "tbi_rx_d[1]"]),
                    e_assign->new (["tbi_rx_d_flip[9]" => "tbi_rx_d[0]"])],

              }
          );

           e_process->add(
              {
                  reset => "reset_tx_clk",
                  reset_level => "1",
                  clock => "ref_clk",
                  clock_level => "1",
                  asynchronous_contents => [
                     e_assign->new (["tbi_tx_d_flip" => "0"])],
                  contents => [ 

                    e_assign->new (["tbi_tx_d_flip[0]" => "tbi_tx_d[9]"]),
                    e_assign->new (["tbi_tx_d_flip[1]" => "tbi_tx_d[8]"]),
                    e_assign->new (["tbi_tx_d_flip[2]" => "tbi_tx_d[7]"]),
                    e_assign->new (["tbi_tx_d_flip[3]" => "tbi_tx_d[6]"]),
                    e_assign->new (["tbi_tx_d_flip[4]" => "tbi_tx_d[5]"]),
                    e_assign->new (["tbi_tx_d_flip[5]" => "tbi_tx_d[4]"]),
                    e_assign->new (["tbi_tx_d_flip[6]" => "tbi_tx_d[3]"]),
                    e_assign->new (["tbi_tx_d_flip[7]" => "tbi_tx_d[2]"]),
                    e_assign->new (["tbi_tx_d_flip[8]" => "tbi_tx_d[1]"]),
                    e_assign->new (["tbi_tx_d_flip[9]" => "tbi_tx_d[0]"])],
                    
              }
          );
      }
      else {
          e_process->add(
              {
                  reset => "reset_rx_clk_int",
                  reset_level => "1",
                  clock => "tbi_rx_clk",
                  clock_level => "1",
                  asynchronous_contents => [
                     e_assign->new (["tbi_rx_d_flip" => "0"])],
                  contents => [ 
                    e_assign->new (["tbi_rx_d_flip[0]" => "tbi_rx_d[9]"]),
                    e_assign->new (["tbi_rx_d_flip[1]" => "tbi_rx_d[8]"]),
                    e_assign->new (["tbi_rx_d_flip[2]" => "tbi_rx_d[7]"]),
                    e_assign->new (["tbi_rx_d_flip[3]" => "tbi_rx_d[6]"]),
                    e_assign->new (["tbi_rx_d_flip[4]" => "tbi_rx_d[5]"]),
                    e_assign->new (["tbi_rx_d_flip[5]" => "tbi_rx_d[4]"]),
                    e_assign->new (["tbi_rx_d_flip[6]" => "tbi_rx_d[3]"]),
                    e_assign->new (["tbi_rx_d_flip[7]" => "tbi_rx_d[2]"]),
                    e_assign->new (["tbi_rx_d_flip[8]" => "tbi_rx_d[1]"]),
                    e_assign->new (["tbi_rx_d_flip[9]" => "tbi_rx_d[0]"])],

              }
          );

           e_process->add(
              {
                  reset => "reset_rx_clk_int",
                  reset_level => "1",
                  clock => "ref_clk",
                  clock_level => "1",
                  asynchronous_contents => [
                     e_assign->new (["tbi_tx_d_flip" => "0"])],
                  contents => [ 

                    e_assign->new (["tbi_tx_d_flip[0]" => "tbi_tx_d[9]"]),
                    e_assign->new (["tbi_tx_d_flip[1]" => "tbi_tx_d[8]"]),
                    e_assign->new (["tbi_tx_d_flip[2]" => "tbi_tx_d[7]"]),
                    e_assign->new (["tbi_tx_d_flip[3]" => "tbi_tx_d[6]"]),
                    e_assign->new (["tbi_tx_d_flip[4]" => "tbi_tx_d[5]"]),
                    e_assign->new (["tbi_tx_d_flip[5]" => "tbi_tx_d[4]"]),
                    e_assign->new (["tbi_tx_d_flip[6]" => "tbi_tx_d[3]"]),
                    e_assign->new (["tbi_tx_d_flip[7]" => "tbi_tx_d[2]"]),
                    e_assign->new (["tbi_tx_d_flip[8]" => "tbi_tx_d[1]"]),
                    e_assign->new (["tbi_tx_d_flip[9]" => "tbi_tx_d[0]"])],
                    
              }
          );
      
      }
       
      $top_lvds_rx_name = 'altera_tse_pma_lvds_rx';
      $top_lvds_tx_name = 'altera_tse_pma_lvds_tx';
      

   }

  }
  
  $top_pcs_name = $instance_name;


  if ($EXPORT_PWRDN == 1) {
    if ($use_lvds == 0) {
      
      e_port->adds(
          ["pcs_pwrdn_out", 1, "output"],
          ["gxb_pwrdn_in", 1, "input"], 
      );
      
      $out_port_map_pcs -> {"powerdown"} = "pcs_pwrdn_out";
      $in_port_map_geth -> {"gxb_powerdown"} = "gxb_pwrdn_in";
    }        
  }
  else {
    if ($use_lvds == 0) {
      $out_port_map_pcs -> {"powerdown"} = "powerdown";
      $in_port_map_geth -> {"gxb_powerdown"} = "powerdown";
    }
  }


  if ($EXPORT_CALBLKCLK == 1) {
    if ($use_lvds == 0) {
      
      e_port->adds(  
          ["gxb_cal_blk_clk", 1, "input"],
      );
      
      $in_port_map_geth -> {"cal_blk_clk"} = "gxb_cal_blk_clk";
    }        
  }
  else {
    if ($use_lvds == 0) {
      $in_port_map_geth -> {"cal_blk_clk"} = "ref_clk";
    }
  }

  
# Instantiation of the PCS block that connects to the embedded SERDES (Alt2GXB)
# -----------------------------------------------------------------------------  
  if ($use_lvds == 0) {
      $out_port_map_pcs -> {"sd_loopback"} = "sd_loopback";
  }
  $out_port_map_pcs -> {"led_an"} = "led_an";  
             
   
  e_blind_instance->add({
      module => $top_pcs_name,                  
      in_port_map => $in_port_map_pcs,                 
      out_port_map => $out_port_map_pcs,
  });


     
     
# The Instantiation of the Alt2GXB module 
# ---------------------------------------
  if ($use_lvds == 0) {
      $in_port_map_geth -> {"pll_inclk"} = "ref_clk"; 
      $in_port_map_geth -> {"rx_cruclk"} = "ref_clk";
      $in_port_map_geth -> {"rx_datain"} = "rxp";
      $in_port_map_geth -> {"rx_seriallpbken"} = "sd_loopback";

      $out_port_map_geth -> {"tx_dataout"} = "txp";
      
      if ($language eq "verilog") {
          $out_port_map_geth -> {"rx_patterndetect"} = "";
      }
      else {
          $out_port_map_geth -> {"rx_patterndetect"} = "open";
      }   
  }
  
  if ($use_lvds == 0) {
      e_blind_instance->add({
          module => $top_geth_name,                 
          in_port_map => $in_port_map_geth,                 
          out_port_map => $out_port_map_geth,
      });
  }   
  else {
      e_blind_instance->add({
          module => $top_lvds_rx_name,                  
          in_port_map => $in_port_map_lvds_rx,                 
          out_port_map => $out_port_map_lvds_rx,
      });

      e_blind_instance->add({
          module => $top_lvds_tx_name,                  
          in_port_map => $in_port_map_lvds_tx,                 
          out_port_map => $out_port_map_lvds_tx,
      });
  }

      
  return $mod;
}


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
    print ("Europa module processing argument \"$key=$value\"\n");
    $command_hash{$key} = $value;
};

#command line arguments
my $top_module_name = "altera_tse_mac_pcs_pma";
my $instance_name = "altera_tse_mac_pcs_pma_core";
my $language = "verilog"; 
my $pcs_only = 0;
my $gige_mode = 1;
my $enable_ena = 32;
my $use_sync_reset = 0;
my $reset_level = 1;
my $enable_mdio = 0;
my $enable_magic_detect = 1;
my $enable_mac_flow_ctrl = 1;
my $enable_sgmii = 1;
my $export_pwrdn = 0;
my $export_calblkclk = 0;
my $use_lvds = 0;


my $temp = $command_hash{"top_module_name"};
if($temp ne "")
{
    $top_module_name = $temp;   
}

my $temp = $command_hash{"instance_name"};
if($temp ne "")
{
    $instance_name = $temp; 
}

my $temp = $command_hash{"language"};
if($temp ne "")
{
    $language = $temp;  
}

my $temp = $command_hash{"pcs_only"};
if($temp ne "")
{
    $pcs_only = $temp;  
}

my $temp = $command_hash{"gige_mode"};
if($temp ne "")
{
    $gige_mode = $temp; 
}

my $temp = $command_hash{"enable_ena"};
if($temp ne "")
{
    $enable_ena = $temp;    
}

my $temp = $command_hash{"use_sync_reset"};
if($temp ne "")
{
    $use_sync_reset = $temp;    
}

my $temp = $command_hash{"reset_level"};
if($temp ne "")
{
    $reset_level = $temp;   
}

my $temp = $command_hash{"enable_mdio"};
if($temp ne "")
{
    $enable_mdio = $temp;   
}

my $temp = $command_hash{"enable_magic_detect"};
if($temp ne "")
{
    $enable_magic_detect = $temp;   
}

my $temp = $command_hash{"enable_mac_flow_ctrl"};
if($temp ne "")
{
    $enable_mac_flow_ctrl = $temp;   
}

my $temp = $command_hash{"enable_sgmii"};
if($temp ne "")
{
    $enable_sgmii = $temp;  
}

my $temp = $command_hash{"export_pwrdn"};
if($temp ne "")
{
    $export_pwrdn = $temp;  
}

my $temp = $command_hash{"export_calblkclk"};
if($temp ne "")
{
    $export_calblkclk = $temp;  
}

my $temp = $command_hash{"use_lvds"};
if($temp ne "")
{
    $use_lvds = $temp;  
}


my $proj = e_project->new();
my $top_mod = &make_mac_pcs_pma($top_module_name, $instance_name, $language, $pcs_only, $gige_mode, $enable_ena, $use_sync_reset, $reset_level, $enable_mdio, $enable_mac_flow_ctrl, $enable_magic_detect, $enable_sgmii, $export_pwrdn, $export_calblkclk, $use_lvds); 

$proj->language($language);     # set the europa project's language.
$proj->top ($top_mod);          # target the project to the module we created. 
$proj->output();
