module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

  reg f;
  reg g;
  reg [1:0] state;
  reg x_prev1;
  reg x_prev2;
  reg g_prev;
  reg y_prev;
  reg f_temp;
  reg [1:0] y_counter;

  localparam A = 2'b00;
  localparam B = 2'b01;
  localparam C = 2'b10;
  localparam D = 2'b11;

  always @(posedge clk) begin
    if (!resetn) begin
      state <= A;
      f <= 0;
      g <= 0;
      x_prev1 <= 0;
      x_prev2 <= 0;
      g_prev <= 0;
      y_prev <= 0;
      f_temp <= 0;
      y_counter <= 0;
    end else begin
      case (state)
        A: begin
          f <= 0;
          g <= 0;
          if (resetn) begin
            state <= B;
            f_temp <= 1;
          end
        end
        B: begin
          f <= f_temp;
          g <= 0;
          f_temp <= 0;
          state <= C;
        end
        C: begin
          f <= 0;
          if ((x_prev2 == 1) && (x_prev1 == 0) && (x == 1)) begin
            g <= 1;
            g_prev <= 1;
            y_counter <= 0;
            state <= D;
          end else begin
            g <= 0;
            g_prev <= 0;
          end
        end
        D: begin
          f <= 0;
          if (y_counter < 2) begin
            if (y == 1) begin
              g <= 1;
              g_prev <= 1;
            end else begin
              g <= g_prev;
            end
            y_counter <= y_counter + 1;
          end else begin
            if (g_prev == 1 && y == 0) begin
              g <= 0;
              g_prev <= 0;
            end else begin
              g <= g_prev;
            end
          end
        end
        default: begin
          state <= A;
          f <= 0;
          g <= 0;
          x_prev1 <= 0;
          x_prev2 <= 0;
          g_prev <= 0;
          y_prev <= 0;
          f_temp <= 0;
          y_counter <= 0;
        end
      endcase

      x_prev2 <= x_prev1;
      x_prev1 <= x;
      y_prev <= y;
      if (!resetn)
          g_prev <= 0;
      else if ((x_prev2 == 1) && (x_prev1 == 0) && (x == 1))
          g_prev <= 1;
      else if (state == D && y_counter >= 2 && y == 0 && g_prev == 1)
          g_prev <= 0;
    end
  end

endmodule