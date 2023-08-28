
module parity #(
	parameter DATA_WIDTH = 8  // default value 
)
	(
	input		wire							CLK,
	input		wire							RST,
	input		wire							PAR_TYP,
	input		wire							DATA_Valid,
	input		wire	[DATA_WIDTH-1:0]		P_DATA,
	output		reg								par_bit
	);

// PAR_TYP : 0 -> Odd parity,  1 -> Even parity
always@(posedge CLK, negedge RST)	begin
	if(!RST) begin
		par_bit	<=	'b0;
	end

	else if(DATA_Valid == 'b1)
		par_bit <= (PAR_TYP == 0) ? ^P_DATA : ~(^P_DATA) ;

end


endmodule