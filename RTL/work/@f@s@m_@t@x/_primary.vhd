library verilog;
use verilog.vl_types.all;
entity FSM_TX is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        par_en          : in     vl_logic;
        data_valid      : in     vl_logic;
        ser_done        : in     vl_logic;
        ser_en          : out    vl_logic;
        par_enable      : out    vl_logic;
        mux_sel         : out    vl_logic_vector(1 downto 0);
        busy            : out    vl_logic
    );
end FSM_TX;
