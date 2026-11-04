module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding
    typedef enum logic [2:0] {
        S0 = 3'b000, // Initial state
        S1 = 3'b001, // State after seeing 1
        S2 = 3'b010, // State after seeing 11
        S3 = 3'b011, // State after seeing 110
        S4 = 3'b100  // State after seeing 1101 (Sequence found)
    } state_t;

    state_t state, next_state;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = (data == 1'b1) ? S1 : S0;
            S1: next_state = (data == 1'b1) ? S2 : S0;
            S2: next_state = (data == 1'b0) ? S3 : S2;
            S3: next_state = (data == 1'b1) ? S4 : S0;
            S4: next_state = S4; // Remain in S4 after sequence is detected
            default: next_state = S0;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            start_shifting <= 1'b0;
        end else if (state == S4) begin
            start_shifting <= 1'b1;
        end
    end

endmodule