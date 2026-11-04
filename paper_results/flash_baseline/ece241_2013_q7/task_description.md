# Task: ece241_2013_q7

 # Description: A JK flip-flop has the below truth table. Note: Qold is the output of the flip-flop before the positive clock edge.
// J | K | Q
// 0 | 0 | Qold
// 0 | 1 | 0
// 1 | 0 | 1
// 1 | 1 | ~Qold  # Header: module top_module (
	input clk,
	input j,
	input k,
	output reg Q
);
  # Circuit Type: SEQ

