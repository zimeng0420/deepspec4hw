# Web Research Results

Total Results: 1

## Result 1

Here's a Verilog implementation of a synchronous counter that counts from 0 to 999, inclusive, with a synchronous reset.

```verilog
module top_module(
    input clk,
    input reset,
    output reg [9:0] q
);

reg [9:0] cnt;

always @(posedge clk) begin
    if (reset) begin
        cnt <= 10'd0;
    end else if (cnt == 10'd999) begin
        cnt <= 10'd0;
    end else begin
        cnt <= cnt + 10'd1;
    end
end

assign q = cnt;

endmodule
```

**Explanation:**

*   **Module Declaration:** The code defines a module named `top_module` with an input clock (`clk`), a synchronous reset (`reset`), and a 10-bit output `q`.
*   **Internal Register:** Inside the module, a 10-bit register `cnt` is declared to hold the counter's current value.
*   **Synchronous Reset and Counting:** The `always` block is triggered at the positive edge of the clock signal.
    *   If `reset` is high, the counter `cnt` is reset to 0.
    *   If `cnt` is equal to 999, it is reset to 0, creating a period of 1000 cycles.
    *   Otherwise, the counter `cnt` is incremented by 1.
*   **Output Assignment:** The value of the counter `cnt` is assigned to the output `q`.

This design uses a synchronous reset, meaning the reset is only effective on the rising edge of the clock. The counter increments on each clock cycle until it reaches 999, then it wraps back to 0.


---

