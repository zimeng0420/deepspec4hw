module top_module (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    always @(*) begin
        // State transition logic
        next_state[0] = state[0] & (~in) | state[2] & (~in); // Remain in A or move to A from C
        next_state[1] = state[0] & in | state[1] & in | state[3] & in; // Move to B from A or remain in B or move to B from D
        next_state[2] = state[1] & (~in) | state[3] & (~in); // Move to C from B or move to C from D
        next_state[3] = state[2] & in; // Move to D from C
    end

    // Output logic
    assign out = state[3]; // Output is high when in state D

endmodule