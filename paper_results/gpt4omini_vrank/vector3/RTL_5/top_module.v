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
    wire [29:0] concatenated_data;

    assign concatenated_data = {a, b, c, d, e, f}; // Concatenate inputs
    assign {z, y, x, w} = {concatenated_data, 2'b11}; // Append two 1's and split into outputs
endmodule