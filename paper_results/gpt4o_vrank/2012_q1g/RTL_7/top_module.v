module top_module (
    input [4:1] x,
    output logic f
);

    // Implementing the function based on given Karnaugh map
    assign f = (x[3] & ~x[2]) | (~x[1] & ~x[3] & ~x[4]) | (x[1] & x[2] & ~x[4]);

endmodule