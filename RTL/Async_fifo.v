/////////////////////////////////////////////////////
//////////////////////top_module/////////////////////
/////////////////////////////////////////////////////
module Async_fifo #(parameter DATA_WIDTH=8,MEM_depth=3)(
input  wire                   W_CLK,W_RST,
input  wire                   R_CLK,R_RST,
input  wire                   W_INC,R_INC,
input  wire [DATA_WIDTH-1:0]  WR_DATA,
output wire [DATA_WIDTH-1:0]  RD_DATA,
output wire                   FULL,EMPTY
);

wire [MEM_depth-1:0] raddr,waddr;
wire [MEM_depth  :0] rptr_GRAY,wq2_rptr;
wire [MEM_depth  :0] wptr_GRAY,rq2_wptr;
wire                 wfull;


FIFO_MEMORY U0_MEM(
.wclk(W_CLK),
.rst (W_RST),
.wdata(WR_DATA),
.rdata(RD_DATA),
.waddr(waddr),
.raddr(raddr),
.winc(W_INC),
.wfull(FULL)
);

FIFO_rptr_empty U1_rptr_empty(
.rclk(R_CLK),
.rret_n(R_RST),
.rinc(R_INC),   
.rq2_wptr(rq2_wptr),
.empty(EMPTY), 
.rptr_Gray(rptr_GRAY),
.raddr(raddr)
);

FIFO_wptr_full U2_wptr_full(
.wclk(W_CLK),
.wrst_n(W_RST),
.winc(W_INC),
.wq2_rptr(wq2_rptr),
.waddr(waddr),
.wptr_Gray(wptr_GRAY),
.wfull(FULL)
);

ADDR_SYNC U3_R2W(
.clk(W_CLK),
.rst(W_RST),
.ASYINC(rptr_GRAY),
.SYNC(wq2_rptr)
);

ADDR_SYNC U3_W2R(
.clk(R_CLK),
.rst(R_RST),
.ASYINC(wptr_GRAY),
.SYNC(rq2_wptr)
);


endmodule




/////////////////////////////////////////////////////
//////////////////////FIFO_MEMORY////////////////////
/////////////////////////////////////////////////////
module FIFO_MEMORY #(parameter DATA_WIDTH=8 ,MEM_depth=3 ,MEM_SIZE=8)(
input  wire                      wclk,rst,
input  wire [MEM_depth-1:0]      waddr,raddr,
input  wire                      winc,wfull,
input  wire [DATA_WIDTH-1:0]     wdata,
output wire [DATA_WIDTH-1:0]     rdata
);

reg [DATA_WIDTH-1:0] MEM [MEM_SIZE-1:0];
reg [MEM_depth:0]  i;
wire wclken;

assign wclken=winc&(~wfull);
assign rdata =MEM[raddr];

always@(posedge wclk,negedge rst )
begin
  if(!rst)
    begin
      for(i=0;i<MEM_SIZE;i=i+1)
      MEM[i] <='b0;
    end
    else if(wclken)
      begin
        MEM[waddr] <=wdata;
      end
end
endmodule



////////////////////////////////////////////////////////////////
//////////////////////addr_Synchronizer/////////////////////////
////////////////////////////////////////////////////////////////
module ADDR_SYNC  #(parameter BUS_WIDTH=4,NUM_STAGES=2)(
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


////////////////////////////////////////////////////////////////
//////////////////////FIFO_rptr_empty //////////////////////////
////////////////////////////////////////////////////////////////
module FIFO_rptr_empty #(parameter DATA_WIDTH=8,MEM_depth=3 ,MEM_SIZE=8)(
input  wire                    rclk,rret_n,
input  wire                    rinc,
input  wire  [MEM_depth:0]     rq2_wptr,
output wire                    empty,
output reg   [MEM_depth:0]     rptr_Gray,
output wire  [MEM_depth-1:0]   raddr
 
);
reg   [MEM_depth:0]     rptr;
reg   [MEM_depth:0]     rptr_reg;
wire                    rempty;
assign raddr = rptr[MEM_depth-1:0];

assign rempty=(rptr_Gray == rq2_wptr)?'b1:'b0;
assign empty =(!rempty);
//assign rptr_reg=(rptr == 3'd7)?'b0:(rptr_reg= rptr_reg+1);

always@(*)
  begin
    if((rptr == 4'b1111) ||(!rret_n))
       rptr_reg='b0;
    else
       rptr_reg= rptr_reg+1;
 end
  
  /*always@(*)
  begin
    if(rptr == rq2_wptr)
       rempty='b1;
    else
       rempty='b0;
  end*/
  


always@(posedge rclk ,negedge rret_n)
 begin
  if(!rret_n)
    begin
      rptr <='b0;
    end
    else if(rinc)
      rptr <=rptr_reg;
 end
 
  always@(*)
     begin
       case(rptr)              //rptr_reg in case false 
         4'b0000: rptr_Gray =4'b0000;
         4'b0001: rptr_Gray =4'b0001;
         4'b0010: rptr_Gray =4'b0011;
         4'b0011: rptr_Gray =4'b0010;
         4'b0100: rptr_Gray =4'b0110;
         4'b0101: rptr_Gray =4'b0111;
         4'b0110: rptr_Gray =4'b0101;
         4'b0111: rptr_Gray =4'b0100;
         4'b1000: rptr_Gray =4'b1100;
         4'b1001: rptr_Gray =4'b1101;
         4'b1010: rptr_Gray =4'b1111;
         4'b1011: rptr_Gray =4'b1110;
         4'b1100: rptr_Gray =4'b1010;
         4'b1101: rptr_Gray =4'b1011;
         4'b1110: rptr_Gray =4'b1001;
         4'b1111: rptr_Gray =4'b1000;
         endcase 
     end
endmodule



////////////////////////////////////////////////////////////////
//////////////////////FIFO_wptr_full ///////////////////////////
////////////////////////////////////////////////////////////////
module FIFO_wptr_full #(parameter DATA_WIDTH=8,MEM_depth=3 ,MEM_SIZE=8)(
input  wire                    wclk,wrst_n,
input  wire                    winc,
input  wire  [MEM_depth:0]     wq2_rptr,
output wire  [MEM_depth-1:0]   waddr,
output reg   [MEM_depth:0]     wptr_Gray,
output wire                    wfull
);

wire                 wfull_cond;
reg   [MEM_depth:0]  wptr_reg;
reg   [MEM_depth:0]     wptr;
assign wfull_cond = ((wptr_Gray[MEM_depth-2:0] == wq2_rptr[MEM_depth-2:0]) && (wptr_Gray[MEM_depth] != wq2_rptr[MEM_depth]) && (wptr_Gray[MEM_depth-1] != wq2_rptr[MEM_depth-1]));
assign waddr=wptr[MEM_depth-1:0];
assign wfull=(wfull_cond)?'b1:'b0;


always@(posedge wclk,negedge wrst_n)
   begin
     if(!wrst_n)
        wptr <=0;
     else if(winc)
        wptr <=wptr_reg;
   end
   
   always@(*)
   begin
    if((wptr == 4'b1111) ||(!wrst_n))
       wptr_reg='b0;
    else
       wptr_reg= wptr_reg+1;
   end
   
   always@(*)
     begin
       case(wptr)                        //wptr_reg in case false 
         4'b0000: wptr_Gray =4'b0000;
         4'b0001: wptr_Gray =4'b0001;
         4'b0010: wptr_Gray =4'b0011;
         4'b0011: wptr_Gray =4'b0010;
         4'b0100: wptr_Gray =4'b0110;
         4'b0101: wptr_Gray =4'b0111;
         4'b0110: wptr_Gray =4'b0101;
         4'b0111: wptr_Gray =4'b0100;
         4'b1000: wptr_Gray =4'b1100;
         4'b1001: wptr_Gray =4'b1101;
         4'b1010: wptr_Gray =4'b1111;
         4'b1011: wptr_Gray =4'b1110;
         4'b1100: wptr_Gray =4'b1010;
         4'b1101: wptr_Gray =4'b1011;
         4'b1110: wptr_Gray =4'b1001;
         4'b1111: wptr_Gray =4'b1000;
         endcase 
     end

  endmodule
