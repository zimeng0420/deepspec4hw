# Web Research Results

Total Results: 1

## Result 1

The term "active-low synchronous reset" refers to a reset signal that, when low (logic 0), will reset a flip-flop on the next active clock edge (typically rising edge). The reset is synchronous because the reset action is synchronized with the clock signal.

Here's how to implement a 4-bit shift register with D flip-flops and an active-low synchronous reset in Verilog:

```verilog
module top_module (
    input clk,
    input resetn,
    input in,
    output out
);

  reg [3:0] shift_reg; // 4-bit shift register

  always @(posedge clk) begin
    if (~resetn) begin // Active-low synchronous reset
      shift_reg <= 4'b0000;
    end else begin
      shift_reg <= {shift_reg[2:0], in}; // Shift and load new input
    end
  end

  assign out = shift_reg[3]; // Output the most significant bit
endmodule
```

**Explanation:**

*   **Module Declaration:** The code defines a module named `top_module` with input signals for clock (`clk`), active-low reset (`resetn`), serial input (`in`), and a single output signal (`out`).
*   **Shift Register Declaration:** Inside the module, a 4-bit register `shift_reg` is declared to store the shift register's contents.
*   **Synchronous Reset and Shift Operation:** An `always` block is used to describe the sequential logic. This block is triggered by the positive edge of the clock signal (`posedge clk`).

    *   **Active-Low Synchronous Reset:** Inside the `always` block, an `if` statement checks the value of `resetn`. Because the reset is active-low, the condition is `~resetn`. If `resetn` is low (0), the `shift_reg` is reset to `4'b0000`. This reset occurs synchronously with the clock's rising edge.
    *   **Shift Operation:** If `resetn` is high (1), the `else` block is executed. This block performs the shift operation. The current value of `shift_reg` is shifted left by one bit, and the new input `in` is loaded into the least significant bit.
*   **Output Assignment:** Finally, the output `out` is assigned the value of the most significant bit (`shift_reg[3]`) of the shift register.

**Key Points:**

*   **Active-Low Reset:** The reset signal `resetn` is active-low, meaning the reset is asserted when the signal is low (0).
*   **Synchronous Reset:** The reset is synchronous, meaning the reset operation occurs on the rising edge of the clock signal.
*   **Non-Blocking Assignments:** Non-blocking assignments (`<=`) are used within the `always` block to ensure that all updates to the `shift_reg` occur concurrently at the end of the clock cycle.
*   **Shift Operation:**  The shift operation `{shift_reg[2:0], in}` shifts the register's contents to the left and introduces the input `in` into the rightmost bit.


---

