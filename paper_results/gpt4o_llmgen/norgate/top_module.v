module top_module(
    input a, 
    input b,
    output out
);

    // Continuous assignment for NOR operation
    assign out = ~(a | b);

endmodule