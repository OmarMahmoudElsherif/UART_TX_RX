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
integer i=0;

always@(posedge sys_clk, negedge rst) begin

rx_dout<=rx_dout;  // to avoid latches
rx_done_tick<=rx_done_tick;

	if(~rst) begin
		no_sampling_ticks<=0;
		rx_data <=0;
		no_recieved_data<=0;
		sampling_cntr <=0;
		rx_done_tick <=0;
		start_flg<=0;
		sample_data_flg<=0;
		i<=0;
	end
	else begin
		if(rx_data_in ==0 && ~sample_data_flg) begin // start bit occurs
			start_flg<=1'd1;
			if(sampling_cntr==5'd8) begin  // middle of start bit
				sampling_cntr<=0;
				sample_data_flg<=1;
			end
		end
		if(sample_data_flg==1) begin
			if(sampling_cntr==5'd16) begin
				
				sampling_cntr<=0;
				no_recieved_data<=no_recieved_data+1;
				if(no_recieved_data==DATA_BITS) begin // we captured all data. (8)
					sampling_cntr<=0;
					start_flg<=1'b0;
					rx_done_tick<=1;
				end
				else  begin
					/****output data******/
			// flip output as we took LSB starting from start bit
			// so we now have LSB in place of MSB , so we need to flip the register
				rx_dout[i] <=rx_data_in ;  // capture and store data
				i=i+1;
				if(i==DATA_BITS) i=0;

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

