module top_module (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // Intermediate wires
    wire and_ab_out;
    wire and_cd_out;

    // Layer 1: AND gates
    and and_ab (
        .a(a),
        .b(b),
        .y(and_ab_out)
    );

    and and_cd (
        .a(c),
        .b(d),
        .y(and_cd_out)
    );

    // Layer 2: OR gate
    or or_out (
        .a(and_ab_out),
        .b(and_cd_out),
        .y(out)
    );

    // Inverter (NOT gate)
    not not_out (
        .in(out),
        .out(out_n)
    );

endmodule