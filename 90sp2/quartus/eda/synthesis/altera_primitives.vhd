package altera_primitives_components is

component    dffe
    port    (
        prn    :    in    std_logic;
        clrn    :    in    std_logic;
        d    :    in    std_logic;
        clk    :    in    std_logic;
        q    :    out    std_logic;
        ena    :    in    std_logic
    );
end component; --dffe


component    carry_sum
    port    (
        sin    :    in    std_logic;
        sout    :    out    std_logic;
        cout    :    out    std_logic;
        cin    :    in    std_logic
    );
end component; --carry_sum


component    soft
    port    (
        a_out    :    out    std_logic;
        a_in    :    in    std_logic
    );
end component; --soft


component    cascade
    port    (
        a_out    :    out    std_logic;
        a_in    :    in    std_logic
    );
end component; --cascade


component    latch
    port    (
        q    :    out    std_logic;
        ena    :    in    std_logic;
        d    :    in    std_logic
    );
end component; --latch


component    TRI
    port    (
        a_out    :    out    std_logic;
        oe    :    in    std_logic;
        a_in    :    in    std_logic
    );
end component; --TRI


component    dffeas
    generic    (
        lpm_type    :    string    :=    "dffeas";
        x_on_violation    :    string    :=    "on";
        is_wysiwyg    :    string    :=    "false";
        power_up    :    string    :=    "DONT_CARE"
    );
    port    (
        devclrn    :    in    std_logic;
        prn    :    in    std_logic;
        clrn    :    in    std_logic;
        d    :    in    std_logic;
        sclr    :    in    std_logic;
        sload    :    in    std_logic;
        asdata    :    in    std_logic;
        devpor    :    in    std_logic;
        clk    :    in    std_logic;
        q    :    out    std_logic;
        aload    :    in    std_logic;
        ena    :    in    std_logic
    );
end component; --dffeas


component    alt_bidir_buf
    generic    (
        enable_bus_hold    :    string    :=    "NONE";
        slew_rate    :    natural    :=    -1;
        location    :    string    :=    "NONE";
        lpm_type    :    string    :=    "alt_bidir_diff";
        weak_pull_up_resistor    :    string    :=    "NONE";
        io_standard    :    string    :=    "NONE";
        termination    :    string    :=    "NONE";
        current_strength    :    string    :=    "NONE";
        input_termination    :    string    :=    "NONE";
        output_termination    :    string    :=    "NONE";
        current_strength_new    :    string    :=    "NONE"
    );
    port    (
        oe    :    in    std_logic;
        bidirin    :    inout    std_logic;
        io    :    inout    std_logic
    );
end component; --alt_bidir_buf


component    alt_bidir_diff
    generic    (
        enable_bus_hold    :    string    :=    "NONE";
        slew_rate    :    natural    :=    -1;
        location    :    string    :=    "NONE";
        lpm_type    :    string    :=    "alt_bidir_diff";
        weak_pull_up_resistor    :    string    :=    "NONE";
        io_standard    :    string    :=    "NONE";
        termination    :    string    :=    "NONE";
        current_strength    :    string    :=    "NONE";
        input_termination    :    string    :=    "NONE";
        output_termination    :    string    :=    "NONE";
        current_strength_new    :    string    :=    "NONE"
    );
    port    (
        oe    :    in    std_logic;
        iobar    :    inout    std_logic;
        bidirin    :    inout    std_logic;
        io    :    inout    std_logic
    );
end component; --alt_bidir_diff


component    alt_inbuf
    generic    (
        lpm_type    :    string    :=    "alt_inbuf";
        enable_bus_hold    :    string    :=    "NONE";
        weak_pull_up_resistor    :    string    :=    "NONE";
        io_standard    :    string    :=    "NONE";
        termination    :    string    :=    "NONE";
        location    :    string    :=    "NONE"
    );
    port    (
        o    :    out    std_logic;
        i    :    in    std_logic
    );
end component; --alt_inbuf


component    alt_inbuf_diff
    generic    (
        enable_bus_hold    :    string    :=    "NONE";
        location    :    string    :=    "NONE";
        lpm_type    :    string    :=    "alt_inbuf_diff";
        weak_pull_up_resistor    :    string    :=    "NONE";
        io_standard    :    string    :=    "NONE";
        termination    :    string    :=    "NONE"
    );
    port    (
        ibar    :    in    std_logic;
        o    :    out    std_logic;
        i    :    in    std_logic
    );
end component; --alt_inbuf_diff


component    alt_iobuf
    port    (
        oe    :    in    std_logic;
        io    :    inout    std_logic;
        o    :    out    std_logic;
        i    :    in    std_logic
    );
end component; --alt_iobuf


component    alt_iobuf_diff
    generic    (
        enable_bus_hold    :    string    :=    "NONE";
        slew_rate    :    natural    :=    -1;
        location    :    string    :=    "NONE";
        lpm_type    :    string    :=    "alt_iobuf_diff";
        weak_pull_up_resistor    :    string    :=    "NONE";
        io_standard    :    string    :=    "NONE";
        termination    :    string    :=    "NONE";
        current_strength    :    string    :=    "NONE";
        input_termination    :    string    :=    "NONE";
        output_termination    :    string    :=    "NONE";
        current_strength_new    :    string    :=    "NONE"
    );
    port    (
        oe    :    in    std_logic;
        iobar    :    inout    std_logic;
        io    :    inout    std_logic;
        o    :    out    std_logic;
        i    :    in    std_logic
    );
end component; --alt_iobuf_diff


component    alt_outbuf
    generic    (
        enable_bus_hold    :    string    :=    "NONE";
        slew_rate    :    natural    :=    -1;
        location    :    string    :=    "NONE";
        slow_slew_rate    :    string    :=    "NONE";
        lpm_type    :    string    :=    "alt_outbuf";
        weak_pull_up_resistor    :    string    :=    "NONE";
        io_standard    :    string    :=    "NONE";
        termination    :    string    :=    "NONE";
        current_strength    :    string    :=    "NONE";
        current_strength_new    :    string    :=    "NONE"
    );
    port    (
        o    :    out    std_logic;
        i    :    in    std_logic
    );
end component; --alt_outbuf


component    alt_outbuf_diff
    generic    (
        enable_bus_hold    :    string    :=    "NONE";
        slew_rate    :    natural    :=    -1;
        location    :    string    :=    "NONE";
        lpm_type    :    string    :=    "alt_outbuf_diff";
        weak_pull_up_resistor    :    string    :=    "NONE";
        io_standard    :    string    :=    "NONE";
        termination    :    string    :=    "NONE";
        current_strength    :    string    :=    "NONE";
        current_strength_new    :    string    :=    "NONE"
    );
    port    (
        obar    :    out    std_logic;
        o    :    out    std_logic;
        i    :    in    std_logic
    );
end component; --alt_outbuf_diff


component    alt_outbuf_tri
    generic    (
        enable_bus_hold    :    string    :=    "NONE";
        slew_rate    :    natural    :=    -1;
        location    :    string    :=    "NONE";
        slow_slew_rate    :    string    :=    "NONE";
        lpm_type    :    string    :=    "alt_outbuf_tri";
        weak_pull_up_resistor    :    string    :=    "NONE";
        io_standard    :    string    :=    "NONE";
        termination    :    string    :=    "NONE";
        current_strength    :    string    :=    "NONE";
        current_strength_new    :    string    :=    "NONE"
    );
    port    (
        oe    :    in    std_logic;
        o    :    out    std_logic;
        i    :    in    std_logic
    );
end component; --alt_outbuf_tri


component    alt_outbuf_tri_diff
    generic    (
        enable_bus_hold    :    string    :=    "NONE";
        slew_rate    :    natural    :=    -1;
        location    :    string    :=    "NONE";
        lpm_type    :    string    :=    "alt_outbuf_tri_diff";
        weak_pull_up_resistor    :    string    :=    "NONE";
        io_standard    :    string    :=    "NONE";
        termination    :    string    :=    "NONE";
        current_strength    :    string    :=    "NONE";
        current_strength_new    :    string    :=    "NONE"
    );
    port    (
        obar    :    out    std_logic;
        oe    :    in    std_logic;
        o    :    out    std_logic;
        i    :    in    std_logic
    );
end component; --alt_outbuf_tri_diff


component    carry
    port    (
        a_out    :    out    std_logic;
        a_in    :    in    std_logic
    );
end component; --carry


component    exp
    port    (
        a_out    :    out    std_logic;
        a_in    :    in    std_logic
    );
end component; --exp


component    global
    port    (
        a_out    :    out    std_logic;
        a_in    :    in    std_logic
    );
end component; --global


component    opndrn
    port    (
        a_out    :    out    std_logic;
        a_in    :    in    std_logic
    );
end component; --opndrn


component    row_global
    port    (
        a_out    :    out    std_logic;
        a_in    :    in    std_logic
    );
end component; --row_global

