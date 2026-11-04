module top_module (
	input clk,
	input reset,
	input [3:1] s,
	output reg fr3,
	output reg fr2,
	output reg fr1,
	output reg dfr
);

	parameter S_ABOVE = 3'b111;
	parameter S_BETWEEN_3_2 = 3'b011;
	parameter S_BETWEEN_2_1 = 3'b001;
	parameter S_BELOW = 3'b000;


	reg [2:0] current_level, previous_level;

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			current_level <= S_BELOW;
			previous_level <= S_BELOW;
			fr3 <= 1'b1;
			fr2 <= 1'b1;
			fr1 <= 1'b1;
			dfr <= 1'b0;
		end else begin
			// Determine current level based on sensor inputs
			if (s == 3'b111) begin
				current_level <= S_ABOVE;
			end else if (s == 3'b011) begin
				current_level <= S_BETWEEN_3_2;
			end else if (s == 3'b001) begin
				current_level <= S_BETWEEN_2_1;
			end else begin
				current_level <= S_BELOW;
			end

			// Update outputs based on current level and previous level
			case (current_level)
				S_ABOVE: begin
					fr3 <= 1'b0;
					fr2 <= 1'b0;
					fr1 <= 1'b0;
					dfr <= 1'b0;
				end
				S_BETWEEN_3_2: begin
					fr3 <= 1'b0;
					fr2 <= 1'b0;
					fr1 <= 1'b1;
					dfr <= (previous_level < current_level) ? 1'b1 : 1'b0;
				end
				S_BETWEEN_2_1: begin
					fr3 <= 1'b0;
					fr2 <= 1'b1;
					fr1 <= 1'b1;
					dfr <= (previous_level < current_level) ? 1'b1 : 1'b0;
				end
				S_BELOW: begin
					fr3 <= 1'b1;
					fr2 <= 1'b1;
					fr1 <= 1'b1;
					dfr <= 1'b0; //Supplemental flow valve is not controlled, all is on
				end
				default: begin
					fr3 <= 1'b0;
					fr2 <= 1'b0;
					fr1 <= 1'b0;
					dfr <= 1'b0; // Should not happen
				end
			endcase

			// Update previous level
			previous_level <= current_level;
		end
	end

endmodule