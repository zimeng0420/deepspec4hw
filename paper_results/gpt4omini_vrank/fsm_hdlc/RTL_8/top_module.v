module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);
    typedef enum logic [2:0] {
        S0, // Initial State
        S1, // 0
        S2, // 01
        S3, // 011
        S4, // 0111
        S5, // 01111
        S6, // 011111
        S7  // 0111111
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    always_ff @(posedge clk) begin
        disc <= 0;
        flag <= 0;
        err <= 0;

        case (current_state)
            S0: begin
                if (in == 1)
                    next_state <= S1;
                else
                    next_state <= S0;
            end
            S1: begin
                if (in == 1)
                    next_state <= S2;
                else
                    next_state <= S0;
            end
            S2: begin
                if (in == 1)
                    next_state <= S3;
                else
                    next_state <= S0;
            end
            S3: begin
                if (in == 1)
                    next_state <= S4;
                else
                    next_state <= S0;
            end
            S4: begin
                if (in == 1)
                    next_state <= S5;
                else
                    next_state <= S0;
            end
            S5: begin
                if (in == 1)
                    next_state <= S6;
                else
                    next_state <= S0;
            end
            S6: begin
                if (in == 1)
                    next_state <= S7;
                else
                    begin
                        disc <= 1;
                        next_state <= S0;
                    end
            end
            S7: begin
                err <= 1;
                next_state <= S0;
            end
            default: next_state <= S0;
        endcase

        if (current_state == S6 && in == 0) begin
            flag <= 1; // Flag sequence detected
        end
    end
endmodule