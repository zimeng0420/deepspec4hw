module top_module (
    input clk,
    input areset,
    input x,
    output z
);

  reg state_A;
  reg state_B;

  // One-hot encoding: state_A = 1'b1 means state A is active, state_B = 1'b1 means state B is active.

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state_A <= 1'b1;
      state_B <= 1'b0;
    end else begin
      case ({state_A, state_B})
        2'b10: begin // State A
          if (x == 1'b0) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
          end else begin
            state_A <= 1'b0;
            state_B <= 1'b1;
          end
        end
        2'b01: begin // State B
          state_A <= 1'b0;
          state_B <= 1'b1;
        end
        default: begin // Should not happen, but handle for safety
          state_A <= 1'b1;
          state_B <= 1'b0;
        end
      endcase
    end
  end

  assign z = (state_A & x) | (state_B & ~x);

endmodule