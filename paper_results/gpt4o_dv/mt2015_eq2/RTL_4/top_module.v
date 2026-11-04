module top_module(
    input [1:0] A,
    input [1:0] B,
    output z
);

    // Perform bitwise comparison using XNOR for equality check
    wire xnor_1, xnor_0;
    assign xnor_1 = ~(A[1] ^ B[1]);
    assign xnor_0 = ~(A[0] ^ B[0]);

    // Combine the results of XNOR gates using AND gate for the final output
    assign z = xnor_1 & xnor_0;

endmodule