module top_module (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    wire [29:0] concatenated_inputs;
    assign concatenated_inputs = {a, b, c, d, e, f};

    assign w = concatenated_inputs[29:22]; // 8 bits from the first part
    assign x = concatenated_inputs[21:14]; // 8 bits from the second part
    assign y = concatenated_inputs[13:6];  // 8 bits from the third part
    assign z = {concatenated_inputs[5:0], 2'b11}; // 6 bits from the last part and two 1's

endmodule