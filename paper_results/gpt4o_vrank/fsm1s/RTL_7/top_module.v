module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    // State encoding
    typedef enum logic [1:0] {
        A = 2'd0,
        B = 2'd1
    } state_t;

    state_t state, next_state;

    // State transition
    always @(posedge clk) begin
        if (reset)
            state <= B;  // Reset state
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            B: next_state = (in == 0) ? A : B;
            A: next_state = (in == 0) ? B : A;
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            B: out = 1;
            A: out = 0;
        endcase
    end

endmodule