module pongTop(clk_in,Rst,startGame,i_serial,paddleup2,paddledwn2,rgb,HSync,VSync,seg1,seg2);
input clk_in,Rst,startGame,i_serial,paddleup2,paddledwn2;
output HSync,VSync;
output [6:0]seg1,seg2;
output [2:0]rgb;

wire displayBall,displayPaddle1,displayPaddle2;
wire dataValid, dataop;
wire pu2,pd2;
wire GameStart;
wire [11:0]H_pos,V_pos;
wire [2:0]paddleY1, paddleY2;
wire GAMErunning;
wire [5:0]ballX,ballY;
wire [2:0]score_p1,score_p2;
wire [6:0]seg;

uart_receiver (.clk_in(clk_in),.serial_data_in(i_serial),.data_valid(dataValid),.data_byte_op(dataop));
debounce_pb (.in_clk(clk_in), .pb_in(startGame), .pb_out(GameStart));
debounce_pb (.in_clk(clk_in), .pb_in(paddleup2), .pb_out(pu2));
debounce_pb (.in_clk(clk_in), .pb_in(paddledwn2), .pb_out(pd2));
vga_controller (.clk(clk_in),.rst(Rst),.Hsync(HSync),.Vsync(VSync),.h_pos(H_pos),.v_pos(V_pos));
paddle1_ctrl p1(.in_clk(clk_in),.reset(Rst),.y_paddle(paddleY1),.uart_o(dataop),.dv(dataValid),.dispPaddle1(displayPaddle1),.h_pos(H_pos),.v_pos(V_pos));
paddle2_ctrl p2(.in_clk(clk_in),.reset(Rst),.push1(pu2),.push2(pd2),.y_paddle(paddleY2),.dispPaddle2(displayPaddle2),.h_pos(H_pos),.v_pos(V_pos));
ball_ctrl (.clk_in(clk_in),.reset(Rst),.gameRunning(GAMErunning),.h_pos(H_Pos),.v_pos(H_pos),.disp_ball(displayBall),.ball_x(ballX),.ball_y(ballY));
gameCtrl_FSM (.clk_in(clk_in),.reset(Rst),.start(GameStart),.x_ball(ballX),.y_ball(ballY),.y_paddle1(paddleY1),.y_paddle2(paddleY2),.game_active(GAMErunning),.P1score(score_p1),.P2score(score_p2));
displayScore_SSD (.i_clk(clk_in),.score(score_p1),.segment(seg1));
displayScore_SSD (.i_clk(clk_in),.score(score_p2),.segment(seg2));

assign draw = displayBall | displayPaddle1 | displayPaddle2;
assign rgb = draw ? 3'b111 : 3'b000;

endmodule 