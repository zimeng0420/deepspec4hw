module top_module (
    input clk,
    input x,
    output reg z
);

    reg Q1, Q2, Q3;

    always @(posedge clk) begin
        Q1 <= x ^ Q1;
        Q2 <= x & ~Q2;
        Q3 <= x | ~Q3;
        
        // XNOR operation: z = ~(XOR_out ^ AND_out ^ OR_out)
        z <= ~((x ^ Q1) ^ (x & ~Q2) ^ (x | ~Q3));
    end

endmodule