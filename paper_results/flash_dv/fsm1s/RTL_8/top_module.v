module top_module (
    input clk,
    input in,
    input reset,
    output out
);

  reg state;
  parameter A = 1'b0;
  parameter B = 1'b1;

  assign out = state;

  always @(posedge clk) begin
    if (reset) begin
      state <= B;
    end else begin
      case (state)
        A: begin
          if (in == 0) begin
            state <= B;
          end else begin
            state <= A;
          end
        end
        B: begin
          if (in == 0) begin
            state <= A;
          end else begin
            state <= B;
          end
        end
        default: state <= B;
      endcase
    end
  end

endmodule