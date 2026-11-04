module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    typedef enum reg [3:0] { 
        S0, // Initial state
        S1, // 0
        S2, // 01
        S3, // 011
        S4, // 0111
        S5, // 01111
        S6, // 011111
        S7, // 0111111 (err state for 7 or more)
        FLAG, // 01111110 (frame flag)
        DISC // 0111110 (discard bit)
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) 
            current_state <= S0;
        else 
            current_state <= next_state;
    end

    always @(*) begin
        disc = 0;
        flag = 0;
        err = 0;
        case (current_state)
            S0: begin
                if (in) next_state = S1; 
                else next_state = S0;
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
                    disc = 1; // 0111110 detected
                    next_state = S0;
                end
            end
            S6: begin
                if (in) begin
                    flag = 1; // 01111110 (frame flag) detected
                    next_state = S0;
                end
                else begin
                    err = 1; // 7 or more 1s detected
                    next_state = S7;
                end
            end
            S7: begin
                if (in) next_state = S7; // stay in error state
                else next_state = S0; // reset to initial state
            end
        endcase
    end
endmodule