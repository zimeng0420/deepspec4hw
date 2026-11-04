module top_module (
    input clk,
    input areset,
    input x,
    output z
);

  reg z;
  reg [1:0] state;

  parameter S_ZERO = 2'b00;
  parameter S_ONE  = 2'b01;
  parameter S_INV  = 2'b10;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= S_ZERO;
      z <= 0;
    end else begin
      case (state)
        S_ZERO: begin
          if (x) begin
            state <= S_ONE;
            z <= 1;
          end else begin
            state <= S_ZERO;
            z <= 0;
          end
        end
        S_ONE: begin
          state <= S_INV;
          z <= ~x;
        end
        S_INV: begin
          state <= S_INV;
          z <= ~x;
        end
        default: begin
          state <= S_ZERO;
          z <= 0;
        end
      endcase
    end
  end

endmodule