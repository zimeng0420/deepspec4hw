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
          end else begin
            state <= A;
            z <= 0;
          end
          w_d1 <= 0;
          w_d2 <= 0;
        end
        B: begin
          state <= C;
          w_d1 <= w;
          w_d2 <= w_d1;
          z <= 0;
        end
        C: begin
          state <= D;
          w_d1 <= w;
          w_d2 <= w_d1;
          z <= 0;
        end
        D: begin
          w_d1 <= w;
          w_d2 <= w_d1;
          // Check for exactly two 1s
          if ((w && w_d1 && ~w_d2) || (w && ~w_d1 && w_d2) || (~w && w_d1 && w_d2)) begin
            z <= 1;
          } else begin
            z <= 0;
          end
          state <= B;
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