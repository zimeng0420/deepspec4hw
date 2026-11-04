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
assign x = {e, 3'b000};
assign y = {f, 3'b000};
assign z = {2'b11, 6'b000000};

endmodule