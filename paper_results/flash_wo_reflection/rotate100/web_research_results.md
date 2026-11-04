# Web Research Results

Total Results: 1

## Result 1

A 100-bit left/right rotator can be built with synchronous load and left/right enable. A rotator shifts in the shifted-out bit from the other end of the register, unlike a shifter that discards the shifted-out bit and shifts in a zero. When enabled, a rotator rotates the bits around and does not modify or discard them.

Here's a breakdown of the functionality:

1.  **Load:** Loads the shift register with `data[99:0]` instead of rotating. This is a synchronous active-high load.
2.  **Enable (ena[1:0]):** This synchronous input chooses whether and which direction to rotate:
    *   `2'b01`: Rotates right by one bit.
    *   `2'b10`: Rotates left by one bit.
    *   `2'b00` and `2'b11`: Do not rotate.
3.  **q:** Represents the contents of the rotator.

Module definition:

```verilog
module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);
```

---

