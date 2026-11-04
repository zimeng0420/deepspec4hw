module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding
    typedef enum reg [2:0] {
        S0, // 0 consecutive 1s
        S1, // 1 consecutive 1s
        S2, // 2 consecutive 1s
        S3, // 3 consecutive 1s
        S4, // 4 consecutive 1s
        S5, // 5 consecutive 1s
        S6, // 6 consecutive 1s
        ERR // Error state: 7 or more consecutive 1s
    } state_t;
    
    state_t current_state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (current_state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? ERR : S0;
            ERR: next_state = in ? ERR : S0;
            default: next_state = S0; // Default case
        endcase
    end

    // Output logic (combinational)
    always @(*) begin
        disc = 0;
        flag = 0;
        err = 0;

        case (current_state)
            S5: if (!in) disc = 1; // 0111110, discard 0
            S6: if (!in) flag = 1; // 01111110, frame boundary flag
            ERR: err = 1;          // 7 or more consecutive 1s, error
        endcase
    end

    // State update logic (sequential)
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0; // Reset to initial state
        end else begin
            current_state <= next_state;
        end
    end

endmodule