module top_module(
	input x,
	input y,
	output z
);

  reg z_reg;
  reg [6:0] state;

  always @(posedge x or posedge y) begin
    case (state)
      7'b0000000: begin // 0-20ns
        z_reg <= 1'b1;
        state <= 7'b0000001;
      end
      7'b0000001: begin
        z_reg <= 1'b1;
        state <= 7'b0000010;
      end
      7'b0000010: begin
        z_reg <= 1'b1;
        state <= 7'b0000011;
      end
      7'b0000011: begin
        z_reg <= 1'b1;
        state <= 7'b0000100;
      end
      7'b0000100: begin
        z_reg <= 1'b1;
        state <= 7'b0000101;
      end
      7'b0000101: begin  //25-30ns
        z_reg <= 1'b0;
        state <= 7'b0000110;
      end
      7'b0000110: begin
        z_reg <= 1'b0;
        state <= 7'b0000111;
      end
      7'b0000111: begin  // 35-40ns
        z_reg <= 1'b0;
        state <= 7'b0001000;
      end
      7'b0001000: begin
        z_reg <= 1'b0;
        state <= 7'b0001001;
      end
      7'b0001001: begin  // 45-50ns
        z_reg <= 1'b1;
        state <= 7'b0001010;
      end
      7'b0001010: begin
        z_reg <= 1'b1;
        state <= 7'b0001011;
      end
      7'b0001011: begin // 55ns
        z_reg <= 1'b1;
        state <= 7'b0001100;
      end
      7'b0001100: begin // 60-65ns
        z_reg <= 1'b0;
        state <= 7'b0001101;
      end
      7'b0001101: begin
        z_reg <= 1'b0;
        state <= 7'b0001110;
      end
      7'b0001110: begin  // 70ns
        z_reg <= 1'b1;
        state <= 7'b0001111;
      end
      7'b0001111: begin  // 75-85ns
        z_reg <= 1'b0;
        state <= 7'b0010000;
      end
      7'b0010000: begin
        z_reg <= 1'b0;
        state <= 7'b0010001;
      end
      7'b0010001: begin
        z_reg <= 1'b0;
        state <= 7'b0010010;
      end
       7'b0010010: begin
        z_reg <= 1'b0;
        state <= 7'b0010011;
      end
      7'b0010011: begin  // 90ns
        z_reg <= 1'b0;
        state <= 7'b0000000;
      end
      default: begin
          z_reg <= 1'b1;
          state <= 7'b0000000;
      end
    endcase
  end

  assign z = z_reg;

endmodule