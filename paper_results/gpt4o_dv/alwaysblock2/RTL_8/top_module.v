module top_module(
	input clk,
	input a, 
	input b,
	output out_assign,
	output reg out_always_comb,
	output reg out_always_ff
);

    // Implement XOR using assign statement
    assign out_assign = a ^ b;

    // Implement XOR using combinational always block
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Implement XOR using clocked always block
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule