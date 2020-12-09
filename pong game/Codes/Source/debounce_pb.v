module debounce_pb(in_clk, pb_in, pb_out);
input in_clk;
input pb_in;
output pb_out;

reg button_state		 = 1'b 1;		//not pressed 
reg [18:0]clk_counter = 0;

parameter clks_ms = 500000;			//clks cycles to elapse 10ms
  
always @(posedge in_clk)
begin
	if((pb_in !== button_state) && (clk_counter < clks_ms))
	begin
	clk_counter <= clk_counter + 1;
	end
	
	else if((pb_in !== button_state) && clk_counter == clks_ms)
	begin
	clk_counter  <= 0;
	button_state <= pb_in;
	end
	
	else
	begin
	clk_counter <= 0;
	end
end

assign pb_out = button_state;
endmodule 