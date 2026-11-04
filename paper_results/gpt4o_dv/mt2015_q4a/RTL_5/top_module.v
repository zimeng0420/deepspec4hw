module top_module(
    input x,
    input y,
    output z);

    // Implement the Boolean function z = (x XOR y) AND x
    assign z = (x ^ y) & x;

endmodule