module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

  // Define states
  localparam A = 2'b00;
  localparam B = 2'b01;
  localparam C = 2'b10;
  localparam D = 2'b11;

  reg [1:0] state;
  reg w_d1;
  reg w_d2;

  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      z <= 0;
      w_d1 <= 0;
      w_d2 <= 0;
    end else begin
      case (state)
        A: begin
          if (s) begin
            state <= B;
            z <= 0;
            w_d1 <= 0;
            w_d2 <= 0;
          end else begin
            state <= A;
            z <= 0;
            w_d1 <= 0;
            w_d2 <= 0;
          end
        end
        B: begin
          state <= C;
          z <= 0;
          w_d2 <= w_d1;
          w_d1 <= w;
        end
        C: begin
          state <= D;
          z <= 0;
          w_d2 <= w_d1;
          w_d1 <= w;
        end
        D: begin
          state <= B;
          if ((w & w_d1 & ~w_d2) | (w & ~w_d1 & w_d2) | (~w & w_d1 & w_d2)) begin
            z <= 1;
          end else begin
            z <= 0;
          end
          w_d2 <= w_d1;
          w_d1 <= w;
        end
        default: begin
          state <= A;
          z <= 0;
          w_d1 <= 0;
          w_d2 <= 0;
        end
      endcase
    end
  end

endmodule