module top_module (
    input [4:1] x,
    output logic f
);
    // Implement the boolean expression derived from the K-map
    assign f = (x[1] & x[4]) | (x[2] & x[3]) | (x[3] & x[4]);
endmodule