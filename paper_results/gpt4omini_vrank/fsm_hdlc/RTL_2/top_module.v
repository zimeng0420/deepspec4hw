module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    typedef enum reg [2:0] {
        S0, // Initial state
        S1, // 0
        S2, // 01
        S3, // 011
        S4, // 0111
        S5, // 01111
        S6, // 011111
        S7, // 0111111
        S8  // 01111110
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            current_state <= next_state;
            disc <= 0;
            flag <= 0;
            err <= 0;
            // Output logic
            case (next_state)
                S6: disc <= 1;        // Output discard signal
                S8: flag <= 1;        // Output frame flag signal
                S7: err <= 1;         // Output error signal
            endcase
        end
    end

    always @(*) begin
        case (current_state)
            S0: next_state = (in) ? S1 : S0; // Wait for start of a sequence
            S1: next_state = (in) ? S2 : S0; // 0 found, go back to start on 0
            S2: next_state = (in) ? S3 : S0; // Found 01
            S3: next_state = (in) ? S4 : S0; // Found 011
            S4: next_state = (in) ? S5 : S0; // Found 0111
            S5: next_state = (in) ? S6 : S0; // Found 01111
            S6: next_state = (in) ? S7 : S0; // Found 011111
            S7: next_state = (in) ? S7 : S8; // Found 0111111 or 01111110
            S8: next_state = (in) ? S7 : S0; // Found 01111110 or 0 (flag end) 
            default: next_state = S0;
        endcase
    end

endmodule