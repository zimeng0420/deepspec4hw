module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge);

  reg [7:0] in_prev;

  always @(posedge clk) begin
    in_prev <= in;
    anyedge <= {8{1'b0}}; // Default to 0

    for (int i = 0; i < 8; i++) begin
      if (!in_prev[i] && in[i]) begin
        anyedge[i] <= 1'b1;
      end
    end
  end

endmodule