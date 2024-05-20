module SYS_TOP #(parameter Config_W=8 ,Data_W=8, ALU_W=16)(
input  wire       REF_CLK,RST,UART_CLK,
input  wire       RX_IN,
output wire       TX_OUT,
output wire       Par_Err,Stp_Err
);

localparam  RF_add_w =4,
            RF_data_w=8,
            FUN_W    =4;
            
            
///////////////////RX I/O PORTS////////////////////////
wire   [Config_W-1:0]  UART_Config;
wire   [Data_W-1:0]    P_Data,P_Data_syn;
wire                   data_valid,data_valid_syn;

//////////////////SYS_CTRL I/O PORTS///////////////////
wire                   WrEN ,RdEn ,Rd_D_Vld,addr_en;
wire   [RF_add_w-1:0]  Addr;
wire   [RF_data_w-1:0] Wr_D ,Rd_D; 
wire   [FUN_W-1:0]     FUN;
wire                   EN,OUT_Valid;
wire   [Data_W-1:0]    WR_DATA;
wire   [ALU_W-1 :0]    ALU_OUT ;
wire                   FIFO_FULL,WR_INC; 
wire                   Gate_EN,clk_div_en;   

//////////////////REG_FILE I/O PORTS///////////////////
wire  [Data_W-1:0]    OP_1,OP_2;
wire  [Data_W-1:0]    Div_Ratio;
wire                  SYNC_RST1;


//////////////////ALU I/O PORTS///////////////////////
wire                  ALU_CLK;


//////////////////ASYNC_FIFO I/O PORTS////////////////
wire                  TX_CLK;
wire  [Data_W-1:0]    RD_DATA;
wire                  F_EMPTY;
wire                  RD_INC;
wire                  SYNC_RST2;


//////////////////CLK_DIV I/O PORTS///////////////////
wire  [7:0]           mux_in;
wire                  RX_CLK;


//////////////////TX I/O PORTS////////////////////////
wire                  Busy;  //,TX_OUT


DATA_SYNC U0_DATA_SYNC(
.clk(REF_CLK),
.rst(SYNC_RST1),                        
.unsync_bus(P_Data),
.bus_enable(data_valid),
.sync_bus(P_Data_syn),
.enable_pulse(data_valid_syn)
);


RST_SYNC U1_RST_SYNC(
.rst(RST),
.clk(REF_CLK),
.SYNC_RST(SYNC_RST1)
);

RST_SYNC U2_RST_SYNC(
.rst(RST),
.clk(UART_CLK),
.SYNC_RST(SYNC_RST2)
);


UART_RX U3_UART_RX(
.CLK(RX_CLK),
.RST(SYNC_RST2),
.PRESCALE(UART_Config[7:2]),
.PER_EN(UART_Config[0]),
.PAR_TYP(UART_Config[1]),
.RX_IN(RX_IN),
.DATA_VALID(data_valid),
.P_DATA(P_Data),
.par_err(Par_Err),
.stp_err(Stp_Err)
);


UART_TX  U4_UART_TX(
.P_DATA(RD_DATA),
.DATA_VALID(F_EMPTY),
.PAR_TYP(UART_Config[1]),
.PAR_EN(UART_Config[0]),
.CLK(TX_CLK),
.RST(SYNC_RST2),
.start_bit(1'd0),
.stop_bit(1'd1),
.TX_OUT(TX_OUT),
.BUSY(Busy)
);

SYS_CTRL  U5_SYS_CTRL(
.CLK(REF_CLK),
.RST(SYNC_RST1),
.ALU_OUT(ALU_OUT),
.OUT_Valid(OUT_Valid),
.RX_D_VLD(data_valid_syn),
.RdData_Valid(Rd_D_Vld),
.FIFO_Full(FIFO_FULL),
.RX_P_DATA(P_Data_syn),
.RdData(Rd_D),
.ALU_EN(EN),
.CLK_EN(Gate_EN),
.WrEN(WrEN),
.RdEN(RdEn),
.TX_D_VLD(WR_INC),
.clk_div_en(clk_div_en),
.Address(Addr),
.ALU_FUN(FUN),
.WrData(Wr_D),
.TX_P_DATA(WR_DATA),
.addr_en(addr_en)
);

REG_File U6_REG_File(
.CLK(REF_CLK),
.RST(SYNC_RST1),
.WrEn(WrEN),
.RdEn(RdEn),
.Address(Addr),
.WrData(Wr_D),
.RrData(Rd_D),
.RdData_Valid(Rd_D_Vld),
.REG0(OP_1),
.REG1(OP_2),
.REG2(UART_Config),
.REG3(Div_Ratio),
.addr_en(addr_en)
);

ALU U6_ALU(
.CLK(ALU_CLK),
.RST(SYNC_RST1),
.Enable(EN),
.A(OP_1),
.B(OP_2),
.ALU_FUN(FUN),
.ALU_OUT(ALU_OUT),
.OUT_VALID(OUT_Valid)
);

Async_fifo U7_Async_fifo(
.W_CLK(REF_CLK),
.W_RST(SYNC_RST1),
.R_CLK(TX_CLK),
.R_RST(SYNC_RST2),
.W_INC(WR_INC),
.R_INC(RD_INC),
.WR_DATA(WR_DATA),
.RD_DATA(RD_DATA),
.FULL(FIFO_FULL),
.EMPTY(F_EMPTY)
);


ClkDiv U8_ClkDiv_TX(
.i_ref_clk(UART_CLK),
.i_ret_n(SYNC_RST2),
.i_clk_en(clk_div_en),
.i_div_ratio(Div_Ratio),
.o_div_clk(TX_CLK)
);


ClkDiv U9_ClkDiv_RX(
.i_ref_clk(UART_CLK),
.i_ret_n(SYNC_RST2),
.i_clk_en(clk_div_en),
.i_div_ratio(mux_in),
.o_div_clk(RX_CLK)
);

CLK_GATE U10_CLK_GATE(

.CLK_EN(Gate_EN),
.CLK(REF_CLK),
.GATED_CLK(ALU_CLK)
);

Div_mux  U11_Div_mux(
.mux_out(mux_in),
.prescale(UART_Config[7:2])
);


PULSE_GEN  U12_PULSE_GEN(
.clk(TX_CLK),
.rst(SYNC_RST2),
.busy(Busy),
.RD_inc(RD_INC)
);

endmodule


