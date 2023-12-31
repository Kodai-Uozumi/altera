// Accellera Standard V2.2 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2008. All rights reserved.


`ifdef OVL_ASSERT_ON

 wire xzcheck_enable;

 wire psl_valid_test_expr;
 reg xzdetect_bit;

`ifdef OVL_XCHECK_OFF
  assign xzcheck_enable = 1'b0;
`else
  `ifdef OVL_IMPLICIT_XCHECK_OFF
    assign xzcheck_enable = 1'b0;
  `else
    assign xzcheck_enable = 1'b1;

    assign psl_valid_test_expr = ~(test_expr ^ test_expr);

    always@( reset_n or psl_valid_test_expr )
      begin
        if( reset_n == 1'b0 )
          begin
            xzdetect_bit = 1'b0;
          end
        else
          begin
            if( psl_valid_test_expr )
              begin
                //Do nothing
              end
             else
              begin
                xzdetect_bit = ~xzdetect_bit;
              end
          end
      end

  `endif // OVL_IMPLICIT_XCHECK_OFF
`endif // OVL_XCHECK_OFF

 generate
   case (property_type)
     `OVL_ASSERT_2STATE,
     `OVL_ASSERT: begin  : assert_checks
                    assert_proposition_assert
                    assert_proposition_assert (
                       .reset_n(`OVL_RESET_SIGNAL),
                       .test_expr(test_expr),
                       .xzdetect_bit(xzdetect_bit),
                       .xzcheck_enable(xzcheck_enable));
                  end
     `OVL_IGNORE: begin: ovl_ignore
                    //do nothing
                  end
     default: initial ovl_error_t(`OVL_FIRE_2STATE,"");
   endcase
 endgenerate
`endif

`endmodule //Required to pair up with already used "`module" in file assert_proposition.vlib

//Module to be replicated for assert checks
//This module is bound to the PSL vunits with assert checks
module assert_proposition_assert (reset_n, test_expr, xzdetect_bit, xzcheck_enable);
       input reset_n, test_expr;
       input xzdetect_bit, xzcheck_enable;
endmodule
