module top_module (
    input clk,
    input in,
    input areset,
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
    
    // State Transition Logic
    always @(*) begin
        case (current_state)
            A: next_state = (in == 0) ? A : B;
            B: next_state = (in == 0) ? C : B;
            C: next_state = (in == 0) ? A : D;
            D: next_state = (in == 0) ? C : B;
            default: next_state = A; // Default to state A
        endcase
    end
    
    // Output Logic
    always @(*) begin
        case (current_state)
            D: out = 1;
            default: out = 0;
        endcase
    end

    // Sequential Logic - State Register
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= A; // Asynchronous reset to state A
        else
            current_state <= next_state;
    end

endmodule