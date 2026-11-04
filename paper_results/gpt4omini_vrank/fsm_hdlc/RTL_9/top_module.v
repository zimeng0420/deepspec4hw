module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [3:0] state, next_state;
    parameter S0 = 4'b0000, // Initial/reset state
              S1 = 4'b0001, // 0
              S2 = 4'b0010, // 01
              S3 = 4'b0011, // 011
              S4 = 4'b0100, // 0111
              S5 = 4'b0101, // 01111
              S6 = 4'b0110, // 011111
              S7 = 4'b0111; // 0111111 (err)

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            state <= next_state;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end
    end

    always @(*) begin
        case (state)
            S0: begin
                if (in == 0)
                    next_state = S0;
                else
                    next_state = S1;
            end
            S1: begin
                if (in == 0)
                    next_state = S0;
                else
                    next_state = S2;
            end
            S2: begin
                if (in == 0)
                    next_state = S0;
                else
                    next_state = S3;
            end
            S3: begin
                if (in == 0)
                    next_state = S0;
                else
                    next_state = S4;
            end
            S4: begin
                if (in == 0)
                    next_state = S0;
                else
                    next_state = S5;
            end
            S5: begin
                if (in == 0) begin
                    disc <= 1; // Signal discard of last bit
                    next_state = S0;
                end else
                    next_state = S6;
            end
            S6: begin
                if (in == 0) begin
                    flag <= 1; // Signal frame flag detected
                    next_state = S0;
                end else
                    next_state = S7; // Error state
            end
            S7: begin
                err <= 1; // Signal error for 7 or more 1s
                next_state = S7; // Remain in error state
            end
            default: next_state = S0; // Safe default
        endcase
    end

endmodule