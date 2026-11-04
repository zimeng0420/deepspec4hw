module top_module(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

  reg [9:0] counter;
  reg tc_reg;

  always @(posedge clk) begin
    if (load) begin
      counter <= data;
      tc_reg <= 0; // Reset tc when loading new value
    } else begin
      if (counter > 0) begin
        counter <= counter - 1;
      end else begin
        counter <= 0; // Stop counting once it reaches 0
      end
    end
  end

  always @(counter) begin
    if (counter == 0) begin
      tc_reg <= 1;
    } else begin
      tc_reg <= 0;
    end
  end

  assign tc = tc_reg;

endmodule