library verilog;
use verilog.vl_types.all;
entity Div_mux is
    port(
        prescale        : in     vl_logic_vector(5 downto 0);
        mux_out         : out    vl_logic_vector(7 downto 0)
    );
end Div_mux;
