module top_module(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    wire and_ab_out;
    wire and_cd_out;

    assign and_ab_out = a & b;
    assign and_cd_out = c & d;
    assign out = and_ab_out | and_cd_out;
    assign out_n = ~out;

endmodule