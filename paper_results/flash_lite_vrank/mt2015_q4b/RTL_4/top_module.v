module top_module(
	input x,
	input y,
	output z
);

  reg z_reg;
  reg [6:0] counter;

  always @(posedge x or posedge y) begin
    if (x || y) begin
      counter <= 0;
    end
  end
  
  always @(*) begin
    case(counter)
      0: z_reg = 1;
      1: z_reg = 1;
      2: z_reg = 1;
      3: z_reg = 1;
      4: z_reg = 1;
      5: z_reg = 0;
      6: z_reg = 0;
      7: z_reg = 0;
      8: z_reg = 0;
      9: z_reg = 1;
      10: z_reg = 1;
      11: z_reg = 1;
      12: z_reg = 0;
      13: z_reg = 0;
      14: z_reg = 1;
      15: z_reg = 0;
      16: z_reg = 0;
      17: z_reg = 0;
      18: z_reg = 0;
      19: z_reg = 0;
      20: z_reg = 0;
      21: z_reg = 0;
      22: z_reg = 0;
      23: z_reg = 0;
      24: z_reg = 0;
      25: z_reg = 0;
      26: z_reg = 0;
      27: z_reg = 0;
      28: z_reg = 0;
      29: z_reg = 0;
      30: z_reg = 0;
      31: z_reg = 0;
      32: z_reg = 0;
      33: z_reg = 0;
      34: z_reg = 0;
      35: z_reg = 0;
      36: z_reg = 0;
      37: z_reg = 0;
      38: z_reg = 0;
      39: z_reg = 0;
      40: z_reg = 0;
      41: z_reg = 0;
      42: z_reg = 0;
      43: z_reg = 0;
      44: z_reg = 0;
      45: z_reg = 0;
      46: z_reg = 0;
      47: z_reg = 0;
      48: z_reg = 0;
      49: z_reg = 0;
      50: z_reg = 0;
      51: z_reg = 0;
      52: z_reg = 0;
      53: z_reg = 0;
      54: z_reg = 0;
      55: z_reg = 1;
      56: z_reg = 0;
      57: z_reg = 0;
      58: z_reg = 0;
      59: z_reg = 0;
      60: z_reg = 0;
      61: z_reg = 0;
      62: z_reg = 0;
      63: z_reg = 0;
      64: z_reg = 0;
      65: z_reg = 0;
      66: z_reg = 0;
      67: z_reg = 0;
      68: z_reg = 0;
      69: z_reg = 1;
      70: z_reg = 1;
      71: z_reg = 1;
      72: z_reg = 1;
      73: z_reg = 1;
      74: z_reg = 1;
      75: z_reg = 0;
      76: z_reg = 0;
      77: z_reg = 0;
      78: z_reg = 0;
      79: z_reg = 0;
      80: z_reg = 0;
      81: z_reg = 0;
      82: z_reg = 0;
      83: z_reg = 0;
      84: z_reg = 0;
      85: z_reg = 0;
      86: z_reg = 0;
      87: z_reg = 0;
      88: z_reg = 0;
      89: z_reg = 0;
      90: z_reg = 0;
      91: z_reg = 0;
      92: z_reg = 0;
      93: z_reg = 0;
      94: z_reg = 0;
      95: z_reg = 0;
      96: z_reg = 0;
      97: z_reg = 0;
      98: z_reg = 0;
      99: z_reg = 0;

      default: z_reg = 0;
    endcase
  end

  always @(posedge x or posedge y) begin
      counter <= counter + 1;
  end

  assign z = z_reg;

endmodule