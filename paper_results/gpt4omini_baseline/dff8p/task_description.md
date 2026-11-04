# Task: dff8p

 # Description: Create 8 D flip-flops with active high synchronous reset. The flip-flops must be reset to 0x34 rather than zero. All DFFs should be triggered by the negative edge of clk.  # Header: module top_module(
	input clk,
	input [7:0] d,
	input reset,
	output reg [7:0] q);
  # Circuit Type: SEQ

