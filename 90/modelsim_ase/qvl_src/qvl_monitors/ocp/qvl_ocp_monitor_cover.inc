//              Copyright 2006-2007 Mentor Graphics Corporation
//                           All Rights Reserved.
//
//              THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY
//            INFORMATION WHICH IS THE PROPERTY OF MENTOR GRAPHICS
//           CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE
//                                  TERMS.
//
//                   Questa Verification Library (QVL)
//

`ifdef QVL_COVER_ON

  //---------------------------------------------------------------------
  // SV Covergroups start here
  //---------------------------------------------------------------------

  reg prevent_x_to_valid_transition_count;

  initial
    begin
      // This is required to prevent the coverpoints to increment
      // when 'x' to '0' transition that happens during start of
      // simulation
      prevent_x_to_valid_transition_count = 1'b0;
    end

  always @ (posedge clk)
    begin
      prevent_x_to_valid_transition_count <= 1'b1;
    end

  wire enable_coverpoint; // Wire to hold "when to increment the stats"

  assign collect_stats = 1'b1; // Not having any siginficance in SV.

  assign #1 enable_coverpoint = (collect_stats == 1'b1 && areset_n == 1'b1 &&
                                 ireset_n === 1'b1 && 
                                 prevent_x_to_valid_transition_count == 1'b1);
`ifdef QVL_SV_COVERGROUP
  covergroup ocp_statistics @ (posedge clk);

    type_option.strobe = 1;
    type_option.comment = "Statistics for OCP Monitor";

    S0 : coverpoint (!($stable(total_requests, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins Total_requests = {1};
        type_option.comment = "Total requests";
        }
    S1 : coverpoint (!($stable(back_to_back_read_requests, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins Back_to_back_Read_requests = {1};
        type_option.comment = "Back to back Read requests";
        }
    S2 : coverpoint (!($stable(back_to_back_write_requests, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins Back_to_back_Write_requests = {1};
        type_option.comment = "Back to back Write requests";
        }
    S3 : coverpoint (!($stable(back_to_back_broadcast_requests, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins Back_to_back_Broadcast_requests = {1};
        type_option.comment = "Back to back Broadcast requests";
        }
    S4 : coverpoint (!($stable(back_to_back_writenonpost_requests, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins Back_to_back_WriteNonPost_requests = {1};
        type_option.comment = "Back to back WriteNonPost requests";
        }
    S5 : coverpoint (!($stable(request_phases_with_all_data_masked, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins Request_phases_with_all_data_masked = {1};
        type_option.comment = "Request phases with all data masked";
        }
    S6 : coverpoint (!($stable(datahandshake_phases_with_all_data_masked, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins Datahandshake_phases_with_all_data_masked = {1};
        type_option.comment = "Datahandshake phases with all data masked";
        }
  endgroup : ocp_statistics

  covergroup ocp_cornercases @ (posedge clk);

    type_option.strobe = 1;
    type_option.comment = "Cornercases for OCP Monitor";

    C0 : coverpoint (!($stable(read_requests, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins Read_requests = {1};
        type_option.comment = "Read requests";
        }
    C1 : coverpoint (!($stable(write_requests, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins Write_requests = {1};
        type_option.comment = "Write requests";
        }
    C2 : coverpoint (!($stable(broadcast_requests, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins Broadcast_requests = {1};
        type_option.comment = "Broadcast requests";
        }
    C3 : coverpoint (!($stable(writenonpost_requests, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins WriteNonPost_requests = {1};
        type_option.comment = "WriteNonPost requests";
        }
    C4 : coverpoint (!($stable(writeconditional_requests, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins WriteConditional_requests = {1};
        type_option.comment = "WriteConditional requests";
        }
    C5 : coverpoint (!($stable(readlinked_requests, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins ReadLinked_requests = {1};
        type_option.comment = "ReadLinked requests";
        }
    C6 : coverpoint (!($stable(readex_requests, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins ReadEx_requests = {1};
        type_option.comment = "ReadEx requests";
        }
    C7 : coverpoint (!($stable(dflt1_burst_sequences, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins DFLT1_burst_sequences = {1};
        type_option.comment = "DFLT1 burst sequences";
        }
    C8 : coverpoint (!($stable(dflt2_burst_sequences, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins DFLT2_burst_sequences = {1};
        type_option.comment = "DFLT2 burst sequences";
        }
    C9 : coverpoint (!($stable(incr_burst_sequences, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins INCR_burst_sequences = {1};
        type_option.comment = "INCR burst sequences";
        }
    C10 : coverpoint (!($stable(strm_burst_sequences, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins STRM_burst_sequences = {1};
        type_option.comment = "STRM burst sequences";
        }
    C11 : coverpoint (!($stable(unkn_burst_sequences, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins UNKN_burst_sequences = {1};
        type_option.comment = "UNKN burst sequences";
        }
    C12 : coverpoint (!($stable(wrap_burst_sequences, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins WRAP_burst_sequences = {1};
        type_option.comment = "WRAP burst sequences";
        }
    C13 : coverpoint (!($stable(xor_burst_sequences, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins XOR_burst_sequences = {1};
        type_option.comment = "XOR burst sequences";
        }
    C14 : coverpoint (!($stable(imprecise_bursts, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins Imprecise_bursts = {1};
        type_option.comment = "Imprecise bursts";
        }
    C15 : coverpoint (!($stable(precise_bursts_with_multiple_requests, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins Precise_bursts_with_multiple_requests = {1};
        type_option.comment = "Precise bursts with multiple requests";
        }
    C16 : coverpoint (!($stable(precise_bursts_with_single_request, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins Precise_bursts_with_single_request = {1};
        type_option.comment = "Precise bursts with single request";
        }
    C17 : coverpoint (!($stable(dva_responses, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins DVA_responses = {1};
        type_option.comment = "DVA responses";
        }
    C18 : coverpoint (!($stable(err_responses, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins ERR_responses = {1};
        type_option.comment = "ERR responses";
        }
    C19 : coverpoint (!($stable(fail_responses, @ (posedge clk)))) iff(enable_coverpoint)
        {
        bins FAIL_responses = {1};
        type_option.comment = "FAIL responses";
        }
  endgroup : ocp_cornercases

  ocp_statistics  OCP_STATISTICS = new();
  ocp_cornercases OCP_CORNERCASES = new();

  initial
    begin
      ocp_statistics::type_option.comment = "Statistics for OCP Monitor";
      ocp_cornercases::type_option.comment = "Cornercases for OCP Monitor";
    end
`endif // QVL_SV_COVERGROUP

`ifdef QVL_MW_FINAL_COVER
  final
    begin
      $display("----------------------- Coverage for OCP Monitor -------------------------");
      $display("Monitor instance                           : %m");
      $display("----------------------- Statistics for OCP Monitor -----------------------");
      $display("Total requests                             : %0d", total_requests);
      $display("Back to back Read requests                 : %0d", back_to_back_read_requests);
      $display("Back to back Write requests                : %0d", back_to_back_write_requests);
      $display("Back to back WriteNonPost requests         : %0d", back_to_back_writenonpost_requests);
      $display("Back to back Broadcast requests            : %0d", back_to_back_writenonpost_requests);
      $display("Request phases with all data masked        : %0d", request_phases_with_all_data_masked);
      $display("Datahandshake phases with all data masked  : %0d", datahandshake_phases_with_all_data_masked);
      $display("----------------------- Cornercases for OCP Monitor -----------------------");
      $display("Read requests                              : %0d", read_requests);
      $display("Write requests                             : %0d", write_requests);
      $display("Broadcast requests                         : %0d", broadcast_requests);
      $display("WriteNonPost requests                      : %0d", writenonpost_requests);
      $display("WriteConditional requests                  : %0d", writeconditional_requests);
      $display("ReadLinked requests                        : %0d", readlinked_requests);
      $display("ReadEx requests                            : %0d", readex_requests);
      $display("DFLT1 burst sequences                      : %0d", dflt1_burst_sequences);
      $display("DFLT2 burst sequences                      : %0d", dflt2_burst_sequences);
      $display("INCR burst sequences                       : %0d", incr_burst_sequences);
      $display("STRM burst sequences                       : %0d", strm_burst_sequences);
      $display("UNKN burst sequences                       : %0d", unkn_burst_sequences);
      $display("WRAP burst sequences                       : %0d", wrap_burst_sequences);
      $display("XOR burst sequences                        : %0d", xor_burst_sequences);
      $display("Imprecise bursts                           : %0d", imprecise_bursts);
      $display("Precise bursts with multiple requests      : %0d", precise_bursts_with_multiple_requests);
      $display("Precise bursts with single request         : %0d", precise_bursts_with_single_request);
      $display("DVA responses                              : %0d", dva_responses);
      $display("ERR responses                              : %0d", err_responses);
      $display("FAIL responses                             : %0d", fail_responses);
    end
 `endif // QVL_MW_FINAL_COVER
  //---------------------------------------------------------------------

`endif //QVL_COVER_ON


