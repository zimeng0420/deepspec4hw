module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    // State Encoding
    typedef enum logic [1:0] {A=2'b00, B=2'b01} state_t;
    state_t current_state, next_state;

    // State Transition
    always_comb begin
        case (current_state)
            A: next_state = in ? A : B;
            B: next_state = in ? B : A;
            default: next_state = B;  // Default state to handle unintended cases
        endcase
    end

    // Sequential Logic: State Register
    always_ff @(posedge clk or posedge areset) begin
        if (areset) 
            current_state <= B;
        else 
            current_state <= next_state;
    end

    // Output Logic
    always_comb begin
        case (current_state)
            A: out = 1'b0;
            B: out = 1'b1;
            default: out = 1'b0; // Default output
        endcase
    end

endmodule