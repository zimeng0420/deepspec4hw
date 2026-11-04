module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    // Define states
    typedef enum reg [1:0] {A, B, C, D} state_t;
    state_t state, next_state;

    // State transition logic
    always @(*) begin
        // Default next state
        next_state = state;

        case (state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
        endcase
    end

    // State update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A; // Go to state A on reset
        else
            state <= next_state; // Update state based on transition logic
    end

    // Output logic
    always @(*) begin
        case (state)
            A: out = 1'b0;
            B: out = 1'b0;
            C: out = 1'b0;
            D: out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule