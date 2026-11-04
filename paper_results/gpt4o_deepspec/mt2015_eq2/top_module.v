module top_module(
    input [1:0] A,
    input [1:0] B,
    output z
);

    // Compare corresponding bits of A and B with XNOR gates
    wire xnor0, xnor1;
    assign xnor0 = ~(A[0] ^ B[0]); // XNOR gate for least significant bits
    assign xnor1 = ~(A[1] ^ B[1]); // XNOR gate for most significant bits

    // Combine results of XNOR gates using AND gate
    assign z = xnor0 & xnor1; // If both bits match, z = 1, otherwise z = 0

endmodule