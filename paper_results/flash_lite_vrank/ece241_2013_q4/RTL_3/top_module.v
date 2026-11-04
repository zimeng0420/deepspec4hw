module top_module (
	input clk,
	input reset,
	input [3:1] s,
	output reg fr3,
	output reg fr2,
	output reg fr1,
	output reg dfr
);

	reg [3:1] prev_s;
	reg [1:0] state; // 00: Below s1, 01: Between s1 & s2, 10: Between s2 & s3, 11: Above s3

	// State machine logic
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			state <= 2'b00; // Initialize to "below s1" state
			fr3 <= 1'b1;
			fr2 <= 1'b1;
			fr1 <= 1'b1;
			dfr <= 1'b0; // Initially, no additional flow
			prev_s <= 3'b000;
		end else begin
			prev_s <= s;

			// Determine the current state based on sensor inputs
			if (s[3]) begin // Above s3
				state <= 2'b11;
			end else if (s[2]) begin // Between s2 and s3
				state <= 2'b10;
			end else if (s[1]) begin // Between s1 and s2
				state <= 2'b01;
			end else begin // Below s1
				state <= 2'b00;
			end

			// Output logic based on the current state
			case (state)
				2'b11: begin // Above s3
					fr3 <= 1'b0;
					fr2 <= 1'b0;
					fr1 <= 1'b0;
					dfr <= 1'b0;
				end
				2'b10: begin // Between s2 and s3
					fr3 <= 1'b0;
					fr2 <= 1'b0;
					fr1 <= 1'b1;
					dfr <= (prev_s[2:1] == 2'b00 & s[2:1] != 2'b00); //Check if previous level was lower and now the water level is high.
				end
				2'b01: begin // Between s1 and s2
					fr3 <= 1'b0;
					fr2 <= 1'b1;
					fr1 <= 1'b1;
					dfr <= (prev_s[1] == 1'b0 & s[1] != 1'b0); // Check if previous level was lower and now the water level is high.
				end
				2'b00: begin // Below s1
					fr3 <= 1'b1;
					fr2 <= 1'b1;
					fr1 <= 1'b1;
					dfr <= 1'b0;
				end
				default: begin //Should never happen, but set defaults to safe state.
					fr3 <= 1'b1;
					fr2 <= 1'b1;
					fr1 <= 1'b1;
					dfr <= 1'b0;
				end
			endcase
		end
	end

endmodule