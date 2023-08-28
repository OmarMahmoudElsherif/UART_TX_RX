
module serializer #(
	parameter DATA_WIDTH = 8  // default value 
	) 

	(
	input		wire							CLK,
	input		wire							RST,
	input		wire	[DATA_WIDTH-1:0]		P_DATA,
	input		wire							ser_en,
	output		reg								ser_done,
	output		reg								ser_data
	);


reg 	[DATA_WIDTH-1:0]	 Shift_Register;
reg 	[2:0]				 Counter;		// we made it 3 bits as max data transfer allowed in uart {5, 6, 7, 8 bits}


// Sequential always
always@(posedge CLK,negedge RST)	begin
	if(!RST)	begin
		ser_data	<=	'b0;
		ser_done	<=	'b1;
		Counter     <=  'b0;
	end
	else begin

		// storing input data
		if(ser_en)	begin             
			Shift_Register	<=	P_DATA;
			ser_done		<=	'b0;	
		end

		// outputing data bit by bit , LSB First
		else if (! ser_done ) begin      

			{Shift_Register[DATA_WIDTH-2:0],ser_data}	<=	Shift_Register;
			Shift_Register[DATA_WIDTH-1]	<=	'b0;

			// Counter Logic
			if(Counter == DATA_WIDTH-1)	 begin
				Counter		<=	'b0;
				ser_done	<=	'b1;
			end
			else begin
				Counter		<=	Counter	+	'b1;
				ser_done	<=	'b0;
			end

		end
		
	end


end

endmodule