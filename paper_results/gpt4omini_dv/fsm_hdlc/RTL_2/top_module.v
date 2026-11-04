module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);
    typedef enum reg [2:0] {
        S0, // Initial state, assume previous input is 0
        S1, // Received 1
        S2, // Received 11
        S3, // Received 111
        S4, // Received 1111
        S5, // Received 11111
        S6, // Received 111111
        S7  // Received 1111111 (error state)
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
            S6: next_state = (in) ? S7 : S0; // if in, move to error state
            S7: next_state = (in) ? S7 : S0; // stay in error state
            default: next_state = S0;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            current_state <= next_state;

            // Assert outputs based on the state
            disc <= (current_state == S5 && in == 0);
            flag <= (current_state == S6 && in == 0);
            err <= (current_state == S7);
        end
    end
endmodule