library verilog;
use verilog.vl_types.all;
entity SYS_CTRL is
    generic(
        data_w          : integer := 8;
        ALU_w           : integer := 16
    );
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        ALU_OUT         : in     vl_logic_vector;
        OUT_Valid       : in     vl_logic;
        RX_D_VLD        : in     vl_logic;
        RdData_Valid    : in     vl_logic;
        FIFO_Full       : in     vl_logic;
        RX_P_DATA       : in     vl_logic_vector;
        RdData          : in     vl_logic_vector;
        ALU_EN          : out    vl_logic;
        CLK_EN          : out    vl_logic;
        WrEN            : out    vl_logic;
        RdEN            : out    vl_logic;
        TX_D_VLD        : out    vl_logic;
        clk_div_en      : out    vl_logic;
        addr_en         : out    vl_logic;
        Address         : out    vl_logic_vector(3 downto 0);
        ALU_FUN         : out    vl_logic_vector(3 downto 0);
        WrData          : out    vl_logic_vector;
        TX_P_DATA       : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of data_w : constant is 1;
    attribute mti_svvh_generic_type of ALU_w : constant is 1;
end SYS_CTRL;
