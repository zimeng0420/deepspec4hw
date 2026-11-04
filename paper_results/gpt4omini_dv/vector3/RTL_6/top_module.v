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

    assign w = {a, b, c, d}; // Concatenate a, b, c, d into w
    assign x = {e, 3'b000};   // Assign e to x and fill the remaining bits
    assign y = {f, 3'b000};   // Assign f to y and fill the remaining bits
    assign z = {6'b000000, 2'b11}; // Assign 2'b11 in the LSB positions of z

endmodule