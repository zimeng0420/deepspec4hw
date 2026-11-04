module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q
);

  reg [511:0] next_q;

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      for (int i = 0; i < 512; i = i + 1) begin
        // Calculate the next state for each cell based on Rule 110
        case ({ (i == 0 ? 1'b0 : q[i-1]), q[i], (i == 511 ? 1'b0 : q[i+1]) })
          3'b111: next_q[i] = 1'b0;
          3'b110: next_q[i] = 1'b1;
          3'b101: next_q[i] = 1'b1;
          3'b100: next_q[i] = 1'b0;
          3'b011: next_q[i] = 1'b1;
          3'b010: next_q[i] = 1'b1;
          3'b001: next_q[i] = 1'b1;
          3'b000: next_q[i] = 1'b0;
          default: next_q[i] = 1'b0; // Handle any unexpected states.
        endcase
      end
      q <= next_q;
    end
  end

endmodule