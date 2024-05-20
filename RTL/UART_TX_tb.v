`timescale 1ns/1ps
module UART_TX_tb ();
  reg [7:0] P_DATA_tb;
  reg       DATA_VALID_tb;
  reg       PAR_TYP_tb;
  reg       PAR_EN_tb;
  reg       start_bit_tb;
  reg       stop_bit_tb;
  reg       CLK_tb;
  reg       RST_tb;
  wire      TX_OUT_tb;
  wire      BUSY_tb;
  
  
  localparam period=5.0;
  reg [10:0] out_data;   //output register frame 
  
  
 always  #(period/2) CLK_tb=~CLK_tb;
   
   
  UART_TX DUT(
  .P_DATA(P_DATA_tb),
  .DATA_VALID(DATA_VALID_tb),
  .PAR_TYP(PAR_TYP_tb),
  .PAR_EN(PAR_EN_tb),
  .start_bit(start_bit_tb),
  .stop_bit(stop_bit_tb),
  .CLK(CLK_tb),
  .RST(RST_tb),
  .TX_OUT(TX_OUT_tb),
  .BUSY(BUSY_tb)
  );
  
  
  initial
  begin
    $dumpfile("UART_TX.vcd");
    //$dumpvar;
    intialization;
    first_test;
    second_test;
    third_task;
    
    #200 $stop;
    end
    
    
    task intialization;    //initialization block 
      begin
        CLK_tb=1'b0;
        DATA_VALID_tb=1'b0;
        PAR_EN_tb=1'b0;
        PAR_TYP_tb=1'b0;
        start_bit_tb=1'b0;
        stop_bit_tb=1'b1;
        reset;
      end
    endtask
    
    
    task reset;
      begin
        RST_tb=1'b0;
        #(period);
        RST_tb=1'b1;
      end
    endtask
    
    task first_test;   //check output with even parity
      integer i;
      begin
        
        DATA_VALID_tb=1'b1;
        PAR_EN_tb=1'b1;
        PAR_TYP_tb=1'b0;
        P_DATA_tb=8'b10101011;
        
        for(i=0;i<11;i=i+1)
        begin
        #(period)
        out_data[i]=TX_OUT_tb;
        end
        if(out_data ==({stop_bit_tb,1'b1,P_DATA_tb,start_bit_tb}))
          $display("the data with even parity pass, the busy value is high in all iteration");
        else
         $display("the data with even parity fail, the busy value isnot high in all iteration");
         
        end
    endtask
    
    
      task second_test;  //check output with odd parity and two follow frames
      integer i;
      begin
        
        DATA_VALID_tb=1'b1;
        PAR_EN_tb=1'b1;
        PAR_TYP_tb=1'b1;
        P_DATA_tb=8'b00101010;
        
        for(i=0;i<11;i=i+1)
        begin
        #(period)
        out_data[i]=TX_OUT_tb;
        end
        if(out_data ==({stop_bit_tb,1'b0,P_DATA_tb,start_bit_tb}))
          $display("the data with odd parity pass, the busy value is high in all iteration");
        else
         $display("the data with odd parity fail, the busy value isnot high in all iteration");
         
        end
    endtask
    
    task third_task;   //check output without parity and two separated by reset signal frames
      integer j;
      begin
        reset;
        DATA_VALID_tb=1'b1;
        PAR_EN_tb=1'b0;
        PAR_TYP_tb=1'b1;
        P_DATA_tb=8'b000011111;
        for(j=0;j<10;j=j+1)
        begin
          #(period)
          out_data[j]=TX_OUT_tb;
        end
        if(out_data[9:0] ==({stop_bit_tb,P_DATA_tb,start_bit_tb}))
          $display("the data without parity pass");
        else
         $display("the data without parity fail");
      end
    endtask
  

endmodule