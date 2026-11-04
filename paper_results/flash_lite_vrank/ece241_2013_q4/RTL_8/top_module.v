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
	localparam S_ABOVE_S3 = 3'b000;
	localparam S_BETWEEN_S3_S2 = 3'b001;
	localparam S_BETWEEN_S2_S1 = 3'b010;
	localparam S_BELOW_S1 = 3'b011;

	// State register
	reg [2:0] state, next_state;

	// Previous sensor value
	reg [3:1] prev_s;

	// Nominal flow rate assignments based on state
	always @(*) begin
		case (state)
			S_ABOVE_S3: begin
				fr3 = 1'b0;
				fr2 = 1'b0;
				fr1 = 1'b0;
			end
			S_BETWEEN_S3_S2: begin
				fr3 = 1'b0;
				fr2 = 1'b0;
				fr1 = 1'b1;
			end
			S_BETWEEN_S2_S1: begin
				fr3 = 1'b0;
				fr2 = 1'b1;
				fr1 = 1'b1;
			end
			S_BELOW_S1: begin
				fr3 = 1'b1;
				fr2 = 1'b1;
				fr1 = 1'b1;
			end
			default: begin
				fr3 = 1'b1;
				fr2 = 1'b1;
				fr1 = 1'b1;
			end
		endcase
	end

	// Logic for supplemental flow
	always @(*) begin
		dfr = 1'b0; // Default: supplemental flow off

		if (state == S_BETWEEN_S3_S2 && (prev_s == 3'b000 || prev_s == 3'b001 || prev_s == 3'b000)) begin
			dfr = 1'b1;
		end
		else if (state == S_BETWEEN_S2_S1 && (prev_s == 3'b000 || prev_s == 3'b001 || prev_s == 3'b010)) begin
			dfr = 1'b1;
		end
		else if (state == S_BELOW_S1 && (prev_s == 3'b000 || prev_s == 3'b001 || prev_s == 3'b010 || prev_s == 3'b011)) begin
		    dfr = 1'b1;
		end
	end


	// State transition logic
	always @(*) begin
		next_state = state;
		case (1'b1) // Use a default case to cover all scenarios
			(s == 3'b111): next_state = S_ABOVE_S3;
			(s == 3'b011): next_state = S_BETWEEN_S3_S2;
			(s == 3'b010): next_state = S_BETWEEN_S2_S1;
			(s == 3'b000): next_state = S_BELOW_S1;
			default: next_state = state;
		endcase
	end

	// State register update
	always @(posedge clk) begin
		if (reset) begin
			state <= S_BELOW_S1;
			prev_s <= 3'b000;
		end else begin
			state <= next_state;
			prev_s <= s;
		end
	end

endmodule