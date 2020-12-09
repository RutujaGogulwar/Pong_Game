module paddle2_ctrl(in_clk,reset,push1,push2,y_paddle,dispPaddle2,h_pos,v_pos);
input push1,push2,reset,in_clk;
input [11:0]h_pos,v_pos;
output reg [8:0]y_paddle;
output reg dispPaddle2;

reg [21:0]count_clk = 0;
parameter paddleHeight = 48;
parameter paddleWidth = 10;
parameter screenWidth =640;
parameter screenHeight = 480;
parameter waitCycles = 2500000;

always @(posedge in_clk)
begin
	if(count_clk == waitCycles)
		count_clk <=0;
	else
		count_clk <= count_clk + 1;
end

always @(posedge in_clk)
begin
	if(!reset)
		y_paddle <= 240;		//centre of screen : 480/2
	if(push1 == 0 && count_clk == waitCycles)		// up
		y_paddle <= y_paddle-1;
	else if(push2 == 0 && count_clk == waitCycles)		// down
		y_paddle <= y_paddle+1;
	else
		y_paddle <= y_paddle;
end

always @(posedge in_clk)
begin
    if ((v_pos > screenWidth-paddleWidth) && (h_pos >= y_paddle) && h_pos <= y_paddle + paddleHeight)
      dispPaddle2 <= 1'b1;
    else
      dispPaddle2 <= 1'b0;
end

endmodule 