module top_module (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

    // Define output logic
    assign out = (state == 2'b11) ? 1 : 0; // Output is 1 only in state D

    // State transition logic
    always @(*) begin
        case (state)
            2'b00: next_state = (in == 1'b0) ? 2'b00 : 2'b01; // A: A if 0, B if 1
            2'b01: next_state = (in == 1'b0) ? 2'b10 : 2'b01; // B: C if 0, B if 1
            2'b10: next_state = (in == 1'b0) ? 2'b00 : 2'b11; // C: A if 0, D if 1
            2'b11: next_state = (in == 1'b0) ? 2'b10 : 2'b01; // D: C if 0, B if 1
            default: next_state = 2'b00; // Default to state A for safety
        endcase
    end

endmodule