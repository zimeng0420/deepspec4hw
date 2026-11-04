module top_module (
    input clk,
    input x,
    output z
);
    reg d_ff1, d_ff2, d_ff3;
    
    wire xor_out, and_out, or_out;
    wire d_ff1_next, d_ff2_next, d_ff3_next;

    assign xor_out = x ^ d_ff1;
    assign and_out = x & ~d_ff2;
    assign or_out = x | ~d_ff3;

    always @(posedge clk) begin
        d_ff1 <= xor_out;
        d_ff2 <= and_out;
        d_ff3 <= or_out;
    end

    assign z = d_ff1 ^ d_ff2 ^ d_ff3;

endmodule