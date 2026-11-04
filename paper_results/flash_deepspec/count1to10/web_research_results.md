# Web Research Results

Total Results: 1

## Result 1

Here's a Verilog implementation of a decade counter that counts from 1 through 10, inclusive, with a synchronous reset that resets the counter to 1.

```verilog
module top_module(
    input clk,
    input reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd1;
        end else begin
            if (q == 4'd10) begin
                q <= 4'd1;
            end else begin
                q <= q + 1'b1;
            end
        end
    end

endmodule
```

**Explanation:**

*   **Module Definition:** The code defines a module named `top_module` with a clock input (`clk`), a reset input (`reset`), and a 4-bit output register `q`.
*   **Synchronous Reset:** The `always @(posedge clk)` block ensures that the counter's behavior is synchronized with the rising edge of the clock signal. Inside this block, the `if (reset)` statement checks if the reset signal is active. If it is, the counter `q` is immediately set to 1 (`4'd1`). This is a synchronous reset because the reset only takes effect on the rising edge of the clock.
*   **Counting Logic:** If the reset is not active, the `else` block is executed. This block first checks if the current value of `q` is equal to 10 (`if (q == 4'd10)`). If it is, the counter is reset to 1 (`q <= 4'd1`), creating the decade counter behavior. Otherwise, the counter is incremented by 1 (`q <= q + 1'b1`).
*   **4-bit Register:** The output `q` is declared as a 4-bit register (`output reg [3:0] q`), which means it can store values from 0 to 15. However, the logic ensures that it only counts from 1 to 10.
*   **Counting from 1 to 10:** The counter counts from 1 to 10 inclusively. When the reset input is active, the counter resets to 1. After reaching the value of 10, the counter resets to 1 on the next clock cycle.


---

