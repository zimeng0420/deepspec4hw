module top_module (
	input clk,
	input reset,
	input [3:1] s,
	output reg fr3,
	output reg fr2,
	output reg fr1,
	output reg dfr
);

	reg [3:1] current_level, prev_level;

	// State Definitions (same as sensor assertions)
	localparam ABOVE_S3 = 4'b1111; // s[3:1] = 111
	localparam BETWEEN_S3_S2 = 4'b0111; // s[3:1] = 011
	localparam BETWEEN_S2_S1 = 4'b0011; // s[3:1] = 001
	localparam BELOW_S1 = 4'b0001; // s[3:1] = 000


	always @(posedge clk or posedge reset) begin
		if (reset) begin
			current_level <= BELOW_S1;
			prev_level <= BELOW_S1;
			fr3 <= 1'b1;
			fr2 <= 1'b1;
			fr1 <= 1'b1;
			dfr <= 1'b0;
		end else begin
			// Determine current level based on sensor inputs
			if (s[3]) begin
				current_level <= ABOVE_S3;
			end else if (s[2]) begin
				current_level <= BETWEEN_S3_S2;
			end else if (s[1]) begin
				current_level <= BETWEEN_S2_S1;
			end else begin
				current_level <= BELOW_S1;
			end

			// Flow rate logic
			case (current_level)
				ABOVE_S3: begin
					fr3 <= 1'b0;
					fr2 <= 1'b0;
					fr1 <= 1'b0;
					dfr <= 1'b0;
				end
				BETWEEN_S3_S2: begin
					fr3 <= 1'b0;
					fr2 <= 1'b0;
					fr1 <= 1'b1;
					dfr <= (prev_level < current_level); //increase flow if level is increasing
				end
				BETWEEN_S2_S1: begin
					fr3 <= 1'b0;
					fr2 <= 1'b1;
					fr1 <= 1'b1;
					dfr <= (prev_level < current_level); //increase flow if level is increasing
				end
				BELOW_S1: begin
					fr3 <= 1'b1;
					fr2 <= 1'b1;
					fr1 <= 1'b1;
					dfr <= 1'b0;
				end
				default: begin
					fr3 <= 1'b0;
					fr2 <= 1'b0;
					fr1 <= 1'b0;
					dfr <= 1'b0;
				end
			endcase

			// Update previous level
			prev_level <= current_level;
		end
	end

endmodule