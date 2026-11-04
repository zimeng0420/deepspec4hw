module top_module (
    input clk,
    input in,
    input reset,
    output out
);

    // Define state encoding
    typedef enum logic [0:0] {
        STATE_A = 1'b0,
        STATE_B = 1'b1
    } state_t;

    state_t state, next_state;

    // State transition
    always @(posedge clk) begin
        if (reset)
            state <= STATE_B; // Reset state
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            STATE_B: next_state = in ? STATE_B : STATE_A;
            STATE_A: next_state = in ? STATE_A : STATE_B;
        endcase
    end

    // Output logic
    assign out = (state == STATE_B) ? 1'b1 : 1'b0;

endmodule