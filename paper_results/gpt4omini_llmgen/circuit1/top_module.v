module top_module (
    input a, 
    input b, 
    output q
);
    assign q = a & b; // Output is the logical AND of inputs a and b
endmodule