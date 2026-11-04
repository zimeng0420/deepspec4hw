module top_module (
    input clk,
    input x,
    output reg z
);
    
    reg Q1, Q2, Q3;

    wire XOR_out, AND_out, OR_out;

    // Combinational logic
    assign XOR_out = x ^ Q1;
    assign AND_out = x & ~Q2;
    assign OR_out = x | ~Q3;
    
    always @(posedge clk) begin
        // Sequential logic: update D flip-flops
        Q1 <= XOR_out;
        Q2 <= AND_out;
        Q3 <= OR_out;
    end
    
    // Final XNOR output
    always @(*) begin
        z = ~(XOR_out ^ AND_out ^ OR_out);
    end

endmodule