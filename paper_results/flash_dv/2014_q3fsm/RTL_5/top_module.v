module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

  // Define the states
  parameter A = 2'b00;
  parameter B = 2'b01;
  parameter C = 2'b10;
  parameter D = 2'b11;

  // State register
  reg [1:0] state;

  // Registers to store the last two values of w
  reg w_d1;
  reg w_d2;

  // Combinational logic for next state and output
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
          w_d1 <= w;
          w_d2 <= 0;
          z <= 0;
        end
        C: begin
          state <= D;
          w_d2 <= w_d1;
          w_d1 <= w;
          z <= 0;
        end
        D: begin
          // Check for exactly two 1s in the last three cycles
          if ((w & w_d1 & ~w_d2) | (w & ~w_d1 & w_d2) | (~w & w_d1 & w_d2)) begin
            z <= 1;
          } else begin
            z <= 0;
          end
          state <= B;
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