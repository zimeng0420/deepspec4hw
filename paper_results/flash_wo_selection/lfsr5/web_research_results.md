# Web Research Results

Total Results: 1

## Result 1

A Galois LFSR is a type of linear feedback shift register where the input bit is XORed with the output bit to produce the next value for bit positions with a "tap". Bit positions without a tap simply shift. In a Galois LFSR, the feedback bits affect several positions in the register. This configuration, also known as modular, internal XORs, or one-to-many LFSR, can generate the same output stream as a conventional LFSR but with a time offset.

**Concept Definitions:**

*   **Galois LFSR:** A specific arrangement where bit positions with a "tap" are XORed with the output bit to produce its next value, while bit positions without a tap shift.
*   **Maximum-Length LFSR:** If the tap positions are carefully chosen, the LFSR can be made to be "maximum-length", cycling through 2<sup>n</sup>-1 states before repeating for an n-bit LFSR. The all-zero state is never reached.
*   **Taps:** Selected bits in the shift register that determine the feedback function. The feedback function is generally an exclusive OR of the values of the tapped bits in the shift register.

**Working Principles:**

*   In a Galois configuration, bits that are not taps are shifted one position to the right unchanged when the system is clocked.
*   The taps, on the other hand, are XORed with the output bit before they are stored in the next position. The new output bit is the next input bit.
*   Galois LFSRs do not concatenate every tap to produce the new input. The XORing is done within the LFSR, and no XOR gates are run in serial. Each tap can be computed in parallel, increasing the speed of execution.

**Design Methods and Considerations:**

*   The LFSR is maximal-length if and only if the corresponding feedback polynomial is primitive over the Galois field GF(2).
*   The number of bits that can be produced by an LFSR is based on its characteristic polynomial and can be as large as 2<sup>n</sup>-1 for an n-bit LFSR.
*   Circuits of LFSRs are easy to construct or program, consisting of shift registers and XOR gates.
*   The Galois form is generally faster than the Fibonacci form in hardware due to the reduced number of logic gates in the feedback loop.
*   In a software implementation of an LFSR, the Galois form is more efficient, as the XOR operations can be implemented a word at a time.

**Module for a 5-bit maximal-length Galois LFSR with taps at bit positions 5 and 3:**

```verilog
module top_module(
    input clk,
    input reset,
    output reg [4:0] q
);
always @(posedge clk) begin
    if (reset)
        q <= 5'd1;
    else
        q <= {q[0], q[4], (q[0] ^ q[3]), q[2], q[1]};
end
endmodule
```

---

