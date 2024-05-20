library verilog;
use verilog.vl_types.all;
entity Async_fifo_tb is
    generic(
        D_SIZE          : integer := 8;
        A_SIZE          : integer := 3;
        P_SIZE          : integer := 4;
        Write_CLK_PERIOD: real    := 12.500000;
        Read_CLK_PERIOD : integer := 20;
        Write_CLK_HALF_PERIOD: vl_notype;
        Read_CLK_HALF_PERIOD: vl_notype
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of D_SIZE : constant is 1;
    attribute mti_svvh_generic_type of A_SIZE : constant is 1;
    attribute mti_svvh_generic_type of P_SIZE : constant is 1;
    attribute mti_svvh_generic_type of Write_CLK_PERIOD : constant is 1;
    attribute mti_svvh_generic_type of Read_CLK_PERIOD : constant is 1;
    attribute mti_svvh_generic_type of Write_CLK_HALF_PERIOD : constant is 3;
    attribute mti_svvh_generic_type of Read_CLK_HALF_PERIOD : constant is 3;
end Async_fifo_tb;
