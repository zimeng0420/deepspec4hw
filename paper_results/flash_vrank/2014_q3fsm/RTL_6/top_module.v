module top_module (
	input clk,
	input reset,
	input s,
	input w,
	output reg z
);

  reg [3:0] state;
  reg [2:0] w_count;

  localparam A = 4'b0001;
  localparam B = 4'b0010;
  localparam C = 4'b0011;
  localparam D = 4'b0100;
  localparam E = 4'b0101;
  localparam F = 4'b0110;
  localparam G = 4'b0111;

  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      z <= 0;
      w_count <= 0;
    end else begin
      case (state)
        A: begin
          if (s) begin
            state <= B;
            z <= 0;
            w_count <= 0;
          end else begin
            state <= A;
            z <= 0;
            w_count <= 0;
          end
        end
        B: begin
          state <= C;
          w_count <= {w_count[1:0], w};
          z <= 0;
        end
        C: begin
          state <= D;
          w_count <= {w_count[1:0], w};
          z <= 0;
        end
        D: begin
          state <= E;
          w_count <= {w_count[1:0], w};
          z <= 0;
        end
        E: begin
          if ((w_count[0] + w_count[1] + w_count[2]) == 2) begin
            state <= F;
            z <= 0;
          end else begin
            state <= F;
            z <= 0;
          end
        end
        F: begin
            state <= G;
            z <= ((w_count[0] + w_count[1] + w_count[2]) == 2) ? 1 : 0;
        end
        G: begin
            state <= B;
            z <= 0;
        end
        default: begin
          state <= A;
          z <= 0;
          w_count <= 0;
        end
      endcase
    end
  end

endmodule