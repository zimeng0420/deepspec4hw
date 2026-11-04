module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

  parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G_HIGH = 6, G_LOW = 7;

  reg state, next_state;
  reg f_reg, g_reg;

  always @(posedge clk) begin
    if (!resetn) begin
      state <= A;
      f_reg <= 0;
      g_reg <= 0;
    end else begin
      state <= next_state;
      f_reg <= 0; // default value, set to 1 in state B if needed
      g_reg <= g_reg; // g_reg retains its value unless explicitly changed
    end
  end

  always @(*) begin
    next_state = state;
    f = f_reg;
    g = g_reg;


    case (state)
      A: begin
        next_state = A;
        f_reg = 0;
        g_reg = 0;
        if (resetn) begin
          next_state = B;
        end
      end
      B: begin
        next_state = C;
        f_reg = 1;
        g_reg = 0;
      end
      C: begin
        next_state = C;
        f_reg = 0;
        g_reg = 0;
        if (x) begin
          next_state = D;
        end
      end
      D: begin
        next_state = D;
        f_reg = 0;
        g_reg = 0;
        if (!x) begin
          next_state = E;
        end
      end
      E: begin
        next_state = E;
        f_reg = 0;
        g_reg = 0;
        if (x) begin
          next_state = F;
        end
      end
      F: begin
        next_state = G_HIGH;
        f_reg = 0;
        g_reg = 1;
      end
      G_HIGH: begin
        next_state = G_HIGH;
        f_reg = 0;
        g_reg = 1;
        if (y) begin
          next_state = G_HIGH;
          g_reg = 1;
        end else begin
            next_state = G;
        end
      end
      G: begin
        next_state = G_HIGH;
          f_reg = 0;
          g_reg = 1;
          if(y) begin
              next_state = G_HIGH;
              g_reg = 1;
          end else begin
            next_state = G_LOW;

          end
      end

      G_LOW: begin
          next_state = G_LOW;
          f_reg = 0;
          g_reg = 0;
      end
      default: begin
        next_state = A;
        f_reg = 0;
        g_reg = 0;
      end
    endcase
  end

endmodule