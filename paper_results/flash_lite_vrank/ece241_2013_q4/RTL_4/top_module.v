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
	localparam STATE_ABOVE_S3 = 2'b00;
	localparam STATE_BETWEEN_S3_S2 = 2'b01;
	localparam STATE_BETWEEN_S2_S1 = 2'b10;
	localparam STATE_BELOW_S1 = 2'b11;

	reg [1:0] current_state, next_state;
	reg [1:0] previous_state;

	// Flow rate outputs
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			fr3 <= 1'b1;
			fr2 <= 1'b1;
			fr1 <= 1'b1;
			dfr <= 1'b0;  // Initially, no extra flow
			current_state <= STATE_BELOW_S1;
			previous_state <= STATE_BELOW_S1;
		end else begin
			fr3 <= (current_state == STATE_BELOW_S1) ? 1'b1 : 1'b0;
			fr2 <= (current_state == STATE_BELOW_S1 || current_state == STATE_BETWEEN_S2_S1) ? 1'b1 : 1'b0;
			fr1 <= (current_state == STATE_BETWEEN_S3_S2 || current_state == STATE_BETWEEN_S2_S1 || current_state == STATE_BELOW_S1) ? 1'b1 : 1'b0;
			dfr <= (previous_state < current_state) ? 1'b1 : 1'b0; // Increase flow if level increased
			previous_state <= current_state;
			current_state <= next_state;
		end
	end

	// State transition logic
	always @(*) begin
		casez (s)
			3'b111:  next_state = STATE_ABOVE_S3;
			3'b011:  next_state = STATE_BETWEEN_S3_S2;
			3'b001:  next_state = STATE_BETWEEN_S2_S1;
			3'b000:  next_state = STATE_BELOW_S1;
			default: next_state = current_state; // Handle invalid sensor inputs
		endcase
	end

endmodule