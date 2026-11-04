module top_module (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

    always @(*) begin
        // State Transition Logic
        case (state)
            2'b00: next_state = (in == 0) ? 2'b00 : 2'b01; // State A
            2'b01: next_state = (in == 0) ? 2'b10 : 2'b01; // State B
            2'b10: next_state = (in == 0) ? 2'b00 : 2'b11; // State C
            2'b11: next_state = (in == 0) ? 2'b10 : 2'b01; // State D
        endcase

        // Output Logic
        case (state)
            2'b00: out = 0;  // State A
            2'b01: out = 0;  // State B
            2'b10: out = 0;  // State C
            2'b11: out = 1;  // State D
        endcase
    end

endmodule