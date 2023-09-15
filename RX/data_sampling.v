
module data_sampling (
	input		wire				CLK,
	input		wire				RST,
	input		wire   [5:0]		Prescale,
	input		wire				RX_IN,
	input		wire				data_samp_en,
	input		wire   [5:0]		edge_cnt,
	output		reg					sampled_bit
	);

// our 3 samples
reg			sample1,sample2,sample3;



//sequential always
always @(posedge CLK,negedge RST) begin
	if(!RST) begin
		sample1			<=		'b0;
		sample2			<=		'b0;
		sample3			<=		'b0;
		sampled_bit		<=		'b0;	
	end
	else if(data_samp_en)	begin
		if(edge_cnt	==	(Prescale>>1) - 1'b1)	begin  // take sample 1
			sample1		<=	RX_IN;
		end
		else if (edge_cnt	==	(Prescale>>1) ) begin  // take sample 2 (middle sampling bit)
			sample2		<=	RX_IN;
		end
		else if (edge_cnt	==	(Prescale>>1) + 1'b1 ) begin  // take sample 3
			sample3		<=	RX_IN;
		end
		

		case({sample1,sample2,sample3})
			'b000,'b010,'b001,'b100 : begin
				sampled_bit		<=		'b0;	
			end
			'b111,'b110,'b011,'b101 : begin
				sampled_bit		<=		'b1;
			end	
		endcase

	end



end



endmodule