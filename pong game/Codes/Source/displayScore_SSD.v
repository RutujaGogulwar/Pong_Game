module displayScore_SSD(i_clk,score,segment);
input i_clk;
input [2:0]score;
output[6:0]segment;

reg [6:0] hex_value = 7'h 00;

always @(posedge i_clk)
begin
	case(score)
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

assign segment[6] = hex_value[6];
assign segment[5] = hex_value[5];
assign segment[4] = hex_value[4];
assign segment[3] = hex_value[3];
assign segment[2] = hex_value[2];
assign segment[1] = hex_value[1];
assign segment[0] = hex_value[0];

endmodule 