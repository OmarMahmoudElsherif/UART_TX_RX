module UART_RX #(
	parameter DATA_BITS=8, //default 8 data bits
		  STOP_BIT_TICKS = 16  // a stop bit ticks
)(
	input sys_clk,rst,rx_sampling_clk,
	input rx_data_in,
	output reg rx_done_tick,
	output reg [DATA_BITS-1:0] rx_dout
);

reg[3:0] no_sampling_ticks;
reg [DATA_BITS-1:0] rx_data, no_recieved_data;
reg [4:0] sampling_cntr;

reg start_flg;
reg sample_data_flg;

always@(posedge sys_clk, negedge rst) begin
	if(~rst) begin
		no_sampling_ticks<=0;
		rx_data <=0;
		no_recieved_data<=0;
		sampling_cntr <=0;
		rx_done_tick <=0;
		start_flg<=0;
		sample_data_flg<=0;
	end
	else begin
		if(rx_data_in ==0 && ~sample_data_flg) begin // start bit occurs
			start_flg<=1'd1;
			if(sampling_cntr==5'd8) begin  // middle of start bit
				sampling_cntr<=0;
				sample_data_flg<=1;
				//start_flg<=1'b0;
			end
		end
		if(sample_data_flg==1) begin
			if(sampling_cntr==5'd16) begin
				rx_data <=rx_data_in | (rx_data<<1); // capture and store data
				sampling_cntr<=0;
				no_recieved_data<=no_recieved_data+1;
				if(no_recieved_data==8'd8) begin // we captured all data.
					sampling_cntr<=0;
					start_flg<=1'b0;
					rx_dout<=rx_data; // output data
					rx_done_tick<=1;
				end
			end		
		end
			
	end

end


// counting number of samples
always@ (posedge rx_sampling_clk) begin
	if(start_flg ==1) begin
		sampling_cntr <=sampling_cntr+1;
	end
	else begin
		rx_done_tick<=0;
	end
end


endmodule

