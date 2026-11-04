module top_module (
    input clk,
    input x,
    output z
);
    reg q1, q2, q3;

    wire q1_n = ~q1;
    wire q2_n = ~q2;
    wire q3_n = ~q3;

    wire d1 = x ^ q1;
    wire d2 = x & q2_n;
    wire d3 = x | q3_n;

    always @(posedge clk) begin
        q1 <= d1;
        q2 <= d2;
        q3 <= d3;
    end

    assign z = ~(q1 ~^ q2 ~^ q3);

endmodule