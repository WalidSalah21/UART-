library verilog;
use verilog.vl_types.all;
entity BIT_SYNC is
    generic(
        BUS_WIDTH       : integer := 4;
        NUM_STAGES      : integer := 5
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        ASYINC          : in     vl_logic_vector;
        SYNC            : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of BUS_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of NUM_STAGES : constant is 1;
end BIT_SYNC;
