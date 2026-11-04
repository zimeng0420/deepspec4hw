module top_module(
	input clk,
	input a,
	input b,
	output out_assign,
	output reg out_always_comb,
	output reg out_always_ff
);

    // 1. XOR using assign statement (combinational)
    assign out_assign = a ^ b;

    // 2. XOR using combinational always block (combinational)
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // 3. XOR using clocked always block (sequential, delayed)
    always @(posedge clk) begin
        out_always_ff <= a ^ b; // Non-blocking assignment for sequential logic
    end

endmodule