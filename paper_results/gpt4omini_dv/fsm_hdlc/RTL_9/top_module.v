module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding
    typedef enum reg [3:0] {
        S0, // Initial State (Waiting for 0 or 1)
        S1, // Received 0
        S2, // Received 1
        S3, // Received 11
        S4, // Received 111
        S5, // Received 1111
        S6, // Received 11111
        S7, // Received 111111
        S8, // Received 1111110 (disc)
        S9  // Received 11111110 (flag)
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        disc = 0;
        flag = 0;
        err = 0;
        
        case (current_state)
            S0: begin
                if (in) next_state = S1; // Receive 1
            end
            S1: begin
                if (in) next_state = S2; // Receive 1 (1)
                else next_state = S0; // Receive 0 (reset)
            end
            S2: begin
                if (in) next_state = S3; // Receive 1 (11)
                else next_state = S1; // Receive 0
            end
            S3: begin
                if (in) next_state = S4; // Receive 1 (111)
                else next_state = S2; // Receive 0
            end
            S4: begin
                if (in) next_state = S5; // Receive 1 (1111)
                else next_state = S3; // Receive 0
            end
            S5: begin
                if (in) next_state = S6; // Receive 1 (11111)
                else next_state = S4; // Receive 0
            end
            S6: begin
                if (in) next_state = S7; // Receive 1 (111111)
                else next_state = S5; // Receive 0
            end
            S7: begin
                if (in) begin
                    next_state = S7; // 7 or more 1's (error)
                    err = 1; // Error condition
                end else begin
                    next_state = S8; // 1111110 (disc)
                    disc = 1; // Need to discard 
                end
            end
            S8: begin
                if (in) begin
                    next_state = S9; // 11111110 (flag)
                    flag = 1; // Frame flag detected
                end else begin
                    next_state = S0; // Reset to waiting state
                end
            end
            S9: begin
                next_state = S0; // Return to initial state after flag
            end
        endcase
    end
endmodule