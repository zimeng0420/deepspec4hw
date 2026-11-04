module top_module (
    input clk,
    input areset,
    input x,
    output z
);

  reg z_reg;
  reg state;

  parameter A = 0, B = 1;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= A;
      z_reg <= 0;
    end else begin
      case (state)
        A: begin
          if (x) begin
            state <= B;
            z_reg <= 1;
          end else begin
            state <= A;
            z_reg <= 0;
          end
        end
        B: begin
          if (x) begin
            state <= B;
            z_reg <= 0;
          end else begin
            state <= B;
            z_reg <= 1;
          end
        end
        default: begin
          state <= A;
          z_reg <= 0;
        end
      endcase
    end
  end

  assign z = z_reg;

endmodule