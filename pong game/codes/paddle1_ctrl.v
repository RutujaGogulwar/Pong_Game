// ASCII Codes:
// arrow up - (38)00100110
//arrow dwn - (40)00101000

module paddle1_ctrl(in_clk,i_serial,y_paddle);
input i_serial, in_clk;
output reg [2:0]y_paddle;

wire dv;
wire [7:0]uart_o;
reg [21:0]count_clk = 0;

parameter up  = 8'b 00100110;
parameter dwn = 8'b 00101000;
parameter waitCycles = 2500000;

uart_receiver u1(.clk_in(in_clk),.serial_data_in(i_serial),.data_valid(dv),.data_byte_op(uart_o));

always @(posedge in_clk)
begin
	if(count_clk == waitCycles)
		count_clk <=0;
	else
		count_clk <= count_clk + 1;
	
	if(dv)
	begin
		if(uart_o == up && count_clk == waitCycles)
			y_paddle <= y_paddle-1;
		else if(uart_o == dwn && count_clk == waitCycles)
			y_paddle <= y_paddle+1;
		else
			y_paddle <= y_paddle;
	end
	else
		y_paddle <= y_paddle;
end
endmodule 