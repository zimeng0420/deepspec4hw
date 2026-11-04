module top_module (
    input clk,
    input in,
    input areset,
    output out
);

  reg state;

  // State encoding:
  // A = 0
  // B = 1

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 1; // Reset to state B
    end else begin
      case (state)
        0: begin // State A
          if (in) begin
            state <= 0; // A --1--> A
          end else begin
            state <= 1; // A --0--> B
          end
        end
        1: begin // State B
          if (in) begin
            state <= 1; // B --1--> B
          end else begin
            state <= 0; // B --0--> A
          end
        end
        default: state <= 1; // Should not happen, but reset to B
      endcase
    end
  end

  assign out = state;

endmodule