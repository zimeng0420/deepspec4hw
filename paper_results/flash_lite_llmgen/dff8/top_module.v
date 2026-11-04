module top_module(
    input clk,
    input [7:0] d,
    input rst_n, // Optional: Active-low reset
    output reg [7:0] q
);

  // Internal wire for each DFF output (optional, but good practice)
  // wire [7:0] q_internal; // If using individual DFF modules

  // D Flip-Flop Implementation (Method 1: Using a for loop and a basic DFF module)
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Asynchronous reset
      q <= 8'b0; // Initialize to zero on reset
    end else begin
      q <= d; // Capture data on positive clock edge
    end
  end

endmodule