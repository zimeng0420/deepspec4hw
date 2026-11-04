module top_module(
    input x,
    input y,
    output z
);
    // Combinational logic
    assign z = (~x & ~y) | (x & y);
endmodule