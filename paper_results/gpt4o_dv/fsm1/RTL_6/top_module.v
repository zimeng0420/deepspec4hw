module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    // State Encoding
    typedef enum reg [1:0] {A = 1'b0, B = 1'b1} state_t;
    state_t state, next_state;

    // Asynchronous reset and state transition logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B; // Asynchronous reset to state B
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            B: next_state = (in == 0) ? A : B;
            A: next_state = (in == 0) ? B : A;
            default: next_state = B; // Default to state B
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            B: out = 1;
            A: out = 0;
            default: out = 1;
        endcase
    end

endmodule