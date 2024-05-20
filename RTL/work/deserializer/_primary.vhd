library verilog;
use verilog.vl_types.all;
entity deserializer is
    generic(
        W               : integer := 8
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        deser_en        : in     vl_logic;
        sampled_bit     : in     vl_logic;
        prescale        : in     vl_logic_vector(5 downto 0);
        p_data          : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of W : constant is 1;
end deserializer;
