`timescale 1ns/1ns
module debounce_pb_tb();

reg clk,i_pb;
wire o_pb;

debounce_pb D(.in_clk(clk), .pb_in(i_pb), .pb_out(o_pb));

always #10 clk <= ~clk;

initial 
begin
clk <= 1'b 0;
i_pb <=1'b 1;
end

initial
begin
	@(posedge clk)
				i_pb <= 1'b 1;
		#3 	i_pb <= 1'b 0;
		#5 	i_pb <= 1'b 1;
		#20	i_pb <= 1'b 0;
		#6 	i_pb <= 1'b 1;
		#5 	i_pb <= 1'b 0;
		#20	i_pb <= 1'b 1;
		#3 	i_pb <= 1'b 0;
		#10	i_pb <= 1'b 1;
		#10000 i_pb <= 1'b 0;
end
endmodule 