module top_module (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    always @(*) begin
        // Next state logic
        next_state[0] = (state[0] & ~in) | (state[2] & ~in); // A: A if in=0, C: A if in=0
        next_state[1] = (state[0] & in) | (state[3] & in);   // A: B if in=1, D: B if in=1
        next_state[2] = (state[1] & ~in) | (state[3] & ~in); // B: C if in=0, D: C if in=0
        next_state[3] = (state[2] & in);                     // C: D if in=1
    end

    // Output logic
    assign out = state[3]; // D: output is 1 only in state D

endmodule