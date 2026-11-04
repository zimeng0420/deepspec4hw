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
	localparam STATE_ABOVE_S3 = 3'b000;
	localparam STATE_BETWEEN_S3_S2 = 3'b001;
	localparam STATE_BETWEEN_S2_S1 = 3'b010;
	localparam STATE_BELOW_S1 = 3'b011;

	reg [2:0] current_state, next_state;
	reg [2:0] prev_state; // Store the previous state

	// State Transition Logic
	always @(*) begin
		next_state = current_state;
		case (current_state)
			STATE_ABOVE_S3: begin
				if (!s[3]) next_state = STATE_BETWEEN_S3_S2;
			end
			STATE_BETWEEN_S3_S2: begin
				if (!s[2]) next_state = STATE_BETWEEN_S2_S1;
			end
			STATE_BETWEEN_S2_S1: begin
				if (!s[1]) next_state = STATE_BELOW_S1;
			end
			STATE_BELOW_S1: begin
				if (s[1]) next_state = STATE_BETWEEN_S2_S1;
			end
			default: next_state = STATE_BELOW_S1; // Default to below S1 if no state matches
		endcase
	end


	// Output Logic
	always @(*) begin
		fr3 = 1'b0;
		fr2 = 1'b0;
		fr1 = 1'b0;
		dfr = 1'b0;

		case (current_state)
			STATE_ABOVE_S3: begin
				// Do nothing. Outputs are already initialized to 0
			end
			STATE_BETWEEN_S3_S2: begin
				fr1 = 1'b1;
			end
			STATE_BETWEEN_S2_S1: begin
				fr1 = 1'b1;
				fr2 = 1'b1;
			end
			STATE_BELOW_S1: begin
				fr1 = 1'b1;
				fr2 = 1'b1;
				fr3 = 1'b1;
			end
			default: begin // Default state (shouldn't happen if logic is correct, but good for safety)
				fr1 = 1'b1;
				fr2 = 1'b1;
				fr3 = 1'b1;
			end
		endcase

		//Supplemental flow valve logic based on level change
        if (next_state > current_state) begin // Check for level increase (previous level was lower)
            dfr = 1'b1;
        end
		
	end

	// State Update (Synchronous)
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			current_state <= STATE_BELOW_S1; // Reset to state equivalent to water low
			prev_state <= STATE_BELOW_S1;
			fr3 <= 1'b1;
			fr2 <= 1'b1;
			fr1 <= 1'b1;
			dfr <= 1'b0;
		end
		else begin
			current_state <= next_state;
			prev_state <= current_state;
		end
	end

endmodule