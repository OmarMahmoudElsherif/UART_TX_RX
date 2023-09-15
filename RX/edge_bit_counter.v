
module edge_bit_counter (
	input		wire				CLK,
	input		wire				RST,
	input		wire				enable,
	input		wire	[5:0]		Prescale,
	output		reg		[5:0]		edge_cnt,
	output		reg		[3:0]		bit_cnt
	);


always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		// reset
		edge_cnt 		<=		'b1;
		bit_cnt 		<=		'b0;
	end
	else if (enable) begin
		
		if(edge_cnt == Prescale ) begin
			bit_cnt 	<=	bit_cnt 	+	'b1;
			edge_cnt 	<=	'b1;	
		end
		else begin
			edge_cnt 	<=		edge_cnt 	+	'b1;
		end
	end
	else begin
		edge_cnt 		<=		'b1;
		bit_cnt 		<=		'b0;
	end
end



endmodule
