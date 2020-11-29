module seven_segment_ctrl(i_clk,num,seg_A,seg_B,seg_C,seg_D,seg_E,seg_F,seg_G);
input i_clk;
input [3:0]num;
output seg_A,seg_B,seg_C,seg_D,seg_E,seg_F,seg_G;

reg [6:0] hex_value = 7'h 00;

always @(posedge i_clk)
begin
	case(num)
		0 : hex_value <= 7'h 7E;
		1 : hex_value <= 7'h 30;
		2 : hex_value <= 7'h 6D;
		3 : hex_value <= 7'h 79;
		4 : hex_value <= 7'h 33;
		5 : hex_value <= 7'h 5B;
		6 : hex_value <= 7'h 5F;
		7 : hex_value <= 7'h 70;
		8 : hex_value <= 7'h 7F;
		9 : hex_value <= 7'h 7B;
	endcase
end 

assign seg_A = hex_value[6];
assign seg_B = hex_value[5];
assign seg_C = hex_value[4];
assign seg_D = hex_value[3];
assign seg_E = hex_value[2];
assign seg_F = hex_value[1];
assign seg_G = hex_value[0];

endmodule 