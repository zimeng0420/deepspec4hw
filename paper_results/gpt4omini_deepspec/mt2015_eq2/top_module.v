module top_module(
    input [1:0] A,
    input [1:0] B,
    output z
);

    wire eq1, eq0;

    assign eq1 = (A[1] == B[1]);
    assign eq0 = (A[0] == B[0]);
    assign z = eq1 & eq0;

endmodule