module top_module (
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire a_not, b_not, c_not, d_not;
    wire and1, and2, and3, and4, and5, and6, and7, and8, and9;

    assign a_not = ~a;
    assign b_not = ~b;
    assign c_not = ~c;
    assign d_not = ~d;

    assign and1 = a_not & b_not & c_not & d_not;
    assign and2 = a_not & b_not & c & d_not;
    assign and3 = a_not & b & c_not & d_not;
    assign and4 = a_not & b & c & d;
    assign and5 = a & b_not & c_not & d_not;
    assign and6 = a & b_not & c & d_not;
    assign and7 = a & b & c_not & d_not;
    assign and8 = a & b & c & d;
    assign and9 = a & b_not & c & d;

    assign out = and1 | and2 | and3 | and4 | and5 | and6 | and7 | and8 | and9;

endmodule