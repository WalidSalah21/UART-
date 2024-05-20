library verilog;
use verilog.vl_types.all;
entity MUX is
    port(
        mux_sel         : in     vl_logic_vector(1 downto 0);
        start_bit       : in     vl_logic;
        stop_bit        : in     vl_logic;
        ser_data        : in     vl_logic;
        par_bit         : in     vl_logic;
        tx_out          : out    vl_logic
    );
end MUX;
