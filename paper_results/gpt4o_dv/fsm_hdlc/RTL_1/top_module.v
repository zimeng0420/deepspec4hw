module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State Encoding
    typedef enum reg [2:0] {
        S0 = 3'd0, // No consecutive 1s
        S1 = 3'd1, // 1 consecutive 1
        S2 = 3'd2, // 2 consecutive 1s
        S3 = 3'd3, // 3 consecutive 1s
        S4 = 3'd4, // 4 consecutive 1s
        S5 = 3'd5, // 5 consecutive 1s
        S6 = 3'd6, // 6 consecutive 1s
        SE = 3'd7  // Error state (7 or more consecutive 1s)
    } state_t;

    state_t current_state, next_state;

    // State Transition Logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next State Logic
    always @(*) begin
        case (current_state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? SE : S0;
            SE: next_state = in ? SE : S0;
            default: next_state = S0;
        endcase
    end

    // Output Logic
    always @(posedge clk) begin
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
        
        case (current_state)
            S5: if (!in) disc <= 1'b1; // 0111110
            S6: if (!in) flag <= 1'b1; // 01111110
            SE: err <= 1'b1;           // 01111111...
        endcase
    end

endmodule