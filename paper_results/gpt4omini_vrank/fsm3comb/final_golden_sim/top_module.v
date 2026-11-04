module top_module (
	input in,
	input [1:0] state,
	output reg [1:0] next_state,
	output reg out
);

always @(*) begin
	case (state)
		2'b00: begin // State A
			if (in == 0) begin
				next_state = 2'b00; // Stay in A
			end else begin
				next_state = 2'b01; // Go to B
			end
			out = 0;
		end
		2'b01: begin // State B
			if (in == 0) begin
				next_state = 2'b10; // Go to C
			end else begin
				next_state = 2'b01; // Stay in B
			end
			out = 0;
		end
		2'b10: begin // State C
			if (in == 0) begin
				next_state = 2'b00; // Go to A
			end else begin
				next_state = 2'b11; // Go to D
			end
			out = 0;
		end
		2'b11: begin // State D
			if (in == 0) begin
				next_state = 2'b10; // Go to C
			end else begin
				next_state = 2'b01; // Go to B
			end
			out = 1;
		end
		default: begin
			next_state = 2'b00; // Default to state A
			out = 0;
		end
	endcase
end

endmodule