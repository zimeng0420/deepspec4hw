module top_module (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // State Definitions (One-Hot Encoding)
    localparam S0 = 0;
    localparam S1 = 1;
    localparam S2 = 2;
    localparam S3 = 3;
    localparam S4 = 4;
    localparam S5 = 5;
    localparam S6 = 6;
    localparam S7 = 7;
    localparam S8 = 8;
    localparam S9 = 9;

    // Next State Logic (Derived from state transition diagram)
    always @(*) begin
        case (1'b1) // Using a case statement for clarity, though if-else could also be used.
            1'b1: begin // Always execute this case
                next_state[S0] = (state[S0] & ~in) | (state[S1] & ~in) | (state[S2] & ~in) | (state[S3] & ~in) | (state[S4] & ~in) | (state[S7] & ~in) | (state[S8] & ~in) | (state[S9] & ~in);
                next_state[S1] = (state[S0] & in) | (state[S8] & in) | (state[S9] & in);
                next_state[S2] = (state[S1] & in);
                next_state[S3] = (state[S2] & in);
                next_state[S4] = (state[S3] & in);
                next_state[S5] = (state[S4] & in);
                next_state[S6] = (state[S5] & in);
                next_state[S7] = (state[S6] & in) | (state[S7] & in);
                next_state[S8] = (state[S5] & ~in);
                next_state[S9] = (state[S6] & ~in);
            end
        endcase
    end

    // Output Logic (Derived from state transition diagram)
    assign out1 = state[S8] | state[S9];
    assign out2 = state[S7] | state[S9];

endmodule