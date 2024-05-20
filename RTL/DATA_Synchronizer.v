module DATA_SYNC  #(parameter BUS_WIDTH=8,NUM_STAGES=2 )(
input wire                 clk,rst,
input wire                 bus_enable,
input wire [BUS_WIDTH-1:0] unsync_bus,
output reg [BUS_WIDTH-1:0] sync_bus,
output reg                 enable_pulse 
);

reg                    op_ff_pulse_gen;
reg   [NUM_STAGES-1:0] sync_rst_reg  ;
wire                   pulse_g_output;


assign pulse_g_output=(sync_rst_reg[NUM_STAGES-1] & (~op_ff_pulse_gen));


always@(posedge clk ,negedge rst)
begin
if(!rst)
  begin
    {sync_rst_reg[NUM_STAGES-1:0]} <='b0;
     op_ff_pulse_gen               <='b0;
     enable_pulse                  <='b0;
  end
else
  begin
    {sync_rst_reg[NUM_STAGES-1:0]} <={sync_rst_reg[NUM_STAGES-2:0],bus_enable};
    op_ff_pulse_gen                <=sync_rst_reg[NUM_STAGES-1];
    enable_pulse                   <=pulse_g_output;
  end
end



always@(posedge clk ,negedge rst)
begin
if(!rst)
  begin
    sync_bus <='b0;
  end
else if(pulse_g_output)
  begin
    sync_bus <=unsync_bus;
  end
end


endmodule

