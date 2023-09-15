
module Stop_Check (
	input		wire		stp_chk_en,
	input		wire		sampled_bit,
	output		reg			stp_err
	);


always @(*) begin
	if(stp_chk_en) begin
		if(sampled_bit == 'b1) begin   // stop bit = '1'
			stp_err		=	'b0;
		end
		else begin 		//error in stop bit
			stp_err		=	'b1;
		end
	end
	else begin
		stp_err		=	'b0;
	end

end

endmodule