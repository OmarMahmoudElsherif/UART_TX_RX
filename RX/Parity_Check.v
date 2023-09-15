
module Parity_Check #(
	parameter DATA_WIDTH = 8  // default value 
	)

	(
	input		wire							sampled_bit,
	input		wire							par_chk_en,
	input		wire							PAR_TYP,
	input		wire	[DATA_WIDTH-1:0]		P_DATA,
	output		reg								par_err
	);


always @(*) begin
	if(par_chk_en) begin
		if(PAR_TYP == 'b0) begin   // even parity
			if( ^P_DATA == sampled_bit) begin
				par_err		=		'b0;			
			end
			else begin
				par_err		=		'b1;
			end
		end
		else begin 		// odd parity
			if( ~(^P_DATA) == sampled_bit) begin
				par_err		=		'b0;			
			end
			else begin
				par_err		=		'b1;
			end
		end
	end

end

endmodule