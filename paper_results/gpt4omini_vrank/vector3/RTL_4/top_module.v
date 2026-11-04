module top_module (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);
    wire [29:0] concatenated;
    
    assign concatenated = {a, b, c, d, e, f}; // Concatenate the 5-bit inputs

    assign w = {concatenated[29:22], 1'b1}; // First 8 bits + LSB 1
    assign x = {concatenated[21:14], 1'b1}; // Next 8 bits + LSB 1
    assign y = concatenated[13:6];          // Next 8 bits
    assign z = concatenated[5:0];           // Last 6 bits (but need 8 bits, so consider extra 0s)
    
    // Zero-fill the last two bits of z
    assign z = {concatenated[5:0], 2'b00};   // Filling with 2 additional 0s
    
endmodule