// Accellera Standard V2.2 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2008. All rights reserved.




`ifdef OVL_ASSERT_ON

  property ASSERT_ODD_PARITY_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  (^(test_expr));
  endproperty


`ifdef OVL_XCHECK_OFF
  //Do nothing
`else
  `ifdef OVL_IMPLICIT_XCHECK_OFF
    //Do nothing
  `else
  property ASSERT_ODD_PARITY_XZ_ON_TEST_EXPR_P;
  @ (posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  ((!($isunknown(test_expr))));
  endproperty
  `endif // OVL_IMPLICIT_XCHECK_OFF
`endif // OVL_XCHECK_OFF

  generate

    case (property_type)
      `OVL_ASSERT_2STATE,
      `OVL_ASSERT: begin : ovl_assert
        A_ASSERT_ODD_PARITY_P: assert property (ASSERT_ODD_PARITY_P)
                               else ovl_error_t(`OVL_FIRE_2STATE,"Test expression does not exhibit odd parity");

`ifdef OVL_XCHECK_OFF
  //Do nothing
`else
  `ifdef OVL_IMPLICIT_XCHECK_OFF
    //Do nothing
  `else
        A_ASSERT_ODD_PARITY_XZ_ON_TEST_EXPR_P:
        assert property (ASSERT_ODD_PARITY_XZ_ON_TEST_EXPR_P)
        else ovl_error_t(`OVL_FIRE_XCHECK,"test_expr contains X or Z");
  `endif // OVL_IMPLICIT_XCHECK_OFF
`endif // OVL_XCHECK_OFF

      end

      `OVL_ASSUME_2STATE,
      `OVL_ASSUME: begin : ovl_assume
        M_ASSERT_ODD_PARITY_P: assume property (ASSERT_ODD_PARITY_P);

`ifdef OVL_XCHECK_OFF
  //Do nothing
`else
  `ifdef OVL_IMPLICIT_XCHECK_OFF
    //Do nothing
  `else
        M_ASSERT_ODD_PARITY_XZ_ON_TEST_EXPR_P:
        assume property (ASSERT_ODD_PARITY_XZ_ON_TEST_EXPR_P);
  `endif // OVL_IMPLICIT_XCHECK_OFF
`endif // OVL_XCHECK_OFF

      end
      `OVL_IGNORE : begin : ovl_ignore
        // do nothing;
      end
      default     : initial ovl_error_t(`OVL_FIRE_2STATE,"");
    endcase

  endgenerate

`endif // OVL_ASSERT_ON

`ifdef OVL_COVER_ON

generate

    if (coverage_level != `OVL_COVER_NONE) begin : ovl_cover
     if (OVL_COVER_SANITY_ON) begin : ovl_cover_sanity

      cover_test_expr_change:
      cover property (@(posedge clk) ( (`OVL_RESET_SIGNAL != 1'b0) && $past(`OVL_RESET_SIGNAL != 1'b0) &&
                                    !$stable(test_expr) ) )
                    ovl_cover_t("test_expr_change covered");
     end //sanity coverage
    end

endgenerate

`endif // OVL_COVER_ON

