module top_module (
	input clk,
	input reset,
	input [3:1] s,
	output reg fr3,
	output reg fr2,
	output reg fr1,
	output reg dfr
);

	// Define states using parameters for readability and maintainability
	parameter ABOVE_S3 = 3'b111; // s[3:1] asserted
	parameter BETWEEN_S3_S2 = 3'b011; // s[2:1] asserted
	parameter BETWEEN_S2_S1 = 3'b001; // s[1] asserted
	parameter BELOW_S1 = 3'b000; // No sensors asserted

	reg [2:0] current_state;
	reg [2:0] previous_state; // Store previous state for supplemental flow determination

	always @(posedge clk) begin
		if (reset) begin
			current_state <= BELOW_S1;  // Reset to low water level
			previous_state <= BELOW_S1;
			fr3 <= 1'b1;
			fr2 <= 1'b1;
			fr1 <= 1'b1;
			dfr <= 1'b0; // Initialize dfr to zero on reset to avoid unexpected behavior
		end else begin
			previous_state <= current_state; // Store the previous state

			// Determine the current state based on sensor inputs
			if (s[3]) begin
				current_state <= ABOVE_S3;
			end else if (s[2]) begin
				current_state <= BETWEEN_S3_S2;
			end else if (s[1]) begin
				current_state <= BETWEEN_S2_S1;
			end else begin
				current_state <= BELOW_S1;
			end


			// Control flow rates based on the current state
			case (current_state)
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
					dfr <= (previous_state < current_state) ; //Supplemental flow needed if previous was lower
				end
				BETWEEN_S2_S1: begin
					fr3 <= 1'b0;
					fr2 <= 1'b1;
					fr1 <= 1'b1;
					dfr <= (previous_state < current_state) ; //Supplemental flow needed if previous was lower
				end
				BELOW_S1: begin
					fr3 <= 1'b1;
					fr2 <= 1'b1;
					fr1 <= 1'b1;
					dfr <= (previous_state < current_state); //Supplemental flow needed if previous was lower
				end
				default: begin // Should not happen, but good practice to handle unexpected states
					fr3 <= 1'b0;
					fr2 <= 1'b0;
					fr1 <= 1'b0;
					dfr <= 1'b0;
				end
			endcase
		end
	end
endmodule