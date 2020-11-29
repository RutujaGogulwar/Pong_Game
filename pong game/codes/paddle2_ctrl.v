module paddle2_ctrl(in_clk,reset,push1,push2,y_paddle);
input push1,push2,reset,in_clk;
output reg [2:0]y_paddle;
reg [21:0]count_clk = 0;

parameter waitCycles = 2500000;

vga_controller v1(.clk(in_clk),.Hsync(),.Vsync(),.rst(reset),.rgb());

always @(posedge in_clk)
begin
	if(count_clk == waitCycles)
		count_clk <=0;
	else
		count_clk <= count_clk + 1;
end

always @(posedge in_clk)
begin
	if(push1 == 0 && count_clk == waitCycles)
		y_paddle <= y_paddle-1;
	else if(push2 == 0 && count_clk == waitCycles)
		y_paddle <= y_paddle+1;
	else
		y_paddle <= y_paddle;
end

endmodule 