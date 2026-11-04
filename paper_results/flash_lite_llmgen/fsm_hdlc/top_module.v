module top_module (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7;
    reg [2:0] state, next_state;
    reg disc_reg, flag_reg, err_reg;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state and output logic
    always @(*) begin
        next_state = state;
        disc_reg = 1'b0;
        flag_reg = 1'b0;
        err_reg = 1'b0;

        case (state)
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
                else begin
                    next_state = S0;
                    disc_reg = 1'b1;
                end
            end
            S6: begin
                if (in)
                    next_state = S7;
                else begin
                    next_state = S0;
                    flag_reg = 1'b1;
                end
            end
            S7: begin
                next_state = S7;
                err_reg = 1'b1;
            end
            default: next_state = S0;
        endcase
    end

    // Output registers
    always @(posedge clk) begin
        disc <= disc_reg;
        flag <= flag_reg;
        err <= err_reg;
    end

endmodule