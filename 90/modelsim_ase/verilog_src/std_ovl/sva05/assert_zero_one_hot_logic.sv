// Accellera Standard V2.2 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2008. All rights reserved.



`ifdef OVL_ASSERT_ON

`ifdef OVL_XCHECK_OFF
  //Do nothing
`else
  `ifdef OVL_IMPLICIT_XCHECK_OFF
    //Do nothing
  `else
    property ASSERT_ZERO_ONE_HOT_XZ_P;
    @(posedge clk)
    disable iff (`OVL_RESET_SIGNAL != 1'b1)
    (!($isunknown(test_expr)));
    endproperty
  `endif // OVL_IMPLICIT_XCHECK_OFF
`endif // OVL_XCHECK_OFF

  property ASSERT_ZERO_ONE_HOT_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  !($isunknown(test_expr)) |-> ($onehot0(test_expr));
  endproperty

  generate

    case (property_type)
      `OVL_ASSERT_2STATE,
      `OVL_ASSERT: begin : ovl_assert
        A_ASSERT_ZERO_ONE_HOT_P:    assert property (ASSERT_ZERO_ONE_HOT_P)
                                    else ovl_error_t(`OVL_FIRE_2STATE,"Test expression contains more than 1 asserted bits");

`ifdef OVL_XCHECK_OFF
  //Do nothing
`else
  `ifdef OVL_IMPLICIT_XCHECK_OFF
    //Do nothing
  `else
        A_ASSERT_ZERO_ONE_HOT_XZ_P: assert property (ASSERT_ZERO_ONE_HOT_XZ_P)
                                    else ovl_error_t(`OVL_FIRE_XCHECK,"test_expr contains X or Z");
  `endif // OVL_IMPLICIT_XCHECK_OFF
`endif // OVL_XCHECK_OFF

      end
      `OVL_ASSUME_2STATE,
      `OVL_ASSUME: begin : ovl_assume
        M_ASSERT_ZERO_ONE_HOT_P:    assume property (ASSERT_ZERO_ONE_HOT_P);

`ifdef OVL_XCHECK_OFF
  //Do nothing
`else
  `ifdef OVL_IMPLICIT_XCHECK_OFF
    //Do nothing
  `else
        M_ASSERT_ZERO_ONE_HOT_XZ_P: assume property (ASSERT_ZERO_ONE_HOT_XZ_P);
  `endif // OVL_IMPLICIT_XCHECK_OFF
`endif // OVL_XCHECK_OFF

      end
      `OVL_IGNORE : begin : ovl_ignore
         // Do nothing;
      end
      default     : initial ovl_error_t(`OVL_FIRE_2STATE,"");
    endcase

  endgenerate

`endif // OVL_ASSERT_ON

`ifdef OVL_COVER_ON

      wire [width-1:0] test_expr_1 = test_expr - {{width-1{1'b0}},1'b1};
      reg [width-1:0] one_hots_checked;

generate

    if (coverage_level != `OVL_COVER_NONE) begin : ovl_cover
     if (OVL_COVER_SANITY_ON) begin : ovl_cover_sanity

      cover_test_expr_change:
      cover property (@(posedge clk) ((`OVL_RESET_SIGNAL != 1'b0) &&
                     !$stable(test_expr) ))
                     ovl_cover_t("test_expr_change covered");
     end //sanity coverage

     if (OVL_COVER_CORNER_ON) begin : ovl_cover_corner

      always @(posedge clk) begin
        if (`OVL_RESET_SIGNAL != 1'b0) begin
          if ((test_expr ^ test_expr)=={width{1'b0}}) begin
            if ((test_expr & test_expr_1) == {width{1'b0}}) begin
              one_hots_checked <= one_hots_checked | test_expr;
            end
          end
        end
        else begin
`ifdef OVL_INIT_REG
         one_hots_checked <= {width{1'b0}};
`endif
        end
      end

      cover_test_expr_all_zeros:
      cover property (@(posedge clk) ( (`OVL_RESET_SIGNAL != 1'b0) &&
                     ($past(`OVL_RESET_SIGNAL) != 1'b0) &&
                     $rose(test_expr == {width{1'b0}}) ) )
                     ovl_cover_t("test_expr_all_zeros covered");

      cover_all_one_hots_checked:
      cover property (@(posedge clk) ( (`OVL_RESET_SIGNAL != 1'b0) &&
                     ($past(`OVL_RESET_SIGNAL) != 1'b0) &&
                     $rose(one_hots_checked == {width{1'b1}}) ) )
                     ovl_cover_t("all_one_hots_checked covered");
     end //corner coverage
    end

endgenerate

`endif // OVL_COVER_ON

