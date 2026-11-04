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
  reg [2:0] state;
  reg x_prev1;
  reg x_prev2;
  reg [1:0] y_timer;

  localparam A = 3'b000;
  localparam B = 3'b001;
  localparam C = 3'b010;
  localparam D = 3'b011;
  localparam E = 3'b100;
  localparam F = 3'b101;
  localparam G = 3'b110;


  always @(posedge clk) begin
    if (!resetn) begin
      state <= A;
      f <= 0;
      g <= 0;
      x_prev1 <= 0;
      x_prev2 <= 0;
      y_timer <= 0;
    end else begin
      case (state)
        A: begin
          f <= 0;
          g <= 0;
          state <= B;
          x_prev1 <= 0;
          x_prev2 <= 0;
          y_timer <= 0;
        end
        B: begin
          f <= 1;
          g <= 0;
          state <= C;
          x_prev1 <= 0;
          x_prev2 <= 0;
          y_timer <= 0;
        end
        C: begin
          f <= 0;
          g <= 0;
          if (x == 1) begin
            state <= D;
          end else begin
            state <= C;
          end
          x_prev2 <= x_prev1;
          x_prev1 <= x;
          y_timer <= 0;
        end
        D: begin
          f <= 0;
          g <= 0;
          if (x == 0) begin
            state <= E;
          end else begin
            state <= C;
          end
          x_prev2 <= x_prev1;
          x_prev1 <= x;
          y_timer <= 0;
        end
        E: begin
          f <= 0;
          g <= 0;
          if (x == 1) begin
            state <= F;
          end else begin
            state <= C;
          end
          x_prev2 <= x_prev1;
          x_prev1 <= x;
          y_timer <= 0;
        end
        F: begin
          f <= 0;
          g <= 1;
          state <= G;
          x_prev1 <= 0;
          x_prev2 <= 0;
          y_timer <= 0;
        end
        G: begin
          f <= 0;
          if (y == 1) begin
            g <= 1;
            state <= G;
            y_timer <= 0;
          end else if (y_timer < 2) begin
            g <= 1;
            state <= G;
            y_timer <= y_timer + 1;
          end else begin
            g <= 0;
            state <= G;
            y_timer <= 0;
          end
          x_prev1 <= 0;
          x_prev2 <= 0;
        end
        default: begin
          state <= A;
          f <= 0;
          g <= 0;
          x_prev1 <= 0;
          x_prev2 <= 0;
          y_timer <= 0;
        end
      endcase
    end
  end

  assign f = (state == B) ? 1'b1 : 1'b0;
  assign g = g;

endmodule