module top_module (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

    // Next state logic
    always @(*) begin
        case (state)
            2'b00: next_state = in ? 2'b01 : 2'b00; // A
            2'b01: next_state = in ? 2'b01 : 2'b10; // B
            2'b10: next_state = in ? 2'b11 : 2'b00; // C
            2'b11: next_state = in ? 2'b01 : 2'b10; // D
            default: next_state = 2'b00; // Default case for safety
        endcase
    end

    // Output logic
    assign out = (state == 2'b11) ? 1'b1 : 1'b0; // Output is 1 only in state D

endmodule