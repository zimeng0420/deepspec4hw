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
        S0, // No consecutive 1's
        S1, // 1 consecutive 1
        S2, // 2 consecutive 1's
        S3, // 3 consecutive 1's
        S4, // 4 consecutive 1's
        S5, // 5 consecutive 1's
        S6, // 6 consecutive 1's (flag potential state)
        S7  // Error state for 7 or more consecutive 1's
    } state_t;

    // Define current state and next state variables
    reg [2:0] current_state, next_state;
    
    // State transition logic (combinational)
    always @(*) begin
        // Default to no output
        next_state = current_state;
        disc = 0;
        flag = 0;
        err = 0;
        
        case (current_state)
            S0: begin
                if (in) next_state = S1;
            end
            S1: begin
                if (in) next_state = S2;
                else next_state = S0;
            end
            S2: begin
                if (in) next_state = S3;
                else next_state = S0;
            end
            S3: begin
                if (in) next_state = S4;
                else next_state = S0;
            end
            S4: begin
                if (in) next_state = S5;
                else next_state = S0;
            end
            S5: begin
                if (in) next_state = S6;
                else begin
                    next_state = S0;
                    disc = 1; // Disc signal for 0111110
                end
            end
            S6: begin
                if (in) next_state = S7; // Enter error state if another 1
                else begin
                    next_state = S0;
                    flag = 1; // Flag signal for 01111110
                end
            end
            S7: begin
                err = 1; // Stay in error state (assert err)
                if (!in) next_state = S0;
            end
        endcase
    end

    // State updating logic (sequential)
    always @(posedge clk) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

endmodule