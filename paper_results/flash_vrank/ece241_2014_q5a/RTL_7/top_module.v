module top_module (
    input clk,
    input areset,
    input x,
    output z
);

  reg current_state, next_state;

  // Define state encoding (optional, but improves readability)
  parameter IDLE = 2'b00;
  parameter FIRST_1 = 2'b01;
  parameter INVERT = 2'b10;

  reg z_reg;
  assign z = z_reg;

  // State transition logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= IDLE;
      z_reg <= 0;
    end else begin
      current_state <= next_state;
    end
  end

  always @(*) begin
    case (current_state)
      IDLE: begin
        if (x == 1) begin
          next_state = FIRST_1;
          z_reg = 1;
        end else begin
          next_state = IDLE;
          z_reg = 0;
        end
      end
      FIRST_1: begin
        next_state = INVERT;
        z_reg = x; //Output is x
      end
      INVERT: begin
        next_state = INVERT;
        z_reg = ~x; //Output is inversion of x
      end
      default: begin
        next_state = IDLE;
        z_reg = 0;
      end
    endcase
  end

endmodule