# Web Research Results

Total Results: 1

## Result 1

Here's a Verilog implementation of a 4-bit right shift register, incorporating asynchronous reset, synchronous load, and enable signals, based on the search results:

```verilog
module top_module(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q <= 4'b0; // Asynchronous reset to zero [7].
        end else begin
            if (load) begin
                q <= data; // Load data if load is asserted [4, 10].
            end else if (ena) begin
                q <= {1'b0, q[3:1]}; // Shift right if enable is asserted. Q[3] becomes zero, and q[0] is shifted out and disappears [4, 14].
            end else begin
                q <= q; // Maintain the current value if neither load nor ena is asserted.
            end
        end
    end

endmodule
```

**Explanation:**

*   **Module Declaration:** Defines the module `top_module` with the specified inputs and outputs.
*   **Inputs:**
    *   `clk`: Clock signal.
    *   `areset`: Asynchronous positive edge-triggered reset.
    *   `load`: Synchronous active-high load signal.
    *   `ena`: Synchronous active-high enable signal for shifting.
    *   `data[3:0]`: 4-bit data input for loading.
*   **Output:**
    *   `q[3:0]`: 4-bit output register representing the contents of the shift register.
*   **Asynchronous Reset:** The `always @(posedge clk or posedge areset)` block ensures that the reset is triggered by a positive edge on the `areset` signal. When `areset` is asserted, the shift register `q` is reset to zero.
*   **Synchronous Load and Enable:** Inside the `else` block (when `areset` is not active), the code checks for the `load` and `ena` signals on the positive edge of the clock.
*   **Priority:** If both `load` and `ena` are asserted, the `load` input has higher priority, as specified in the problem description.
*   **Shift Right Operation:** If `ena` is asserted and `load` is not, the shift register shifts its contents to the right. The most significant bit (MSB) `q[3]` is set to 0, and the least significant bit (LSB) `q[0]` is shifted out and disappears.
*   **Data Retention:** If neither `load` nor `ena` is asserted, the shift register retains its current value.


---

