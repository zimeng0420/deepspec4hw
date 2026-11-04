module top_module(
    input [1:0] A,
    input [1:0] B,
    output z
);
    wire eq1, eq0;

    assign eq1 = (A[1] ~^ B[1]); // XNOR for the most significant bits
    assign eq0 = (A[0] ~^ B[0]); // XNOR for the least significant bits
    assign z = eq1 & eq0;        // AND gate to determine equality

endmodule