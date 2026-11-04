module top_module (
    input clk,
    input x,
    output reg z
);

    reg Q1, Q2, Q3;

    // Update D flip-flops on the positive edge of the clock
    always @(posedge clk) begin
        // D flip-flop Logic
        Q1 <= x ^ Q1;
        Q2 <= x & ~Q2;
        Q3 <= x | ~Q3;
    end

    // Combinational logic for XNOR gate
    always @(*) begin
        z = ~(Q1 ^ Q2 ^ Q3);
    end

endmodule