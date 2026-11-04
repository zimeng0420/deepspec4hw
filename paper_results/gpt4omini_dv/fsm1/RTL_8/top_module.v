module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    typedef enum reg [1:0] {A, B} state_t;
    state_t current_state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= B; // Asynchronous reset to state B
        end else begin
            current_state <= next_state; // Update state on clock
        end
    end

    always @(*) begin
        case (current_state)
            A: begin
                out = 0; // Output for state A
                next_state = (in == 0) ? B : A; // State transitions from A
            end
            B: begin
                out = 1; // Output for state B
                next_state = (in == 0) ? A : B; // State transitions from B
            end
        endcase
    end

endmodule