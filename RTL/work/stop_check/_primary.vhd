library verilog;
use verilog.vl_types.all;
entity stop_check is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        stp_chk_en      : in     vl_logic;
        sampled_bit     : in     vl_logic;
        stp_err         : out    vl_logic
    );
end stop_check;
