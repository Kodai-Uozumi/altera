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

`include "std_qvl_task.h"
`include "std_qvl_property.h"

`ifdef QVL_ASSERT_ON

  //---------------------------------------------------------------------

  parameter QVL_MSG = "USB 2.0 Violation: ";
  parameter QVL_ERROR = 1; //`OVL_ERROR;
  parameter QVL_INFO = 3; // `OVL_INFO;
  parameter QVL_PROPERTY_TYPE = 0;  // 0 = `OVL_ZIN2OVLSVA
                                    // 1 = `OVL_ASSUME
  parameter QVL_COVERAGE_LEVEL = 0; // `OVL_COVER_ALL;

  //---------------------------------------------------------------------
  // Protocol checks
  //---------------------------------------------------------------------

generate 
  case (MAC_LAYER_CONSTRAINT)
    `QVL_ASSERT :
      begin : qvl_assert_ASSERT_NEVER_MAC
        A_USB_2_0_UTMI_RX_VALID_ASSERTED_BEFORE_RX_ACTIVE: 
          assert property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( rx_valid_without_rx_active))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_RX_VALID_ASSERTED_BEFORE_RX_ACTIVE"}),
                          .msg            ("RxValid signal should be asserted after the assertion of RxActive signal."),
                          .severity_level (QVL_ERROR),
                          .property_type  (MAC_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_ILLEGAL_RX_VALIDH: 
          assert property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (((rx_vald_h_without_rx_valid && latched_databus16_8 === 1'b1)))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_ILLEGAL_RX_VALIDH"}),
                          .msg            ("RxValidH signal should not be asserted without asserting RxValid signal."),
                          .severity_level (QVL_ERROR),
                          .property_type  (MAC_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_RXERROR_ASSERTED: 
          assert property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( illegal_rx_error_assertion))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_RXERROR_ASSERTED"}),
                          .msg            ("Illegal RxError signal assertion."),
                          .severity_level (QVL_ERROR),
                          .property_type  (MAC_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_RX_VALID_NOT_NEGATED: 
          assert property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( rx_valid_not_deasserted))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_RX_VALID_NOT_NEGATED"}),
                          .msg            ("RxValid signal asserted after the negation of RxError signal."),
                          .severity_level (QVL_ERROR),
                          .property_type  (MAC_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_ILLEGAL_TX_READY: 
          assert property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (((tx_more_data_transfer_after_tx_valid_h && latched_databus16_8 === 1'b1)))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_ILLEGAL_TX_READY"}),
                          .msg            ("More than one byte transferred after the negation of TxValidH signal."),
                          .severity_level (QVL_ERROR),
                          .property_type  (MAC_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_ILLEGAL_RX_VALID: 
          assert property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (((rx_more_data_transfer_after_rx_valid_h && latched_databus16_8 === 1'b1)))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_ILLEGAL_RX_VALID"}),
                          .msg            ("More than one byte transferred after the negation of RxValidH signal."),
                          .severity_level (QVL_ERROR),
                          .property_type  (MAC_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_TX_READY_ASSERTED_MORE_THAN_ONE_CLOCK: 
          assert property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (((tx_ready_more_than_one_clock &&
                           (DEVICE_SPEED !== 0 ||(xcvr_select === 1'b1 && term_select === 1'b1)))))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_TX_READY_ASSERTED_MORE_THAN_ONE_CLOCK"}),
                          .msg            ("TxReady signal should be asserted for one clock per byte time."),
                          .severity_level (QVL_ERROR),
                          .property_type  (MAC_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_RX_VALID_MORE_THAN_ONE_CLOCK: 
          assert property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (((rx_valid_more_than_one_clock &&
                           (DEVICE_SPEED !== 0 ||(xcvr_select === 1'b1 && term_select === 1'b1)))))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_RX_VALID_MORE_THAN_ONE_CLOCK"}),
                          .msg            ("RxValid signal should be asserted for one clock per byte time."),
                          .severity_level (QVL_ERROR),
                          .property_type  (MAC_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_TX_VALID_DEASSERT_TO_RX_ACTIVE_ASSERT_MIN_ERROR: 
          assert property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( transmit_to_receive_delay_violation_min))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_TX_VALID_DEASSERT_TO_RX_ACTIVE_ASSERT_MIN_ERROR"}),
                          .msg            ("Minimum inter packet delay specification is violated while receiving a packet after the transmission of a packet."),
                          .severity_level (QVL_ERROR),
                          .property_type  (MAC_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_TX_VALID_DEASSERT_TO_RX_ACTIVE_ASSERT_MAX_ERROR: 
          assert property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( transmit_to_receive_delay_violation_max))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_TX_VALID_DEASSERT_TO_RX_ACTIVE_ASSERT_MAX_ERROR"}),
                          .msg            ("Maximum inter packet delay specification is violated while receiving a packet after the transmission of a packet."),
                          .severity_level (QVL_ERROR),
                          .property_type  (MAC_LAYER_CONSTRAINT));
      end
    `QVL_ASSUME : 
      begin : qvl_assume_ASSERT_NEVER_MAC
        M_USB_2_0_UTMI_RX_VALID_ASSERTED_BEFORE_RX_ACTIVE: 
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( rx_valid_without_rx_active))));
        M_USB_2_0_UTMI_ILLEGAL_RX_VALIDH: 
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (((rx_vald_h_without_rx_valid && latched_databus16_8 === 1'b1)))));
        M_USB_2_0_UTMI_RXERROR_ASSERTED: 
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( illegal_rx_error_assertion))));
        M_USB_2_0_UTMI_RX_VALID_NOT_NEGATED: 
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( rx_valid_not_deasserted))));
        M_USB_2_0_UTMI_ILLEGAL_TX_READY: 
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (((tx_more_data_transfer_after_tx_valid_h && latched_databus16_8 === 1'b1)))));
        M_USB_2_0_UTMI_ILLEGAL_RX_VALID: 
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (((rx_more_data_transfer_after_rx_valid_h && latched_databus16_8 === 1'b1)))));
        M_USB_2_0_UTMI_TX_READY_ASSERTED_MORE_THAN_ONE_CLOCK: 
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (((tx_ready_more_than_one_clock &&
                           (DEVICE_SPEED !== 0 ||(xcvr_select === 1'b1 && term_select === 1'b1)))))));
        M_USB_2_0_UTMI_RX_VALID_MORE_THAN_ONE_CLOCK: 
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (((rx_valid_more_than_one_clock &&
                           (DEVICE_SPEED !== 0 ||(xcvr_select === 1'b1 && term_select === 1'b1)))))));
        M_USB_2_0_UTMI_TX_VALID_DEASSERT_TO_RX_ACTIVE_ASSERT_MIN_ERROR: 
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( transmit_to_receive_delay_violation_min))));
        M_USB_2_0_UTMI_TX_VALID_DEASSERT_TO_RX_ACTIVE_ASSERT_MAX_ERROR: 
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( transmit_to_receive_delay_violation_max))));
      end
    `QVL_IGNORE : 
      begin : qvl_ignore_ASSERT_NEVER_MAC
      end
    default: initial qvl_error_t (
                          .err_msg        (""),
                          .msg            (""),
                          .severity_level (QVL_ERROR),
                          .property_type  (`QVL_IGNORE));
  endcase
endgenerate




`ifdef QVL_XCHECK_OFF
`else // QVL_XCHECK_OFF

generate 
  case (MAC_LAYER_CONSTRAINT)
    `QVL_ASSERT :
      begin : qvl_assert_ASSERT_NEVER_UNKNOWN_MAC
        A_USB_2_0_UTMI_TX_READY_KNOWN_DRIVEN: 
          assert property ( ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (tx_ready),
                          .qualifier (((tx_valid === 1'b1 || r_tx_valid === 1'b1)))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_TX_READY_KNOWN_DRIVEN"}),
                          .msg            ("TxReady is not driven to a valid level."),
                          .severity_level (QVL_ERROR),
                          .property_type  (MAC_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_RX_VALID_KNOWN_DRIVEN: 
          assert property ( ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (rx_valid),
                          .qualifier (((rx_active === 1'b1)))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_RX_VALID_KNOWN_DRIVEN"}),
                          .msg            ("RxValid is not driven to a valid level."),
                          .severity_level (QVL_ERROR),
                          .property_type  (MAC_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_RX_VALIDH_KNOWN_DRIVEN: 
          assert property ( ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (rx_valid_h),
                          .qualifier (((rx_valid === 1'b1 && databus16_8 === 1'b1)))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_RX_VALIDH_KNOWN_DRIVEN"}),
                          .msg            ("RxValidH is not driven to a valid level."),
                          .severity_level (QVL_ERROR),
                          .property_type  (MAC_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_RX_ACTIVE_KNOWN_DRIVEN: 
          assert property ( ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (rx_active),
                          .qualifier (( 1'b1))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_RX_ACTIVE_KNOWN_DRIVEN"}),
                          .msg            ("RxActive is not driven to a valid level."),
                          .severity_level (QVL_ERROR),
                          .property_type  (MAC_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_DATA_OUT_KNOWN_DRIVEN: 
          assert property ( ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr ((latched_databus16_8?{data_out_low_actual,data_out_high_actual}:{8'b00,data_out_low_actual})),
                          .qualifier (((rx_valid === 1'b1 && rx_active === 1'b1 && BI_DIRECTIONAL == 0)))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_DATA_OUT_KNOWN_DRIVEN"}),
                          .msg            ("DataOut is not driven to a valid level."),
                          .severity_level (QVL_ERROR),
                          .property_type  (MAC_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_RX_ERROR_KNOWN_DRIVEN: 
          assert property ( ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (rx_error),
                          .qualifier (((rx_active)))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_RX_ERROR_KNOWN_DRIVEN"}),
                          .msg            ("RxError is not driven to a valid level."),
                          .severity_level (QVL_ERROR),
                          .property_type  (MAC_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_LINE_STATE_KNOWN_DRIVEN: 
          assert property ( ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (line_state),
                          .qualifier (( 1'b1))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_LINE_STATE_KNOWN_DRIVEN"}),
                          .msg            ("LineState is not driven to a valid level."),
                          .severity_level (QVL_ERROR),
                          .property_type  (MAC_LAYER_CONSTRAINT));
     end
    `QVL_ASSUME :
      begin : qvl_assume_ASSERT_NEVER_UNKNOWN_MAC
        M_USB_2_0_UTMI_TX_READY_KNOWN_DRIVEN: 
          assume property (ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (tx_ready),
                          .qualifier (((tx_valid === 1'b1 || r_tx_valid === 1'b1)))));
        M_USB_2_0_UTMI_RX_VALID_KNOWN_DRIVEN: 
          assume property (ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (rx_valid),
                          .qualifier (((rx_active === 1'b1)))));
        M_USB_2_0_UTMI_RX_VALIDH_KNOWN_DRIVEN: 
          assume property (ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (rx_valid_h),
                          .qualifier (((rx_valid === 1'b1 && databus16_8 === 1'b1)))));
        M_USB_2_0_UTMI_RX_ACTIVE_KNOWN_DRIVEN: 
          assume property (ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (rx_active),
                          .qualifier (( 1'b1))));
        M_USB_2_0_UTMI_DATA_OUT_KNOWN_DRIVEN: 
          assume property (ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr ((latched_databus16_8?{data_out_low_actual,data_out_high_actual}:{8'b00,data_out_low_actual})),
                          .qualifier (((rx_valid === 1'b1 && rx_active === 1'b1 && BI_DIRECTIONAL == 0)))));
        M_USB_2_0_UTMI_RX_ERROR_KNOWN_DRIVEN: 
          assume property (ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (rx_error),
                          .qualifier (((rx_active)))));
        M_USB_2_0_UTMI_LINE_STATE_KNOWN_DRIVEN: 
          assume property (ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (line_state),
                          .qualifier (( 1'b1))));
     end
    `QVL_IGNORE : 
      begin : qvl_ignore_ASSERT_NEVER_UNKNOWN_MAC
      end
    default: initial qvl_error_t (
                          .err_msg        (""),
                          .msg            (""),
                          .severity_level (QVL_ERROR),
                          .property_type  (`QVL_IGNORE));
  endcase
endgenerate
`endif // QVL_XCHECK_OFF



generate 
  case (PHY_LAYER_CONSTRAINT)
    `QVL_ASSERT :
      begin : qvl_assert_ASSERT_NEVER_PHY
        A_USB_2_0_UTMI_ILLEGAL_TX_VALIDH: 
          assert property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( tx_vald_h_without_tx_valid))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_ILLEGAL_TX_VALIDH"}),
                          .msg            ("TxValidH signal should not be asserted without asserting TxValid signal."),
                          .severity_level (QVL_ERROR),
                          .property_type  (PHY_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_DATA_CHANGE_BEFORE_TX_READY: 
          assert property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (((tx_data_changed_before_sampling &&
                           (DEVICE_SPEED !== 0 ||(xcvr_select === 1'b1 && term_select === 1'b1)))))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_DATA_CHANGE_BEFORE_TX_READY"}),
                          .msg            ("Value on DataIn bus must be held until TxReady is sampled asserted."),
                          .severity_level (QVL_ERROR),
                          .property_type  (PHY_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_RX_DEASSERT_TO_TX_VALID_ASSERT_MIN_ERROR: 
          assert property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( receive_to_transmit_delay_violation_min))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_RX_DEASSERT_TO_TX_VALID_ASSERT_MIN_ERROR"}),
                          .msg            ("Minimum inter packet delay specification is violated while transmitting a packet after the reception of a packet."),
                          .severity_level (QVL_ERROR),
                          .property_type  (PHY_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_RX_DEASSERT_TO_TX_VALID_ASSERT_MAX_ERROR: 
          assert property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( receive_to_transmit_delay_violation_max))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_RX_DEASSERT_TO_TX_VALID_ASSERT_MAX_ERROR"}),
                          .msg            ("Maximum inter packet delay specification is violated while transmitting a packet after the reception of a packet."),
                          .severity_level (QVL_ERROR),
                          .property_type  (PHY_LAYER_CONSTRAINT));
      end
    `QVL_ASSUME :
      begin : qvl_assume_ASSERT_NEVER_PHY
        M_USB_2_0_UTMI_ILLEGAL_TX_VALIDH: 
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( tx_vald_h_without_tx_valid))));
        M_USB_2_0_UTMI_DATA_CHANGE_BEFORE_TX_READY: 
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (((tx_data_changed_before_sampling &&
                           (DEVICE_SPEED !== 0 ||(xcvr_select === 1'b1 && term_select === 1'b1)))))));
        M_USB_2_0_UTMI_RX_DEASSERT_TO_TX_VALID_ASSERT_MIN_ERROR: 
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( receive_to_transmit_delay_violation_min))));
        M_USB_2_0_UTMI_RX_DEASSERT_TO_TX_VALID_ASSERT_MAX_ERROR: 
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( receive_to_transmit_delay_violation_max))));
      end
    `QVL_IGNORE : 
      begin : qvl_ignore_ASSERT_NEVER_PHY
      end
    default: initial qvl_error_t (
                          .err_msg        (""),
                          .msg            (""),
                          .severity_level (QVL_ERROR),
                          .property_type  (`QVL_IGNORE));
  endcase
endgenerate
  



`ifdef QVL_XCHECK_OFF
`else // QVL_XCHECK_OFF

generate 
  case (PHY_LAYER_CONSTRAINT)
    `QVL_ASSERT :
      begin : qvl_assert_ASSERT_NEVER_UNKNOWN_PHY
        A_USB_2_0_UTMI_TX_VALID_KNOWN_DRIVEN: 
          assert property ( ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (tx_valid),
                          .qualifier (( 1'b1))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_TX_VALID_KNOWN_DRIVEN"}),
                          .msg            ("TxValid is not driven to a valid level."),
                          .severity_level (QVL_ERROR),
                          .property_type  (PHY_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_TX_VALIDH_KNOWN_DRIVEN: 
          assert property ( ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (tx_valid_h),
                          .qualifier (((tx_valid === 1'b1 && databus16_8 === 1'b1)))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_TX_VALIDH_KNOWN_DRIVEN"}),
                          .msg            ("TxValidH is not driven to a valid level."),
                          .severity_level (QVL_ERROR),
                          .property_type  (PHY_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_DATA_IN_KNOWN_DRIVEN: 
          assert property ( ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr ((latched_databus16_8?{data_in_low_actual,data_in_high_actual}:{8'b00,data_in_low_actual})),
                          .qualifier (((tx_valid === 1'b1 && BI_DIRECTIONAL == 0)))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_DATA_IN_KNOWN_DRIVEN"}),
                          .msg            ("DataIn is not driven to a valid level."),
                          .severity_level (QVL_ERROR),
                          .property_type  (PHY_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_DATABUS16_8_KNOWN_DRIVEN: 
          assert property ( ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (databus16_8),
                          .qualifier (((DEVICE_SPEED == 0)))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_DATABUS16_8_KNOWN_DRIVEN"}),
                          .msg            ("DataBus16_8 is not driven to a valid level."),
                          .severity_level (QVL_ERROR),
                          .property_type  (PHY_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_XCVR_SELECT_KNOWN_DRIVEN: 
          assert property ( ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (xcvr_select),
                          .qualifier (((DEVICE_SPEED == 0)))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_XCVR_SELECT_KNOWN_DRIVEN"}),
                          .msg            ("XcvrSelect is not driven to a valid level."),
                          .severity_level (QVL_ERROR),
                          .property_type  (PHY_LAYER_CONSTRAINT));
        A_USB_2_0_UTMI_TERM_SELECT_KNOWN_DRIVEN: 
          assert property ( ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (term_select),
                          .qualifier (((DEVICE_SPEED == 0)))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_TERM_SELECT_KNOWN_DRIVEN"}),
                          .msg            ("TermSelect is not driven to a valid level."),
                          .severity_level (QVL_ERROR),
                          .property_type  (PHY_LAYER_CONSTRAINT));
      end
    `QVL_ASSUME :
      begin : qvl_assume_ASSERT_NEVER_UNKNOWN_PHY 
        M_USB_2_0_UTMI_TX_VALID_KNOWN_DRIVEN: 
          assume property (ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (tx_valid),
                          .qualifier (( 1'b1))));
        M_USB_2_0_UTMI_TX_VALIDH_KNOWN_DRIVEN: 
          assume property (ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (tx_valid_h),
                          .qualifier (((tx_valid === 1'b1 && databus16_8 === 1'b1)))));
        M_USB_2_0_UTMI_DATA_IN_KNOWN_DRIVEN: 
          assume property (ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr ((latched_databus16_8?{data_in_low_actual,data_in_high_actual}:{8'b00,data_in_low_actual})),
                          .qualifier (((tx_valid === 1'b1 && BI_DIRECTIONAL == 0)))));
        M_USB_2_0_UTMI_DATABUS16_8_KNOWN_DRIVEN: 
          assume property (ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (databus16_8),
                          .qualifier (((DEVICE_SPEED == 0)))));
        M_USB_2_0_UTMI_XCVR_SELECT_KNOWN_DRIVEN: 
          assume property (ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (xcvr_select),
                          .qualifier (((DEVICE_SPEED == 0)))));
        M_USB_2_0_UTMI_TERM_SELECT_KNOWN_DRIVEN: 
          assume property (ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (term_select),
                          .qualifier (((DEVICE_SPEED == 0)))));
      end
    `QVL_IGNORE : 
      begin : qvl_ignore_ASSERT_NEVER_UNKNOWN_PHY 
      end
    default: initial qvl_error_t (
                          .err_msg        (""),
                          .msg            (""),
                          .severity_level (QVL_ERROR),
                          .property_type  (`QVL_IGNORE));
  endcase
endgenerate
`endif // QVL_XCHECK_OFF




generate 
  case (Constraints_Mode)
    `QVL_ASSERT :
      begin : qvl_assert_ASSERT_NEVER_CM
        A_USB_2_0_UTMI_TX_VALID_RX_ACTIVE_ASSERTED: 
          assert property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (((tx_valid === 1'b1 && rx_active === 1'b1)))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_TX_VALID_RX_ACTIVE_ASSERTED"}),
                          .msg            ("TxValid and RxActive signal should not be asserted together."),
                          .severity_level (QVL_ERROR),
                          .property_type  (Constraints_Mode));
        A_USB_2_0_UTMI_NUMBER_OF_ENDPOINTS_ERROR: 
          assert property ( ASSERT_NEVER_P ( 
                          .clock     (clock),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (((first_clock_after_reset === 1'b1 &&
                           ((NUMBER_OF_ENDPOINTS > 32 && DEVICE_SPEED != 2) ||
                           (NUMBER_OF_ENDPOINTS > 3 && DEVICE_SPEED == 2)))))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_NUMBER_OF_ENDPOINTS_ERROR"}),
                          .msg            ("Maximum number of end points supported is 32 for full/high speed devices and 3 for low speed devices."),
                          .severity_level (QVL_ERROR),
                          .property_type  (Constraints_Mode));
        A_USB_2_0_UTMI_DATABUS16_8_LEVEL_CHANGE: 
          assert property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( latched_databus16_8 !== databus16_8 &&
                           first_clock_after_reset == 1'b0))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_DATABUS16_8_LEVEL_CHANGE"}),
                          .msg            ("Signal 'databus16_8' should not be toggled."),
                          .severity_level (QVL_ERROR),
                          .property_type  (Constraints_Mode));
        A_USB_2_0_UTMI_INVALID_CHIRP_SEQUENCE:
          assert property ( ASSERT_NEVER_P (
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (invalid_chirp_sequence)))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_INVALID_CHIRP_SEQUENCE"}),
                          .msg            ("Chirp sequence for high speed detection is invalid."),
                          .severity_level (QVL_ERROR),
                          .property_type  (Constraints_Mode));
        A_USB_2_0_UTMI_TIMEOUT_KJ_CHIRP_DURATION:
          assert property ( ASSERT_NEVER_P (
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (chirp_kj_duration_timeout)))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_TIMEOUT_KJ_CHIRP_DURATION"}),
                          .msg            ("Chirp duration for K or J driven by the hub during High speed detection sequence, has timed out."),
                          .severity_level (QVL_ERROR),
                          .property_type  (Constraints_Mode));
        A_USB_2_0_UTMI_J_STATE_DURING_DEV_K_CHIRP:
          assert property ( ASSERT_NEVER_P (
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (device_j_state_during_chirping)))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_J_STATE_DURING_DEV_K_CHIRP"}),
                          .msg            ("Line state has transitioned to J state while device was sending K chirp during speed detect sequence."),
                          .severity_level (QVL_ERROR),
                          .property_type  (Constraints_Mode));
        A_USB_2_0_UTMI_DEV_INITIATE_WITH_J_DURING_CHIRP:
          assert property ( ASSERT_NEVER_P (
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (device_initiated_with_j_during_chirp)))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_DEV_INITIATE_WITH_J_DURING_CHIRP"}),
                          .msg            ("Line state has transitioned to J state in order to begin chirping by the device."),
                          .severity_level (QVL_ERROR),
                          .property_type  (Constraints_Mode));
        A_USB_2_0_UTMI_TERM_SEL_DEASSERT_TIMEOUT:
          assert property ( ASSERT_NEVER_P (
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (term_sel_deassert_timeout)))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_TERM_SEL_DEASSERT_TIMEOUT"}),
                          .msg            ("term_select signal did not change to low level before 500us after detecting the device as a high speed device."),
                          .severity_level (QVL_ERROR),
                          .property_type  (Constraints_Mode));
      end
    `QVL_ASSUME :
      begin : qvl_assume_ASSERT_NEVER_CM
        M_USB_2_0_UTMI_TX_VALID_RX_ACTIVE_ASSERTED: 
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (((tx_valid === 1'b1 && rx_active === 1'b1)))));
        M_USB_2_0_UTMI_NUMBER_OF_ENDPOINTS_ERROR: 
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (((first_clock_after_reset === 1'b1 &&
                           ((NUMBER_OF_ENDPOINTS > 32 && DEVICE_SPEED != 2) ||
                           (NUMBER_OF_ENDPOINTS > 3 && DEVICE_SPEED == 2)))))));
        M_USB_2_0_UTMI_DATABUS16_8_LEVEL_CHANGE: 
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( latched_databus16_8 !== databus16_8 &&
                           first_clock_after_reset == 1'b0))));
        M_USB_2_0_UTMI_INVALID_CHIRP_SEQUENCE:
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (invalid_chirp_sequence)));
        M_USB_2_0_UTMI_TIMEOUT_KJ_CHIRP_DURATION:
          assume property ( ASSERT_NEVER_P (
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (chirp_kj_duration_timeout)));
        M_USB_2_0_UTMI_J_STATE_DURING_DEV_K_CHIRP:
          assume property ( ASSERT_NEVER_P (
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (device_j_state_during_chirping)));
        M_USB_2_0_UTMI_DEV_INITIATE_WITH_J_DURING_CHIRP:
          assume property ( ASSERT_NEVER_P (
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (device_initiated_with_j_during_chirp)));
        M_USB_2_0_UTMI_TERM_SEL_DEASSERT_TIMEOUT:
          assume property ( ASSERT_NEVER_P (
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (term_sel_deassert_timeout)));
    end
    `QVL_IGNORE : 
      begin : qvl_ignore_ASSERT_NEVER_CM
      end
    default: initial qvl_error_t (
                          .err_msg        (""),
                          .msg            (""),
                          .severity_level (QVL_ERROR),
                          .property_type  (`QVL_IGNORE));
  endcase
endgenerate





`ifdef QVL_XCHECK_OFF
`else // QVL_XCHECK_OFF

generate 
  case (Constraints_Mode)
    `QVL_ASSERT :
      begin : qvl_assert_ASSERT_NEVER_UNKNOWN_CM
        A_USB_2_0_UTMI_DATA_LOW_KNOWN_DRIVEN: 
          assert property ( ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (data_low),
                          .qualifier (((BI_DIRECTIONAL == 1)))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_DATA_LOW_KNOWN_DRIVEN"}),
                          .msg            ("Data[7:0] bus is not driven to a valid level."),
                          .severity_level (QVL_ERROR),
                          .property_type  (Constraints_Mode));
        A_USB_2_0_UTMI_DATA_HIGH_KNOWN_DRIVEN: 
          assert property ( ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (data_high),
                          .qualifier (((BI_DIRECTIONAL == 1 && latched_databus16_8 === 1'b1)))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_DATA_HIGH_KNOWN_DRIVEN"}),
                          .msg            ("Data[15:8] bus is not driven to a valid level."),
                          .severity_level (QVL_ERROR),
                          .property_type  (Constraints_Mode));
        A_USB_2_0_UTMI_VALIDH_KNOWN_DRIVEN: 
          assert property ( ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (valid_h),
                          .qualifier (((BI_DIRECTIONAL == 1 && latched_databus16_8 === 1'b1)))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_UTMI_VALIDH_KNOWN_DRIVEN"}),
                          .msg            ("ValidH is not driven to a valid level."),
                          .severity_level (QVL_ERROR),
                          .property_type  (Constraints_Mode));
      end
    `QVL_ASSUME :
      begin : qvl_assume_ASSERT_NEVER_UNKNOWN_CM
        M_USB_2_0_UTMI_DATA_LOW_KNOWN_DRIVEN: 
          assume property (ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (data_low),
                          .qualifier (((BI_DIRECTIONAL == 1)))));
        M_USB_2_0_UTMI_DATA_HIGH_KNOWN_DRIVEN: 
          assume property (ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (data_high),
                          .qualifier (((BI_DIRECTIONAL == 1 && latched_databus16_8 === 1'b1)))));
        M_USB_2_0_UTMI_VALIDH_KNOWN_DRIVEN: 
          assume property (ASSERT_NEVER_UNKNOWN_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .test_expr (valid_h),
                          .qualifier (((BI_DIRECTIONAL == 1 && latched_databus16_8 === 1'b1)))));
      end
    `QVL_IGNORE : 
      begin : qvl_ignore_ASSERT_NEVER_UNKNOWN_CM
      end
    default: initial qvl_error_t (
                          .err_msg        (""),
                          .msg            (""),
                          .severity_level (QVL_ERROR),
                          .property_type  (`QVL_IGNORE));
  endcase
endgenerate
`endif // QVL_XCHECK_OFF


generate 
  case (ZI_DEVICE_SIDE_CONSTRAINT)
    `QVL_ASSERT :
      begin : qvl_assert_ASSERT_NEVER_ZID
        A_USB_2_0_TKN_PKT_SIZE_ERR: 
          assert property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( tkn_pkt_size_err))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_TKN_PKT_SIZE_ERR"}),
                          .msg            ("Token packets should have 24 bits."),
                          .severity_level (QVL_ERROR),
                          .property_type  (ZI_DEVICE_SIDE_CONSTRAINT));
        A_USB_2_0_SPLIT_PKT_SIZE_ERR: 
          assert property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( split_tkn_pkt_size_err))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_SPLIT_PKT_SIZE_ERR"}),
                          .msg            ("A SPLIT token should have 32 bits."),
                          .severity_level (QVL_ERROR),
                          .property_type  (ZI_DEVICE_SIDE_CONSTRAINT));
        A_USB_2_0_HANDSHAKE_PKT_SIZE_ERR_HOST: 
          assert property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (((handshake_pkt_size_err && host_is_transmitting)))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_HANDSHAKE_PKT_SIZE_ERR_HOST"}),
                          .msg            ("A handshake packet should have only 8 bits."),
                          .severity_level (QVL_ERROR),
                          .property_type  (ZI_DEVICE_SIDE_CONSTRAINT));
      end
    `QVL_ASSUME :
      begin : qvl_assume_ASSERT_NEVER_ZID
        M_USB_2_0_TKN_PKT_SIZE_ERR: 
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( tkn_pkt_size_err))));
        M_USB_2_0_SPLIT_PKT_SIZE_ERR: 
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (( split_tkn_pkt_size_err))));
        M_USB_2_0_HANDSHAKE_PKT_SIZE_ERR_HOST: 
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (((handshake_pkt_size_err && host_is_transmitting)))));
      end
    `QVL_IGNORE : 
      begin : qvl_ignore_ASSERT_NEVER_ZID
      end
    default: initial qvl_error_t (
                          .err_msg        (""),
                          .msg            (""),
                          .severity_level (QVL_ERROR),
                          .property_type  (`QVL_IGNORE));
  endcase
endgenerate


generate 
  case (ZI_HOST_SIDE_CONSTRAINT)
    `QVL_ASSERT :
      begin : qvl_assert_ASSERT_NEVER_ZIH
        A_USB_2_0_HANDSHAKE_PKT_SIZE_ERR_DEVICE: 
          assert property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (((handshake_pkt_size_err && device_is_transmitting)))))
          else qvl_error_t(
                          .err_msg        ({QVL_MSG,"A_USB_2_0_HANDSHAKE_PKT_SIZE_ERR_DEVICE"}),
                          .msg            ("A handshake packet should have only 8 bits."),
                          .severity_level (QVL_ERROR),
                          .property_type  (ZI_HOST_SIDE_CONSTRAINT));
      end
    `QVL_ASSUME :
      begin : qvl_assume_ASSERT_NEVER_ZIH
        M_USB_2_0_HANDSHAKE_PKT_SIZE_ERR_DEVICE: 
          assume property ( ASSERT_NEVER_P ( 
                          .clock     (clock ),
                          .reset_n   ((!areset && !reset) ),
                          .enable    (1'b1),
                          .test_expr (((handshake_pkt_size_err && device_is_transmitting)))));
      end
    `QVL_IGNORE : 
      begin : qvl_ignore_ASSERT_NEVER_ZIH
      end
    default: initial qvl_error_t (
                          .err_msg        (""),
                          .msg            (""),
                          .severity_level (QVL_ERROR),
                          .property_type  (`QVL_IGNORE));
  endcase
endgenerate

`endif // QVL_ASSERT_ON
