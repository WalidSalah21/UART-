library verilog;
use verilog.vl_types.all;
entity strt_check is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        strt_chk_en     : in     vl_logic;
        sampled_bit     : in     vl_logic;
        strt_glitch     : out    vl_logic
    );
end strt_check;
