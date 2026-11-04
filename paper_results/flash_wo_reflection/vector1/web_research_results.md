# Web Research Results

Total Results: 1

## Result 1

In Verilog, bit slicing allows you to select a contiguous group of bits from a vector. This is also referred to as "part select". You can extract the lower and upper bytes of a 16-bit input using bit slicing.

To split a 16-bit input into lower [7:0] and upper [15:8] bytes in Verilog, you can directly assign the corresponding bit ranges to the output ports.

```verilog
module top_module (
    input [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    assign out_lo = in[7:0];   // Lower byte: bits 7 to 0
    assign out_hi = in[15:8];  // Upper byte: bits 15 to 8

endmodule
```

*   `in[7:0]` selects bits 7 through 0 of the input `in`, which corresponds to the lower byte.
*   `in[15:8]` selects bits 15 through 8 of the input `in`, which corresponds to the upper byte.


---

