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

assign w = {a, b, c, d};
assign x = {e, 3'b000}; // padding e to 8 bits
assign y = {f, 3'b000}; // padding f to 8 bits
assign z = 8'b00000011; // last two bits are 1

endmodule