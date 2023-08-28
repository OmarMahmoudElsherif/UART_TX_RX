
module UART_TB();

/////////////////////////////////////////////////////////
///////////////////// Parameters ////////////////////////
/////////////////////////////////////////////////////////

parameter DATA_WIDTH_TB = 8 ;       // Could be 5,6,7,8 bits 
parameter CLK_PERIOD = 10 ; 

/////////////////////////////////////////////////////////
//////////////////// DUT Signals ////////////////////////
/////////////////////////////////////////////////////////


reg             			        CLK_TB;          
reg          	  			        RST_TB;          
reg			[DATA_WIDTH_TB-1:0]     P_DATA_TB;         
reg                     			DATA_VALID_TB;
reg                     			PAR_EN_TB;
reg                     			PAR_TYP_TB;      
wire                    			TX_OUT_TB;         
wire                    			Busy_TB;

////////////////////////////////////////////////////////
////////////////// initial block /////////////////////// 
////////////////////////////////////////////////////////


initial begin
	//initialize
	initialize();
	//reset
	reset();
	//send data

	$display("************Sending Data Without parity************");
	send_data_without_parity('b00101011);
	#CLK_PERIOD;
	$display("************Sending Data With Even Parity************");

	send_data_with_Even_parity('b00101010);
	#CLK_PERIOD;
	$display("************Sending Data With Odd Parity************");
	
	send_data_with_Odd_parity('b00101011);
	#CLK_PERIOD;

	$display("************ Sending 5 frames Back-To-Back with Even Parity************");
	send_data_with_Even_parity('b00101010);
	send_data_with_Even_parity('b10111001);
	send_data_with_Even_parity('b00100100);
	send_data_with_Even_parity('b11110001);
	send_data_with_Even_parity('b00110010);



	#(10*CLK_PERIOD)
 	$stop ;

end



///////////////////// Clock Generator //////////////////

always #(CLK_PERIOD/2) CLK_TB = ~CLK_TB ;


////////////////////////////////////////////////////////
/////////////////////// TASKS //////////////////////////
////////////////////////////////////////////////////////

/////////////// Signals Initialization //////////////////

task initialize ;
  begin
	CLK_TB			= 1'b0  ;
	RST_TB		    = 1'b1  ;    // rst is deactivated
	DATA_VALID_TB   = 1'b0  ;
	PAR_EN_TB		= 1'b0  ;		// parity is deactivated
	PAR_TYP_TB		= 1'b0	;
  end
endtask

///////////////////////// RESET /////////////////////////

task reset ;
 begin
  #(CLK_PERIOD)
  RST_TB  = 'b0;           // rst is activated
  #(CLK_PERIOD)
  RST_TB  = 'b1;
  #(CLK_PERIOD) ;
 end
endtask


///////////////////////// Send Data without parity /////////////////////////

task send_data_without_parity;
	input	[DATA_WIDTH_TB-1:0] DATA_in;


	reg [DATA_WIDTH_TB-1:0] DATA_Sent;
	integer i;

	begin

		P_DATA_TB = DATA_in;
		DATA_VALID_TB = 1;
		#CLK_PERIOD;
		DATA_VALID_TB = 0;

		for(i=0;i<DATA_WIDTH_TB;i=i+1) begin
			#CLK_PERIOD		DATA_Sent[i] = TX_OUT_TB;	
		end
		if( DATA_Sent == DATA_in ) begin
			$display("Transmission Success");
		end
		else begin
			$display("Transmission Failed");
		end
		#CLK_PERIOD;

	end
endtask


///////////////////////// Send Data with Even Parity /////////////////////////

task send_data_with_Even_parity;
	input	[DATA_WIDTH_TB-1:0] DATA_in;


	reg [DATA_WIDTH_TB:0] DATA_Sent;
	integer i;

	begin
		P_DATA_TB = DATA_in;
		DATA_VALID_TB = 1;
		PAR_TYP_TB = 0;	//even parity
		PAR_EN_TB = 1;
		#CLK_PERIOD;
		DATA_VALID_TB = 0;

		for(i=0;i<=DATA_WIDTH_TB;i=i+1) begin
			#CLK_PERIOD		DATA_Sent[i] = TX_OUT_TB;	
		end
		if( DATA_Sent[DATA_WIDTH_TB-1:0] == DATA_in && DATA_Sent[DATA_WIDTH_TB]==^DATA_in) begin
			$display("Even Parity Transmission Success");
		end
		else begin
			$display("Even Parity Transmission Failed");
		end
		#CLK_PERIOD;

	end
endtask


///////////////////////// Send Data with Even Parity /////////////////////////

task send_data_with_Odd_parity;
	input	[DATA_WIDTH_TB-1:0] DATA_in;


	reg [DATA_WIDTH_TB:0] DATA_Sent;
	integer i;

	begin
		P_DATA_TB = DATA_in;
		DATA_VALID_TB = 1;
		PAR_TYP_TB = 1;	//odd parity
		PAR_EN_TB = 1;
		#CLK_PERIOD;
		DATA_VALID_TB = 0;

		for(i=0;i<=DATA_WIDTH_TB;i=i+1) begin
			#CLK_PERIOD		DATA_Sent[i] = TX_OUT_TB;	
		end
		if( DATA_Sent[DATA_WIDTH_TB-1:0] == DATA_in && DATA_Sent[DATA_WIDTH_TB]==~(^DATA_in)) begin
			$display("Odd Parity Transmission Success");
		end
		else begin
			$display("Odd Parity Transmission Failed");
		end
		#CLK_PERIOD;

	end
endtask





// Design Instaniation
UART_TX #(.DATA_WIDTH(DATA_WIDTH_TB) ) DUT (
	.CLK(CLK_TB),
	.RST(RST_TB),
	.P_DATA(P_DATA_TB),
	.DATA_VALID(DATA_VALID_TB),
	.PAR_EN(PAR_EN_TB),
	.PAR_TYP(PAR_TYP_TB),
	.TX_OUT(TX_OUT_TB),
	.Busy(Busy_TB)
	);



endmodule