
module MUX_4x1 (
	input		wire		[1:0]		mux_sel,
	input		wire					ser_data,
	input		wire					par_bit,
	output		reg						TX_OUT
	);

always @(*) begin
	case(mux_sel)
	'b00	:	begin
		TX_OUT	=	'b0;		//start bit
	end
	'b01	:	begin
		TX_OUT	=	'b1;		//stop bit
	end
	'b10	:	begin
		TX_OUT	=	ser_data;		// data bits
	end
	'b11	:	begin
		TX_OUT	=	par_bit;		//parity bit
	end

	endcase
	
end


endmodule