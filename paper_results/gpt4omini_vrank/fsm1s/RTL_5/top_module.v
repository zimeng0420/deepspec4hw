module top_module (
	input clk,
	input in,
	input reset,
	output reg out
);

typedef enum reg [1:0] {
	B = 1'b0,
	A = 1'b1
} state_t;

state_t current_state, next_state;

always @(posedge clk) begin
	if (reset) begin
		current_state <= B;
	end else begin
		current_state <= next_state;
	end
end

always @(*) begin
	case (current_state)
		B: begin
			if (in == 1'b0) begin
				next_state = A;
				out = 1'b1;
			end else begin
				next_state = B;
				out = 1'b1;
			end
		end
		A: begin
			if (in == 1'b0) begin
				next_state = B;
				out = 1'b0;
			end else begin
				next_state = A;
				out = 1'b0;
			end
		end
	default: begin
		next_state = B;
		out = 1'b0;
	end
	endcase
end

endmodule