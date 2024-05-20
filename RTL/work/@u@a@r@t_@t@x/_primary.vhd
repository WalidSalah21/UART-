library verilog;
use verilog.vl_types.all;
entity UART_TX is
    generic(
        W               : integer := 8
    );
    port(
        P_DATA          : in     vl_logic_vector;
        DATA_VALID      : in     vl_logic;
        PAR_TYP         : in     vl_logic;
        PAR_EN          : in     vl_logic;
        start_bit       : in     vl_logic;
        stop_bit        : in     vl_logic;
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        TX_OUT          : out    vl_logic;
        BUSY            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of W : constant is 1;
end UART_TX;
