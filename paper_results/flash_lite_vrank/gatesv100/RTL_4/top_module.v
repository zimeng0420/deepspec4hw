module top_module (
	input [99:0] in,
	output [98:0] out_both,
	output [99:1] out_any,
	output [99:0] out_different
);

  // (1) out_both: Each bit indicates if both current bit and left neighbour are 1
  genvar i;
  generate
    for (i = 0; i < 99; i = i + 1) begin: both_gen
      assign out_both[i] = in[i] & in[i+1];
    end
  endgenerate

  // (2) out_any: Each bit indicates if either current bit or right neighbour is 1
  genvar j;
  generate
    for (j = 1; j < 100; j = j + 1) begin: any_gen
      assign out_any[j] = in[j] | in[j-1];
    end
  endgenerate
  
  // (3) out_different: Each bit indicates if current bit is different from left neighbour. Wrap around.
  assign out_different[0] = in[0] ^ in[99];
  genvar k;
  generate
    for (k = 1; k < 100; k = k + 1) begin: diff_gen
        assign out_different[k] = in[k] ^ in[k-1];
    end
  endgenerate

endmodule