module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

  // Define states
  localparam A = 3'b000;
  localparam B = 3'b001;
  localparam C = 3'b010;
  localparam D = 3'b011;
  localparam E = 3'b100;
  localparam F = 3'b101;
  localparam G = 3'b110;
  localparam H = 3'b111;

  reg [2:0] current_state, next_state;
  reg f_reg, g_reg;

  // State transition logic
  always @(posedge clk) begin
    if (!resetn) begin
      current_state <= A;
      f_reg <= 0;
      g_reg <= 0;
    end else begin
      current_state <= next_state;
      f_reg <= f;
      g_reg <= g;
    end
  end

  // Next state logic
  always @(*) begin
    next_state = current_state; // Default: stay in current state
    f = f_reg; // Default output
    g = g_reg; // Default output

    case (current_state)
      A: begin
        f = 0;
        g = 0;
        next_state = B;
      end
      B: begin
        f = 1;
        g = 0;
        next_state = C;
      end
      C: begin
        f = 0;
        g = 0;
        if (x == 1)
          next_state = D;
        else
          next_state = C;
      end
      D: begin
        f = 0;
        g = 0;
        if (x == 0)
          next_state = E;
        else
          next_state = C;
      end
      E: begin
        f = 0;
        g = 0;
        if (x == 1)
          next_state = F;
        else
          next_state = C;
      end
      F: begin
        f = 0;
        g = 1;
        next_state = G;
      end
      G: begin
        f = 0;
        g = 1;
        if (y == 1)
          next_state = H;
        else
          next_state = G;
      end
      H: begin
        f = 0;
        g = 1;
          next_state = H;

      end
      default: begin
        f = 0;
        g = 0;
        next_state = A;
      end
    endcase
  end

endmodule