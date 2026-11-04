module top_module (
    input clk,
    input x,
    output z
);

    reg q1, q2, q3; // D Flip-flop outputs

    // Combinational logic
    wire xor_out, and_out, or_out;
    assign xor_out = x ^ q1;
    assign and_out = x & ~q2;
    assign or_out = x | ~q3;

    // XNOR gate combining outputs of XOR, AND, OR
    assign z = ~(xor_out ^ and_out ^ or_out);
    
    // Sequential logic with D flip-flops
    always @(posedge clk) begin
        q1 <= xor_out; // Drive D flip-flop with XOR output
        q2 <= and_out; // Drive D flip-flop with AND output
        q3 <= or_out;  // Drive D flip-flop with OR output
    end

endmodule