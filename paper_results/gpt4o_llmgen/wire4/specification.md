```verilog
module top_module (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);

// Technical Specification:
// - Connect input 'a' directly to output 'w'.
// - Connect input 'b' directly to outputs 'x' and 'y'.
// - Connect input 'c' directly to output 'z'.

assign w = a; // Connection from input 'a' to output 'w'
assign x = b; // Connection from input 'b' to output 'x'
assign y = b; // Connection from input 'b' to output 'y'
assign z = c; // Connection from input 'c' to output 'z'

endmodule
```