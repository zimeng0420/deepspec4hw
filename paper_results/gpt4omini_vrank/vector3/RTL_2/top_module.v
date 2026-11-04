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
    wire [29:0] concat_inputs;
    assign concat_inputs = {a, b, c, d, e, f};

    assign w = {concat_inputs[29:22], 2'b11};  // 8 bits: bits 29-22 and two 1s
    assign x = {concat_inputs[21:14], 2'b11};  // 8 bits: bits 21-14 and two 1s
    assign y = {concat_inputs[13:6], 2'b11};   // 8 bits: bits 13-6 and two 1s
    assign z = {concat_inputs[5:0], 2'b11};    // 8 bits: bits 5-0 and two 1s

endmodule