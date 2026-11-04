module top_module (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);
    // Combinatorial logic for next state
    always @(*) begin
        next_state = 10'b0000000000; // Default next state
        case (1'b1) // case on the one-hot encoding
            state[0]: next_state[0] = (in == 0) ? 1 : 0; next_state[1] = (in == 1) ? 1 : 0;
            state[1]: next_state[0] = (in == 0) ? 1 : 0; next_state[2] = (in == 1) ? 1 : 0;
            state[2]: next_state[0] = (in == 0) ? 1 : 0; next_state[3] = (in == 1) ? 1 : 0;
            state[3]: next_state[0] = (in == 0) ? 1 : 0; next_state[4] = (in == 1) ? 1 : 0;
            state[4]: next_state[0] = (in == 0) ? 1 : 0; next_state[5] = (in == 1) ? 1 : 0;
            state[5]: next_state[8] = (in == 0) ? 1 : 0; next_state[6] = (in == 1) ? 1 : 0;
            state[6]: next_state[9] = (in == 0) ? 1 : 0; next_state[7] = (in == 1) ? 1 : 0;
            state[7]: next_state[0] = (in == 0) ? 1 : 0; next_state[7] = (in == 1) ? 1 : 0;
            state[8]: next_state[0] = (in == 0) ? 1 : 0; next_state[1] = (in == 1) ? 1 : 0;
            state[9]: next_state[0] = (in == 0) ? 1 : 0; next_state[1] = (in == 1) ? 1 : 0;
        endcase
    end
    
    // Output logic
    assign out1 = state[7] | state[8] | state[9]; // High when in S7, S8 or S9
    assign out2 = state[7]; // High only when in S7

endmodule