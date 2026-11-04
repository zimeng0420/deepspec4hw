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

    // First AND gate
    assign and1_out = a & b;

    // Second AND gate
    assign and2_out = c & d;

    // OR gate
    assign out = and1_out | and2_out;

    // NOT gate
    assign out_n = ~out;

endmodule