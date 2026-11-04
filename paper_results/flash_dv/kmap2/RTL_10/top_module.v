module top_module(
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire a_not, b_not, c_not, d_not;
    wire and1, and2, and3, and4, and5, and6, and7, and8, and9;

    not (a_not, a);
    not (b_not, b);
    not (c_not, c);
    not (d_not, d);

    and (and1, a_not, b_not, c_not, d_not);
    and (and2, a_not, b_not, c, d_not);
    and (and3, a_not, b, c_not, d_not);
    and (and4, a_not, b, c, d);
    and (and5, a, b_not, c_not, d_not);
    and (and6, a, b_not, c, d_not);
    and (and7, a, b, c_not, d_not);
    and (and8, a, b, c, d);
    and (and9, a, b_not, c, d);

    or (out, and1, and2, and3, and4, and5, and6, and7, and8, and9);

endmodule