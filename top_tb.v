

`timescale 1ns/1ns
module top;

reg clk=0;

always #(5) clk=~clk;   // to get clk period = 10nsec= 0.01usec (1/100 MHZ) if using system freq=100MHZ

wire rx_clk;
reg rx_data_in_tb;
reg rst;
wire rx_done;
wire [7:0] rx_dout_tb;

baud_rate_gen #(
	.pBAUD_RATE(9600),
	.pSYS_CLK_FREQ(100000000)
)
top_baud_gen (
	.sys_clk(clk),
	.Async_rst(rst),
	.clk_out(rx_clk)


);

UART_RX #(
	.DATA_BITS(8), 
	.STOP_BIT_TICKS(16)

) uart_rx_tb (
	.sys_clk(clk),
	.rst(rst),
	.rx_sampling_clk(rx_clk),
	.rx_data_in(rx_data_in_tb),
	.rx_done_tick(rx_done),
	.rx_dout(rx_dout_tb)
);


reg [16:0] Tb;
initial begin

// since rx_clk = 6.5 usec, so Tb must be >=16rx_clk = 104000 nsec
Tb<= 104000;

rst<=0;
#2
rst<=1;
rx_data_in_tb <=1; //idle
#Tb  
rx_data_in_tb <=0; // start
#Tb

/***********data bits  1001_1010  ****************/
rx_data_in_tb <=1; 
#Tb
rx_data_in_tb <=0; 
#Tb
rx_data_in_tb <=0; 
#Tb
rx_data_in_tb <=1; 
#Tb

rx_data_in_tb <=1; 
#Tb
rx_data_in_tb <=0; 
#Tb
rx_data_in_tb <=1; 
#Tb
rx_data_in_tb <=0; 
#Tb;

// idle again
rx_data_in_tb <=1; 
#Tb;

$display("Tx data : 1001_1010");
$display("Rx data = %b",rx_dout_tb);
$stop();

end


endmodule
