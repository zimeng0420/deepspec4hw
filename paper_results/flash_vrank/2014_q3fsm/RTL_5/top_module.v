module top_module (
	input clk,
	input reset,
	input s,
	input w,
	output reg z
);

  parameter A = 0, B = 1, C0 = 2, C1 = 3, C2 = 4, C3 = 5;
  reg [2:0] state;

  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      z <= 0;
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
        end
        B: begin
          state <= C0;
          z <= 0;
        end
        C0: begin
          if (w) begin
            state <= C1;
          } else begin
            state <= C3;
          end
          z <= 0;
        end
        C1: begin
          if (w) begin
            state <= C2;
          } else begin
            state <= C3;
          end
          z <= 0;
        end
        C2: begin
          if (w) begin
            state <= C3;
          } else begin
            state <= C3;
          end
          z <= 1;
        end
        C3: begin
          if (w) begin
            state <= C2;
          } else begin
            state <= C0;
          end
          z <= 0;
        end
        default: begin
          state <= A;
          z <= 0;
        end
      endcase
    end
  end

endmodule