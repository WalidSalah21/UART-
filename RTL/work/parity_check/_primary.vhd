library verilog;
use verilog.vl_types.all;
entity parity_check is
    generic(
        width           : integer := 8
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        Par_typ         : in     vl_logic;
        Par_chk_en      : in     vl_logic;
        Sampled_bit     : in     vl_logic;
        P_data          : in     vl_logic_vector;
        Par_err         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end parity_check;
