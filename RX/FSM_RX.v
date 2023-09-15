
module FSM_RX (

///////////////////// Inputs /////////////////////////////////

	input		wire				CLK,
	input		wire				RST,
	input		wire				RX_IN,
	input		wire	[5:0]		Prescale,
	input		wire				PAR_EN,
	input		wire				PAR_TYP,
	input		wire	[3:0]		bit_cnt,	//unused
	input		wire	[5:0]		edge_cnt,
	input		wire				par_err,
	input		wire				strt_glitch,
	input		wire				stp_err,

///////////////////// Outputs ////////////////////////////////

	output		reg					data_samp_en,
	output		reg					enable,
	output		reg					par_chk_en,
	output		reg					strt_chk_en,
	output		reg					stp_chk_en,
	output		reg					data_valid,
	output		reg					deser_en

	);

//////////////////////////////////////////////////////////////
////////////////////////  FSM States  ////////////////////////
//////////////////////////////////////////////////////////////

localparam		[2:0]		IDLE					=	'b000,		
							Start_Bit				=	'b001,
							Data_Stage				=	'b010,
							Parity_Bit				=	'b011,
							Stop_Bit   				=   'b101;
					


reg		[2:0]	Next_state,
				current_state;


// internal register
reg		[5:0]		Prescale_reg;
// we made register for prescale in case it changed it next back-to-back transaction
// so our Stop_Bit state doesnot change its functionality.
always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		Prescale_reg	<=		'b0;
	end
	else begin
		Prescale_reg	<=		Prescale;
	end
end


//////////////////////////////////////////////////////////////
/////////////////////  State Transition  /////////////////////
//////////////////////////////////////////////////////////////

always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		current_state	<=	IDLE;
	end
	else  begin
		current_state	<=	Next_state;
	end
end



//////////////////////////////////////////////////////////////
////////////////////// Next State Logic  /////////////////////
//////////////////////////////////////////////////////////////

always@(*) begin
	data_samp_en		=		'b0;
	enable				=		'b0;
	par_chk_en			=		'b0;
	strt_chk_en			=		'b0;
	stp_chk_en			=		'b0;
	data_valid			=		'b0;
	deser_en			=		'b0;
	Next_state			=		IDLE;


	case(current_state)

	IDLE	:	begin

		if(RX_IN	==	'b0	) begin
			enable			=		'b1;
			Next_state		=		Start_Bit;
		end
		else begin
			Next_state		=		IDLE;
		end
	end	

	Start_Bit	:	begin
		strt_chk_en		=		'b1;
		enable			=		'b1;
		data_samp_en	=		'b1;

		if(strt_glitch	==	'b0	&& bit_cnt == 'b1 ) begin
			Next_state		=		Data_Stage;
		end
		else if (bit_cnt == 'b0 ) begin   //we still waiting for 9th clk edge in case prescaler 16
			Next_state		=		Start_Bit;
		end
		else begin
			Next_state		=		IDLE;
		end
	end	

	Data_Stage	:	begin
		enable			=		'b1;
		data_samp_en	=		'b1;

		if(bit_cnt != 'd9 ) begin
			
			Next_state		=		Data_Stage;
			if(edge_cnt == ((Prescale_reg>>1) +'d2))  // since if we have Prescale = 16 , so we take 3 samples at {7,8,9} and produce result at edge_cnt=10
			begin
				deser_en		=		'b1;  //enable shift register
			end
			else begin
				deser_en		=		'b0;
			end

		end
		else begin
			if(PAR_EN == 'b1)  begin 	//enable frame parity bit
				Next_state		=		Parity_Bit;
			end
			else begin
				Next_state		=		Stop_Bit;
			end
		end
		
	end	


	Parity_Bit	:	begin
		enable			=		'b1;
		data_samp_en	=		'b1;
		par_chk_en		=		'b1;


		if(bit_cnt == 'd10 ) begin
			
			if(par_err	==	'b1)   begin
				Next_state		=		IDLE;
			end
			else begin
				Next_state		=		Stop_Bit;
			end
		end
		else begin
			Next_state			=		Parity_Bit;
		end
		
	end	

	Stop_Bit :	begin
		enable			=		'b1;
		data_samp_en	=		'b1;
		stp_chk_en		=		'b1;

		if(edge_cnt == Prescale_reg ) begin  
		
			/**clear enables **/
				enable			=	'b0;
				data_samp_en	=	'b0;
				stp_chk_en		=	'b0;
			
			if(stp_err	==	'b1)   begin
				Next_state		=		IDLE;
			end
			else begin
				/**Outputs Data**/
				data_valid		=	'b1;
				

				if(RX_IN == 'b0) begin  //	consective frames
					Next_state		=	Start_Bit;
				end
				else begin
					Next_state		=	IDLE;
				end
			end

		end

		else begin
			Next_state		=		Stop_Bit;
		end

	end

	default : begin
			data_samp_en		=		'b0;
			enable				=		'b0;
			par_chk_en			=		'b0;
			strt_chk_en			=		'b0;
			stp_chk_en			=		'b0;
			data_valid			=		'b0;
			deser_en			=		'b0;
			Next_state			=		IDLE;
	end



	endcase


end





endmodule
