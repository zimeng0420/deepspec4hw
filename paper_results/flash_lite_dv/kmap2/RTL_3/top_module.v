module top_module (
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire not_a, not_b, not_c, not_d;
    wire and1_out, and2_out, and3_out, and4_out;

    not #(1) not_a_gate (not_a, a);
    not #(1) not_b_gate (not_b, b);
    not #(1) not_c_gate (not_c, c);
    not #(1) not_d_gate (not_d, d);

    and #(1) and1 (and1_out, not_a, not_c);
    and #(1) and2 (and2_out, not_b, d);
    and #(1) and3 (and3_out, not_a, b);
    and #(1) and4 (and4_out, b, c);

    or #(1) or1 (out, and1_out, and2_out, and3_out, and4_out);

endmodule