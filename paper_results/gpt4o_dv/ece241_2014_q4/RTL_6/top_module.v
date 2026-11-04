module top_module (
    input clk,
    input x,
    output reg z
);

    reg Q1, Q2, Q3;
    wire XOR_out, AND_out, OR_out;

    // Combinational logic for the gates
    assign XOR_out = x ^ Q1;
    assign AND_out = x & ~Q2;
    assign OR_out = x | ~Q3;
    
    // Sequential logic for the D flip-flops
    always @(posedge clk) begin
        Q1 <= XOR_out;
        Q2 <= AND_out;
        Q3 <= OR_out;
    end

    // Combinational logic for the XNOR gate
    always @(*) begin
        z = ~(XOR_out ^ AND_out ^ OR_out);
    end

endmodule