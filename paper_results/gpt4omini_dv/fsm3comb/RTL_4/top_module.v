module top_module (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

    always @(*) begin
        case (state)
            2'b00: next_state = (in == 0) ? 2'b00 : 2'b01; // State A
            2'b01: next_state = (in == 0) ? 2'b10 : 2'b01; // State B
            2'b10: next_state = (in == 0) ? 2'b00 : 2'b11; // State C
            2'b11: next_state = (in == 0) ? 2'b10 : 2'b01; // State D
            default: next_state = 2'b00; // Default case (to handle unexpected states)
        endcase
    end

    assign out = (state == 2'b11) ? 1 : 0; // Output logic

endmodule