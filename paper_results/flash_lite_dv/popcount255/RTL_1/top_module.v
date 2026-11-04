module top_module (
    input  [254:0] in,
    output reg [7:0] out
);

  // Internal signals for intermediate calculations
  wire [7:0]  seg_count_0;
  wire [7:0]  seg_count_1;
  wire [7:0]  seg_count_2;
  wire [7:0]  seg_count_3;
  wire [7:0]  seg_count_4;
  wire [7:0]  seg_count_5;
  wire [7:0]  seg_count_6;
  wire [7:0]  seg_count_7;
  wire [7:0]  seg_count_8;
  wire [7:0]  seg_count_9;
  wire [7:0]  seg_count_10;
  wire [7:0]  seg_count_11;
  wire [7:0]  seg_count_12;
  wire [7:0]  seg_count_13;
  wire [7:0]  seg_count_14;
  wire [7:0]  seg_count_15;
  wire [7:0]  seg_count_16;
  wire [7:0]  seg_count_17;
  wire [7:0]  seg_count_18;
  wire [7:0]  seg_count_19;
  wire [7:0]  seg_count_20;
  wire [7:0]  seg_count_21;
  wire [7:0]  seg_count_22;
  wire [7:0]  seg_count_23;
  wire [7:0]  seg_count_24;
  wire [7:0]  seg_count_25;
  wire [7:0]  seg_count_26;
  wire [7:0]  seg_count_27;
  wire [7:0]  seg_count_28;
  wire [7:0]  seg_count_29;
  wire [7:0]  seg_count_30;
  wire [7:0]  seg_count_31;

  wire [7:0]  sum_0_7;
  wire [7:0]  sum_8_15;
  wire [7:0]  sum_16_23;
  wire [7:0]  sum_24_31;


  // Population count for 8-bit segments. Using lookup table for speed.

  //Segment 0
  popcount_8bit pop_count_0 (
      .in(in[7:0]),
      .out(seg_count_0)
  );

  //Segment 1
  popcount_8bit pop_count_1 (
      .in(in[15:8]),
      .out(seg_count_1)
  );

  //Segment 2
  popcount_8bit pop_count_2 (
      .in(in[23:16]),
      .out(seg_count_2)
  );

  //Segment 3
  popcount_8bit pop_count_3 (
      .in(in[31:24]),
      .out(seg_count_3)
  );

  //Segment 4
  popcount_8bit pop_count_4 (
      .in(in[39:32]),
      .out(seg_count_4)
  );

  //Segment 5
  popcount_8bit pop_count_5 (
      .in(in[47:40]),
      .out(seg_count_5)
  );

  //Segment 6
  popcount_8bit pop_count_6 (
      .in(in[55:48]),
      .out(seg_count_6)
  );

  //Segment 7
  popcount_8bit pop_count_7 (
      .in(in[63:56]),
      .out(seg_count_7)
  );
    //Segment 8
  popcount_8bit pop_count_8 (
      .in(in[71:64]),
      .out(seg_count_8)
  );

  //Segment 9
  popcount_8bit pop_count_9 (
      .in(in[79:72]),
      .out(seg_count_9)
  );

  //Segment 10
  popcount_8bit pop_count_10 (
      .in(in[87:80]),
      .out(seg_count_10)
  );

  //Segment 11
  popcount_8bit pop_count_11 (
      .in(in[95:88]),
      .out(seg_count_11)
  );

  //Segment 12
  popcount_8bit pop_count_12 (
      .in(in[103:96]),
      .out(seg_count_12)
  );

  //Segment 13
  popcount_8bit pop_count_13 (
      .in(in[111:104]),
      .out(seg_count_13)
  );

  //Segment 14
  popcount_8bit pop_count_14 (
      .in(in[119:112]),
      .out(seg_count_14)
  );

  //Segment 15
  popcount_8bit pop_count_15 (
      .in(in[127:120]),
      .out(seg_count_15)
  );
    //Segment 16
  popcount_8bit pop_count_16 (
      .in(in[135:128]),
      .out(seg_count_16)
  );

  //Segment 17
  popcount_8bit pop_count_17 (
      .in(in[143:136]),
      .out(seg_count_17)
  );

  //Segment 18
  popcount_8bit pop_count_18 (
      .in(in[151:144]),
      .out(seg_count_18)
  );

  //Segment 19
  popcount_8bit pop_count_19 (
      .in(in[159:152]),
      .out(seg_count_19)
  );

  //Segment 20
  popcount_8bit pop_count_20 (
      .in(in[167:160]),
      .out(seg_count_20)
  );

  //Segment 21
  popcount_8bit pop_count_21 (
      .in(in[175:168]),
      .out(seg_count_21)
  );

  //Segment 22
  popcount_8bit pop_count_22 (
      .in(in[183:176]),
      .out(seg_count_22)
  );

  //Segment 23
  popcount_8bit pop_count_23 (
      .in(in[191:184]),
      .out(seg_count_23)
  );
    //Segment 24
  popcount_8bit pop_count_24 (
      .in(in[199:192]),
      .out(seg_count_24)
  );

  //Segment 25
  popcount_8bit pop_count_25 (
      .in(in[207:200]),
      .out(seg_count_25)
  );

  //Segment 26
  popcount_8bit pop_count_26 (
      .in(in[215:208]),
      .out(seg_count_26)
  );

  //Segment 27
  popcount_8bit pop_count_27 (
      .in(in[223:216]),
      .out(seg_count_27)
  );

  //Segment 28
  popcount_8bit pop_count_28 (
      .in(in[231:224]),
      .out(seg_count_28)
  );

  //Segment 29
  popcount_8bit pop_count_29 (
      .in(in[239:232]),
      .out(seg_count_29)
  );

  //Segment 30
  popcount_8bit pop_count_30 (
      .in(in[247:240]),
      .out(seg_count_30)
  );

  //Segment 31, handles the last 3 bits
  popcount_3bit pop_count_31_lsb (
      .in(in[254:248]),
      .out(seg_count_31_temp)
  );
  wire [2:0] seg_count_31_temp;
  assign seg_count_31 = {5'b00000, seg_count_31_temp};


  // Adder Tree to sum the segment counts
  assign sum_0_7 = seg_count_0 + seg_count_1 + seg_count_2 + seg_count_3 + seg_count_4 + seg_count_5 + seg_count_6 + seg_count_7;
  assign sum_8_15 = seg_count_8 + seg_count_9 + seg_count_10 + seg_count_11 + seg_count_12 + seg_count_13 + seg_count_14 + seg_count_15;
  assign sum_16_23 = seg_count_16 + seg_count_17 + seg_count_18 + seg_count_19 + seg_count_20 + seg_count_21 + seg_count_22 + seg_count_23;
  assign sum_24_31 = seg_count_24 + seg_count_25 + seg_count_26 + seg_count_27 + seg_count_28 + seg_count_29 + seg_count_30 + seg_count_31;

  wire [8:0] sum_0_15;
  assign sum_0_15 = sum_0_7 + sum_8_15;

  wire [8:0] sum_16_31;
  assign sum_16_31 = sum_16_23 + sum_24_31;

  wire [8:0] total_sum;
  assign total_sum = sum_0_15 + sum_16_31;



  // Assign the final count to the output
  always @(*) begin
    out = total_sum[7:0];
  end

endmodule

// 8-bit Population count module using LUT
module popcount_8bit (
    input  [7:0] in,
    output reg [7:0] out
);

  // Define a lookup table for population count
  //  reg [7:0] lut [0:255]; //Original - using LUT can be done if needed but add complexity to compile on some tools.
    always @(*) begin
        out = 0;
        for (integer i = 0; i < 8; i = i + 1) begin
            out = out + in[i];
        end
    end

endmodule

module popcount_3bit (
    input  [6:0] in,
    output reg [2:0] out
);
    always @(*) begin
        out = 0;
        for (integer i = 0; i < 7; i = i + 1) begin
            out = out + in[i];
        end
    end
endmodule