module gameCtrl_FSM(clk_in,reset,start,x_ball,y_ball,y_paddle1,y_paddle2,game_active,P1score,P2score);
input clk_in,start,reset;
input [11:0]x_ball,y_ball,y_paddle1,y_paddle2;
output game_active;
output reg P1score, P2score;


parameter screenWidth  = 640;
parameter screenHeight = 480;
parameter max_score = 5;
parameter paddleHeight = 6; 

parameter idle    = 3'b000;
parameter gameRunning = 3'b001;
parameter scoreP1 = 3'b010;
parameter scoreP2 = 3'b011;
parameter clear = 3'b100;

reg fsm = idle;


always @(posedge clk_in)
  begin
	 if(!reset)
		fsm <= idle;
		
    case (fsm)
    idle :
    begin
		P1score <=0;
		P2score <=0;
      if (start == 1'b1)
        fsm <= gameRunning;
    end


    gameRunning :
    begin
      if (x_ball == 0 && (y_ball < y_paddle1 ||  y_ball > y_paddle1 + paddleHeight))
        fsm <= scoreP2;

      else if (x_ball == 0 && (y_ball < y_paddle2 ||  y_ball > y_paddle2 + paddleHeight))
        fsm <= scoreP1;
    end

    scoreP1 :
    begin
      if (P1score < max_score)
        P1score <= P1score + 1;
      else
      begin
        P1score <= 0;
        fsm <= clear;
      end
    end

    scoreP2 :
    begin
      if (P2score < max_score)
        P2score <= P2score + 1;
      else
      begin
        P2score <= 0;
        fsm <= clear;
      end
    end

    clear :
      fsm <= idle;
    endcase
  end

assign game_active = (fsm == gameRunning) ? 1'b1 : 1'b0;
endmodule 