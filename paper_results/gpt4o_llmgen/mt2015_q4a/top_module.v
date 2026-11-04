module top_module(
    input x,
    input y,
    output z
);

    wire xor_result;

    // Perform XOR operation
    assign xor_result = x ^ y;

    // Perform AND operation with x
    assign z = xor_result & x;

endmodule