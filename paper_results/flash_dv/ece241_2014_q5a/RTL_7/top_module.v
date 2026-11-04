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
      if (!first_one_seen) begin
        if (x) begin
          first_one_seen <= 1;
          z_reg <= 1;
        end else begin
          z_reg <= 0;
        end
      end else begin
        z_reg <= ~x;
      end
    end
  end

  assign z = z_reg;

endmodule