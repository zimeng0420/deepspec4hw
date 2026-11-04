module top_module(
    input [2:0] a, 
    input [2:0] b, 
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Compute bitwise OR
    assign out_or_bitwise = a | b;
    
    // Compute logical OR (if any bit of a or b is set, the result is 1)
    assign out_or_logical = |(a | b);
    
    // Compute bitwise NOT for a and b
    assign out_not[2:0] = ~a;
    assign out_not[5:3] = ~b;

endmodule