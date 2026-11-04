module top_module (
	input [254:0] in,
	output reg [7:0] out
);

  reg [7:0] count_intermediate_0;
  reg [7:0] count_intermediate_1;
  reg [7:0] count_intermediate_2;
  reg [7:0] count_intermediate_3;
  reg [7:0] count_intermediate_4;
  reg [7:0] count_intermediate_5;
  reg [7:0] count_intermediate_6;
  reg [7:0] count_intermediate_7;


  always @(*) begin
    count_intermediate_0 = 0;
	  count_intermediate_1 = 0;
	  count_intermediate_2 = 0;
	  count_intermediate_3 = 0;
	  count_intermediate_4 = 0;
	  count_intermediate_5 = 0;
	  count_intermediate_6 = 0;
	  count_intermediate_7 = 0;
	  out = 0;
    // Stage 1: 1-bit population counts for 8-bit segments, using reduce or operator
    for (integer i = 0; i < 32; i = i + 1) begin
        count_intermediate_0[i] = in[i*8+0] + in[i*8+1] + in[i*8+2] + in[i*8+3] + in[i*8+4] + in[i*8+5] + in[i*8+6] + in[i*8+7];
		count_intermediate_1[i] = in[i*8+8] + in[i*8+9] + in[i*8+10] + in[i*8+11] + in[i*8+12] + in[i*8+13] + in[i*8+14] + in[i*8+15];
		count_intermediate_2[i] = in[i*8+16] + in[i*8+17] + in[i*8+18] + in[i*8+19] + in[i*8+20] + in[i*8+21] + in[i*8+22] + in[i*8+23];
		count_intermediate_3[i] = in[i*8+24] + in[i*8+25] + in[i*8+26] + in[i*8+27] + in[i*8+28] + in[i*8+29] + in[i*8+30] + in[i*8+31];
    end
    for (integer i = 0; i < 32; i = i + 1) begin
        count_intermediate_4[i] = in[i*8+32] + in[i*8+33] + in[i*8+34] + in[i*8+35] + in[i*8+36] + in[i*8+37] + in[i*8+38] + in[i*8+39];
		count_intermediate_5[i] = in[i*8+40] + in[i*8+41] + in[i*8+42] + in[i*8+43] + in[i*8+44] + in[i*8+45] + in[i*8+46] + in[i*8+47];
		count_intermediate_6[i] = in[i*8+48] + in[i*8+49] + in[i*8+50] + in[i*8+51] + in[i*8+52] + in[i*8+53] + in[i*8+54] + in[i*8+55];
		count_intermediate_7[i] = in[i*8+56] + in[i*8+57] + in[i*8+58] + in[i*8+59] + in[i*8+60] + in[i*8+61] + in[i*8+62] + in[i*8+63];
    end

    // Stage 2: Combine 8-bit segments using adders (32-bit inputs for count_intermediate_0 to count_intermediate_7)
    out = 0;
    for (integer i = 0; i < 32; i = i + 1) begin
        out = out + count_intermediate_0[i] + count_intermediate_1[i] + count_intermediate_2[i] + count_intermediate_3[i] + count_intermediate_4[i] + count_intermediate_5[i] + count_intermediate_6[i] + count_intermediate_7[i];
    end

  end
endmodule