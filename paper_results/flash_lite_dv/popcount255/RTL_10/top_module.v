module top_module (
    input  [254:0] in,
    output reg [7:0] out
);

  // Internal signals
  wire [7:0] segment_counts [31:0]; // Array to store population counts for each 8-bit segment
  wire [7:0] count1;
  wire [7:0] count2;
  wire [7:0] count3;

  // Calculate population count for each 8-bit segment (or less for the last segment)
  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin: segment_count_gen
      if (i < 31) begin
        assign segment_counts[i] = in[i*8+7:i*8] + in[i*8+6:i*8] + in[i*8+5:i*8] + in[i*8+4:i*8] + in[i*8+3:i*8] + in[i*8+2:i*8] + in[i*8+1:i*8] + in[i*8:i*8];
      end else begin
        assign segment_counts[i] = in[247:247] + in[246:246] + in[245:245] + in[244:244] + in[243:243] + in[242:242] + in[241:241] + in[240:240] + in[239:239] + in[238:238] + in[237:237] + in[236:236] + in[235:235] + in[234:234] + in[233:233] + in[232:232] + in[231:231] + in[230:230] + in[229:229] + in[228:228] + in[227:227] + in[226:226] + in[225:225] + in[224:224] + in[223:223] + in[222:222] + in[221:221] + in[220:220] + in[219:219] + in[218:218] + in[217:217] + in[216:216] + in[215:215] + in[214:214] + in[213:213] + in[212:212] + in[211:211] + in[210:210] + in[209:209] + in[208:208] + in[207:207] + in[206:206] + in[205:205] + in[204:204] + in[203:203] + in[202:202] + in[201:201] + in[200:200] + in[199:199] + in[198:198] + in[197:197] + in[196:196] + in[195:195] + in[194:194] + in[193:193] + in[192:192] + in[191:191] + in[190:190] + in[189:189] + in[188:188] + in[187:187] + in[186:186] + in[185:185] + in[184:184] + in[183:183] + in[182:182] + in[181:181] + in[180:180] + in[179:179] + in[178:178] + in[177:177] + in[176:176] + in[175:175] + in[174:174] + in[173:173] + in[172:172] + in[171:171] + in[170:170] + in[169:169] + in[168:168] + in[167:167] + in[166:166] + in[165:165] + in[164:164] + in[163:163] + in[162:162] + in[161:161] + in[160:160] + in[159:159] + in[158:158] + in[157:157] + in[156:156] + in[155:155] + in[154:154] + in[153:153] + in[152:152] + in[151:151] + in[150:150] + in[149:149] + in[148:148] + in[147:147] + in[146:146] + in[145:145] + in[144:144] + in[143:143] + in[142:142] + in[141:141] + in[140:140] + in[139:139] + in[138:138] + in[137:137] + in[136:136] + in[135:135] + in[134:134] + in[133:133] + in[132:132] + in[131:131] + in[130:130] + in[129:129] + in[128:128] + in[127:127] + in[126:126] + in[125:125] + in[124:124] + in[123:123] + in[122:122] + in[121:121] + in[120:120] + in[119:119] + in[118:118] + in[117:117] + in[116:116] + in[115:115] + in[114:114] + in[113:113] + in[112:112] + in[111:111] + in[110:110] + in[109:109] + in[108:108] + in[107:107] + in[106:106] + in[105:105] + in[104:104] + in[103:103] + in[102:102] + in[101:101] + in[100:100] + in[99:99] + in[98:98] + in[97:97] + in[96:96] + in[95:95] + in[94:94] + in[93:93] + in[92:92] + in[91:91] + in[90:90] + in[89:89] + in[88:88] + in[87:87] + in[86:86] + in[85:85] + in[84:84] + in[83:83] + in[82:82] + in[81:81] + in[80:80] + in[79:79] + in[78:78] + in[77:77] + in[76:76] + in[75:75] + in[74:74] + in[73:73] + in[72:72] + in[71:71] + in[70:70] + in[69:69] + in[68:68] + in[67:67] + in[66:66] + in[65:65] + in[64:64] + in[63:63] + in[62:62] + in[61:61] + in[60:60] + in[59:59] + in[58:58] + in[57:57] + in[56:56] + in[55:55] + in[54:54] + in[53:53] + in[52:52] + in[51:51] + in[50:50] + in[49:49] + in[48:48] + in[47:47] + in[46:46] + in[45:45] + in[44:44] + in[43:43] + in[42:42] + in[41:41] + in[40:40] + in[39:39] + in[38:38] + in[37:37] + in[36:36] + in[35:35] + in[34:34] + in[33:33] + in[32:32] + in[31:31] + in[30:30] + in[29:29] + in[28:28] + in[27:27] + in[26:26] + in[25:25] + in[24:24] + in[23:23] + in[22:22] + in[21:21] + in[20:20] + in[19:19] + in[18:18] + in[17:17] + in[16:16] + in[15:15] + in[14:14] + in[13:13] + in[12:12] + in[11:11] + in[10:10] + in[9:9] + in[8:8] + in[7:7] + in[6:6] + in[5:5] + in[4:4] + in[3:3] + in[2:2] + in[1:1] + in[0:0];
      end
    end
  endgenerate

  // Sum the segment counts using a tree structure
  assign count1 = segment_counts[0] + segment_counts[1] + segment_counts[2] + segment_counts[3] + segment_counts[4] + segment_counts[5] + segment_counts[6] + segment_counts[7];
  assign count2 = segment_counts[8] + segment_counts[9] + segment_counts[10] + segment_counts[11] + segment_counts[12] + segment_counts[13] + segment_counts[14] + segment_counts[15];
  assign count3 = segment_counts[16] + segment_counts[17] + segment_counts[18] + segment_counts[19] + segment_counts[20] + segment_counts[21] + segment_counts[22] + segment_counts[23];
  assign count4 = segment_counts[24] + segment_counts[25] + segment_counts[26] + segment_counts[27] + segment_counts[28] + segment_counts[29] + segment_counts[30] + segment_counts[31];

  assign out = count1 + count2 + count3 + count4;


endmodule