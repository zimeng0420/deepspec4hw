module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding
    typedef enum logic [2:0] {
        S_IDLE  = 3'b000,
        S_1     = 3'b001,
        S_11    = 3'b010,
        S_110   = 3'b011,
        S_1101  = 3'b100
    } state_t;

    // State variables
    state_t state, next_state;

    // State transition logic (combinational logic)
    always_comb begin
        case (state)
            S_IDLE:  next_state = data ? S_1   : S_IDLE;
            S_1:     next_state = data ? S_11  : S_IDLE;
            S_11:    next_state = data ? S_11  : S_110;
            S_110:   next_state = data ? S_1101: S_IDLE;
            S_1101:  next_state = S_1101;
            default: next_state = S_IDLE;
        endcase
    end

    // State register update (sequential logic)
    always_ff @(posedge clk) begin
        if (reset)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    // Output logic
    always_ff @(posedge clk) begin
        if (reset)
            start_shifting <= 0;
        else
            start_shifting <= (state == S_1101) ? 1 : start_shifting;
    end

endmodule