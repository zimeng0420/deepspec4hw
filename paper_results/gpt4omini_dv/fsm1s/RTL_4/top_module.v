module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    // State encoding
    typedef enum logic [1:0] {A = 1'b0, B = 1'b1} state_t;
    state_t current_state, next_state;

    // Sequential logic for state transitions
    always_ff @(posedge clk or posedge reset) begin
        if (reset) 
            current_state <= B; // Reset to state B
        else 
            current_state <= next_state; // Update to next state
    end

    // Combinational logic for state transitions and output
    always_comb begin
        case (current_state)
            A: begin
                if (in) begin
                    next_state = A; // Remain in A
                    out = 0; // Output is 0
                end else begin
                    next_state = B; // Transition to B
                    out = 0; // Output is 0
                end
            end
            B: begin
                if (in) begin
                    next_state = B; // Remain in B
                    out = 1; // Output is 1
                end else begin
                    next_state = A; // Transition to A
                    out = 1; // Output is 1
                end
            end
        endcase
    end

endmodule