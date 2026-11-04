# Web Research Results

Total Results: 1

## Result 1

The Verilog equality operator can be used to create a circuit that compares two 2-bit inputs A[1:0] and B[1:0] and produces an output z, where z is 1 if A = B, and 0 otherwise.

```verilog
module top_module(
    input [1:0] A,
    input [1:0] B,
    output z
);

    assign z = (A == B) ? 1 : 0;

endmodule
```

Digital magnitude comparators are essential building blocks in computer systems and are used in ALUs and memory address decoding.


---

