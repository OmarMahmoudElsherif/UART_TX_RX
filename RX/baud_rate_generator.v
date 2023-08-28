// Freq of Rx= 16*baudrate (due to oversampling)
// Freq of Tx = baudrate

/*
Standard baud rates include {110,300,600,1200,2400,4800,9600,14400,19200,38400,57600,115200,128000,256000} bps
*/
module baud_rate_gen #(
	parameter pBAUD_RATE= 9600,		// Default value
	parameter pSYS_CLK_FREQ = 100000000    // 100MHZ
)(
	
	input sys_clk,
	input Async_rst,
	output reg clk_out
);

	reg [9:0] counter;
	// Equation to get Final Value
	wire [15:0] FINAL_VALUE;  
// 16-bits as greatest value occurs when using 110 buad rate, and it dont exceed 16bits
	
	assign FINAL_VALUE = pSYS_CLK_FREQ/(16*pBAUD_RATE) -1; 
	// Equation to get Final Value

	always @(posedge sys_clk,negedge Async_rst ) begin
		if(~Async_rst) begin	
			counter<=0;
			clk_out<=0;
		end
		else begin 
			counter<=counter+1;
			if(counter == FINAL_VALUE/2) begin
				clk_out<=~clk_out;
				counter<=0;
			end
			
		end

	end

endmodule

