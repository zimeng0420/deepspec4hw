# Web Research Results

Total Results: 1

## Result 1

A half adder is a combinational logic circuit designed to add two binary digits. It has two inputs, typically labeled A and B, and two outputs: Sum (S) and Carry (C). The Sum output represents the result of the addition, while the Carry output indicates whether there is a carry-out.

**Truth Table**

The truth table for a half adder is as follows:

| Input A | Input B | Output S | Output C |
| :------ | :------ | :------- | :------- |
| 0       | 0       | 0        | 0        |
| 0       | 1       | 1        | 0        |
| 1       | 0       | 1        | 0        |
| 1       | 1       | 0        | 1        |

**Operation**

The half adder performs binary addition according to these rules:

*   0 + 0 = 0
*   0 + 1 = 1
*   1 + 0 = 1
*   1 + 1 = 10 (Sum = 0, Carry = 1)

The Sum output is the result of an XOR operation on the inputs A and B (S = A XOR B), and the Carry output is the result of an AND operation on the inputs A and B (C = A AND B).

**Implementation**

A half adder can be implemented using an XOR gate for the Sum and an AND gate for the Carry. It can also be implemented using NAND or NOR gates.

**Limitations**

A half adder can only add two single-bit numbers and does not have a carry-in input. This means it cannot add a carry from a previous addition stage.



---

