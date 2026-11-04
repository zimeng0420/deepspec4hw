module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

  reg [2:0] state;
  reg [2:0] w_history;

  localparam A = 3'b000;
  localparam B = 3'b001;
  localparam C = 3'b010;
  localparam D = 3'b011;
  localparam E = 3'b100;

  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      z <= 0;
      w_history <= 0;
    end else begin
      case (state)
        A: begin
          z <= 0;
          if (s) begin
            state <= B;
            w_history <= {w_history[1:0], w};
          end else begin
            state <= A;
            w_history <= 0;
          end
        end
        B: begin
          state <= C;
          w_history <= {w_history[1:0], w};
          z <= 0;
        end
        C: begin
          state <= D;
          w_history <= {w_history[1:0], w};
          z <= 0;
        end
        D: begin
          state <= E;
          w_history <= {w_history[1:0], w};
          z <= 0;
        end
        E: begin
          state <= B;
          w_history <= {w_history[1:0], w};
          if ((w_history[2] & w_history[1] & ~w_history[0]) |
              (w_history[2] & ~w_history[1] & w_history[0]) |
              (~w_history[2] & w_history[1] & w_history[0])) begin
            z <= 1;
          end else begin
            z <= 0;
          end
        end
        default: begin
          state <= A;
          z <= 0;
          w_history <= 0;
        end
      endcase
    end
  end

endmodule