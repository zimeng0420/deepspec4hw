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
  reg [1:0] w_history; // Store last 2 w values

  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      z <= 0;
      w_history <= 2'b00;
    end else begin
      case (state)
        A: begin
          if (s) begin
            state <= B;
            z <= 0;
            w_history <= {w, w_history[1]};
          end else begin
            state <= A;
            z <= 0;
            w_history <= {w, w_history[1]};
          end
        end
        B: begin
          state <= C;
          z <= 0;
          w_history <= {w, w_history[1]};
        end
        C: begin
          state <= D;
          z <= 0;
          w_history <= {w, w_history[1]};
        end
        D: begin
          state <= B;
          // Check for exactly two 1s in the last three cycles
          if ((w & w_history[1] & ~w_history[0]) |
              (w & ~w_history[1] & w_history[0]) |
              (~w & w_history[1] & w_history[0])) begin
            z <= 1;
          } else begin
            z <= 0;
          end
          w_history <= {w, w_history[1]};
        end
        default: begin
          state <= A;
          z <= 0;
          w_history <= 2'b00;
        end
      endcase
    end
  end

endmodule