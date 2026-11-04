module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    // Define state encoding
    typedef enum logic [0:0] {
        B = 1'b0,
        A = 1'b1
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B; // Default to B state
        endcase
    end

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= B;
        else
            current_state <= next_state;
    end

    // Output logic based on current state
    always @(*) begin
        case (current_state)
            B: out = 1'b1;
            A: out = 1'b0;
            default: out = 1'b1; // Default to B's output
        endcase
    end

endmodule