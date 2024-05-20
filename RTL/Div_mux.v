module Div_mux(
input wire  [5:0] prescale,
output reg  [7:0] mux_out
);
always@(*)
  begin
    case(prescale)
       6'd32: mux_out = 2'd1;
       6'd16: mux_out = 2'd2;
       6'd8 : mux_out = 2'd4;
       default:mux_out= 2'd1;
    endcase
   end
endmodule
