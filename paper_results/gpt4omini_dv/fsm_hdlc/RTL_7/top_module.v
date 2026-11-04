module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);
    typedef enum reg [2:0] {
        S0, // Initial state (waiting for 0 or 1)
        S1, // Seen 0
        S2, // Seen 01
        S3, // Seen 011
        S4, // Seen 0111
        S5, // Seen 01111
        S6, // Seen 011111
        S7  // Seen 0111111
    } state_type;

    state_type current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    always @(*) begin
        // Default outputs
        disc = 0;
        flag = 0;
        err = 0;
        
        case (current_state)
            S0: begin
                if (in) next_state = S1;
                else next_state = S0;
            end
            
            S1: begin
                if (in) next_state = S2; // 1
                else next_state = S0;     // 0
            end
            
            S2: begin
                if (in) next_state = S3; // 1
                else next_state = S0;     // 0
            end
            
            S3: begin
                if (in) next_state = S4; // 1
                else next_state = S0;     // 0
            end
            
            S4: begin
                if (in) next_state = S5; // 1
                else next_state = S0;     // 0
            end
            
            S5: begin
                if (in) next_state = S6; // 1
                else next_state = S0;     // 0
            end
            
            S6: begin
                if (in) begin
                    next_state = S7;    // 1
                    err = 1;            // 7 or more 1s detected
                end else begin
                    next_state = S0;    // 0
                end
            end
            
            S7: begin
                err = 1;                 // Staying in error state
                if (in) next_state = S7; // 1
                else next_state = S0;     // 0
            end
            
            default: next_state = S0;
        endcase

        // Output conditions based on states
        if (current_state == S6 && in == 0) 
            disc = 1; // Transitioning from S6 (011111) to S0 (0)
        else if (current_state == S6 && in == 1) 
            flag = 1; // Transitioning from S6 to S7 (0111111 -> 01111110)
    end
endmodule