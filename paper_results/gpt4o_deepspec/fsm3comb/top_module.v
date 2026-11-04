module top_module (
	input in,
	input [1:0] state,
	output reg [1:0] next_state,
	output reg out
);

always @(*) begin
    // State transition logic
    case (state)
        2'b00: next_state = (in == 1'b0) ? 2'b00 : 2'b01; // State A
        2'b01: next_state = (in == 1'b0) ? 2'b10 : 2'b01; // State B
        2'b10: next_state = (in == 1'b0) ? 2'b00 : 2'b11; // State C
        2'b11: next_state = (in == 1'b0) ? 2'b10 : 2'b01; // State D
        default: next_state = 2'b00; // Default case (optional safety)
    endcase

    // Output logic
    case (state)
        2'b00: out = 1'b0; // State A
        2'b01: out = 1'b0; // State B
        2'b10: out = 1'b0; // State C
        2'b11: out = 1'b1; // State D
        default: out = 1'b0; // Default case (optional safety)
    endcase
end

endmodule