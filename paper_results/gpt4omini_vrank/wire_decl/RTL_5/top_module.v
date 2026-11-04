module top_module (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

wire and1_out;
wire and2_out;

and AND1(and1_out, a, b);
and AND2(and2_out, c, d);
or OR1(out, and1_out, and2_out);
not NOT1(out_n, out);

endmodule