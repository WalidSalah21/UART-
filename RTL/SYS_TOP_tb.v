`timescale 1ns/1ps
module SYS_TOP_tb #(parameter D_SIZE=11)();
  
  reg    REF_CLK_tb,RST_tb,UART_CLK_tb;
  reg    RX_IN_tb;
  wire   TX_OUT_tb;
  wire   Par_Err_tb,Stp_Err_tb;
  
  
  
  
 reg         PAR_TYP_tb,PER_EN_tb;
 reg  [6:0]  PRESCALE_tb;
 
localparam U_CLK_PERIOD=271.3,
           REF_CLK_PERIOD=10;

 reg [D_SIZE-1:0] inp_frame [14:0] ;

always  #(U_CLK_PERIOD/2.0)      UART_CLK_tb=~UART_CLK_tb;
always  #(REF_CLK_PERIOD/2.0)    REF_CLK_tb =~ REF_CLK_tb;


SYS_TOP  DUT(
.REF_CLK(REF_CLK_tb),
.RST(RST_tb),
.UART_CLK(UART_CLK_tb),
.RX_IN(RX_IN_tb),
.TX_OUT(TX_OUT_tb),
.Par_Err(Par_Err_tb),
.Stp_Err(Stp_Err_tb)
);

initial
  begin
    $dumpfile("UART_RX.vcd");
    $dumpvars;
    $readmemh("RX_INP_Frames.txt",inp_frame); 
    initialization;
    
    //I chack all this frames on the wave form
    
     ///////***setup the configration of system***////////
    PAR_TYP_tb =0;
    PER_EN_tb =1;
    PRESCALE_tb ='d32;
    #(U_CLK_PERIOD);
    first_test(inp_frame[0]);   //frame 0,1,2 check write in reg file and out data from TX 
    first_test(inp_frame[1]);
    first_test(inp_frame[2]); 
    first_test(inp_frame[3]);   //frame 3,4 check read from reg file and out data from TX
    first_test(inp_frame[4]);
    #(32*10*UART_CLK_tb);
    first_test(inp_frame[5]);   //frame 5,6,7,8 enter oper 1,2 form out and check operation and recieve the output from RX
    first_test(inp_frame[6]);
    first_test(inp_frame[7]);   
    first_test(inp_frame[8]);
    first_test(inp_frame[9]);   //frame 9,10 do add operation on th existing operands and recieve output from TX
    first_test(inp_frame[10]);
    first_test(inp_frame[11]);  //frame 11,12 DO SHIFT RIGHT operation
    first_test(inp_frame[12]);
    first_test(inp_frame[13]);  //frame 13,14 DO SHIFT left operation
    first_test(inp_frame[14]);
    #400000$stop;
  end
  
  
  
task reset;
  begin
   RST_tb=1'b0;
   #(0.5*U_CLK_PERIOD);
   RST_tb=1'b1;
  end
endtask
    
task initialization;
begin
  UART_CLK_tb=0;
  REF_CLK_tb =0;
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
            #((PRESCALE_tb)*U_CLK_PERIOD);
          end//3
          
          end//2
        
    else  //without parity case
      begin//8
         for(i=0;i<10;i=i+1)
          begin//9
            RX_IN_tb=RX_IN[i];
            #((PRESCALE_tb)*U_CLK_PERIOD);
          end//9
      end//8
    end//1
  
endtask


endmodule


