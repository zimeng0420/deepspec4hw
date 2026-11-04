module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    typedef enum reg [3:0] {
        S0, // Initial state (waiting for 0)
        S1, // 0 followed by 1
        S2, // 01
        S3, // 011
        S4, // 0111
        S5, // 01111
        S6, // 011111
        S7, // 0111110 (disc)
        S8, // 01111110 (flag)
        S9  // 01111111... (err)
    } state_t;

    state_t current_state, next_state;

    always @ (posedge clk or posedge reset) begin
        if (reset) 
            current_state <= S0;
        else 
            current_state <= next_state;
    end

    always @ (*) begin
        disc = 0; 
        flag = 0; 
        err = 0; 
        case (current_state)
            S0: begin
                if (in) 
                    next_state = S1;
                else 
                    next_state = S0;
            end
            S1: begin
                if (in) 
                    next_state = S2;
                else 
                    next_state = S0;
            end
            S2: begin
                if (in) 
                    next_state = S3;
                else 
                    next_state = S0;
            end
            S3: begin
                if (in) 
                    next_state = S4;
                else 
                    next_state = S0;
            end
            S4: begin
                if (in) 
                    next_state = S5;
                else 
                    next_state = S0;
            end
            S5: begin
                if (in) 
                    next_state = S6;
                else 
                    next_state = S0;
            end
            S6: begin
                if (in) 
                    next_state = S9; // 7 or more 1s detected
                else 
                    next_state = S7; // 0111110 (disc)
            end
            S7: begin
                if (in) 
                    next_state = S8; // 01111110 (flag)
                else 
                    next_state = S0;
            end
            S8: begin
                next_state = S0; // Return to initial state after flag
            end
            S9: begin
                next_state = S9; // Stay in error state
                err = 1; // Generate error signal
            end
            default: next_state = S0;
        endcase
    end

    always @ (posedge clk) begin
        if (current_state == S7) 
            disc <= 1; // Signal disc on next clock
        if (current_state == S8) 
            flag <= 1; // Signal flag on next clock
    end

endmodule