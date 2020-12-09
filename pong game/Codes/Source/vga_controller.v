module vga_controller(clk,rst,Hsync,Vsync,h_pos,v_pos);
input clk,rst;
output reg Hsync,Vsync;
output reg [11:0]h_pos=0, v_pos=0;
integer active_display=0;		//handshake signal
reg clk_25=0;						//vga works on 25MHz clk

parameter h_display = 640;
parameter h_frontporch = 16;
parameter h_syncpulse = 96;
parameter h_backporch = 48;

parameter v_display = 480;
parameter v_frontporch = 10;
parameter v_syncpulse = 2;
parameter v_backporch = 33;


//clk divider
always @(posedge clk)
begin
	clk_25 <= ~(clk_25);
end

//horizontal position counter
always @(posedge clk_25, negedge rst)
begin
	if(!rst)
		h_pos <= 0;
	else if(h_pos == (h_display + h_frontporch + h_syncpulse + h_backporch))
		h_pos <= 0;
	else
		h_pos <= h_pos+1;
end

//verical position counter
always @(posedge clk_25, negedge rst)
begin
	if(!rst)
		v_pos <= 0;
	else if(h_pos == (h_display + h_frontporch + h_syncpulse + h_backporch))
	begin
		if(v_pos == (v_display + v_frontporch + v_syncpulse + v_backporch))
			v_pos <= 0;
		else
			v_pos <= v_pos+1;
	end
end

//Horizontal synchronization pulse generator
always @(posedge clk_25, negedge rst)
begin
	if(!rst)
		Hsync <= 0;
	else if((h_pos <= (h_display + h_frontporch)) || (h_pos > (h_display + h_syncpulse + h_backporch)))
		Hsync <= 1;
	else
		Hsync <= 0;
end

//Vertical synchronization pulse generator
always @(posedge clk_25, negedge rst)
begin
	if(!rst)
		Vsync <= 0;
	else if((v_pos <= (v_display + v_frontporch)) || (v_pos > (v_display + v_syncpulse + v_backporch)))
		Vsync <= 1;
	else
		Vsync <= 0;
end

//active display area
always @(posedge clk_25, negedge rst)
begin
	if(!rst)
		active_display <= 0;
	else if(h_pos <= h_display && v_pos <= v_display)
		active_display <= 1;
	else 
		active_display <= 0;
end

endmodule 