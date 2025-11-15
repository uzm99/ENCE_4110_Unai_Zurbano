
`default_nettype none

module display_controller(
	input tick,
	input [7:0] char2seg,
	input i_led_dim,
	input i_entering_password,
	input i_intruder,	
	input i_presence,
	input i_locked,
	input i_fire,
	input i_wrong_password,
	input [9:0] i_fire_pattern,
	input [9:0] i_intruder_pattern,
	input [9:0] i_wrong_pattern,
	input i_locking,
	input i_temp_celsius,
	output reg [7:0] HEX0,
	output reg [7:0] HEX1,
	output reg [7:0] HEX2,
	output reg [7:0] HEX3,
	output reg [7:0] HEX4,
	output reg [7:0] HEX5,
	output reg [9:0] LEDR
);

	
	// 7-segment displays and LEDR activation
	// **************************************************
	
	always @(*) begin
	
		HEX0 = 8'hFF;
		HEX1 = 8'hFF;
		HEX2 = 8'hFF;
		HEX3 = 8'hFF;
		HEX4 = 8'hFF;
		HEX5 = 8'hFF;
		
		LEDR = 10'b0;
		
				
		if (i_fire) begin
			
			LEDR = i_fire_pattern;
			
			HEX0 = 8'hFF; 		  //-
			HEX1 = 8'hFF; 	     //-
			HEX2 = 8'b10000110; //e
			HEX3 = 8'b10101111; //r
			HEX4 = 8'b11101111; //i
			HEX5 = 8'b10001110; //F
			
		end
		
		else
		if (i_locking) begin
		
			if (tick) begin
				LEDR = 10'd0;
				HEX0 = 8'b10100001; //d
				HEX1 = 8'b10000110; //e
				HEX2 = 8'b10001010; //k
				HEX3 = 8'b10100111; //c
				HEX4 = 8'b10100011; //o
				HEX5 = 8'b11000111; //L
			end else begin
				LEDR = 10'b1111111111;
				HEX0 = 8'hFF;
				HEX1 = 8'hFF;
				HEX2 = 8'hFF;
				HEX3 = 8'hFF;
				HEX4 = 8'hFF;
				HEX5 = 8'hFF;
			end
			
		end
		
		else
		if (i_entering_password) begin
		
			HEX0 = char2seg;
			HEX1 = 8'hFF;
			HEX2 = 8'hFF;
			HEX3 = 8'hFF;
			HEX4 = 8'hFF;
			HEX5 = 8'hFF;
			
		end
		
		else 
		if (i_intruder) begin
		
			LEDR = i_intruder_pattern;
		
			HEX0 = 8'b10101111; //r
			HEX1 = 8'b10000110; //e
			HEX2 = 8'b10000011; //b
			HEX3 = 8'b10000011; //b
			HEX4 = 8'b10100011; //o
			HEX5 = 8'b10101111; //r
			
		
		end
		else
		
		if (i_wrong_password) begin
		
			LEDR = i_wrong_pattern;
		
			HEX0 = 8'hFF; 		  //-
			HEX1 = 8'hFF; 		  //-
			HEX2 = 8'b10000110; //e
			HEX3 = 8'b10001100; //p
			HEX4 = 8'b10100011; //o
			HEX5 = 8'b10101011; //n
			
		end
		
		else
		
		if (i_locked) begin
		
			HEX0 = 8'b10100001; //d
			HEX1 = 8'b10000110; //e
			HEX2 = 8'b10001010; //k
			HEX3 = 8'b10100111; //c
			HEX4 = 8'b10100011; //o
			HEX5 = 8'b11000111; //L
			
		end
		
		
		else 
		
		if (i_temp_celsius) begin
		
			HEX0 = 8'b10001110; //F
			HEX1 = 8'hFF; //
			HEX2 = 8'hFF; //
			HEX3 = 8'b10110111; //=
			HEX4 = 8'b10011100; //º
			HEX5 = 8'b10000111; //t
			
		end
		
		else begin
		
			HEX0 = 8'b11000110; //C
			HEX1 = 8'hFF; //
			HEX2 = 8'hFF; //
			HEX3 = 8'b10110111; //=
			HEX4 = 8'b10011100; //º
			HEX5 = 8'b10000111; //t
		
		end
		
		if (i_presence & !i_intruder) LEDR = {10{i_led_dim}};

		
	end

endmodule

`default_nettype wire