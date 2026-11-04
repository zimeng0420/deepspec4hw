module top_module (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    wire and_out1;  // Intermediate wire for first AND gate
    wire and_out2;  // Intermediate wire for second AND gate

    assign and_out1 = a & b;  // First AND gate
    assign and_out2 = c & d;  // Second AND gate
    assign out = and_out1 | and_out2;  // OR gate
    assign out_n = ~out;  // NOT gate

endmodule