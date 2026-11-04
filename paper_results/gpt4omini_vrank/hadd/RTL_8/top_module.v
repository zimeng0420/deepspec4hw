module top_module (
    input a,
    input b,
    output sum,
    output cout
);
    assign sum = a ^ b;   // compute sum
    assign cout = a & b;  // compute carry-out
endmodule