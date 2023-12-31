// Accellera Standard V2.2 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2008. All rights reserved.

`ifdef OVL_XCHECK_OFF
   //Do nothing
`else
  `ifdef OVL_IMPLICIT_XCHECK_OFF
    //Do nothing
  `else
  wire valid_test_expr;
  assign valid_test_expr = ~((^test_expr) ^ (^test_expr));
 `endif // OVL_IMPLICIT_XCHECK_OFF
`endif // OVL_XCHECK_OFF

`ifdef OVL_ASSERT_ON

  // local paramaters used as defines
  parameter OVERFLOW_START = 1'b0;
  parameter OVERFLOW_CHECK = 1'b1;

  reg r_state;

`ifdef OVL_SYNTHESIS
`else
  initial begin
    r_state=OVERFLOW_START;
  end
`endif

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin
      case (r_state)
        OVERFLOW_START:
          if (test_expr == max) begin
             r_state <= OVERFLOW_CHECK;
          end
        OVERFLOW_CHECK:
          if (test_expr != max) begin
            r_state <= OVERFLOW_START;
            if (test_expr <= min || test_expr > max) begin
              ovl_error_t(`OVL_FIRE_2STATE,"Test expression changed value from allowed maximum value max to a value in the range max+1 to min");
            end
          end
      endcase
    end
    else begin
      r_state <= OVERFLOW_START;
    end
  end // always

`endif // OVL_ASSERT_ON

`ifdef OVL_COVER_ON

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0 && coverage_level != `OVL_COVER_NONE) begin

     if(OVL_COVER_BASIC_ON) begin //basic coverage
      if (test_expr == max) begin
        ovl_cover_t("test_expr_at_max covered");
      end
     end //basic coverage

     if(OVL_COVER_CORNER_ON) begin //corner coverage
      if (test_expr == min) begin
          ovl_cover_t("test_expr_at_min covered");
      end
     end //corner coverage

    end // OVL_COVER_NONE
  end // always

`endif // OVL_COVER_ON

`ifdef OVL_XCHECK_OFF
   //Do nothing
`else
  `ifdef OVL_IMPLICIT_XCHECK_OFF
    //Do nothing
  `else
 `ifdef OVL_ASSERT_ON

  always @(posedge clk)
    begin
      if (`OVL_RESET_SIGNAL != 1'b0)
        begin
          if (valid_test_expr == 1'b1)
            begin
              // Do Nothing
            end
          else
            ovl_error_t(`OVL_FIRE_XCHECK,"test_expr contains X or Z");
        end
    end

 `endif // OVL_ASSERT_ON
 `endif // OVL_IMPLICIT_XCHECK_OFF
`endif // OVL_XCHECK_OFF
