module top_module (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);

    // Direct connections (wire-like behavior)
    assign w = a;
    assign x = b;
    assign y = b;
    assign z = c;

endmodule