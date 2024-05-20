library verilog;
use verilog.vl_types.all;
entity FIFO_rptr_empty is
    generic(
        DATA_WIDTH      : integer := 8;
        MEM_depth       : integer := 3;
        MEM_SIZE        : integer := 8
    );
    port(
        rclk            : in     vl_logic;
        rret_n          : in     vl_logic;
        rinc            : in     vl_logic;
        rq2_wptr        : in     vl_logic_vector;
        empty           : out    vl_logic;
        rptr_Gray       : out    vl_logic_vector;
        raddr           : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of MEM_depth : constant is 1;
    attribute mti_svvh_generic_type of MEM_SIZE : constant is 1;
end FIFO_rptr_empty;
