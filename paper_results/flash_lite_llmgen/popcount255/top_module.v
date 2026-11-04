module bit_counter (
    input [7:0] in,
    output reg [3:0] out
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

module top_module (
    input [254:0] in,
    output reg [7:0] out
);

    wire [3:0] count_0_to_7;
    wire [3:0] count_8_to_15;
    wire [3:0] count_16_to_23;
    wire [3:0] count_24_to_31;
    wire [3:0] count_32_to_39;
    wire [3:0] count_40_to_47;
    wire [3:0] count_48_to_55;
    wire [3:0] count_56_to_63;
    wire [3:0] count_64_to_71;
    wire [3:0] count_72_to_79;
    wire [3:0] count_80_to_87;
    wire [3:0] count_88_to_95;
    wire [3:0] count_96_to_103;
    wire [3:0] count_104_to_111;
    wire [3:0] count_112_to_119;
    wire [3:0] count_120_to_127;
    wire [3:0] count_128_to_135;
    wire [3:0] count_136_to_143;
    wire [3:0] count_144_to_151;
    wire [3:0] count_152_to_159;
    wire [3:0] count_160_to_167;
    wire [3:0] count_168_to_175;
    wire [3:0] count_176_to_183;
    wire [3:0] count_184_to_191;
    wire [3:0] count_192_to_199;
    wire [3:0] count_200_to_207;
    wire [3:0] count_208_to_215;
    wire [3:0] count_216_to_223;
    wire [3:0] count_224_to_231;
    wire [3:0] count_232_to_239;
    wire [3:0] count_240_to_247;
    wire [3:0] count_248_to_254;

    bit_counter counter_0_to_7 ( .in(in[7:0]), .out(count_0_to_7) );
    bit_counter counter_8_to_15 ( .in(in[15:8]), .out(count_8_to_15) );
    bit_counter counter_16_to_23 ( .in(in[23:16]), .out(count_16_to_23) );
    bit_counter counter_24_to_31 ( .in(in[31:24]), .out(count_24_to_31) );
    bit_counter counter_32_to_39 ( .in(in[39:32]), .out(count_32_to_39) );
    bit_counter counter_40_to_47 ( .in(in[47:40]), .out(count_40_to_47) );
    bit_counter counter_48_to_55 ( .in(in[55:48]), .out(count_48_to_55) );
    bit_counter counter_56_to_63 ( .in(in[63:56]), .out(count_56_to_63) );
    bit_counter counter_64_to_71 ( .in(in[71:64]), .out(count_64_to_71) );
    bit_counter counter_72_to_79 ( .in(in[79:72]), .out(count_72_to_79) );
    bit_counter counter_80_to_87 ( .in(in[87:80]), .out(count_80_to_87) );
    bit_counter counter_88_to_95 ( .in(in[95:88]), .out(count_88_to_95) );
    bit_counter counter_96_to_103 ( .in(in[103:96]), .out(count_96_to_103) );
    bit_counter counter_104_to_111 ( .in(in[111:104]), .out(count_104_to_111) );
    bit_counter counter_112_to_119 ( .in(in[119:112]), .out(count_112_to_119) );
    bit_counter counter_120_to_127 ( .in(in[127:120]), .out(count_120_to_127) );
    bit_counter counter_128_to_135 ( .in(in[135:128]), .out(count_128_to_135) );
    bit_counter counter_136_to_143 ( .in(in[143:136]), .out(count_136_to_143) );
    bit_counter counter_144_to_151 ( .in(in[151:144]), .out(count_144_to_151) );
    bit_counter counter_152_to_159 ( .in(in[159:152]), .out(count_152_to_159) );
    bit_counter counter_160_to_167 ( .in(in[167:160]), .out(count_160_to_167) );
    bit_counter counter_168_to_175 ( .in(in[175:168]), .out(count_168_to_175) );
    bit_counter counter_176_to_183 ( .in(in[183:176]), .out(count_176_to_183) );
    bit_counter counter_184_to_191 ( .in(in[191:184]), .out(count_184_to_191) );
    bit_counter counter_192_to_199 ( .in(in[199:192]), .out(count_192_to_199) );
    bit_counter counter_200_to_207 ( .in(in[207:200]), .out(count_200_to_207) );
    bit_counter counter_208_to_215 ( .in(in[215:208]), .out(count_208_to_215) );
    bit_counter counter_216_to_223 ( .in(in[223:216]), .out(count_216_to_223) );
    bit_counter counter_224_to_231 ( .in(in[231:224]), .out(count_224_to_231) );
    bit_counter counter_232_to_239 ( .in(in[239:232]), .out(count_232_to_239) );
    bit_counter counter_240_to_247 ( .in(in[247:240]), .out(count_240_to_247) );
    bit_counter counter_248_to_254 ( .in(in[254:248]), .out(count_248_to_254) );

    // Sum the counts using a series of adders.  This is a simplified example.
    // A more optimized approach would use a tree structure.
    reg [7:0] sum1;
    reg [7:0] sum2;
    reg [7:0] sum3;
    reg [7:0] sum4;
    reg [7:0] sum5;
    reg [7:0] sum6;
    reg [7:0] sum7;
    reg [7:0] sum8;
    reg [7:0] sum9;
    reg [7:0] sum10;
    reg [7:0] sum11;
    reg [7:0] sum12;
    reg [7:0] sum13;
    reg [7:0] sum14;
    reg [7:0] sum15;
    reg [7:0] sum16;
    reg [7:0] sum17;
    reg [7:0] sum18;
    reg [7:0] sum19;
    reg [7:0] sum20;
    reg [7:0] sum21;
    reg [7:0] sum22;
    reg [7:0] sum23;
    reg [7:0] sum24;
    reg [7:0] sum25;
    reg [7:0] sum26;
    reg [7:0] sum27;
    reg [7:0] sum28;
    reg [7:0] sum29;
    reg [7:0] sum30;
    reg [7:0] sum31;
    reg [7:0] sum32;

    always @(*) begin
        sum1 = {4'b0, count_0_to_7} + {4'b0, count_8_to_15};
        sum2 = {4'b0, count_16_to_23} + {4'b0, count_24_to_31};
        sum3 = {4'b0, count_32_to_39} + {4'b0, count_40_to_47};
        sum4 = {4'b0, count_48_to_55} + {4'b0, count_56_to_63};
        sum5 = {4'b0, count_64_to_71} + {4'b0, count_72_to_79};
        sum6 = {4'b0, count_80_to_87} + {4'b0, count_88_to_95};
        sum7 = {4'b0, count_96_to_103} + {4'b0, count_104_to_111};
        sum8 = {4'b0, count_112_to_119} + {4'b0, count_120_to_127};
        sum9 = {4'b0, count_128_to_135} + {4'b0, count_136_to_143};
        sum10 = {4'b0, count_144_to_151} + {4'b0, count_152_to_159};
        sum11 = {4'b0, count_160_to_167} + {4'b0, count_168_to_175};
        sum12 = {4'b0, count_176_to_183} + {4'b0, count_184_to_191};
        sum13 = {4'b0, count_192_to_199} + {4'b0, count_200_to_207};
        sum14 = {4'b0, count_208_to_215} + {4'b0, count_216_to_223};
        sum15 = {4'b0, count_224_to_231} + {4'b0, count_232_to_239};
        sum16 = {4'b0, count_240_to_247} + {4'b0, count_248_to_254};

        sum17 = sum1 + sum2;
        sum18 = sum3 + sum4;
        sum19 = sum5 + sum6;
        sum20 = sum7 + sum8;
        sum21 = sum9 + sum10;
        sum22 = sum11 + sum12;
        sum23 = sum13 + sum14;
        sum24 = sum15 + sum16;

        sum25 = sum17 + sum18;
        sum26 = sum19 + sum20;
        sum27 = sum21 + sum22;
        sum28 = sum23 + sum24;

        sum29 = sum25 + sum26;
        sum30 = sum27 + sum28;

        sum31 = sum29 + sum30;

        out = sum31;
    end

endmodule