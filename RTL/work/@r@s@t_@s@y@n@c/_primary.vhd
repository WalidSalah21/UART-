library verilog;
use verilog.vl_types.all;
entity RST_SYNC is
    generic(
        NUM_STAGES      : integer := 2;
        No_bits         : integer := 1
    );
    port(
        rst             : in     vl_logic;
        clk             : in     vl_logic;
        SYNC_RST        : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NUM_STAGES : constant is 1;
    attribute mti_svvh_generic_type of No_bits : constant is 1;
end RST_SYNC;
