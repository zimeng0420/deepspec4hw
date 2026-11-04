module top_module (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    always @(*) begin
        // State transition logic
        next_state[0] = (state[0] & ~in) | (state[2] & ~in); // Next state A logic
        next_state[1] = (state[0] & in) | (state[3] & in);   // Next state B logic
        next_state[2] = (state[1] & ~in) | (state[3] & ~in); // Next state C logic
        next_state[3] = (state[2] & in);                     // Next state D logic
    end

    // Output logic
    assign out = state[3]; // Output is 1 only in state D

endmodule