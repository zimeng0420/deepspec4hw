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

    // First layer of AND gates
    and AND1 (and1_out, a, b);
    and AND2 (and2_out, c, d);

    // Second layer OR gate
    or OR1 (out, and1_out, and2_out);

    // NOT gate for inverted output
    not NOT1 (out_n, out);
endmodule