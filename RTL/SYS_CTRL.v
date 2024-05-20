module SYS_CTRL #(parameter data_w=8,ALU_w=16 )(  
input wire               CLK,RST,
input wire  [ALU_w-1:0]  ALU_OUT,
input wire               OUT_Valid,RX_D_VLD,RdData_Valid,FIFO_Full,   
input wire  [data_w-1:0] RX_P_DATA,RdData,
output reg               ALU_EN,CLK_EN,WrEN,RdEN,
output reg               TX_D_VLD,clk_div_en,addr_en,
output reg  [3:0]        Address,ALU_FUN,
output reg  [data_w-1:0] WrData,TX_P_DATA
);

localparam ideal=4'b0000,wait_Wr_addr=4'b0001,
           wait_wr_data=4'b0011,wait_Rd_addr=4'b0010,
           wait_reading=4'b0110,wait_fifo_full=4'b0111,
           wait_oper1=4'b0100,wait_oper2=4'b1100,
           wait_Alu_fun=4'b1000,Alu_operation=4'b1001,
           wait_1clk=4'b1110,
           secand_wait=4'b1010,multi_frame2=4'b1011;
          
      
reg [3:0] next_state,current_state;
           
always@(posedge CLK,negedge RST)
  begin
    if(!RST)
      current_state <=ideal;
    else
      current_state <=next_state;
  end
  
 always@(*)
   begin
     case(current_state)
       ideal:
        begin
          if(RX_D_VLD &&(RX_P_DATA ==8'hAA))
            next_state =wait_Wr_addr;
          else if(RX_D_VLD &&(RX_P_DATA ==8'hBB))
            next_state =wait_Rd_addr;
          else if(RX_D_VLD &&(RX_P_DATA ==8'hCC))
            next_state =wait_oper1;
          else if(RX_D_VLD &&(RX_P_DATA ==8'hDD))
            next_state =wait_Alu_fun;
          else
            next_state =ideal;
        end
       wait_Wr_addr:
        begin
          if(RX_D_VLD)
            next_state =wait_wr_data;
          else
            next_state =wait_Wr_addr;
        end
       wait_wr_data:
        begin
          if(RX_D_VLD)
            next_state =ideal;
            else
            next_state =wait_wr_data;
        end
       wait_Rd_addr:
        begin
          if(RX_D_VLD)
            next_state =wait_1clk;
            else
            next_state =wait_Rd_addr;
        end
        
        
       wait_1clk: next_state =wait_reading;
       
       wait_reading:
        begin
          if(!FIFO_Full && RdData_Valid)
            next_state =ideal;
          else if(FIFO_Full && RdData_Valid)
            next_state =wait_fifo_full;
          else
            next_state =wait_reading;
        end
       wait_fifo_full:
        begin
          if(!FIFO_Full &&((ALU_FUN !='d2) ||(ALU_FUN !='d0)))
            next_state =ideal;
          else if(!FIFO_Full &&((ALU_FUN =='d2) || (ALU_FUN =='d0)))
            next_state =multi_frame2;
          else
            next_state =wait_fifo_full;
        end
       wait_oper1:
        begin
          if(RX_D_VLD)
            next_state =wait_oper2;
            else
            next_state =wait_oper1;
        end
       wait_oper2:
        begin
          if(RX_D_VLD)
            next_state =wait_Alu_fun;
            else
            next_state =wait_oper2;
        end
       wait_Alu_fun:
        begin
           if(RX_D_VLD)
            next_state =Alu_operation;
            else
            next_state =wait_Alu_fun;
        end
       Alu_operation:
        begin
          if((ALU_FUN !='d2) || (ALU_FUN !='d0) || (ALU_FUN !='d13))
            begin
              if(!FIFO_Full && OUT_Valid)
                 next_state =ideal;
              else if(FIFO_Full && OUT_Valid)
                 next_state =wait_fifo_full;
              else
                 next_state =Alu_operation;
            end
          else
            begin
              if(!FIFO_Full && OUT_Valid)
                 next_state =multi_frame2;
              else if(FIFO_Full && OUT_Valid)
                 next_state =wait_fifo_full;
              else
                 next_state =Alu_operation;
            end
        end
        multi_frame2:
         begin
          if(FIFO_Full)
            next_state =secand_wait;
          else if(!FIFO_Full)
            next_state =ideal;
          else
            next_state =multi_frame2;
         end
         secand_wait:
          begin
           if(!FIFO_Full)
             next_state =ideal;
           else
             next_state =secand_wait;
          end
        default:
          next_state = ideal;
     endcase
   end
           
           
  
always@(*)
  begin
          ALU_EN     ='b0;
          ALU_FUN    ='b0;
          CLK_EN     ='b0;
          Address    ='b0;
          WrEN       ='b0;
          RdEN       ='b0;
          WrData     ='b0;
          TX_P_DATA  ='b0;
          TX_D_VLD   =1'b0;
          clk_div_en =1'b1;
          addr_en    =1'b0;
    case(current_state)
      ideal:
        begin
          ALU_EN     ='b0;
          ALU_FUN    ='b0;
          CLK_EN     ='b0;
          Address    ='b0;
          WrEN       ='b0;
          RdEN       ='b0;
          WrData     ='b0;
          TX_P_DATA  ='b0;
          TX_D_VLD   =1'b0;
          clk_div_en =1'b1;
          if(next_state ==wait_oper1)
            addr_en    =1'b1;
          else
            addr_en    =1'b0;
        end
      wait_Wr_addr:
        begin
          if(RX_D_VLD)
            begin
              addr_en ='b1;
              Address =RX_P_DATA;
            end
          else
           begin
            Address ='b0;
            addr_en ='b0;
           end
        end
        
      wait_wr_data:
        begin
          if(RX_D_VLD)
            begin
             WrData =RX_P_DATA;
             WrEN   =1'd1;
             end
          else
            begin
             WrData ='b0;
             WrEN   =1'd0;
            end
        end
      wait_Rd_addr:
        begin
          if(RX_D_VLD)
           begin
             addr_en ='b1;
             Address =RX_P_DATA;
             //RdEN   =1'd1;
           end
          else
           begin
            Address ='b0;
            //RdEN   =1'd0;
            addr_en ='b0;
           end
        end
      wait_reading:
        begin
          if(RdData_Valid && (!FIFO_Full))
            begin
              TX_P_DATA =RdData;
              TX_D_VLD  =1'd1;
            end
          /*else if(RdData_Valid && (FIFO_Full))
            begin
              TX_P_DATA =RdData; ////
              TX_D_VLD  =1'd0;
            end*/
          else
            begin
              TX_P_DATA =RdData; ////
              TX_D_VLD  =1'd0;
            end
        end
      wait_fifo_full:
        begin
          if(!FIFO_Full)
            TX_D_VLD  =1'd1;
          else
            TX_D_VLD  =1'd0;
        end
      wait_oper1:
          begin
           if(next_state ==wait_oper2)
             addr_en ='b1;
           else
             addr_en ='b0;
          if(RX_D_VLD)
            begin
              
            WrData  =RX_P_DATA;
            Address =4'd1;
            WrEN    =1'd1;
            //CLK_EN  =1'd1;
            end
          else
            begin
            //addr_en ='b1;
            WrData  =RX_P_DATA;
            Address =4'd1;
            WrEN    =1'd0;
            //CLK_EN  =1'd1;
            end
        end
      wait_oper2:
        begin
          if(RX_D_VLD)
            begin
            WrData  =RX_P_DATA;
            Address =4'd1;
            WrEN    =1'd1;
            //CLK_EN  =1'd1;
            end
          else
            begin
            WrData  =RX_P_DATA;
            Address =4'd1;
            WrEN    =1'd0;
            //CLK_EN  =1'd1;
            end
        end
      wait_Alu_fun:
        begin
          CLK_EN  =1'd1;
          if(RX_D_VLD)
            begin
              ALU_EN  ='d1;
              ALU_FUN =RX_P_DATA[3:0];
            end
          else
            begin
              ALU_EN  ='d0;
              ALU_FUN =RX_P_DATA[3:0];
            end
        end
      Alu_operation:
        begin
          if(OUT_Valid && FIFO_Full)
            begin
              TX_P_DATA =ALU_OUT[7:0];
              ALU_EN    ='d0;
              CLK_EN    ='d0;
              
            end
          else if(OUT_Valid && !FIFO_Full)
            begin
              TX_P_DATA =ALU_OUT[7:0];
              CLK_EN    ='d0;
              ALU_EN    ='d0;
              TX_D_VLD  ='d1;
            end
          else
            begin
              TX_P_DATA =ALU_OUT[7:0];
            end
        end
      multi_frame2:
        begin
          if(!FIFO_Full)
            begin
              TX_P_DATA =ALU_OUT[15:8];
              TX_D_VLD  ='d1;
            end
          else
            begin
              TX_P_DATA =ALU_OUT[15:8];
            end
        end
      secand_wait:
        begin
          if(!FIFO_Full)
            begin
            TX_P_DATA =ALU_OUT[15:8];
            TX_D_VLD  ='d1;
           end
          else
            begin
            TX_D_VLD  ='d0;
            TX_P_DATA =ALU_OUT[15:8];
           end
        end
        
      wait_1clk:
        begin
          RdEN   =1'd1;
        end
      default:
        begin
        end
      endcase
    
  end
  
  
  
           endmodule


