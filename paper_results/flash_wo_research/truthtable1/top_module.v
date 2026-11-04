module top_module (
    input x3,
    input x2,
    input x1,
    output f
);

    wire not_x3;
    wire and1_out;
    wire or1_out;
    wire and2_out;

    assign not_x3 = ~x3;
    assign and1_out = x2 & not_x3;
    assign or1_out = x2 | x3;
    assign and2_out = x1 & or1_out;
    assign f = and1_out | and2_out;

endmodule