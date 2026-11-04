module top_module (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    always @(*) begin
        // Default values for next_state
        next_state = 4'b0000;
        
        // State transition logic based on current state and input
        next_state[0] = state[0] & ~in | state[2] & ~in; // A -> A (in=0), C -> A (in=0)
        next_state[1] = state[0] & in | state[1] & in | state[3] & in; // A -> B (in=1), B -> B (in=1), D -> B (in=1)
        next_state[2] = state[1] & ~in | state[3] & ~in; // B -> C (in=0), D -> C (in=0)
        next_state[3] = state[2] & in; // C -> D (in=1)
    end

    // Output logic
    assign out = state[3]; // Output only depends on state D

endmodule