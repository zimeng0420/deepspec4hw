module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

  reg [2:0] state;
  localparam A = 3'b000;
  localparam B = 3'b001;
  localparam C = 3'b010;
  localparam D = 3'b011;
  localparam E = 3'b100;

  reg w1, w2, w3;

  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      z <= 0;
      w1 <= 0;
      w2 <= 0;
      w3 <= 0;
    end else begin
      case (state)
        A: begin
          if (s) begin
            state <= B;
            w1 <= w;
            z <= 0;
          end else begin
            state <= A;
            z <= 0;
          end
        end
        B: begin
          state <= C;
          w2 <= w;
          z <= 0;
        end
        C: begin
          state <= D;
          w3 <= w;
          z <= 0;
        end
        D: begin
          state <= E;
          z <= ( (w1 & w2 & ~w3) | (w1 & ~w2 & w3) | (~w1 & w2 & w3) );
        end
        E: begin
          state <= B;
          w1 <= w;
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