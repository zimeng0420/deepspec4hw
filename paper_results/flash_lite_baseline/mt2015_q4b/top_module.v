module top_module(
	input x,
	input y,
	output z
);

  reg z_reg;
  reg [6:0] state;

  always @(x or y) begin
    case (state)
      7'b0000000: begin // 0-20ns
        if (x == 1'b1 && y == 1'b0) state <= 7'b0000001;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b0000010;
        else if (x == 1'b1 && y == 1'b1) state <= 7'b0000011;
        else state <= 7'b0000000;
      end
      7'b0000001: begin // 25-30ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b0000100;
        else if (x == 1'b1 && y == 1'b1) state <= 7'b0000101;
        else state <= 7'b0000001;
      end
      7'b0000010: begin // 35-40ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b0000110;
        else state <= 7'b0000010;
      end
      7'b0000011: begin // 45-50ns
        if (x == 1'b0 && y == 1'b0) state <= 7'b0000111;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b0001000;
        else state <= 7'b0000011;
      end
      7'b0000100: begin // 35-40ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b0001001;
        else state <= 7'b0000100;
      end
      7'b0000101: begin // 45-50ns
        if (x == 1'b0 && y == 1'b0) state <= 7'b0001010;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b0001011;
        else state <= 7'b0000101;
      end
      7'b0000110: begin // 45-50ns
        if (x == 1'b0 && y == 1'b0) state <= 7'b0001100;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b0001101;
        else state <= 7'b0000110;
      end
      7'b0000111: begin // 55ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b0001110;
        else state <= 7'b0000111;
      end
      7'b0001000: begin // 55ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b0001111;
        else state <= 7'b0001000;
      end
      7'b0001001: begin // 55ns
        if (x == 1'b0 && y == 1'b0) state <= 7'b0010000;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b0010001;
        else state <= 7'b0001001;
      end
      7'b0001010: begin // 55ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b0010010;
        else state <= 7'b0001010;
      end
      7'b0001011: begin // 55ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b0010011;
        else state <= 7'b0001011;
      end
      7'b0001100: begin // 55ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b0010100;
        else state <= 7'b0001100;
      end
      7'b0001101: begin // 55ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b0010101;
        else state <= 7'b0001101;
      end
      7'b0001110: begin // 55ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b0010110;
        else state <= 7'b0001110;
      end
      7'b0001111: begin // 55ns
        if (x == 1'b0 && y == 1'b0) state <= 7'b0010111;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b0011000;
        else state <= 7'b0001111;
      end
      7'b0010000: begin // 60-65ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b0011001;
        else state <= 7'b0010000;
      end
      7'b0010001: begin // 60-65ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b0011010;
        else state <= 7'b0010001;
      end
      7'b0010010: begin // 60-65ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b0011011;
        else state <= 7'b0010010;
      end
      7'b0010011: begin // 60-65ns
        if (x == 1'b0 && y == 1'b0) state <= 7'b0011100;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b0011101;
        else state <= 7'b0010011;
      end
      7'b0010100: begin // 60-65ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b0011110;
        else state <= 7'b0010100;
      end
      7'b0010101: begin // 60-65ns
        if (x == 1'b0 && y == 1'b0) state <= 7'b0011111;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b0100000;
        else state <= 7'b0010101;
      end
      7'b0010110: begin // 60-65ns
        if (x == 1'b0 && y == 1'b0) state <= 7'b0100001;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b0100010;
        else state <= 7'b0010110;
      end
      7'b0010111: begin // 60-65ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b0100011;
        else state <= 7'b0010111;
      end
      7'b0011000: begin // 60-65ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b0100100;
        else state <= 7'b0011000;
      end
      7'b0011001: begin // 60-65ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b0100101;
        else state <= 7'b0011001;
      end
      7'b0011010: begin // 60-65ns
        if (x == 1'b0 && y == 1'b0) state <= 7'b0100110;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b0100111;
        else state <= 7'b0011010;
      end
      7'b0011011: begin // 60-65ns
        if (x == 1'b0 && y == 1'b0) state <= 7'b0101000;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b0101001;
        else state <= 7'b0011011;
      end
      7'b0011100: begin // 60-65ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b0101010;
        else state <= 7'b0011100;
      end
      7'b0011101: begin // 60-65ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b0101011;
        else state <= 7'b0011101;
      end
      7'b0011110: begin // 60-65ns
        if (x == 1'b0 && y == 1'b0) state <= 7'b0101100;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b0101101;
        else state <= 7'b0011110;
      end
      7'b0011111: begin // 60-65ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b0101110;
        else state <= 7'b0011111;
      end
      7'b0100000: begin // 70ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b0101111;
        else state <= 7'b0100000;
      end
      7'b0100001: begin // 70ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b0110000;
        else state <= 7'b0100001;
      end
      7'b0100010: begin // 70ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b0110001;
        else state <= 7'b0100010;
      end
      7'b0100011: begin // 70ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b0110010;
        else state <= 7'b0100011;
      end
      7'b0100100: begin // 70ns
        if (x == 1'b0 && y == 1'b0) state <= 7'b0110011;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b0110100;
        else state <= 7'b0100100;
      end
      7'b0100101: begin // 70ns
        if (x == 1'b0 && y == 1'b0) state <= 7'b0110101;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b0110110;
        else state <= 7'b0100101;
      end
      7'b0100110: begin // 70ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b0110111;
        else state <= 7'b0100110;
      end
      7'b0100111: begin // 70ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b0111000;
        else state <= 7'b0100111;
      end
      7'b0101000: begin // 70ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b0111001;
        else state <= 7'b0101000;
      end
      7'b0101001: begin // 70ns
        if (x == 1'b0 && y == 1'b0) state <= 7'b0111010;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b0111011;
        else state <= 7'b0101001;
      end
      7'b0101010: begin // 70ns
        if (x == 1'b0 && y == 1'b0) state <= 7'b0111100;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b0111101;
        else state <= 7'b0101010;
      end
      7'b0101011: begin // 70ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b0111110;
        else state <= 7'b0101011;
      end
      7'b0101100: begin // 70ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b0111111;
        else state <= 7'b0101100;
      end
      7'b0101101: begin // 70ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b1000000;
        else state <= 7'b0101101;
      end
      7'b0101110: begin // 70ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b1000001;
        else state <= 7'b0101110;
      end
      7'b0101111: begin // 70ns
        if (x == 1'b0 && y == 1'b0) state <= 7'b1000010;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b1000011;
        else state <= 7'b0101111;
      end
      7'b0110000: begin // 75ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1000100;
        else state <= 7'b0110000;
      end
      7'b0110001: begin // 75ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1000101;
        else state <= 7'b0110001;
      end
      7'b0110010: begin // 75ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1000110;
        else state <= 7'b0110010;
      end
      7'b0110011: begin // 75ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b1000111;
        else state <= 7'b0110011;
      end
      7'b0110100: begin // 75ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1001000;
        else state <= 7'b0110100;
      end
      7'b0110101: begin // 75ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b1001001;
        else state <= 7'b0110101;
      end
      7'b0110110: begin // 75ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1001010;
        else state <= 7'b0110110;
      end
      7'b0110111: begin // 75ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b1001011;
        else state <= 7'b0110111;
      end
      7'b0111000: begin // 75ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1001100;
        else state <= 7'b0111000;
      end
      7'b0111001: begin // 75ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1001101;
        else state <= 7'b0111001;
      end
      7'b0111010: begin // 75ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b1001110;
        else state <= 7'b0111010;
      end
      7'b0111011: begin // 75ns
        if (x == 1'b0 && y == 1'b0) state <= 7'b1001111;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b1010000;
        else state <= 7'b0111011;
      end
      7'b0111100: begin // 75ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1010001;
        else state <= 7'b0111100;
      end
      7'b0111101: begin // 75ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b1010010;
        else state <= 7'b0111101;
      end
      7'b0111110: begin // 75ns
        if (x == 1'b0 && y == 1'b0) state <= 7'b1010011;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b1010100;
        else state <= 7'b0111110;
      end
      7'b0111111: begin // 75ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1010101;
        else state <= 7'b0111111;
      end
      7'b1000000: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1010110;
        else state <= 7'b1000000;
      end
      7'b1000001: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1010111;
        else state <= 7'b1000001;
      end
      7'b1000010: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1011000;
        else state <= 7'b1000010;
      end
      7'b1000011: begin // 80-85ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b1011001;
        else state <= 7'b1000011;
      end
      7'b1000100: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1011010;
        else state <= 7'b1000100;
      end
      7'b1000101: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1011011;
        else state <= 7'b1000101;
      end
      7'b1000110: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1011100;
        else state <= 7'b1000110;
      end
      7'b1000111: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1011101;
        else state <= 7'b1000111;
      end
      7'b1001000: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1011110;
        else state <= 7'b1001000;
      end
      7'b1001001: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1011111;
        else state <= 7'b1001001;
      end
      7'b1001010: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1100000;
        else state <= 7'b1001010;
      end
      7'b1001011: begin // 80-85ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b1100001;
        else state <= 7'b1001011;
      end
      7'b1001100: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1100010;
        else state <= 7'b1001100;
      end
      7'b1001101: begin // 80-85ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b1100011;
        else state <= 7'b1001101;
      end
      7'b1001110: begin // 80-85ns
        if (x == 1'b0 && y == 1'b0) state <= 7'b1100100;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b1100101;
        else state <= 7'b1001110;
      end
      7'b1001111: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1100110;
        else state <= 7'b1001111;
      end
      7'b1010000: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1100111;
        else state <= 7'b1010000;
      end
      7'b1010001: begin // 80-85ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b1101000;
        else state <= 7'b1010001;
      end
      7'b1010010: begin // 80-85ns
        if (x == 1'b0 && y == 1'b0) state <= 7'b1101001;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b1101010;
        else state <= 7'b1010010;
      end
      7'b1010011: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1101011;
        else state <= 7'b1010011;
      end
      7'b1010100: begin // 80-85ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b1101100;
        else state <= 7'b1010100;
      end
      7'b1010101: begin // 80-85ns
        if (x == 1'b0 && y == 1'b0) state <= 7'b1101101;
        else if (x == 1'b0 && y == 1'b1) state <= 7'b1101110;
        else state <= 7'b1010101;
      end
      7'b1010110: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1101111;
        else state <= 7'b1010110;
      end
      7'b1010111: begin // 80-85ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b1110000;
        else state <= 7'b1010111;
      end
      7'b1011000: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1110001;
        else state <= 7'b1011000;
      end
      7'b1011001: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1110010;
        else state <= 7'b1011001;
      end
      7'b1011010: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1110011;
        else state <= 7'b1011010;
      end
      7'b1011011: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1110100;
        else state <= 7'b1011011;
      end
      7'b1011100: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1110101;
        else state <= 7'b1011100;
      end
      7'b1011101: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1110110;
        else state <= 7'b1011101;
      end
      7'b1011110: begin // 80-85ns
        if (x == 1'b0 && y == 1'b1) state <= 7'b1110111;
        else state <= 7'b1011110;
      end
      7'b1011111: begin // 80-85ns
        if (x == 1'b1 && y == 1'b1) state <= 7'b1111000;
        else state <= 7'b1011111;
      end
      7'b1100000: begin // 90ns
        if (x == 1'b1 && y == 1'b0) state <= 7'b1111001;
        else state <= 7'b1100000;
      end
      7'b1100001: begin // 90ns
        if (x == 1'b1 && y == 1'b0) state <= 7'b1111