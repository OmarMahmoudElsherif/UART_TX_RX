
module deserializer #(
	parameter DATA_WIDTH = 8  // default value 
	)

	(
	input		wire							CLK,
	input		wire							RST,
	input		wire							sampled_bit,
	input		wire							deser_en,
	output		reg  	[DATA_WIDTH-1:0]		P_DATA
	);


//shift register
reg 	[DATA_WIDTH-1:0]	 Shift_Register;


always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		// reset
		P_DATA				<=		'b0;	
		Shift_Register		<=		'b0;
	end
	else if(deser_en) begin
		//	Shift_Register	<= 	{Shift_Register[DATA_WIDTH-2:0],sampled_bit};
			
		Shift_Register <= {sampled_bit,Shift_Register[7:1]};
	end
	
	else begin
		P_DATA			<=		Shift_Register;
	end

end





endmodule