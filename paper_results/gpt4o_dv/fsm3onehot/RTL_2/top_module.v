module top_module (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    always @(*) begin
        // Next state logic
        next_state[0] = (state[0] & ~in) | (state[2] & ~in); // From state A or C when in=0
        next_state[1] = (state[0] & in) | (state[3] & in);   // From state A or D when in=1
        next_state[2] = (state[1] & ~in) | (state[3] & ~in); // From state B or D when in=0
        next_state[3] = (state[2] & in);                     // From state C when in=1
    end

    // Output logic
    assign out = state[3];

endmodule