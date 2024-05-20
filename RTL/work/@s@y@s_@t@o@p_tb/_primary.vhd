library verilog;
use verilog.vl_types.all;
entity SYS_TOP_tb is
    generic(
        D_SIZE          : integer := 11
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of D_SIZE : constant is 1;
end SYS_TOP_tb;
