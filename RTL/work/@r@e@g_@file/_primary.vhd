library verilog;
use verilog.vl_types.all;
entity REG_File is
    generic(
        width_RF        : integer := 8;
        Depth_RF        : integer := 16;
        ADDR_W          : integer := 4
    );
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        WrEn            : in     vl_logic;
        RdEn            : in     vl_logic;
        addr_en         : in     vl_logic;
        Address         : in     vl_logic_vector;
        WrData          : in     vl_logic_vector;
        RrData          : out    vl_logic_vector;
        RdData_Valid    : out    vl_logic;
        REG0            : out    vl_logic_vector;
        REG1            : out    vl_logic_vector;
        REG2            : out    vl_logic_vector;
        REG3            : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width_RF : constant is 1;
    attribute mti_svvh_generic_type of Depth_RF : constant is 1;
    attribute mti_svvh_generic_type of ADDR_W : constant is 1;
end REG_File;
