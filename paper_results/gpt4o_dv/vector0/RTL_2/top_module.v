module top_module(
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);
    // Direct assignments
    assign outv = vec;  // Mirror input vector to output vector
    
    // Split vector into individual bits
    assign o0 = vec[0]; // Least significant bit
    assign o1 = vec[1]; // Middle bit
    assign o2 = vec[2]; // Most significant bit

endmodule