module top_module (
	input clk,
	input reset,
	input [3:1] s,
	output reg fr3,
	output reg fr2,
	output reg fr1,
	output reg dfr
);

	// State definition
	localparam S_ABOVE_S3 = 3'b111;
	localparam S_BETWEEN_S3_S2 = 3'b110;
	localparam S_BETWEEN_S2_S1 = 3'b100;
	localparam S_BELOW_S1 = 3'b000;

	reg [2:0] current_state;
	reg [2:0] prev_state;

	always @(posedge clk) begin
		if (reset) begin
			current_state <= S_BELOW_S1;
			prev_state <= S_BELOW_S1;
		end else begin
			// Determine current state based on sensor inputs
			if (s[3]) begin
				current_state <= S_ABOVE_S3;
			end else if (s[2]) begin
				current_state <= S_BETWEEN_S3_S2;
			end else if (s[1]) begin
				current_state <= S_BETWEEN_S2_S1;
			end else begin
				current_state <= S_BELOW_S1;
			end

			prev_state <= current_state; // Store the previous state
		end
	end

	always @(*) begin
		// Default values
		fr3 = 1'b0;
		fr2 = 1'b0;
		fr1 = 1'b0;
		dfr = 1'b0;

		case (current_state)
			S_ABOVE_S3: begin
				// No flow
			end
			S_BETWEEN_S3_S2: begin
				fr1 = 1'b1;
			end
			S_BETWEEN_S2_S1: begin
				fr1 = 1'b1;
				fr2 = 1'b1;
			end
			S_BELOW_S1: begin
				fr1 = 1'b1;
				fr2 = 1'b1;
				fr3 = 1'b1;
			end
			default: begin
				// Should not reach here, but handle it for completeness
				fr1 = 1'b1;
				fr2 = 1'b1;
				fr3 = 1'b1;
			end
		endcase

		// Check for increasing water level and open supplemental flow valve
		if (current_state > prev_state) begin
			dfr = 1'b1;
		end else begin
			dfr = 1'b0;
		end
	end
endmodule