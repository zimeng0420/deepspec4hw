module top_module (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    reg [3:0] state, next_state;
    reg disc_reg, flag_reg, err_reg;

    localparam S0 = 4'd0, // Initial state, equivalent to "previous input was 0"
               S1 = 4'd1, // '0' -> '1'
               S2 = 4'd2, // '01' -> '1'
               S3 = 4'd3, // '011' -> '1'
               S4 = 4'd4, // '0111' -> '1'
               S5 = 4'd5, // '01111' -> '1'
               S6 = 4'd6, // '011111' -> '0'
               S7 = 4'd7, // '0111111' -> '0'
               S8 = 4'd8; // '01111111...' Error state

    // State transition logic
    always @(*) begin
        next_state = state; // Default to stay in the same state
        disc_reg = 0;
        flag_reg = 0;
        err_reg = 0;
        
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: begin
                if (in) next_state = S7;
                else begin
                    flag_reg = 1;
                    next_state = S0;
                end
            end
            S7: begin
                if (in) next_state = S8;
                else begin
                    disc_reg = 1;
                    next_state = S0;
                end
            end
            S8: begin
                err_reg = 1;
                if (!in) next_state = S0;
            end
        endcase
    end

    // State registers
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic
    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule