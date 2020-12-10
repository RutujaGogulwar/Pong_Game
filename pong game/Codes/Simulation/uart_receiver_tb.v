`timescale 1ns/1ps
module uart_receiver_tb();

reg clk, serial_in;
wire dataValid;
wire [7:0]o_data_byte;

uart_receiver u1(.clk_in(clk),.serial_data_in(serial_in),.data_valid(dataValid),.data_byte_op(o_data_byte));
 
initial clk <= 0;
always
begin
	#10 clk <= ~clk;
end

initial 
begin
	@(posedge clk)
		// start bit
				serial_in <= 1'b 0;
				
		//8-bit data 11000101
		#8600 serial_in <= 1'b 1;
		#8600 serial_in <= 1'b 0;
		#8600 serial_in <= 1'b 1;
		#8600 serial_in <= 1'b 0;
		#8600 serial_in <= 1'b 0;
		#8600 serial_in <= 1'b 0;
		#8600 serial_in <= 1'b 1;
		#8600 serial_in <= 1'b 1;
		
		// stop bit
		#8600 serial_in <= 1'b 1;
		
		//end simulation
		#8600 $finish;
		
		if(o_data_byte == 8'b 11000101)
			$display("Test Passed");
		else
			$display("Test Failed");
end

endmodule 