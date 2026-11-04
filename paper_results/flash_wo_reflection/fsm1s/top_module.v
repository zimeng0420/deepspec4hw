module top_module (
    input clk,
    input in,
    input reset,
    output out
);

  reg current_state;
  // State encoding: A = 0, B = 1

  always @(posedge clk) begin
    if (reset) begin
      current_state <= 1; // Reset to state B
    end else begin
      case (current_state)
        0: begin // State A
          if (in == 0) begin
            current_state <= 1; // Go to state B
          end else begin
            current_state <= 0; // Stay in state A
          end
        end
        1: begin // State B
          if (in == 0) begin
            current_state <= 0; // Go to state A
          end else begin
            current_state <= 1; // Stay in state B
          end
        end
        default: current_state <= 1; // Should not happen, but reset to B
      endcase
    end
  end

  assign out = current_state; // Output is the current state

endmodule