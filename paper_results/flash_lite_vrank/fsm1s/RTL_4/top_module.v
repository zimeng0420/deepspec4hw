module top_module (
	input clk,
	input in,
	input reset,
	output out
);

	parameter A = 2'b00;
	parameter B = 2'b01;

	reg [1:0] state, next_state;
	reg out_reg;

	// State transition logic
	always @(*) begin
		case (state)
			B:
				if (in)
					next_state = B;
				else
					next_state = A;
			A:
				if (in)
					next_state = A;
				else
					next_state = B;
			default:
				next_state = B; // Handle uninitialized state
		endcase
	end

	// Output logic
	always @(*) begin
		case (state)
			B:
				out_reg = 1'b1;
			A:
				out_reg = 1'b0;
			default:
				out_reg = 1'b1; // Default to out=1 for uninitialized state (corresponds to state B)
		endcase
	end

	// State register and output register
	always @(posedge clk) begin
		if (reset) begin
			state <= B;
			out_reg <= 1'b1; //Reset to B (out = 1)
		end else begin
			state <= next_state;
			// out_reg is updated directly in output logic, no need to update here
		end
	end

	assign out = out_reg;

endmodule