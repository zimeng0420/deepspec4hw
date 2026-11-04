module top_module(
    input [2:0] vec, 
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);
    assign outv = vec; // Output vector is directly assigned from input vector
    assign o0 = vec[0]; // Least significant bit of input assigned to o0
    assign o1 = vec[1]; // Middle bit of input assigned to o1
    assign o2 = vec[2]; // Most significant bit of input assigned to o2
endmodule