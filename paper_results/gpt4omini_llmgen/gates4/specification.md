```verilog
module top_module (
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

// Internal wires for intermediate results
wire and_result;
wire or_result;
wire xor_result;

// 4-input AND gate
assign out_and = in[0] & in[1] & in[2] & in[3];

// 4-input OR gate
assign out_or = in[0] | in[1] | in[2] | in[3];

// 4-input XOR gate
assign out_xor = in[0] ^ in[1] ^ in[2] ^ in[3];

endmodule
```