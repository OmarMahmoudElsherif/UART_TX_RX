
module Start_Check (
	input		wire		strt_chk_en,
	input		wire		sampled_bit,
	output		reg			strt_glitch
	);


always @(*) begin
	if(strt_chk_en) begin
		if(sampled_bit == 'b0) begin   // start bit = '0'
			strt_glitch		=	'b0;
		end
		else begin 		//error in start bit
			strt_glitch		=	'b1;
		end
	end
	else begin
		strt_glitch		=	'b0;
	end

end

endmodule