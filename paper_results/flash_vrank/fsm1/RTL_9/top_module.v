module top_module (
	input clk,
	input in,
	input areset,
	output out
);

  reg state;
  parameter A = 0, B = 1;

  always @(posedge clk, posedge areset) begin
    if (areset) begin
      state <= B;
    end else begin
      case (state)
        A: begin
          if (in) begin
            state <= A;
          end else begin
            state <= B;
          end
        end
        B: begin
          if (in) begin
            state <= B;
          end else begin
            state <= A;
          end
        end
        default: state <= B; 
      endcase
    end
  end

  assign out = state;

endmodule