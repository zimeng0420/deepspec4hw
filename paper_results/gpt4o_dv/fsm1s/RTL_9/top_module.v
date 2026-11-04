module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    // State encoding
    parameter B = 1'b0, A = 1'b1;
    reg current_state, next_state;

    // Synchronous state update
    always @(posedge clk) begin
        if (reset)
            current_state <= B; // Reset state
        else
            current_state <= next_state;
    end

    // Combinational logic for next state
    always @(*) begin
        case (current_state)
            B: next_state = in ? B : A;
            A: next_state = in ? A : B;
            default: next_state = B; // Default state for safety
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            B: out = 1;
            A: out = 0;
            default: out = 1; // Default output for safety
        endcase
    end

endmodule