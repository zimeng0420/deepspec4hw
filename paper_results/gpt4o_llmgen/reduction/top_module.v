module top_module (
    input [7:0] in,
    output parity
);

    // Calculate even parity using XOR reduction operator
    assign parity = ^in;

endmodule