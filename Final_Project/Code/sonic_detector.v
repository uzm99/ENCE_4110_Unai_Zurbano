
`default_nettype none

module sonic_detector (
    input   clk,      // 50 MHz - 20 ns
	 input rst,
    output  reg trig,
    input   echo,
    output reg  [32:0] distance,
	 output o_presence
);

    // timing constants
    localparam integer PULSE_WIDTH = 500;        // 10 us
    localparam integer PERIOD      = 3000500;    // 60 ms (approx)

    // Counters
    reg [21:0] trig_counter = 0;
    reg [31:0] echo_counter = 0;
    //reg [31:0] echo_time    = 0;
	 
	 
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            trig_counter <= 0;
            trig    <= 0;
        end else begin
            // restart counter every 60 ms
            if (trig_counter >= PERIOD) begin
                trig_counter <= 0;
            end else begin
                trig_counter <= trig_counter + 1;
            end

            // pulse high for first 10 us
            if (trig_counter < PULSE_WIDTH)
                trig <= 1'b1;
            else
                trig <= 1'b0;
        end
    end
	 
	 // --- Sync Echo Signal ---
		reg  echo_sync_0;
		reg  echo_sync_1;
		wire echo_safe;

		always @(posedge clk or posedge rst) begin
			 if (rst) begin
				  echo_sync_0 <= 0;
				  echo_sync_1 <= 0;
			 end else begin
				  echo_sync_0 <= echo; // First flop
				  echo_sync_1 <= echo_sync_0; // Second flop
			 end
		end
		assign echo_safe = echo_sync_1; // Use this synchronized signal
	 
	 // Echo measurement
	// --- NEW: Edge Detector ---
	// We need to know the *previous* value of echo_safe
	reg echo_safe_prev;
	always @(posedge clk or posedge rst) begin
		 if (rst)
			  echo_safe_prev <= 0;
		 else
			  echo_safe_prev <= echo_safe;
	end

	// These wires detect a single-cycle pulse on an edge
	wire rising_edge  = (echo_safe == 1'b1) && (echo_safe_prev == 1'b0);
	wire falling_edge = (echo_safe == 1'b0) && (echo_safe_prev == 1'b1);


	// --- NEW: Echo FSM (Replaces your old echo 'always' block) ---
	reg [1:0] echo_state = 0;

	// Re-use your existing registers
	// reg [31:0] echo_counter = 0; // Already defined
	// reg [32:0] distance = 0;     // Already defined (output)

	always @(posedge clk or posedge rst) begin
		 if (rst) begin
			  echo_state <= 0;
			  echo_counter <= 0;
			  distance <= 0;
		 end else begin
			  
			  case (echo_state)
					
					// State 0: IDLE
					// Wait for the pulse to START
					0: begin
						 echo_counter <= 0; // Hold counter at 0
						 if (rising_edge)
							  echo_state <= 1; // Move to COUNTING state
					end
					
					// State 1: COUNTING
					// Count clock cycles while the pulse is high
					1: begin
						 if (falling_edge)
							  echo_state <= 2; // Move to CALCULATE state
						 else
							  echo_counter <= echo_counter + 1;
					end

					// State 2: CALCULATE
					// Pulse has ended. Do the math ONCE.
					2: begin
						 distance <= echo_counter / 2900;
						 echo_state <= 0; // Go back to IDLE
					end
					
					default:
						 echo_state <= 0;
						 
			  endcase
		 end
	end

	//Presence detection
	assign o_presence  = (distance < 8'd13);

endmodule

`default_nettype wire