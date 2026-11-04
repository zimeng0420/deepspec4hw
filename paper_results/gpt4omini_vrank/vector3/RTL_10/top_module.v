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
    
    assign concatenated = {a, b, c, d, e, f}; // Concatenating inputs
    
    assign w = {concatenated[29:22], 1'b1}; // Assigning 1st output
    assign x = {concatenated[21:14], 1'b1}; // Assigning 2nd output
    assign y = {concatenated[13:6], 1'b1};   // Assigning 3rd output
    assign z = {concatenated[5:0], 2'b11};    // Assigning 4th output with two 1's

endmodule