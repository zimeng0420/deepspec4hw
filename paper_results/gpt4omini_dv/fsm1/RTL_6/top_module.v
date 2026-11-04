module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    typedef enum reg {A, B} state_t;
    state_t current_state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) 
            current_state <= B; // Reset to state B
        else 
            current_state <= next_state; // Transition to the next state
    end

    always @* begin
        case (current_state)
            A: begin
                out = 0; // Output for state A
                if (in == 0)
                    next_state = B; // Transition A --0--> B
                else
                    next_state = A; // Transition A --1--> A
            end
            B: begin
                out = 1; // Output for state B
                if (in == 0)
                    next_state = A; // Transition B --0--> A
                else
                    next_state = B; // Transition B --1--> B
            end
            default: begin
                out = 0; // Default case (should not happen)
                next_state = A; // Default to A if in unknown state
            end
        endcase
    end

endmodule