module top_module(
    input x,
    input y,
    output z
);

wire not_x;
wire not_y;
wire and1;
wire and2;

not(not_x, x);
not(not_y, y);
and(and1, not_x, not_y);
and(and2, x, y);
or(z, and1, and2);

endmodule