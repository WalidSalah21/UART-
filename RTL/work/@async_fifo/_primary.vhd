library verilog;
use verilog.vl_types.all;
entity Async_fifo is
    generic(
        DATA_WIDTH      : integer := 8;
        MEM_depth       : integer := 3
    );
    port(
        W_CLK           : in     vl_logic;
        W_RST           : in     vl_logic;
        R_CLK           : in     vl_logic;
        R_RST           : in     vl_logic;
        W_INC           : in     vl_logic;
        R_INC           : in     vl_logic;
        WR_DATA         : in     vl_logic_vector;
        RD_DATA         : out    vl_logic_vector;
        FULL            : out    vl_logic;
        EMPTY           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of MEM_depth : constant is 1;
end Async_fifo;
