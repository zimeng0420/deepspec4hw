module top_module (
	input in,
	input [1:0] state,
	output reg [1:0] next_state,
	output out
);

always @(*) begin
	case(state)
		2'b00: begin // State A
			next_state = (in) ? 2'b01 : 2'b00; // A or B
		end
		2'b01: begin // State B
			next_state = (in) ? 2'b01 : 2'b10; // B or C
		end
		2'b10: begin // State C
			next_state = (in) ? 2'b11 : 2'b00; // D or A
		end
		2'b11: begin // State D
			next_state = (in) ? 2'b01 : 2'b10; // B or C
		end
		default: begin
			next_state = 2'b00; // Default to A
		end
	endcase
end

assign out = (state == 2'b11) ? 1'b1 : 1'b0; // Output logic for Moore machine

endmodule