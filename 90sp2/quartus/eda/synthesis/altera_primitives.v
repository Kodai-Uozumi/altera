module    dffe    (
    prn,
    clrn,
    d,
    clk,
    q,
    ena);



    input    prn;
    input    clrn;
    input    d;
    input    clk;
    output    q;
    input    ena;

endmodule //dffe

module    carry_sum    (
    sin,
    sout,
    cout,
    cin);



    input    sin;
    output    sout;
    output    cout;
    input    cin;

endmodule //carry_sum

module    soft    (
    out,
    in);



    output    out;
    input    in;

endmodule //soft

module    cascade    (
    out,
    in);



    output    out;
    input    in;

endmodule //cascade

module    latch    (
    q,
    ena,
    d);



    output    q;
    input    ena;
    input    d;

endmodule //latch

module    TRI    (
    out,
    oe,
    in);



    output    out;
    input    oe;
    input    in;

endmodule //TRI

module    dffeas    (
    devclrn,
    prn,
    clrn,
    d,
    sclr,
    sload,
    asdata,
    devpor,
    clk,
    q,
    aload,
    ena);

    parameter    lpm_type    =    "dffeas";
    parameter    x_on_violation    =    "on";
    parameter    is_wysiwyg    =    "false";
    parameter    power_up    =    "DONT_CARE";


    input    devclrn;
    input    prn;
    input    clrn;
    input    d;
    input    sclr;
    input    sload;
    input    asdata;
    input    devpor;
    input    clk;
    output    q;
    input    aload;
    input    ena;

endmodule //dffeas

module    alt_bidir_buf    (
    oe,
    bidirin,
    io);

    parameter    enable_bus_hold    =    "NONE";
    parameter    slew_rate    =    -1;
    parameter    location    =    "NONE";
    parameter    lpm_type    =    "alt_bidir_diff";
    parameter    weak_pull_up_resistor    =    "NONE";
    parameter    io_standard    =    "NONE";
    parameter    termination    =    "NONE";
    parameter    current_strength    =    "NONE";
    parameter    input_termination    =    "NONE";
    parameter    output_termination    =    "NONE";
    parameter    current_strength_new    =    "NONE";


    input    oe;
    inout    bidirin;
    inout    io;

endmodule //alt_bidir_buf

module    alt_bidir_diff    (
    oe,
    iobar,
    bidirin,
    io);

    parameter    enable_bus_hold    =    "NONE";
    parameter    slew_rate    =    -1;
    parameter    location    =    "NONE";
    parameter    lpm_type    =    "alt_bidir_diff";
    parameter    weak_pull_up_resistor    =    "NONE";
    parameter    io_standard    =    "NONE";
    parameter    termination    =    "NONE";
    parameter    current_strength    =    "NONE";
    parameter    input_termination    =    "NONE";
    parameter    output_termination    =    "NONE";
    parameter    current_strength_new    =    "NONE";


    input    oe;
    inout    iobar;
    inout    bidirin;
    inout    io;

endmodule //alt_bidir_diff

module    alt_inbuf    (
    o,
    i);

    parameter    lpm_type    =    "alt_inbuf";
    parameter    enable_bus_hold    =    "NONE";
    parameter    weak_pull_up_resistor    =    "NONE";
    parameter    io_standard    =    "NONE";
    parameter    termination    =    "NONE";
    parameter    location    =    "NONE";


    output    o;
    input    i;

endmodule //alt_inbuf

module    alt_inbuf_diff    (
    ibar,
    o,
    i);

    parameter    enable_bus_hold    =    "NONE";
    parameter    location    =    "NONE";
    parameter    lpm_type    =    "alt_inbuf_diff";
    parameter    weak_pull_up_resistor    =    "NONE";
    parameter    io_standard    =    "NONE";
    parameter    termination    =    "NONE";


    input    ibar;
    output    o;
    input    i;

endmodule //alt_inbuf_diff

module    alt_iobuf    (
    oe,
    io,
    o,
    i);



    input    oe;
    inout    io;
    output    o;
    input    i;

endmodule //alt_iobuf

module    alt_iobuf_diff    (
    oe,
    iobar,
    io,
    o,
    i);

    parameter    enable_bus_hold    =    "NONE";
    parameter    slew_rate    =    -1;
    parameter    location    =    "NONE";
    parameter    lpm_type    =    "alt_iobuf_diff";
    parameter    weak_pull_up_resistor    =    "NONE";
    parameter    io_standard    =    "NONE";
    parameter    termination    =    "NONE";
    parameter    current_strength    =    "NONE";
    parameter    input_termination    =    "NONE";
    parameter    output_termination    =    "NONE";
    parameter    current_strength_new    =    "NONE";


    input    oe;
    inout    iobar;
    inout    io;
    output    o;
    input    i;

endmodule //alt_iobuf_diff

module    alt_outbuf    (
    o,
    i);

    parameter    enable_bus_hold    =    "NONE";
    parameter    slew_rate    =    -1;
    parameter    location    =    "NONE";
    parameter    slow_slew_rate    =    "NONE";
    parameter    lpm_type    =    "alt_outbuf";
    parameter    weak_pull_up_resistor    =    "NONE";
    parameter    io_standard    =    "NONE";
    parameter    termination    =    "NONE";
    parameter    current_strength    =    "NONE";
    parameter    current_strength_new    =    "NONE";


    output    o;
    input    i;

endmodule //alt_outbuf

module    alt_outbuf_diff    (
    obar,
    o,
    i);

    parameter    enable_bus_hold    =    "NONE";
    parameter    slew_rate    =    -1;
    parameter    location    =    "NONE";
    parameter    lpm_type    =    "alt_outbuf_diff";
    parameter    weak_pull_up_resistor    =    "NONE";
    parameter    io_standard    =    "NONE";
    parameter    termination    =    "NONE";
    parameter    current_strength    =    "NONE";
    parameter    current_strength_new    =    "NONE";


    output    obar;
    output    o;
    input    i;

endmodule //alt_outbuf_diff

module    alt_outbuf_tri    (
    oe,
    o,
    i);

    parameter    enable_bus_hold    =    "NONE";
    parameter    slew_rate    =    -1;
    parameter    location    =    "NONE";
    parameter    slow_slew_rate    =    "NONE";
    parameter    lpm_type    =    "alt_outbuf_tri";
    parameter    weak_pull_up_resistor    =    "NONE";
    parameter    io_standard    =    "NONE";
    parameter    termination    =    "NONE";
    parameter    current_strength    =    "NONE";
    parameter    current_strength_new    =    "NONE";


    input    oe;
    output    o;
    input    i;

endmodule //alt_outbuf_tri

module    alt_outbuf_tri_diff    (
    obar,
    oe,
    o,
    i);

    parameter    enable_bus_hold    =    "NONE";
    parameter    slew_rate    =    -1;
    parameter    location    =    "NONE";
    parameter    lpm_type    =    "alt_outbuf_tri_diff";
    parameter    weak_pull_up_resistor    =    "NONE";
    parameter    io_standard    =    "NONE";
    parameter    termination    =    "NONE";
    parameter    current_strength    =    "NONE";
    parameter    current_strength_new    =    "NONE";


    output    obar;
    input    oe;
    output    o;
    input    i;

endmodule //alt_outbuf_tri_diff

module    carry    (
    out,
    in);



    output    out;
    input    in;

endmodule //carry

module    exp    (
    out,
    in);



    output    out;
    input    in;

endmodule //exp

module    global    (
    out,
    in);



    output    out;
    input    in;

endmodule //global

module    opndrn    (
    out,
    in);



    output    out;
    input    in;

endmodule //opndrn

module    row_global    (
    out,
    in);



    output    out;
    input    in;

endmodule //row_global

