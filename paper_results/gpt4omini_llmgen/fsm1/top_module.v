module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    // State encoding
    typedef enum reg [1:0] {
        A = 1'b0,
        B = 1'b1
    } state_t;

    state_t current_state, next_state;

    // Asynchronous reset and state transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= B; // Reset to state B
        end else begin
            current_state <= next_state; // Transition to the next state
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            A: begin
                if (in) begin
                    next_state = A; // Stay in A on input 1
                end else begin
                    next_state = B; // Transition to B on input 0
                end
            end
            B: begin
                if (in) begin
                    next_state = B; // Stay in B on input 1
                end else begin
                    next_state = A; // Transition to A on input 0
                end
            end
            default: next_state = B; // Default state (safety)
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            A: out = 1'b0;
            B: out = 1'b1;
            default: out = 1'b0; // Default output (safety)
        endcase
    end

endmodule