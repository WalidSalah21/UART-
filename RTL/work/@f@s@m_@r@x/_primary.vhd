library verilog;
use verilog.vl_types.all;
entity FSM_RX is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        par_en          : in     vl_logic;
        rx_in           : in     vl_logic;
        stp_err         : in     vl_logic;
        strt_glitch     : in     vl_logic;
        par_err         : in     vl_logic;
        bit_cnt         : in     vl_logic_vector(3 downto 0);
        edge_cnt        : in     vl_logic_vector(5 downto 0);
        prescale        : in     vl_logic_vector(5 downto 0);
        data_samp_en    : out    vl_logic;
        enable          : out    vl_logic;
        deser_en        : out    vl_logic;
        data_valid      : out    vl_logic;
        stp_chk_en      : out    vl_logic;
        strt_chk_en     : out    vl_logic;
        par_chk_en      : out    vl_logic
    );
end FSM_RX;
