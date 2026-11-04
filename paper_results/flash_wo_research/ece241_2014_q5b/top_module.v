module top_module (
    input clk,
    input areset,
    input x,
    output z
);

  // State encoding:
  // A: 2'b01
  // B: 2'b10

  reg state_A;
  reg state_B;

  // Output z is combinational
  assign z = (state_A & x) | (state_B & ~x);

  // State transition logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state_A <= 1'b1;
      state_B <= 1'b0;
    end else begin
      case ({state_A, state_B})
        2'b01: begin // State A
          if (x) begin
            state_A <= 1'b0;
            state_B <= 1'b1;
          end else begin
            state_A <= 1'b1;
            state_B <= 1'b0;
          end
        end
        2'b10: begin // State B
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

endmodule