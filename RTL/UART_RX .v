//////////////////////////////////////////////////////
//////////////////////top_module//////////////////////
//////////////////////////////////////////////////////
module UART_RX #(parameter W=8,clk_W=5)( 
input  wire            CLK,RST,
input  wire  [5:0]     PRESCALE,
input  wire            PER_EN,
input  wire            PAR_TYP,
input  wire            RX_IN,
output wire            DATA_VALID,
output wire  [W-1:0]   P_DATA,
output wire            par_err,stp_err
);

wire             par_chk_en;
wire             strt_chk_en,strt_glitch;
wire             stp_chk_en;
wire             deser_en,sampled_bit;
wire             dat_samp_en,enable;
wire [3:0]       bit_cnt;
wire [clk_W:0]   edge_cnt;



parity_check U0(
.clk(CLK),
.rst(RST),
.Par_typ(PAR_TYP),
.Par_chk_en(par_chk_en),
.Sampled_bit(sampled_bit),
.P_data(P_DATA),
.Par_err(par_err)
);

strt_check U1(
.clk(CLK),
.rst(RST),
.strt_chk_en(strt_chk_en),
.sampled_bit(sampled_bit),
.strt_glitch(strt_glitch)
);

stop_check U2(
.clk(CLK),
.rst(RST),
.stp_chk_en(stp_chk_en),
.sampled_bit(sampled_bit),
.stp_err(stp_err)
);

deserializer U3(
.clk(CLK),
.rst(RST),
.deser_en(deser_en),
.sampled_bit(sampled_bit),
.p_data(P_DATA),
.prescale(PRESCALE)
);

edge_bit_counter U4(
.clk(CLK),
.rst(RST),
.enable(enable),
.prescale(PRESCALE),
.par_en(PER_EN),
.bit_cnt(bit_cnt),
.edge_cnts(edge_cnt)
);

data_sampling U5(
.clk(CLK),
.rst(RST),
.prescale(PRESCALE),
.dat_samp_en(dat_samp_en),
.edge_cnts(edge_cnt),
.rx_in(RX_IN),
.sampled_bit(sampled_bit)
);

FSM_RX U6(
.clk(CLK),
.rst(RST),
.par_en(PER_EN),
.rx_in(RX_IN),
.stp_err(stp_err),
.strt_glitch(strt_glitch),
.par_err(par_err),
.bit_cnt(bit_cnt),
.edge_cnt(edge_cnt),
.prescale(PRESCALE),
.data_samp_en(dat_samp_en),
.enable(enable),
.deser_en(deser_en),
.data_valid(DATA_VALID),
.stp_chk_en(stp_chk_en),
.strt_chk_en(strt_chk_en),
.par_chk_en(par_chk_en)
);

 


endmodule

//////////////////////////////////////////////////////
//////////////////////parity_check////////////////////
//////////////////////////////////////////////////////
module parity_check #(parameter width=8)(
input wire             clk,rst,
input wire             Par_typ,
input wire             Par_chk_en,
input wire             Sampled_bit,
input wire [width-1:0] P_data,
output reg             Par_err
);

always@(posedge clk,negedge rst)
   begin
     if(!rst)
       begin
         Par_err <=1'b0;
       end
     else if(Par_chk_en)
      begin
        if(Par_typ &&((~^P_data)==Sampled_bit))                    //case odd parity check
          Par_err <=1'b0;   
        else if(!Par_typ &&((^P_data)==Sampled_bit))               //case even parity check
          Par_err <=1'b0; 
        else
          Par_err <=1'b1;
      end 
     else
        Par_err <=1'b0;
    
    end
   

endmodule


//////////////////////////////////////////////////////
//////////////////////start_check/////////////////////
//////////////////////////////////////////////////////
module strt_check(
input wire clk,rst,  
input wire strt_chk_en,
input wire sampled_bit,
output reg strt_glitch
);

always@(posedge clk,negedge rst)
   begin
     if(!rst)
         strt_glitch <=1'b0;
           
     else if(strt_chk_en)
       begin
        if(sampled_bit == 0)
           strt_glitch <=1'b0;   
        else 
           strt_glitch <=1'b1;
       end 
     else
           strt_glitch <=1'b0;
      
    end
endmodule

//////////////////////////////////////////////////////
///////////////////////stop_check/////////////////////
//////////////////////////////////////////////////////
module stop_check(
input wire clk,rst,  
input wire stp_chk_en,
input wire sampled_bit,
output reg stp_err
);

always@(posedge clk,negedge rst)
   begin
     if(!rst)
           stp_err <=1'b0;
           
     else if(stp_chk_en)
      begin
        if(sampled_bit == 1)
           stp_err <=1'b0;   
        else
           stp_err <=1'b1;
      end 
     else
           stp_err <=1'b0;
    
    end
endmodule

//////////////////////////////////////////////////////
/////////////////////deserializer/////////////////////
//////////////////////////////////////////////////////
module deserializer #(parameter W=8)(
input  wire            clk,rst, 
input  wire            deser_en,
input  wire            sampled_bit,
input  wire   [5:0]    prescale,
output reg    [W-1:0]  p_data
);
reg [3:0] count;
reg done;

always@(posedge clk,negedge rst)
   begin
     if(!rst)
       begin
            p_data <=8'b00;   //assume at rst to follow the sequance 
            count  <=4'd0;
       end
     else if(deser_en && !done)
      begin
         p_data[count]  <=sampled_bit;
         count          <=count+1;
      end
    else if(done)
         count  <=4'd0;
    end
    

always@(*)
    begin
      if(count==4'd8)
        done=1;
      else
        done=0;
    end

endmodule

//////////////////////////////////////////////////////
/////////////////edge_bit_counter/////////////////////
//////////////////////////////////////////////////////
module edge_bit_counter(
input  wire         clk,rst, 
input  wire         enable,
input  wire [5:0]   prescale,
input  wire         par_en,
output reg  [3:0]   bit_cnt,
output reg  [5:0]   edge_cnts

);

wire         edge_done;
reg          frame_done;


assign edge_done=(edge_cnts ==(prescale-1))?'b1:'b0;
  
 always@(*)
  begin
    if(par_en)
      if((bit_cnt =='d10)&& edge_done)
        frame_done ='d1;
      else
        frame_done ='d0;
    else
      if((bit_cnt =='d9)&& edge_done)
        frame_done ='d1;
      else
        frame_done ='d0;
  end   
    
    
    
always@(posedge clk,negedge rst)
   begin
     if(!rst)
       edge_cnts <='b0;
     else if(enable && !edge_done)
       edge_cnts <=edge_cnts+1'b1;
     else if(edge_done || (!enable))
       edge_cnts <='b0;
     end
     
 always@(posedge clk,negedge rst)
   begin
     if(!rst)
       bit_cnt <='b0;
     else if(frame_done ||(!enable))
       bit_cnt <='b0; 
     else if(edge_done)
       bit_cnt <= bit_cnt +1'b1;
     
     end    
     
     
     
       
endmodule

//////////////////////////////////////////////////////
/////////////////data_sampling////////////////////////
//////////////////////////////////////////////////////
module data_sampling(
input wire         clk,rst,
input wire [5:0]   prescale,
input wire         dat_samp_en,
input wire [5:0]   edge_cnts,
input wire         rx_in,
output reg         sampled_bit
);

reg  [2:0]    samples;
reg  [2:0]    count;
wire [4:0]    mid;
wire          sampled_bit_t;

assign sampled_bit_t =((samples[0]^samples[1])& samples[2])| (samples[0] & samples[1]);  //truth table logic otimise
assign mid =(prescale>>1);


always@(posedge clk,negedge rst)
   begin
     if(!rst)
         sampled_bit <=1'bz; 
     else if(count==2'd3)
         sampled_bit <=sampled_bit_t;
   end

always@(posedge clk,negedge rst)
   begin
     if(!rst)
         count       <='b0;
     else if( dat_samp_en &&((edge_cnts==mid-2)|(edge_cnts==mid-1)|(edge_cnts==mid)) )  //this values catch the required places
         begin
            samples[count] <=rx_in;
            count <=count+1;
         end
     else if(dat_samp_en && count==2'd3)
         count       <='b0;
      
   end
endmodule

//////////////////////////////////////////////////////
////////////////////////FSM///////////////////////////
//////////////////////////////////////////////////////
module FSM_RX(
input wire          clk,rst,
input wire          par_en,rx_in,stp_err,strt_glitch,par_err,
input wire  [3:0]   bit_cnt,
input wire  [5:0]   edge_cnt,
input wire  [5:0]   prescale,
output reg          data_samp_en,enable,deser_en,data_valid,stp_chk_en,strt_chk_en,par_chk_en
);

localparam ideal=3'b000,start=3'b001,data=3'b011,
           parity=3'b010,stop=3'b110,data_valids=3'b100;
          
reg  [2:0]  current_state,next_state;
wire [4:0]    mid;
reg  [0:1]    var;
assign mid =(prescale>>1);
        
always@(posedge clk ,negedge rst)
  begin
    if(!rst)
      current_state <=ideal;
    else if((next_state== ideal)&& (!rx_in) &&(!(par_err | stp_err | strt_glitch)) )  //this state to go from datavalid case to start case in case rx_in ==0 and the condtion fron testing
      current_state <= start;
    else
      current_state <=next_state;
  end
  
  always@(posedge clk ,negedge rst)   //this alweys for check there are stp or parity   error or not
  begin
    if(!rst)
      var <=2'b0;
    else if((current_state==parity) && (edge_cnt==mid+3))
      if(par_err)
        var[0]<=1;
      else
        var[0]<=0;
    else if((current_state==stop) && (edge_cnt==mid+3))
      if(stp_err)
       var[1]<=1;
      else
       var[1]<=0;
     else if(current_state==ideal)
       var <=2'b0;
    end
      
  always@(*)
    begin
      case(current_state)
       ideal:
        begin
          if(!rx_in)
            next_state =start;
          else
            next_state =ideal;
        end
       start:
        begin
          if(!bit_cnt &&(edge_cnt==prescale-1))   
            next_state =data;
          else if(strt_glitch)
            next_state =ideal;
          else
            next_state =start;
        end
       data:
        begin
          if(par_en && bit_cnt=='d8 && (edge_cnt==prescale-1))  //case parity exist
            next_state =parity;
          else if(!par_en && bit_cnt=='d8 && (edge_cnt==prescale-1))  //case not parity exist
            next_state =stop;
          else
            next_state =data;
        end
       parity:
        begin
          if((bit_cnt ==9) && (edge_cnt==prescale-1))
            next_state =stop;
          else
            next_state =parity;
          end
       stop:    //from her we can go to  datavalid,ideal or start state
        begin
           if((~|var) && (edge_cnt==(mid+4)) && ((bit_cnt=='d9)|(bit_cnt=='d10)))
            next_state =data_valids;
          else if(|var && (!rx_in) &&(edge_cnt==prescale-1) &&((bit_cnt=='d9)|(bit_cnt=='d10)))
            next_state =start;
          else if(|var && rx_in &&(edge_cnt==prescale-1) &&((bit_cnt=='d9)|(bit_cnt=='d10)))
            next_state =ideal;
          else
            next_state =stop;
        end
       data_valids:  
       begin
         if(rx_in &&(edge_cnt==prescale-1) && ((bit_cnt=='d9)|(bit_cnt=='d10)))
           next_state =ideal;
         else if(!rx_in &&(edge_cnt==prescale-1) && ((bit_cnt=='d9)|(bit_cnt=='d10)))
           next_state =start;
         else
            next_state =data_valids;
       end
       default:
         begin
           next_state=ideal;
         end
      endcase
    end
    


always@(*)
  begin
    case(current_state)
     ideal:
      begin
        data_samp_en ='b0;
        if(!rx_in)                   //do it mealy for counter work immediatly case rx_in=0 at begin
          enable       ='b1;
        else
          enable       ='b0;
          
        deser_en     ='b0;
        data_valid   ='b0;
        stp_chk_en   ='b0;
        strt_chk_en  ='b0;
        par_chk_en   ='b0;
      end
     start:
      begin
        data_samp_en ='b1;
        enable       ='b1;
        deser_en     ='b0;
        data_valid   ='b0;
        stp_chk_en   ='b0;
        par_chk_en   ='b0;
        if((edge_cnt == mid+2))   //up the enable for on bit
          strt_chk_en  ='b1;
        else
          strt_chk_en  ='b0;
      end
     data:
      begin
        data_samp_en ='b1;
        enable       ='b1;
        data_valid   ='b0;
        stp_chk_en   ='b0;
        strt_chk_en  ='b0;
        par_chk_en   ='b0;
        
        if(edge_cnt == mid+2)     //up the enable for on bit
          deser_en  ='b1;
        else
          deser_en  ='b0;
          
          
      end
     parity:
      begin
        data_samp_en ='b1;
        enable       ='b1;
        deser_en     ='b0;
        data_valid   ='b0;
        stp_chk_en   ='b0;
        strt_chk_en  ='b0;
        if((edge_cnt == mid+2))
          par_chk_en  ='b1;
        else
          par_chk_en  ='b0;
      end
     stop:
      begin
        data_samp_en ='b1;
        enable       ='b1;
        deser_en     ='b0;
        data_valid   ='b0;
        strt_chk_en  ='b0;
        par_chk_en   ='b0;
        if((edge_cnt == mid+2))
          stp_chk_en  ='b1;
        else
          stp_chk_en  ='b0;
      end
     data_valids:
      begin
        data_samp_en ='b1;
        enable       ='b1;
        deser_en     ='b0;
        if(edge_cnt==(mid+5))
           data_valid   ='b1;
        else
           data_valid   ='b0;
        stp_chk_en   ='b0;
        strt_chk_en  ='b0;
        par_chk_en   ='b0;
      end
     default:
      begin
        data_samp_en ='b0;
        enable       ='b0;
        deser_en     ='b0;
        data_valid   ='b0;
        stp_chk_en   ='b0;
        strt_chk_en  ='b0;
        par_chk_en   ='b0;
      end
   endcase
    
  end

endmodule








