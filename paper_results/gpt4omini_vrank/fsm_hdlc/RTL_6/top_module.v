module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);
    typedef enum reg [2:0] {
        S0,  // Initial state
        S1,  // 0
        S2,  // 1
        S3,  // 11
        S4,  // 111
        S5,  // 1111
        S6,  // 11111
        S7,  // 111111
        S8   // 1111111
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        disc = 0;
        flag = 0;
        err = 0;
        case (state)
            S0: begin
                if (in == 1) 
                    next_state = S1;
                else 
                    next_state = S0;
            end
            S1: begin
                if (in == 1) 
                    next_state = S2;
                else 
                    next_state = S0;
            end
            S2: begin
                if (in == 1) 
                    next_state = S3;
                else 
                    next_state = S0;
            end
            S3: begin
                if (in == 1) 
                    next_state = S4;
                else 
                    next_state = S0;
            end
            S4: begin
                if (in == 1) 
                    next_state = S5;
                else 
                    next_state = S0;
            end
            S5: begin
                if (in == 1) 
                    next_state = S6;
                else 
                    next_state = S0;
            end
            S6: begin
                if (in == 1) 
                    next_state = S7;
                else 
                    next_state = S0;
            end
            S7: begin
                if (in == 1) 
                    next_state = S8;
                else 
                    next_state = S0;
            end
            S8: begin
                err = 1;
                next_state = S8;  // Stay in error state
            end
            default: next_state = S0;
        endcase

        // Output logic for disc and flag
        if (state == S6 && in == 0) 
            disc = 1;  // When reaching 0111110
        else if (state == S7 && in == 0) 
            flag = 1;  // When reaching 01111110
    end
endmodule