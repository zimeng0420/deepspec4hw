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
	localparam ABOVE_S3  = 3'b111;
	localparam BETWEEN_S3_S2 = 3'b011;
	localparam BETWEEN_S2_S1 = 3'b001;
	localparam BELOW_S1  = 3'b000;

	reg [2:0] current_state, next_state;
	reg [2:0] previous_state;  // Store previous water level state

	always @(posedge clk) begin
		if (reset) begin
			current_state <= BELOW_S1; // Reset to lowest level
			previous_state <= BELOW_S1;
			fr3 <= 1'b1;
			fr2 <= 1'b1;
			fr1 <= 1'b1;
			dfr <= 1'b0;
		end else begin
			current_state <= next_state;
			previous_state <= current_state;
		end
	end


	always @(*) begin
		// Default output values
		fr3 = 1'b0;
		fr2 = 1'b0;
		fr1 = 1'b0;
		dfr = 1'b0;


		// State transition logic
		case (1'b1) //using 1'b1 to trigger case statement

			1'b1 : begin
				case ( {s[3], s[2], s[1]} )  // Combine sensor inputs for state detection
					3'b111:  next_state = ABOVE_S3;
					3'b011:  next_state = BETWEEN_S3_S2;
					3'b001:  next_state = BETWEEN_S2_S1;
					3'b000:  next_state = BELOW_S1;
					default: next_state = current_state; // Shouldn't happen, but handle default
				endcase
			end

			default: next_state = current_state; // Should never reach here
		endcase


		// Output logic
		case (current_state)
			ABOVE_S3: begin
				// No flow
			end
			BETWEEN_S3_S2: begin
				fr1 = 1'b1;
			end
			BETWEEN_S2_S1: begin
				fr1 = 1'b1;
				fr2 = 1'b1;
			end
			BELOW_S1: begin
				fr1 = 1'b1;
				fr2 = 1'b1;
				fr3 = 1'b1;
			end
			default: begin  //Default outputs to be safe, shouldn't happen.
				fr1 = 1'b0;
				fr2 = 1'b0;
				fr3 = 1'b0;
			end
		endcase

		//Supplemental flow valve logic
		if (current_state > previous_state) begin
			dfr = 1'b1;  // Open supplemental valve if level increased
		end else begin
			dfr = 1'b0;
		end
	end

endmodule