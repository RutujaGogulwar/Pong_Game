// ASCII Codes:
// arrow up - (38)00100110
//arrow dwn - (40)00101000

module paddle1_ctrl(in_clk,reset,y_paddle,uart_o,dv,dispPaddle1,h_pos,v_pos);
input in_clk,reset,dv;
input [11:0]h_pos,v_pos;
input [7:0]uart_o;
output reg [8:0]y_paddle;
output reg dispPaddle1;

reg [21:0]count_clk = 0;

parameter paddleHeight = 48;
parameter paddleWidth = 10;

parameter up  = 8'b 00100110;
parameter dwn = 8'b 00101000;
parameter waitCycles = 2500000;

always @(posedge in_clk)
begin
	if(!reset)
		y_paddle <= 240;	//centre of screen: 480/2
		
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

always @(posedge in_clk)
begin
    if ((v_pos < paddleWidth) && (h_pos >= y_paddle) && (h_pos <= y_paddle + paddleHeight))
      dispPaddle1 <= 1'b1;
    else
      dispPaddle1 <= 1'b0;
end
endmodule 