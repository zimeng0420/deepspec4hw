# Web Research Results

Total Results: 1

## Result 1

A Galois LFSR is a shift register where bit positions with a "tap" are XORed with the output bit to produce its next value, while bit positions without a tap shift. If the taps positions are carefully chosen, the LFSR can be made to be "maximum-length". A maximum-length LFSR of *n* bits cycles through 2^*n*-1 states before repeating (the all-zero state is never reached).

**Design Principles:**

*   **Taps:** For a 5-bit maximal-length Galois LFSR, taps are typically at bit positions 5 and 3. Tap positions are usually numbered starting from 1.
*   **Maximum Length Sequence:** A maximum-length LFSR produces an m-sequence (cycles through all possible 2^m - 1 states within the shift register except the all-zeros state).
*   **Feedback Polynomial:** The arrangement of taps for feedback in an LFSR can be expressed as a polynomial mod 2. The LFSR is maximal-length if and only if the corresponding feedback polynomial is primitive over the Galois field GF(2).
*   The number of taps is even.
*   The set of taps is setwise co-prime; i.e., there must be no divisor other than 1 common to all taps.

**Implementation Steps:**

1.  **Galois Configuration:** In a Galois configuration, bits that are not taps are shifted one position to the right unchanged. The taps, on the other hand, are XORed with the output bit before they are stored in the next position. The new output bit is the next input bit.
2.  **Reset State:** The reset should reset the LFSR output to 1.
3.  **Clocking:** When the system is clocked, the register updates its state based on the tap positions and XOR operations.
4.  **Output:** The output is taken from one of the register bits.

**Verilog Implementation:**

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

In this Verilog code:

*   `clk` is the clock input.
*   `reset` is the active-high synchronous reset input.
*   `q` is the 5-bit output register.

Upon reset, the register `q` is initialized to 1. Otherwise, on each clock cycle, the next state is computed by shifting and XORing the appropriate bits.


---

