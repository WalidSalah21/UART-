module PULSE_GEN(
input   wire  clk,rst,
input   wire  busy,
output  wire  RD_inc
);
reg                    op_ff_pulse_gen;

assign RD_inc=(busy & (~op_ff_pulse_gen));

always@(posedge clk,negedge rst)
  begin
    if(!rst)
      op_ff_pulse_gen <='b0;
    else
      op_ff_pulse_gen <=busy;
  end
endmodule