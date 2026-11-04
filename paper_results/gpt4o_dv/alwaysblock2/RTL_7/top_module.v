module top_module(
	input clk,
	input a, 
	input b,
	output out_assign,
	output reg out_always_comb,
	output reg out_always_ff
);

    // Continuous assignment for XOR using assign statement
    assign out_assign = a ^ b;

    // Combinational always block for XOR logic
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Clocked always block for XOR logic with one cycle delay
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule