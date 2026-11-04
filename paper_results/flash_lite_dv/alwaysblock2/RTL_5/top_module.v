module top_module(
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Combinational logic using assign statement
    assign out_assign = a ^ b;

    // Combinational logic using always_comb block
    always_comb begin
        out_always_comb = a ^ b;
    end

    // Sequential logic using clocked always block
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule