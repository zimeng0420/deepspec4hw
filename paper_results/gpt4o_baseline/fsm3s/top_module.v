module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    // State Encoding
    typedef enum reg [1:0] {
        A = 2'd0,
        B = 2'd1,
        C = 2'd2,
        D = 2'd3
    } state_t;

    state_t current_state, next_state;

    // Sequential block: State Transition
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= A; // Synchronous active high reset to state A
        else
            current_state <= next_state;
    end

    // Combinational block: Determine Next State
    always @(*) begin
        case (current_state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A; // Default to state A
        endcase
    end

    // Output logic (Moore machine: depends only on current state)
    always @(*) begin
        case (current_state)
            A, B, C: out = 1'b0; // Output is 0 in states A, B, and C
            D: out = 1'b1;       // Output is 1 in state D
            default: out = 1'b0; // Default output is 0
        endcase
    end

endmodule