module top_module (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    always @(*) begin
        // Default next state
        next_state = 4'b0000;

        // Next state logic
        next_state[0] = state[0] & (~in) | state[2] & (~in); // A
        next_state[1] = state[0] & in | state[1] & in | state[3] & in; // B
        next_state[2] = state[1] & (~in) | state[3] & (~in); // C
        next_state[3] = state[2] & in; // D
    end

    // Output logic
    assign out = state[3]; // Output is 1 only in state D

endmodule