module top_module (
    input clk,
    input x,
    output z
);

    wire q1, q2, q3;
    wire d1, d2, d3;
    wire nq1, nq2, nq3;

    // XOR gate with flip-flop output
    assign d1 = x ^ q1;
    always @(posedge clk) begin
        q1 <= d1;
    end

    // AND gate with flip-flop complemented output
    assign nq2 = ~q2;
    assign d2 = x & nq2;
    always @(posedge clk) begin
        q2 <= d2;
    end

    // OR gate with flip-flop complemented output
    assign nq3 = ~q3;
    assign d3 = x | nq3;
    always @(posedge clk) begin
        q3 <= d3;
    end

    // Three-input XNOR gate
    assign z = ~(q1 ^ q2 ^ q3);

endmodule