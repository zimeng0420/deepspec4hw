module top_module (
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire not_a, not_b, not_c, not_d;
    wire and1_out, and2_out, and3_out, and4_out;

    not #(1) not_a_inst (
        .in(a),
        .out(not_a)
    );

    not #(1) not_b_inst (
        .in(b),
        .out(not_b)
    );

    not #(1) not_c_inst (
        .in(c),
        .out(not_c)
    );

    not #(1) not_d_inst (
        .in(d),
        .out(not_d)
    );

    and #(1) and1_inst (
        .in1(not_a),
        .in2(not_c),
        .out(and1_out)
    );

    and #(1) and2_inst (
        .in1(not_b),
        .in2(d),
        .out(and2_out)
    );

    and #(1) and3_inst (
        .in1(not_a),
        .in2(b),
        .out(and3_out)
    );

    and #(1) and4_inst (
        .in1(b),
        .in2(c),
        .out(and4_out)
    );

    or #(1) or_inst (
        .in1(and1_out),
        .in2(and2_out),
        .in3(and3_out),
        .in4(and4_out),
        .out(out)
    );

endmodule