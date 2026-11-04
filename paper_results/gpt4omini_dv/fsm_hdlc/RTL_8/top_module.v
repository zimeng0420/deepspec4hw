module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    typedef enum reg [3:0] {
        S0,  // Idle state (expecting 0)
        S1,  // Seen 1
        S2,  // Seen 11
        S3,  // Seen 111
        S4,  // Seen 1111
        S5,  // Seen 11111
        S6,  // Seen 111111
        S7,  // Seen 1111111
        S8   // Seen 11111110 (flag state)
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            S0: next_state = (in) ? S1 : S0;
            S1: next_state = (in) ? S2 : S0;
            S2: next_state = (in) ? S3 : S0;
            S3: next_state = (in) ? S4 : S0;
            S4: next_state = (in) ? S5 : S0;
            S5: next_state = (in) ? S6 : S0;
            S6: next_state = (in) ? S7 : S0;
            S7: next_state = (in) ? S8 : S0;  // Error detected
            S8: next_state = (in) ? S0 : S0;  // After flag, return to S0
            default: next_state = S0;
        endcase
    end

    // State output logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            current_state <= next_state;

            // Reset outputs
            disc <= 0;
            flag <= 0;
            err <= 0;

            // Set outputs based on the current state
            case (current_state)
                S5: disc <= 1; // 0111110
                S6: flag <= 1; // 01111110
                S7: err <= 1;  // 01111111
            endcase
        end
    end

endmodule