# Web Research Results

Total Results: 1

## Result 1

Here's a Verilog module that splits a 16-bit input into two 8-bit outputs, suitable for a combinational circuit:

```verilog
module top_module (
    input [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    assign out_lo = in[7:0];   // Lower byte [4]
    assign out_hi = in[15:8];  // Upper byte [4]

endmodule
```

**Explanation:**

*   **Module Definition:** The code defines a module named `top_module` with a 16-bit input `in`, and two 8-bit outputs `out_hi` and `out_lo`.
*   **Assignments:**
    *   `assign out_lo = in[7:0];` This line extracts the lower 8 bits (bits 0 through 7) from the input `in` and assigns them to the output `out_lo`.
    *   `assign out_hi = in[15:8];` This line extracts the upper 8 bits (bits 8 through 15) from the input `in` and assigns them to the output `out_hi`.
*   **Combinational Logic:** The `assign` statements create combinational logic, meaning the outputs will update automatically whenever the input `in` changes.


---

