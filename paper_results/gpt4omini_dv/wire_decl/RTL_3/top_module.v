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

    assign and1_out = a & b; // First AND gate
    assign and2_out = c & d; // Second AND gate
    assign out = and1_out | and2_out; // OR gate
    assign out_n = ~out; // NOT gate

endmodule