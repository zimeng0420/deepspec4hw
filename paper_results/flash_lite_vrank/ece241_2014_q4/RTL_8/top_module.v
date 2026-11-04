module top_module (
	input clk,
	input x,
	output z
);

    wire xor_out, and_out, or_out;
    wire q1_bar, q2_bar, q3_bar;

    reg q1, q2, q3;

    // XOR gate and D flip-flop
    always @(posedge clk) begin
        q1 <= x ^ q1;
    end

    // AND gate and D flip-flop
    always @(posedge clk) begin
        q2 <= x & q2_bar;
    end

    // OR gate and D flip-flop
    always @(posedge clk) begin
        q3 <= x | q3_bar;
    end
    
    assign q1_bar = ~q1;
    assign q2_bar = ~q2;
    assign q3_bar = ~q3;

    // Three-input XNOR gate
    assign z = ~(q1 ^ q2 ^ q3);

endmodule