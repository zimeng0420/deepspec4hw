module top_module (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    always @(*) begin
        // Next state logic
        next_state[0] = state[0] & (~in) | state[2] & (~in); // A stays or C goes to A
        next_state[1] = state[0] & in | state[1] & in | state[3] & in; // A goes to B or B stays or D goes to B
        next_state[2] = state[1] & (~in) | state[3] & (~in); // B goes to C or D goes to C
        next_state[3] = state[2] & in; // C goes to D
    end
    
    // Output logic
    assign out = state[3]; // Output is high if in state D

endmodule