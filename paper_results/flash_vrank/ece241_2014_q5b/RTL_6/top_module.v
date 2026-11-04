module top_module (
    input clk,
    input areset,
    input x,
    output z
);

  parameter A = 2'b01;
  parameter B = 2'b10;

  reg [1:0] state;
  reg z_reg;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= A;
      z_reg <= 0;
    end else begin
      case (state)
        A: begin
          if (x == 0) begin
            state <= A;
            z_reg <= 0;
          end else begin
            state <= B;
            z_reg <= 1;
          end
        end
        B: begin
          if (x == 0) begin
            state <= B;
            z_reg <= 1;
          end else begin
            state <= B;
            z_reg <= 0;
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