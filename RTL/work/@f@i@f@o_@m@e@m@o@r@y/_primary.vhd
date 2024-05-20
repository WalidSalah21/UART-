library verilog;
use verilog.vl_types.all;
entity FIFO_MEMORY is
    generic(
        DATA_WIDTH      : integer := 8;
        MEM_depth       : integer := 3;
        MEM_SIZE        : integer := 8
    );
    port(
        wclk            : in     vl_logic;
        rst             : in     vl_logic;
        waddr           : in     vl_logic_vector;
        raddr           : in     vl_logic_vector;
        winc            : in     vl_logic;
        wfull           : in     vl_logic;
        wdata           : in     vl_logic_vector;
        rdata           : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of MEM_depth : constant is 1;
    attribute mti_svvh_generic_type of MEM_SIZE : constant is 1;
end FIFO_MEMORY;
