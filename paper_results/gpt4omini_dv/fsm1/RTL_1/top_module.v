module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    // State declaration
    typedef enum reg [1:0] {
        A = 1'b0,
        B = 1'b1
    } state_t;

    state_t current_state, next_state;

    // Asynchronous reset
    always @* begin
        if (areset) 
            next_state = B;  // Reset to state B
        else case (current_state)
            A: next_state = (in == 1'b0) ? B : A;
            B: next_state = (in == 1'b0) ? A : B;
            default: next_state = B; // Default case (should not happen)
        endcase
    end

    // State update on clock edge
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= B;  // Reset to state B
        else
            current_state <= next_state;
    end

    // Output based on current state
    always @* begin
        out = (current_state == B) ? 1'b1 : 1'b0; // Output '1' in state B, '0' in state A
    end

endmodule