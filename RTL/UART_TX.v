///////////////////////////////////////////
//////////serializer module////////////////
///////////////////////////////////////////
module serializer #(parameter width=8 )(
input  wire [width-1:0] p_data,
input  wire ser_en,
input  wire clk,rst,
output reg ser_done,
output reg ser_data
);

reg [3:0] counter=0;
reg [width-1:0] data;


always@(posedge clk,negedge rst)     
begin
  if(!rst)
    begin
      ser_data <= 1'b1;
    end
  else if(ser_en && !ser_done)
    {data[6:0],ser_data} <= data; 
end


always@(posedge clk,negedge rst)
begin
  if(!rst)
    begin
      counter  <=0;
    end
  else if(ser_en )      
    begin
       counter<=counter+1;  
    end
  else
    counter<=0;  
end

always@(*)
  begin
    case(counter)
      4'd8: ser_done=1'b1;
      default: ser_done=1'b0;
    endcase
  end

  
  always@(*)
  begin
    if(counter ==0)
      data=p_data;
    else
      data=data;
  end

endmodule

///////////////////////////////////////////
//////////parity module////////////////////
///////////////////////////////////////////
module parity_Calc #(parameter width=8 )(
input wire [width-1:0] p_data,
input wire data_valid,
input wire par_typ,
input wire par_enable,
input wire clk,rst,
output reg par_bit 
);

reg par_bit_tst1;

always@(posedge clk , negedge rst)
begin
  if(!rst)
    begin
      par_bit<=0'b0;
    end
  else if(par_enable)
    begin 
      par_bit<=par_bit_tst1;
    end
end


always@(*)
  begin
    if(data_valid)
      begin
        if(par_typ)
            par_bit_tst1=~^p_data;
        else
            par_bit_tst1=^p_data;
      end
    else
        par_bit_tst1=par_bit_tst1;
  end
endmodule
///////////////////////////////////////////
/////////////////mux module////////////////
///////////////////////////////////////////
module MUX (
input wire [1:0] mux_sel,
input wire start_bit,
input wire stop_bit,
input wire ser_data,
input wire par_bit,
output reg  tx_out
);

always@(*)
  begin
  case(mux_sel)
    2'b00:tx_out=start_bit;
    2'b01:tx_out=stop_bit;
    2'b10:tx_out=ser_data;
    2'b11:tx_out=par_bit;
  endcase
  end
endmodule


///////////////////////////////////////////
/////////////////FSM module////////////////
///////////////////////////////////////////
module FSM_TX(
  input wire clk,rst,
  input wire  par_en,
  input wire data_valid,
  input wire ser_done,
  output reg ser_en,
  output reg par_enable,
  output reg [1:0] mux_sel,
  output reg busy
);

reg [2:0] current_state,next_state;

localparam 
ideal  =3'b000,
start  =3'b001,
data   =3'b011,
parity =3'b010,
stop   =3'b110;


always@ (posedge clk,negedge rst)
  begin
    if(!rst)
      begin
      current_state <= ideal;
      end
    else 
      current_state <= next_state;
  end


always@(*)
  begin
    case(current_state)
      ideal:
        begin
          mux_sel=2'b01;
          ser_en=1'b0;
          busy=1'b0;
          par_enable=1'b0;
        end
      start:
        begin
          mux_sel=2'b0;
          ser_en=1'b1;
          busy=1'b1;
          par_enable=1'b1;
        end
      data:
        begin
          mux_sel=2'b10;
          ser_en=2'b1;
          busy=1'b1;
          par_enable=1'b0;
        end
      parity:
        begin
          mux_sel=2'b11;
          ser_en=1'b0;
          busy=1'b1;
          par_enable=0'b0;
        end
      stop:
        begin
          mux_sel=2'b01;
          ser_en=1'b0;
          busy=1'b1;
          par_enable=0'b0;
        end
      default:
        begin
          mux_sel=2'b01;
          ser_en='b0;
          busy='b0;
          par_enable='b0;
        end
    endcase
  end

always@(*)
  begin
    case(current_state)
      ideal:
        begin
          if(data_valid)
            next_state=start;
          else
            next_state=current_state;
        end
      start:
        begin
          next_state=data;
        end
      data:
        begin
           if((par_en==1) && (ser_done==1))
             next_state=parity;
           else if((par_en==0) && (ser_done==1))
             next_state=stop;
          else
            next_state=current_state;
        end
      parity:
        begin
          next_state=stop;
        end
      stop:
        begin
          //case(data_valid)
           next_state=ideal;
          //1'b1:next_state=start;
          
        end
      default:
        begin
          next_state=current_state;
        end
    endcase
  end

endmodule

///////////////////////////////////////////
/////////////UART_TX module////////////////
///////////////////////////////////////////
module UART_TX #(parameter W=8)(
input  wire [W-1:0]     P_DATA,
input  wire             DATA_VALID,
input  wire             PAR_TYP,
input  wire             PAR_EN,
input  wire             start_bit,
input  wire             stop_bit,
input  wire             CLK,RST,
output wire             TX_OUT,
output wire             BUSY
);

wire [1:0] MUX_SEL;
wire ser_data,ser_done,ser_en;
wire par_enable,par_bit;

serializer U0(
.clk(CLK),
.rst(RST),
.p_data(P_DATA),
.ser_data(ser_data),
.ser_en(ser_en),
.ser_done(ser_done)
);


parity_Calc U1(
.p_data(P_DATA),
.data_valid(DATA_VALID),
.par_typ(PAR_TYP),
.par_enable(par_enable),
.par_bit(par_bit),
.clk(CLK),
.rst(RST)
);


MUX U2(
.mux_sel(MUX_SEL),
.start_bit(start_bit),
.stop_bit(stop_bit),
.ser_data(ser_data),
.par_bit(par_bit),
.tx_out(TX_OUT)
);


FSM_TX U3(
.clk(CLK),
.rst(RST),
.par_en(PAR_EN),
.data_valid(DATA_VALID),
.ser_done(ser_done),
.ser_en(ser_en),
.par_enable(par_enable),
.mux_sel(MUX_SEL),
.busy(BUSY)
);


endmodule


