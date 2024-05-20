library verilog;
use verilog.vl_types.all;
entity FIFO_wptr_full is
    generic(
        DATA_WIDTH      : integer := 8;
        MEM_depth       : integer := 3;
        MEM_SIZE        : integer := 8
    );
    port(
        wclk            : in     vl_logic;
        wrst_n          : in     vl_logic;
        winc            : in     vl_logic;
        wq2_rptr        : in     vl_logic_vector;
        waddr           : out    vl_logic_vector;
        wptr_Gray       : out    vl_logic_vector;
        wfull           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of MEM_depth : constant is 1;
    attribute mti_svvh_generic_type of MEM_SIZE : constant is 1;
end FIFO_wptr_full;
