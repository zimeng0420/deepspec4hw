module top_module (
    input  [1023:0] in,
    input  [7:0]   sel,
    output [3:0]   out
);

  // Calculate the starting bit index for the selected 4-bit group.
  // Multiply sel by 4 because each group is 4 bits wide.
  // This is the most efficient way to calculate the starting bit.
  assign out = in[ (sel * 4) +: 4 ]; // Concatenation operator for bit selection

endmodule