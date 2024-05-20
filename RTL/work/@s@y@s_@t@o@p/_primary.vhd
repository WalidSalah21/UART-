library verilog;
use verilog.vl_types.all;
entity SYS_TOP is
    generic(
        Config_W        : integer := 8;
        Data_W          : integer := 8;
        ALU_W           : integer := 16
    );
    port(
        REF_CLK         : in     vl_logic;
        RST             : in     vl_logic;
        UART_CLK        : in     vl_logic;
        RX_IN           : in     vl_logic;
        TX_OUT          : out    vl_logic;
        Par_Err         : out    vl_logic;
        Stp_Err         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Config_W : constant is 1;
    attribute mti_svvh_generic_type of Data_W : constant is 1;
    attribute mti_svvh_generic_type of ALU_W : constant is 1;
end SYS_TOP;
