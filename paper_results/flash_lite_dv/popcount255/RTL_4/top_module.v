module top_module (
    input  [254:0] in,
    output reg [7:0] out
);

  // Internal wires for intermediate calculations
  wire [7:0]  count0;
  wire [7:0]  count1;
  wire [7:0]  count2;
  wire [7:0]  count3;
  wire [7:0]  count4;
  wire [7:0]  count5;
  wire [7:0]  count6;
  wire [7:0]  count7;
  wire [7:0]  count8;
  wire [7:0]  count9;
  wire [7:0]  count10;
  wire [7:0]  count11;
  wire [7:0]  count12;
  wire [7:0]  count13;
  wire [7:0]  count14;
  wire [7:0]  count15;
  wire [7:0]  count16;
  wire [7:0]  count17;
  wire [7:0]  count18;
  wire [7:0]  count19;
  wire [7:0]  count20;
  wire [7:0]  count21;
  wire [7:0]  count22;
  wire [7:0]  count23;
  wire [7:0]  count24;
  wire [7:0]  count25;
  wire [7:0]  count26;
  wire [7:0]  count27;
  wire [7:0]  count28;
  wire [7:0]  count29;
  wire [7:0]  count30;
  wire [7:0]  count31;

  // Instance the sub modules
  popcount8  pc8_0  (in[7:0],     count0);
  popcount8  pc8_1  (in[15:8],    count1);
  popcount8  pc8_2  (in[23:16],   count2);
  popcount8  pc8_3  (in[31:24],   count3);
  popcount8  pc8_4  (in[39:32],   count4);
  popcount8  pc8_5  (in[47:40],   count5);
  popcount8  pc8_6  (in[55:48],   count6);
  popcount8  pc8_7  (in[63:56],   count7);
  popcount8  pc8_8  (in[71:64],   count8);
  popcount8  pc8_9  (in[79:72],   count9);
  popcount8  pc8_10 (in[87:80],   count10);
  popcount8  pc8_11 (in[95:88],   count11);
  popcount8  pc8_12 (in[103:96],  count12);
  popcount8  pc8_13 (in[111:104], count13);
  popcount8  pc8_14 (in[119:112], count14);
  popcount8  pc8_15 (in[127:120], count15);
  popcount8  pc8_16 (in[135:128], count16);
  popcount8  pc8_17 (in[143:136], count17);
  popcount8  pc8_18 (in[151:144], count18);
  popcount8  pc8_19 (in[159:152], count19);
  popcount8  pc8_20 (in[167:160], count20);
  popcount8  pc8_21 (in[175:168], count21);
  popcount8  pc8_22 (in[183:176], count22);
  popcount8  pc8_23 (in[191:184], count23);
  popcount8  pc8_24 (in[199:192], count24);
  popcount8  pc8_25 (in[207:200], count25);
  popcount8  pc8_26 (in[215:208], count26);
  popcount8  pc8_27 (in[223:216], count27);
  popcount8  pc8_28 (in[231:224], count28);
  popcount8  pc8_29 (in[239:232], count29);
  popcount8  pc8_30 (in[247:240], count30);
  popcount7  pc7_31 (in[254:248], count31);

  //Adder Tree
  wire [7:0] sum1;
  wire [7:0] sum2;
  wire [7:0] sum3;
  wire [7:0] sum4;
  wire [7:0] sum5;

  adder16bit a16_0 ( .a({count15,count14,count13,count12,count11,count10,count9,count8,count7,count6,count5,count4,count3,count2,count1,count0}), .b({8'b0}), .sum(sum1) ); // sum1 - sum of 16 x 8bit counters
  adder16bit a16_1 ( .a({count31,count30,count29,count28,count27,count26,count25,count24,count23,count22,count21,count20,count19,count18,count17,count16}), .b({8'b0}), .sum(sum2) ); // sum2 - sum of 15 x 8bit counters and 1x7 bit counter
  adder16bit a16_2 ( .a({sum2,8'b0,8'b0,8'b0,8'b0,8'b0,8'b0,8'b0,8'b0,8'b0,8'b0,8'b0,8'b0,8'b0,8'b0,8'b0}), .b({8'b0}), .sum(sum3) ); // zero padded sum2 to 16 bits
  adder16bit a16_3 ( .a({sum1,sum3}), .b({8'b0}), .sum(sum4));
  assign out = sum4;



endmodule

module popcount8 (
    input  [7:0] in,
    output reg [7:0] out
);

  always @(*) begin
    out = 0;
    for (integer i = 0; i < 8; i = i + 1) begin
      if (in[i]) begin
        out = out + 1;
      end
    end
  end

endmodule

module popcount7 (
    input  [6:0] in,
    output reg [7:0] out
);

  always @(*) begin
    out = 0;
    for (integer i = 0; i < 7; i = i + 1) begin
      if (in[i]) begin
        out = out + 1;
      end
    end
  end

endmodule

module adder16bit(
    input [15:0] a,
    input [15:0] b,
    output [7:0] sum
);

    wire [15:0] sum_internal;
    assign sum_internal = a + b;
    assign sum = sum_internal[7:0];

endmodule