module uart_receiver(clk_in,serial_data_in,data_valid,data_byte_op);
input clk_in, serial_data_in;
output data_valid;			//handshake signal
output [7:0]data_byte_op;

parameter baudRate		= 115200;
parameter clk_per_bit   = 434;			//clk_in/baudRate=50,000,000/115200

parameter idle				= 3'b 000;
parameter startBit		= 3'b 001;
parameter stopBit			= 3'b 010;
parameter dataReceive	= 3'b 011;
parameter clear			= 3'b 100;	

reg [8:0]clk_count		= 0;
reg [2:0]bit_index		= 0;
reg [7:0]output_byte		= 0;
reg [2:0]fsm_state		= 0;
reg valid_data				= 0;

always @(posedge clk_in)
begin
	case(fsm_state)
	
		idle:
		begin
			valid_data	<= 1'b 0;
			clk_count	<= 0;
			bit_index	<= 0;
			
			if(serial_data_in == 0)
				fsm_state <= startBit;
			else
				fsm_state <= idle;
		end
		
		startBit:
		begin
			if(clk_count == (clk_per_bit/2))
			begin
				if(serial_data_in == 0)
				begin
					clk_count <= 0;
					fsm_state <= dataReceive;
				end
				else
					fsm_state <= idle;
			end
			else
			begin
				clk_count <= clk_count + 1;
				fsm_state <= startBit;
			end
		end
		
		dataReceive:
		begin
			if(clk_count < clk_per_bit-1)
			begin
				clk_count <= clk_count + 1;
				fsm_state <= dataReceive;
			end
			else
			begin		
				clk_count					<= 0;
				output_byte[bit_index]	<= serial_data_in;
				
				if(bit_index <= 6)
				begin
					
					bit_index <= bit_index + 1;
					fsm_state <= dataReceive;
				end
				else
				begin
					bit_index <= 0;
					fsm_state <= stopBit;
				end
			end
		end
		
		stopBit:
		begin
			if(clk_count < (clk_per_bit-1))
			begin
				clk_count <= clk_count + 1;
				fsm_state <= stopBit;
			end
			else
			begin
				valid_data <= 1'b 1;
				clk_count  <= 0;
				fsm_state  <= clear;
			end
		end
		
		clear:
		begin
			clk_count	<= 0;
			valid_data	<= 1'b 0;
			fsm_state	<= idle;
			
		end
		
		default:
			fsm_state <= idle;
		
	endcase
end

assign data_valid		= valid_data;
assign data_byte_op	= output_byte;

endmodule 