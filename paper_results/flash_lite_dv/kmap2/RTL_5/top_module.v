module top_module (
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire not_a, not_b, not_c, not_d;
    wire and1, and2, and3, and4;

    not  not_a_gate (not_a, a);
    not  not_b_gate (not_b, b);
    not  not_c_gate (not_c, c);
    not  not_d_gate (not_d, d);

    and and1_gate (and1, not_a, not_c);
    and and2_gate (and2, not_b, d);
    and and3_gate (and3, not_a, b);
    and and4_gate (and4, b, c);

    or out_gate (out, and1, and2, and3, and4);

endmodule