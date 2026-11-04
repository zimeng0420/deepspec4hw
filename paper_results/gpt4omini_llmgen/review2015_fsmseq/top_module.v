module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding
    typedef enum logic [2:0] {
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 0;
        end else begin
            state <= next_state;
            if (next_state == S4) begin
                start_shifting <= 1;
            end else begin
                start_shifting <= 0;
            end
        end
    end

    always @(*) begin
        case(state)
            S0: next_state = data ? S1 : S0; // Wait for '1'
            S1: next_state = data ? S2 : S0; // Detected '1'
            S2: next_state = data ? S1 : S3; // Detected '11'
            S3: next_state = data ? S4 : S0; // Detected '110'
            S4: next_state = S4;               // Detected '1101', stay in S4
            default: next_state = S0;         // Default case to reset
        endcase
    end

endmodule