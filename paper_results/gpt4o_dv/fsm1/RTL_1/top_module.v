module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    // State encoding
    typedef enum reg [1:0] {A = 1'b0, B = 1'b1} state_t;
    state_t current_state, next_state;

    // Asynchronous reset and state transition logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= B;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B; // Default to state B
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            B: out = 1'b1;
            A: out = 1'b0;
        endcase
    end

endmodule