module top_module (
    input clk,
    input areset,
    input x,
    output z
);

  reg state_A, state_B;
  wire z_out;

  // State encoding:
  // A: 2'b01
  // B: 2'b10

  // Next state logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state_A <= 1'b1;
      state_B <= 1'b0;
    end else begin
      if (state_A) begin
        if (x) begin
          state_A <= 1'b0;
          state_B <= 1'b1;
        end else begin
          state_A <= 1'b1;
          state_B <= 1'b0;
        end
      end else if (state_B) begin
        state_A <= 1'b0;
        state_B <= 1'b1;
      end
    end
  end

  // Output logic
  assign z_out = (state_A & x) | (state_B & ~x);
  assign z = z_out;

endmodule