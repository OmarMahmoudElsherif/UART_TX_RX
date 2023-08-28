
module UART_TX #(
	parameter	DATA_WIDTH = 8	//default value
	) 

	(
	input	wire						CLK,
	input	wire						RST,
	input	wire	[DATA_WIDTH-1:0]	P_DATA,
	input	wire						DATA_VALID,
	input	wire						PAR_EN,
	input	wire						PAR_TYP,
	output	wire						TX_OUT,
	output	wire						Busy
	);


/////////////////////////////////////////////////////
/////////////// Internal Signals ////////////////////
/////////////////////////////////////////////////////

wire				ser_en_Top;
wire				ser_done_Top;
wire     			ser_data_Top;
wire				par_bit_Top;
wire	[1:0]		mux_sel_Top;


/////////////////////////////////////////////////////
///////////// Modules Instatiations /////////////////
/////////////////////////////////////////////////////

/**** Serializer Instantiation ****/
serializer Serializer_Inst (
	.CLK(CLK),
	.RST(RST),
	.P_DATA(P_DATA),
	.ser_en(ser_en_Top),
	.ser_done(ser_done_Top),
	.ser_data(ser_data_Top)
);


/**** Parity Instantiation ****/
parity Parity_Inst (
	.CLK(CLK),
	.RST(RST),
	.PAR_TYP(PAR_TYP),
	.DATA_Valid(DATA_VALID),
	.P_DATA(P_DATA),
	.par_bit(par_bit_Top)
);



/**** MUX 4x1 Instantiation ****/
MUX_4x1 MUX_4x1_Inst (
	.mux_sel(mux_sel_Top),
	.ser_data(ser_data_Top),
	.par_bit(par_bit_Top),
	.TX_OUT(TX_OUT)
	);



/**** FSM Instantiation ****/
FSM FSM_Inst (
	.CLK(CLK),
	.RST(RST),
	.Data_Valid(DATA_VALID),
	.ser_done(ser_done_Top),
	.PAR_EN(PAR_EN),
	.mux_sel(mux_sel_Top),
	.busy(Busy),
	.ser_en(ser_en_Top)
	);




endmodule