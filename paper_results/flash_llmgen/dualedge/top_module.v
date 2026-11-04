module top_module(
    input clk,
    input d,
    output reg q
);

  reg clk_prev;
  reg rising_edge;
  reg falling_edge;
  reg data_select;
  reg q_internal; // Internal register for the flip-flop

  always @(posedge clk) begin
    clk_prev <= clk; // Capture previous clock value
  end

  always @(*) begin
    rising_edge  = (clk == 1'b1) && (clk_prev == 1'b0);
    falling_edge = (clk == 1'b0) && (clk_prev == 1'b1);
  end

  always @(posedge clk) begin
    if (rising_edge) begin
      data_select <= d;
    end else if (falling_edge) begin
      data_select <= d;
    end
  end

  always @(posedge clk) begin
    q_internal <= data_select;
  end

  assign q = q_internal;

endmodule