library verilog;
use verilog.vl_types.all;
entity UART_RX is
    generic(
        W               : integer := 8;
        clk_W           : integer := 5
    );
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        PRESCALE        : in     vl_logic_vector(5 downto 0);
        PER_EN          : in     vl_logic;
        PAR_TYP         : in     vl_logic;
        RX_IN           : in     vl_logic;
        DATA_VALID      : out    vl_logic;
        P_DATA          : out    vl_logic_vector;
        par_err         : out    vl_logic;
        stp_err         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of W : constant is 1;
    attribute mti_svvh_generic_type of clk_W : constant is 1;
end UART_RX;
