module top_module (
	input clk,
	input reset,
	input in,
	output reg disc,
	output reg flag,
	output reg err
);

	reg [2:0] state, next_state;
	parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011,
			  S4 = 3'b100, S5 = 3'b101, S6 = 3'b110, S7 = 3'b111;

	always @ (posedge clk) begin
		if (reset)
			state <= S0;
		else
			state <= next_state;
	end

	always @ (*) begin
		// Default outputs
		disc = 0;
		flag = 0;
		err = 0;

		case (state)
			S0: begin
				if (in)
					next_state = S1;
				else
					next_state = S0;
			end
			S1: begin
				if (in)
					next_state = S2;
				else
					next_state = S0;
			end
			S2: begin
				if (in)
					next_state = S3;
				else
					next_state = S0;
			end
			S3: begin
				if (in)
					next_state = S4;
				else
					next_state = S0;
			end
			S4: begin
				if (in)
					next_state = S5;
				else
					next_state = S0;
			end
			S5: begin
				if (in)
					next_state = S6;
				else
					next_state = S0;
			end
			S6: begin
				if (in) begin
					next_state = S7;
					err = 1; // Error condition, 7 or more consecutive 1s
				end else begin
					next_state = S0;
					flag = 1; // flag detected
				end
			end
			S7: begin
				if (in) begin
					next_state = S7;
					err = 1; // Stay in error state
				end else begin
					next_state = S0;
				end
			end
			default: begin
				next_state = S0;
			end
		endcase

		// Handle disc condition (5 consecutive 1s followed by a 0)
		if (state == S5 && !in)
			disc = 1;
	end

endmodule