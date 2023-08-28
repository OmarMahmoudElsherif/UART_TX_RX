
module FSM (
	input		wire					CLK,
	input		wire					RST,
	input		wire					Data_Valid,
	input		wire					ser_done,
	input		wire					PAR_EN,
	output		reg			[1:0]		mux_sel,
	output		reg						busy,
	output		reg						ser_en
	);


//5 states
localparam	[2:0]	IDLE_State	   = 'b000,
					Start_State    = 'b001,
					Data_State	   = 'b010,
					Parity_State   = 'b011,
					Stop_State     = 'b100;	


reg	[2:0]	Current_State, 
			Next_State;


//next state logic
always@(posedge CLK, negedge RST) begin
	if(!RST) begin
		Current_State	<=	IDLE_State;
	end
	else begin
		Current_State	<=	Next_State;
	end
end


/************************ FSM Logic ************************/ 
always@(*)  begin

	case(Current_State)
		IDLE_State	:	begin
				mux_sel		=	'b01;	// idle state (Output Logic High)
				ser_en		=	'b0;
				if(Data_Valid) begin
					Next_State	=	Start_State;
					ser_en      =   'b1; // to take data on bus for serializer
					busy        =   'b1;
				end
				else begin
					Next_State	=	IDLE_State;
					busy        =   'b0;	
				end			
		end

		Start_State	:	begin
			mux_sel		=	'b00;
			ser_en      =   'b0;
			busy        =   'b1;
			Next_State	= Data_State;		
		end

		Data_State	:	begin
			mux_sel		=	'b10;
			ser_en      =   'b0;
			busy        =   'b1;
			if(ser_done) begin
				if(PAR_EN) begin
					Next_State	= Parity_State;
				end
				else begin
					Next_State	=	Stop_State;				
				end
			end

			else begin
				Next_State	= Data_State;				
			end
		end

		Parity_State	:	begin
			mux_sel		=	'b11;
			ser_en      =   'b0;
			busy        =   'b1;
			Next_State	=	Stop_State;
		end


		Stop_State	:	begin
			mux_sel		=	'b01;
			ser_en      =   'b0;
			busy        =   'b1;
			if(Data_Valid) begin     // in case we have next transaction directly after stop bit
				Next_State	=	Start_State;
				ser_en      =   'b1; // to take data on bus for serializer
			end
			else begin
				Next_State	=	IDLE_State;			
			end		
		end

		default	:	begin    //default case to avoid latches
			busy        =   'b0;
			ser_en      =   'b0;
			mux_sel     =   'b01;
			Next_State  =	IDLE_State;
				
		end


	endcase



end




endmodule
