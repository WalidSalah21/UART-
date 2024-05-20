module REG_File #(parameter width_RF=8 ,Depth_RF=16 ,ADDR_W=4)(
  
  input  wire                   CLK,RST,
  input  wire                   WrEn,RdEn,addr_en,
  input  wire [ADDR_W-1:0]      Address,
  input  wire [width_RF-1:0]    WrData,
  output reg  [width_RF-1:0]    RrData,
  output reg                    RdData_Valid,
  output wire [width_RF-1:0]    REG0,
  output wire [width_RF-1:0]    REG1,
  output wire [width_RF-1:0]    REG2,
  output wire [width_RF-1:0]    REG3
);

reg [width_RF-1:0] REG_File [Depth_RF-1:0];   //REG_File declantion
reg [ADDR_W-1:0]   i;
reg [ADDR_W-1:0]      Addr; 


always@(posedge CLK,negedge RST)
 if(!RST)
   Addr <='b0;
 else if(addr_en)
    begin
      Addr <= Address; 
    end      

assign REG0 =REG_File[0];
assign REG1 =REG_File[1];
assign REG2 =REG_File[2];
assign REG3 =REG_File[3];


always@(posedge CLK,negedge RST)
begin
  if(!RST)
    begin
      RrData       <='b0;
      RdData_Valid <='b0;
      for(i=0;i<Depth_RF-1;i=i+1)
       begin
        if(i==2)
          REG_File[i] <='b10000001;
        else if(i==3)
          REG_File[i] <='b00100000;
        else
          REG_File[i] <='b0;
       end
    end
  else if(WrEn ^ RdEn)
      begin
       if(WrEn)
         begin
           REG_File[Addr]<=WrData;
           RdData_Valid     <='b0;
         end
       else  
         begin
           RrData       <=REG_File[Addr];
           RdData_Valid <='b1;
         end
       end
     else
       begin
         RdData_Valid     <='b0;
       end
 end
 

endmodule

