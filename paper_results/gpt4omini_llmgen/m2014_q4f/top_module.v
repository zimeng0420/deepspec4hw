module top_module (
    input logic in1,
    input logic in2,
    output logic out
);
    // Internal signal to hold the inverted value of in2
    logic in2_inv;

    // Invert the in2 signal
    assign in2_inv = ~in2;

    // AND operation with in1 and inverted in2
    assign out = in1 & in2_inv;
endmodule