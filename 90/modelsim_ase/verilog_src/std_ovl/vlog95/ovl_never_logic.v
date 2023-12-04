// Accellera Standard V2.2 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2008. All rights reserved.


//------------------------------------------------------------------------------
// SHARED CODE
//------------------------------------------------------------------------------
// No shared code for this OVL


//------------------------------------------------------------------------------
// ASSERTION
//------------------------------------------------------------------------------
`ifdef OVL_ASSERT_ON

  // 2-STATE
  // =======
  wire fire_2state_1;
  reg  fire_2state;
  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL == 1'b0) begin
      // OVL does not fire during reset
      fire_2state <= 1'b0;
    end
    else begin
      if (fire_2state_1) begin
        ovl_error_t(`OVL_FIRE_2STATE,"Test expression is not FALSE");
        fire_2state <= ovl_fire_2state_f(property_type);
      end
      else begin
        fire_2state <= 1'b0;
      end
    end
  end

  assign fire_2state_1 = (test_expr == 1'b1);

  // X-CHECK
  // =======
  `ifdef OVL_XCHECK_OFF
    wire fire_xcheck = 1'b0;
  `else
    `ifdef OVL_IMPLICIT_XCHECK_OFF
      wire fire_xcheck = 1'b0;
    `else
      reg fire_xcheck_1;
      reg fire_xcheck;
      always @(posedge clk) begin
        if (`OVL_RESET_SIGNAL == 1'b0) begin
          // OVL does not fire during reset
          fire_xcheck <= 1'b0;
        end
        else begin
          if (fire_xcheck_1) begin
            ovl_error_t(`OVL_FIRE_XCHECK,"test_expr contains X or Z");
            fire_xcheck <= ovl_fire_xcheck_f(property_type);
          end
          else begin
            fire_xcheck <= 1'b0;
          end
        end
      end

      wire valid_test_expr = ((test_expr ^ test_expr) == 1'b0);

      always @ (valid_test_expr) begin
        if (valid_test_expr) begin
          fire_xcheck_1 = 1'b0;
        end
        else begin
          fire_xcheck_1 = 1'b1;
        end
      end

    `endif // OVL_IMPLICIT_XCHECK_OFF
  `endif // OVL_XCHECK_OFF

`else
  wire fire_2state = 1'b0;
  wire fire_xcheck = 1'b0;
`endif // OVL_ASSERT_ON


//------------------------------------------------------------------------------
// COVERAGE
//------------------------------------------------------------------------------
// No coverage for this OVL
wire fire_cover = 1'b0;