library verilog;
use verilog.vl_types.all;
entity serializer is
    generic(
        width           : integer := 8
    );
    port(
        p_data          : in     vl_logic_vector;
        ser_en          : in     vl_logic;
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        ser_done        : out    vl_logic;
        ser_data        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end serializer;
