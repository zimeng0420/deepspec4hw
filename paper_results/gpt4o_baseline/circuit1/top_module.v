module top_module (
    input a,
    input b,
    output q
);
    assign q = a & b; // q is 1 only when both a and b are 1
endmodule