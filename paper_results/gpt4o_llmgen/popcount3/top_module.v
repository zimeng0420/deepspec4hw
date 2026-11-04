module top_module (
    input [2:0] in,
    output [1:0] out
);

    // Intermediate signals to hold each bit of the count
    wire bit0, bit1, bit2;

    // Assign each bit of the input to intermediate signals, indicating presence of 1 in corresponding position
    assign bit0 = in[0];       // LSB check
    assign bit1 = in[1];       // Middle bit check
    assign bit2 = in[2];       // MSB check

    // Summing up the number of 1's using addition
    assign out = bit0 + bit1 + bit2;

endmodule