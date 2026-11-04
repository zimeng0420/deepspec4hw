module top_module (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

  // Combinational logic: 2:1 multiplexer to select the input to the flip-flop
  always @(*) begin
    if (L) begin
      Q = R; // Load R if L is asserted
    end else if (E) begin
      Q = w; // Shift w if E is asserted and L is not
    end else begin
      Q = Q; // Hold current value if neither L nor E is asserted
    end
  end

  // Sequential logic: D flip-flop
  always @(posedge clk) begin
    // Update Q on the rising edge of the clock
  end

endmodule