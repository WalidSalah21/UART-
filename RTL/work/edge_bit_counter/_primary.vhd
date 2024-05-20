library verilog;
use verilog.vl_types.all;
entity edge_bit_counter is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        enable          : in     vl_logic;
        prescale        : in     vl_logic_vector(5 downto 0);
        par_en          : in     vl_logic;
        bit_cnt         : out    vl_logic_vector(3 downto 0);
        edge_cnts       : out    vl_logic_vector(5 downto 0)
    );
end edge_bit_counter;
