module top_module (
    input clk,
    input in,
    input areset,
    output out
);

    // State encoding
    typedef enum logic [0:0] {
        A = 1'b0,
        B = 1'b1
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B; // Default to state B for safety
        endcase
    end

    // State update logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= B; // Asynchronous reset to state B
        end else begin
            current_state <= next_state; // Proceed to next state on clock edge
        end
    end

    // Output logic
    assign out = (current_state == B) ? 1'b1 : 1'b0;

endmodule