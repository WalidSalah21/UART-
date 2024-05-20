library verilog;
use verilog.vl_types.all;
entity UART_RX_tb is
    generic(
        W               : integer := 8
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of W : constant is 1;
end UART_RX_tb;
