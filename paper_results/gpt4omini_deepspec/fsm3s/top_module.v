module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    // State Encoding
    parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    reg [1:0] current_state, next_state;

    // State Transition Logic
    always @(*) begin
        case (current_state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A; // Default to A for safety
        endcase
    end

    // Output Logic
    always @(*) begin
        case (current_state)
            A, B, C: out = 1'b0;
            D: out = 1'b1;
            default: out = 1'b0; // Default to 0 for safety
        endcase
    end

    // State Update Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A; // Synchronous reset to state A
        end else begin
            current_state <= next_state; // Update state
        end
    end
    
endmodule