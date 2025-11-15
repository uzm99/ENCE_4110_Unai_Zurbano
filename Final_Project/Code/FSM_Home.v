
`default_nettype none

module FSM_Home #
(
	parameter N = 4
)
(
	input clk,
	input reset,
	input i_rst_wrong,
	input i_fire,
	input i_presence,
	input i_data_ready,
	input [7:0] i_char,
	input i_button_lock,
	input i_lock,
	
	output reg o_intruder,
	output reg o_locked,
	output reg o_fire_alert,
	output reg o_entering_password,
	output reg o_wrong_password,
	output reg o_start_counter_2s,
	output reg o_start_counter_5s,
	output reg o_locking,
	output reg [7:0] o_state
);

	reg [7:0] state, next_state;
	
	//Numbers
	localparam [7:0] w_1 = 8'd49, w_2 = 8'd50, w_3 = 8'd51, w_4 = 8'd52;

	// States
	localparam [7:0] IDLE = 8'd0,	Intruder = 8'd1,
							PW_unlock_1 = 8'd2, PW_unlock_2 = 8'd3, PW_unlock_3 = 8'd4, PW_unlock = 8'd5, PW_unlock_wrong = 8'd6,
							Fire = 8'd7, Timer_lock = 8'd8, PW_lock = 8'd9;

	// 1. State Register (sequential)
	always @(posedge clk) begin
		if(reset)
			state <= IDLE;
		else
			state <= next_state;
	end
	
	// 2. Next-State Logic (combinational)
	always @(*) begin
		
		next_state = state; // default: hold state
	
		case(state)
		
			IDLE: 
				begin		
					next_state = (i_fire) ? Fire : (i_button_lock) ? Timer_lock : IDLE;
				end
	
			Timer_lock:
				begin
					next_state = (i_lock) ? PW_lock : Timer_lock;
				end
				
			PW_lock:
				begin
					next_state = (i_fire) ? Fire : (i_presence) ? Intruder : (i_data_ready & i_char == w_1) ? PW_unlock_1 :
										(i_data_ready) ? PW_unlock_wrong : PW_lock;
				end
				
			PW_unlock_1:
				begin
					next_state = (i_fire) ? Fire : (i_data_ready & i_char == w_2) ? PW_unlock_2 :
										(i_data_ready) ? PW_unlock_wrong : PW_unlock_1;
				end
				
			PW_unlock_2:
				begin
					next_state = (i_fire) ? Fire : (i_data_ready & i_char == w_3) ? PW_unlock_3 :
										(i_data_ready) ? PW_unlock_wrong : PW_unlock_2;
				end
			
			PW_unlock_3:
				begin
					next_state = (i_fire) ? Fire : (i_data_ready & i_char == w_4) ? IDLE :
										(i_data_ready) ? PW_unlock_wrong : PW_unlock_3;
				end
				
			PW_unlock_wrong:
				begin
					next_state = (i_rst_wrong) ? PW_lock : PW_unlock_wrong;
				end
				
			Intruder:
				begin
					next_state = (i_data_ready & i_char == w_1) ? PW_unlock_1 :
										(i_data_ready) ? PW_unlock_wrong : Intruder;
				end
			
			Fire:
				begin
					next_state = (!i_fire) ? PW_lock : Fire;
				end
				
			default: ;// None
		
		endcase
	end
	
	// 3. Output Logic (combinational)
	
	always @(*) begin
	
		o_state = state;
	
		// default all signals are zero
		o_intruder 	= 1'b0;
		o_locked		= 1'b0;
		o_fire_alert		= 1'b0;
		o_entering_password	= 1'b0;
		o_wrong_password		= 1'b0;
		o_start_counter_2s 	= 1'b0;
		o_start_counter_5s 	= 1'b0;
		o_locking 	= 1'b0;
	
		case(state)
		
			IDLE: 
				begin		
					// do nothing
				end
	
			Timer_lock:
				begin
					o_start_counter_5s 	= 1'b1;
					o_locking 	= 1'b1;
				end
			
			PW_lock:
				begin
					o_locked		= 1'b1;
				end
				
			PW_unlock_1:
				begin
					o_entering_password	= 1'b1;
					o_locked		= 1'b1;
				end
				
			PW_unlock_2:
				begin
					o_entering_password	= 1'b1;
					o_locked		= 1'b1;
				end
			
			PW_unlock_3:
				begin
					o_entering_password	= 1'b1;
					o_locked		= 1'b1;
				end
				
			PW_unlock_wrong:
				begin
					o_wrong_password		= 1'b1;
					o_locked		= 1'b1;
					o_start_counter_2s 	= 1'b1;
				end
				
			Intruder:
				begin
					o_intruder	= 1'b1;
					o_locked		= 1'b1;
				end
			
			Fire:
				begin
					o_fire_alert	= 1'b1;
					o_locked		= 1'b1;
				end
		
		endcase
	end

endmodule

`default_nettype wire
