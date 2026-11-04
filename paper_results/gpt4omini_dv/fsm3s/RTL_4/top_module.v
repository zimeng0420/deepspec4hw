module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    // State Encoding
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t current_state, next_state;

    // Combinational Logic for Next State and Output
    always @(*) begin
        case (current_state)
            A: next_state = (in == 0) ? A : B;
            B: next_state = (in == 0) ? C : B;
            C: next_state = (in == 0) ? A : D;
            D: next_state = (in == 0) ? C : B;
            default: next_state = A; // Default to A
        endcase
    end

    // Output Logic
    always @(*) begin
        case (current_state)
            A, B, C: out = 0;
            D: out = 1;
            default: out = 0; // Default output
        endcase
    end

    // Synchronous Reset and State Update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A; // Reset to state A
        end else begin
            current_state <= next_state; // Update current state
        end
    end

endmodule