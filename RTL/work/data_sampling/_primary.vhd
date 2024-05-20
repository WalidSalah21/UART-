library verilog;
use verilog.vl_types.all;
entity data_sampling is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        prescale        : in     vl_logic_vector(5 downto 0);
        dat_samp_en     : in     vl_logic;
        edge_cnts       : in     vl_logic_vector(5 downto 0);
        rx_in           : in     vl_logic;
        sampled_bit     : out    vl_logic
    );
end data_sampling;
