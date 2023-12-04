library verilog;
use verilog.vl_types.all;
entity max_asynch_sexp is
    port(
        datain          : in     vl_logic_vector(51 downto 0);
        dataout         : out    vl_logic
    );
end max_asynch_sexp;
