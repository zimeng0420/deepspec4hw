module top_module(
    input clk,
    input a, 
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Using an assign statement for XOR
    assign out_assign = a ^ b;

    // Using a combinational always block for XOR
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Using a clocked always block with flip-flop for delayed XOR
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule