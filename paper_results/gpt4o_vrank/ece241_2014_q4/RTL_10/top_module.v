module top_module (
    input clk,
    input x,
    output z
);
    // Wires for D flip-flop outputs
    wire q1, q2, q3;
    
    // Wires for complementary outputs
    wire nq1, nq2, nq3;
    
    // XOR, AND, OR gates
    wire d1, d2, d3;
    
    assign d1 = x ^ q1;  // XOR with its flip-flop output
    assign d2 = x & nq2; // AND with complemented flip-flop output
    assign d3 = x | nq3; // OR with complemented flip-flop output
    
    // D flip-flops
    always @(posedge clk) begin
        q1 <= d1;
        q2 <= d2;
        q3 <= d3;
    end
    
    // Complementary outputs
    assign nq1 = ~q1;
    assign nq2 = ~q2;
    assign nq3 = ~q3;
    
    // 3-input XNOR gate
    assign z = ~(q1 ^ q2 ^ q3);
    
endmodule