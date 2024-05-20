library verilog;
use verilog.vl_types.all;
entity parity_Calc is
    generic(
        width           : integer := 8
    );
    port(
        p_data          : in     vl_logic_vector;
        data_valid      : in     vl_logic;
        par_typ         : in     vl_logic;
        par_enable      : in     vl_logic;
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        par_bit         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end parity_Calc;
