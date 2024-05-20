`timescale 1ns/1ps
module Async_fifo_tb ;

  parameter D_SIZE = 8 ;                         // data size
  parameter A_SIZE = 3  ;                         // address size
  parameter P_SIZE = 4  ;                         // pointer width

  reg                    i_w_clk;              // write domian operating clock
  reg                    i_w_rstn;             // write domian active low reset  
  reg                    i_w_inc;              // write control signal 
  reg                    i_r_clk;              // read domian operating clock
  reg                    i_r_rstn;             // read domian active low reset 
  reg                    i_r_inc;              // read control signal
  reg   [D_SIZE-1:0]     i_w_data;             // write data bus 
  wire  [D_SIZE-1:0]     o_r_data;             // read data bus
  wire                   o_full;               // fifo full flag
  wire                   o_empty;              // fifo empty flag

   //----------------------- Define testbench parameters ------------------------------

  parameter Write_CLK_PERIOD = 12.5 ; // 80 MHz
  parameter Read_CLK_PERIOD = 20 ;    // 50 MHz
   
  parameter Write_CLK_HALF_PERIOD = Write_CLK_PERIOD/2 ;
  parameter Read_CLK_HALF_PERIOD = Read_CLK_PERIOD/2 ;


  // burst length = 20
  reg [D_SIZE-1:0] Burst_Words [19:0] ;

  reg [4:0]  count ;


  // ----------------------- initial block --------------------------------------------------

 initial 
    begin

    $dumpfile("Async_fifo.vcd") ;    // $dumpfile is used to specify the name of the verilog dumping file, the dumping file standard name is verilog.dump
    $dumpvars;                       // $dumpvars is used to generate the verilog dumping file

    $readmemh("stimulus.txt",Burst_Words);             // read hexadeciemal values from stimulus txt file
    //$vcdplusmemon();                                   // Enable dumping Memories and arraies 
                   
    $monitor ("READ DATA is %8d \n", o_r_data);
     
    count = 5'b0;
    i_w_clk = 1'b0 ;
    i_r_clk = 1'b0 ;
    i_w_rstn = 1'b1 ;
    i_r_rstn = 1'b1 ; 
    /*i_w_inc = 1'b0 ;
    i_r_inc = 1'b0 ;*/
    #5
    i_w_rstn = 1'b0 ;
    i_r_rstn = 1'b0 ; 
    #5
    i_w_rstn = 1'b1 ;
    i_r_rstn = 1'b1 ; 
    /*i_w_inc = 1'b1 ;
    i_r_inc = 1'b1 ;*/
    
    


    #900

     $stop  ; 
  
   end

always @ (negedge i_w_clk)
  begin
    if(!o_full && count < 5'd21)
     begin
     i_w_data <= Burst_Words[count] ;
     count <= count + 5'b01 ;
    end
   
  end
  
 
  always @ (*)
  begin
    if(!o_full && count < 5'd21)
     i_w_inc  <= 1'b1;
    else
     i_w_inc  <= 1'b0;
   end
   
    
  always @ (*)
  begin
    if(o_empty )
     i_r_inc  <= 1'b1;
    else
     i_r_inc  <= 1'b0;
   end


   // --------------------------------- Clock generator ----------------------------------------

   always #Write_CLK_HALF_PERIOD  i_w_clk = ~i_w_clk ;     // 12.5 ns period (80 MHz clock frequency) 
   
   always #Read_CLK_HALF_PERIOD   i_r_clk = ~i_r_clk ;     // 20 ns period (50 MHz clock frequency) 

   // --------------------------------- Module Instantiation ----------------------------------------


Async_fifo DUT (
.W_CLK(i_w_clk),      
.R_CLK(i_r_clk),      
.W_RST(i_w_rstn),          
.R_RST(i_r_rstn),        
.R_INC(i_r_inc),    
.W_INC(i_w_inc),       
.WR_DATA(i_w_data),       
.RD_DATA(o_r_data),     
.FULL(o_full),     
.EMPTY(o_empty)
);

endmodule