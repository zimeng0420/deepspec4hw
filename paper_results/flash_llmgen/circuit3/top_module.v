module top_module (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire ab = a & b;
    wire ac = a & c;
    wire ad = a & d;
    wire bc = b & c;
    wire bd = b & d;
    wire cd = c & d;

    assign q = ab | ac | ad | bc | bd | cd;

endmodule