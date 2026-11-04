module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

  reg [3:0] state;
  reg f_reg;
  reg g_reg;

  parameter A = 4'b0000;
  parameter B = 4'b0001;
  parameter C = 4'b0010;
  parameter D = 4'b0011;
  parameter E = 4'b0100;
  parameter F = 4'b0101;
  parameter G = 4'b0110;
  parameter H = 4'b0111;
  parameter I = 4'b1000;
  parameter J = 4'b1001;
  parameter K = 4'b1010;

  always @(posedge clk) begin
    if (!resetn) begin
      state <= A;
      f_reg <= 0;
      g_reg <= 0;
    end else begin
      case (state)
        A: begin
          state <= B;
          f_reg <= 0;
          g_reg <= 0;
        end
        B: begin
          state <= C;
          f_reg <= 1;
          g_reg <= 0;
        end
        C: begin
          state <= D;
          f_reg <= 0;
          g_reg <= 0;
        end
        D: begin
          if (x == 1) begin
            state <= E;
          end else begin
            state <= D;
          end
          f_reg <= 0;
          g_reg <= 0;
        end
        E: begin
          if (x == 0) begin
            state <= F;
          end else begin
            state <= D;
          end
          f_reg <= 0;
          g_reg <= 0;
        end
        F: begin
          if (x == 1) begin
            state <= G;
          end else begin
            state <= D;
          end
          f_reg <= 0;
          g_reg <= 0;
        end
        G: begin
          state <= H;
          f_reg <= 0;
          g_reg <= 1;
        end
        H: begin
          if (y == 1) begin
            state <= I;
          end else begin
            state <= J;
          end
          f_reg <= 0;
          g_reg <= 1;
        end
        J: begin
          if (y == 1) begin
            state <= I;
          end else begin
            state <= K;
          end
          f_reg <= 0;
          g_reg <= 1;
        end
        I: begin
          state <= I;
          f_reg <= 0;
          g_reg <= 1;
        end
        K: begin
          state <= K;
          f_reg <= 0;
          g_reg <= 0;
        end
        default: begin
          state <= A;
          f_reg <= 0;
          g_reg <= 0;
        end
      endcase
    end
  end

  assign f = f_reg;
  assign g = g_reg;

endmodule