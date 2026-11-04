module top_module (
    input  [254:0] in,
    output reg [7:0] out
);

  // Internal wires
  wire [3:0] count0, count1, count2, count3, count4, count5, count6, count7, count8, count9, count10, count11, count12, count13, count14, count15;
  wire [3:0] count16, count17, count18, count19, count20, count21, count22, count23, count24, count25, count26, count27, count28, count29, count30, count31;


  // 8-bit population count modules (optimized using 8-bit LUT)
  popcount8 pc0  ( .in(in[7:0]),  .out(count0) );
  popcount8 pc1  ( .in(in[15:8]), .out(count1) );
  popcount8 pc2  ( .in(in[23:16]), .out(count2) );
  popcount8 pc3  ( .in(in[31:24]), .out(count3) );
  popcount8 pc4  ( .in(in[39:32]), .out(count4) );
  popcount8 pc5  ( .in(in[47:40]), .out(count5) );
  popcount8 pc6  ( .in(in[55:48]), .out(count6) );
  popcount8 pc7  ( .in(in[63:56]), .out(count7) );
  popcount8 pc8  ( .in(in[71:64]), .out(count8) );
  popcount8 pc9  ( .in(in[79:72]), .out(count9) );
  popcount8 pc10 ( .in(in[87:80]), .out(count10) );
  popcount8 pc11 ( .in(in[95:88]), .out(count11) );
  popcount8 pc12 ( .in(in[103:96]), .out(count12) );
  popcount8 pc13 ( .in(in[111:104]), .out(count13) );
  popcount8 pc14 ( .in(in[119:112]), .out(count14) );
  popcount8 pc15 ( .in(in[127:120]), .out(count15) );
  popcount8 pc16 ( .in(in[135:128]), .out(count16) );
  popcount8 pc17 ( .in(in[143:136]), .out(count17) );
  popcount8 pc18 ( .in(in[151:144]), .out(count18) );
  popcount8 pc19 ( .in(in[159:152]), .out(count19) );
  popcount8 pc20 ( .in(in[167:160]), .out(count20) );
  popcount8 pc21 ( .in(in[175:168]), .out(count21) );
  popcount8 pc22 ( .in(in[183:176]), .out(count22) );
  popcount8 pc23 ( .in(in[191:184]), .out(count23) );
  popcount8 pc24 ( .in(in[199:192]), .out(count24) );
  popcount8 pc25 ( .in(in[207:200]), .out(count25) );
  popcount8 pc26 ( .in(in[215:208]), .out(count26) );
  popcount8 pc27 ( .in(in[223:216]), .out(count27) );
  popcount8 pc28 ( .in(in[231:224]), .out(count28) );
  popcount8 pc29 ( .in(in[239:232]), .out(count29) );
  popcount8 pc30 ( .in(in[247:240]), .out(count30) );
  popcount8 pc31 ( .in(in[254:248]), .out({count31[3:0], 1'b0, 1'b0, 1'b0}) );  // Handle the extra bits.  Padding as needed.
  // Adders to sum the counts.  Using a tree structure to keep critical path small

  wire [5:0] sum1, sum2, sum3, sum4;
  wire [6:0] sum5;
  wire [7:0] sum_final;

  // Stage 1: sum of counts
  assign sum1 = count0 + count1 + count2 + count3;
  assign sum2 = count4 + count5 + count6 + count7;
  assign sum3 = count8 + count9 + count10 + count11;
  assign sum4 = count12 + count13 + count14 + count15;
  assign sum5 = sum1 + sum2 + sum3 + sum4;

  assign sum1 = count16 + count17 + count18 + count19;
  assign sum2 = count20 + count21 + count22 + count23;
  assign sum3 = count24 + count25 + count26 + count27;
  assign sum4 = count28 + count29 + count30 + count31;


  assign sum_final = sum1 + sum2 + sum3 + sum4 + sum5[5:0];

  always @(*) begin
    out = sum_final;
  end

endmodule

// 8-bit popcount module using LUT or other optimized implementation
module popcount8 (
    input  [7:0] in,
    output [3:0] out
);
  // Using a simple iterative method for demonstration (can be replaced with LUT or other optimized implementation)
  reg [3:0] count;
  integer i;

  always @(*) begin
    count = 0;
    for (i = 0; i < 8; i = i + 1) begin
      if (in[i] == 1'b1) begin
        count = count + 1;
      end
    end
    out = count;
  end

endmodule