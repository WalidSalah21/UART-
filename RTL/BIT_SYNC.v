module BIT_SYNC  #(parameter BUS_WIDTH=4,NUM_STAGES=5 )(
input wire                       clk,rst,
input wire   [BUS_WIDTH-1:0]     ASYINC,
output reg   [BUS_WIDTH-1:0]     SYNC
);

reg [3:0] i;
reg [NUM_STAGES-1:0] sync_bits_reg [BUS_WIDTH-1:0];

always@(posedge clk ,negedge rst)
begin
if(!rst)
 begin
  for (i=0;i<BUS_WIDTH;i=i+1)
   begin
    {sync_bits_reg[i][NUM_STAGES-1:0]} <='b0;
   end
 end
else
  begin
    for (i=0;i<BUS_WIDTH;i=i+1)
    begin
    {sync_bits_reg[i][NUM_STAGES-1:0]} <={sync_bits_reg[i][NUM_STAGES-2:0],ASYINC[i]};
    end
  end
end

always@(*)
  begin
    for (i=0;i<BUS_WIDTH;i=i+1)
    begin
      SYNC[i] = sync_bits_reg[i][NUM_STAGES-1];
    end
  end 

endmodule

