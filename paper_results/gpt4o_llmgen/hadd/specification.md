**Technical Specification for Half Adder Module:**

**Module Name:**
- `top_module`

**Purpose:**
- The half adder is a combinational circuit that performs the addition of two single binary digits. It generates a sum and a carry value.

**Inputs:**
1. `a`: A single-bit binary input.
2. `b`: A single-bit binary input.

**Outputs:**
1. `sum`: A single-bit output representing the sum of `a` and `b`.
2. `cout`: A single-bit output representing the carry-out from the addition of `a` and `b`.

**Functional Description:**
- To compute the `sum`, a simple XOR (exclusive OR) operation is used between inputs `a` and `b`.
  ```
  sum = a XOR b
  ```
- To compute the `cout`, an AND operation is used between inputs `a` and `b`.
  ```
  cout = a AND b
  ```

**Truth Table:**

| a | b | sum | cout |
|---|---|-----|------|
| 0 | 0 |  0  |  0   |
| 0 | 1 |  1  |  0   |
| 1 | 0 |  1  |  0   |
| 1 | 1 |  0  |  1   |

**Design Considerations:**
- This design does not handle carry-in and is intended solely for the addition of two single-bit inputs.
- No state storage; purely combinational logic.
- Implemented using basic logic gates (XOR, AND), common in hardware design.

**Constraints:**
- The inputs `a` and `b` must be binary (single bits: 0 or 1).

**Verilog Implementation:**
```verilog
module top_module (
    input a,
    input b,
    output sum,
    output cout
);
    assign sum = a ^ b;     // XOR operation for sum
    assign cout = a & b;    // AND operation for carry-out
endmodule
```