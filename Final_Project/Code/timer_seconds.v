
`default_nettype none

module timer_seconds #(
    parameter SECONDS_TARGET = 10 
) (
    input       i_clk,
    input       i_rst,
    input       i_start,
    output      o_done
);

    // States for the machine
    localparam STATE_IDLE  = 0;
    localparam STATE_COUNT = 1;

    // Use $clog2 to calculate the minimum number of bits needed
    // This makes the counter size flexible, too
    localparam CNT_WIDTH = (SECONDS_TARGET <= 1) ? 1 : $clog2(SECONDS_TARGET);

    reg [CNT_WIDTH-1:0] counter_s;
    reg                 state;
    reg                 o_done_reg;

    assign o_done = o_done_reg;

    always @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            // Reset all registers
            state      <= STATE_IDLE;
            counter_s  <= 0;
            o_done_reg <= 0;
        end else begin
            // Default: 'done' pulse is low unless set high
            o_done_reg <= 0; 
            
            case (state)
                
                // --- IDLE STATE ---
                // Wait here until i_start is high
                STATE_IDLE: begin
                    if (i_start) begin
                        state <= STATE_COUNT; // Move to COUNT state
                    end
                    // Keep the counter reset
                    counter_s <= 0; 
                end

                // --- COUNTING STATE ---
                // Count N-seconds
                STATE_COUNT: begin
                    // Check if we are at the *end* of the N-second period.
                    // We count from 0 to N-1 (which is N total ticks).
                    if (counter_s == SECONDS_TARGET - 1) begin
                        state      <= STATE_IDLE; // Go back to idle
                        o_done_reg <= 1;         // Pulse 'done' high
                        counter_s  <= 0;         // Reset counter
                    end else begin
                        counter_s <= counter_s + 1; // Keep counting
                    end
                end
                
                // Default case for safety
                default: begin
                    state <= STATE_IDLE;
                    counter_s <= 0;
                end
            endcase
        end
    end
    
endmodule

`default_nettype wire