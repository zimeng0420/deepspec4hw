module top_module(
    input [2:0] vec, 
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    assign outv = vec;  // Route input vector to output vector
    assign o0 = vec[0]; // Assign vec[0] to output o0
    assign o1 = vec[1]; // Assign vec[1] to output o1
    assign o2 = vec[2]; // Assign vec[2] to output o2

endmodule