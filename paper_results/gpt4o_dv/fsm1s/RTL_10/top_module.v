module top_module (
    input clk,
    input in,
    input reset,
    output out
);

    // State declarations
    reg state, next_state;

    // State encoding
    localparam STATE_B = 1'b0;
    localparam STATE_A = 1'b1;

    // Synchronous state transition
    always @(posedge clk) begin
        if (reset)
            state <= STATE_B;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            STATE_B: next_state = in ? STATE_B : STATE_A;
            STATE_A: next_state = in ? STATE_A : STATE_B;
            default: next_state = STATE_B; // Safety fallback
        endcase
    end

    // Output logic
    assign out = (state == STATE_B);

endmodule