`timescale 1ns/1ps 
module UART_RX_tb #(parameter W=8)();
  
reg            CLK_tb,RST_tb;
reg   [5:0]    PRESCALE_tb;
reg            PER_EN_tb;
reg            PAR_TYP_tb;
reg            RX_IN_tb;
wire           DATA_VALID_tb;
wire  [W-1:0]  P_DATA_tb;


localparam clk_period=5;

always  #(clk_period/2.0) CLK_tb=~CLK_tb;

UART_RX DUT(
.CLK(CLK_tb),
.RST(RST_tb),
.PRESCALE(PRESCALE_tb),
.PER_EN(PER_EN_tb),
.PAR_TYP(PAR_TYP_tb),
.RX_IN(RX_IN_tb),
.DATA_VALID(DATA_VALID_tb),
.P_DATA(P_DATA_tb)

);



initial
begin
  $dumpfile("UART_RX.vcd");
  $dumpvars;
  initialization;  
  PER_EN_tb=1;
  PAR_TYP_tb=1;
  PRESCALE_tb=16;
   #(clk_period/2.0);   //to make the change of input rx_in with posedge of RX_CLK        
   
            //{the following sequance is the right} 
            //{pass ->fail ->pass ->fail ->pass ->fail}
   
  first_test(11'b11010101010);   //with odd parity correct
  //#(clk_period);
  first_test(11'b10100111110);   //with odd parity wrong and In succession with last frame
  
  reset;                         //try reset between two different configration
  
  #(clk_period);                //her we saw that change delay dosenot affect on the counter 
  PER_EN_tb=1;                  //case even parity 
  PAR_TYP_tb=0;
  first_test(11'b10010101010);  //with even parity correct
  first_test(11'b11010111110);  //with even parity wrong
  
  reset;
  PER_EN_tb=0;                  //case no parity and different configration
  PAR_TYP_tb=0; 
  first_test(10'b1010111110);   //without parity correct
  first_test(10'b0010101010);   //with stop error bit
  
  
  
  #100 $stop;
end

task reset;
  begin
        RST_tb=1'b0;
        #(clk_period);
        RST_tb=1'b1;
  end
endtask
    
task initialization;
begin
  CLK_tb=0;
  reset; 
end
endtask


task first_test;
  input  [10:0] RX_IN;
  integer i;                      //I put numbers on each begin and her end
  begin//1 
    if(PER_EN_tb)                 //case parity exist
      begin//2
        for(i=0;i<11;i=i+1)
          begin//3
            RX_IN_tb=RX_IN[i];
            #((PRESCALE_tb)*clk_period);
          end//3
          if((RX_IN[8:1] ==P_DATA_tb) && (RX_IN[10] == 1) && (RX_IN[0] == 0))
            begin//6
              case(PAR_TYP_tb)
                1'b0:  //even
                     begin//4
                       if(RX_IN[9] ==(^P_DATA_tb))   
                               $display("the test with even parity is pass");
                       else
                               $display("the test with even parity is fail");
                     end//4
                1'b1:  //odd
                     begin//5
                       if(RX_IN[9] ==(~^P_DATA_tb))
                               $display("the test with odd parity is pass");
                       else
                               $display("the test with odd parity is fail");
                     end//5
              endcase 
            end//6
           else
              begin//7
               case(PAR_TYP_tb) //case fail in odd and even parity
                1'b0:
                   $display("the test with even parity is fail");
                1'b1:
                   $display("the test with odd parity is fail");
               endcase
              end//7
          end//2
        
    else  //without parity case
      begin//8
         for(i=0;i<10;i=i+1)
          begin//9
            RX_IN_tb=RX_IN[i];
            #((PRESCALE_tb)*clk_period);
          end//9
          
          if((RX_IN[8:1] ==P_DATA_tb) && (RX_IN[9] == 1) && (RX_IN[0] == 0) )
            $display("the test without parity is pass");
          else
            $display("the test without parity is fail");
      end//8
    end//1
  
endtask



 endmodule