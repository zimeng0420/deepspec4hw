module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State declaration using binary encoding
    typedef enum logic [2:0] {
        S0 = 3'b000,  // Initial state
        S1 = 3'b001,  // After seeing '1'
        S11 = 3'b010, // After seeing '11'
        S110 = 3'b011,// After seeing '110'
        S1101 = 3'b100 // After seeing '1101'
    } state_t;

    state_t state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 0;
        end else begin
            state <= next_state;
            if (state == S1101)
                start_shifting <= 1;
        end
    end

    // Next state logic (state transition conditions)
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S11 : S0;
            S11: next_state = data ? S11 : S110;
            S110: next_state = data ? S1101 : S0;
            S1101: next_state = S1101; // Remain in this state forever
            default: next_state = S0;
        endcase
    end

endmodule