module top_module(
    input a,
    input b,
    output out
);

    assign out = ~(a ^ b);  // XNOR is the inverse of XOR

    // Alternative implementations (functionally equivalent):
    // assign out = a == b;
    // assign out = (a & b) | (~a & ~b);

endmodule