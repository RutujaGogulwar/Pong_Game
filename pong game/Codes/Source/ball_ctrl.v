module ball_ctrl(clk_in,reset,gameRunning,h_pos,v_pos,disp_ball,ball_x,ball_y);
input clk_in,reset,gameRunning;
input [5:0]h_pos;
input [5:0]v_pos;
output reg disp_ball;
output reg [5:0]ball_x = 0;
output reg [5:0]ball_y = 0;

parameter ball_width = 16;
parameter ball_height = 16;
parameter screenWidth = 640;
parameter screenHeight = 480;
parameter waitCycles = 2500000;

reg [5:0]  ball_x_p = 0;
reg [5:0]  ball_y_p = 0;
reg [21:0] count_clk = 0;
 
always @(posedge clk_in)
begin
	if (!gameRunning || !reset)
	begin
		ball_x <= screenWidth/2;
		ball_y <= screenHeight/2;
		ball_x_p <= screenWidth/2 + 1;
		ball_y_p <= screenHeight/2 - 1;
	end
 
	else
	begin
		if (count_clk < waitCycles)			//to control speed of ball
			count_clk <= count_clk + 1;
		else
		begin
			count_clk <= 0;
	 
			ball_x_p <= ball_x;
			ball_y_p <= ball_y;

			if ((ball_x_p < ball_x && ball_x == screenWidth-1) || (ball_x_p > ball_x && ball_x != 0))
				ball_x <= ball_x - 1;
			else
				ball_x <= ball_x + 1;
			if ((ball_y_p < ball_y && ball_y == screenHeight-1) || (ball_y_p > ball_y && ball_y != 0))
				ball_y <= ball_y - 1;
			else
				ball_y <= ball_y + 1;
		end
	end
end 


always @(posedge clk_in)
begin
	if (v_pos == ball_x && h_pos == ball_y)
		disp_ball <= 1'b1;
	else
		disp_ball <= 1'b0;
end
endmodule 