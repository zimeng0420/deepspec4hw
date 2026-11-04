module top_module (
	input clk,
	input areset,
	input x,
	output z
);

	// State Definitions
	parameter S_IDLE = 2'b00;
	parameter S_SEARCH = 2'b01;
	parameter S_COMPLEMENT = 2'b10;

	// State Variables
	reg [1:0] state;
	reg [1:0] next_state;
	reg complement;

	// Output Register
	reg z;

	// Internal Signals
	reg bit_found_one;

	// State Transition Logic
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= S_IDLE;
		end else begin
			state <= next_state;
		end
	end

	// Output and Next State Logic
	always @(*) begin
		next_state = state;
		z = 1'b0;
		complement = 1'b0;
		bit_found_one = 1'b0; // Initialize within the always block

		case (state)
			S_IDLE: begin
				z = 1'b0; // or z = x; as per the Moore machine
				if (!areset) begin
					next_state = S_SEARCH;
				end else begin
					next_state = S_IDLE;
				end
			end

			S_SEARCH: begin
				if (x) begin
					next_state = S_COMPLEMENT;
					bit_found_one = 1'b1;
					z = x; // output the bit found for the first 1
				end else begin
					next_state = S_SEARCH;
					z = x;
				end
			end

			S_COMPLEMENT: begin
				if (!bit_found_one) begin
					//This should not occur. Added for code completeness, but should not reach here
                    z = x;
                    next_state = S_COMPLEMENT;
                end else begin
					z = ~x;
					next_state = S_COMPLEMENT;

				end
			end

			default: begin
				next_state = S_IDLE;
				z = 1'b0; // or x;  as per the Moore Machine
			end
		endcase
	end
endmodule