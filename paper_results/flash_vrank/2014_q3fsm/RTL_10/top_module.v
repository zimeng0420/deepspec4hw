module top_module (
	input clk,
	input reset,
	input s,
	input w,
	output reg z
);

  reg [2:0] state;
  reg [1:0] w_count;

  localparam A = 3'b000;
  localparam B = 3'b001;
  localparam C = 3'b010;
  localparam D = 3'b011;
  localparam E = 3'b100;

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
          if (w) begin
            w_count <= w_count + 1;
          end
          state <= C;
          z <= 0;
        end
        C: begin
          if (w) begin
            w_count <= w_count + 1;
          end
          state <= D;
          z <= 0;
        end
        D: begin
          if (w) begin
            w_count <= w_count + 1;
          end

          if (w_count == 2) begin
            z <= 1;
          end else begin
            z <= 0;
          end
          state <= E;
        end
        E: begin
          state <= B;
          w_count <= 0;
          z <= 0; // Reset z here to avoid it being high longer than one cycle.
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