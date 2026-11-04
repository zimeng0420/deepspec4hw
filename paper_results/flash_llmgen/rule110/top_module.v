module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q);

  reg [511:0] next_q;

  always @(*) begin
    // Calculate the next state of each cell based on Rule 110
    for (int i = 0; i < 512; i++) begin
      // Determine the left, center, and right cell states
      logic left   = (i == 0)   ? 0 : q[i-1];  // Boundary condition: q[-1] = 0
      logic center = q[i];
      logic right  = (i == 511) ? 0 : q[i+1]; // Boundary condition: q[512] = 0

      // Implement Rule 110 using a case statement or boolean logic
      case ({left, center, right})
        3'b111: next_q[i] = 0;
        3'b110: next_q[i] = 1;
        3'b101: next_q[i] = 1;
        3'b100: next_q[i] = 0;
        3'b011: next_q[i] = 1;
        3'b010: next_q[i] = 1;
        3'b001: next_q[i] = 1;
        3'b000: next_q[i] = 0;
        default: next_q[i] = 0; // Should never happen, but good practice
      endcase
    end
  end

  always @(posedge clk) begin
    if (load) begin
      q <= data; // Load the data input
    end else begin
      q <= next_q; // Update the cell states
    end
  end

endmodule