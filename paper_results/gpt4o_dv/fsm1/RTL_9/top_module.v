module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    typedef enum logic {A=0, B=1} state_t;
    state_t current_state, next_state;

    // Asynchronous Reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= B; // Reset to state B
        else
            current_state <= next_state; // Update state on clock edge
    end

    // State Transition Logic
    always_comb begin
        case (current_state)
            B: next_state = (in == 0) ? A : B;
            A: next_state = (in == 0) ? B : A;
            default: next_state = B; // Default state for safety
        endcase
    end

    // Output Logic
    always_comb begin
        case (current_state)
            B: out = 1;
            A: out = 0;
            default: out = 0; // Default output for safety
        endcase
    end

endmodule