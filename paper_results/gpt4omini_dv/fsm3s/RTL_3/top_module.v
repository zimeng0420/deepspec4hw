module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    // State encoding
    parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    reg [1:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            A: next_state = (in == 0) ? A : B;
            B: next_state = (in == 0) ? C : B;
            C: next_state = (in == 0) ? A : D;
            D: next_state = (in == 0) ? C : B;
            default: next_state = A; // Default state to avoid latches
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            A, B, C: out = 0; // Output 0 for states A, B, C
            D: out = 1;       // Output 1 for state D
            default: out = 0; // Default output
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= A; // Reset to state A
        else
            current_state <= next_state; // Update state
    end

endmodule