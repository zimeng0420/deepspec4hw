module top_module (
    input clk,
    input areset,
    input x,
    output z
);

  reg first_one_seen;
  reg z_reg;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      first_one_seen <= 0;
      z_reg <= 0;
    end else begin
      first_one_seen <= first_one_seen || x;
      if (first_one_seen) begin
        z_reg <= ~x;
      end else begin
        z_reg <= x;
      end
    end
  end

  assign z = z_reg;

endmodule