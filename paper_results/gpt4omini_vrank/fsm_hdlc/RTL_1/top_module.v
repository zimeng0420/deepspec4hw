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
        S0, // Initial state
        S1, // Sequence: 0
        S2, // Sequence: 01
        S3, // Sequence: 011
        S4, // Sequence: 0111
        S5, // Sequence: 01111
        S6, // Sequence: 011111
        S7, // Sequence: 0111111 (error state)
        S8  // Sequence: 01111110 (flag state)
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @ (posedge clk) begin
        if (reset) 
            current_state <= S0;
        else 
            current_state <= next_state;
    end

    // Next state logic
    always @ (*) begin
        next_state = current_state; // Default to hold state
        disc = 0; 
        flag = 0; 
        err = 0;

        case (current_state)
            S0: 
                if (in) 
                    next_state = S1; // Input is 1
            S1: 
                if (in) 
                    next_state = S2; // Input is 1
                else 
                    next_state = S0; // Input is 0
            S2: 
                if (in) 
                    next_state = S3; // Input is 1
                else 
                    next_state = S0; // Input is 0
            S3: 
                if (in) 
                    next_state = S4; // Input is 1
                else 
                    next_state = S0; // Input is 0
            S4: 
                if (in) 
                    next_state = S5; // Input is 1
                else 
                    next_state = S0; // Input is 0
            S5: 
                if (in) 
                    next_state = S6; // Input is 1
                else 
                    next_state = S0; // Input is 0
            S6: 
                if (in) 
                    next_state = S7; // Input is 1 (Error state)
                else 
                    next_state = S8; // Input is 0 (Flag state)
            S7: 
                err = 1; // 7 or more consecutive 1s
            S8: 
                flag = 1; // 01111110 detected
            default: 
                next_state = S0; // Default to initial state
        endcase
        
        // Signal for bit to be discarded
        if (current_state == S5 && in == 0) 
            disc = 1; // 0111110 sequence detected
    end
endmodule