module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

  parameter A = 0, B = 1, C0 = 2, C1 = 3, C2 = 4, D = 5;
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
          end else begin
            state <= C1;
          end
        end
        C1: begin
          if (w) begin
            state <= C2;
          end else begin
            state <= C2;
          end
        end
        C2: begin
          if (w) begin
            state <= D;
          end else begin
            state <= D;
          end
        end
        D: begin
          if (w) begin
            if ((w + $past(w,1) + $past(w,2)) == 2) begin
              z <= 1;
            end else begin
              z <= 0;
            end
          end else begin
            if ((w + $past(w,1) + $past(w,2)) == 2) begin
              z <= 1;
            end else begin
              z <= 0;
            end
          end
          state <= B;
        end
        default: begin
          state <= A;
          z <= 0;
        end
      endcase
    end
  end

endmodule