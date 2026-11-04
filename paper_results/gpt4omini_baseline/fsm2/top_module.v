module top_module (
	input clk,
	input j,
	input k,
	input areset,
	output reg out
);

typedef enum reg [1:0] {OFF, ON} state_t;
state_t state, next_state;

always @(posedge clk or posedge areset) begin
	if (areset) begin
		state <= OFF;
	end else begin
		state <= next_state;
	end
end

always @(*) begin
	case (state)
		OFF: begin
			out = 0;
			if (j) begin
				next_state = ON;
			end else begin
				next_state = OFF;
			end
		end
		ON: begin
			out = 1;
			if (k) begin
				next_state = OFF;
			end else begin
				next_state = ON;
			end
		end
		default: begin
			next_state = OFF; // Default safety state
		end
	endcase
end

endmodule