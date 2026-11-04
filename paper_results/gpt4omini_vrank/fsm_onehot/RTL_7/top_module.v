module top_module (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    assign next_state = (state[0]) ? (in ? 10'b0000000000 : 10'b0000000001) : // S0
                        (state[1]) ? (in ? 10'b0000000010 : 10'b0000000000) : // S1
                        (state[2]) ? (in ? 10'b0000000011 : 10'b0000000000) : // S2
                        (state[3]) ? (in ? 10'b0000000100 : 10'b0000000000) : // S3
                        (state[4]) ? (in ? 10'b0000000101 : 10'b0000000000) : // S4
                        (state[5]) ? (in ? 10'b0000001000 : 10'b0000000110) : // S5
                        (state[6]) ? (in ? 10'b0000001001 : 10'b0000000111) : // S6
                        (state[7]) ? (in ? 10'b0000000111 : 10'b0000000000) : // S7
                        (state[8]) ? (in ? 10'b0000000001 : 10'b0000000000) : // S8
                        (state[9]) ? (in ? 10'b0000000001 : 10'b0000000000) : // S9
                        10'b0000000000; // Default case (should not occur)

    assign out1 = state[7] | state[8] | state[9]; // Outputs for (0, 1)
    assign out2 = state[8]; // Outputs for (1, 0)

endmodule