module top_module(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out);

  reg [31:0] prev_in;

  always @(posedge clk) begin
    if (reset) begin
      out <= 32'b0;
    end else begin
      for (int i = 0; i < 32; i++) begin
        if (prev_in[i] == 1 && in[i] == 0) begin
          out[i] <= 1'b1; // Capture the 1-to-0 transition
        end
      end
    end
    prev_in <= in; // Store the current input for the next clock cycle
  end

endmodule