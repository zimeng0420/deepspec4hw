module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    // State Definition
    typedef enum reg [1:0] {
        A = 1'b0,
        B = 1'b1
    } state_t;

    state_t current_state, next_state;

    // Asynchronous reset and state transition in the sequential block
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= B; // Reset to state B
        end else begin
            current_state <= next_state; // Transition to next state
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            A: begin
                if (in == 0) begin
                    next_state = B; // A --0--> B
                end else begin
                    next_state = A; // A --1--> A
                end
                out = 0; // Output for state A
            end
            B: begin
                if (in == 0) begin
                    next_state = A; // B --0--> A
                end else begin
                    next_state = B; // B --1--> B
                end
                out = 1; // Output for state B
            end
            default: begin
                next_state = B; // Default state
                out = 0;
            end
        endcase
    end

endmodule