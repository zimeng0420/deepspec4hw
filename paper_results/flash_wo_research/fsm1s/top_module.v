module top_module (
    input clk,
    input in,
    input reset,
    output out
);

  reg state_q;

  // State encoding:
  // A: state_q = 0
  // B: state_q = 1

  always @(posedge clk) begin
    if (reset) begin
      state_q <= 1; // Reset to state B
    end else begin
      case (state_q)
        0: begin // State A
          if (in == 0) begin
            state_q <= 1; // A --in=0--> B
          end else begin
            state_q <= 0; // A --in=1--> A
          end
        end
        1: begin // State B
          if (in == 0) begin
            state_q <= 0; // B --in=0--> A
          end else begin
            state_q <= 1; // B --in=1--> B
          end
        end
        default: state_q <= 1; // Should not happen, but reset to B
      endcase
    end
  end

  assign out = state_q;

endmodule