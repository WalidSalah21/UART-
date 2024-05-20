library verilog;
use verilog.vl_types.all;
entity PULSE_GEN is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        busy            : in     vl_logic;
        RD_inc          : out    vl_logic
    );
end PULSE_GEN;
