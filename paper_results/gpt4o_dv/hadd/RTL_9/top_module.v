module top_module (
    input a,
    input b,
    output sum,
    output cout
);

    // XOR gate provides the sum.
    assign sum = a ^ b;

    // AND gate provides the carry-out.
    assign cout = a & b;

endmodule