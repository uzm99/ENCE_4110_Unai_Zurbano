module shownumber(
	input clk,
	input rst,
	output [7:0] HEX0,
	output [7:0] HEX1,
	output [7:0] HEX2,
	output [7:0] HEX3,
	output [7:0] HEX4,
	output [7:0] HEX5,
	input [32:0] num
);

// Registers for BCD digits
reg [3:0] d0, d1, d2, d3, d4, d5;

// This clocked block performs the division/modulo.
// It's still a lot of logic, but the output is now 
// registered and stable.
always @(posedge clk) begin
    if (rst) begin
        d0 <= 0;
        d1 <= 0;
        d2 <= 0;
        d3 <= 0;
        d4 <= 0;
        d5 <= 0;
    end else begin
        // These calculations are now synchronous
        d0 <= (num) % 10;
        d1 <= (num / 10) % 10 ;
        d2 <= (num / 100) % 10;
        d3 <= (num / 1000) % 10;
        d4 <= (num / 10000) % 10;
        d5 <= (num / 100000) % 10;
    end
end

// Your decoders are purely combinatorial, which is correct.
// They are now driven by the STABLE d0-d5 registers.
seg7Decoder seg0( .i_bin(d0), .o_HEX(HEX0) );
seg7Decoder seg1( .i_bin(d1), .o_HEX(HEX1) );
seg7Decoder seg2( .i_bin(d2), .o_HEX(HEX2) );
seg7Decoder seg3( .i_bin(d3), .o_HEX(HEX3) );
seg7Decoder seg4( .i_bin(d4), .o_HEX(HEX4) );
seg7Decoder seg5( .i_bin(d5), .o_HEX(HEX5) );
    
endmodule