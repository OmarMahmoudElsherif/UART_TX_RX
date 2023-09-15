
module UART_RX #(
	parameter DATA_WIDTH = 8  // default value 
	)
	(
///////////////////// Inputs /////////////////////////////////
	input		wire						CLK,
	input		wire						RST,
	input		wire						PAR_TYP,
	input		wire						PAR_EN,
	input		wire	[5:0]				Prescale,
	input		wire						RX_IN,
///////////////////// Outputs ////////////////////////////////
	output		wire		[DATA_WIDTH-1:0]	P_DATA,
	output		wire						data_valid
	);




//////////////////////////////////////////////////////////////
////////////////// Internal Signals //////////////////////////
//////////////////////////////////////////////////////////////

wire  				data_samp_en_Top;

wire	[3:0]		bit_cnt_Top;
wire	[5:0]		edge_cnt_Top;
wire				enable_Top;
wire				par_chk_en_Top;
wire				par_err_Top;
wire				strt_chk_en_Top;
wire				strt_glitch_Top;
wire				stp_chk_en_Top;
wire				stp_err_Top;
wire				deser_en_Top;
wire				sampled_bit_Top;




FSM_RX FSM_DUT (
///////////////////// Inputs /////////////////////////////////
	.CLK(CLK),
	.RST(RST),
	.RX_IN(RX_IN),
	.Prescale(Prescale),
	.PAR_EN(PAR_EN),
	.PAR_TYP(PAR_TYP),
	.bit_cnt(bit_cnt_Top),
	.edge_cnt(edge_cnt_Top),
	.par_err(par_err_Top),
	.strt_glitch(strt_glitch_Top),
	.stp_err(stp_err_Top),
///////////////////// Outputs ////////////////////////////////
	.data_samp_en(data_samp_en_Top),
	.enable(enable_Top),
	.par_chk_en(par_chk_en_Top),
	.strt_chk_en(strt_chk_en_Top),
	.stp_chk_en(stp_chk_en_Top),
	.data_valid(data_valid),
	.deser_en(deser_en_Top)
	);




deserializer  #(.DATA_WIDTH(DATA_WIDTH) )
	deser_DUT
(
	.CLK(CLK),
	.RST(RST),
	.sampled_bit(sampled_bit_Top),
	.deser_en(deser_en_Top),
	.P_DATA(P_DATA)
);



data_sampling data_sampling_DUT(
	.CLK(CLK),
	.RST(RST),
	.Prescale(Prescale),
	.RX_IN(RX_IN),
	.data_samp_en(data_samp_en_Top),
	.edge_cnt(edge_cnt_Top),
	.sampled_bit(sampled_bit_Top)
);



edge_bit_counter Counter_DUT(
	.CLK(CLK),
	.RST(RST),
	.enable(enable_Top),
	.Prescale(Prescale),
	.edge_cnt(edge_cnt_Top),
	.bit_cnt(bit_cnt_Top)
);




Stop_Check Stop_Check_DUT(
	.stp_chk_en(stp_chk_en_Top),
	.sampled_bit(sampled_bit_Top),
	.stp_err(stp_err_Top)
	);


Start_Check Start_Check_DUT(
	.strt_chk_en(strt_chk_en_Top),
	.sampled_bit(sampled_bit_Top),
	.strt_glitch(strt_glitch_Top)
	);

Parity_Check #(.DATA_WIDTH(DATA_WIDTH) )
	Parity_Check_DUT
	(
	.sampled_bit(sampled_bit_Top),
	.par_chk_en(par_chk_en_Top),
	.PAR_TYP(PAR_TYP),
	.P_DATA(P_DATA),
	.par_err(par_err_Top)
);








endmodule