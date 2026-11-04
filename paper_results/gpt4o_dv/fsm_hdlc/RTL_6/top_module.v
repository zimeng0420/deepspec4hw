module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding
    typedef enum logic [2:0] {
        S0, // 0 consecutive 1s (previous input was 0)
        S1, // 1 consecutive 1s
        S2, // 2 consecutive 1s
        S3, // 3 consecutive 1s
        S4, // 4 consecutive 1s
        S5, // 5 consecutive 1s
        S6, // 6 consecutive 1s
        SERR // Error state (7 or more consecutive 1s)
    } state_t;

    state_t state, next_state;

    // State transition logic
    always_comb begin
        next_state = state; // Default to stay in the current state
        // Default outputs
        disc = 0;
        flag = 0;
        err = 0;
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: begin
                if (in)
                    next_state = S6;
                else begin
                    next_state = S0;
                    disc = 1;
                end
            end
            S6: begin
                if (in)
                    next_state = SERR;
                else begin
                    next_state = S0;
                    flag = 1;
                end
            end
            SERR: begin
                if (in)
                    next_state = SERR;
                else
                    next_state = S0;
                err = 1;
            end
        endcase
    end

    // State register with synchronous reset
    always_ff @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule