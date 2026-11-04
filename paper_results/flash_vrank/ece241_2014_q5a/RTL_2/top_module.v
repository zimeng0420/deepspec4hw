module top_module (
    input clk,
    input areset,
    input x,
    output z
);

  reg z_reg;
  output z = z_reg;

  reg [1:0] state, next_state;

  // State definitions
  parameter S_IDLE = 2'b00;
  parameter S_FIRST = 2'b01;
  parameter S_INVERT = 2'b10;

  // State transition logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= S_IDLE;
    end else begin
      state <= next_state;
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      S_IDLE: begin
        if (x == 1'b1) begin
          next_state = S_FIRST;
        end else begin
          next_state = S_IDLE;
        end
      end
      S_FIRST: begin
        next_state = S_INVERT;
      end
      S_INVERT: begin
        next_state = S_INVERT;
      end
      default: next_state = S_IDLE;
    endcase
  end

  // Output logic
  always @(posedge clk) begin
    if (areset) begin
      z_reg <= 1'b0;
    end else begin
      case (state)
        S_IDLE: begin
          z_reg <= 1'b0;
        end
        S_FIRST: begin
          z_reg <= x;
        end
        S_INVERT: begin
          z_reg <= ~x;
        end
        default: z_reg <= 1'b0;
      endcase
    end
  end

endmodule