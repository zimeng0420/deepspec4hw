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
        S2, // 1
        S3, // 11
        S4, // 111
        S5, // 1111
        S6, // 11111
        S7  // 111111
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(state or in) begin
        disc = 0;
        flag = 0;
        err = 0;
        
        case (state)
            S0: begin
                if (in) next_state = S1; // Start counting 1s
                else next_state = S0;    // Stay in S0
            end
            S1: begin
                if (in) next_state = S2; // 1 detected
                else next_state = S0;    // Reset on zero
            end
            S2: begin
                if (in) next_state = S3; // 11 detected
                else next_state = S0;    // Reset on zero
            end
            S3: begin
                if (in) next_state = S4; // 111 detected
                else next_state = S0;    // Reset on zero
            end
            S4: begin
                if (in) next_state = S5; // 1111 detected
                else next_state = S0;    // Reset on zero
            end
            S5: begin
                if (in) next_state = S6; // 11111 detected
                else next_state = S0;    // Reset on zero
            end
            S6: begin
                if (in) begin
                    next_state = S7;     // 111111 detected
                    err = 1;             // Error signal
                end else begin
                    next_state = S0;     // Reset on zero
                    disc = 1;            // Discard signal
                end
            end
            S7: begin
                if (in) begin
                    next_state = S7;     // Stay in error state
                    err = 1;             // Error signal remains active
                end else begin
                    next_state = S0;     // If a zero is found after 6 ones
                    flag = 1;            // Frame flag
                end
            end
            default: next_state = S0;  // Default case
        endcase
    end

endmodule