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
	reg [2:0] previous_state;

	// State Transition Logic
	always @(*) begin
		case (current_state)
			STATE_ABOVE_S3: begin
				if (!s[3]) next_state = STATE_BETWEEN_S3_S2;
				else next_state = STATE_ABOVE_S3;
			end
			STATE_BETWEEN_S3_S2: begin
				if (!s[2]) next_state = STATE_BETWEEN_S2_S1;
				else if (s[3]) next_state = STATE_ABOVE_S3;
				else next_state = STATE_BETWEEN_S3_S2;
			end
			STATE_BETWEEN_S2_S1: begin
				if (!s[1]) next_state = STATE_BELOW_S1;
				else if (s[2]) next_state = STATE_BETWEEN_S3_S2;
				else next_state = STATE_BETWEEN_S2_S1;
			end
			STATE_BELOW_S1: begin
				if (s[1]) next_state = STATE_BETWEEN_S2_S1;
				else next_state = STATE_BELOW_S1;
			end
			default: next_state = STATE_BELOW_S1; // Default to below S1
		endcase
	end

	// Output Logic
	always @(*) begin
		case (current_state)
			STATE_ABOVE_S3: begin
				fr3 = 0;
				fr2 = 0;
				fr1 = 0;
				dfr = 0;
			end
			STATE_BETWEEN_S3_S2: begin
				fr3 = 0;
				fr2 = 0;
				fr1 = 1;
				dfr = (previous_state == STATE_BELOW_S1 || previous_state == STATE_BETWEEN_S2_S1) ? 1 : 0;
			end
			STATE_BETWEEN_S2_S1: begin
				fr3 = 0;
				fr2 = 1;
				fr1 = 1;
				dfr = (previous_state == STATE_BELOW_S1) ? 1 : 0;
			end
			STATE_BELOW_S1: begin
				fr3 = 1;
				fr2 = 1;
				fr1 = 1;
				dfr = 0;
			end
			default: begin // Default to below S1
				fr3 = 1;
				fr2 = 1;
				fr1 = 1;
				dfr = 0;
			end
		endcase
	end

	// State Update and Previous State Update
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			current_state <= STATE_BELOW_S1;
			previous_state <= STATE_BELOW_S1;
		end else begin
			previous_state <= current_state;
			current_state <= next_state;
		end
	end

endmodule