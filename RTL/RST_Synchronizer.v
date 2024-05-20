module RST_SYNC #(parameter NUM_STAGES=2 ,No_bits=1)(
input  wire               rst,clk,
output reg  [No_bits-1:0] SYNC_RST
);

reg [3:0] i;

reg [NUM_STAGES-1:0] sync_rst_reg [No_bits-1:0];

always@(posedge clk ,negedge rst)
begin
if(!rst)
  begin
    for (i=0;i<No_bits;i=i+1)
    begin
    {sync_rst_reg[i][NUM_STAGES-1:0]} <='b0;
    end 
  end
else
  begin
    for (i=0;i<No_bits;i=i+1)
    begin
    {sync_rst_reg[i][NUM_STAGES-1:0]} <={sync_rst_reg[i][NUM_STAGES-2:0],1'b1};
    end
  end
end
  
always@(*)
  begin
    for (i=0;i<No_bits;i=i+1)
    begin
      SYNC_RST[i] = sync_rst_reg[i][NUM_STAGES-1];
    end
  end  
endmodule
