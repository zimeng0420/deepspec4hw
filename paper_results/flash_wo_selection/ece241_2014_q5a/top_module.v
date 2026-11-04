module top_module (
    input clk,
    input areset,
    input x,
    output z
);

  reg state; // State: 0 = initial, 1 = one_seen
  reg z_reg;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 0;
      z_reg <= 0;
    end else begin
      case (state)
        0: begin
          if (x == 1) begin
            state <= 1;
            z_reg <= 1;
          end else begin
            state <= 0;
            z_reg <= 0;
          end
        end
        1: begin
          state <= 1;
          z_reg <= ~x;
        end
        default: begin
          state <= 0;
          z_reg <= 0;
        end
      endcase
    end
  end

  assign z = z_reg;

endmodule