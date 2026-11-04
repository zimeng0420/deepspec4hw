module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State definition
    typedef enum reg [2:0] {
        S0, // Reset state / Initial state
        S1, // 1 consecutive 1
        S2, // 2 consecutive 1s
        S3, // 3 consecutive 1s
        S4, // 4 consecutive 1s
        S5, // 5 consecutive 1s
        S6, // 6 consecutive 1s
        S7  // 7 or more consecutive 1s (Error state)
    } state_t;

    // State registers
    state_t current_state, next_state;

    // State transition logic (Combinational)
    always @(*) begin
        case (current_state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0; // Remain in error state if in is 1
            default: next_state = S0; // Default case (should not happen)
        endcase
    end

    // Output logic based on current state (Moore machine)
    always @(*) begin
        // Default outputs
        disc = 1'b0;
        flag = 1'b0;
        err = 1'b0;
        
        case (current_state)
            S5: if (!in) disc = 1'b1; // 0111110 detected
            S6: if (!in) flag = 1'b1; // 01111110 detected
            S7: err = 1'b1;           // 7 or more consecutive 1s
        endcase
    end

    // State register update (Synchronous)
    always @(posedge clk) begin
        if (reset)
            current_state <= S0; // Reset to initial state
        else
            current_state <= next_state;
    end

endmodule