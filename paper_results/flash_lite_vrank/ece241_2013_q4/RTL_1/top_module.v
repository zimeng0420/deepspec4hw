module top_module (
	input clk,
	input reset,
	input [3:1] s,
	output reg fr3,
	output reg fr2,
	output reg fr1,
	output reg dfr
);

	// State Definitions
	localparam S_ABOVE_S3 = 3'b000;
	localparam S_BETWEEN_S3_S2 = 3'b001;
	localparam S_BETWEEN_S2_S1 = 3'b010;
	localparam S_BELOW_S1 = 3'b011;

	// State Register
	reg [2:0] state, next_state;
	reg [2:0] prev_state; // Store the previous state

	// FSM Logic
	always @(posedge clk) begin
		if (reset) begin
			state <= S_BELOW_S1; // Reset to below s1 state
			prev_state <= S_BELOW_S1;
		end else begin
			state <= next_state;
			prev_state <= state;
		end
	end

	// Next State Logic
	always @(*) begin
		case (1'b1) // Using 1'b1 to force a case always match
			1'b1: begin // Default Case
				if (s[3]) begin
					next_state = S_ABOVE_S3;
				end else if (s[2]) begin
					next_state = S_BETWEEN_S3_S2;
				end else if (s[1]) begin
					next_state = S_BETWEEN_S2_S1;
				end else begin
					next_state = S_BELOW_S1;
				end
			end
		endcase
	end

	// Output Logic
	always @(*) begin
		case (state)
			S_ABOVE_S3: begin
				fr3 = 1'b0;
				fr2 = 1'b0;
				fr1 = 1'b0;
				dfr = 1'b0;
			end
			S_BETWEEN_S3_S2: begin
				fr3 = 1'b0;
				fr2 = 1'b0;
				fr1 = 1'b1;
				dfr = (prev_state < state); // Open dfr if level increased from below
			end
			S_BETWEEN_S2_S1: begin
				fr3 = 1'b0;
				fr2 = 1'b1;
				fr1 = 1'b1;
				dfr = (prev_state < state); // Open dfr if level increased from below
			end
			S_BELOW_S1: begin
				fr3 = 1'b1;
				fr2 = 1'b1;
				fr1 = 1'b1;
				dfr = (prev_state < state); //Open dfr if level increased from below
			end
			default: begin // Should never happen, but good practice
				fr3 = 1'b1;
				fr2 = 1'b1;
				fr1 = 1'b1;
				dfr = 1'b0;
			end
		endcase
	end
endmodule